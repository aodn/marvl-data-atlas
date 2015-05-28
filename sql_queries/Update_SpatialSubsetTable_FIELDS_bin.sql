SET SEARCH_PATH = marvl3, public;

-- Update FIELDS_bin in spatial_subset
\echo 'Update FIELDS_bin in spatial_subset'

UPDATE marvl3.spatial_subset
SET "LONGITUDE_bin" = (width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111, -- we consider LONGITUDE buckets of size 0.25 with first value centred on 111 : [110.875;111.125[, [111.125;111.375[, [111.375;111.625[, [111.625;111.875[, etc...
"LATITUDE_bin" = (width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3, -- we consider LATITUDE buckets of size 0.25 with first value centred on -3 : [-2.875;-3.125[, [-3.125;-3.375[, etc...
"TIME_bin" = date_trunc('month', "TIME" AT TIME ZONE 'UTC') + interval '14 days', -- we consider TIME buckets monthly with first value centred on 2007-01-15 : [2007-01-01;2007-01-31[, [2007-02-01;2007-02-28[, etc...
"DEPTH_bin" = (width_bucket(CASE WHEN "DEPTH_QC" IN ('0', '1', '2') THEN "DEPTH" ELSE "NOMINAL_DEPTH" END, -5, 505, 51)-1)*10, -- we consider DEPTH buckets of size 10 with first value centred on 0 : [-5;5[, [5;15[, etc... If field DEPTH is NULL, NOMINAL_DEPTH is considered.
geom_bin = ST_GeometryFromText(COALESCE('POLYGON(('||(width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket("LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket("LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||'))'), '4326')
