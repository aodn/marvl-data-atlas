SET SEARCH_PATH = marvl3, public;

-- CSIRO Mooring

SELECT
s.source_id,
COALESCE(d."SURVEY_ID"||'+'||d."SERIAL_NO"),
d."LONGITUDE",
d."LATITUDE",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC')

FROM aodn_csiro_cmar.aodn_csiro_cmar_mooring_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'aodn_csiro_cmar_mooring_data'
