SET SEARCH_PATH = marvl3, public;

-- spatial_subset_filtered
\echo 'spatial_subset_filtered'
INSERT INTO spatial_subset_filtered (
measurement_id,
feature_instance_id,
collection_id,
"ORGANISATION",
"FACILITY",
"SUBFACILITY",
"PRODUCT",
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
d.pkid,
d.origin_id,
s.source_id,
s."ORGANISATION",
s."FACILITY",
s."SUBFACILITY",
s."PRODUCT",
d."LONGITUDE",
d."LONGITUDE_QC",
d."LATITUDE",
d."LATITUDE_QC",
d."TIME" AT TIME ZONE 'UTC',
d."TIME_QC",
d."NOMINAL_DEPTH",
d."NOMINAL_DEPTH_QC",
d."DEPTH",
d."DEPTH_QC",
CASE WHEN d."TEMP_QC" IN ('0', '1', '2') AND d."TEMP" BETWEEN -2.5 AND 40 THEN d."TEMP" ELSE NULL END, -- measurements with QC flags no good are not considered, global range QC test (ARGO thresholds)
CASE WHEN d."TEMP_QC" IN ('0', '1', '2') AND d."TEMP" BETWEEN -2.5 AND 40 THEN d."TEMP_QC" ELSE NULL END, -- global range QC test (ARGO thresholds)
CASE WHEN (d."PSAL_QC" IN ('0', '1', '2') AND d."PSAL" BETWEEN 2 AND 41 AND d."TEMP_QC" IN ('0', '1', '2')) THEN d."PSAL" ELSE NULL END, -- checking for TEMP_QC is part of the salinity QC test (if TEMP is not good then PSAL must be not good), global range QC test (ARGO thresholds)
CASE WHEN (d."PSAL_QC" IN ('0', '1', '2') AND d."PSAL" BETWEEN 2 AND 41 AND d."TEMP_QC" IN ('0', '1', '2')) THEN d."PSAL_QC" ELSE NULL END, -- global range QC test (ARGO thresholds)
d.geom
FROM spatial_subset d
INNER JOIN marvl3.source s 
ON s.source_id = d.source_id
WHERE d."LONGITUDE_QC" IN ('0', '1', '2') -- measurements with time and space location QC flags no good are not considered
AND d."LATITUDE_QC" IN ('0', '1', '2')
AND d."TIME_QC" IN ('0', '1', '2')
AND (
d."NOMINAL_DEPTH_QC" IN ('0', '1', '2')
OR d."DEPTH_QC" IN ('0', '1', '2')
)
AND d."TIME" BETWEEN '1995-01-01' AND now() -- impossible time QC test
AND d."LONGITUDE" BETWEEN 111 AND 155 -- impossible location QC test
AND d."LATITUDE" BETWEEN -45 AND -3
AND (
d."DEPTH" BETWEEN -5 AND 505
OR d."NOMINAL_DEPTH" BETWEEN -5 AND 505
);
