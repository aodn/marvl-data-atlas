SET SEARCH_PATH = marvl3, public;
	
----AUV
\echo 'AUV'
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
d.file_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
d."TIME" AT TIME ZONE 'UTC',
'1',
d."DEPTH",
'0',
d."TEMP",
'0',
d."PSAL",
'0',
d.geom
FROM auv.auv_trajectory_st_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'auv_trajectory_st_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01';
