SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS bathy_atlas;
CREATE TABLE bathy_atlas (
	"LONGITUDE" double precision,
	"LATITUDE" double precision,
	"DEPTH" real
);
