--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2025-05-20 18:44:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 851 (class 1247 OID 519381)
-- Name: uloga_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.uloga_enum AS ENUM (
    'clan',
    'knjiznicar'
);


ALTER TYPE public.uloga_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 519386)
-- Name: autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autor (
    id_autora integer NOT NULL,
    ime character varying(100) NOT NULL,
    prezime character varying(100) NOT NULL,
    biografija character varying(300)
);


ALTER TABLE public.autor OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 519385)
-- Name: autor_id_autora_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.autor_id_autora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.autor_id_autora_seq OWNER TO postgres;

--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 215
-- Name: autor_id_autora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.autor_id_autora_seq OWNED BY public.autor.id_autora;


--
-- TOC entry 220 (class 1259 OID 519404)
-- Name: knjiga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knjiga (
    id_knjige integer NOT NULL,
    naslov character varying(255) NOT NULL,
    autor_id integer,
    tip_knjige integer NOT NULL,
    broj_primjeraka integer NOT NULL,
    godina_izdanja date,
    opis character varying(255)
);


ALTER TABLE public.knjiga OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 519403)
-- Name: knjiga_id_knjige_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.knjiga_id_knjige_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.knjiga_id_knjige_seq OWNER TO postgres;

--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 219
-- Name: knjiga_id_knjige_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.knjiga_id_knjige_seq OWNED BY public.knjiga.id_knjige;


--
-- TOC entry 218 (class 1259 OID 519395)
-- Name: korisnik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.korisnik (
    id_korisnika integer NOT NULL,
    ime character varying(100) NOT NULL,
    prezime character varying(100) NOT NULL,
    email character varying(255),
    datum_registracije date,
    uloga public.uloga_enum,
    datum_upisa date,
    kraj_clanarine date,
    datum_zaposlenja date
);


ALTER TABLE public.korisnik OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 519394)
-- Name: korisnik_id_korisnika_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.korisnik_id_korisnika_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.korisnik_id_korisnika_seq OWNER TO postgres;

--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 217
-- Name: korisnik_id_korisnika_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.korisnik_id_korisnika_seq OWNED BY public.korisnik.id_korisnika;


--
-- TOC entry 226 (class 1259 OID 519452)
-- Name: obavijest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obavijest (
    id_obavijesti integer NOT NULL,
    id_korisnika integer,
    naslov character varying(255),
    sadrzaj character varying(255),
    datum_slanja date
);


ALTER TABLE public.obavijest OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 519451)
-- Name: obavijest_id_obavijesti_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.obavijest_id_obavijesti_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.obavijest_id_obavijesti_seq OWNER TO postgres;

--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 225
-- Name: obavijest_id_obavijesti_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.obavijest_id_obavijesti_seq OWNED BY public.obavijest.id_obavijesti;


--
-- TOC entry 222 (class 1259 OID 519418)
-- Name: posudba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posudba (
    id_posudbe integer NOT NULL,
    id_korisnika integer,
    id_knjige integer,
    datum_posudbe date NOT NULL,
    datum_povratka date NOT NULL,
    kasnjenje boolean
);


ALTER TABLE public.posudba OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 519417)
-- Name: posudba_id_posudbe_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posudba_id_posudbe_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posudba_id_posudbe_seq OWNER TO postgres;

--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 221
-- Name: posudba_id_posudbe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posudba_id_posudbe_seq OWNED BY public.posudba.id_posudbe;


--
-- TOC entry 224 (class 1259 OID 519435)
-- Name: rezervacija; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezervacija (
    id_rezervacije integer NOT NULL,
    id_korisnika integer,
    id_knjige integer,
    datum_rezervacije date NOT NULL,
    datum_isteka_rezervacije date NOT NULL
);


ALTER TABLE public.rezervacija OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 519434)
-- Name: rezervacija_id_rezervacije_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervacija_id_rezervacije_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rezervacija_id_rezervacije_seq OWNER TO postgres;

--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 223
-- Name: rezervacija_id_rezervacije_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervacija_id_rezervacije_seq OWNED BY public.rezervacija.id_rezervacije;


