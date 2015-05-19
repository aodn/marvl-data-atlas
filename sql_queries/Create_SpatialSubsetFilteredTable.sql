SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS spatial_subset_filtered;
CREATE TABLE spatial_subset_filtered (
	measurement_id integer,
	feature_type_id text,
	"ORGANISATION" text,
	"FACILITY" text,
	"SUBFACILITY" text,
	"PRODUCT" text,
	"LONGITUDE" double precision,
	"LONGITUDE_QC" text,
	"LATITUDE" double precision,
	"LATITUDE_QC" text,
	"TIME" timestamp with time zone,
	"TIME_QC" text,
	"NOMINAL_DEPTH" real,
	"NOMINAL_DEPTH_QC" text,
	"DEPTH" real,
	"DEPTH_QC" text,
	"TEMP" real,
	"TEMP_QC" text,
	"PSAL" real,
	"PSAL_QC" text,
	"UCUR" real,
	"UCUR_QC" text,
	"VCUR" real,
	"VCUR_QC" text,
	geom geometry(Geometry,4326)
);

ALTER TABLE spatial_subset_filtered ADD CONSTRAINT spatial_subset_filtered_pkid PRIMARY KEY (measurement_id);
