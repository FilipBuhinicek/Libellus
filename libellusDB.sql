--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying,
    biography text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_id_seq OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    published_year integer,
    description text,
    book_type character varying DEFAULT 'fiction'::character varying NOT NULL,
    copies_available integer,
    author_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: borrowings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrowings (
    id bigint NOT NULL,
    borrow_date date NOT NULL,
    return_date date,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    due_date date NOT NULL
);


ALTER TABLE public.borrowings OWNER TO postgres;

--
-- Name: borrowings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.borrowings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.borrowings_id_seq OWNER TO postgres;

--
-- Name: borrowings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.borrowings_id_seq OWNED BY public.borrowings.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    sent_date date NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    id bigint NOT NULL,
    reservation_date date NOT NULL,
    expiration_date date NOT NULL,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservations_id_seq OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    type character varying,
    employment_date date,
    membership_start date,
    membership_end date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    termination_date date,
    password_digest character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: borrowings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings ALTER COLUMN id SET DEFAULT nextval('public.borrowings_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-05-12 17:34:29.230186	2025-05-12 17:34:29.23019
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (id, first_name, last_name, biography, created_at, updated_at) FROM stdin;
1	J.K.	Rowling	Britanska autorica najpoznatija po seriji o Harryju Potteru.	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
2	George	Orwell	Engleski pisac najpoznatiji po knjigama "1984" i "Životinjska farma".	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
3	Jane	Austen	Engleska književnica poznata po romanima koji istražuju britansko društvo i ljubavnu dinamiku.	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
4	Mark	Twain	Američki pisac, humorist i novinar poznat po romanima "The Adventures of Huckleberry Finn" i "Tom Sawyer".	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
5	Ernest	Hemingway	Američki pisac poznat po jednostavnom stilu i dubokim temama o ratovima i životu.	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
6	Leo	Tolstoy	Ruski pisac poznat po djelima 'Rat i mir' i 'Ana Karenjina'.	2025-05-13 16:25:24.798863	2025-05-13 16:25:24.798863
7	Filip	Dev	This is a short bio	2025-05-18 09:43:14.770835	2025-05-18 09:43:14.770835
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, title, published_year, description, book_type, copies_available, author_id, created_at, updated_at) FROM stdin;
1	Harry Potter and the Philosopher's Stone	1997	Prvi dio serije o Harryju Potteru koji istražuje svijet čarobnjaka.	fiction	5	1	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
2	1984	1949	Društvena kritika totalitarnih režima kroz distopijsku budućnost.	fiction	3	2	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
3	Pride and Prejudice	1813	Roman o ljubavi i društvenim normama iz perioda engleskog regentstva.	fiction	4	3	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
4	The Adventures of Huckleberry Finn	1884	Roman o odrastanju i prijateljstvu na rijeci Mississippi.	fiction	6	4	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
5	The Old Man and the Sea	1952	Priča o borbi starca s ogromnom ribom u otvorenom moru.	fiction	2	5	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812
6	1984	1984	desc	fiction	5	\N	2025-05-18 09:45:02.723709	2025-05-18 09:45:02.723709
7	1984	1984	desc	fiction	5	1	2025-05-18 09:46:43.558997	2025-05-18 09:46:43.558997
\.


