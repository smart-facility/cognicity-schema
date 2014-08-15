--Get count of unconfirmed reports
INSERT INTO rw_count_reports_unconfirmed(rw_pkey, count, start_time, end_time) 
SELECT p1.pkey, COALESCE(count.count,0), '2014-02-12 16:00:00 ICT'::TIMESTAMP WITH TIME ZONE, '2014-02-12 22:00:00 ICT'::TIMESTAMP WITH TIME ZONE FROM jkt_rw_boundary AS p1 
		LEFT OUTER JOIN(
			SELECT b.pkey, count(a.pkey) FROM unconfirmed_reports a, jkt_rw_boundary b
			WHERE ST_WITHIN(a.the_geom, b.the_geom)
			AND a.created_at AT TIME ZONE 'ICT' > '2014-02-12 16:00' AT TIME ZONE 'ICT'
			AND a.created_at AT TIME ZONE 'ICT' < '2014-02-12 22:00' AT TIME ZONE 'ICT'
			 GROUP BY b.pkey) as count 
		ON (p1.pkey = count.pkey);
--Get count of confirmed reports
INSERT INTO rw_count_reports_confirmed(rw_pkey, count, start_time, end_time) 
SELECT p1.pkey, COALESCE(count.count,0), '2014-02-12 16:00:00 ICT'::TIMESTAMP WITH TIME ZONE, '2014-02-12 22:00:00 ICT'::TIMESTAMP WITH TIME ZONE FROM jkt_rw_boundary AS p1 
		LEFT OUTER JOIN(
			SELECT b.pkey, count(a.pkey) FROM reports a, jkt_rw_boundary b
			WHERE ST_WITHIN(a.the_geom, b.the_geom)
			AND a.created_at AT TIME ZONE 'ICT' > '2014-02-12 16:00' AT TIME ZONE 'ICT'
			AND a.created_at AT TIME ZONE 'ICT' < '2014-02-12 22:00' AT TIME ZONE 'ICT'
			 GROUP BY b.pkey) as count 
		ON (p1.pkey = count.pkey);