SET SEARCH_PATH = marvl3, public;
 
-- TRUNCATE spatial_subset CASCADE;
-- ALTER SEQUENCE spatial_subset_pkid_seq RESTART;
-- ALTER SEQUENCE duplicate_seq RESTART;
	
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
FROM aatams_sattag_dm.aatams_sattag_dm_profile_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
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

-- Argo
\echo 'Argo'
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
COALESCE(d.platform_number||'+'||d.cycle_number),	-- see ref_column in CreatPopulate_SourceTable.sql
d.longitude,
d.position_qc,
d.latitude,
d.position_qc,
d.juld,
d.juld_qc,
-gsw_z_from_p(d.pres_adjusted, d.latitude),
d.pres_adjusted_qc,
d.temp_adjusted,
d.temp_adjusted_qc,
d.psal_adjusted,
d.psal_adjusted_qc,
d."position"
FROM argo.profile_download d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d."position")
AND s.table_name = 'profile_download'
AND d.juld >= '1995-01-01'
AND d.juld < '2015-01-01';

-- WODB XBT
\echo 'WODB XBT'
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
m."CAST_ID",
m."LONGITUDE",
'1',
m."LATITUDE",
'1',
m."TIME",
'1',
d.depth,
'1',
d.temperature,
'1',
NULL,
NULL,
m.geom
FROM wodb.xbt_deployments m, marvl3."500m_isobath" p, marvl3.source s
INNER JOIN wodb.xbt_measurements d,
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom, m.geom)
AND s."SUBFACILITY" = 'XBT'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';

-- WODB CTD
\echo 'WODB CTD'
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
m."CAST_ID",
m."LONGITUDE",
'1',
m."LATITUDE",
'1',
m."TIME",
'1',
d.depth,
'1',
d.temperature,
'1',
d.salinity,
'1',
m.geom
FROM wodb.ctd_deployments m, marvl3."500m_isobath" p, marvl3.source s
INNER JOIN wodb.ctd_measurements d 
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom, m.geom)
AND s."SUBFACILITY" = 'CTD'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';

-- WODB UOR
\echo 'WODB UOR'
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
m."CAST_ID",
m."LONGITUDE",
'1',
m."LATITUDE",
'1',
m."TIME",
'1',
d.depth,
'1',
d.temperature,
'1',
d.salinity,
'1',
m.geom
FROM wodb.uor_deployments m, marvl3."500m_isobath" p, source s
INNER JOIN wodb.uor_measurements d
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom, m.geom)
AND s."SUBFACILITY" = 'UOR'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';

-- ANMN_TS timeSeries
\echo 'ANMN_TS timeSeries'
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
d.timeseries_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
max(d."TIME_quality_control"),
avg(d."DEPTH"),
max(d."DEPTH_quality_control"),
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM anmn_ts.anmn_ts_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_ts_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.timeseries_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_NRS_RT_METEO timeSeries
\echo 'ANMN_NRS_RT_METEO timeSeries'
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
d.timeseries_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
0,
'1',
avg(d."SSTI"),
max(d."SSTI_quality_control"),
NULL,
NULL,
d.geom
FROM anmn_nrs_rt_meteo.anmn_nrs_rt_meteo_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_rt_meteo_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.timeseries_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_NRS_RT_BIO timeSeries
\echo 'ANMN_NRS_RT_BIO timeSeries'
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
d.timeseries_id,
d."LONGITUDE",
d."LONGITUDE_quality_control",
d."LATITUDE",
d."LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
max(d."TIME_quality_control"),
-gsw_z_from_p(avg(d."PRES_REL"), d."LATITUDE"),
max(d."PRES_REL_quality_control"),
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM anmn_nrs_rt_bio.anmn_nrs_rt_bio_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_rt_bio_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.timeseries_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_AM_DM timeSeries
\echo 'ANMN_AM_DM timeSeries'
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
d.file_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
max(d."TIME_quality_control"),
0,
'1',
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM anmn_am_dm.anmn_am_dm_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_am_dm_data'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_BURST_AVG timeSeries
\echo 'ANMN_BURST_AVG timeSeries'
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
d.timeseries_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
avg(d."TEMP"),
'1',
avg(d."PSAL"),
'1',
d.geom
FROM anmn_burst_avg.anmn_burst_avg_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_burst_avg_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.timeseries_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_NRS_YON_DAR timeSeries
\echo 'ANMN_NRS_YON_DAR TEMP timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
NULL,
NULL,
avg(d."VALUES"),
max(d."VALUES_quality_control"),
NULL,
NULL,
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'TEMP'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'ANMN_NRS_YON_DAR PSAL timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
NULL,
NULL,
NULL,
NULL,
avg(d."VALUES"),
max(d."VALUES_quality_control"),
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'PSAL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'ANMN_NRS_YON_DAR DEPTH timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
avg(d."VALUES"),
max(d."VALUES_quality_control"),
NULL,
NULL,
NULL,
NULL,
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'DEPTH'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'ANMN_NRS_YON_DAR PRES_REL timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
-gsw_z_from_p(avg(d."VALUES"), d."LATITUDE"),
max(d."VALUES_quality_control"),
NULL,
NULL,
NULL,
NULL,
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'PRES_REL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- FAIMMS timeSeries
\echo 'FAIMMS TEMP timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
NULL,
NULL,
avg(d."VALUES"),
max(d."VALUES_quality_control"),
NULL,
NULL,
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'TEMP'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'FAIMMS PSAL timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
NULL,
NULL,
NULL,
NULL,
avg(d."VALUES"),
max(d."VALUES_quality_control"),
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'PSAL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'FAIMMS DEPTH timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
avg(d."VALUES"),
max(d."VALUES_quality_control"),
NULL,
NULL,
NULL,
NULL,
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'DEPTH'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

