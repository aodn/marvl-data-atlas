SET SEARCH_PATH = marvl3, public;

-- data_atlas
\echo 'data_atlas'
INSERT INTO data_atlas (
"LONGITUDE",
"LONGITUDE_bound_min",
"LONGITUDE_bound_max",
"LATITUDE",
"LATITUDE_bound_min",
"LATITUDE_bound_max",
"TIME",
"TIME_bound_min",
"TIME_bound_max",
"DEPTH",
"DEPTH_bound_min",
"DEPTH_bound_max",
"TEMP_n",
"TEMP_min",
"TEMP_max",
"TEMP_mean",
"TEMP_stddev",
"PSAL_n",
"PSAL_min",
"PSAL_max",
"PSAL_mean",
"PSAL_stddev",
geom
)
SELECT
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111 AS "LONGITUDE", -- we consider LONGITUDE buckets of size 0.25 with first value centred on 111 : [110.875;111.125[, [111.125;111.375[, [111.375;111.625[, [111.625;111.875[, etc...
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875 AS "LONGITUDE_bound_min",
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125 AS "LONGITUDE_bound_max",
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3 AS "LATITUDE", -- we consider LATITUDE buckets of size 0.25 with first value centred on -3 : [-2.875;-3.125[, [-3.125;-3.375[, etc...
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125 AS "LATITUDE_bound_min",
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875 AS "LATITUDE_bound_max",
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') + interval '15 days' AS "TIME", -- we consider TIME buckets quarterly with first value centred on 2007-02-16 : [2007-01-01;2007-04-01[, [2007-04-01;2007-07-01[, etc...
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') AS "TIME_bound_min",
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') + interval '1 mons' AS "TIME_bound_max",
(width_bucket(CASE WHEN "DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10 AS "DEPTH", -- we consider DEPTH buckets of size 10 with first value centred on 0 : [-5;5[, [5;15[, etc... If field DEPTH is NULL, NOMINAL_DEPTH is considered.
(width_bucket(CASE WHEN "DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10-5 AS "DEPTH_bound_min",
(width_bucket(CASE WHEN "DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10+5 AS "DEPTH_bound_max",
count(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_n", -- measurements with QC flags no good are not considered
min(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_min",
max(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_max",
avg(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_mean",
stddev(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_stddev",
count(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_n", -- checking for TEMP_QC is part of the salinity QC test (if TEMP is not good then PSAL must be not good)
min(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_min",
max(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_max",
avg(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_mean",
stddev(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_stddev",
ST_GeometryFromText(COALESCE('POLYGON(('||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||'))'), '4326')
FROM marvl3.spatial_subset s
WHERE "LONGITUDE_QC" IN ('0', '1', '2') -- measurements with time and space location QC flags no good are not considered
AND "LATITUDE_QC" IN ('0', '1', '2')
AND "TIME_QC" IN ('0', '1', '2')
AND (
"NOMINAL_DEPTH_QC" IN ('0', '1', '2')
OR "DEPTH_QC" IN ('0', '1', '2')
)
AND s."TIME" BETWEEN '1995-01-01' AND now() -- impossible time QC test
AND s."LONGITUDE" BETWEEN 111 AND 155 -- impossible location QC test
AND s."LATITUDE" BETWEEN -45 AND -3
AND s."DEPTH" BETWEEN -5 AND 500
GROUP BY width_bucket(s."LONGITUDE", 110.875, 155.125, 177), -- elements in same temporal and spatial buckets are grouped
width_bucket(s."LATITUDE", -2.875, -45.125, 169),
date_trunc('month', s."TIME" AT TIME ZONE 'UTC'),
width_bucket(CASE WHEN "DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51);