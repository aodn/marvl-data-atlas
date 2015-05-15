SET SEARCH_PATH = marvl3, public;
	
----AUV
\echo 'AUV'
INSERT INTO marvl3.spatial_subset(
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
'1',
avg(d."LATITUDE"),
'1',
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'0',
avg(d."TEMP"),
'0',
avg(d."PSAL"),
'0',
ST_GeometryFromText(COALESCE('POINT('||avg(d."LONGITUDE")||' '||avg(d."LATITUDE")||')'), '4326') -- geom is re-created from averaged positions over 1min
FROM auv.auv_trajectory_st_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'auv_trajectory_st_data' 
AND d."TIME" >= '1995-01-01' 
AND d."TIME" < '2015-01-01'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min
GROUP BY s.source_id, d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'); -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
