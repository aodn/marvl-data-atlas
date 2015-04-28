SET SEARCH_PATH = marvl3, public;

-- AODN DSTO
\echo 'AODN DSTO'
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
max(replace(replace(d."LONGITUDE_quality_control", '8', '2'), '9', '')), -- we assume interpolated values as probably good data and we set missing values to NULL
avg(d."LATITUDE"),
max(replace(replace(d."LATITUDE_quality_control", '8', '2'), '9', '')),
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'), -- WODB provides a timestamp every ~1min to ~5min
max(replace(replace(d."TIME_quality_control", '8', '2'), '9', '')),
(width_bucket(CASE WHEN d."DEPTH" IS NOT NULL THEN d."DEPTH" ELSE -gsw_z_from_p(d."PRES", d."LATITUDE") END, -2.5, 502.5, 101)-1)*5, --we are binning from surface to 500m limit every 5m. DEPTH is sometimes NULL while PRES (relative pressure here) is not.
max(replace(replace(CASE WHEN d."DEPTH" IS NOT NULL THEN d."DEPTH_quality_control" ELSE d."PRES_quality_control" END, '8', '2'), '9', '')),
avg(d."TEMP"),
max(replace(replace(d."TEMP_quality_control", '8', '2'), '9', '')),
avg(d."PSAL"),
max(replace(replace(d."PSAL_quality_control", '8', '2'), '9', '')),
ST_GeometryFromText(COALESCE('POINT('||avg(d."LONGITUDE")||' '||avg(d."LATITUDE")||')'), '4326') -- geom is re-created from averaged positions
FROM aodn_dsto.aodn_dsto_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anfog_dm_trajectory_data'
GROUP BY s.source_id, d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'), width_bucket(CASE WHEN d."DEPTH" IS NOT NULL THEN d."DEPTH" ELSE -gsw_z_from_p(d."PRES", d."LATITUDE") END, -2.5, 502.5, 101)
ORDER BY d.file_id, date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'), width_bucket(CASE WHEN d."DEPTH" IS NOT NULL THEN d."DEPTH" ELSE -gsw_z_from_p(d."PRES", d."LATITUDE") END, -2.5, 502.5, 101);
