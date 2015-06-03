SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS data_atlas;
CREATE TABLE data_atlas (
	"LONGITUDE_bin" double precision,
	"LONGITUDE_bound_min" double precision,
	"LONGITUDE_bound_max" double precision,
	"LATITUDE_bin" double precision,
	"LATITUDE_bound_min" double precision,
	"LATITUDE_bound_max" double precision,
	"TIME_bin" timestamp with time zone,
	"TIME_bound_min" timestamp with time zone,
	"TIME_bound_max" timestamp with time zone,
	"DEPTH_bin" real,
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
	geom_bin geometry(Geometry,4326)
);

ALTER TABLE data_atlas
ADD CONSTRAINT data_atlas_pk PRIMARY KEY ("LONGITUDE_bin", "LATITUDE_bin", "TIME_bin", "DEPTH_bin");

ALTER TABLE data_atlas
ADD CONSTRAINT data_atlas_geom_check CHECK (st_isvalid(geom_bin));

CREATE INDEX data_atlas_gist_idx ON data_atlas USING gist (geom_bin);
