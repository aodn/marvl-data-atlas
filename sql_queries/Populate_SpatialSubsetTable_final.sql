SET SEARCH_PATH = marvl3, public;

-- delete useless entries
DELETE FROM spatial_subset
WHERE "TEMP" IS NULL
AND "PSAL" IS NULL
AND "DEPTH" IS NULL;

-- need to set empty field's flag to 9
\echo 'Update NOMINAL_DEPTH_QC'
UPDATE spatial_subset
SET "NOMINAL_DEPTH_QC" = 9
WHERE "NOMINAL_DEPTH" IS NULL;

\echo 'Update DEPTH_QC'
UPDATE spatial_subset
SET "DEPTH_QC" = 9
WHERE "DEPTH" IS NULL;

\echo 'Update TEMP_QC'
UPDATE spatial_subset
SET "TEMP_QC" = 9
WHERE "TEMP" IS NULL;

\echo 'Update PSAL_QC'
UPDATE spatial_subset
SET "PSAL_QC" = 9
WHERE "PSAL" IS NULL;
