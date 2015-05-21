SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS source;
CREATE TABLE source (
	"ORGANISATION" text,
	"FACILITY" text,
	"SUBFACILITY" text,
	"PRODUCT" text,
	feature_type text,
	schema_name text,
	table_name text,
	ref_column text,
	preprocessing text,
	n_deployments integer,
	n_measurements integer
);

INSERT INTO source (SELECT 'IMOS/AODN', 'AATAMS', 'SATTAG', 'DM', 'trajectoryProfile', 'aatams_sattag_dm', 'aatams_sattag_dm_profile_data','profile_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'ACORN', '', '', 'gridded','','','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'AIMS', 'CTD', '', 'profile', 'aodn_aims_ctd', 'aodn_aims_ctd_data', 'Station','');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANFOG', '', 'DM', 'trajectory','anfog_dm','anfog_dm_trajectory_data','file_id','1-min average, 5m bin');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'CTD', 'NRS', 'profile','anmn_nrs_ctd_profiles','anmn_nrs_ctd_profiles_data','cruise_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'Acidification', 'DM', 'timeSeries','anmn_am_dm','anmn_am_dm_data','file_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'Burst average', '', 'timeSeries','anmn_burst_avg','anmn_burst_avg_timeseries_data','timeseries_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'RT bio', 'NRS', 'timeSeries','anmn_nrs_rt_bio','anmn_nrs_rt_bio_timeseries_data','timeseries_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'RT meteo', 'NRS', 'timeSeries','anmn_nrs_rt_meteo','anmn_nrs_rt_meteo_timeseries_data','timeseries_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'DarYon', 'NRS', 'timeSeries','anmn_nrs_dar_yon','anmn_nrs_yon_dar_timeseries_data','file_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'Temperature regridded', 'timeSeries','anmn_t_regridded','anmn_regridded_temperature_data','file_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'TS', 'timeSeries','anmn_ts','anmn_ts_timeseries_data','timeseries_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'Velocity', 'timeSeriesProfile','anmn_velocity','','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'AODN', '', 'DSTO', 'trajectory','aodn_dsto','aodn_dsto_trajectory_data','file_id','1-min average, 5m bin');
INSERT INTO source (SELECT 'IMOS/AODN', 'AODN', '', 'NT hawksbills', 'trajectoryProfile','aodn_nt_sattag_hawksbill','aodn_nt_sattag_hawksbill_profile_data','profile_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'Argo', '', '', 'trajectoryProfile','argo','profile_download','platform_number+cycle_number','');
INSERT INTO source (SELECT 'IMOS/AODN', 'AUV', '', '', 'trajectory','auv','auv_trajectory_st_data','file_id','1-min average, 5-min subsample');
INSERT INTO source (SELECT 'IMOS/AODN', 'FAIMMS', '', '', 'timeSeries','faimms','faimms_timeseries_data','channel_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'XBT', 'DM', 'profile','soop_xbt_dm','soop_xbt_dm_profile_data','profile_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'CO2', '', 'trajectory','soop_co2','soop_co2_trajectory_data','cruise_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'TRV', '', 'trajectory','soop_trv','soop_trv_trajectory_data','trip_id','1-min average, 5-min subsample');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'SST', 'DM', 'trajectory','soop_sst','soop_sst_dm_trajectory_data','trajectory_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'SST', 'RT', 'trajectory','soop_sst','soop_sst_nrt_trajectory_data','trajectory_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'ASF', 'MT', 'trajectory','soop_asf_mt','soop_asf_mt_trajectory_data','cruise_id','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'TMV', 'DM', 'trajectory','soop_tmv','soop_tmv_trajectory_data','file_id','1-min average, 5-min subsample');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'Altimetry', '', 'timeSeries','srs_altimetry','measurements','file_id','1-hour average');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'Salinity', '', 'gridded','','','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'SST', '', 'gridded','','','','');
INSERT INTO source (SELECT 'CSIRO', '', 'ADCP', '', 'timeSeriesProfile','aodn_csiro_cmar','aodn_csiro_cmar_adcp_data','"SURVEY_ID"','');
INSERT INTO source (SELECT 'CSIRO', '', 'CTD', '', 'profile','aodn_csiro_cmar','aodn_csiro_cmar_ctd_data','"SURVEY_ID"','');
INSERT INTO source (SELECT 'CSIRO', '', 'Hydrology', '', 'profile','aodn_csiro_cmar','aodn_csiro_cmar_hydrology_data','"SURVEY_ID"','');
INSERT INTO source (SELECT 'CSIRO', '', 'Mooring', '', 'timeSeries','aodn_csiro_cmar','aodn_csiro_cmar_mooring_data','"SURVEY_ID+SERIAL_NO"','1-hour average');
INSERT INTO source (SELECT 'CSIRO', '', 'Trajectory', '', 'trajectory','aodn_csiro_cmar','aodn_csiro_cmar_trajectory_data','"SURVEY_ID"','1-min average, 5-min subsample');
INSERT INTO source (SELECT 'CSIRO', '', 'Underway', '', 'trajectory','aodn_csiro_cmar','aodn_csiro_cmar_underway_data','"SURVEY_ID"','1-min average, 5-min subsample');
INSERT INTO source (SELECT 'CSIRO', '', 'XBT', '', 'profile','aodn_csiro_cmar','aodn_csiro_cmar_xbt_data','"SURVEY_ID"','');
INSERT INTO source (SELECT 'RAN', '', 'CTD', '', 'profile','aodn_ran_ctd','aodn_ran_ctd_data','file_id','');
INSERT INTO source (SELECT 'RAN', '', 'SST', '', 'timeSeries','aodn_ran_sst','ran_sst_data','file_id','1-hour average');
INSERT INTO source (SELECT 'WODB', '', 'APB', '', 'trajectoryProfile','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'CTD', '', 'profile','wodb','ctd_measurements','cast_id','');
INSERT INTO source (SELECT 'WODB', '', 'GLD', '', 'trajectory','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'MBT', '', 'profile','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'OSD', '', 'profile','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'PFL', '', 'trajectoryProfile','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'SUR', '', 'trajectory','wodb','','','');
INSERT INTO source (SELECT 'WODB', '', 'UOR', '', 'trajectory','wodb','uor_measurements','cast_id','');
INSERT INTO source (SELECT 'WODB', '', 'XBT', '', 'profile','wodb','xbt_measurements','cast_id','');

ALTER TABLE source ADD COLUMN source_id bigserial;
ALTER TABLE source ADD PRIMARY KEY (source_id);