\echo 'FAIMMS PRES_REL timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.channel_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
-gsw_z_from_p(avg(d."VALUES"), d."LATITUDE"),
max(d."VALUES_quality_control"),
NULL,
NULL,
NULL,
NULL,
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'PRES_REL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.channel_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- SRS_ALTIMETRY timeSeries
\echo 'SRS_ALTIMETRY timeSeries'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
d.file_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
-gsw_z_from_p(avg(d."PRES")-10.1325, d."LATITUDE"),
max(d."PRES_quality_control"),
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM srs_altimetry.measurements d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.schema_name = 'srs_altimetry'
AND s.table_name = 'measurements'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- CSIRO Mooring
\echo 'CSIRO Mooring'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"NOMINAL_DEPTH",
"NOMINAL_DEPTH_QC",
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
COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"),
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
CASE
	WHEN max(d."TIME_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."TIME_QC_FLAG") > 63 AND max(d."TIME_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."TIME_QC_FLAG") > 127 AND max(d."TIME_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."NOMINAL_METER_DEPTH"),
'1',
-gsw_z_from_p(avg(d."PRESSURE"), d."LATITUDE"),
CASE
	WHEN max(d."PRESSURE_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."PRESSURE_QC_FLAG") > 63 AND max(d."PRESSURE_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."PRESSURE_QC_FLAG") > 127 AND max(d."PRESSURE_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."TEMPERATURE"),
CASE
	WHEN max(d."TEMPERATURE_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."TEMPERATURE_QC_FLAG") > 63 AND max(d."TEMPERATURE_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."TEMPERATURE_QC_FLAG") > 127 AND max(d."TEMPERATURE_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."SALINITY"),
CASE
	WHEN max(d."SALINITY_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."SALINITY_QC_FLAG") > 63 AND max(d."SALINITY_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."SALINITY_QC_FLAG") > 127 AND max(d."SALINITY_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
d.geom
FROM aodn_csiro_cmar.aodn_csiro_cmar_mooring_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'aodn_csiro_cmar_mooring_data'
GROUP BY s.source_id, COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"), d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"), date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- RAN SST
\echo 'RAN SST'
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
d.file_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
0,
'1',
avg(d."SST"),
'1',
NULL,
NULL,
d.geom
FROM aodn_ran_sst.ran_sst_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'ran_sst_data'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- SOOP TMV trajectory
\echo 'SOOP TMV trajectory'
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
d.file_id,
avg(d."LONGITUDE"),
max(d."LONGITUDE_quality_control"),
avg(d."LATITUDE"),
max(d."LATITUDE_quality_control"),
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'),
max(d."TIME_quality_control"),
0,
'1',
avg(d."TEMP_2"), -- TEMP_2 is collected by the sensor on the hull, TEMP_1 inside the water pump.
max(d."TEMP_2_quality_control"),
avg(d."PSAL"), -- CNDC collected via water pump and PSAL computed using TEMP_1.
max(d."PSAL_quality_control"),
ST_GeometryFromText(COALESCE('POINT('||avg(d."LONGITUDE")||' '||avg(d."LATITUDE")||')'), '4326') -- geom is re-created from averaged positions over 1min
FROM soop_tmv.soop_tmv_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'soop_tmv_trajectory_data'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min
GROUP BY s.source_id, d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC') -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
ORDER BY d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC');

-- SOOP TRV trajectory
\echo 'SOOP TRV trajectory'
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
d.trip_id,
avg(d."LONGITUDE"),
'1', -- TO BE CONFIRMED!!!
avg(d."LATITUDE"),
'1',
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'),
'1',
0,
'1',
avg(d."Seawater_Intake_Temperature"), -- TEMP_2 is collected by the sensor on the hull, TEMP_1 inside the water pump.
'1',
avg(d."PSAL"), -- CNDC collected via water pump and PSAL computed using TEMP_1.
'1',
ST_GeometryFromText(COALESCE('POINT('||avg(d."LONGITUDE")||' '||avg(d."LATITUDE")||')'), '4326') -- geom is re-created from averaged positions over 1min
FROM soop_trv.soop_trv_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'soop_trv_trajectory_data'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min
GROUP BY s.source_id, d.trip_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC') -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
ORDER BY d.trip_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC');

-- need to set empty field's flag to 9
\echo 'Update NOMINAL_DEPTH_QC'
UPDATE spatial_subset
SET "NOMINAL_DEPTH_QC" = 9
WHERE "NOMINAL_DEPTH" IS NULL;

\echo 'Update DEPTH_QC'
UPDATE spatial_subset
SET "DEPTH_QC" = 9
WHERE "DEPTH" IS NULL;

\echo 'Update TEMP_QC'
UPDATE spatial_subset
SET "TEMP_QC" = 9
WHERE "TEMP" IS NULL;

\echo 'Update PSAL_QC'
UPDATE spatial_subset
SET "PSAL_QC" = 9
WHERE "PSAL" IS NULL;
