SET SEARCH_PATH = marvl3, public;

-- SOOP TRV trajectory

SELECT
s.source_id,
d.trip_id,
d."LONGITUDE",
d."LATITUDE"

FROM soop_trv.soop_trv_trajectory_data d,  marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'soop_trv_trajectory_data'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min <=> ~ 1.5km at 10knots
