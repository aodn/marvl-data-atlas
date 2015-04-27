SET SEARCH_PATH = marvl3, public;

-- ANMN NRS CTD PROFILES
\echo 'ANMN NRS CTD PROFILES'
INSERT INTO spatial_subset (
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
d."TIME" AT TIME ZONE 'UTC',
d."TIME_quality_control",
d."DEPTH",
d."DEPTH_quality_control",
d."TEMP",
d."TEMP_quality_control",
d."PSAL",
d."PSAL_quality_control",
d.geom
FROM anmn_nrs_ctd_profiles.anmn_nrs_ctd_profiles_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_ctd_profiles_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01';
