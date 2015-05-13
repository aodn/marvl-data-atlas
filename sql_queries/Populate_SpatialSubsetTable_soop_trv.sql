SET SEARCH_PATH = marvl3, public;

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
FROM soop_trv.soop_trv_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'soop_trv_trajectory_data'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min <=> ~ 1.5km at 10knots
GROUP BY s.source_id, d.trip_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'); -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
