SET SEARCH_PATH = marvl3, public;

-- bathy_ga
\echo 'bathy_ga'
COPY bathy_ga ("LONGITUDE", "LATITUDE", "DEPTH") FROM '../bathy/Australia_GA_1kmres_1.xyz' WITH DELIMITER ' '
COPY bathy_ga ("LONGITUDE", "LATITUDE", "DEPTH") FROM '../bathy/Australia_GA_1kmres_2.xyz' WITH DELIMITER ' '
COPY bathy_ga ("LONGITUDE", "LATITUDE", "DEPTH") FROM '../bathy/Australia_GA_1kmres_3.xyz' WITH DELIMITER ' '
COPY bathy_ga ("LONGITUDE", "LATITUDE", "DEPTH") FROM '../bathy/Australia_GA_1kmres_4.xyz' WITH DELIMITER ' '
COPY bathy_ga ("LONGITUDE", "LATITUDE", "DEPTH") FROM '../bathy/Australia_GA_1kmres_5.xyz' WITH DELIMITER ' '
