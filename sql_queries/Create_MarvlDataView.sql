SET SEARCH_PATH = marvl3, public;

DROP VIEW IF EXISTS marvl3_data;
CREATE VIEW marvl3_data AS (
SELECT measurement_id,
	feature_type_id,
	"ORGANISATION",
	"FACILITY",
	"SUBFACILITY",
	"PRODUCT",
	"LONGITUDE",
	"LONGITUDE_QC",
	"LATITUDE",
	"LATITUDE_QC",
	"TIME" AT TIME ZONE 'UTC' AS "TIME",
	"TIME_QC",
	"NOMINAL_DEPTH",
	"NOMINAL_DEPTH_QC",
	"DEPTH",
	"DEPTH_QC",
	"TEMP",
	"TEMP_QC",
	"PSAL",
	"PSAL_QC",
	geom
	FROM spatial_subset_filtered
	ORDER BY feature_type_id, "TIME", "NOMINAL_DEPTH", "DEPTH"
);