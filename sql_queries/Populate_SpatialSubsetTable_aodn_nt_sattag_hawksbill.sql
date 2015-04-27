SET SEARCH_PATH = marvl3, public;

-- AODN NT SATTAG HAWKSBILL
\echo 'AODN NT SATTAG HAWKSBILL'
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
d.profile_id,
d.lon,
'0',
d.lat,
'0',
d.timestamp AT TIME ZONE 'UTC',
'0',
-gsw_z_from_p(d.pressure, d.lat),
'0',
d.temp_vals,
'0',
NULL,
NULL,
d.geom
FROM aodn_nt_sattag_hawksbill.aodn_nt_sattag_hawksbill_profile_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'aodn_nt_sattag_hawksbill_profile_data'
AND d.timestamp >= '1995-01-01'
AND d.timestamp < '2015-01-01';
