CREATE DATABASE cognicity
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;

 -- Spatial extensions
 CREATE EXTENSION postgis;
 CREATE EXTENSION postgis_topology;


 -- Create table to store id of last seen tweet id as captured using GNIP
 CREATE TABLE seen_tweet_id (onerow_id bool PRIMARY KEY DEFAULT TRUE, id bigint, CONSTRAINT onerow_uni CHECK (onerow_ID));
 INSERT INTO seen_tweet_id VALUES (TRUE, 0);
