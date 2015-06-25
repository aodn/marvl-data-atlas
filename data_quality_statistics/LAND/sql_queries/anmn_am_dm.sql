SET SEARCH_PATH = marvl3, public;

-- ANMN_AM_DM timeSeries
SELECT
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC')

FROM anmn_am_dm.anmn_am_dm_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'anmn_am_dm_data'

