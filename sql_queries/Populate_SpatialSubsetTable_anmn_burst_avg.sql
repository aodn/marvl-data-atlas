SET SEARCH_PATH = marvl3, public;

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
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
