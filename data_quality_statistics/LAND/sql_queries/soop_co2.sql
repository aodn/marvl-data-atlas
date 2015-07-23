SET SEARCH_PATH = marvl3, public;
---SOOP-CO2
-- Temperature data from SOOP-CO2 not used. TEMP will be extracted from other schemas

SELECT
s.source_id,
d.cruise_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME" AT TIME ZONE 'UTC'

FROM soop_co2.soop_co2_trajectory_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'soop_co2_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND d.vessel_name IN('L''Astrolabe','Aurora Australis');