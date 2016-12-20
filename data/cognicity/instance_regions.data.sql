-- Instance regions for PetaBencana.id 2016
-- Refer to https://github.com/urbanriskmap/urbanriskmap-meta/wiki/Bounding-Boxes-for-Target-Cities
INSERT INTO cognicity.instance_regions (code, name, the_geom) VALUES ('jbd', 'Jabodetabek', ST_GeomFromText('POLYGON((106.480 -6.733, 107.175 -6.733, 107.175 -5.880, 106.480 -5.880, 106.480 -6.733))',4326)),
('bdg', 'Bandung', ST_GeomFromText('POLYGON((107.369 -7.165, 107.931 -7.165, 107.931 -6.668, 107.369 -6.668, 107.369 -7.165))',4326)),
('sby', 'Surabaya', ST_GeomFromText('POLYGON((112.3975 -7.5499, 113.0318 -7.5499, 113.0318 -7.0143, 112.3975 -7.0143, 112.3975 -7.5499))',4326));
