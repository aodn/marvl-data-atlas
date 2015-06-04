SET SEARCH_PATH = marvl3, public;

DROP VIEW IF EXISTS marvl3_atlas_data;
CREATE VIEW marvl3_atlas_data AS (
SELECT "LONGITUDE_bin",
  "LONGITUDE_bound_min",
  "LONGITUDE_bound_max",
  "LATITUDE_bin",
  "LATITUDE_bound_min",
  "LATITUDE_bound_max",
  "TIME_bin" AT TIME ZONE 'UTC' AS "TIME_bin",
  "TIME_bound_min" AT TIME ZONE 'UTC' AS "TIME_bound_min",
  "TIME_bound_max" AT TIME ZONE 'UTC' AS "TIME_bound_max",
  "DEPTH_bin",
  "DEPTH_bound_min",
  "DEPTH_bound_max",
  "TEMP_n",
  "TEMP_min",
  "TEMP_max",
  "TEMP_mean",
  "TEMP_stddev",
  "PSAL_n",
  "PSAL_min",
  "PSAL_max",
  "PSAL_mean",
  "PSAL_stddev",
  geom_bin
	FROM data_atlas
	ORDER BY "TIME_bin", "DEPTH_bin", "LATITUDE_bin", "LONGITUDE_bin"
);
