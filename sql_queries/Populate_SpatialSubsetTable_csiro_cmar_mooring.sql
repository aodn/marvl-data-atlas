SET SEARCH_PATH = marvl3, public;

-- CSIRO Mooring
\echo 'CSIRO Mooring'
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
COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"),
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
CASE
	WHEN max(d."TIME_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."TIME_QC_FLAG") > 63 AND max(d."TIME_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."TIME_QC_FLAG") > 127 AND max(d."TIME_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."NOMINAL_METER_DEPTH"),
'1',
-gsw_z_from_p(avg(d."PRESSURE"), d."LATITUDE"),
CASE
	WHEN max(d."PRESSURE_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."PRESSURE_QC_FLAG") > 63 AND max(d."PRESSURE_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."PRESSURE_QC_FLAG") > 127 AND max(d."PRESSURE_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."TEMPERATURE"),
CASE
	WHEN max(d."TEMPERATURE_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."TEMPERATURE_QC_FLAG") > 63 AND max(d."TEMPERATURE_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."TEMPERATURE_QC_FLAG") > 127 AND max(d."TEMPERATURE_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
avg(d."SALINITY"),
CASE
	WHEN max(d."SALINITY_QC_FLAG") <= 63 THEN '1'
	WHEN max(d."SALINITY_QC_FLAG") > 63 AND max(d."SALINITY_QC_FLAG") <= 127 THEN '3'
	WHEN max(d."SALINITY_QC_FLAG") > 127 AND max(d."SALINITY_QC_FLAG") <= 191 THEN '4'
	ELSE '0'
END,
d.geom
FROM aodn_csiro_cmar.aodn_csiro_cmar_mooring_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'aodn_csiro_cmar_mooring_data'
GROUP BY s.source_id, COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"), d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom;
