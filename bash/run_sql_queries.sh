#!/bin/bash

DATABASE_HOST=2-nec-hob.emii.org.au
DATABASE_NAME=harvest
DATABASE_USERNAME=marvl3

# Run psql in front of the harvest database
# $1 - sql file to run
psql_marvl() {
	local sql_file=$1; shift
	cat $sql_file | psql -h $DATABASE_HOST -d $DATABASE_NAME -U $DATABASE_USERNAME
}

# create and populate the table source
SQL_FILES="$SQL_FILES ../sql_queries/CreatePopulate_SourceTable.sql"

# create and populate the table 500m_isobath
tmp_psql_500m_isobath=`mktemp`
echo "DROP TABLE IF EXISTS marvl3.\"500m_isobath\";" > $tmp_psql_500m_isobath
shp2pgsql -s 4326 ../500mIsobath_Shapefile/polygon_500m.sh marvl3."500m_isobath" >> $tmp_psql_500m_isobath
SQL_FILES="$SQL_FILES $tmp_psql_500m_isobath"

# create and populate the table australian_continent
tmp_psql_australian_continent=`mktemp`
echo "DROP TABLE IF EXISTS marvl3.\"australian_continent\";" > $tmp_psql_australian_continent
shp2pgsql -s 4326 ../AustralianContinent_Shapefile/australian_continent.sh marvl3."australian_continent" >> $tmp_psql_australian_continent
SQL_FILES="$SQL_FILES $tmp_psql_australian_continent"

# create the table spatial_subset
SQL_FILES="$SQL_FILES ../sql_queries/Create_SpatialSubsetTable.sql"

# create the function gsw_z_from_p
SQL_FILES="$SQL_FILES ../sql_queries/CreateSeaWaterFunctions.sql"

# populate the table spatial_subset
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_aatams_sattag_dm.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_ctd_profiles.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_aodn_nt_sattag_hawksbill.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_argo.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_wodb_xbt.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_wodb_ctd.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_wodb_uor.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_ts.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_meteo.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_bio.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_am_dm.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_burst_avg.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_dar_yon.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_faimms.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_srs_altimetry.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_csiro_cmar_mooring.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_wodb_sur.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_csiro_cmar_trajectory.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_csiro_cmar_underway.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_ran_sst.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_tmv.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_trv.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_co2.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_sst_dm.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_sst_nrt.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_soop_asf_mt.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_anfog_dm.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_aodn_dsto.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_aodn_aims_ctd.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_auv.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_SpatialSubsetTable_final.sql"

# create and populate the table bathy_atlas
SQL_FILES="$SQL_FILES ../sql_queries/Create_BathyAtlasTable.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_BathyAtlasTable.sql"

# create and populate the table data_atlas
SQL_FILES="$SQL_FILES ../sql_queries/Create_DataAtlasTable.sql"
SQL_FILES="$SQL_FILES ../sql_queries/Populate_DataAtlasTable.sql"

# delete rows in the table data_atlas that are deeper than the seafloor
SQL_FILES="$SQL_FILES ../sql_queries/DeleteFrom_DataAtlasTable.sql"

# run all files
for file in $SQL_FILES; do
	echo "Running sql in '$file'"
	psql_marvl $file
done

rm -f $tmp_psql_500m_isobath
rm -f $tmp_psql_australian_continent
