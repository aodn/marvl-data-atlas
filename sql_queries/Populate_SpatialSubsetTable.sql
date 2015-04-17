SET SEARCH_PATH = marvl3, public;
 
-- TRUNCATE spatial_subset CASCADE;
-- ALTER SEQUENCE spatial_subset_pkid_seq RESTART;
-- ALTER SEQUENCE duplicate_seq RESTART;
	
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
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND source_id = 1 AND timestamp >= '1995-01-01' AND timestamp < '2015-01-01' AND 
	device_id NOT IN ('ct106-796-13','ct31-441-07','ct31-448B-07','ct61-01-09','ct76-364-11','ft13-073_3-13','ft13-616-12','ft13-628-12','ft13-633-12') -- Exclude devices that have been recovered
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
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND source_id = 4 AND "TIME" >= '1995-01-01' AND "TIME" < '2015-01-01'
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
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND source_id = 14 AND timestamp >= '1995-01-01' AND timestamp < '2015-01-01'
	);

-- Argo
INSERT INTO spatial_subset(
	WITH m AS (SELECT DISTINCT platform_number, cycle_number, source_id FROM argo.profile_download, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, profile_download."position") AND source_id = 15  AND juld >= '1995-01-01' AND juld < '2015-01-01')
  SELECT source_id,
	COALESCE(m.platform_number||'_'||m.cycle_number),
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

-- WODB XBT
INSERT INTO spatial_subset(
	WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, xbt_deployments.geom FROM wodb.xbt_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, xbt_deployments.geom) AND source_id = 45 AND "TIME" >= '1995-01-01' AND "TIME" < '2015-01-01')
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

-- WODB CTD
INSERT INTO spatial_subset(
	WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, ctd_deployments.geom FROM wodb.ctd_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, ctd_deployments.geom) AND source_id = 38 AND "TIME" >= '1995-01-01' AND "TIME" < '2015-01-01')
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