SET SEARCH_PATH = marvl3, public;

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
d.file_id,
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
avg(d."DEPTH"),
'1',
-gsw_z_from_p(avg(d."PRES")-10.1325, d."LATITUDE"),
max(d."PRES_quality_control"),
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM srs_altimetry.measurements d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.schema_name = 'srs_altimetry'
AND s.table_name = 'measurements'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');
