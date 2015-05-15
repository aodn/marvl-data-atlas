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
m."Station",
m."Longitude",
'1',
m."Latitude",
'1',
m."Time" AT TIME ZONE 'UTC',
'1',
d."Depth",
'1',
d."Temp",
'0',
d."Salinity",
'0',
m.geom
FROM marvl3."500m_isobath" p, marvl3.source s, aodn_aims_ctd.aodn_aims_ctd_map m, marvl3."australian_continent" pp
INNER JOIN  aodn_aims_ctd.aodn_aims_ctd_data d
ON m."Station" = d."Station"
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.schema_name = 'aodn_aims_ctd'
AND m."Time" >= '1995-01-01'
AND m."Time" < '2015-01-01';
