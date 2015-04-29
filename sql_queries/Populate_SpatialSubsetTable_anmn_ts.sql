SET SEARCH_PATH = marvl3, public;

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
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
