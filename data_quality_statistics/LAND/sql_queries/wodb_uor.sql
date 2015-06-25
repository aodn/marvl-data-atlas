SET SEARCH_PATH = marvl3, public;

-- WODB UOR

SELECT
s.source_id,
m."CAST_ID",
m."LONGITUDE",
m."LATITUDE",
m."TIME"

FROM source s, marvl3."australian_continent" pp, wodb.uor_deployments m
INNER JOIN wodb.uor_measurements d
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(pp.geom, m.geom) = TRUE
AND s."SUBFACILITY" = 'UOR'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';
