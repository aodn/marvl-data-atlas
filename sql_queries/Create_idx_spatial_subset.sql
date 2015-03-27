
CREATE INDEX tble_lookup_traj_idx 
  ON marvl3.spatial_subset
  USING btree
  (source_id,origin_id,"TIME");
