
WITH A AS (SELECT 
m.source_id,
count(distinct m.origin_id) AS n_deployments,
count(*) AS n_measurements
FROM marvl3.spatial_subset m 
GROUP BY m.source_id),

B AS (SELECT 
s.source_id, 
s.feature_type,
s.schema_name,
s."ORGANISATION",
s."FACILITY",
s."SUBFACILITY",
s."PRODUCT",
s.preprocessing 
FROM marvl3.source s)
SELECT 
b.source_id,
b.feature_type,
b.schema_name,
a.n_deployments,
a.n_measurements,
b.preprocessing,
b."ORGANISATION",
b."FACILITY",
b."SUBFACILITY",
b."PRODUCT" 
FROM a
FULL JOIN b ON a.source_id = b.source_id


