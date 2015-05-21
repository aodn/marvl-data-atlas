﻿SET SEARCH_PATH = marvl3, public;

-- bathy_atlas
\echo 'bathy_atlas'
INSERT INTO bathy_atlas (
"LONGITUDE",
"LATITUDE",
"DEPTH"
)
select
(width_bucket(b.longitude, 110.875, 155.125, 177)-1)*0.25+111,
(width_bucket(b.latitude, -2.875, -45.125, 169)-1)*-0.25-3,
max(b.depth)
from marvl3.bathy_ga b
GROUP BY width_bucket(b.longitude, 110.875, 155.125, 177), width_bucket(b.latitude, -2.875, -45.125, 169);
