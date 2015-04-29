 SET SEARCH_PATH = marvl3, public;               
-- WODB SUR
\echo 'WODB SUR'
INSERT INTO marvl3.spatial_subset(
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
'0',
d.latitude,
'0',
d.time AT TIME ZONE 'UTC',
'0',
d.depth,
'0',
d.temperature,
'0',
d.salinity,
'0',
d.geom
FROM wodb.sur_measurements d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom,m.geom) 
AND s."SUBFACILITY" = 'SUR' 
AND s.schema_name = 'wodb'
AND d.time>= '1995-01-01'
AND d.time < '2015-01-01';