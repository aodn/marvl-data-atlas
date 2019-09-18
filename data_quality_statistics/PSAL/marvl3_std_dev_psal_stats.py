#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Created on Thu Jun 25 11:11:21 2015

@author: lbesnard
"""
# script to look for std psal > std_dev (4 by default) and retrieve the source data. The source data is copied into a 'bin' directory
# use pgpass. The password must be defined in ~/.pgpass

import psycopg2
import datetime
import numpy as np
import os
import calendar
from six.moves import map

# create a postgresql connection, need .pgpass file in $HOME (not checked)
def connect(db_dbname,db_user,db_host):
    try:
        conn = psycopg2.connect("dbname="+ db_dbname+ " user=" + db_user +" host=" + db_host)
    except:
        print("unable to connect to the database")

    cur = conn.cursor()
    return cur

# find rows in marvl3.data_atlas WHERE std dev of PSAL is greater than std_dev defined above
def get_psal_stddev(cur,std_dev):
    sql_query_find_psal_std = """SELECT "LONGITUDE_bin","LATITUDE_bin","TIME_bin","DEPTH_bin","PSAL_stddev" FROM marvl3.data_atlas WHERE "PSAL_stddev">"""+ str(std_dev) +""" ORDER BY  "PSAL_stddev" DESC"""
    cur.execute(sql_query_find_psal_std)

    rows = cur.fetchall()
    return rows

# get for a specific row/bin the origin id and source_id of the data
def get_data_row_source_and_origin_id(cur,lon_bin,lat_bin,time_bin,depth_bin):
    sql_query_find_source_org = """SELECT DISTINCT origin_id, source_id FROM marvl3.spatial_subset WHERE "LONGITUDE_bin" = """ + \
                            str(lon_bin) +""" AND "LATITUDE_bin" = """ + str(lat_bin) +\
                            """ AND "DEPTH_bin" = """ + str(depth_bin) + """ AND "TIME_bin" = '"""+ time_bin.strftime('%Y-%m-%d') +"""'""" +\
                            """ AND "PSAL" IS NOT NULL"""

    cur.execute(sql_query_find_source_org)

    rows_source_org = cur.fetchall()

    # add all different origin/sources to list and make sure they are all int
    origin_id = []
    source_id = []

    for row in rows_source_org:
        origin_id.append( row[0] )
        source_id.append ( row[1] )

    return origin_id, source_id

# retrieve the data_provider, origin schema and table name of a source_id by looking at the source table
def get_data_provider(cur,source_id):
    sql_query_find_data_provider = """SELECT schema_name, table_name, ref_column, "ORGANISATION" FROM marvl3.source WHERE source_id =""" + str(source_id) + ";"
    cur.execute(sql_query_find_data_provider)

    rows_data_provider              = cur.fetchall()
    schema_name_data_provider       = rows_data_provider[0][0]
    table_name_data_provider        = rows_data_provider[0][1]
    ref_column_name_data_provider   = rows_data_provider[0][2]
    organisation_name_data_provider = rows_data_provider[0][3]

    return schema_name_data_provider,table_name_data_provider,table_name_data_provider,ref_column_name_data_provider,organisation_name_data_provider

# get the column names of a postgresql table
def get_table_header(cur,schema_name_data_provider,table_name_data_provider):
    sql_query = "SELECT * FROM " + schema_name_data_provider+ "." + table_name_data_provider+ " LIMIT 0"
    cur.execute(sql_query)

    colnames = [desc[0] for desc in cur.description]
    colnames = ','.join(map(str, colnames))

    return colnames

# add months to a python date. Function used to create the TIME_bin range to create sql filters on origin data
def add_months(sourcedate,months):
    month = sourcedate.month - 1 + months
    year  = sourcedate.year + month / 12
    month = month % 12 + 1
    day   = min(sourcedate.day,calendar.monthrange(year,month)[1])

    return datetime.date(year,month,day)

# check if a column exist in a table
def check_column_exist_in_table(cur,schema_name,table_name,column_name):
    sql_query = "SELECT column_name FROM information_schema.columns WHERE table_name='" +  table_name + "' and table_schema='"+  schema_name+ "' and column_name='" + column_name +"';"
    cur.execute(sql_query)
    rows_column          = cur.fetchall()
    column_exist_boolean = not (not rows_column )# true exist, false not exist

    return column_exist_boolean

# get the origin data values of a bin
def get_source_data_values(cur,organisation_name_data_provider,schema_name_data_provider,table_name_data_provider,ref_column_name_data_provider,origin_id,time_bin,depth_bin,lon_bin,lat_bin):

    sql_check_DEPTH_exist    = check_column_exist_in_table (cur,schema_name_data_provider,table_name_data_provider,'DEPTH')
    sql_check_TIME_exist     = check_column_exist_in_table (cur,schema_name_data_provider,table_name_data_provider,'TIME')
    sql_check_time_exist     = check_column_exist_in_table (cur,schema_name_data_provider,table_name_data_provider,'time')
    sql_check_LATITUDE_exist = check_column_exist_in_table (cur,schema_name_data_provider,table_name_data_provider,'LATITUDE')

    main_query    = """SELECT * FROM """ + schema_name_data_provider + "." + table_name_data_provider +\
                        " WHERE " + ref_column_name_data_provider +" LIKE '"+ str(origin_id) + "'"

    # start and end of the month
    TIME_query    = """ AND "TIME" >= '""" + time_bin.strftime('%Y-%m-01') +"""'""" +\
                                    """ AND "TIME" < '""" + add_months(time_bin,1).strftime('%Y-%m-01') +"""'"""

    time_query    = """ AND "time" >= '""" + time_bin.strftime('%Y-%m-01') +"""'""" +\
                                    """ AND "time" < '""" + add_months(time_bin,1).strftime('%Y-%m-01') +"""'"""

    # bin defined by center of bin +- 0.125 in lat lon
    bin_lat_lon_size = 0.125
    lat_lon_query = """ AND "LATITUDE" >= """ + str(lat_bin- bin_lat_lon_size) +\
                        """ AND "LATITUDE" <= """ + str(lat_bin + bin_lat_lon_size)  +\
                        """ AND "LONGITUDE" >= """ + str(lon_bin - bin_lat_lon_size) +\
                        """ AND "LONGITUDE" <= """ + str(lon_bin + bin_lat_lon_size)

    # bin defined by center of bin +- 5 in depth
    bin_depth_size = 5
    depth_query   = """ AND "DEPTH" >= """ + str(depth_bin - bin_depth_size) +\
                        """ AND "DEPTH" <= """ + str(depth_bin + bin_depth_size)

    if  sql_check_TIME_exist & sql_check_LATITUDE_exist & sql_check_DEPTH_exist:
        sql_query = main_query + TIME_query + lat_lon_query + depth_query

    elif  (sql_check_TIME_exist & sql_check_LATITUDE_exist) & (not sql_check_DEPTH_exist):
        sql_query = main_query + TIME_query + lat_lon_query

    elif (sql_check_TIME_exist) & (not sql_check_LATITUDE_exist) & (not sql_check_DEPTH_exist):
        sql_query = main_query + TIME_query

    elif sql_check_time_exist:
        sql_query = main_query + time_query

    else:
        sql_query = main_query

    try:
        cur.execute(sql_query)
    except:
        # sometimes origin_id can be a string or a number.
        # Instead of looking for the data type from information_schema.columns
        # , which could be real/,char, varchar... just replace LIKE with = in query
        postgres_rollback_error(cur)
        sql_query = sql_query.replace('LIKE', '=')
        cur.execute(sql_query)

    rows_original_data = cur.fetchall()

    return rows_original_data


# this function has to run after a sql query failed (for example after a try catch)
def postgres_rollback_error(cur):
    cur.execute("""rollback""")

# save the original data into a csv file
def save_to_file_source_data(colnames,rows_original_data,folder_path,schema_name_data_provider,table_name_data_provider,lon_bin,lat_bin,time_bin,depth_bin,origin):
    bin_name    = str(lon_bin) + "_" + str(lat_bin)  + "_" + str(time_bin.strftime('%Y-%m-01')) + "_" + str(depth_bin) +  "_stddev=" + str(std_dev_bin)
    folder_path = folder_path + os.path.sep + bin_name
    filepath    = folder_path + os.path.sep + schema_name_data_provider + "." + table_name_data_provider + "_"  + str(origin) + ".csv"


    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    # save header
    f = open(filepath,'w')
    f.write( colnames)
    f.write( '\n')
    f.close()

    # append data
    f_handle = open(filepath, 'a')
    np.savetxt(f_handle, rows_original_data, delimiter=",", fmt='%s')
    f_handle.close()

    return filepath

def save_sql_query_psal_csv(folder_path,psal_stddev):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    # save header to file
    f = open(folder_path + os.path.sep + 'rows.csv','w')
    f.write( 'LON_bin,LAT_bin,TIME_bin,DEPTH_bin,PSAL_STDDEV\n')
    f.close()

    # save data
    f_handle = open(folder_path + os.path.sep + 'rows.csv', 'a')
    np.savetxt(f_handle, psal_stddev,delimiter=",", fmt='%s')
    f_handle.close()

def main():
    cur           = connect(db_dbname,db_user,db_host)
    psal_stddev_4 = get_psal_stddev(cur,std_dev)
    save_sql_query_psal_csv(folder_path,psal_stddev_4)
    global std_dev_bin

    i_row = 0
    for row in psal_stddev_4:
        print("process row " + str(i_row))
        lon_bin       = row[0]
        lat_bin       = row[1]
        time_bin      = row[2]
        depth_bin     = row[3]
        std_dev_bin   = row[4]

        [origin_id, source_id]  =  get_data_row_source_and_origin_id(cur,lon_bin,lat_bin,time_bin,depth_bin)

        # can be more than one source per bin. But the same source can have more than one origin id
        j_source    = 0
        for source in source_id:
            [schema_name_data_provider,\
              table_name_data_provider,\
              table_name_data_provider,\
              ref_column_name_data_provider,\
              organisation_name_data_provider] = get_data_provider(cur,source)

            origin = origin_id[j_source]


            rows_original_data   = get_source_data_values(cur,organisation_name_data_provider,schema_name_data_provider,table_name_data_provider,ref_column_name_data_provider,origin,time_bin,depth_bin,lon_bin,lat_bin)
            colnames             = get_table_header(cur,schema_name_data_provider,table_name_data_provider)
            filepath             = save_to_file_source_data(colnames,rows_original_data,folder_path,schema_name_data_provider,table_name_data_provider,lon_bin,lat_bin,time_bin,depth_bin,origin)

            j_source += 1

        i_row += 1



db_dbname   = 'harvest'
db_user     = 'marvl3'
db_host     = '2-nec-hob.emii.org.au'
std_dev     = 4
folder_path = os.getenv("HOME") + os.path.sep  +'IMOS/marvl3_statistics/PSAL'

main()




