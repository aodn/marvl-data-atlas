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
	"TEMP",
	"TEMP_quality_control",
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
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 34
	);

-- WODB XBT
INSERT INTO spatial_subset(
	WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, xbt_deployments.geom FROM wodb.xbt_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, xbt_deployments.geom) AND source_id = 45)
  SELECT source_id,
	m."CAST_ID",
	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME",
	NULL,
	depth,
	NULL,
	temperature,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL
  FROM m
  LEFT JOIN wodb.xbt_measurements d ON m."CAST_ID" = d.cast_id
	);