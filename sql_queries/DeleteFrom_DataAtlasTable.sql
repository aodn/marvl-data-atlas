SET SEARCH_PATH = marvl3, public;

--delete entries where we don't have any data
\echo 'delete entries from data_atlas where we dont have any data'
DELETE FROM data_atlas
WHERE "TEMP_n" = 0
AND "PSAL_n" = 0;

-- delete_bins_from_data_atlas_based_on_bathy
\echo 'delete_bins_from_data_atlas_based_on_bathy'
DELETE FROM data_atlas s
WHERE (s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH") IN (
SELECT s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH" 
FROM data_atlas s
INNER JOIN bathy_atlas b
ON s."LONGITUDE" = b."LONGITUDE"
AND s."LATITUDE" = b."LATITUDE"
WHERE s."DEPTH" > b."DEPTH" + 10); -- we allow 10m margin
