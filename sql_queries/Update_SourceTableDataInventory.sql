SET SEARCH_PATH = marvl3, public;
-- Update Source Table with data summary
\echo 'Data Inventory'

WITH a AS (SELECT 
m.source_id,
count(distinct m.origin_id) AS n_deployments,
count(*) AS n_measurements
FROM marvl3.spatial_subset m 
GROUP BY m.source_id)

UPDATE marvl3.source s
SET n_deployments = a.n_deployments,
n_measurements = a.n_measurements 
FROM a WHERE s.source_id = a.source_id 