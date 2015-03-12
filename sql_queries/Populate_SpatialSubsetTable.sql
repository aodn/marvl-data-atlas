SET SEARCH_PATH = marvl3, public;

-- SOOP_XBT_DM
INSERT INTO spatial_subset(
	WITH m AS (SELECT profile_id, source_id FROM soop_xbt_dm.soop_xbt_dm_profile_map, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_xbt_dm_profile_map.geom) AND source_id = 18)
  SELECT source_id,
	m.profile_id,
	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME",
	"TIME_quality_control",
	"DEPTH",
	"DEPTH_quality_control",
	"TEMP" AS "TEMP",
	"TEMP_quality_control" AS "TEMP_QC",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL
  FROM m
  LEFT JOIN soop_xbt_dm.soop_xbt_dm_profile_data d ON m.profile_id = d.profile_id
	);

-- CSIRO XBT
INSERT INTO spatial_subset(
  SELECT source_id,
	"SURVEY_ID",
	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME" AT TIME ZONE 'UTC' AS TIME,
	NULL,
	"DEPTH",
	NULL,
	"TEMPERATURE",
	"TEMPERATURE_QC",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom,
	NULL
  FROM aodn_csiro_cmar.aodn_csiro_cmar_xbt_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND -- Condition #1: In 500m Shapefile, no QC flags
  	source_id = 34 -- Link to institutions table
	);