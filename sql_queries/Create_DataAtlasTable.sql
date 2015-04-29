SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS data_atlas;
CREATE TABLE data_atlas (
	"LONGITUDE" double precision,
	"LONGITUDE_bound_min" double precision,
	"LONGITUDE_bound_max" double precision,
	"LATITUDE" double precision,
	"LATITUDE_bound_min" double precision,
	"LATITUDE_bound_max" double precision,
	"TIME" timestamp with time zone,
	"TIME_bound_min" timestamp with time zone,
	"TIME_bound_max" timestamp with time zone,
	"DEPTH" real,
	"DEPTH_bound_min" real,
	"DEPTH_bound_max" real,
	"TEMP_n" real,
	"TEMP_min" real,
	"TEMP_max" real,
	"TEMP_mean" real,
	"TEMP_stddev" real,
	"PSAL_n" real,
	"PSAL_min" real,
	"PSAL_max" real,
	"PSAL_mean" real,
	"PSAL_stddev" real,
	"UCUR_n" real,
	"UCUR_min" real,
	"UCUR_max" real,
	"UCUR_mean" real,
	"UCUR_stddev" real,
	"VCUR_n" real,
	"VCUR_min" real,
	"VCUR_max" real,
	"VCUR_mean" real,
	"VCUR_stddev" real,
	geom geometry(Geometry,4326)
);

ALTER TABLE data_atlas 
ADD CONSTRAINT data_atlas_pk PRIMARY KEY ("LONGITUDE", "LATITUDE", "TIME", "DEPTH");
