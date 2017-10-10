-- Instance regions for RiskMap.in 2017

INSERT INTO cognicity.instance_regions (code, name, the_geom) VALUES ('mum', 'Mumbai', ST_GeomFromText('POLYGON((72.7036 19.2975, 73.0953 19.2975, 73.09532 18.8600, 72.7036 18.8600, 72.7036 19.2975))',4326)),
('blr', 'Bengaluru', ST_GeomFromText('POLYGON((77.3670 13.2011, 77.8663 13.2001, 77.8642 12.7594, 77.3649 12.7626, 77.3670 13.2011))',4326)),
('chn', 'Chennai', ST_GeomFromText('POLYGON((80.0529 13.3150, 80.4241 13.3150, 80.4241 12.8042, 80.0529 12.8042, 80.0529 13.3150))',4326));
