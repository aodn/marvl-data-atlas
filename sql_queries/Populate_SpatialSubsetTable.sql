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
'0',	--looks like data hasn't been QC'd at all. TO BE CONFIRMED!!!
d.lat,
'0',
d.timestamp AT TIME ZONE 'UTC',
'0',
-gsw_z_from_p(d.pressure, d.lat),	--looks like pressure is a PRES_REL (displays ~0dbar at the surface). TO BE CONFIRMED!!!
'0',
d.temp_vals,
'0',
d.sal_corrected_vals,
'0',
d.geom
FROM aatams_sattag_dm.aatams_sattag_dm_profile_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'aatams_sattag_dm_profile_data' -- it is best not to hard code source_id value since it may change...
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
'0',	--TO BE CONFIRMED!!!
d.lat,
'0',
d.timestamp AT TIME ZONE 'UTC',
'0',
-gsw_z_from_p(d.pressure, d.lat),	--is pressure PRES or PRES_REL? TO BE CONFIRMED!!!
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
-gsw_z_from_p(d.pres_adjusted, d.latitude),	--looks like pressure is PRES_REL. TO BE CONFIRMED!!!
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
'1',	--TO BE CONFIRMED!!!
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
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
max(d."TIME_quality_control") AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH",
max(d."DEPTH_quality_control") AS "DEPTH_quality_control",
avg(d."TEMP") AS "TEMP",
max(d."TEMP_quality_control") AS "TEMP_quality_control",
avg(d."PSAL") AS "PSAL",
max(d."PSAL_quality_control") AS "PSAL_quality_control",
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
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
0 AS "DEPTH",
'1' AS "DEPTH_quality_control",
avg(d."SSTI") AS "TEMP",
max(d."SSTI_quality_control") AS "TEMP_quality_control",
NULL AS "PSAL",
NULL AS "PSAL_quality_control",
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
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
max(d."TIME_quality_control") AS "TIME_quality_control",
-gsw_z_from_p(avg(d."PRES_REL"), d."LATITUDE") AS "DEPTH",
max(d."PRES_REL_quality_control") AS "DEPTH_quality_control",
avg(d."TEMP") AS "TEMP",
max(d."TEMP_quality_control") AS "TEMP_quality_control",
avg(d."PSAL") AS "PSAL",
max(d."PSAL_quality_control") AS "PSAL_quality_control",
d.geom
FROM anmn_nrs_rt_bio.anmn_nrs_rt_bio_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_rt_bio_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.timeseries_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- ANMN_NRS_BGC chemistry timeSeries
\echo 'ANMN_NRS_BGC chemistry timeSeries'
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
d."NRS_SAMPLE_CODE", -- TO BE CONFIRMED!!!
d."LONGITUDE",
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."UTC_TRIP_START_TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."SAMPLE_DEPTH_M") AS "DEPTH",
'1' AS "DEPTH_quality_control",
NULL AS "TEMP",
NULL AS "TEMP_quality_control",
avg(d."SALINITY") AS "PSAL",
max(d."SALINITY_FLAG") AS "PSAL_quality_control", -- is the flag scale the old IODE one?
d.geom
FROM anmn_nrs_bgc.anmn_nrs_bgc_chemistry_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_bgc_chemistry_data'
GROUP BY s.source_id, d."NRS_SAMPLE_CODE", d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."UTC_TRIP_START_TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d."NRS_SAMPLE_CODE", date_trunc('hour', d."UTC_TRIP_START_TIME" AT TIME ZONE 'UTC');

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
d.file_id, -- TO BE CONFIRMED!!!
d."LONGITUDE",
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
max(d."TIME_quality_control") AS "TIME_quality_control",
0 AS "DEPTH",
'1' AS "DEPTH_quality_control",
avg(d."TEMP") AS "TEMP",
max(d."TEMP_quality_control") AS "TEMP_quality_control",
avg(d."PSAL") AS "PSAL",
max(d."PSAL_quality_control") AS "PSAL_quality_control",
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH",
'1' AS "DEPTH_quality_control",
avg(d."TEMP") AS "TEMP",
'1' AS "TEMP_quality_control",
avg(d."PSAL") AS "PSAL",
'1' AS "PSAL_quality_control",
d.geom
FROM anmn_burst_avg.anmn_burst_avg_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_burst_avg_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH", -- this is the nominal depth... actual depth or pressure is lost
'1' AS "DEPTH_quality_control",
avg(d."VALUES") AS "TEMP",
max(d."VALUES_quality_control") AS "TEMP_quality_control",
NULL AS "PSAL",
NULL AS "PSAL_quality_control",
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'TEMP'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH", -- this is the nominal depth... actual depth or pressure is lost
'1' AS "DEPTH_quality_control",
NULL AS "TEMP",
NULL AS "TEMP_quality_control",
avg(d."VALUES") AS "PSAL",
max(d."VALUES_quality_control") AS "PSAL_quality_control",
d.geom
FROM anmn_nrs_dar_yon.anmn_nrs_yon_dar_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_yon_dar_timeseries_data'
AND d."VARNAME" = 'PSAL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH", -- this is the nominal depth... actual depth or pressure is lost
'1' AS "DEPTH_quality_control",
avg(d."VALUES") AS "TEMP",
max(d."VALUES_quality_control") AS "TEMP_quality_control",
NULL AS "PSAL",
NULL AS "PSAL_quality_control",
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'TEMP'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
avg(d."DEPTH") AS "DEPTH", -- this is the nominal depth... actual depth or pressure is lost
'1' AS "DEPTH_quality_control",
NULL AS "TEMP",
NULL AS "TEMP_quality_control",
avg(d."VALUES") AS "PSAL",
max(d."VALUES_quality_control") AS "PSAL_quality_control",
d.geom
FROM faimms.faimms_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'faimms_timeseries_data'
AND d."VARNAME" = 'PSAL'
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
d.file_id, -- TO BE CONFIRMED!!!
d."LONGITUDE",
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
CASE WHEN avg(d."PRES") IS NOT NULL THEN -gsw_z_from_p(avg(d."PRES")-10.1325, d."LATITUDE") -- actual depth from pressure
	ELSE avg(d."DEPTH") -- nominal depth
