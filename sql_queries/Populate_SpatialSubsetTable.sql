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
    WHERE "TIME" >= '1995-01-01'
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

-- AODN RAN CTD
INSERT INTO spatial_subset(
  SELECT source_id,
	file_id,
	longitude,
	position_qc_flag,
	latitude,
	position_qc_flag,
	"time" AT TIME ZONE 'UTC',
	time_qc_flag,
	pressure,
	NULL,
	temperature,
	temperature_qc_flag,
	salinity,
	salinity_qc_flag,
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom
  FROM aodn_ran_ctd.aodn_ran_ctd_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 35
	);

-- AODN NT SATTAG HAWKSBILL
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
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom
  FROM aodn_nt_sattag_hawksbill.aodn_nt_sattag_hawksbill_profile_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 14
	);

-- ANMN NRS CTD PROFILES
INSERT INTO spatial_subset(
  SELECT source_id,
	cruise_id,
	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME" AT TIME ZONE 'UTC',
	"TIME_quality_control",
	"DEPTH",
	"DEPTH_quality_control",
	"TEMP",
	"TEMP_quality_control",
	"PSAL",
	"PSAL_quality_control",
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom
  FROM anmn_nrs_ctd_profiles.anmn_nrs_ctd_profiles_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 4
	);

-- Argo
INSERT INTO spatial_subset(
	WITH m AS (SELECT DISTINCT platform_number, cycle_number, source_id FROM argo.profile_download, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, profile_download."position") AND source_id = 15  AND juld >= '1995-01-01')
  SELECT source_id,
	m.platform_number,
	longitude,
	position_qc,
	latitude,
	position_qc,
	juld,
	juld_qc,
	pres_adjusted,
	pres_adjusted_qc,
	temp_adjusted,
	temp_adjusted_qc,
	psal_adjusted,
	psal_adjusted_qc,
	NULL,
	NULL,
	NULL,
	NULL,
	"position"
  FROM m
  LEFT JOIN argo.profile_download d ON m.platform_number = d.platform_number AND m.cycle_number = d.cycle_number
	);

-- CSIRO CTD
INSERT INTO spatial_subset(
  SELECT source_id,
	"SURVEY_ID",
	"LON_START",
	NULL,
	"LAT_START",
	NULL,
	"TIME_START" AT TIME ZONE 'UTC',
	NULL,
	"PRESSURE",
	NULL,
	"TEMPERATURE",
	"TEMPERATURE_QC",
	"SALINITY",
	"SALINITY_QC",
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom
  FROM aodn_csiro_cmar.aodn_csiro_cmar_ctd_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND
  	source_id = 29
	);

-- WODB CTD
INSERT INTO spatial_subset(
	WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, ctd_deployments.geom FROM wodb.ctd_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, ctd_deployments.geom) AND source_id = 38)
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
  LEFT JOIN wodb.ctd_measurements d ON m."CAST_ID" = d.cast_id
	);