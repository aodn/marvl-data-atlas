% found out that SOOP_ASF_MT had data from year 2015. 
% Removed any potential other data from the spatial_subset table
% It could be also implemented during the process of creating the spatial subset.
DELETE FROM marvl3.spatial_subset where "TIME" >'2015-01-01 00:00:00'