END AS "DEPTH",
CASE WHEN avg(d."PRES") IS NOT NULL THEN max(d."PRES_quality_control")
	ELSE '1'
END AS "DEPTH_quality_control",
avg(d."TEMP") AS "TEMP",
max(d."TEMP_quality_control") AS "TEMP_quality_control",
avg(d."PSAL") AS "PSAL",
max(d."PSAL_quality_control") AS "PSAL_quality_control",
d.geom
FROM srs_altimetry.measurements d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.schema_name = 'srs_altimetry'
AND s.table_name = 'measurements'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control",
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control", -- there are [...]_QC_FLAG fields but what is their associated flag scale??? TO BE CONFIRMED!!!
avg(d."NOMINAL_METER_DEPTH") AS "DEPTH", -- this is the nominal depth. Field PRESSURE is always NULL anyway...
'1' AS "DEPTH_quality_control",
avg(d."TEMPERATURE") AS "TEMP",
'1' AS "TEMP_quality_control",
avg(d."SALINITY") AS "PSAL",
'1' AS "PSAL_quality_control",
d.geom
FROM aodn_csiro_cmar.aodn_csiro_cmar_mooring_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'aodn_csiro_cmar_mooring_data'
GROUP BY s.source_id, COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"), d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
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
'1' AS "LONGITUDE_quality_control", -- TO BE CONFIRMED!!!
d."LATITUDE",
'1' AS "LATITUDE_quality_control",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC') AS "TIME",
'1' AS "TIME_quality_control",
0 AS "DEPTH",
'1' AS "DEPTH_quality_control",
avg(d."SST") AS "TEMP",
'1' AS "TEMP_quality_control",
NULL AS "PSAL",
NULL AS "PSAL_quality_control",
d.geom
FROM aodn_ran_sst.ran_sst_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'ran_sst_data'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", "LONGITUDE_quality_control", d."LATITUDE", "LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');

-- need to set empty field's flag to 9
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