--
-- TOC entry 4716 (class 2604 OID 519389)
-- Name: autor id_autora; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor ALTER COLUMN id_autora SET DEFAULT nextval('public.autor_id_autora_seq'::regclass);


--
-- TOC entry 4718 (class 2604 OID 519407)
-- Name: knjiga id_knjige; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knjiga ALTER COLUMN id_knjige SET DEFAULT nextval('public.knjiga_id_knjige_seq'::regclass);


--
-- TOC entry 4717 (class 2604 OID 519398)
-- Name: korisnik id_korisnika; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.korisnik ALTER COLUMN id_korisnika SET DEFAULT nextval('public.korisnik_id_korisnika_seq'::regclass);


--
-- TOC entry 4721 (class 2604 OID 519455)
-- Name: obavijest id_obavijesti; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obavijest ALTER COLUMN id_obavijesti SET DEFAULT nextval('public.obavijest_id_obavijesti_seq'::regclass);


--
-- TOC entry 4719 (class 2604 OID 519421)
-- Name: posudba id_posudbe; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posudba ALTER COLUMN id_posudbe SET DEFAULT nextval('public.posudba_id_posudbe_seq'::regclass);


--
-- TOC entry 4720 (class 2604 OID 519438)
-- Name: rezervacija id_rezervacije; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervacija ALTER COLUMN id_rezervacije SET DEFAULT nextval('public.rezervacija_id_rezervacije_seq'::regclass);


--
-- TOC entry 4886 (class 0 OID 519386)
-- Dependencies: 216
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autor (id_autora, ime, prezime, biografija) FROM stdin;
1	J.K.	Rowling	Britanska autorica najpoznatija po seriji o Harryju Potteru.
2	George	Orwell	Engleski pisac najpoznatiji po svojim knjigama "1984" i "Zivotinjska farma".
3	Jane	Austen	Engleska knjizevnica poznata po romanima koji istrazuju britansko drustvo i ljubavnu dinamiku.
4	Mark	Twain	Americki pisac, humorist i novinar poznat po romanima "The Adventures of Huckleberry Finn" i "Tom Sawyer".
5	Ernest	Hemingway	Americki pisac poznat po jednostavnom stilu pisanja i dubokim temama o ratovima i zivotu.
6	J.K.	Rowling	Britanska autorica najpoznatija po seriji o Harryju Potteru.
7	George	Orwell	Engleski pisac najpoznatiji po svojim knjigama "1984" i "Zivotinjska farma".
8	Jane	Austen	Engleska knjizevnica poznata po romanima koji istrazuju britansko drustvo i ljubavnu dinamiku.
9	Mark	Twain	Americki pisac, humorist i novinar poznat po romanima "The Adventures of Huckleberry Finn" i "Tom Sawyer".
10	Ernest	Hemingway	Americki pisac poznat po jednostavnom stilu pisanja i dubokim temama o ratovima i zivotu.
\.


--
-- TOC entry 4890 (class 0 OID 519404)
-- Dependencies: 220
-- Data for Name: knjiga; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.knjiga (id_knjige, naslov, autor_id, tip_knjige, broj_primjeraka, godina_izdanja, opis) FROM stdin;
1	Harry Potter and the Philosophers Stone	1	1	5	1997-06-26	Prvi dio serije o Harryju Potteru koji istrazuje svijet carobnjaka.
2	1984	2	1	3	1949-06-08	DruÅ¡tvena kritika totalitarnih rezima kroz distopijsku buducnost.
3	Pride and Prejudice	3	1	4	1813-01-28	Roman o ljubavi i druÅ¡tvenim normama iz perioda engleskog regentstva.
4	The Adventures of Huckleberry Finn	4	1	6	1884-12-10	Roman o odrastanju i prijateljstvu na rijeci Mississippi.
5	The Old Man and the Sea	5	1	2	1952-09-01	Prica o borbi starca s ogromnom ribom u otvorenom moru.
6	Harry Potter and the Philosophers Stone	1	1	5	1997-06-26	Prvi dio serije o Harryju Potteru koji istrazuje svijet carobnjaka.
7	1984	2	1	3	1949-06-08	DruÅ¡tvena kritika totalitarnih rezima kroz distopijsku buducnost.
8	Pride and Prejudice	3	1	4	1813-01-28	Roman o ljubavi i druÅ¡tvenim normama iz perioda engleskog regentstva.
9	The Adventures of Huckleberry Finn	4	1	6	1884-12-10	Roman o odrastanju i prijateljstvu na rijeci Mississippi.
10	The Old Man and the Sea	5	1	2	1952-09-01	Prica o borbi starca s ogromnom ribom u otvorenom moru.
\.


