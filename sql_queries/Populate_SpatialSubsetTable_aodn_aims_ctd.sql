SET SEARCH_PATH = marvl3, public;

-- AODN AIMS CTD
\echo 'AODN AIMS CTD'
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
d."Station",
d."Longitude",
'1',
d."Latitude",
'1',
d."Time" AT TIME ZONE 'UTC',
'1',
d."Depth",
'1',
d."Temp",
'0',
d."Salinity",
'0',
d.geom
FROM marvl3."500m_isobath" p, marvl3.source s, aodn_aims_ctd.aodn_aims_ctd_data d, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.schema_name = 'aodn_aims_ctd'
AND d."Time" >= '1995-01-01'
AND d."Time" < '2015-01-01';
