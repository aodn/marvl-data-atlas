SET SEARCH_PATH = marvl3, public;

-- RAN SST

SELECT
s.source_id,
d.file_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC')

FROM aodn_ran_sst.ran_sst_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'ran_sst_data'
