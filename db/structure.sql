--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: calendar_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendar_events (
    id integer NOT NULL,
    eventable_id integer NOT NULL,
    eventable_type character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    title text NOT NULL,
    description text,
    location text,
    attendee_email_addresses character varying(255)[],
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    all_day boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: calendar_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendar_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendar_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calendar_events_id_seq OWNED BY calendar_events.id;


--
-- Name: calls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calls (
    id integer NOT NULL,
    phone_id integer NOT NULL,
    uid character varying(255) NOT NULL,
    call_type character varying(255) NOT NULL,
    phone_number character varying(255) NOT NULL,
    clean_phone_number character varying(255) NOT NULL,
    duration integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: calls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calls_id_seq OWNED BY calls.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    contactable_id integer NOT NULL,
    contactable_type character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    full_name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: email_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_addresses (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    email_address character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_addresses_id_seq OWNED BY email_addresses.id;


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phone_numbers (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    phone_number character varying(255) NOT NULL,
    clean_phone_number character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phone_numbers_id_seq OWNED BY phone_numbers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sources (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying(255) NOT NULL,
    provider character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    queued_for_destruction boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_synchronizeds hstore,
    email_address character varying(255),
    access_token character varying(255),
    access_secret character varying(255),
    context_io_source_label character varying(255)
);


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sources_id_seq OWNED BY sources.id;


--
-- Name: text_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE text_messages (
    id integer NOT NULL,
    phone_id integer NOT NULL,
    uid character varying(255) NOT NULL,
    text_message_type character varying(255) NOT NULL,
    thread_id character varying(255) NOT NULL,
    phone_number character varying(255) NOT NULL,
    clean_phone_number character varying(255) NOT NULL,
    body text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: text_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE text_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: text_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE text_messages_id_seq OWNED BY text_messages.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email_address character varying(255) NOT NULL,
    password_digest character varying(255) NOT NULL,
    context_io_account_id character varying(255) NOT NULL,
    context_io_web_hook_id character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    time_zone character varying(255) DEFAULT 'Eastern Time (US & Canada)'::character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendar_events ALTER COLUMN id SET DEFAULT nextval('calendar_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY calls ALTER COLUMN id SET DEFAULT nextval('calls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_addresses ALTER COLUMN id SET DEFAULT nextval('email_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phone_numbers ALTER COLUMN id SET DEFAULT nextval('phone_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources ALTER COLUMN id SET DEFAULT nextval('sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY text_messages ALTER COLUMN id SET DEFAULT nextval('text_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendar_events
    ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: calls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calls
    ADD CONSTRAINT calls_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: text_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY text_messages
    ADD CONSTRAINT text_messages_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_calendar_events_on_eventable_id_and_eventable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calendar_events_on_eventable_id_and_eventable_type ON calendar_events USING btree (eventable_id, eventable_type);


--
-- Name: index_calendar_events_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calendar_events_on_uid ON calendar_events USING btree (uid);


--
-- Name: index_calls_on_clean_phone_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calls_on_clean_phone_number ON calls USING btree (clean_phone_number);


--
-- Name: index_calls_on_phone_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calls_on_phone_id ON calls USING btree (phone_id);


--
-- Name: index_calls_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calls_on_uid ON calls USING btree (uid);


--
-- Name: index_contacts_on_contactable_id_and_contactable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_contactable_id_and_contactable_type ON contacts USING btree (contactable_id, contactable_type);


--
-- Name: index_contacts_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_uid ON contacts USING btree (uid);


--
-- Name: index_email_addresses_on_contact_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_addresses_on_contact_id ON email_addresses USING btree (contact_id);


--
-- Name: index_email_addresses_on_email_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_addresses_on_email_address ON email_addresses USING btree (email_address);


--
-- Name: index_phone_numbers_on_clean_phone_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_phone_numbers_on_clean_phone_number ON phone_numbers USING btree (clean_phone_number);


--
-- Name: index_phone_numbers_on_contact_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_phone_numbers_on_contact_id ON phone_numbers USING btree (contact_id);


--
-- Name: index_sources_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_type ON sources USING btree (type);


--
-- Name: index_sources_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_uid_and_provider ON sources USING btree (uid, provider);


--
-- Name: index_text_messages_on_clean_phone_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_text_messages_on_clean_phone_number ON text_messages USING btree (clean_phone_number);


--
-- Name: index_text_messages_on_phone_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_text_messages_on_phone_id ON text_messages USING btree (phone_id);


--
-- Name: index_text_messages_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_text_messages_on_uid ON text_messages USING btree (uid);


--
-- Name: index_users_on_email_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email_address ON users USING btree (email_address);


--
-- Name: sources_last_synchronizeds; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sources_last_synchronizeds ON sources USING gin (last_synchronizeds);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120710221226');

INSERT INTO schema_migrations (version) VALUES ('20120711020035');

INSERT INTO schema_migrations (version) VALUES ('20120711030743');

INSERT INTO schema_migrations (version) VALUES ('20120711032726');

INSERT INTO schema_migrations (version) VALUES ('20120711033725');

INSERT INTO schema_migrations (version) VALUES ('20120711033757');

INSERT INTO schema_migrations (version) VALUES ('20120712183051');

INSERT INTO schema_migrations (version) VALUES ('20120712183312');

INSERT INTO schema_migrations (version) VALUES ('20120712183357');

INSERT INTO schema_migrations (version) VALUES ('20120712215540');

INSERT INTO schema_migrations (version) VALUES ('20120712220508');

INSERT INTO schema_migrations (version) VALUES ('20120712221319');

INSERT INTO schema_migrations (version) VALUES ('20120716223712');