--
-- Data for Name: borrowings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.borrowings (id, borrow_date, return_date, user_id, book_id, created_at, updated_at, due_date) FROM stdin;
1	2024-03-15	2024-03-22	1	1	2025-05-13 18:13:15.653289	2025-05-13 18:13:15.653289	2024-03-22
2	2024-02-20	2024-02-27	2	3	2025-05-13 18:13:15.653289	2025-05-13 18:13:15.653289	2024-02-27
3	2024-01-10	2024-01-17	3	2	2025-05-13 18:13:15.653289	2025-05-13 18:13:15.653289	2024-01-17
4	2024-04-01	2024-04-08	4	4	2025-05-13 18:13:15.653289	2025-05-13 18:13:15.653289	2024-04-08
5	2024-03-10	2024-03-17	5	5	2025-05-13 18:13:15.653289	2025-05-13 18:13:15.653289	2024-03-17
6	2025-05-15	\N	1	1	2025-05-18 09:49:20.128455	2025-05-18 09:49:20.128455	2025-05-25
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, title, content, sent_date, user_id, created_at, updated_at) FROM stdin;
1	Nova knjiga u ponudi	Knjiga "1984" Georgea Orwella sada je dostupna za posudbu!	2024-04-04	1	2025-05-13 18:14:16.195656	2025-05-13 18:14:16.195656
2	Povratak knjige	Molimo Vas da vratite knjigu "Pride and Prejudice" najkasnije do 2024-02-27.	2024-02-22	2	2025-05-13 18:14:16.195656	2025-05-13 18:14:16.195656
3	Obavijest o kašnjenju	Vaša posudba "The Adventures of Huckleberry Finn" je zakasnila. Molimo Vas da je vratite što je prije moguce.	2024-04-03	3	2025-05-13 18:14:16.195656	2025-05-13 18:14:16.195656
4	Novost u knjiznici	U knjiznici je dostupna nova knjiga: "The Old Man and the Sea" Ernesta Hemingwaya.	2024-03-31	4	2025-05-13 18:14:16.195656	2025-05-13 18:14:16.195656
5	Rok za povratak	Sjetite se da je rok za povratak knjige "The Old Man and the Sea" 2024-03-17.	2024-03-12	5	2025-05-13 18:14:16.195656	2025-05-13 18:14:16.195656
6	Title	Content	2025-05-15	1	2025-05-18 09:51:47.013374	2025-05-18 09:51:47.013374
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (id, reservation_date, expiration_date, user_id, book_id, created_at, updated_at) FROM stdin;
1	2024-04-05	2024-04-09	1	2	2025-05-13 18:13:43.601076	2025-05-13 18:13:43.601076
2	2024-04-06	2024-04-10	3	1	2025-05-13 18:13:43.601076	2025-05-13 18:13:43.601076
3	2024-03-30	2024-04-03	2	4	2025-05-13 18:13:43.601076	2025-05-13 18:13:43.601076
4	2024-04-02	2024-04-06	4	3	2025-05-13 18:13:43.601076	2025-05-13 18:13:43.601076
5	2024-04-01	2024-04-05	5	5	2025-05-13 18:13:43.601076	2025-05-13 18:13:43.601076
6	2025-05-15	2025-05-25	1	1	2025-05-18 09:50:15.348348	2025-05-18 09:50:15.348348
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20250512162730
20250512163525
20250512163555
20250512163556
20250512163605
20250512163606
20250513153600
20250513154117
20250513155038
20250514160547
20250514162032
20250514163223
20250517205927
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, type, employment_date, membership_start, membership_end, created_at, updated_at, termination_date, password_digest) FROM stdin;
1	Filip	Marković	filip.markovic@example.com	Member	\N	2023-05-12	2025-05-12	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812	\N	\N
2	Ana	Ivić	ana.ivic@example.com	Librarian	2023-04-22	\N	\N	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812	\N	\N
3	Luka	Jurić	luka.juric@example.com	Member	\N	2022-09-15	2025-09-15	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812	\N	\N
4	Ivana	Kovač	ivana.kovac@example.com	Librarian	2023-01-10	\N	\N	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812	\N	\N
5	Tomislav	Soldo	tomislav.soldo@example.com	Member	\N	2021-06-05	2026-06-05	2025-05-13 18:09:40.031812	2025-05-13 18:09:40.031812	\N	\N
6	Ana	Ivic	ana.ivic@gmail.com	Member	\N	\N	\N	2025-05-13 16:40:07.413685	2025-05-13 16:40:07.413685	\N	\N
7	Ana	Horvat	ana.horvat@example.com	Librarian	2024-01-01	\N	\N	2025-05-14 16:29:56.137489	2025-05-14 16:29:56.137489	\N	$2a$12$/VX9n7dW9bm8SRmmLg8rnOGo1Qwmj4/keZIwQ8MVOp4MMhB.QCfz2
8	Ivan	Ivić	ivan.ivic@example.com	Librarian	2024-02-02	\N	\N	2025-05-14 16:30:20.245185	2025-05-14 16:30:20.245185	\N	$2a$12$c7SxTXhUhgphDp7x5k9HN.jUM5etuPzuexlD7ZSHr.8R1ZmHzAMK.
9	Filip	Dev	filip.dev@example.com	Librarian	2024-03-01	\N	\N	2025-05-14 16:46:43.592279	2025-05-14 16:46:43.592279	\N	$2a$12$Pcp/61O15UL1FgTnaoLdHOc9Y7hZamG/A8ezXyAySMwRUkwUKhOGe
10	Filip	Member	filip.member@example.com	Member	\N	2024-03-01	\N	2025-05-14 17:51:51.857295	2025-05-14 17:51:51.857295	\N	$2a$12$bpg41Zc/ourcCgrue7/5U.9A5sAX0BEqhcTeX2y99dMASXDrgaw6q
11	Filip	Member	filip.mem@example.com	Member	\N	2024-03-01	\N	2025-05-14 17:54:45.18921	2025-05-14 17:54:45.18921	\N	$2a$12$WHLGJ9xf.RL3brzFU0kyA.5hqXD3Rmp04fL.0GH4bySGFr/OrUoKW
\.


--
-- Name: authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_id_seq', 7, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 7, true);


--
-- Name: borrowings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.borrowings_id_seq', 6, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 6, true);


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservations_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: borrowings borrowings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT borrowings_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_books_on_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_books_on_author_id ON public.books USING btree (author_id);


--
-- Name: index_borrowings_on_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_borrowings_on_book_id ON public.borrowings USING btree (book_id);


--
-- Name: index_borrowings_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_borrowings_on_user_id ON public.borrowings USING btree (user_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_reservations_on_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_on_book_id ON public.reservations USING btree (book_id);


--
-- Name: index_reservations_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reservations_on_user_id ON public.reservations USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: borrowings fk_rails_2d6421032c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT fk_rails_2d6421032c FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: reservations fk_rails_48a92fce51; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT fk_rails_48a92fce51 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: books fk_rails_53d51ce16a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_rails_53d51ce16a FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: borrowings fk_rails_64d35f133d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrowings
    ADD CONSTRAINT fk_rails_64d35f133d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notifications fk_rails_b080fb4855; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reservations fk_rails_bff51a5a6e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT fk_rails_bff51a5a6e FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- PostgreSQL database dump complete
--

