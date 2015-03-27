SET SEARCH_PATH = marvl3, public;

-- Identify XBT duplicates
UPDATE spatial_subset SET duplicate = TRUE
FROM (WITH a AS (SELECT origin_id, 
	"LONGITUDE", 
	"LATITUDE", 
	"TIME" 
  FROM spatial_subset 
	GROUP BY origin_id, "LONGITUDE", "LATITUDE", "TIME"), 
  b AS (SELECT row_number() over (partition by "LONGITUDE", "LATITUDE", "TIME" order by origin_id) as rnum,* 
  FROM a) 
  SELECT * 
  FROM b)aggregated
WHERE aggregated.origin_id = spatial_subset.origin_id AND rnum > 1




-- Identify XBT duplicates
UPDATE spatial_subset SET duplicate = TRUE
FROM (WITH a AS (SELECT origin_id, 
	"LONGITUDE", 
	"LATITUDE", 
	"TIME" 
  FROM spatial_subset 
	GROUP BY origin_id, "LONGITUDE", "LATITUDE", "TIME"), 
  b AS (SELECT row_number() over (partition by "LONGITUDE", "LATITUDE", "TIME" order by origin_id) as rnum,* 
  FROM a) 
  SELECT * 
  FROM b)aggregated
WHERE aggregated.origin_id = spatial_subset.origin_id AND rnum > 1