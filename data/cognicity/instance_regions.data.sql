-- Instance regions for PetaBencana.id 2016
-- Refer to https://github.com/urbanriskmap/urbanriskmap-meta/wiki/Bounding-Boxes-for-Target-Cities
INSERT INTO cognicity.instance_regions (code, name, the_geom) VALUES ('jbd', 'Jabodetabek', ST_GeomFromText('POLYGON((106.480 -6.733, 107.175 -6.733, 107.175 -5.880, 106.480 -5.880, 106.480 -6.733))',4326)),
('bdg', 'Bandung', ST_GeomFromText('POLYGON((107.369 -7.165, 107.931 -7.165, 107.931 -6.668, 107.369 -6.668, 107.369 -7.165))',4326)),
('sby', 'Surabaya', ST_GeomFromText('POLYGON((112.3975 -7.5499, 113.0318 -7.5499, 113.0318 -7.0143, 112.3975 -7.0143, 112.3975 -7.5499))',4326)),
('chn', 'Chennai', ST_GeomFromText('POLYGON((80.585 12.889,80.255 12.956,80.243 12.959,80.235 12.975,80.219 12.965,80.2 12.98,80.201 12.991,80.187 13.001,80.188 13.007,80.198 13.012,80.174 13.014,80.17 13.034,80.173 13.061,80.184 13.075,80.18 13.09,80.181 13.094,80.19 13.112,80.23 13.113,80.229 13.127,80.24 13.133,80.25 13.126,80.298 13.127,80.619 13.073,80.585 12.889))', 4326));
