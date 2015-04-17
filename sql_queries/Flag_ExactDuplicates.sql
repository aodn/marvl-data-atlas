SET SEARCH_PATH = marvl3, public;

-- Identify profile duplicates
UPDATE spatial_subset SET duplicate = TRUE, duplicate_id = dupl_id
FROM (SELECT "LONGITUDE", 
	"LATITUDE", 
	"TIME",
	nextval('duplicate_seq') AS dupl_id
  FROM spatial_subset 
  LEFT JOIN source ON source.source_id = spatial_subset.source_id
-- 	WHERE source."SUBFACILITY" IN ('XBT','SATTAG', 'APB')
	GROUP BY "LONGITUDE", "LATITUDE", "TIME"
	HAVING count(DISTINCT origin_id) > 1)aggregated
WHERE aggregated."LONGITUDE" = spatial_subset."LONGITUDE" AND aggregated."LATITUDE" = spatial_subset."LATITUDE" AND aggregated."TIME" = spatial_subset."TIME";