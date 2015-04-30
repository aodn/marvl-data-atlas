SET SEARCH_PATH = marvl3, public;	
---SOOP-SST DM	
\echo 'SOOP-SST DM'
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
d.trajectory_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
d."TIME" AT TIME ZONE 'UTC',
d."TIME_quality_control",
0,
'1',
d."TEMP",
d."TEMP_quality_control",
NULL,
NULL,
d.geom
FROM  soop_sst.soop_sst_dm_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'soop_sst_dm_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01';
