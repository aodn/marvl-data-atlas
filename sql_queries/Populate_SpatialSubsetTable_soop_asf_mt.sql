SET SEARCH_PATH = marvl3, public;		
---SOOP_ASF_MT	
\echo 'SOOP_ASF_MT'		
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
d.cruise_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
d."TIME" AT TIME ZONE 'UTC' AS TIME,
'1',
'0',
'1',
d."TEMP",
'0',
NULL,
NULL,
d.geom
FROM soop_asf_mt.soop_asf_mt_trajectory_data d, "500m_isobath" p,source s 
WHERE ST_CONTAINS(p.geom, d.geom)
AND  s.table_name='soop_asf_mt_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'	
AND vessel_name NOT IN ('Southern Surveyor')		--SouthernS excluded from here as data from this vessel will be extracted from CSIRO_underway