SET SEARCH_PATH = marvl3, public;
---SOOP-CO2	
-- Temperature data from SOOP-CO2 not used. TEMP will be extracted from other schemas
\echo 'SOOP-CO2'
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
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
d."TIME" AT TIME ZONE 'UTC' AS TIME,
d."TIME_quality_control",
'0',
'1',
NULL,
NULL,
d."PSAL",
d."PSAL_quality_control",
d.geom
FROM soop_co2.soop_co2_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom) 
AND s.table_name='soop_co2_trajectory_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
AND vessel_name IN('L''Astrolabe', 'Aurora Australis')	   

 
