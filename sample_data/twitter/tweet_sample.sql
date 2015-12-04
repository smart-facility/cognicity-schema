INSERT INTO tweet_reports (created_at, text, text_urls, user_mentions, lang, url, the_geom) VALUES ('2015-10-26 16:05:48.406729+11','Tenang, Banjir pasti berlalu RT " @tvOneNews: Poling KHI: Jokowi Galau Soal Banjir Jakarta http://t.co/O6pRyhzPoz"','[{"url":"http://t.co/O6pRyhzPoz","expanded_url":"http://bit.ly/190uacd","display_url":"bit.ly/190uacd","indices":[91,113]}]','[{"screen_name":"tvOneNews","name":"tvOneNews","id":55507370,"id_str":"55507370","indices":[34,44]}]','id','https://twitter.com/iHolderness/status/654861870344462336','0101000020E6100000E85C9BD7A2A95A401478279F1EB318C0');
SELECT upsert_tweet_users(md5('jack'));
--Now insert another tweet but simulate change status to verified by government
INSERT INTO tweet_reports
  (created_at, text, text_urls, user_mentions, lang, url, the_geom)
  VALUES ('2015-10-26 16:05:48.406729+11','Tenang, Banjir pasti berlalu RT " @tvOneNews: Poling KHI: Jokowi Galau Soal Banjir Jakarta http://t.co/O6pRyhzPoz"','[{"url":"http://t.co/O6pRyhzPoz","expanded_url":"http://bit.ly/190uacd","display_url":"bit.ly/190uacd","indices":[91,113]}]','[{"screen_name":"tvOneNews","name":"tvOneNews","id":55507370,"id_str":"55507370","indices":[34,44]}]','id','https://twitter.com/iHolderness/status/654861870344462336',ST_GeomFromText('POINT(-6.157046 106.831578)',4326));

UPDATE all_reports SET status = 'verified' WHERE pkey = (SELECT pkey FROM all_reports ORDER BY pkey DESC LIMIT 1);
