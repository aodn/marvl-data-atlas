SET SEARCH_PATH = marvl3, public;
-- CSIRO TRAJECTORY
\echo 'CSIRO TRAJECTORY'				
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
d."SURVEY_ID",
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
d."TIME" AT TIME ZONE 'UTC',
'1',
-gsw_z_from_p(d."PRESSURE", d."LATITUDE")  -- looks like pressure is  PRES_REL , value close to 0dbar near surface
'0',
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