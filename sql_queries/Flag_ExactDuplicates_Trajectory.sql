SET SEARCH_PATH = marvl3, public;


-- Identify underway (trajectory) duplicates
UPDATE spatial_subset SET duplicate = TRUE, duplicate_id = dupl_id
FROM (SELECT "LONGITUDE", 
	"LATITUDE", 
	"TIME",
	nextval('duplicate_seq') AS dupl_id
 FROM spatial_subset WHERE source_id IN (19,20,21,22,23,24,33,43)
	GROUP BY "LONGITUDE", "LATITUDE", "TIME"
	HAVING count(DISTINCT origin_id) > 1)aggregated
WHERE aggregated."LONGITUDE" = spatial_subset."LONGITUDE" AND aggregated."LATITUDE" = spatial_subset."LATITUDE" AND aggregated."TIME" = spatial_subset."TIME";

-- Identify duplicates in the other trajectory schemas (AUV,GLD,UOR,CSIRO_traj)
UPDATE spatial_subset SET duplicate = TRUE, duplicate_id = dupl_id
FROM (SELECT "LONGITUDE", 
	"LATITUDE", 
	"TIME",
	nextval('duplicate_seq') AS dupl_id
 FROM spatial_subset WHERE source_id IN (16,32,39,44)
	GROUP BY "LONGITUDE", "LATITUDE", "TIME"
	HAVING count(DISTINCT origin_id) > 1)aggregated
WHERE aggregated."LONGITUDE" = spatial_subset."LONGITUDE" AND aggregated."LATITUDE" = spatial_subset."LATITUDE" AND aggregated."TIME" = spatial_subset."TIME";
