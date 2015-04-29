SET SEARCH_PATH = marvl3, public;

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
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
