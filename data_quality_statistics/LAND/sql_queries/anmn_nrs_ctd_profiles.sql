SET SEARCH_PATH = marvl3, public;

SELECT
s.source_id,
d.cruise_id,
d."LONGITUDE",
d."LATITUDE",
d."TIME" AT TIME ZONE 'UTC'

FROM anmn_nrs_ctd_profiles.anmn_nrs_ctd_profiles_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'anmn_nrs_ctd_profiles_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01';
