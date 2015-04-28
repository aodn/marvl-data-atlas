SET SEARCH_PATH = marvl3, public;
-- CSIRO UNDERWAY
\echo 'CSIRO UNDERWAY'
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
'0',
d."LATITUDE",
'0',
d."TIME" AT TIME ZONE 'UTC' AS TIME,
'0',
'0',
'0',
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
	
		