--
-- TOC entry 4888 (class 0 OID 519395)
-- Dependencies: 218
-- Data for Name: korisnik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.korisnik (id_korisnika, ime, prezime, email, datum_registracije, uloga, datum_upisa, kraj_clanarine, datum_zaposlenja) FROM stdin;
1	Filip	Markovic	filip.markovic@example.com	2023-05-12	clan	2023-05-12	2025-05-12	\N
2	Ana	Ivic	ana.ivic@example.com	2023-04-22	knjiznicar	\N	\N	2023-04-22
3	Luka	Juric	luka.juric@example.com	2022-09-15	clan	2022-09-15	2025-09-15	\N
4	Ivana	Kovac	ivana.kovac@example.com	2023-01-10	knjiznicar	\N	\N	2023-01-10
5	Tomislav	Soldo	tomislav.soldo@example.com	2021-06-05	clan	2021-06-05	2026-06-05	\N
\.


--
-- TOC entry 4896 (class 0 OID 519452)
-- Dependencies: 226
-- Data for Name: obavijest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obavijest (id_obavijesti, id_korisnika, naslov, sadrzaj, datum_slanja) FROM stdin;
1	1	Nova knjiga u ponudi	Knjiga "1984" Georgea Orwella sada je dostupna za posudbu!	2024-04-04
2	2	Povratak knjige	Molimo Vas da vratite knjigu "Pride and Prejudice" najkasnije do 2024-02-27.	2024-02-22
3	3	Obavijest o kaÅ¡njenju	VaÅ¡a posudba "The Adventures of Huckleberry Finn" je zakasnila. Molimo Vas da je vratite Å¡to je prije moguce.	2024-04-03
4	4	Novost u knjiznici	U knjiznici je dostupna nova knjiga: "The Old Man and the Sea" Ernesta Hemingwaya.	2024-03-31
5	5	Rok za povratak	Sjetite se da je rok za povratak knjige "The Old Man and the Sea" 2024-03-17.	2024-03-12
6	1	Nova knjiga u ponudi	Knjiga "1984" Georgea Orwella sada je dostupna za posudbu!	2024-04-04
7	2	Povratak knjige	Molimo Vas da vratite knjigu "Pride and Prejudice" najkasnije do 2024-02-27.	2024-02-22
8	3	Obavijest o kaÅ¡njenju	VaÅ¡a posudba "The Adventures of Huckleberry Finn" je zakasnila. Molimo Vas da je vratite Å¡to je prije moguce.	2024-04-03
9	4	Novost u knjiznici	U knjiznici je dostupna nova knjiga: "The Old Man and the Sea" Ernesta Hemingwaya.	2024-03-31
10	5	Rok za povratak	Sjetite se da je rok za povratak knjige "The Old Man and the Sea" 2024-03-17.	2024-03-12
\.


--
-- TOC entry 4892 (class 0 OID 519418)
-- Dependencies: 222
-- Data for Name: posudba; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posudba (id_posudbe, id_korisnika, id_knjige, datum_posudbe, datum_povratka, kasnjenje) FROM stdin;
1	1	1	2024-03-15	2024-03-22	f
2	2	3	2024-02-20	2024-02-27	f
3	3	2	2024-01-10	2024-01-17	f
4	4	4	2024-04-01	2024-04-08	t
5	5	5	2024-03-10	2024-03-17	f
6	1	1	2024-03-15	2024-03-22	f
7	2	3	2024-02-20	2024-02-27	f
8	3	2	2024-01-10	2024-01-17	f
9	4	4	2024-04-01	2024-04-08	t
10	5	5	2024-03-10	2024-03-17	f
\.


