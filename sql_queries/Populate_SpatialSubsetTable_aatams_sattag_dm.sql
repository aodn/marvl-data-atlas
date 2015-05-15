SET SEARCH_PATH = marvl3, public;

-- AATAMS SATTAG DM
\echo 'AATAMS SATTAG DM'
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
d.sal_corrected_vals,
'0',
d.geom
FROM aatams_sattag_dm.aatams_sattag_dm_profile_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'aatams_sattag_dm_profile_data'
AND d.timestamp >= '1995-01-01'
AND d.timestamp < '2015-01-01'
-- Exclude devices that have been recovered
AND d.device_id NOT IN (
'ct106-796-13',
'ct31-441-07',
'ct31-448B-07',
'ct61-01-09',
'ct76-364-11',
'ft13-073_3-13',
'ft13-616-12',
'ft13-628-12',
'ft13-633-12'
);