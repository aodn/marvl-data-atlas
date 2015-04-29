SET SEARCH_PATH = marvl3, public;

-- ANMN_NRS_RT_BIO timeSeries
\echo 'ANMN_NRS_RT_BIO timeSeries'
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
-gsw_z_from_p(avg(d."PRES_REL"), d."LATITUDE"),
max(d."PRES_REL_quality_control"),
avg(d."TEMP"),
max(d."TEMP_quality_control"),
avg(d."PSAL"),
max(d."PSAL_quality_control"),
d.geom
FROM anmn_nrs_rt_bio.anmn_nrs_rt_bio_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'anmn_nrs_rt_bio_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
