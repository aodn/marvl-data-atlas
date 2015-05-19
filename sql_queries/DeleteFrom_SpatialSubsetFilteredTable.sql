SET SEARCH_PATH = marvl3, public;

--delete entries where we don't have any data
\echo 'delete entries where we dont have any data'
DELETE FROM spatial_subset_filtered
WHERE "TEMP" IS NULL
AND "PSAL" IS NULL;

-- delete_entries_from_spatial_subset_filtered_based_on_bathy
\echo 'delete_bins_from_data_atlas_based_on_bathy'
DELETE FROM spatial_subset_filtered s
WHERE (s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH") IN (
SELECT s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH"
FROM spatial_subset_filtered s
INNER JOIN bathy_atlas b
ON round(s."LONGITUDE"::numeric*4)/4 = b."LONGITUDE"
AND round(s."LATITUDE"::numeric*4)/4 = b."LATITUDE"
WHERE s."DEPTH" > b."DEPTH");
