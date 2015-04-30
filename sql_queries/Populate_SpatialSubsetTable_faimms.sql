SET SEARCH_PATH = marvl3, public;

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
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;

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
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;

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
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;

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
AND d."VALUES" >= 0
AND d."VALUES" < 500 -- gsw_z_from_p cannot handle crazy pressure (fair enough...)
GROUP BY s.source_id, d.channel_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
