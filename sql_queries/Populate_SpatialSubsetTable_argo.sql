SET SEARCH_PATH = marvl3, public;

-- Argo
\echo 'Argo'
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
COALESCE(d.platform_number||'+'||d.cycle_number),	-- see ref_column in CreatPopulate_SourceTable.sql
d.longitude,
d.position_qc,
d.latitude,
d.position_qc,
d.juld,
d.juld_qc,
-gsw_z_from_p(d.pres_adjusted, d.latitude),
d.pres_adjusted_qc,
d.temp_adjusted,
d.temp_adjusted_qc,
d.psal_adjusted,
d.psal_adjusted_qc,
d."position"
FROM argo.profile_download d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d."position")
AND ST_CONTAINS(pp.geom, d."position") = FALSE
AND s.table_name = 'profile_download'
AND d.juld >= '1995-01-01'
AND d.juld < '2015-01-01';
