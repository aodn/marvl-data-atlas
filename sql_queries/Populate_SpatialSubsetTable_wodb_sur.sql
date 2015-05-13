 SET SEARCH_PATH = marvl3, public;               
-- WODB SUR
\echo 'WODB SUR'
INSERT INTO spatial_subset(
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
d.cast_id,
d.longitude,
'1',
d.latitude,
'1',
d.time AT TIME ZONE 'UTC',
'1',
d.depth,
'1',
CASE WHEN d.temperature = 999999 THEN NULL ELSE d.temperature END,
CASE WHEN d.temperature = 999999 THEN '9' ELSE '1' END,
CASE WHEN d.salinity = 999999 THEN NULL ELSE d.salinity END,
CASE WHEN d.salinity = 999999 THEN '9' ELSE '1' END,
d.geom
FROM wodb.sur_measurements d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s."SUBFACILITY" = 'SUR' 
AND s.schema_name = 'wodb'
AND d.time>= '1995-01-01'
AND d.time < '2015-01-01';
