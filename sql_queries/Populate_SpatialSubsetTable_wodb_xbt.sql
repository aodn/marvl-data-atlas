SET SEARCH_PATH = marvl3, public;

-- WODB XBT
\echo 'WODB XBT'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"DEPTH",
"DEPTH_QC",
"TEMP",
"TEMP_QC",
"PSAL",
"PSAL_QC",
geom
)
SELECT
s.source_id,
m."CAST_ID",
m."LONGITUDE",
'1',
m."LATITUDE",
'1',
m."TIME",
'1',
d.depth,
'1',
d.temperature,
'1',
NULL,
NULL,
m.geom
FROM marvl3."500m_isobath" p, marvl3.source s, wodb.xbt_deployments m
INNER JOIN wodb.xbt_measurements d
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom, m.geom)
AND s."SUBFACILITY" = 'XBT'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';
