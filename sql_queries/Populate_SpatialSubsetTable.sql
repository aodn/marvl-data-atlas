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
	geom
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
	"TIME" AT TIME ZONE 'UTC',
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
	m.geom
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
	geom
  FROM m
  LEFT JOIN wodb.xbt_measurements d ON m."CAST_ID" = d.cast_id
	);

	
-- AATAMS SATTAG DM
INSERT INTO spatial_subset(
  SELECT source_id,
	profile_id,
	lon,
	NULL,
	lat,
	NULL,
	timestamp AT TIME ZONE 'UTC',
	NULL,
	pressure,
	NULL,
	temp_vals,
	NULL,
	sal_corrected_vals,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom
  FROM aatams_sattag_dm.aatams_sattag_dm_profile_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 1
	);

-- WODB APB
INSERT INTO spatial_subset(
	WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, apb_deployments.geom FROM wodb.apb_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, apb_deployments.geom) AND source_id = 37)
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
	salinity,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom
  FROM m
  LEFT JOIN wodb.apb_measurements d ON m."CAST_ID" = d.cast_id
	);