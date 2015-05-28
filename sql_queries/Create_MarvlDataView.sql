SET SEARCH_PATH = marvl3, public;

DROP VIEW IF EXISTS marvl3_data;
CREATE VIEW marvl3_data AS (
SELECT measurement_id,
	feature_instance_id,
	"ORGANISATION",
	"FACILITY",
	"SUBFACILITY",
	"PRODUCT",
	"LONGITUDE",
	"LONGITUDE_bin",
	"LONGITUDE_QC",
	"LATITUDE",
	"LATITUDE_bin",
	"LATITUDE_QC",
	"TIME",
	"TIME_bin",
	"TIME_QC",
	"NOMINAL_DEPTH",
	"NOMINAL_DEPTH_QC",
	"DEPTH",
	"DEPTH_bin",
	"DEPTH_QC",
	"TEMP",
	"TEMP_QC",
	"PSAL",
	"PSAL_QC",
	geom,
	geom_bin
	FROM spatial_subset_filtered
	ORDER BY feature_instance_id, "TIME", "NOMINAL_DEPTH", "DEPTH", "LATITUDE", "LONGITUDE"
);
