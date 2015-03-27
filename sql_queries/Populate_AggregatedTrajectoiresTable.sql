
--Have to run the queries individually cause of identical origin_id between different schemas 
--AUV
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=16
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-CO2
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=19
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-TRV
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=20
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-SST DM
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=21
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-SST RT
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=22
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-ASF MT
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=23
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--SOOP-TMV DM
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=24
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--CSIRO Trajectory (compare with WODB UOR)
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=32
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--CSIRO Underway
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=33
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a


--WODB Glider
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=38
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--WODB SUR
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=43
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a

--WODB UOR ( profile but corresponds to CSIRO trajectory data)
WITH a AS (
SELECT ss.source_id,ss.origin_id,ss."LONGITUDE",ss."LATITUDE",ss."TIME" FROM marvl3.spatial_subset ss
INNER JOIN(
SELECT origin_id, min("TIME") time_start 
FROM marvl3.spatial_subset WHERE source_id=44
GROUP BY origin_id
) agg on ss.origin_id=agg.origin_id and ss."TIME"=agg.time_start
)

INSERT INTO marvl3.aggregated_trajectories
SELECT * from a