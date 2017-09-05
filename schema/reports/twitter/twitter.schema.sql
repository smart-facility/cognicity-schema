-- Schema for Twitter/PowerTrack Data
CREATE SCHEMA twitter;

 -- Create table to store id of last seen tweet id as captured using GNIP
 CREATE TABLE twitter.seen_tweet_id (onerow_id bool PRIMARY KEY DEFAULT TRUE, id bigint, CONSTRAINT onerow_uni CHECK (onerow_ID));

-- Create table to anonymously track invited users
CREATE TABLE twitter.invitees
(
 pkey bigserial,
 user_hash character varying UNIQUE,
 CONSTRAINT pkey_tweet_invitees PRIMARY KEY (pkey)
);
