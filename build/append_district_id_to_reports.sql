-- Appends new district ID to report properties of existing reports (Indonesia only)

-- Set district_id null across all reports
UPDATE cognicity.all_reports SET tags = b.tags FROM (SELECT tags::jsonb || '{"district_id":"null"}'::jsonb as tags, pkey from cognicity.all_reports) AS b WHERE cognicity.all_reports.pkey = b.pkey;

-- Set district_id based on local_area
UPDATE cognicity.all_reports SET tags = b.tags FROM (SELECT tags::jsonb || ('{"district_id":' || j.district_id::varchar || '}')::jsonb as tags, i.pkey from cognicity.all_reports i, cognicity.local_areas j WHERE ST_WITHIN(i.the_geom, j.the_geom) ) AS b WHERE cognicity.all_reports.pkey = b.pkey;
