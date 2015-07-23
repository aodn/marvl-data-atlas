SET SEARCH_PATH = marvl3, public;
---SOOP_ASF_MT

SELECT
s.source_id,
d.cruise_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME" AT TIME ZONE 'UTC'

FROM soop_asf_mt.soop_asf_mt_trajectory_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'soop_asf_mt_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND d.vessel_name NOT IN ('Southern Surveyor'); --SouthernS excluded from here as data from this vessel will be extracted from CSIRO_underway
