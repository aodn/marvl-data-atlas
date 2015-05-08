SET SEARCH_PATH = marvl3, public;

-- bathy_atlas
\echo 'bathy_atlas'
INSERT INTO bathy_atlas (
"LONGITUDE",
"LATITUDE",
"DEPTH"
)
select
(width_bucket(w.longitude, 110.875, 155.125, 176)-1)*0.25+111,
(width_bucket(w.latitude, -2.875, -45.125, 168)-1)*-0.25-3,
max(w.depth)
from legacy_bathy.world_depth w
GROUP BY width_bucket(w.longitude, 110.875, 155.125, 176), width_bucket(w.latitude, -2.875, -45.125, 168);
