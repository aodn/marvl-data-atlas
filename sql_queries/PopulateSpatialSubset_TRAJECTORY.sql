
SET SEARCH_PATH = marvl3, public;
	
----AUV
\echo 'AUV'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
)
SELECT 
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME",
d."DEPTH",
d."TEMP",
d."PSAL",
d.geom
FROM auv.auv_trajectory_st_data d,  "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name= 'auv_trajectory_st_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
	
---SOOP-CO2	
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
d."TIME",
d."TIME_quality_control",
0,
d."TEMP_1",
d."TEMP_1_quality_control",
d."PSAL",
d."PSAL_quality_control",
d.geom
FROM soop_co2.soop_co2_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom) 
AND s.table_name='soop_co2_trajectory_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
AND vessel_name IN('L''Astrolabe', 'Aurora Australis')	   

DELETE "TEMP" FROM marvl3.spatial_subset WHERE source_id=19 -- delete Temperature data from SOOP-CO2 will be extracted from other schemas
 	


---SOOP-TRV
\echo 'SOOP-TRV'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
) 
SELECT 
s.source_id,
d.trip_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME",
0,
d."Seawater_Intake_Temperature",
d."PSAL",
d.geom
FROM soop_trv.soop_trv_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, soop_trv.soop_trv_trajectory_data.geom) 
AND s.table_name='soop_trv_trajectory_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
 
	
---SOOP-SST DM	
\echo 'SOOP-SST DM'
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
"TEMP",
"TEMP_QC",
geom
)	
SELECT 
s.source_id,
d.trajectory_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
d."TIME",
d."TIME_quality_control",
0,
d."TEMP",
d."TEMP_quality_control",
d.geom
FROM  soop_sst.soop_sst_dm_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name='soop_sst_dm_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'	
	
---SOOP-SST NRT
\echo 'SOOP-SST NRT'
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
"TEMP",
"TEMP_QC",
geom
)
SELECT source_id,
d.trajectory_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
d."TIME",
d."TIME_quality_control",
0,
d."TEMP",
d."TEMP_quality_control",
d.geom
FROM soop_sst.soop_sst_nrt_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom) 
AND s.table_name='soop_sst_nrt_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
AND vessel_name NOT IN('Xutra Bhum', 'Wana Bhum','RV Cape Ferguson')	--'Xutra Bhum', 'Wana Bhum' inSOOP-SST DM; 'RV Cape Ferguson' in SOOP-TRV

DELETE from marvl3.spatial_subset m where 
m.pkid IN (select trajectory_id 
from soop_sst.soop_sst_nrt_trajectory_data d 
join marvl3.spatial_subset m on d.trajectory_id::character =m.origin_id
where vessel_name IN ('L''Astrolabe') AND d.TIME <'2013-04-15- 00:00:00'
) -- Astrolabe SOOP-SST-NRT data processed to DM product only up to Apr 2013  
---SOOP_TMV
\echo 'SOOP_TMV'	
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
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
d."TIME",
d."TIME_quality_control",
0,
d."TEMP_1",
d."TEMP_1_quality_control",
d."PSAL",
d."PSAL_quality_control",	
geom
FROM soop_tmv.soop_tmv_trajectory_data d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom, d.geom) 
AND s.table_name='soop_tmv_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
	
---SOOP_ASF_MT	
\echo 'SOOP_TMV'		
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
)	
SELECT 
s.source_id,
d.cruise_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME",
0,
d."TEMP",
d.geom
FROM soop_asf_mt.soop_asf_mt_trajectory_data d, "500m_isobath" p,source s 
WHERE ST_CONTAINS(p.geom, d.geom)
AND  s.table_name='soop_asf_mt_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'	
AND vessel_name NOT IN ('Southern Surveyor')		--SouthernS excluded from here as data from this vessel will be extracted from CSIRO_underway	

-- CSIRO TRAJECTORY
\echo 'CSIRO TRAJECTORY'				
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"TEMP_QC",
"PSAL",
"PSAL_QC",
geom
)
SELECT 
s.source_id,
d."SURVEY_ID",
d."LONGITUDE",
d."LATITUDE",
d."TIME" AT TIME ZONE 'UTC' AS TIME,
gsw_z_from_p(d."PRESSURE", d."LATITUDE")  -- looks like pressure is  PRES_REL , value close to 0dbar near surface
d."TEMPERATURE",
d."TEMPERATURE_QC",
d."SALINITY",
d."SALINITY_QC",
d.geom
FROM aodn_csiro_cmar.aodn_csiro_cmar_trajectory_data d, "500m_isobath" p, source s
WHERE ST_CONTAINS(p.geom, d.geom) 
AND  s.table_name='aodn_csiro_cmar_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01' 
	
	
-- CSIRO UNDERWAY
\echo 'CSIRO UNDERWAY'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"TEMP_QC",
"PSAL",
"PSAL_QC",
geom
)
SELECT 
s.source_id,
d."SURVEY_ID",
d."LONGITUDE",
d."LATITUDE",
d."TIME" AT TIME ZONE 'UTC' AS TIME,
0,
d."SEA_SURFACE_TEMP",
d."SEA_SURFACE_TEMP_QC" ,
d."SALINITY",
d."SALINITY_QC",
d.geom
FROM aodn_csiro_cmar.aodn_csiro_cmar_underway_data d, "500m_isobath" p, source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND  s.table_name='aodn_csiro_cmar_underway_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
	
		
-- WODB GLD
\echo 'WODB GLD'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
)
SELECT
s.source_id, 
d.cast_id,
d.longitude,
d.latitude,
d.time timestamp with time zone as time,
d.depth,
d.temperature,
d.salinity,
d.geom
FROM wodb.gld_deployments d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom,m.geom) 
AND s."SUBFACILITY" = 'GLD' 
AND s.schema_name = 'wodb'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'

                
-- WODB SUR
\echo 'WODB SUR'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
)
SELECT 
s.source_id,
d.cast_id,
d.longitude,
d.latitude,
d.time timestamp with time zone as time,
d.depth,
d.temperature,
d.salinity,
d.geom
FROM wodb.sur_measurement d, "500m_isobath" p,source s
WHERE ST_CONTAINS(p.geom,m.geom) 
AND s."SUBFACILITY" = 'SUR' 
AND s.schema_name = 'wodb'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'

-- WODB UOR
\echo 'WODB UOR'
INSERT INTO marvl3.spatial_subset(
source_id,
origin_id,
"LONGITUDE",
"LATITUDE",
"TIME",
"DEPTH",
"TEMP",
"PSAL",
geom
)
SELECT 
s.source_id,
m."CAST_ID",
m."LONGITUDE",
m."LATITUDE",
m."TIME",
d.depth,
d.temperature,
d.salinity,
d.geom
FROM wodb.sur_deployments m, "500m_isobath" p,source s
INNER JOIN wodb.sur_deployments d,
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom,m.geom) 
AND s."SUBFACILITY" = 'UOR' 
AND s.schema_name = 'wodb'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'