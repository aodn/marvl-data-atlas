SET SEARCH_PATH = marvl3, public;

----AUV

SELECT
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')

FROM auv.auv_trajectory_st_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'auv_trajectory_st_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min