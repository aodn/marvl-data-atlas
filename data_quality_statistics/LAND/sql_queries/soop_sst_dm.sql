SET SEARCH_PATH = marvl3, public;
---SOOP-SST DM


SELECT
s.source_id,
d.trajectory_id,
d."LONGITUDE",
d."LATITUDE"

FROM  soop_sst.soop_sst_dm_trajectory_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE
ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'soop_sst_dm_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01';
