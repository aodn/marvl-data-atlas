SET SEARCH_PATH = marvl3, public;


SELECT
s.source_id,
d."Station",
d."Longitude",
d."Latitude",
d."Time" AT TIME ZONE 'UTC'

FROM marvl3.source s, aodn_aims_ctd.aodn_aims_ctd_data d, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.schema_name = 'aodn_aims_ctd'
AND d."Time" >= '1995-01-01'
AND d."Time" < '2015-01-01';
