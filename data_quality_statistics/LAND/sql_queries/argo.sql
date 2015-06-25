SET SEARCH_PATH = marvl3, public;

-- Argo

SELECT
s.source_id,
COALESCE(d.platform_number||'+'||d.cycle_number),	-- see ref_column in CreatPopulate_SourceTable.sql
d.longitude,
d.latitude

FROM argo.profile_download d,  marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(pp.geom, d."position") = TRUE
AND s.table_name = 'profile_download'
AND d.juld >= '1995-01-01'
AND d.juld < '2015-01-01';
