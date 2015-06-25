SET SEARCH_PATH = marvl3, public;
---SOOP-SST NRT

SELECT source_id,
d.trajectory_id,
d."LONGITUDE",
d."LATITUDE"

FROM soop_sst.soop_sst_nrt_trajectory_data d, marvl3."500m_isobath" p,marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d.geom) = TRUE
AND s.table_name = 'soop_sst_nrt_trajectory_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND vessel_name NOT IN('Xutra Bhum','Wana Bhum','RV Cape Ferguson');	--'Xutra Bhum', 'Wana Bhum' in SOOP-SST DM; 'RV Cape Ferguson' in SOOP-TRV

-- inland data because of bad precision --