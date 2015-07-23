SET SEARCH_PATH = marvl3, public;

SELECT
s.source_id,
d.file_id,
d."LATITUDE",
d."LONGITUDE"

FROM anfog_dm.anfog_dm_trajectory_data d,marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'anfog_dm_trajectory_data'
