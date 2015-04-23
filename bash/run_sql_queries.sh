#!/bin/bash

# need to create a role marvl3 and then a schema marvl3 in the harvest database

# create and populate the table source
cat ../sql_queries/CreatePopulate_SourceTable.sql | psql -h po.aodn.org.au -d harvest -U admin
# create and populate the table 500m_isobath
shp2pgsql -s 4326 ../500mIsobath_Shapefile/polygon_500m.sh marvl3."500m_isobath" | psql -h po.aodn.org.au -d harvest -U admin
# create the table spatial_subset
cat ../sql_queries/Create_SpatialSubsetTable.sql | psql -h po.aodn.org.au -d harvest -U admin
# create the function gsw_z_from_p
cat ../sql_queries/CreateSeaWaterFunctions.sql | psql -h po.aodn.org.au -d harvest -U admin
# populate the table spatial_subset
cat ../sql_queries/Populate_SpatialSubsetTable.sql | psql -h po.aodn.org.au -d harvest -U admin
