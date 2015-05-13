SET SEARCH_PATH = marvl3, public;

-- ANMN_NRS_RT_METEO timeSeries
\echo 'ANMN_NRS_RT_METEO timeSeries'
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
'1',
0,
'1',
avg(d."SSTI"),
max(d."SSTI_quality_control"),
NULL,
NULL,
d.geom
FROM anmn_nrs_rt_meteo.anmn_nrs_rt_meteo_timeseries_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'anmn_nrs_rt_meteo_timeseries_data'
GROUP BY s.source_id, d.timeseries_id, d."LONGITUDE", d."LONGITUDE_quality_control", d."LATITUDE", d."LATITUDE_quality_control", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
