SET SEARCH_PATH = marvl3, public;

-- SRS_ALTIMETRY timeSeries

SELECT
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC')

FROM srs_altimetry.measurements d,  marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.schema_name = 'srs_altimetry'
AND s.table_name = 'measurements'