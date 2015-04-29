#!/bin/bash

# create and populate the table source
cat ../sql_queries/CreatePopulate_SourceTable.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# create and populate the table 500m_isobath
echo "DROP TABLE IF EXISTS marvl3.\"500m_isobath\";" | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
shp2pgsql -s 4326 ../500mIsobath_Shapefile/polygon_500m.sh marvl3."500m_isobath" | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# create the table spatial_subset
cat ../sql_queries/Create_SpatialSubsetTable.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# create the function gsw_z_from_p
cat ../sql_queries/CreateSeaWaterFunctions.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# populate the table spatial_subset
cat ../sql_queries/Populate_SpatialSubsetTable_aatams_sattag_dm.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_ctd_profiles.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_aodn_nt_sattag_hawksbill.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_argo.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_xbt.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_ctd.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_uor.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_ts.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_meteo.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_bio.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_am_dm.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_burst_avg.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_dar_yon.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_faimms.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_srs_altimetry.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_csiro_cmar_mooring.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_ran_sst.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_soop_tmv.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_soop_trv.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_anfog_dm.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
cat ../sql_queries/Populate_SpatialSubsetTable_aodn_dsto.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# create the table data_atlas
cat ../sql_queries/Create_DataAtlasTable.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3

# populate the table data_atlas
cat ../sql_queries/Populate_DataAtlasTable.sql | psql -h 2-nec-hob.emii.org.au -d harvest -U marvl3
