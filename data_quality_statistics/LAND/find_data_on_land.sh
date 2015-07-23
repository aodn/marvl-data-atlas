#!/bin/bash
# use ~/.pgpass for password access.
# renamed files with  rename   's/^Populate_SpatialSubsetTable_//' *
# please change output_dir variable. This is a basic script
# author besnard.laurent@utas.edu.au

function export_db_env(){
    db_dbname="harvest"
    db_user="marvl3"
    db_host="2-nec-hob.emii.org.au"
}

function export_local_env(){
    input_dir=$script_path'/sql_queries'
    output_dir=$HOME'/IMOS/marvl3_statistics/LAND/sql_output2'
    mkdir -p $output_dir
}

function run_query(){
    local sql_file=$1
    local sql_file_basename=$(basename "${sql_file}")

    local sql_output_file=${sql_file_basename}'_query_output.csv'
    local sql_query='psql  -d '$db_dbname' -U  '$db_user'  -h  '$db_host'  -a -f  '$sql_file

    eval $sql_query > $output_dir/$sql_output_file
}

function main(){
    script_path=$(readlink -f $0)
    script_path=$(dirname "${script_path}")
    export_db_env
    export_local_env

    for f in $input_dir/*.sql; do
        echo "Processing $f file"
        run_query $f
    done
}

main