#!/bin/bash

# need to create a role marvl3 and then a schema marvl3 in the harvest database

# create and populate the table source
cat ../sql_queries/CreatePopulate_SourceTable.sql | psql -h po.aodn.org.au -d harvest -U admin

# create and populate the table 500m_isobath
echo "DROP TABLE IF EXISTS marvl3.\"500m_isobath\";" | psql -h po.aodn.org.au -d harvest -U admin
shp2pgsql -s 4326 ../500mIsobath_Shapefile/polygon_500m.sh marvl3."500m_isobath" | psql -h po.aodn.org.au -d harvest -U admin

# create the table spatial_subset
cat ../sql_queries/Create_SpatialSubsetTable.sql | psql -h po.aodn.org.au -d harvest -U admin

# create the function gsw_z_from_p
cat ../sql_queries/CreateSeaWaterFunctions.sql | psql -h po.aodn.org.au -d harvest -U admin

# populate the table spatial_subset
cat ../sql_queries/Populate_SpatialSubsetTable_aatams_sattag_dm.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_ctd_profiles.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_aodn_nt_sattag_hawksbill.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_argo.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_xbt.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_ctd.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_wodb_uor.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_ts.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_meteo.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_rt_bio.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_am_dm.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_burst_avg.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anmn_nrs_dar_yon.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_faimms.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_srs_altimetry.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_csiro_cmar_mooring.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_ran_sst.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_soop_tmv.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_soop_trv.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_anfog_dm.sql | psql -h po.aodn.org.au -d harvest -U admin
cat ../sql_queries/Populate_SpatialSubsetTable_aodn_dsto.sql | psql -h po.aodn.org.au -d harvest -U admin
