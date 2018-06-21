--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.3 (Ubuntu 10.3-1.pgdg16.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: sites; Type: TABLE; Schema: infrastructure; Owner: postgres
--

CREATE TABLE infrastructure.sites (
    pkey bigint NOT NULL,
    name character varying(50),
    tags json,
    the_geom public.geometry(PointZ,4326) NOT NULL
);


ALTER TABLE infrastructure.sites OWNER TO postgres;

--
-- Name: sites_pkey_seq; Type: SEQUENCE; Schema: infrastructure; Owner: postgres
--

CREATE SEQUENCE infrastructure.sites_pkey_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE infrastructure.sites_pkey_seq OWNER TO postgres;

--
-- Name: sites_pkey_seq; Type: SEQUENCE OWNED BY; Schema: infrastructure; Owner: postgres
--

ALTER SEQUENCE infrastructure.sites_pkey_seq OWNED BY infrastructure.sites.pkey;


--
-- Name: sites pkey; Type: DEFAULT; Schema: infrastructure; Owner: postgres
--

ALTER TABLE ONLY infrastructure.sites ALTER COLUMN pkey SET DEFAULT nextval('infrastructure.sites_pkey_seq'::regclass);


--
-- Data for Name: sites; Type: TABLE DATA; Schema: infrastructure; Owner: postgres
--

INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (3, 'G54', '{"site": "G54", "basin": "NNRC"}', '01010000A0E6100000E512F236B50E54C0F416F93A49183A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (4, 'G56', '{"site": "G56", "basin": "HILLS"}', '01010000A0E61000005DB2042C4C0754C07500B903C5523A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (5, 'G57', '{"site": "G57", "basin": "C14"}', '01010000A0E61000009D767CA4D60754C04D94970F1B3B3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (6, 'S124', '{"site": "S124", "basin": "NNRC"}', '01010000A0E61000008FCC1B0E681754C0F991F3E01A213A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (7, 'S125', '{"site": "S125", "basin": "C13"}', '01010000A0E6100000A0C0CA8B111354C0F894D6BE042A3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (8, 'S13', '{"site": "S13", "basin": "C11"}', '01010000A0E610000020A9F02D5D0D54C0E8137992F4103A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (9, 'S13AW', '{"site": "S13AW", "basin": "C11"}', '01010000A0E61000005341CCF6031254C040394F1587103A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (10, 'S29', '{"site": "S29", "basin": "C9"}', '01010000A0E6100000677C5402B20954C07B91173BDEED39400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (11, 'S30', '{"site": "S30", "basin": "C9"}', '01010000A0E6100000BF7F7A04991B54C0412DDAA6F1F439400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (12, 'S33', '{"site": "S33", "basin": "C12"}', '01010000A0E6100000B572110B720C54C0B7E36BA3C4223A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (13, 'S34', '{"site": "S34", "basin": "NNRC"}', '01010000A0E6100000384C81BE4B1C54C09432B4FB05263A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (14, 'S36', '{"site": "S36", "basin": "C13"}', '01010000A0E610000037E50AEF720B54C06D5D36AB542C3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (15, 'S37A', '{"site": "S37A", "basin": "C14"}', '01010000A0E61000002C8ECFD56C0854C0A1CBF0AAC8343A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (16, 'S37B', '{"site": "S37B", "basin": "C14"}', '01010000A0E61000005B6218BEE70A54C09D97D70344393A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (17, 'S38', '{"site": "S38", "basin": "C14"}', '01010000A0E6100000D46A406B1B1354C05D182B62BF3A3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (18, 'S381', '{"site": "S381", "basin": "C11"}', '01010000A0E6100000F98D65B0D81A54C03C27C5E0C40F3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (19, 'S39', '{"site": "S39", "basin": "HILLS"}', '01010000A0E6100000555D9A350B1354C0BC77C93E185B3A400000000000000000');
INSERT INTO infrastructure.sites (pkey, name, tags, the_geom) VALUES (20, 'S9', '{"site": "S9", "basin": "C11"}', '01010000A0E61000001BD82AC1621C54C018E4123CC40F3A400000000000000000');


--
-- Name: sites_pkey_seq; Type: SEQUENCE SET; Schema: infrastructure; Owner: postgres
--

SELECT pg_catalog.setval('infrastructure.sites_pkey_seq', 20, true);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: infrastructure; Owner: postgres
--

ALTER TABLE ONLY infrastructure.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (pkey);


--
-- PostgreSQL database dump complete
--

