SET SEARCH_PATH = marvl3, public;


SELECT
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')  -- WODB provides a timestamp every ~1min to ~5min

FROM aodn_dsto.aodn_dsto_trajectory_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'aodn_dsto_trajectory_data'