--
-- TOC entry 4894 (class 0 OID 519435)
-- Dependencies: 224
-- Data for Name: rezervacija; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezervacija (id_rezervacije, id_korisnika, id_knjige, datum_rezervacije, datum_isteka_rezervacije) FROM stdin;
1	1	2	2024-04-05	2024-04-09
2	3	1	2024-04-06	2024-04-10
3	2	4	2024-03-30	2024-04-03
4	4	3	2024-04-02	2024-04-06
5	5	5	2024-04-01	2024-04-05
\.


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 215
-- Name: autor_id_autora_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.autor_id_autora_seq', 10, true);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 219
-- Name: knjiga_id_knjige_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.knjiga_id_knjige_seq', 10, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 217
-- Name: korisnik_id_korisnika_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.korisnik_id_korisnika_seq', 6, true);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 225
-- Name: obavijest_id_obavijesti_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.obavijest_id_obavijesti_seq', 10, true);


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 221
-- Name: posudba_id_posudbe_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posudba_id_posudbe_seq', 10, true);


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 223
-- Name: rezervacija_id_rezervacije_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervacija_id_rezervacije_seq', 5, true);


--
-- TOC entry 4723 (class 2606 OID 519393)
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (id_autora);


--
-- TOC entry 4729 (class 2606 OID 519411)
-- Name: knjiga knjiga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knjiga
    ADD CONSTRAINT knjiga_pkey PRIMARY KEY (id_knjige);


--
-- TOC entry 4725 (class 2606 OID 519402)
-- Name: korisnik korisnik_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.korisnik
    ADD CONSTRAINT korisnik_email_key UNIQUE (email);


--
-- TOC entry 4727 (class 2606 OID 519400)
-- Name: korisnik korisnik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.korisnik
    ADD CONSTRAINT korisnik_pkey PRIMARY KEY (id_korisnika);


--
-- TOC entry 4735 (class 2606 OID 519459)
-- Name: obavijest obavijest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obavijest
    ADD CONSTRAINT obavijest_pkey PRIMARY KEY (id_obavijesti);


--
-- TOC entry 4731 (class 2606 OID 519423)
-- Name: posudba posudba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posudba
    ADD CONSTRAINT posudba_pkey PRIMARY KEY (id_posudbe);


--
-- TOC entry 4733 (class 2606 OID 519440)
-- Name: rezervacija rezervacija_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervacija
    ADD CONSTRAINT rezervacija_pkey PRIMARY KEY (id_rezervacije);


--
-- TOC entry 4736 (class 2606 OID 519412)
-- Name: knjiga knjiga_autor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knjiga
    ADD CONSTRAINT knjiga_autor_id_fkey FOREIGN KEY (autor_id) REFERENCES public.autor(id_autora);


--
-- TOC entry 4741 (class 2606 OID 519460)
-- Name: obavijest obavijest_id_korisnika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obavijest
    ADD CONSTRAINT obavijest_id_korisnika_fkey FOREIGN KEY (id_korisnika) REFERENCES public.korisnik(id_korisnika);


--
-- TOC entry 4737 (class 2606 OID 519429)
-- Name: posudba posudba_id_knjige_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posudba
    ADD CONSTRAINT posudba_id_knjige_fkey FOREIGN KEY (id_knjige) REFERENCES public.knjiga(id_knjige);


--
-- TOC entry 4738 (class 2606 OID 519424)
-- Name: posudba posudba_id_korisnika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posudba
    ADD CONSTRAINT posudba_id_korisnika_fkey FOREIGN KEY (id_korisnika) REFERENCES public.korisnik(id_korisnika);


--
-- TOC entry 4739 (class 2606 OID 519446)
-- Name: rezervacija rezervacija_id_knjige_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervacija
    ADD CONSTRAINT rezervacija_id_knjige_fkey FOREIGN KEY (id_knjige) REFERENCES public.knjiga(id_knjige);


--
-- TOC entry 4740 (class 2606 OID 519441)
-- Name: rezervacija rezervacija_id_korisnika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervacija
    ADD CONSTRAINT rezervacija_id_korisnika_fkey FOREIGN KEY (id_korisnika) REFERENCES public.korisnik(id_korisnika);


-- Completed on 2025-05-20 18:44:33

--
-- PostgreSQL database dump complete
--

