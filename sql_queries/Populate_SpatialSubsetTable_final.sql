SET SEARCH_PATH = marvl3, public;

-- need to convert NaNs to NULLs
UPDATE spatial_subset
SET "LATITUDE" = NULL
WHERE "LATITUDE" = FLOAT8 'NaN';

UPDATE spatial_subset
SET "LONGITUDE" = NULL
WHERE "LONGITUDE" = FLOAT8 'NaN';

UPDATE spatial_subset
SET "TEMP" = NULL
WHERE "TEMP" = FLOAT8 'NaN';

UPDATE spatial_subset
SET "PSAL" = NULL
WHERE "PSAL" = FLOAT8 'NaN';

UPDATE spatial_subset
SET "DEPTH" = NULL
WHERE "DEPTH" = FLOAT8 'NaN';

UPDATE spatial_subset
SET "NOMINAL_DEPTH" = NULL
WHERE "NOMINAL_DEPTH" = FLOAT8 'NaN';

-- delete useless entries
DELETE FROM spatial_subset
WHERE "TEMP" IS NULL
AND "PSAL" IS NULL;

DELETE FROM spatial_subset
WHERE "LATITUDE" IS NULL
OR "LONGITUDE" IS NULL
OR "TIME" IS NULL
OR ("DEPTH" IS NULL AND "NOMINAL_DEPTH" IS NULL);

-- need to set empty fields' flag to 9
UPDATE spatial_subset
SET "NOMINAL_DEPTH_QC" = '9'
WHERE "NOMINAL_DEPTH" IS NULL;

UPDATE spatial_subset
SET "DEPTH_QC" = '9'
WHERE "DEPTH" IS NULL;

UPDATE spatial_subset
SET "TEMP_QC" = '9'
WHERE "TEMP" IS NULL;

UPDATE spatial_subset
SET "PSAL_QC" = '9'
WHERE "PSAL" IS NULL;
