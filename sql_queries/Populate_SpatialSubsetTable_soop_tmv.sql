SET SEARCH_PATH = marvl3, public;

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
FROM soop_tmv.soop_tmv_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'soop_tmv_trajectory_data'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min
GROUP BY s.source_id, d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'); -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
