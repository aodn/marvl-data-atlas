 SET SEARCH_PATH = marvl3, public;
-- WODB SUR

SELECT
s.source_id,
d.cast_id,
d.longitude,
d.latitude,
d.time AT TIME ZONE 'UTC'

FROM wodb.sur_measurements d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s."SUBFACILITY" = 'SUR'
AND s.schema_name = 'wodb'
AND d.time>= '1995-01-01'
AND d.time < '2015-01-01';
