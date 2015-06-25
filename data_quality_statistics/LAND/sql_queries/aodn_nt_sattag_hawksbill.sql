SET SEARCH_PATH = marvl3, public;


SELECT
s.source_id,
d.profile_id,
d.lon,
d.lat,
d.timestamp AT TIME ZONE 'UTC'

FROM aodn_nt_sattag_hawksbill.aodn_nt_sattag_hawksbill_profile_data d, marvl3.source s, marvl3."australian_continent" pp
WHERE  ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'aodn_nt_sattag_hawksbill_profile_data'
AND d.timestamp >= '1995-01-01'
AND d.timestamp < '2015-01-01';
