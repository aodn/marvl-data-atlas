SELECT ss.origin_id,ss."TIME",ss."LATITUDE",ss."LONGITUDE" FROM marvl3.spatial_subset  ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=24
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start



