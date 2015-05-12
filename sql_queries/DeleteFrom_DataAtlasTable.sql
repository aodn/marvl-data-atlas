SET SEARCH_PATH = marvl3, public;

-- delete_bins_from_data_atlas_based_on_bathy
\echo 'delete_bins_from_data_atlas_based_on_bathy'
DELETE FROM data_atlas s
WHERE (s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH") IN (
SELECT s."LONGITUDE", s."LATITUDE", s."TIME", s."DEPTH" 
FROM data_atlas s
INNER JOIN bathy_atlas b
ON s."LONGITUDE" = b."LONGITUDE"
AND s."LATITUDE" = b."LATITUDE"
WHERE s."DEPTH" * (-1) < b."DEPTH");