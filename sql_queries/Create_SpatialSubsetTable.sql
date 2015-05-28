SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS spatial_subset;
CREATE TABLE spatial_subset (
	source_id integer,
	origin_id text,
	"LONGITUDE" double precision,
	"LONGITUDE_bin" double precision,
	"LONGITUDE_QC" text,
	"LATITUDE" double precision,
	"LATITUDE_bin" double precision,
	"LATITUDE_QC" text,
	"TIME" timestamp with time zone,
	"TIME_bin" timestamp with time zone,
	"TIME_QC" text,
	"NOMINAL_DEPTH" real,
	"NOMINAL_DEPTH_QC" text,
	"DEPTH" real,
	"DEPTH_bin" real,
	"DEPTH_QC" text,
	"TEMP" real,
	"TEMP_QC" text,
	"PSAL" real,
	"PSAL_QC" text,
	"UCUR" real,
	"UCUR_QC" text,
	"VCUR" real,
	"VCUR_QC" text,
	geom geometry(Geometry,4326),
	geom_bin geometry(Geometry,4326),
	duplicate boolean,
	duplicate_id integer,
	pkid bigserial
);

ALTER TABLE spatial_subset 
ADD CONSTRAINT spatial_subset_pkid PRIMARY KEY (pkid);

DROP SEQUENCE IF EXISTS duplicate_seq;
CREATE SEQUENCE duplicate_seq START 1;
