SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS bathy_ga;
CREATE TABLE bathy_ga (
	"LONGITUDE" double precision,
	"LATITUDE" double precision,
	"DEPTH" real
);
