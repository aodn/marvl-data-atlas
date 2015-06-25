﻿SET SEARCH_PATH = marvl3, public;

-- ANMN_BURST_AVG timeSeries

SELECT
s.source_id,
d.timeseries_id,
d."LONGITUDE",
d."LATITUDE",
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC')

FROM anmn_burst_avg.anmn_burst_avg_timeseries_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'anmn_burst_avg_timeseries_data'