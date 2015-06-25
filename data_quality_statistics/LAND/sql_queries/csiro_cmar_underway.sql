SET SEARCH_PATH = marvl3, public;
-- CSIRO UNDERWAY

SELECT
s.source_id,
d."SURVEY_ID",
d."LONGITUDE",
d."LATITUDE",
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')

FROM aodn_csiro_cmar.aodn_csiro_cmar_underway_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'aodn_csiro_cmar_underway_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min