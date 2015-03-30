
SET SEARCH_PATH = marvl3, public;
	
----AUV
INSERT INTO spatial_subset(	
WITH m AS (SELECT file_id, source_id FROM auv.auv_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, auv.auv_trajectory_data.geom) AND source_id = 16)
  SELECT source_id,
  m.file_id,
  	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME",
	NULL,
	"DEPTH",
	NULL,
	"TEMP",
	NULL,
	"PSAL",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN auv.auv_trajectory_st_data d ON m.file_id = d.file_id
	);
---SOOP-CO2	

INSERT INTO spatial_subset(	
WITH m AS (SELECT cruise_id, source_id FROM soop_co2.soop_co2_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_co2.soop_co2_trajectory_data.geom) AND source_id = 19)
  SELECT source_id,
  m.cruise_id,
  	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME",
	"TIME_quality_control",
	0,
	0,
	"TEMP_1",
	"TEMP_1_quality_control",
	"PSAL",
	"PSAL_quality_control",
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_co2.soop_co2_trajectory_data d ON m.cruise_id = d.cruise_id
	);
	
---SOOP-TRV
INSERT INTO spatial_subset(	
WITH m AS (SELECT trip_id, source_id FROM soop_trv.soop_trv_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_trv.soop_trv_trajectory_data.geom) AND source_id = 20)
  SELECT source_id,
  m.trip_id,
  	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME",
	NULL,
	0,
	0,
	"Seawater_Intake_Temperature",
	NULL,
	"PSAL",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_trv.soop_trv_trajectory_data d ON m.trip_id = d.trip_id
	);
	
---SOOP-SST DM	
SET SEARCH_PATH = marvl3, public;	
INSERT INTO spatial_subset(	
WITH m AS (SELECT trajectory_id, source_id FROM soop_sst.soop_sst_dm_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_sst.soop_sst_dm_trajectory_data.geom) AND source_id = 21)
  SELECT source_id,
  m.trajectory_id,
  	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME",
	"TIME_quality_control",
	0,
	0,
	"TEMP",
	"TEMP_quality_control",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_sst.soop_sst_dm_trajectory_data d ON m.trajectory_id = d.trajectory_id
	);
		
---SOOP-SST NRT

INSERT INTO spatial_subset(	
WITH m AS (SELECT trajectory_id, source_id FROM soop_sst.soop_sst_nrt_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_sst.soop_sst_nrt_trajectory_data.geom) AND source_id = 22)
  SELECT source_id,
  m.trajectory_id,
  	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME",
	"TIME_quality_control",
	0,
	0,
	"TEMP",
	"TEMP_quality_control",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_sst.soop_sst_nrt_trajectory_data d ON m.trajectory_id = d.trajectory_id
	);
	
---SOOP_TMV
	
INSERT INTO spatial_subset(	
WITH m AS (SELECT file_id, source_id FROM soop_tmv.soop_tmv_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_tmv.soop_tmv_trajectory_data.geom) AND source_id = 24)
  SELECT source_id,
  m.file_id,
  	"LONGITUDE",
	"LONGITUDE_quality_control",
	"LATITUDE",
	"LATITUDE_quality_control",
	"TIME",
	"TIME_quality_control",
	0,
	0,
	"TEMP_1",
	"TEMP_1_quality_control",
	"PSAL",
	"PSAL_quality_control",
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_tmv.soop_tmv_trajectory_data d ON m.file_id = d.file_id
	);
	
---SOOP_ASF_MT	
	
INSERT INTO spatial_subset(	
WITH m AS (SELECT cruise_id, source_id FROM soop_asf_mt.soop_asf_mt_trajectory_data, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, soop_asf_mt.soop_asf_mt_trajectory_data.geom) AND source_id = 23)
  SELECT source_id,
  m.cruise_id,
  	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME",
	NULL,
	0,
	0,
	"TEMP",
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	geom,
	NULL, 
	NULL
	FROM m
  JOIN soop_asf_mt.soop_asf_mt_trajectory_data d ON m.cruise_id = d.cruise_id
	);
			
-- CSIRO TRAJECTORY
		
INSERT INTO spatial_subset(
  SELECT source_id,
	"SURVEY_ID",
	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME" AT TIME ZONE 'UTC' AS TIME,
	NULL,
	0,
	0,
	"TEMPERATURE",
	"TEMPERATURE_QC",
	"SALINITY",
	"SALINITY_QC",
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom,
	NULL,
	NULL
  FROM aodn_csiro_cmar.aodn_csiro_cmar_trajectory_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND -- Condition #1: In 500m Shapefile, no QC flags
  	source_id = 32 -- Link to institutions table
	);
		
	
-- CSIRO UNDERWAY

INSERT INTO spatial_subset(
  SELECT source_id,
	"SURVEY_ID",
	"LONGITUDE",
	NULL,
	"LATITUDE",
	NULL,
	"TIME" AT TIME ZONE 'UTC' AS TIME,
	NULL,
	0,
	0,
	"SEA_SURFACE_TEMP",
	"SEA_SURFACE_TEMP_QC" ,
	"SALINITY",
	"SALINITY_QC",
	NULL,
	NULL,
	NULL,
	NULL,
	m.geom,
	NULL,
	NULL
  FROM aodn_csiro_cmar.aodn_csiro_cmar_underway_data m, "500m_isobath", source
  WHERE ST_CONTAINS("500m_isobath".geom, m.geom) AND -- Condition #1: In 500m Shapefile, no QC flags
  	source_id = 33 -- Link to institutions table
	);
	
		
	-- WODB GLD
INSERT INTO spatial_subset(
        WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, gld_deployments.geom FROM wodb.gld_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, gld_deployments.geom) AND source_id = 39)
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
        geom,
        NULL,
        NULL
  FROM m
  LEFT JOIN wodb.gld_measurements d ON m."CAST_ID" = d.cast_id
        );
        
        
        	-- WODB SUR
INSERT INTO spatial_subset(
        WITH m AS (SELECT "CAST_ID", "LONGITUDE", "LATITUDE", "TIME", source_id, sur_deployments.geom FROM wodb.sur_deployments, "500m_isobath",source WHERE ST_CONTAINS("500m_isobath".geom, sur_deployments.geom) AND source_id = 43)
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
        geom,
        NULL,
        NULL
  FROM m
  LEFT JOIN wodb.sur_measurements d ON m."CAST_ID" = d.cast_id
        );