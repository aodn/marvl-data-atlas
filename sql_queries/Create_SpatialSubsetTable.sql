SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS spatial_subset;
CREATE TABLE spatial_subset (
	source_id integer,
	origin_id text,
	"LONGITUDE" double precision,
	"LONGITUDE_QC" text,
	"LATITUDE" double precision,
	"LATITUDE_QC" text,
	"TIME" timestamp with time zone,
	"TIME_QC" text,
	"DEPTH" double precision,
	"DEPTH_QC" text,
	"TEMP" double precision,
	"TEMP_QC" text,
	"PSAL" double precision,
	"PSAL_QC" text,
	"UCUR" double precision,
	"UCUR_QC" text,
	"VCUR" double precision,
	"VCUR_QC" text,
	geom geometry(Geometry,4326),
	duplicate boolean
);
