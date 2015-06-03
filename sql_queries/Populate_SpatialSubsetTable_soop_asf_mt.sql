SET SEARCH_PATH = marvl3, public;		
---SOOP_ASF_MT
\echo 'SOOP_ASF_MT'
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
d.cruise_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
d."TIME" AT TIME ZONE 'UTC',
'1',
0,
'1',
d."TEMP",
'0',
NULL,
NULL,
d.geom
FROM soop_asf_mt.soop_asf_mt_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'soop_asf_mt_trajectory_data'
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
AND d.vessel_name NOT IN ('Southern Surveyor'); --SouthernS excluded from here as data from this vessel will be extracted from CSIRO_underway
