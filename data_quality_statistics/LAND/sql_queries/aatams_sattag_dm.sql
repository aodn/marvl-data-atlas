SELECT
s.source_id,
d.profile_id,
d.lon,
d.lat

FROM aatams_sattag_dm.aatams_sattag_dm_profile_data d,  marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'aatams_sattag_dm_profile_data'
AND d.timestamp >= '1995-01-01'
AND d.timestamp < '2015-01-01'
-- Exclude devices that have been recovered
AND d.device_id NOT IN (
'ct106-796-13',
'ct31-441-07',
'ct31-448B-07',
'ct61-01-09',
'ct76-364-11',
'ft13-073_3-13',
'ft13-616-12',
'ft13-628-12',
'ft13-633-12'
)
