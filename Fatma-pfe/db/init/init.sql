--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-08-08 00:59:32

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 934 (class 1247 OID 16697)
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_role_enum AS ENUM (
    'commercial',
    'admin',
    'bo'
);


ALTER TYPE public.users_role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 267 (class 1259 OID 91344)
-- Name: categorie_client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorie_client (
    id integer NOT NULL,
    nom character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.categorie_client OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 91343)
-- Name: categorie_client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorie_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorie_client_id_seq OWNER TO postgres;

--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 266
-- Name: categorie_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorie_client_id_seq OWNED BY public.categorie_client.id;


--
-- TOC entry 250 (class 1259 OID 34746)
-- Name: categorie_produit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorie_produit (
    id integer NOT NULL,
    nom character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.categorie_produit OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 34745)
-- Name: categorie_produit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorie_produit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorie_produit_id_seq OWNER TO postgres;

--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 249
-- Name: categorie_produit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorie_produit_id_seq OWNED BY public.categorie_produit.id;


--
-- TOC entry 256 (class 1259 OID 42132)
-- Name: circuit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.circuit (
    id integer NOT NULL,
    date date NOT NULL,
    "commercialId" integer
);


ALTER TABLE public.circuit OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 42138)
-- Name: circuit_clients_client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.circuit_clients_client (
    "circuitId" integer NOT NULL,
    "clientId" integer NOT NULL
);


ALTER TABLE public.circuit_clients_client OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 42131)
-- Name: circuit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.circuit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.circuit_id_seq OWNER TO postgres;

--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 255
-- Name: circuit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.circuit_id_seq OWNED BY public.circuit.id;


--
-- TOC entry 218 (class 1259 OID 16402)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id integer NOT NULL,
    commercial_id integer,
    prenom character varying NOT NULL,
    telephone character varying NOT NULL,
    nom character varying NOT NULL,
    email character varying NOT NULL,
    adresse character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    latitude double precision,
    longitude double precision,
    "codeFiscale" character varying,
    importance integer DEFAULT 3 NOT NULL,
    categorie_id integer
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16401)
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_id_seq OWNER TO postgres;

--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 217
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- TOC entry 220 (class 1259 OID 16411)
-- Name: commande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commande (
    id integer NOT NULL,
    prix_total_ttc numeric(10,2) NOT NULL,
    prix_hors_taxe numeric(10,2) NOT NULL,
    "commercialId" integer,
    numero_commande character varying NOT NULL,
    date_creation timestamp without time zone DEFAULT now() NOT NULL,
    statut character varying DEFAULT 'en_attente'::character varying NOT NULL,
    "clientId" integer,
    date_validation timestamp without time zone,
    "promotionId" integer,
    "estModifieParAdmin" boolean DEFAULT false NOT NULL,
    tva double precision NOT NULL,
    motif_rejet character varying
);


ALTER TABLE public.commande OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16410)
-- Name: commande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commande_id_seq OWNER TO postgres;

--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 219
-- Name: commande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commande_id_seq OWNED BY public.commande.id;


--
-- TOC entry 230 (class 1259 OID 16477)
-- Name: facture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facture (
    id integer NOT NULL,
    numero_facture character varying NOT NULL,
    date_emission date NOT NULL,
    montant_total numeric(10,2) NOT NULL,
    commande_id integer
);


ALTER TABLE public.facture OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16476)
-- Name: facture_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facture_id_seq OWNER TO postgres;

--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 229
-- Name: facture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facture_id_seq OWNED BY public.facture.id;


--
-- TOC entry 265 (class 1259 OID 91311)
-- Name: historique_commande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historique_commande (
    id integer NOT NULL,
    "champModifie" character varying NOT NULL,
    "ancienneValeur" character varying NOT NULL,
    "nouvelleValeur" character varying NOT NULL,
    "dateModification" timestamp without time zone DEFAULT now() NOT NULL,
    "vuParCommercial" boolean DEFAULT false NOT NULL,
    "commandeId" integer,
    "modifieParId" integer
);


ALTER TABLE public.historique_commande OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 91310)
-- Name: historique_commande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historique_commande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historique_commande_id_seq OWNER TO postgres;

--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 264
-- Name: historique_commande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historique_commande_id_seq OWNED BY public.historique_commande.id;


--
-- TOC entry 254 (class 1259 OID 34947)
-- Name: ligne_commande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ligne_commande (
    id integer NOT NULL,
    quantite integer NOT NULL,
    commande_id integer,
    produit_id integer,
    total numeric(10,2),
    "prixUnitaire" numeric(10,2),
    "prixUnitaireTTC" numeric(10,2),
    tva numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    "totalHT" numeric(10,2)
);


ALTER TABLE public.ligne_commande OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 34946)
-- Name: ligne_commande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ligne_commande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ligne_commande_id_seq OWNER TO postgres;

--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 253
-- Name: ligne_commande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ligne_commande_id_seq OWNED BY public.ligne_commande.id;


--
-- TOC entry 222 (class 1259 OID 16423)
-- Name: lignecommande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lignecommande (
    id integer NOT NULL,
    commande_id integer,
    quantite integer NOT NULL,
    prix_unitaire double precision NOT NULL,
    produit_id integer NOT NULL,
    total numeric(10,2)
);


ALTER TABLE public.lignecommande OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16422)
-- Name: lignecommande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lignecommande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lignecommande_id_seq OWNER TO postgres;

--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 221
-- Name: lignecommande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lignecommande_id_seq OWNED BY public.lignecommande.id;


--
-- TOC entry 228 (class 1259 OID 16463)
-- Name: objectif; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objectif (
    id integer NOT NULL,
    description text NOT NULL,
    prime double precision NOT NULL,
    user_id integer
);


ALTER TABLE public.objectif OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 33985)
-- Name: objectif_commercial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objectif_commercial (
    id integer NOT NULL,
    "dateDebut" date NOT NULL,
    "dateFin" date NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    mission character varying,
    bonus double precision,
    "categorieProduit" character varying,
    prime double precision DEFAULT '0'::double precision NOT NULL,
    "pourcentageCible" double precision,
    "montantCible" numeric DEFAULT '0'::numeric NOT NULL,
    atteint boolean DEFAULT false NOT NULL,
    ventes numeric DEFAULT '0'::numeric NOT NULL,
    "totalVentes" double precision DEFAULT '0'::double precision NOT NULL,
    "commercialId" integer
);


ALTER TABLE public.objectif_commercial OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 33984)
-- Name: objectif_commercial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.objectif_commercial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.objectif_commercial_id_seq OWNER TO postgres;

--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 245
-- Name: objectif_commercial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.objectif_commercial_id_seq OWNED BY public.objectif_commercial.id;


--
-- TOC entry 227 (class 1259 OID 16462)
-- Name: objectif_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.objectif_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.objectif_id_seq OWNER TO postgres;

--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 227
-- Name: objectif_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.objectif_id_seq OWNED BY public.objectif.id;


--
-- TOC entry 252 (class 1259 OID 34753)
-- Name: produit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produit (
    id integer NOT NULL,
    images text[],
    prix_unitaire numeric(10,2) DEFAULT 0 NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    "categorieId" integer NOT NULL,
    description character varying NOT NULL,
    nom character varying NOT NULL,
    tva numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    colisage integer DEFAULT 1 NOT NULL,
    prix_unitaire_ttc numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    "uniteId" integer NOT NULL
);


ALTER TABLE public.produit OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 34752)
-- Name: produit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produit_id_seq OWNER TO postgres;

--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 251
-- Name: produit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produit_id_seq OWNED BY public.produit.id;


--
-- TOC entry 248 (class 1259 OID 34001)
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id integer NOT NULL,
    titre character varying NOT NULL,
    description text NOT NULL,
    "tauxReduction" double precision NOT NULL,
    "dateDebut" date NOT NULL,
    "dateFin" date NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "promotionId" integer
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 34000)
-- Name: promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_id_seq OWNER TO postgres;

--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 247
-- Name: promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_id_seq OWNED BY public.promotion.id;


--
-- TOC entry 240 (class 1259 OID 17493)
-- Name: raison_visite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.raison_visite (
    id integer NOT NULL,
    nom character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.raison_visite OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17492)
-- Name: raison_visite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.raison_visite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.raison_visite_id_seq OWNER TO postgres;

--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 239
-- Name: raison_visite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.raison_visite_id_seq OWNED BY public.raison_visite.id;


--
-- TOC entry 226 (class 1259 OID 16449)
-- Name: reclamation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reclamation (
    id integer NOT NULL,
    description text NOT NULL,
    sujet character varying NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    status character varying DEFAULT 'ouverte'::character varying NOT NULL,
    "userId" integer,
    "clientId" integer
);


ALTER TABLE public.reclamation OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16448)
-- Name: reclamation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reclamation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reclamation_id_seq OWNER TO postgres;

--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 225
-- Name: reclamation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reclamation_id_seq OWNED BY public.reclamation.id;


--
-- TOC entry 232 (class 1259 OID 16489)
-- Name: reglement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reglement (
    id integer NOT NULL,
    type_reglement_id integer,
    mode_paiement character varying NOT NULL,
    montant numeric(10,2) NOT NULL,
    "montantPaye" numeric(10,2),
    "datePaiement" date,
    statut character varying
);


ALTER TABLE public.reglement OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17558)
-- Name: reglement_facture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reglement_facture (
    id integer NOT NULL,
    reglement_id integer,
    facture_id integer
);


ALTER TABLE public.reglement_facture OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17557)
-- Name: reglement_facture_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reglement_facture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reglement_facture_id_seq OWNER TO postgres;

--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 241
-- Name: reglement_facture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reglement_facture_id_seq OWNED BY public.reglement_facture.id;


--
-- TOC entry 231 (class 1259 OID 16488)
-- Name: reglement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reglement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reglement_id_seq OWNER TO postgres;

--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 231
-- Name: reglement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reglement_id_seq OWNED BY public.reglement.id;


--
-- TOC entry 261 (class 1259 OID 74949)
-- Name: satisfaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.satisfaction (
    id integer NOT NULL,
    "isCompleted" boolean DEFAULT false NOT NULL,
    "noteGlobale" integer,
    "serviceCommercial" integer,
    livraison integer,
    "gammeProduits" boolean,
    recommandation boolean,
    commentaire text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "commercialId" integer,
    "clientId" integer
);


ALTER TABLE public.satisfaction OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 74948)
-- Name: satisfaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.satisfaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.satisfaction_id_seq OWNER TO postgres;

--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 260
-- Name: satisfaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.satisfaction_id_seq OWNED BY public.satisfaction.id;


--
-- TOC entry 269 (class 1259 OID 107729)
-- Name: satisfaction_response; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.satisfaction_response (
    id integer NOT NULL,
    "nomClient" character varying NOT NULL,
    reponse text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "surveyId" integer
);


ALTER TABLE public.satisfaction_response OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 107728)
-- Name: satisfaction_response_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.satisfaction_response_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.satisfaction_response_id_seq OWNER TO postgres;

--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 268
-- Name: satisfaction_response_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.satisfaction_response_id_seq OWNED BY public.satisfaction_response.id;


--
-- TOC entry 259 (class 1259 OID 74923)
-- Name: satisfaction_survey; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.satisfaction_survey (
    id integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    titre character varying NOT NULL,
    description text
);


ALTER TABLE public.satisfaction_survey OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 74922)
-- Name: satisfaction_survey_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.satisfaction_survey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.satisfaction_survey_id_seq OWNER TO postgres;

--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 258
-- Name: satisfaction_survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.satisfaction_survey_id_seq OWNED BY public.satisfaction_survey.id;


--
-- TOC entry 263 (class 1259 OID 83115)
-- Name: satisfaction_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.satisfaction_template (
    id integer NOT NULL,
    description text,
    "noteGlobale" integer,
    "serviceCommercial" integer,
    livraison integer,
    "gammeProduits" boolean,
    recommandation boolean,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.satisfaction_template OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 83114)
-- Name: satisfaction_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.satisfaction_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.satisfaction_template_id_seq OWNER TO postgres;

--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 262
-- Name: satisfaction_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.satisfaction_template_id_seq OWNED BY public.satisfaction_template.id;


--
-- TOC entry 271 (class 1259 OID 107744)
-- Name: survey; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey (
    id integer NOT NULL,
    nom character varying NOT NULL,
    "dateDebut" date NOT NULL,
    "dateFin" date NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.survey OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 107763)
-- Name: survey_affectation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_affectation (
    id integer NOT NULL,
    "surveyId" integer,
    "commercialId" integer,
    "clientId" integer
);


ALTER TABLE public.survey_affectation OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 107762)
-- Name: survey_affectation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.survey_affectation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.survey_affectation_id_seq OWNER TO postgres;

--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 274
-- Name: survey_affectation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.survey_affectation_id_seq OWNED BY public.survey_affectation.id;


--
-- TOC entry 270 (class 1259 OID 107743)
-- Name: survey_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.survey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.survey_id_seq OWNER TO postgres;

--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 270
-- Name: survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.survey_id_seq OWNED BY public.survey.id;


--
-- TOC entry 273 (class 1259 OID 107754)
-- Name: survey_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_question (
    id integer NOT NULL,
    text character varying NOT NULL,
    type character varying NOT NULL,
    "surveyId" integer
);


ALTER TABLE public.survey_question OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 107753)
-- Name: survey_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.survey_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.survey_question_id_seq OWNER TO postgres;

--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 272
-- Name: survey_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.survey_question_id_seq OWNED BY public.survey_question.id;


--
-- TOC entry 244 (class 1259 OID 17589)
-- Name: type_reglement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_reglement (
    id integer NOT NULL,
    nom character varying(50) NOT NULL
);


ALTER TABLE public.type_reglement OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17588)
-- Name: type_reglement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_reglement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_reglement_id_seq OWNER TO postgres;

--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 243
-- Name: type_reglement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_reglement_id_seq OWNED BY public.type_reglement.id;


--
-- TOC entry 234 (class 1259 OID 16497)
-- Name: typereglement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typereglement (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.typereglement OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16496)
-- Name: typereglement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.typereglement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.typereglement_id_seq OWNER TO postgres;

--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 233
-- Name: typereglement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.typereglement_id_seq OWNED BY public.typereglement.id;


--
-- TOC entry 236 (class 1259 OID 16525)
-- Name: unite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unite (
    id integer NOT NULL,
    nom character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.unite OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16524)
-- Name: unite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unite_id_seq OWNER TO postgres;

--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 235
-- Name: unite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unite_id_seq OWNED BY public.unite.id;


--
-- TOC entry 238 (class 1259 OID 16704)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    nom character varying NOT NULL,
    prenom character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    tel character varying NOT NULL,
    role public.users_role_enum DEFAULT 'commercial'::public.users_role_enum NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    latitude double precision,
    longitude double precision,
    adresse character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16703)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 224 (class 1259 OID 16435)
-- Name: visite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visite (
    id integer NOT NULL,
    client_id integer,
    "userId" integer,
    raison_id integer,
    date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.visite OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16434)
-- Name: visite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visite_id_seq OWNER TO postgres;

--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 223
-- Name: visite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visite_id_seq OWNED BY public.visite.id;


--
-- TOC entry 4945 (class 2604 OID 91347)
-- Name: categorie_client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie_client ALTER COLUMN id SET DEFAULT nextval('public.categorie_client_id_seq'::regclass);


--
-- TOC entry 4924 (class 2604 OID 34749)
-- Name: categorie_produit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie_produit ALTER COLUMN id SET DEFAULT nextval('public.categorie_produit_id_seq'::regclass);


--
-- TOC entry 4934 (class 2604 OID 42135)
-- Name: circuit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit ALTER COLUMN id SET DEFAULT nextval('public.circuit_id_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 16405)
-- Name: client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 16414)
-- Name: commande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande ALTER COLUMN id SET DEFAULT nextval('public.commande_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 16480)
-- Name: facture id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facture ALTER COLUMN id SET DEFAULT nextval('public.facture_id_seq'::regclass);


--
-- TOC entry 4942 (class 2604 OID 91314)
-- Name: historique_commande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_commande ALTER COLUMN id SET DEFAULT nextval('public.historique_commande_id_seq'::regclass);


--
-- TOC entry 4932 (class 2604 OID 34950)
-- Name: ligne_commande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commande ALTER COLUMN id SET DEFAULT nextval('public.ligne_commande_id_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 16426)
-- Name: lignecommande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignecommande ALTER COLUMN id SET DEFAULT nextval('public.lignecommande_id_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 16466)
-- Name: objectif id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectif ALTER COLUMN id SET DEFAULT nextval('public.objectif_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 33988)
-- Name: objectif_commercial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectif_commercial ALTER COLUMN id SET DEFAULT nextval('public.objectif_commercial_id_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 34756)
-- Name: produit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit ALTER COLUMN id SET DEFAULT nextval('public.produit_id_seq'::regclass);


--
-- TOC entry 4922 (class 2604 OID 34004)
-- Name: promotion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion ALTER COLUMN id SET DEFAULT nextval('public.promotion_id_seq'::regclass);


--
-- TOC entry 4911 (class 2604 OID 17496)
-- Name: raison_visite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raison_visite ALTER COLUMN id SET DEFAULT nextval('public.raison_visite_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 16452)
-- Name: reclamation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reclamation ALTER COLUMN id SET DEFAULT nextval('public.reclamation_id_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 16492)
-- Name: reglement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement ALTER COLUMN id SET DEFAULT nextval('public.reglement_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 17561)
-- Name: reglement_facture id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement_facture ALTER COLUMN id SET DEFAULT nextval('public.reglement_facture_id_seq'::regclass);


--
-- TOC entry 4937 (class 2604 OID 74952)
-- Name: satisfaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction ALTER COLUMN id SET DEFAULT nextval('public.satisfaction_id_seq'::regclass);


--
-- TOC entry 4947 (class 2604 OID 107732)
-- Name: satisfaction_response id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_response ALTER COLUMN id SET DEFAULT nextval('public.satisfaction_response_id_seq'::regclass);


--
-- TOC entry 4935 (class 2604 OID 74926)
-- Name: satisfaction_survey id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_survey ALTER COLUMN id SET DEFAULT nextval('public.satisfaction_survey_id_seq'::regclass);


--
-- TOC entry 4940 (class 2604 OID 83118)
-- Name: satisfaction_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_template ALTER COLUMN id SET DEFAULT nextval('public.satisfaction_template_id_seq'::regclass);


--
-- TOC entry 4949 (class 2604 OID 107747)
-- Name: survey id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey ALTER COLUMN id SET DEFAULT nextval('public.survey_id_seq'::regclass);


--
-- TOC entry 4952 (class 2604 OID 107766)
-- Name: survey_affectation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_affectation ALTER COLUMN id SET DEFAULT nextval('public.survey_affectation_id_seq'::regclass);


--
-- TOC entry 4951 (class 2604 OID 107757)
-- Name: survey_question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_question ALTER COLUMN id SET DEFAULT nextval('public.survey_question_id_seq'::regclass);


--
-- TOC entry 4914 (class 2604 OID 17592)
-- Name: type_reglement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_reglement ALTER COLUMN id SET DEFAULT nextval('public.type_reglement_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 16500)
-- Name: typereglement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typereglement ALTER COLUMN id SET DEFAULT nextval('public.typereglement_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 16528)
-- Name: unite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unite ALTER COLUMN id SET DEFAULT nextval('public.unite_id_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 16707)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 16438)
-- Name: visite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite ALTER COLUMN id SET DEFAULT nextval('public.visite_id_seq'::regclass);


--
-- TOC entry 5256 (class 0 OID 91344)
-- Dependencies: 267
-- Data for Name: categorie_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorie_client (id, nom, "isActive") FROM stdin;
4	épiceriess	t
2	Restauration collective	t
5	Grossistes alimentaires	t
6	Hôtels / Hôtellerie-restauration	t
7	Magasins bio / spécialisés	t
8	Centrales d’achat	t
9	Cavistes / Alcool & boissons	t
1	épiceries	t
3	Grande distribution	t
10	test	t
\.


--
-- TOC entry 5239 (class 0 OID 34746)
-- Dependencies: 250
-- Data for Name: categorie_produit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorie_produit (id, nom, "isActive") FROM stdin;
53	Hygiène et beauté	t
54	Entretien et Nettoyage 	t
55	Epicerie sucrée	t
56	Bébé	t
58	Epicerie salée	t
59	Crèmerie	t
60	Boissons	t
41	Vinaigres et Condiments	t
42	Accessoires ménagers	t
43	Art de la table	t
44	Rangement et organisation	t
45	Bricolage & jardinage	t
46	Accessoires saisonniers	t
47	Électroménager léger	t
48	Jouets et jeux	t
49	Objets connectés	t
50	Emballages réutilisables	t
40	Huiles	t
51	Bio	f
61	Testt	f
52	Animalerie	t
57	Fruits et Légumes	f
62	DDD	t
\.


--
-- TOC entry 5245 (class 0 OID 42132)
-- Dependencies: 256
-- Data for Name: circuit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.circuit (id, date, "commercialId") FROM stdin;
1	2025-05-20	1
2	2025-05-21	1
3	2025-05-21	1
4	2025-05-22	1
5	2025-05-22	1
6	2025-05-22	1
7	2025-05-22	1
8	2025-05-22	1
9	2025-05-22	1
10	2025-05-22	1
11	2025-05-22	1
12	2025-05-22	1
13	2025-05-22	1
14	2025-05-22	7
15	2025-05-22	1
16	2025-05-22	1
17	2025-05-22	1
18	2025-05-22	1
19	2025-05-22	1
20	2025-05-30	1
21	2025-06-30	1
22	2025-06-05	1
23	2025-07-05	1
24	2025-05-31	1
25	2025-06-04	1
26	2025-06-12	1
27	2025-06-11	1
28	2025-06-03	1
29	2025-07-11	1
30	2025-11-22	1
31	2025-06-19	1
32	2025-06-18	1
33	2025-06-24	1
34	2025-06-28	1
35	2025-08-15	1
36	2025-09-03	1
37	2025-08-20	1
38	2025-10-30	1
39	2025-08-01	1
40	2025-09-05	1
41	2025-09-18	1
42	2025-09-26	1
43	2025-07-08	1
44	2025-10-01	1
45	2025-09-17	1
46	2025-06-26	1
47	2025-10-04	1
48	2025-11-01	1
49	2025-10-02	1
50	2025-06-17	1
51	2025-06-25	1
52	2025-11-11	1
53	2025-11-21	1
54	2025-11-29	1
55	2025-11-30	1
56	2025-12-01	1
57	2025-06-20	1
\.


--
-- TOC entry 5246 (class 0 OID 42138)
-- Dependencies: 257
-- Data for Name: circuit_clients_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.circuit_clients_client ("circuitId", "clientId") FROM stdin;
1	4
2	5
3	5
4	4
5	4
6	3
7	8
7	3
8	3
9	3
10	3
11	5
11	3
12	5
12	3
13	13
13	5
13	3
14	5
14	3
15	5
15	3
16	5
16	3
17	13
17	5
17	3
18	13
18	5
18	3
19	8
20	3
21	3
22	12
23	12
24	8
25	5
26	4
27	4
28	11
29	14
30	5
31	11
32	4
33	4
34	4
35	8
36	3
37	4
38	4
39	4
40	22
41	5
42	3
43	23
44	28
45	12
46	21
47	4
48	14
49	3
50	12
51	24
52	25
53	29
54	14
55	14
56	3
57	30
\.


--
-- TOC entry 5207 (class 0 OID 16402)
-- Dependencies: 218
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, commercial_id, prenom, telephone, nom, email, adresse, "isActive", latitude, longitude, "codeFiscale", importance, categorie_id) FROM stdin;
58	1	pedon	+33653974239	alex	alexpedo@gmail.com	5014, Gouvernorat Monastir, Tunisie	t	35.57706568635983	10.817155502736568	30696183805007	3	8
47	1	tt	+33963251236	tt	tt@gmail.com	80 rue	f	50.272874	1.6673051	30696183805004	3	9
11	1	Lefèvre	0715335522	Arthur	arthur.lefèvre@mail.fr	9 Avenue Jean Jaurès, 33868 Nantes	t	36.8065	10.1815	03377857365189	3	3
3	1	Dupont	+33101012879	Alex	AlexDupont@gmail.com	12 Rue de la République, 75001 Paris	t	36.8065	10.1815	61234567894356	3	5
63	1	Bruno vaquette	+33130856300	Sedexo	contact.fr@sodexo.com	6, Rue de la Redoute, Guyancourt, 78280, Île-de-France, France	t	48.783152	2.057534	30194021914572	3	2
14	1	Martin	06 98 76 54 32	Sophie\t	sophie.martin@mail.fr	8 Boulevard Haussmann, 75009 Paris	t	36.8065	10.1815	\N	3	\N
4	1	Moreau	07 87 65 43 21	Lucas	Moreaulucas.moreau@mail.fr	\t14 Rue des Lilas, 33000 Bordeaux	t	36.8065	10.1815	\N	3	\N
19	1	Petit	+33656789012	Clara	clara.petit@mail.fr	22 Rue des Fleurs, 06000 Nice	t	36.8065	10.1815	30696183805009	3	6
21	1	Roux	07 11 22 33 44	Thomas	thomas.roux@mail.fr	5 Place Bellecour, 69002 Lyon	t	36.8065	10.1815	\N	3	\N
5	1	Laurent	06 45 67 89 01	Manon	manon.laurent@mail.fr	77 Avenue Jean Jaurès, 31000 Toulouse	t	36.8065	10.1815	\N	3	\N
8	1	Blanc	07 66 55 44 33	Hugo	hugo.blanc@mail.fr	3 Rue de la Gare, 67000 Strasbourg	t	36.8065	10.1815	\N	3	\N
15	8	Garcia	06 33 22 11 00	Emma	emma.garcia@mail.fr	10 Rue Pasteur, 13006 Marseille	f	36.8065	11.1815	\N	3	\N
22	1	Bernard	07 77 88 99 00	Nathan	nathan.bernard@mail.fr	25 Avenue de la Liberté, 21000 Dijon	t	35.5771416	10.816528	\N	3	\N
28	1	Guerin	07 50 59 54 56	Chloé	chloé.guerin@mail.fr	53 Place Bellecour, 76048 Lille	t	46.45112577920181	3.173719123005867	\N	3	\N
26	1	Chevalier	07 14 49 12 93	Gabriel	gabriel.chevalier@mail.fr	40 Rue Pasteur, 51709 Lille	t	35.8557805	10.6017099	\N	3	\N
13	1	Richard	07 29 95 41 53	Enzo	enzo.richard@mail.fr	64 Rue de la République, 20051 Toulouse	f	36.8065	10.1815	\N	3	\N
24	1	Guerin	06 37 48 50 20	Alice	alice.guerin@mail.fr	60 Rue des Fleurs, 48586 Lyon	f	35.8557954	10.6017297	\N	3	\N
23	1	Guerin	06 51 70 14 60	Nathan	nathan.guerin@mail.fr	80 Rue de la Gare, 95436 Toulouse	f	35.577143	10.8165241	\N	3	\N
29	1	yvyvyv	071236952	xttc	ycgy@gmail.com	87 reuil malmaison 	f	44.84672485303052	3.233955167233944	\N	3	\N
30	1	vuvu	0123451236	tcctt	txtc@gmail.com	Paris belle ville 	f	45.601355622926825	4.137969575822353	\N	3	\N
31	1	tomas	0123698523	ele	eleTomas@gmail.com	92500	f	45.94003561914095	3.283047638833523	\N	3	\N
56	1	emilie	+33237436912	emilie	emilie@gmail.com	45, Rue du Luxembourg, 59100, Roubaix, France	t	50.6915856	3.1572845	3269852145693	3	3
49	1	rr	+33932145687	rr	rr@gmail.com	12, Rue Auguste Gal, 06300, Nice, France	t	43.7030953	7.2854448	1234569852361	3	\N
27	1	Moreau	07 90 65 15 35	Chloé	chloé.moreau@mail.fr	77 Rue des Lilas, 14075 Bordeaux	f	35.86214918544787	10.613276436924934	 827706862245	3	\N
48	1	test	+33612345688	demo	test@tzst.com	Chemin de Rouval, 80600, Gézaincourt, France	t	50.15022901500616	2.322901636362076	3069618380500	3	\N
50	1	zou	+33123698521	aladin	aladin@gmail.com	80120, Rue, France	f	50.2895571	1.6669333	5874369213695	3	\N
57	1	salma	+33632153698	salma	fa@gmail.com	Rue Victor Hugo, 69002, Lyon, France	t	45.7546673	4.8301881	1234567890765	3	1
25	1	Blanc	+33737967764	Lina	lina.blanc@mail.fr	7 rue des fleurs 3700 tours	f	47.3766238	0.7026827	4567890987654	3	\N
32	1	Ben Salah	123456789	Ali	ali@example.com	Rue de Tunis	f	36.8065	10.1815	\N	3	\N
55	1	test	+33612345642	Test	test.test@example.com	35,reuil ville	f	47.08594350786383	4.7294362261891365	7654321098765	3	2
39	1	pp	0123658967	yy	yy@gmail.com	belle ville, paris	t	46.20711915394878	2.915869653224945	1234658793124	3	\N
34	1	hhh	0123652369	hhh	hh@gmail.com	92500 paris	f	46.39217832547591	1.57658401876688	1234569785236	3	\N
35	1	uuu	96632852	yyy	uuu@gmail.com	paris	f	46.668593300899154	5.393547490239143	2365412398523	3	\N
40	1	p	01236932	pp	pp@gmail.com	défense 	f	46.02143488825957	5.259617082774639	1234567090123	3	\N
44	1	jcfj	+33612345678	xjjc	gg@gmail.com	paris	f	45.031796645615195	2.5174177810549736	0236985217536	3	\N
52	1	test	0612345642	Test	test.test@example.com	Paris	t	43.2965	5.3698	\N	3	\N
53	1	test	0612345642	Test	test.test@example.com	Paris	t	43.2965	5.3698	\N	3	\N
59	1	med amibe	+33612345678	aziza	test@outlook.com	16, Rue de Luchy, 60840, Catenoy, France	t	50.465637399890724	2.2057142481207848	3215468935148	3	4
33	1	Bouraoui	+33685263974	Ali	ali@gmail.com	Paris , Lyon	t	48.78448794354755	2.633936293423176	1234567890123	3	\N
12	1	Lefèvre	+33723456789	Julien	julien.lefevre@mail.fr	Avenue de l'Environnement, 5014, Tunisie	t	35.5771444	10.8165402	12345677876513	3	\N
36	1	kekzkz	+33745236921	kzizoz	kzke@outlook.com	paris	t	36.79246629788269	10.189020372927189	19467319764492	3	\N
54	1	test	+33612345642	Test	test.test@example.com	Avenue de l'Environnement, 5014, Tunisie	t	35.5771449	10.8165416	96325807412365	3	\N
43	1	Bv	+33612345645	Av	ai@example.com	Avenue de l'Environnement, 5014, Tunisie	f	35.5771411	10.8165374	12345678901232	3	\N
60	1	Peltier Pascal	+33123695874	METRO FRANCE	metroFrance‑service‑client@metrofrance.com	ZA DU PETIT NANTERRE 5 RUE DES GRANDS PRES 92000 NANTERRE	t	35.57685953141476	10.817039497196674	39931561300014	3	4
61	1	yyy	+33963258741	ttt	tt@gmail.com	Avenue de l'Environnement, 5014, Tunisie	t	35.5771465	10.8165448	12365874963128	3	8
38	22	julien	0978654532	julien	julien@gmail.com	Paris,la defence	t	45.100935022743464	3.387395963072777	63985214756328	3	3
51	1	Boris DERICHEBOURG	+33140882800	Elior Restauration France	gdpr.contact@eliorgroup.com	9-11 9 ALLEE DE L'ARCHE 92400 COURBEVOIE	t	35.57670491485775	10.81698752939701	40816800300023	3	2
45	1	pedro	+33632136542	alin	alin@digitalprocess.com	Paris 6 ème arrondissement	t	46.80627335615366	3.7194406986236572	30696183805002	3	1
62	1	Jean dupain	+33632156342	auchant	jean@gmail.com	Avenue de l'Environnement, 5014, Tunisie	t	35.577057505618136	10.816545970737934	23651247805232	3	6
46	1	Alexandre De Palmas	+33231706088	Carrefour	carrefourservice@carfour.com	ZI, ROUTE DE PARIS, 14120 MONDEVILLE	t	48.947082	2.150503	67205008502051	3	\N
64	1	Alexandra	+33123698524	alexandra	alexandra@outlook.com	Avenue de l'Environnement, 5014, Gouvernorat Monastir, Tunisie	t	35.57579738873189	10.81581674516201	85236974125805	3	10
37	1	andrie alex	+33133662316	idl	andrie.alex@gmail.com	Avenue de l'Environnement, 5014, Gouvernorat Monastir, Tunisie	t	35.5771727	10.8165493	12345678908522	3	9
65	45	elune	+33123395247	action	elune@gmail.com	5014, Gouvernorat Monastir, Tunisie	t	35.57720721305859	10.816353857517242	55555555555555	3	2
76	45	Julie Fontaine	+33 7 76 48 92 11	Picard	julie.fontaine@example.fr	175, rue Jean Jaurès, 94592 Paris	t	44.119851	2.288932	50563629975376	1	2
77	1	Isabelle Lemoine	+33 4 64 47 14 40	Action	isabelle.lemoine@example.fr	185, impasse Jean Jaurès, 79681 Toulouse	t	44.846526	6.645561	31070286031718	3	3
78	22	Isabelle Garcia	+33 7 11 47 83 62	Casino	isabelle.garcia@example.fr	64, rue Jean Jaurès, 87632 Bordeaux	f	47.322105	1.99614	59130354739634	1	2
79	22	Sophie Lemoine	+33 5 54 16 45 83	Lidl	sophie.lemoine@example.fr	135, impasse des Lilas, 93181 Bordeaux	t	46.271943	3.31703	73381684018262	2	1
80	7	Luc Lemoine	+33 7 44 82 60 36	Auchan	luc.lemoine@example.fr	54, impasse Victor Hugo, 84446 Paris	t	43.468868	1.930344	37149158468445	4	2
81	1	Jean Petit	+33 8 29 49 18 33	Intermarché	jean.petit@example.fr	177, avenue des Lilas, 95976 Toulouse	f	43.163754	6.249439	62551297529881	5	2
82	22	Marie Dupont	+33 4 17 32 68 50	Biocoop	marie.dupont@example.fr	59, boulevard de la République, 81008 Marseille	t	45.211855	5.084525	96688229256080	3	3
83	1	Julie Dupont	+33 6 22 43 70 67	Carrefour	julie.dupont@example.fr	198, avenue Jean Jaurès, 78161 Marseille	t	45.532868	6.525498	50351263773182	1	3
84	45	Sophie Dupont	+33 9 18 63 79 95	Système U	sophie.dupont@example.fr	118, boulevard des Lilas, 82988 Nantes	f	45.132401	3.443004	65808084645986	2	2
85	7	Paul Moreau	+33 9 16 34 54 93	Casino	paul.moreau@example.fr	123, chemin des Lilas, 82405 Nantes	f	43.53443	6.197711	01350065255517	2	2
86	1	Marc Lefevre	+33 4 37 97 40 82	Cora	hugo82@lemoine.net	1, rue Marchal, 79282 Paris	t	44.5889	3.6286	33122534491182	5	3
87	45	Isabelle Lebrun	0338259913	Leader Price	dupont.adeline@laposte.net	99, rue Caron, 15227 Lyon	f	43.6904	4.2234	16012037191566	3	2
88	7	Pauline Garnier	+33 (0)4 31 09 72 95	Franprix	paul.garnier@gmail.com	73, avenue Robin, 36233 Lille	t	47.5576	3.9973	18321578619184	1	1
89	22	Céline Roux	+33 5 31 61 84 18	Monoprix	croux@yahoo.fr	54, boulevard Lefevre, 61546 Marseille	f	44.1759	1.2695	14167234550580	2	3
90	1	Vincent Mercier	0662362840	Dia	vincentm@free.fr	87, rue Leclerc, 45798 Bordeaux	t	47.0592	0.3201	90038001354760	4	2
91	7	Sophie David	0873394653	Naturalia	david.sophie@example.fr	59, boulevard Lefevre, 74100 Nantes	t	48.8551	4.1165	78325698412768	3	1
92	1	Alexis Leroux	+33 (0)2 22 94 97 23	Grand Frais	alexis.leroux@orange.fr	15, avenue Laurent, 61093 Rennes	t	44.8758	5.7759	42629518391260	4	1
93	22	Camille André	0458346212	U Express	camille.andre@wanadoo.fr	102, impasse Blanc, 87693 Montpellier	f	45.1001	5.3911	83027417634890	5	2
94	45	Nicolas Gauthier	0127562965	Market	gauthier.nic@live.fr	49, avenue Bourgeois, 94820 Strasbourg	t	45.6916	3.0451	18936057642913	2	3
95	7	Chloé Marchand	+33 6 97 21 10 52	Carrefour City	chloe.marchand@gmail.com	84, chemin Renault, 21395 Dijon	f	46.8137	1.8477	67028245619845	1	2
96	1	Jérôme Lagarde	02 29 99 54 57	E.Leclerc	plaurent@pelletier.fr	96, boulevard de Bernard, 76041 Poirier-sur-Duval	t	-76.924392	132.862365	0961530284784	1	2
97	22	Stéphane Marty-Allain	+33 1 04 69 52 78	Auchan	thierrypauline@yahoo.fr	497, boulevard de Albert, 18862 Pierre-la-Forêt	f	-68.344715	-41.858028	3443859471019	4	1
98	45	Louis Perez	+33 (0)1 48 85 23 52	Biocoop	suzanne35@dupre.fr	chemin de Rousset, 05258 Carpentiernec	f	30.337301	-60.420765	3183239502297	4	2
99	22	Léon Colin	01 71 33 33 18	Simply Market	neveuthierry@le.net	35, chemin Éléonore Carpentier, 84167 Cohennec	t	31.244889	-171.692518	6764772407861	4	3
100	45	Stéphanie-Frédérique Germain	+33 (0)3 64 45 66 28	Spar	kblanc@ferrand.fr	5, chemin Christiane Girard, 61054 Barbier	t	43.617109	11.476984	5274656007416	1	3
\.


--
-- TOC entry 5209 (class 0 OID 16411)
-- Dependencies: 220
-- Data for Name: commande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commande (id, prix_total_ttc, prix_hors_taxe, "commercialId", numero_commande, date_creation, statut, "clientId", date_validation, "promotionId", "estModifieParAdmin", tva, motif_rejet) FROM stdin;
96	292.74	246.00	22	CMD-1752442464903	2025-07-13 23:34:24.787044	validee	38	2025-07-13 21:34:44.878	23	f	0	\N
84	189.21	159.00	1	CMD-1752429871574	2025-07-13 20:04:31.434922	validee	31	2025-07-14 17:27:53.66	17	f	0	\N
60	22.61	19.00	1	CMD-1750511434789	2025-06-21 15:10:34.806999	validee	29	2025-07-14 19:47:03.163	\N	f	0	\N
35	452.14	379.95	1	CMD-2025-017	2025-05-17 19:28:21.64128	validee	4	\N	\N	f	0	\N
58	20.04	19.00	1	CMD-1750189908852	2025-06-17 21:51:47.069927	validee	27	2025-07-14 22:43:38.811	\N	f	0	\N
92	439.11	369.00	1	CMD-1752438842447	2025-07-13 22:34:02.27491	validee	23	2025-07-13 21:39:03.76	23	f	0	\N
99	301.07	253.00	1	CMD-1752543600970	2025-07-15 03:39:59.999059	validee	22	2025-07-15 01:40:40.675	28	f	0	\N
79	110.67	93.00	1	CMD-20250710-099	2025-07-13 18:59:24.259195	validee	11	2025-07-14 17:32:15.277	8	f	0	\N
116	27.46	27.00	1	CMD-00057	2025-07-16 13:11:44.234787	validee	3	2025-07-16 11:36:25.965	\N	f	1.7	\N
69	146.37	123.00	1	CMD-1752184533082	2025-07-10 23:55:33.340865	validee	36	\N	\N	f	0	\N
91	458.15	385.00	1	CMD-1752438035073	2025-07-13 22:20:34.926668	validee	24	2025-07-13 21:40:07.043	13	f	0	\N
87	355.81	299.00	1	CMD-1752435651638	2025-07-13 21:40:51.49583	validee	30	2025-07-14 00:14:13.386	22	f	0	\N
111	0.00	0.00	1	CMD-00098	2025-07-16 05:02:26.663947	validee	3	2025-07-16 13:03:02.886	\N	f	0	\N
102	14.28	12.00	1	CMD- [34m1752545650803 [0m	2025-07-15 04:14:09.829491	validee	30	2025-07-15 19:20:54.34	\N	f	0	\N
82	70.21	59.00	1	CMD-20250710-096	2025-07-13 19:26:12.85762	validee	11	2025-07-14 18:27:29.9	8	f	0	\N
118	27.46	27.00	1	CMD-00040	2025-07-16 16:13:21.741414	validee	3	2025-07-16 14:23:50.427	\N	t	1.7	\N
90	443.87	373.00	1	CMD-1752436630198	2025-07-13 21:57:10.059754	validee	23	2025-07-14 16:27:12.376	23	f	0	\N
54	27.37	23.00	1	CMD-1750163301148	2025-06-17 14:28:19.312092	validee	11	2025-07-15 01:22:00.304	\N	f	0	\N
65	2.38	2.00	1	CMD-1751937144702	2025-07-08 03:12:23.957221	validee	11	2025-07-10 22:53:24.442	\N	f	0	\N
97	5.95	5.00	1	CMD-1752451184463	2025-07-14 01:59:44.324413	validee	27	2025-07-14 00:00:36.807	28	f	0	\N
78	70.21	59.00	1	CMD-20250710-090	2025-07-13 18:33:52.974002	validee	11	2025-07-14 18:32:11.925	8	f	0	\N
70	292.74	246.00	1	CMD-1752342150704	2025-07-12 19:42:31.699308	validee	13	2025-07-14 18:40:57.911	\N	f	0	\N
89	442.68	372.00	1	CMD-1752436321638	2025-07-13 21:52:01.669357	validee	25	2025-07-14 17:07:39.15	14	f	0	\N
100	9.52	8.00	1	CMD-1752544113100	2025-07-15 03:48:32.15508	validee	31	2025-07-15 01:49:00.58	19	f	0	\N
88	149.94	126.00	1	CMD-1752435735684	2025-07-13 21:42:15.508487	validee	27	2025-07-13 19:44:39.474	23	f	0	\N
64	146.37	123.00	1	CMD-1751936743039	2025-07-08 03:05:42.253784	validee	11	2025-07-12 17:34:11.386	\N	f	0	\N
55	146.37	123.00	1	CMD-1750163512061	2025-06-17 14:31:50.252362	validee	4	\N	\N	f	0	\N
53	9.52	8.00	1	CMD-1750163200092	2025-06-17 14:26:38.286446	rejetee	3	\N	\N	f	0	Commande supprimée par l'administrateur
63	292.74	246.00	1	CMD-1751935864280	2025-07-08 02:51:03.499778	validee	23	2025-07-14 19:18:09.692	\N	f	0	\N
56	3.57	3.00	1	CMD-1750187804778	2025-06-17 21:16:42.953252	validee	11	\N	\N	f	0	\N
38	2341.92	1968.00	1	CMD-1747603445554	2025-05-18 23:24:04.954074	validee	5	\N	\N	f	0	\N
59	11.90	10.00	1	CMD-1750509364046	2025-06-21 14:36:04.081992	validee	3	\N	\N	f	0	\N
98	304.64	256.00	1	CMD-1752542741785	2025-07-15 03:25:40.83666	validee	24	2025-07-15 01:26:39.521	5	f	0	\N
36	51.17	43.00	1	CMD-2025-018	2025-05-17 20:43:55.090028	validee	4	\N	\N	f	0	\N
61	202.56	192.00	1	CMD-1750511518258	2025-06-21 15:11:58.257497	validee	24	\N	\N	f	0	\N
37	49.98	42.00	1	CMD-1747603402009	2025-05-18 23:23:21.445122	validee	4	\N	\N	f	0	\N
45	23.80	20.00	1	CMD-1750149639970	2025-06-17 10:40:38.736942	validee	27	\N	\N	f	0	\N
109	39.27	33.00	1	CMD-00099	2025-07-16 04:58:54.254422	validee	3	2025-07-16 14:09:26.738	\N	t	1.7	\N
62	15.47	13.00	22	CMD-1751724148874	2025-07-05 16:02:29.336436	validee	38	\N	\N	f	0	\N
115	32.13	27.00	1	CMD-00052	2025-07-16 05:03:49.022556	validee	3	2025-07-16 11:10:55.392	\N	f	1.7	\N
117	27.46	27.00	1	CMD-00045	2025-07-16 16:10:56.563484	validee	3	2025-07-16 14:11:17.767	\N	t	1.7	\N
67	11.90	10.00	1	CMD-1751937716927	2025-07-08 03:21:56.142981	validee	27	\N	\N	f	0	\N
83	146.37	123.00	1	CMD-1752429493607	2025-07-13 19:58:13.622041	validee	30	2025-07-13 17:58:58.354	13	f	0	\N
66	14.28	12.00	1	CMD-1751937385808	2025-07-08 03:16:25.006213	validee	29	\N	\N	f	0	\N
68	146.37	123.00	22	CMD-1751972564889	2025-07-08 13:02:44.933377	validee	38	\N	\N	f	0	\N
123	24.31	24.00	1	CMD-00046	2025-07-16 16:57:14.384483	validee	3	2025-07-16 15:20:58.274	\N	t	1.29	\N
119	27.46	27.00	1	CMD-00041	2025-07-16 16:22:53.088301	validee	3	2025-07-16 14:23:21.874	\N	t	1.7	\N
120	24.31	24.00	1	CMD-00042	2025-07-16 16:35:53.188052	validee	3	2025-07-16 15:21:12.896	\N	t	1.29	\N
85	149.94	126.00	1	CMD-1752431123781	2025-07-13 20:25:23.659052	validee	43	2025-07-13 18:35:03.416	22	f	0	\N
94	146.37	123.00	1	CMD-1752439698364	2025-07-13 22:48:18.228609	validee	40	2025-07-13 21:05:39.926	13	f	0	\N
101	589.05	495.00	1	CMD- [34m1752545559937 [0m	2025-07-15 04:12:39.075641	validee	27	2025-07-19 16:57:15.715	\N	f	0	\N
86	149.94	126.00	1	CMD-1752434750029	2025-07-13 21:25:49.91337	validee	43	2025-07-13 19:33:45.533	22	f	0	\N
93	110.67	93.00	1	CMD-20250710-093	2025-07-13 22:37:40.309095	validee	11	2025-07-13 21:06:29.297	8	f	0	\N
131	12.15	12.00	1	CMD- [34m1752679823527 [0m	2025-07-16 17:30:23.527371	validee	33	2025-07-16 15:30:44.776	5	f	1.29	\N
132	205.97	135.00	1	CMD- [34m1752715013865 [0m	2025-07-17 03:16:54.198218	validee	34	2025-07-17 14:45:38.454	5	t	52.57	\N
128	0.00	0.00	1	CMD-2025-001	2025-07-16 17:29:18.375351	validee	3	2025-07-17 19:17:01.411	14	f	0	\N
130	90.99	87.00	1	CMD-2025-0023	2025-07-16 17:29:45.491557	validee	3	2025-07-16 15:56:50.072	14	t	4.59	\N
95	149.94	126.00	22	CMD-1752442339983	2025-07-13 23:32:19.850688	validee	38	2025-07-13 21:33:23.088	19	f	0	\N
133	109.80	102.00	1	CMD- [34m1752772988384 [0m	2025-07-17 19:23:08.112145	validee	25	2025-07-17 19:38:23.485	5	t	7.65	\N
135	3.36	3.00	1	CMD- [34m1752774760235 [0m	2025-07-17 19:52:39.939171	validee	39	2025-07-18 22:08:24.851	30	f	11.99	\N
134	3.36	3.00	1	CMD- [34m1752774698586 [0m	2025-07-17 19:51:38.336328	validee	37	2025-07-19 16:51:28.337	29	f	11.99	\N
137	678.17	646.00	1	CMD- [34m1753061682755 [0m	2025-07-21 03:34:42.82889	validee	34	2025-07-21 20:54:45.419	30	t	4.98	\N
138	14.13	13.39	1	CMD- [34m1753120611187 [0m	2025-07-21 19:56:51.298555	validee	36	2025-07-21 20:44:15.689	5	t	5.53	\N
140	21.92	20.78	1	CMD- [34m1753137852524 [0m	2025-07-22 00:44:12.324694	validee	55	2025-07-22 01:15:53.76	5	f	5.5	\N
141	13.71	13.00	1	CMD- [34m1753141657106 [0m	2025-07-22 01:47:36.992546	validee	34	2025-07-22 02:48:55.505	5	f	5.5	\N
142	23.21	22.00	1	CMD- [34m1753146406726 [0m	2025-07-22 03:06:46.611382	validee	55	2025-07-22 03:07:07.203	5	f	5.5	\N
174	5.25	5.00	1	CMD-2025-00852	2025-07-27 15:55:41.838293	en_attente	3	\N	5	f	5	\N
143	13.71	13.00	22	CMD- [34m1753148583901 [0m	2025-07-22 03:43:03.74117	validee	38	2025-07-22 03:43:23.374	29	f	5.5	\N
154	262.70	249.00	1	CMD-2025-00981	2025-07-23 00:36:05.969691	validee	39	2025-07-23 12:43:13.593	5	t	5.5	\N
150	84.40	80.00	1	CMD-2025-00019	2025-07-23 00:19:04.536304	validee	32	2025-07-23 13:56:49.282	5	f	5.5	\N
156	9198.55	8719.00	1	CMD-2025-00303	2025-07-23 23:57:12.295506	validee	46	2025-07-23 23:57:53.731	5	f	5.5	\N
147	326.00	309.00	1	CMD- [34m1753181749468 [0m	2025-07-22 12:55:49.39809	validee	4	2025-07-22 12:56:16.283	29	f	5.5	\N
157	14.88	14.10	1	CMD-2025-00064	2025-07-24 17:04:05.056705	en_attente	45	\N	25	f	5.5	\N
146	37.98	36.00	1	CMD- [34m1753180658106 [0m	2025-07-22 12:37:37.987168	validee	52	2025-07-22 19:25:30.977	5	t	5.5	\N
158	14.88	14.10	1	CMD-2025-00214	2025-07-24 17:48:08.200311	en_attente	58	\N	25	f	5.5	\N
145	49.58	47.00	1	CMD- [34m1753180355868 [0m	2025-07-22 12:32:35.776625	validee	36	2025-07-22 23:03:33.124	29	t	5.49	\N
159	76.80	72.80	1	CMD-2025-00948	2025-07-24 18:10:22.934518	en_attente	47	\N	5	f	5.5	\N
144	65.41	62.00	1	CMD- [34m1753179506985 [0m	2025-07-22 12:18:26.843503	validee	37	2025-07-22 23:04:51.372	5	t	5.5	Commande supprimée par l'administrateur
175	36.92	35.00	1	CMD-2025-00769	2025-07-27 15:56:27.754474	en_attente	3	\N	5	f	5.5	\N
148	269.02	255.00	1	CMD- [34m1753218400363 [0m	2025-07-22 23:06:39.767287	validee	23	2025-07-22 23:06:58.797	5	t	5.5	\N
176	10.53	10.00	1	CMD-2025-00405	2025-07-27 16:01:06.390843	en_attente	63	\N	30	f	5.25	\N
162	7.38	7.00	1	CMD-2025-00600	2025-07-24 21:38:56.584023	rejetee	3	\N	5	f	5.5	Commande supprimée par l'administrateur
182	110.00	100.00	22	CMD20250001	2025-08-04 17:44:50.337808	en_attente	93	\N	5	f	10	\N
161	17.93	17.00	1	CMD-2025-00392	2025-07-24 21:38:29.381043	validee	61	2025-07-24 22:06:25.815	25	t	5.47	\N
183	220.00	200.00	22	CMD20250002	2025-08-04 17:44:50.337808	validee	94	2025-08-04 17:44:50.337808	5	f	10	\N
149	168.80	160.00	1	CMD- [34m1753218763369 [0m	2025-07-22 23:12:42.741675	validee	19	2025-07-22 23:16:47.179	5	t	5.5	Commande supprimée par l'administrateur
184	165.00	150.00	22	CMD20250003	2025-08-04 17:44:50.337808	validee	95	2025-08-04 17:44:50.337808	5	f	10	\N
178	47.35	45.00	1	CMD-2025-00801	2025-07-27 16:14:02.784071	validee	63	2025-07-27 23:42:13.565	11	f	5.22	\N
163	355.53	337.00	1	CMD-2025-00069	2025-07-27 02:56:33.057777	validee	14	2025-07-27 04:06:55.298	25	t	5.5	\N
185	88.00	80.00	22	CMD20250004	2025-08-04 17:44:50.337808	en_attente	96	\N	5	f	10	\N
160	14.88	14.10	1	CMD-2025-00111	2025-07-24 20:48:08.101203	validee	45	2025-07-27 14:17:01.248	5	f	5.5	\N
155	168.80	160.00	1	CMD-2025-00281	2025-07-23 00:37:11.266281	validee	37	2025-07-23 12:24:48.183	5	t	5.5	\N
164	525.00	500.00	1	CMD-2025-00287	2025-07-27 15:31:27.274035	en_attente	3	\N	5	f	5	\N
186	55.00	50.00	22	CMD20250005	2025-08-04 17:44:50.337808	rejetee	97	\N	5	f	10	Client solvabilité insuffisante
166	5.25	5.00	1	CMD-2025-00241	2025-07-27 15:38:14.225367	en_attente	11	\N	29	f	5	\N
167	5.25	5.00	1	CMD-2025-00614	2025-07-27 15:40:17.597974	en_attente	11	\N	25	f	5	\N
187	132.00	120.00	22	CMD20250006	2025-08-04 17:44:50.337808	validee	98	2025-08-04 17:44:50.337808	5	t	10	\N
188	66.00	60.00	22	CMD20250007	2025-08-04 17:44:50.337808	en_attente	99	\N	5	f	10	\N
170	5.25	5.00	1	CMD-2025-00267	2025-07-27 15:49:20.256291	en_attente	4	\N	\N	f	5	\N
171	10.53	10.00	1	CMD-2025-00624	2025-07-27 15:51:44.611044	en_attente	11	\N	\N	f	5.25	\N
172	5.25	5.00	1	CMD-2025-00096	2025-07-27 15:52:57.080777	en_attente	4	\N	\N	f	5	\N
173	10.55	10.00	1	CMD-2025-00517	2025-07-27 15:55:23.50196	en_attente	4	\N	5	f	5.5	\N
189	44.00	40.00	22	CMD20250008	2025-08-04 17:44:50.337808	validee	100	2025-08-04 17:44:50.337808	5	f	10	\N
180	52500.00	50000.00	45	CMD-2025-00442	2025-07-28 04:51:09.426789	validee	65	2025-08-04 01:38:32.394	5	f	5	\N
179	13.68	13.00	1	CMD-2025-00135	2025-07-28 01:48:25.12041	validee	11	2025-08-04 04:30:39.44	25	f	5.19	\N
177	10.53	10.00	1	CMD-2025-00682	2025-07-27 16:01:48.67057	validee	14	2025-08-04 04:30:46.131	11	f	5.25	\N
190	5500.00	5000.00	22	CMD20250009	2025-08-04 17:48:38.561125	validee	93	2025-08-04 17:48:38.561125	5	t	10	\N
191	3300.00	3000.00	22	CMD20250010	2025-08-04 17:48:38.561125	en_attente	94	\N	5	f	10	\N
168	262.50	250.00	1	CMD-2025-00558	2025-07-27 15:41:50.542427	validee	19	2025-08-04 04:31:15.016	\N	t	5	\N
192	11000.00	10000.00	22	CMD20250011	2025-08-04 17:48:38.561125	validee	95	2025-08-04 17:48:38.561125	5	t	10	\N
193	2200.00	2000.00	22	CMD20250012	2025-08-04 17:48:38.561125	rejetee	96	\N	5	f	10	Plafond de crédit dépassé
194	2750.00	2500.00	22	CMD20250013	2025-08-04 17:50:01.591262	validee	97	2025-08-04 17:50:01.591262	5	f	10	\N
169	1362.25	1295.00	1	CMD-2025-00742	2025-07-27 15:43:28.729423	validee	19	2025-08-04 04:31:44.661	\N	t	5.19	\N
195	6050.00	5500.00	22	CMD20250014	2025-08-04 17:50:01.591262	validee	98	2025-08-04 17:50:01.591262	5	t	10	\N
196	9900.00	9000.00	22	CMD20250015	2025-08-04 17:50:01.591262	en_attente	99	\N	5	f	10	\N
165	420.00	400.00	1	CMD-2025-00954	2025-07-27 15:36:18.93962	validee	3	2025-08-04 04:32:22.528	29	t	5	\N
181	82.09	78.00	1	CMD-2025-00138	2025-08-04 04:48:15.123095	en_attente	14	\N	32	f	5.24	\N
197	3300.00	3000.00	22	CMD20250016	2025-08-04 17:50:01.591262	validee	100	2025-08-04 17:50:01.591262	5	f	10	\N
198	11000.00	10000.00	22	CMD20250017	2025-08-04 17:50:01.591262	validee	93	2025-08-04 17:50:01.591262	5	t	10	\N
199	16500.00	15000.00	22	CMD20250018	2025-08-04 17:50:01.591262	rejetee	94	\N	5	f	10	Retard de paiement précédent
200	6600.00	6000.00	22	CMD20250019	2025-08-04 17:50:01.591262	validee	95	2025-08-04 17:50:01.591262	5	t	10	\N
201	3850.00	3500.00	22	CMD20250020	2025-08-04 17:50:01.591262	en_attente	96	\N	5	f	10	\N
202	12100.00	11000.00	22	CMD20250021	2025-08-04 17:50:01.591262	validee	97	2025-08-04 17:50:01.591262	5	f	10	\N
203	7700.00	7000.00	22	CMD20250022	2025-08-04 17:50:01.591262	validee	98	2025-08-04 17:50:01.591262	5	t	10	\N
204	3300.00	3000.00	1	CMD20250023	2025-08-04 17:51:56.560107	validee	93	2025-08-04 17:51:56.560107	5	f	10	\N
205	2200.00	2000.00	1	CMD20250024	2025-08-04 17:51:56.560107	validee	94	2025-08-04 17:51:56.560107	5	t	10	\N
206	5500.00	5000.00	1	CMD20250025	2025-08-04 17:51:56.560107	en_attente	95	\N	5	f	10	\N
207	8800.00	8000.00	1	CMD20250026	2025-08-04 17:51:56.560107	validee	96	2025-08-04 17:51:56.560107	5	f	10	\N
208	1650.00	1500.00	1	CMD20250027	2025-08-04 17:51:56.560107	rejetee	97	\N	5	f	10	Commande annulée par client
209	3300.00	3000.00	1	CMD20250028	2025-08-04 17:51:56.560107	validee	98	2025-08-04 17:51:56.560107	5	t	10	\N
210	9900.00	9000.00	1	CMD20250029	2025-08-04 17:51:56.560107	validee	99	2025-08-04 17:51:56.560107	5	f	10	\N
211	12100.00	11000.00	1	CMD20250030	2025-08-04 17:51:56.560107	validee	100	2025-08-04 17:51:56.560107	5	t	10	\N
212	6050.00	5500.00	1	CMD20250031	2025-08-04 17:51:56.560107	en_attente	93	\N	5	f	10	\N
213	13200.00	12000.00	1	CMD20250032	2025-08-04 17:51:56.560107	validee	94	2025-08-04 17:51:56.560107	5	f	10	\N
\.


--
-- TOC entry 5219 (class 0 OID 16477)
-- Dependencies: 230
-- Data for Name: facture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facture (id, numero_facture, date_emission, montant_total, commande_id) FROM stdin;
\.


--
-- TOC entry 5254 (class 0 OID 91311)
-- Dependencies: 265
-- Data for Name: historique_commande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historique_commande (id, "champModifie", "ancienneValeur", "nouvelleValeur", "dateModification", "vuParCommercial", "commandeId", "modifieParId") FROM stdin;
1	Quantité - sqdsd	5	4	2025-07-16 16:07:07.825406	f	109	1
2	Quantité - sqdsd	3	2	2025-07-16 16:11:15.155429	f	117	1
3	Quantité - sqdsd	3	1	2025-07-16 16:23:32.715982	f	119	1
4	Quantité - sqdsd	3	2	2025-07-16 16:23:47.097833	f	118	1
5	Quantité - sqdsd	3	2	2025-07-16 17:00:19.429196	f	123	1
6	Quantité - zdsa	2	3	2025-07-16 17:05:05.839368	f	123	1
7	Quantité - sqdsd	2	1	2025-07-16 17:10:44.004946	f	123	1
8	Quantité - zdsa	3	1	2025-07-16 17:17:42.757012	f	123	1
9	Quantité - sqdsd	1	2	2025-07-16 17:17:42.810689	f	123	1
10	Quantité - zdsa	1	2	2025-07-16 17:20:58.171685	f	123	1
11	Quantité - sqdsd	3	2	2025-07-16 17:21:12.843111	f	120	1
12	Quantité - szd	10	11	2025-07-16 17:56:49.999593	f	130	1
13	Quantité - szd	10	11	2025-07-16 17:56:50.003849	f	130	1
14	Quantité - zdsa	2	6	2025-07-16 17:56:50.031377	f	130	1
15	Quantité - zdsa	2	6	2025-07-16 17:56:50.032133	f	130	1
16	Quantité - df	1	3	2025-07-17 14:45:38.407027	f	132	1
17	Quantité - test45	1	3	2025-07-17 14:45:38.430385	f	132	1
18	Quantité - test45	1	8	2025-07-17 19:38:23.451685	f	133	1
19	Quantité - huile sunflaower	3	2	2025-07-21 20:44:15.638472	f	138	1
20	Quantité - huile d’olive vierge	20	19	2025-07-21 20:54:45.397348	f	137	1
22	Statut	rejetee	rejetee	2025-07-22 12:26:03.259662	f	144	1
23	Quantité - Arquivet Humide Naturel Poisson & Légume 	1	2	2025-07-22 19:25:30.958384	f	146	1
24	Quantité - Arquivet Humide Naturel Poisson & Légume 	1	5	2025-07-22 23:03:33.099264	f	145	1
25	Quantité - Arquivet Humide Naturel Poisson & Légume 	1	2	2025-07-22 23:04:51.345544	f	144	1
26	Quantité - CESAR Barquettes en terrine cœur de légumes	1	2	2025-07-22 23:04:51.354631	f	144	1
27	Quantité - Drops Chocolat 50% 5 kg	1	3	2025-07-22 23:06:58.774054	f	148	1
28	Statut	rejetee	rejetee	2025-07-22 23:09:41.585759	f	53	1
29	Statut	rejetee	rejetee	2025-07-22 23:13:08.876941	f	149	1
30	Statut	rejetee	rejetee	2025-07-22 23:15:15.877601	f	149	1
31	Statut	rejetee	rejetee	2025-07-22 23:15:22.393781	f	149	1
32	Quantité - Drops Chocolat 50% 5 kg	1	2	2025-07-22 23:16:47.164515	f	149	1
33	Quantité - Drops Chocolat 50% 5 kg	1	2	2025-07-23 12:24:48.114094	f	155	1
34	Quantité - Drops Chocolat 50% 5 kg	1	2	2025-07-23 12:24:48.156921	f	155	1
35	Quantité - Drops Chocolat 50% 5 kg	1	3	2025-07-23 12:43:13.567786	f	154	1
36	Statut	rejetee	rejetee	2025-07-23 23:19:02.696085	f	53	1
37	Statut	rejetee	rejetee	2025-07-23 23:20:09.725755	f	53	1
38	Statut	rejetee	rejetee	2025-07-24 22:05:16.877885	f	162	1
39	Quantité - 5 Céréales Camomille Verveine Fleur d'Oranger - 220 g - Dès 6 mois	1	3	2025-07-24 22:06:25.795286	f	161	1
40	Quantité - 5 Céréales Camomille Verveine Fleur d'Oranger - 220 g - Dès 6 mois	1	67	2025-07-27 04:06:55.271713	f	163	1
41	Quantité - GRILLE PAIN UFESA TT7385 800W - BLANC	3	50	2025-08-04 04:31:14.990576	f	168	1
42	Quantité - 5 Céréales Camomille Verveine Fleur d'Oranger - 220 g - Dès 6 mois	1	100	2025-08-04 04:31:44.639318	f	169	1
43	Quantité - GRILLE PAIN UFESA TT7385 800W - BLANC	1	159	2025-08-04 04:31:44.648384	f	169	1
44	Quantité - GRILLE PAIN UFESA TT7385 800W - BLANC	4	80	2025-08-04 04:32:22.512609	f	165	1
\.


--
-- TOC entry 5243 (class 0 OID 34947)
-- Dependencies: 254
-- Data for Name: ligne_commande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ligne_commande (id, quantite, commande_id, produit_id, total, "prixUnitaire", "prixUnitaireTTC", tva, "totalHT") FROM stdin;
141	1	144	31	8.44	8.00	8.44	5.50	8.00
143	1	145	27	2.11	2.00	2.11	5.50	2.00
145	1	146	28	18.99	18.00	18.99	5.50	18.00
146	9	147	29	85.46	9.00	9.49	5.50	81.00
147	7	147	27	14.77	2.00	2.11	5.50	14.00
148	11	147	31	92.84	8.00	8.44	5.50	88.00
149	7	147	28	132.93	18.00	18.99	5.50	126.00
182	1	169	38	5.25	5.00	5.25	5.00	5.00
144	1	146	29	9.50	9.00	9.49	5.50	9.00
142	1	145	29	9.50	9.00	9.49	5.50	9.00
178	4	165	38	21.00	5.00	5.25	5.00	20.00
200	1	181	43	40.09	38.00	40.09	5.50	38.00
139	1	144	29	9.50	9.00	9.49	5.50	9.00
140	1	144	28	18.99	18.00	18.99	5.50	18.00
151	1	148	29	9.50	9.00	9.49	5.50	9.00
152	1	148	33	3.16	3.00	3.16	5.49	3.00
153	1	148	34	3.16	3.00	3.16	5.49	3.00
201	1	181	38	42.00	40.00	42.00	5.00	40.00
150	1	148	32	84.40	80.00	84.40	5.50	80.00
154	1	149	32	84.40	80.00	84.40	5.50	80.00
155	1	150	32	84.40	80.00	84.40	5.50	80.00
157	1	154	29	9.50	9.00	9.49	5.50	9.00
158	1	155	32	84.40	80.00	84.40	5.50	80.00
156	1	154	32	84.40	80.00	84.40	5.50	80.00
159	1	156	28	18.99	18.00	18.99	5.50	18.00
160	24	156	29	227.88	9.00	9.49	5.50	216.00
161	30	156	36	506.40	16.00	16.88	5.50	480.00
162	1	156	35	5.28	5.00	5.27	5.50	5.00
163	100	156	32	8440.00	80.00	84.40	5.50	8000.00
164	1	157	34	9.60	9.10	9.60	5.50	9.10
165	1	157	35	5.28	5.00	5.27	5.50	5.00
166	1	158	34	9.60	9.10	9.60	5.50	9.10
167	1	158	35	5.28	5.00	5.27	5.50	5.00
168	8	159	34	76.80	9.10	9.60	5.50	72.80
169	1	160	34	9.60	9.10	9.60	5.50	9.10
170	1	160	35	5.28	5.00	5.27	5.50	5.00
172	1	161	27	2.11	2.00	2.11	5.50	2.00
173	1	162	35	5.28	5.00	5.27	5.50	5.00
174	1	162	27	2.11	2.00	2.11	5.50	2.00
171	1	161	35	5.28	5.00	5.27	5.50	5.00
176	1	163	27	2.11	2.00	2.11	5.50	2.00
175	1	163	35	5.28	5.00	5.27	5.50	5.00
177	100	164	38	525.00	5.00	5.25	5.00	500.00
179	1	166	38	5.25	5.00	5.25	5.00	5.00
180	1	167	38	5.25	5.00	5.25	5.00	5.00
184	1	170	38	5.25	5.00	5.25	5.00	5.00
185	1	171	38	5.25	5.00	5.25	5.00	5.00
186	1	171	35	5.28	5.00	5.27	5.50	5.00
187	1	172	38	5.25	5.00	5.25	5.00	5.00
188	2	173	35	10.55	5.00	5.27	5.50	10.00
189	1	174	38	5.25	5.00	5.25	5.00	5.00
190	7	175	35	36.93	5.00	5.27	5.50	35.00
191	1	176	38	5.25	5.00	5.25	5.00	5.00
192	1	176	35	5.28	5.00	5.27	5.50	5.00
193	1	177	38	5.25	5.00	5.25	5.00	5.00
194	1	177	35	5.28	5.00	5.27	5.50	5.00
195	5	178	38	26.25	5.00	5.25	5.00	25.00
196	4	178	35	21.10	5.00	5.27	5.50	20.00
197	1	179	40	8.40	8.00	8.40	5.00	8.00
198	1	179	35	5.28	5.00	5.27	5.50	5.00
199	10000	180	41	52500.00	5.00	5.25	5.00	50000.00
181	3	168	38	15.75	5.00	5.25	5.00	15.00
183	1	169	35	5.28	5.00	5.27	5.50	5.00
\.


--
-- TOC entry 5211 (class 0 OID 16423)
-- Dependencies: 222
-- Data for Name: lignecommande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lignecommande (id, commande_id, quantite, prix_unitaire, produit_id, total) FROM stdin;
\.


--
-- TOC entry 5217 (class 0 OID 16463)
-- Dependencies: 228
-- Data for Name: objectif; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objectif (id, description, prime, user_id) FROM stdin;
\.


--
-- TOC entry 5235 (class 0 OID 33985)
-- Dependencies: 246
-- Data for Name: objectif_commercial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objectif_commercial (id, "dateDebut", "dateFin", "isActive", mission, bonus, "categorieProduit", prime, "pourcentageCible", "montantCible", atteint, ventes, "totalVentes", "commercialId") FROM stdin;
47	2025-07-17	2025-07-17	t	test	\N	\N	10	\N	50	f	0	0	\N
44	2025-07-17	2025-07-17	t	vente	\N	\N	17	\N	28	f	0	0	\N
51	2025-07-18	2025-07-18	f	vente 10% du la produits de Bio	\N	\N	12345678	\N	12345	f	0	0	\N
55	2025-07-21	2025-08-21	t	VENTE	\N	\N	500	\N	5000	f	0	0	22
56	2025-07-22	2025-09-19	t	vente  du la produits de Bio	\N	\N	600	\N	5000	f	0	0	22
50	2025-07-17	2025-07-17	t	vente 10% du la produits de Bio	\N	\N	366	\N	345	f	0	0	20
46	2025-07-17	2025-07-17	f	test	\N	\N	0	\N	0	f	0	0	\N
43	2025-07-17	2025-07-17	f	vente	\N	\N	17	\N	28	f	0	0	\N
38	2025-07-20	2025-07-27	f	vente 10% du la produits de bébé	\N	bébé	14	10	0	f	0	0	\N
39	2025-07-17	2025-07-18	f	vente	\N	\N	10	\N	0	f	0	0	\N
42	2025-07-17	2025-07-17	t	vente	\N	\N	17	\N	28	f	0	0	\N
41	2025-07-17	2025-07-17	t	vente	\N	\N	17	\N	28	f	0	0	\N
57	2025-07-24	2025-07-27	t	34 BB	\N	\N	20	\N	200	f	0	0	10
53	2025-07-23	2026-01-01	t	vente 20% catégorie animalerie 	\N	\N	2000	\N	39714	f	0	0	1
58	2025-07-24	2025-07-24	t	test	\N	\N	45678	\N	45678	f	0	0	1
59	2025-07-24	2025-07-24	t	SSSSSSSSSS	\N	\N	234	\N	2345	f	0	0	1
54	2025-07-21	2025-12-01	f	testttttttttt	\N	\N	900	\N	9000	f	0	0	1
60	2025-08-04	2025-08-31	t	vente 20% catégorie animalerie 	\N	\N	698	\N	34567	f	0	0	22
61	2025-08-04	2025-08-04	f	Vendre pour 346 €	\N	\N	567	\N	346	f	0	0	9
\.


--
-- TOC entry 5241 (class 0 OID 34753)
-- Dependencies: 252
-- Data for Name: produit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produit (id, images, prix_unitaire, isactive, "categorieId", description, nom, tva, colisage, prix_unitaire_ttc, "uniteId") FROM stdin;
31	{/uploads/images-1753151830681-229968668.webp}	8.00	t	53	Un maximum de douceur avec un minimum d’ingrédients. Avec 97% d’ingrédients d’origine naturelle* et facilement biodégradables, Cottage a privilégié une formule minimaliste respectueuse de votre peau et de la nature pour encore plus de douceur.	Douche Lait Hydratante 	5.50	5	8.44	66
32	{/uploads/images-1753184020997-101543242.jpg}	80.00	t	55	 Qu'est-ce que le programme Cacao Horizons ? C'est simple, il s'agit d'un programme ayant pour but d'améliorer le quotidien des cultivateurs de cacao, tout en vous assurant la traçabilité et la durabilité du cacao. Ainsi lorsque vous voyez le logo "Cocoa Horizons" vous pouvez être sûr que votre produit contient des fèves de cacao provenant d'une agriculture durable	Drops Chocolat 50% 5 kg	5.50	1	84.40	63
33	{/uploads/images-1753204032590-887689566.jpg}	3.00	f	56	test	test	5.49	4	3.16	66
37	{/uploads/images-1753297352106-53296564.jpg}	4.00	t	60	eau 2L	Eau minérale	19.00	6	4.76	66
30	{/uploads/images-1753151680517-266667580.webp}	7.00	t	53	La Crème Mousse à la Fleur d’Oranger du Petit Marseillais lave en douceur votre peau, grâce à sa mousse légère qui libère un parfum particulièrement raffiné.	Crème Mousse Extra Doux à la Fleur d'Oranger	5.50	12	7.38	66
52	{/uploads/images/caramel.jpg}	3.80	t	42	Délicieuse crème de caramel pour desserts.	Caramel Beurre Salé 300g	7.00	8	4.07	63
53	{/uploads/images/gaufres.jpg}	2.80	t	43	Gaufres moelleuses fourrées au miel.	Gaufres fourrées 200g	10.00	20	3.08	65
28	{/uploads/images-1753151374096-967361964.webp}	18.00	f	52	Taille de l'animal Petit, Moyen, Grand\r\nAge de l'animal Adulte, Junior, Senior\r\nComposition Poulet et petits legumes - Bœuf et son mélange de légumes - Volaille, légumes et riz - Dinde, légume, s et riz	CESAR Barquettes en terrine cœur de légumes sss	5.50	1	18.99	64
34	{/uploads/images-1753265540795-969464619.jpg}	9.10	t	49	Le Lait de Suite 2 Holle est composé à 99% d'ingrédients issus de l'agriculture biologique. Il est destiné aux bébés après 6 mois en complément d'un allaitement ou non allaités.\r\n\r\nPar sa composition nutritionnelle, il est rassasiant et conforme aux besoins de votre bébé. Si votre enfant a été allaité et que vous désirez le sevrer, il est conseillé de commencer par le lait pour nourrissons 1er âge, qui sera plus adapté en protides	Lait de Suite 2 - Dès 6 mois - 600 g	5.50	3	9.60	64
27	{/uploads/images-1753151185402-369288983.webp}	2.00	t	52	Offrez à votre chat une expérience culinaire exceptionnelle avec la pâtée humide N&D Ocean Thon & Saumon. Ce produit est spécialement conçu pour satisfaire les palais les plus exigeants de nos amis félins. Composée de 60% de darne de thon et de 10% de filet de saumon	Pâtée humide pour chat	5.50	6	2.11	64
36	{/uploads/images-1753265882879-558184909.jpg}	16.00	t	56	le  Lait de Croissance 3 Picot, élaboré en France convient pour les bébés à partir de 10 mois. \r\nRépondre aux besoins nutritionnels de bébé jusqu'à ses 3 ans tout en lui apportant :\r\nDu fer,Du calcium et de la vitamine D nécessaires à la croissance et à un développement osseux normaux,\r\nDes vitamines A et C qui participent au fonctionnement normal du système immunitaire.\r\n \r\n\r\nSans arômes, sans sucres ajoutés pour donner dès le plus jeune âge de bonnes habitudes alimentaires à bébé.	PICOT Croissance 3 Bio - Dès 10 mois - 800g	5.50	11	16.88	66
41	{/uploads/images-1753909550882-111942103.jpg}	29.00	t	46	Wekker 3D Lilo & Stitch avec veilleuse	Wekker 3D Lilo & Stitch avec veilleuse	5.00	12	30.45	63
44	{/uploads/images-1754264271370-855966527.jpg}	23.00	t	40	huile d'olive	huile 	5.50	6	24.26	66
35	{/uploads/images-1753266214561-50159034.jpg}	5.00	t	60	les 5 Céréales Verveine Fleur d'Oranger Camomille Babybio permettent à votre bébé, dès l'âge de 6 mois de découvrir une saveur et une consistance nouvelle, à l'étape de la diversification alimentaire. L'association de céréales et d'extraits de plantes est idéale pour un moment de douceur pendant les repas.	5 Céréales Camomille Verveine Fleur d'Oranger - 220 g - Dès 6 mois	5.50	6	5.27	64
38	{/uploads/images-1754268873972-288113554.jpg}	40.00	t	42	Grille Pain UFESA - Puissance: 800 Watts - 2 Fentes - 7 positions de rôtissage avec sélecteur électronique - Fonction de dégivrage - Fonction de réchauffage - Fonction d'arrêt - Bac à miettes - Rainures en largeur et en profondeur avec réglage pour tranches épaisses et fines - Corps au toucher froid - Rangement des câbles - Couleur: Blanc - Garantie: 1an	GRILLE PAIN UFESA TT7385 800W - BLANC	5.00	12	42.00	64
29	{/uploads/images-1753151504717-497576337.webp}	9.00	t	52	Nourriture humide pour chien Arquivet Pâtée Poisson & Légume 500 g. Ouvrir la boîte et servir directement dans la gamelle de l'animal. Conserver dans un endroit frais et sec, à l'abri de la lumière directe du soleil.	Arquivet Humide Naturel Poisson & Légume 	5.50	48	9.49	63
39	{/uploads/images-1753581669741-311234424.png}	5.00	t	42	daboussi	dabousii	5.00	45	5.25	66
42	{/uploads/images-1753667106805-295500451.jpeg}	7.00	t	49	qdq	sqd	1.81	5	7.13	66
45	{/uploads/images/biscuits1.jpg}	30.00	t	55	Carton de biscuits au chocolat, idéal pour le petit-déjeuner ou le goûter.	Biscuits Chocolat 500g	10.00	20	33.00	64
46	{/uploads/images/confiture.jpg}	4.00	t	40	Confiture artisanale à la fraise, sans conservateurs.	Confiture Fraise Bio 250g	7.00	12	4.28	63
47	{/uploads/images/chocolatnoir.jpg}	2.50	t	41	Tablette de chocolat noir intense, pur cacao.	Chocolat Noir 70% 100g	10.00	24	2.75	65
48	{/uploads/images/bonbons.jpg}	5.00	t	42	Mélange de bonbons sucrés pour enfants et adultes.	Bonbons Assortis 500g	10.00	15	5.50	66
49	{/uploads/images/miel.jpg}	6.00	t	43	Pot de miel pur récolté localement.	Miel Naturel 250g	7.00	10	6.42	63
43	{/uploads/images-1753743091912-458681686.jpg}	38.00	t	55	De délicieuses tartines bio sans gluten à la farine de riz et au cacao issus de l'agriculture biologique. Cette recette inédite et originale, en format familial, régalera tout le monde grâce à sa saveur et son croustillant.	Tartines craquantes bio au cacao sans gluten 	5.50	24	40.09	64
50	{/uploads/images/cereales.jpg}	3.00	t	40	Céréales croustillantes pour petit-déjeuner.	Céréales Chocolatées 375g	10.00	18	3.30	65
51	{/uploads/images/patetartiner.jpg}	4.50	t	41	Pâte chocolatée pour tartines et crêpes.	Pâte à tartiner 500g	10.00	16	4.95	66
40	{/uploads/images-1753908501794-520459521.webp}	60.00	t	47	La centrale vapeur FG2308 de la marque FAGOR est équipée d'une puissance de 2800W et de 8 bars pour un repassage efficace. Sa cuve amovible de 1,5 L permet des sessions prolongées. Profitez d'un débit de 120 g/min, contrôle électronique de la température, thermostat réglable, et deux niveaux de vapeur.	Centrale Vapeur FAGOR FG2308 - 8 BARS - 2800W	5.50	12	63.30	63
\.


--
-- TOC entry 5237 (class 0 OID 34001)
-- Dependencies: 248
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, titre, description, "tauxReduction", "dateDebut", "dateFin", "isActive", "promotionId") FROM stdin;
6	ffff	Jusqu’à 25% de réduction sur tous les produits alimentaires	25	2025-05-02	2025-05-14	f	\N
27	azertyÿyyyyy	AZERTYUIOPrr	20	2025-06-19	2025-06-29	f	\N
25	Promo Étéeez	Jusqu’à 20% de réduction sur tous les produits	20	2024-06-01	2024-06-30	t	\N
16	test	test	23	2025-07-04	2025-06-19	f	\N
15	dddddd	AZERTYUIO	23	2025-07-04	2025-06-19	f	\N
14	test1	test	25	2025-06-06	2025-06-08	f	\N
17	promo lait 	discount 	4	2025-06-14	2025-06-30	f	\N
19	promotion d'hiver 	Jusqu’à 25% de réduction sur tous les produits alimentaires	25	2025-05-02	2025-05-14	f	\N
21	1 acheté = 1 offert	Pour tout achat d’un article, le deuxième est offert automatiquement.	20	2024-06-01	2024-06-30	f	\N
23	Remise Fidélité	-5% pour les clients réguliers ayant passé au moins 3 commandes ce mois-ci.	5	2025-05-02	2025-05-14	f	\N
24	10% de remise dès 100€	\tBénéficiez de 10% de réduction sur toute commande supérieure à 100€ HT.fqefe	26	2025-05-02	2025-05-14	f	\N
22	10% de remise dès 100€	\tBénéficiez de 10% de réduction sur toute commande supérieure à 100€ HT.	26	2025-05-02	2025-05-14	f	\N
18	promotion	Jusqu’à 25% de réduction sur tous les produits alimentaires	25	2025-05-02	2025-05-14	f	\N
28	Promo de weekend	Promo de weekend sur tt les produits ( stock illimité)	10	2025-06-20	2025-06-23	f	\N
7	Promo Étéssss	Jusqu’à 20% de réduction sur tous les produits	30	2024-06-01	2024-06-30	f	\N
12	Promo 	Jusqu’à 20% de réduction sur tous les produits	20	2024-06-01	2024-06-30	f	\N
9	Promo Été	d	1	2025-06-15	2025-06-16	f	\N
5	Promo Été	Jusqu’à 20% de réduction sur tous les produits	20	2024-06-01	2024-06-30	t	\N
29	ffff	gggg	-17	2025-07-19	2025-07-26	t	\N
30	rr	uuu	17	2025-07-20	2025-07-27	t	\N
11	TTTTTTTTTTTT	TEST	450	2025-06-06	2025-06-07	t	\N
26	azertyOOOOOOOOOOOO	AZERTYUIOPGGGGGG	20	2025-06-19	2025-06-29	f	\N
8	Promo Été	Jusqu’à 20% de réduction sur tous les produits	20	2024-06-01	2024-06-30	t	\N
13	Promo Été	Jusqu’à 20% de réduction sur tous les produits	50	2025-06-07	2025-06-11	f	\N
32	promotion d'hiver 		20	2025-08-06	2025-08-14	t	\N
31	test1	zadeasssss	7	2025-07-18	2025-07-25	f	\N
10	promo annuelle 	promotion sur toute les catégories	50	2025-06-12	2025-06-13	t	\N
20	promotion d'hiver 	Jusqu’à 25% de réduction sur tous les produits alimentaires	26	2025-05-02	2025-05-14	t	\N
\.


--
-- TOC entry 5229 (class 0 OID 17493)
-- Dependencies: 240
-- Data for Name: raison_visite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.raison_visite (id, nom, "isActive") FROM stdin;
1	Suivi d’une commande récente	t
6	Présentation de nouveaux produits	t
4	Installation ou démonstration produit	t
8	vérifier besoins client	t
2	Vérification de la satisfaction client	f
3	Lancement d’une promotion ou offre spéciale	t
7	Enquête de satisfaction	t
\.


--
-- TOC entry 5215 (class 0 OID 16449)
-- Dependencies: 226
-- Data for Name: reclamation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reclamation (id, description, sujet, date, status, "userId", "clientId") FROM stdin;
1	hyyy	ggyy	2025-05-21 00:18:14.377408	ouverte	1	5
3	ttt	tt	2025-05-29 23:15:15.878076	ouverte	1	5
8	jnjn	jj	2025-06-09 12:30:04.88726	ouverte	1	8
9	jnjn	jj	2025-06-09 12:30:05.772114	ouverte	1	8
10	jnjn	jj	2025-06-09 12:30:06.309259	ouverte	1	8
11	jnjn	jj	2025-06-09 12:30:06.498654	ouverte	1	8
13	jnjn	jj	2025-06-09 12:30:23.500923	ouverte	1	8
14	jnjn	jj	2025-06-09 12:30:27.803591	ouverte	1	8
19	ghk	hh	2025-06-13 01:47:21.996193	ouverte	1	11
20	ghk	hh	2025-06-13 01:47:22.181182	ouverte	1	11
21	ghk	hh	2025-06-13 01:47:22.386637	ouverte	1	11
30	f  ftc	tt	2025-06-21 21:41:23.175195	traitée	1	24
28	absence de produit 	réclamation 	2025-06-17 10:25:54.600755	traitée	1	13
29	cyyvyv	tcvt	2025-06-17 21:30:44.361508	traitée	1	23
27	vyyvyv	ghj	2025-06-16 15:51:20.431667	traitée	1	19
26	jfur	yrur	2025-06-13 02:01:56.542287	traitée	1	22
25	hhu	cgh	2025-06-13 01:57:17.765584	traitée	1	3
16	jnjn	jj	2025-06-09 12:30:33.3082	traitée	1	8
15	jnjn	jj	2025-06-09 12:30:32.336212	traitée	1	8
6	456	fatma 	2025-05-29 23:46:26.031184	traitée	1	3
5	ycycy	tctc	2025-05-29 23:46:08.199777	traitée	1	8
23	ghk	hh	2025-06-13 01:47:22.968054	traitée	1	11
24	ghk	hh	2025-06-13 01:47:23.152684	traitée	1	11
31	réclamation 	manque des produits 	2025-07-23 00:43:02.567226	traitée	1	11
22	ghk	hh	2025-06-13 01:47:22.538261	traitée	1	11
33	l'article  xxxx est périmée 	articles défectueux 	2025-07-23 23:44:23.972853	traitée	1	14
35	h	g	2025-07-24 21:19:11.998065	traitée	1	45
34	chkkjff	salma 	2025-07-24 20:49:09.194032	traitée	1	45
32	mmm	mmm	2025-07-23 17:50:08.413408	traitée	1	51
4	ttt	tt	2025-05-29 23:15:19.457497	traitée	1	5
17	ghk	hh	2025-06-13 01:47:18.938325	traitée	1	11
2	hyyy	ggyy	2025-05-21 00:18:17.184182	traitée	1	5
18	ghk	hh	2025-06-13 01:47:21.746111	traitée	1	11
12	jnjn	jj	2025-06-09 12:30:06.691324	traitée	1	8
7	ykyky	ykyk	2025-06-09 12:27:07.251677	traitée	1	8
\.


--
-- TOC entry 5221 (class 0 OID 16489)
-- Dependencies: 232
-- Data for Name: reglement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reglement (id, type_reglement_id, mode_paiement, montant, "montantPaye", "datePaiement", statut) FROM stdin;
\.


--
-- TOC entry 5231 (class 0 OID 17558)
-- Dependencies: 242
-- Data for Name: reglement_facture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reglement_facture (id, reglement_id, facture_id) FROM stdin;
\.


--
-- TOC entry 5250 (class 0 OID 74949)
-- Dependencies: 261
-- Data for Name: satisfaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.satisfaction (id, "isCompleted", "noteGlobale", "serviceCommercial", livraison, "gammeProduits", recommandation, commentaire, "createdAt", "commercialId", "clientId") FROM stdin;
5	f	\N	\N	\N	\N	\N	\N	2025-07-03 00:14:54.786464	\N	\N
6	f	\N	\N	\N	\N	\N	\N	2025-07-03 00:35:02.110264	15	\N
\.


--
-- TOC entry 5258 (class 0 OID 107729)
-- Dependencies: 269
-- Data for Name: satisfaction_response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.satisfaction_response (id, "nomClient", reponse, "createdAt", "surveyId") FROM stdin;
\.


--
-- TOC entry 5248 (class 0 OID 74923)
-- Dependencies: 259
-- Data for Name: satisfaction_survey; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.satisfaction_survey (id, "createdAt", titre, description) FROM stdin;
1	2025-07-18 14:21:44.299664	qsd	qdq
2	2025-07-18 14:35:40.017953	hhh	uuuu
3	2025-07-20 12:14:52.312234	df	
\.


--
-- TOC entry 5252 (class 0 OID 83115)
-- Dependencies: 263
-- Data for Name: satisfaction_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.satisfaction_template (id, description, "noteGlobale", "serviceCommercial", livraison, "gammeProduits", recommandation, "createdAt") FROM stdin;
\.


--
-- TOC entry 5260 (class 0 OID 107744)
-- Dependencies: 271
-- Data for Name: survey; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey (id, nom, "dateDebut", "dateFin", "createdAt") FROM stdin;
1	qsxd	2025-07-27	2025-08-01	2025-07-20 12:36:41.489521
2	test	2025-07-12	2025-07-20	2025-07-20 12:53:03.336145
3	test	2025-07-12	2025-07-20	2025-07-20 12:53:13.175285
4	test	2025-07-12	2025-07-20	2025-07-20 12:54:51.41395
5	ffff	2025-07-19	2025-08-09	2025-07-20 12:57:39.528416
6	test2	2025-07-27	2025-08-10	2025-07-20 13:00:18.571819
8	dsdsqaesc	2025-07-12	2025-07-29	2025-07-20 13:15:40.420096
9	x	2025-07-26	2025-07-30	2025-07-20 13:21:10.169709
10	test enquête 	2025-07-27	2025-08-10	2025-07-20 13:50:04.851833
11	enquête 2025	2025-08-01	2025-09-30	2025-07-22 01:18:17.200805
12	Enquête de satisfaction 2026 	2026-01-01	2026-02-28	2025-07-22 19:31:29.290312
13	satisfaction client	2025-07-23	2025-08-30	2025-07-23 23:23:43.256889
14	ffff	2025-07-26	2025-08-07	2025-07-24 14:39:12.434222
7	enquête de satisfaction	2025-07-18	2025-08-02	2025-07-20 13:04:27.364354
\.


--
-- TOC entry 5264 (class 0 OID 107763)
-- Dependencies: 275
-- Data for Name: survey_affectation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_affectation (id, "surveyId", "commercialId", "clientId") FROM stdin;
1	4	22	38
2	5	1	27
3	6	1	43
4	7	1	27
5	8	1	8
6	9	1	45
7	9	1	46
8	9	1	47
9	10	1	48
10	10	1	32
11	10	1	27
12	1	8	15
13	11	1	32
14	11	1	33
15	11	1	25
16	11	1	55
17	12	1	33
18	12	1	34
19	12	1	35
20	12	1	33
21	12	1	34
22	12	1	35
23	12	1	36
24	12	1	33
25	12	1	43
26	12	1	46
27	13	1	46
28	13	1	33
29	13	1	43
30	13	1	36
31	13	1	37
32	13	1	58
33	13	1	51
34	13	1	48
35	13	1	50
36	13	1	52
37	13	1	53
38	13	1	54
39	13	1	46
40	13	1	33
41	13	1	43
42	13	1	36
43	13	1	37
44	13	1	58
45	13	1	51
46	13	1	48
47	13	1	50
48	13	1	52
49	13	1	53
50	13	1	54
51	13	1	46
52	13	1	33
53	13	1	43
54	13	1	36
55	13	1	37
56	13	1	58
57	13	1	51
58	13	1	48
59	13	1	50
60	13	1	52
61	13	1	53
62	13	1	54
63	13	1	37
64	13	1	58
65	13	1	51
66	13	1	46
67	13	1	48
68	13	1	50
69	13	1	52
70	13	1	53
71	13	1	33
72	13	1	36
73	13	1	54
74	13	1	43
75	14	1	60
76	14	1	61
77	14	1	37
78	14	1	58
79	14	1	51
80	14	1	45
81	14	1	47
82	14	1	11
83	14	1	3
84	14	1	46
85	14	1	14
86	14	1	4
87	14	1	19
88	14	1	21
89	14	1	5
90	14	1	8
91	14	1	22
92	14	1	28
93	14	1	26
94	14	1	13
95	14	1	24
96	14	1	23
97	14	1	29
98	14	1	30
99	14	1	31
100	14	1	56
101	14	1	49
102	14	1	27
103	14	1	48
104	14	1	50
105	14	1	57
106	14	1	25
107	14	1	32
108	14	1	55
109	14	1	39
110	14	1	34
111	14	1	35
112	14	1	40
113	14	1	44
114	14	1	52
115	14	1	53
116	14	1	59
117	14	1	33
118	14	1	12
119	14	1	36
120	14	1	54
121	14	1	43
122	7	1	58
123	7	1	47
124	7	1	11
125	7	1	3
126	7	1	63
127	7	1	14
128	7	1	4
129	7	1	19
130	7	1	21
131	7	1	5
132	7	1	8
133	7	1	22
134	7	1	28
135	7	1	26
136	7	1	13
137	7	1	24
138	7	1	23
139	7	1	29
140	7	1	30
141	7	1	31
142	7	1	56
143	7	1	49
144	7	1	27
145	7	1	48
146	7	1	50
147	7	1	57
148	7	1	25
149	7	1	32
150	7	1	55
151	7	1	39
152	7	1	34
153	7	1	35
154	7	1	40
155	7	1	44
156	7	1	52
157	7	1	53
158	7	1	59
159	7	1	33
160	7	1	12
161	7	1	36
162	7	1	54
163	7	1	43
164	7	1	60
165	7	1	61
166	7	1	51
167	7	1	45
168	7	1	62
169	7	1	46
170	7	1	64
171	7	1	37
172	7	1	77
173	7	1	81
174	7	1	83
175	7	1	86
176	7	1	90
177	7	1	92
178	7	1	96
179	7	1	58
180	7	1	47
181	7	1	11
182	7	1	3
183	7	1	63
184	7	1	14
185	7	1	4
186	7	1	19
187	7	1	21
188	7	1	5
189	7	1	8
190	7	1	22
191	7	1	28
192	7	1	26
193	7	1	13
194	7	1	24
195	7	1	23
196	7	1	29
197	7	1	30
198	7	1	31
199	7	1	56
200	7	1	49
201	7	1	27
202	7	1	48
203	7	1	50
204	7	1	57
205	7	1	25
206	7	1	32
207	7	1	55
208	7	1	39
209	7	1	34
210	7	1	35
211	7	1	40
212	7	1	44
213	7	1	52
214	7	1	53
215	7	1	59
216	7	1	33
217	7	1	12
218	7	1	36
219	7	1	54
220	7	1	43
221	7	1	60
222	7	1	61
223	7	1	51
224	7	1	45
225	7	1	62
226	7	1	46
227	7	1	64
228	7	1	37
229	7	1	77
230	7	1	81
231	7	1	83
232	7	1	86
233	7	1	90
234	7	1	92
235	7	1	96
\.


--
-- TOC entry 5262 (class 0 OID 107754)
-- Dependencies: 273
-- Data for Name: survey_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_question (id, text, type, "surveyId") FROM stdin;
1	votre avis 	text	1
2	satisfaut	select	2
3	satisfaut	select	3
4	satisfaut	select	4
5	test	text	5
6	test2	text	6
7	ddddddddddd	select	7
8	f	text	8
9	f	text	8
10	f	text	8
11	x	image	9
12	x	image	9
13	x	image	9
14	q1	select	10
15	q2	select	10
16	q3	select	10
17	ffff	text	1
18	rrrr	image	1
19	A1	select	11
20	A2	select	11
21	A3	select	11
22	Q1	select	12
23	Q2	select	12
24	Q3	text	12
25	etes vous satisfait ? 	select	13
26	le commercial est poli ? 	text	13
27	autre	image	13
28	d	text	14
29	d	image	14
30	d	select	14
31	êtes vous satisfait ?	select	7
32	ldd	text	7
33	zqsd	text	7
\.


--
-- TOC entry 5233 (class 0 OID 17589)
-- Dependencies: 244
-- Data for Name: type_reglement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_reglement (id, nom) FROM stdin;
\.


--
-- TOC entry 5223 (class 0 OID 16497)
-- Dependencies: 234
-- Data for Name: typereglement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typereglement (id, nom, description) FROM stdin;
\.


--
-- TOC entry 5225 (class 0 OID 16525)
-- Dependencies: 236
-- Data for Name: unite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unite (id, nom, "isActive") FROM stdin;
64	carton	t
66	bouteille 	t
63	plastique	t
68	tests	f
67	czggg	f
69	EEE	t
65	fardeaux	f
\.


--
-- TOC entry 5227 (class 0 OID 16704)
-- Dependencies: 238
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nom, prenom, email, password, tel, role, "isActive", latitude, longitude, adresse) FROM stdin;
34	BENYEZZA	Fatma	fatmabenyezza90@gmail.com	$2b$10$PTVPfHUae3Crdi9oli9RyuJBChHAR8pLsVa4wkdNdMC/htd7qwRA.	+33777379056	admin	t	\N	\N	87 Rue Gallieni
9	ali	benyezza	byzali@digitalprocesssbs.com	$2b$10$BaS5CWifOhSfmdPdZrtPL.W0/YUwmd4ReLFYZ0EYgqFpVf7E.BlwG	0745673412	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
1	Ali	Ben Salah	ali.bensalah@digitalprocess.com	$2a$10$yG8ywP8Hbf7nXgGwdTAnIuI1HjYLpMsG6ALKUGNoFq9s3YjI/qMNO	  01 86 76 68 54	commercial	t	48.8427123	2.3719822	54 Quai de la Rapée, 75012 Paris
8	BENYEZZA	Fatma	arthur.martin@digitalprocesssbs.com	$2b$10$kHJE4L6IhsjCZEy5wSJP6OZVPQjjEo4f./qr4/nT4M.kC2/Hgnvpa	0760804155	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
11	BENYEZZA	ali	alibyz@example.com	$2b$10$x8QPCewsMLBjHd4Ug8wIg.q1DOU92EWJfel/ci6408emO1q3LZYG2	0789407093	admin	t	\N	\N	\N
46	TTT	TTT	TT@gmail.com	$2b$10$RLdHVAfLq1Z.HYHL/4Q2yOIqkmGNKADgAKmyDV/Z/uB0zJuef6L22	0789407093	commercial	t	35.8288284	10.6405254	SOUSSE
26	Boughattas Veuve. Mahjoub	Fatma	boughatas@digitalprocess.com	$2b$10$AFK2Te0eoQah.F8z9BFZf.tKkeIzZTBpt7839K5k6oEBfExFipqgi	0767541234	commercial	f	48.8667026	2.3952068	35 Rue Villiers de l'Isle Adam,  Paris
29	yy	yy	p@digitalprocess.com	$2b$10$vooJBfRzG4XLXyfYoBvYnO8KqzGAiiHcJeJDcPYm6ONtaosRafIii	0668150675	commercial	f	35.8473584	10.5796445	sousse,sahloul
15	Clara	Chevalier	clara.chevalier12@mail.fr	$2b$10$c2BWxnnj2NNYuEA9Wdxmi.cdgVYlkNqnH.fqcZynL1K5Ih8gRCwA6	0789407093	commercial	t	48.8362373	2.3943912	24 Rue de Wattignies, 75012 Paris
35	SUPER 	ALESIA	ALESIA@DIGITALPROCESS.COM	$2b$10$8Z3iiocnve22sDPELWpht.avOkf/MXhBHiUJtchr9.MqG31X1.7Nm	0450667824	commercial	t	48.925021	2.434657	15, rue des Lilas 75001 PARIS
13	tttttt	tttt	ttt@example.com	$2b$10$6q.WE2RpXuQoa4Q4u8QrVerTeZ3baFw3q8zXJgsjg3ncXuAy2fKvK	03333547	commercial	f	\N	\N	\N
31	Raphaël	Louis	Louis@digitalprocess.com	$2b$10$WD2qaeGt6Q4mVSKHZ.goaO4wVvX8laIHtwFpbyAKkVwFiMiIizJnO	0634785683	commercial	f	44.8268634	-0.5525239	7 rue du Commerce, 33000 Bordeaux
19	t	t	t@mail.fr	$2b$10$rYzLshphEpyW66QJZ8PVTeE1.sD1HKCq07Oclani2rdoQD2KAs5tG	096754326	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
14	BENYEZZA	Fatma	fatouma@gmail.com	$2b$10$OEQYP7dHlWAt83PV7ZqRie/vrK2LTKlGS2K2T7WgZbPHVVBsHeLz6	0668150110	commercial	f	\N	\N	\N
33	test	test	byezzaali@gmail.com	$2b$10$SvXrCeAF7G7k8KUTsbZ6XuLApuLh3Mnj3TZ2dahkHmpEamIqY7gEO	+33612345678	admin	t	\N	\N	15 rue de la Paix, 75002 Paris
20	Alice	Fontaine	alice.fontaine76@mail.fr	$2b$10$YMTzXAWVjAlMHQA08jZ/ouQpvxEq59jffkA2oD0MejyDRQvoQRuO2	06 83 75 95 23	commercial	t	43.7583347	7.4503517	10 Avenue Jean Jaurès, 13444 Nice
30	ben yezza	Fatma	admin9@digitalprocess.com	$2b$10$PbShyzyUuCE0w7ozjF7xnu3Bej00DAa5AotfQqd/GzZB52DsL6EnW	0668150110	commercial	f	45.8401698	1.2366875	87 Rue Gallieni
22	mario	mario	mario@digitalprocess.com	$2b$10$w2xgtedlBZehic63IhC29ObStYCghfcSdYvFIajI96/t.j2e/yYCW	073456789	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
17	Gabriel	Durand	gabriel.durand1@mail.fr	$2b$10$sxl0XgiS5GCnC3k3De15/OxnYVfTXqVGtd88JStWMfw0XfrctHMnm	06 79 72 42 33	commercial	t	45.7579294	4.8342286	66 Place Bellecour, 60264 Lyon
21	work	work	work@mail.fr	$2b$10$mqzK8JtEBzIJv7Xuc8E4V.LYLON983wPfjHFVJtM6iRmlqt3JLuW.	0745567890	commercial	t	43.7583347	7.4503517	10 Avenue Jean Jaurès, 13444 Nice
7	luca	adam	admin@digitalprocess.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	0671823456	admin	t	48.8667026	2.3952068	35 Rue Villiers de l'Isle Adam,  Paris
18	test	test	test6@mail.fr	MotDePasse123	0976453495	commercial	t	48.8667026	2.3952068	35 Rue Villiers de l'Isle Adam,  Paris
23	julien	mado	julien@gmail.com	$2b$10$8Ml/IydGV.2e3Ky2VczOiuxEqwzOM46gwQpKY7WcLDCdn0o5k9RxS	0123456889	commercial	f	45.8401698	1.2366875	87 Rue Gallieni
37	alice	aime	alice@gmail.com	$2b$10$o7HvVRDo.SDHk/lbLvB8Te/N/i3VYNUEYk87arDFXnQtrGUrmmj3e	+33668150156	commercial	t	48.8878264	2.3252098	68 Av. de Clichy, 75017 Paris
24	EIA	JHON	EIA@gmail.com	$2b$10$PT.oEboV8IwXLhUk.2VTwORtjpU8KfyBcSgONFLjON7aob8a6WRoi	0547893457	commercial	f	48.8861529	2.3190384	56 rue des Batignolles 75017,Paris
10	Manon	Dubois	Manon.Dubois@digitalprocesssbs.com	MotDePasse123	07 63 81 43 10	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
41	coucou	coucou	coucou@gmail.com	$2b$10$K.Saq8vRYDHQloaLD28PQOQhiviw/87gCJh24YbibY5SKJtmkNdry	0987654322	admin	f	\N	\N	SOUSSE
42	kkk	kkk	kkkKKKKK@gmail.com	$2b$10$Ze8XGuxas9IbsMIBHitMl.mFAUzUc.VDMrSnqCXfYW.Dj0t11Ol.m	0987654323	commercial	f	35.8288284	10.6405254	sousse
12	test	test	test@example.com	$2b$10$xVWUn1QaDoBvjVz0AM2/JOlWxLY9.qZKOXdmlJnSPKGwpnE8qjeoy	0551234568	commercial	f	45.8401698	1.2366875	87 Rue Gallieni
32	BOYER	Moulin 	Boyer@digitalprocess.com	$2b$10$3Wz6qVuSiJNAlv0y3lJvteGTXq3ryND7g1w9J2FEirNZ.nBNCjHCW	0823161896	commercial	f	48.8693056	2.3079951	23 avenue des Champs-Élysées, 75008 Paris
39	 Dupont	Jean	jean@digitalprocess.com	$2b$10$Um5txZdW4lXi9AOC5YD.Xe2VQ94E1VAZiIFjGpmhopnpodOANiMMy	0678543245	commercial	f	48.8523616	2.4168041	12 Rue de la République, 75003 Paris, France
5	Sami	Boughattas	sami.boughattas@digitalprocess.com	$2a$10$yG8ywP8Hbf7nXgGwdTAnIuI1HjYLpMsG6ALKUGNoFq9s3YjI/qMNO	0695316696	commercial	t	48.8553821	2.1264987	6 RES TROIS FORETS, 78380 BOUGIVAL
43	yyyyyyyyy	yyyyyyyyyyy	yyy@gmail.com	$2b$10$iOG9nX9ANzIOyTEK.aTfbehY7t2lGmLFtjtIHAnEog2akfjb3LOk6	0986437456	commercial	f	35.8288284	10.6405254	sousse
44	Adam	Ambre	adam.ambre@digitalprocess.com	$2b$10$UZthKnJi2vqxfEYRRiIS1OCSYoRIYCFStNhCpnlRrjY7.MU.jmvU2	0156738290	commercial	t	45.9844107	4.7171508	61 AVENUE DU PROMENOIR 69400 VILLEFRANCHE-SUR-SAÔNE FRANCE
25	sd	Fatma	ff@digitalprocess.com	$2b$10$sEJG7c67CRxdkRYB1xagA.hUNaKgVeHbOUHqtkBMqFa7JUdVfzhfa	0876124567	commercial	t	45.8401698	1.2366875	87 Rue Gallieni
16	Lucas	Boyer	lucas.boyer6@mail.fr	$2b$10$iCbZIY0nLs8crsRQI/J./uOvl8mmdbnEdAhPHrM6DhhiXjn0grHue	0876124567	commercial	t	48.8709845	2.2881469	50 Avenue Victor Hugo, 54931 Paris
27	alin	pedro	pedro@digitalprocess.com	$2b$10$jmnFpWvaMroht89vpNUh5ucdeIN7UnQpH2wQvQA9TRIYU8YX2UzpC	0167589734	commercial	t	48.8595522	2.3198228	Paris, defence 
45	dabousi	db	dabboussiok@gmail.com	$2b$10$PZ6HeUycDubAHfCU38qjAenO7H04VtcDU9CoKKFNd9.9Yqvt4q3Ji	0986765533	commercial	f	35.7707582	10.8280511	monastir
28	sd	ddd	ddd@digitalprocess.com	$2b$10$LMxm1ZMaVjVluEcilI83rOFtQquG4uopvTnBJg1ZMcem4m8wyGy4m	0789407036	commercial	f	48.8781171	2.180342	13 boulevard du Maréchal Foch, 92500 Rueil-Malmaison, France
\.


--
-- TOC entry 5213 (class 0 OID 16435)
-- Dependencies: 224
-- Data for Name: visite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visite (id, client_id, "userId", raison_id, date) FROM stdin;
188	28	1	\N	2025-10-01 00:00:00
189	12	1	\N	2025-09-17 00:00:00
190	12	1	6	2025-06-17 10:11:28.574
191	21	1	2	2025-06-26 00:00:00
192	4	1	2	2025-10-04 00:00:00
193	14	1	3	2025-11-01 00:00:00
194	3	1	2	2025-10-02 00:00:00
195	3	1	2	2025-10-02 00:00:00
196	12	1	2	2025-06-17 20:41:02.779
197	12	1	2	2025-06-17 20:41:02.779
198	27	1	2	2025-06-17 20:43:08.123
199	24	1	2	2025-06-25 00:00:00
200	25	1	1	2025-11-11 00:00:00
201	29	1	7	2025-11-21 00:00:00
202	29	1	7	2025-11-01 00:00:00
203	29	1	3	2025-10-01 00:00:00
204	14	1	2	2025-06-19 00:00:00
205	14	1	2	2025-06-19 00:00:00
206	14	1	2	2025-06-19 00:00:00
207	14	1	2	2025-11-29 00:00:00
208	14	1	2	2025-11-29 00:00:00
209	14	1	2	2025-11-30 00:00:00
210	28	1	2	2025-06-18 00:00:00
211	8	1	2	2025-06-18 00:00:00
212	19	1	3	2025-06-26 00:00:00
213	29	1	2	2025-06-28 00:00:00
214	29	1	3	2025-07-01 00:00:00
215	30	1	2	2025-06-17 00:00:00
216	29	1	3	2025-06-17 00:00:00
217	3	1	7	2025-12-01 00:00:00
218	30	1	3	2025-06-20 00:00:00
219	27	1	2	2025-06-17 00:00:00
220	26	1	2	2025-06-17 00:00:00
221	23	1	7	2025-06-17 23:12:52.909
222	13	1	7	2025-06-17 00:00:00
223	14	1	3	2025-06-17 00:00:00
224	24	1	3	2025-06-17 23:17:57.478
225	30	1	3	2025-06-19 00:00:00
226	3	1	3	2025-06-18 00:00:00
227	3	1	3	2025-06-17 23:27:35.118
228	5	1	3	2025-06-17 23:27:35.118
229	3	1	3	2025-06-17 00:00:00
230	23	1	3	2025-06-18 00:00:00
231	27	1	3	2025-06-28 00:00:00
232	23	1	3	2025-06-28 00:00:00
233	12	1	2	2025-06-18 00:00:00
234	30	1	3	2025-06-18 00:00:00
235	22	1	3	2025-06-25 00:00:00
236	3	1	3	2025-06-19 00:00:00
237	12	1	2	2025-06-19 00:00:00
238	29	1	3	2025-06-20 00:00:00
239	23	1	7	2025-07-11 00:00:00
240	12	1	7	2025-09-19 00:00:00
241	22	1	1	2025-06-19 00:00:00
242	24	1	7	2025-06-26 00:00:00
243	15	1	1	2025-06-23 00:00:00
244	27	1	3	2025-06-29 10:46:30.631
245	27	1	3	2025-06-30 10:46:30.631
246	13	1	3	2025-06-21 00:00:00
247	27	1	3	2025-06-25 10:46:30.631
248	24	1	3	2025-06-19 00:00:00
249	23	1	3	2025-06-26 00:00:00
250	14	1	3	2025-09-25 00:00:00
251	24	1	3	2025-09-25 00:00:00
252	3	1	3	2025-06-27 00:00:00
253	5	1	2	2025-06-26 00:00:00
254	12	1	2	2026-02-11 00:00:00
255	29	1	3	2025-07-10 00:00:00
256	12	1	3	2025-06-28 00:00:00
257	30	1	3	2025-06-26 00:00:00
258	33	1	2	2025-07-08 00:00:00
259	31	1	3	2025-07-03 00:00:00
260	33	1	3	2025-07-03 00:00:00
261	32	1	3	2025-07-04 00:00:00
262	31	1	7	2025-07-04 00:00:00
263	27	1	3	2025-07-10 00:00:00
264	31	1	3	2025-07-10 00:00:00
265	30	1	3	2025-07-10 00:00:00
266	33	1	3	2025-07-30 00:00:00
267	35	1	3	2025-07-10 00:00:00
268	27	1	3	2025-07-03 00:00:00
269	29	1	2	2025-07-03 18:56:49.432
270	24	1	3	2025-07-18 00:00:00
271	11	1	3	2025-07-18 00:00:00
272	27	1	7	2025-07-11 00:00:00
273	34	1	3	2025-07-11 00:00:00
274	4	1	2	2025-07-12 00:00:00
275	25	1	7	2025-07-12 00:00:00
276	34	1	2	2025-07-03 23:48:35.966
277	27	1	3	2025-07-04 00:04:31.803
278	28	1	1	2025-07-04 00:05:55.58
279	32	22	7	2025-07-04 20:42:34.076
280	27	1	3	2025-07-18 00:00:00
281	33	1	3	2025-07-05 12:03:35.273
282	31	1	3	2025-07-05 12:12:56.938
283	8	1	2	2025-07-06 00:00:00
284	21	1	1	2025-07-06 00:00:00
285	30	1	7	2025-07-06 00:00:00
286	13	1	3	2025-07-05 13:35:00.587
287	30	1	3	2025-07-05 14:01:56.386
288	21	22	3	2025-07-19 00:00:00
289	27	22	3	2025-07-19 00:00:00
290	27	1	7	2025-07-09 00:00:00
291	22	1	7	2025-07-31 00:00:00
292	23	1	7	2025-07-31 00:00:00
293	26	1	3	2025-07-08 00:00:00
294	36	1	3	2025-07-07 00:00:00
295	3	1	3	2025-07-06 22:01:29.848
296	27	1	3	2025-07-07 00:00:00
297	8	1	2	2025-07-07 00:00:00
298	31	1	7	2025-07-09 00:00:00
299	23	1	2	2025-07-09 00:00:00
300	38	1	3	2025-07-25 00:00:00
301	27	1	3	2025-07-23 00:00:00
302	11	1	7	2025-07-19 00:00:00
303	13	1	2	2025-07-25 00:00:00
304	27	1	3	2025-07-06 23:06:27.887
305	34	1	2	2025-07-18 00:00:00
306	31	1	2	2025-07-18 00:00:00
307	15	1	3	2025-07-26 00:00:00
308	36	1	7	2025-07-31 00:00:00
309	34	1	7	2025-07-06 23:24:18.005
310	36	1	3	2025-07-28 00:00:00
311	32	1	3	2025-07-06 23:29:09.006
312	29	1	3	2025-07-09 00:00:00
313	28	1	3	2025-07-09 00:00:00
314	26	1	2	2025-07-07 00:13:12.572
315	32	1	7	2025-07-07 00:19:00.366
316	33	1	3	2025-07-22 00:00:00
317	25	1	3	2025-07-22 00:00:00
318	32	1	7	2025-07-22 00:00:00
319	27	1	7	2025-07-22 00:00:00
320	36	1	3	2025-07-22 00:00:00
321	25	1	3	2025-07-10 00:00:00
322	33	1	2	2025-07-10 00:00:00
323	5	1	7	2025-07-25 00:00:00
324	31	1	3	2025-08-21 00:00:00
325	21	1	3	2025-08-21 00:00:00
326	27	1	7	2025-08-29 00:00:00
327	32	1	7	2025-07-16 00:00:00
328	34	1	7	2025-07-07 00:45:18.082
329	11	1	3	2025-07-07 00:47:01.184
330	27	1	7	2025-07-12 00:00:00
331	31	1	7	2025-07-12 00:00:00
332	33	1	7	2025-07-14 00:00:00
333	24	1	7	2025-07-14 00:00:00
334	29	1	2	2025-07-14 00:00:00
335	27	1	7	2025-07-15 00:00:00
336	31	1	7	2025-07-15 00:00:00
337	11	1	2	2025-07-15 00:00:00
338	23	1	2	2025-07-29 00:00:00
339	37	1	1	2025-07-29 00:00:00
340	3	1	2	2025-07-29 00:00:00
341	36	1	7	2025-07-29 00:00:00
342	15	1	2	2025-07-07 21:22:42.572
343	23	1	7	2025-07-23 00:00:00
344	21	1	1	2025-07-23 00:00:00
345	19	1	3	2025-07-23 00:00:00
346	30	1	2	2025-07-25 00:00:00
347	23	1	3	2025-07-24 00:00:00
348	19	1	7	2025-07-09 00:00:00
349	19	1	7	2025-07-25 00:00:00
350	23	1	1	2025-07-25 00:00:00
351	23	1	1	2025-07-26 00:00:00
352	23	1	1	2025-07-30 00:00:00
353	23	1	1	2025-07-28 00:00:00
354	23	1	1	2025-07-20 00:00:00
355	19	1	1	2025-07-08 00:00:00
356	35	1	7	2025-07-07 23:33:33.468
357	4	1	7	2025-07-18 00:00:00
358	36	1	7	2025-08-15 00:00:00
359	25	1	2	2025-09-22 00:00:00
360	24	1	3	2025-10-10 00:00:00
361	5	1	7	2025-09-06 00:00:00
362	24	1	1	2025-10-24 00:00:00
363	24	1	3	2025-09-19 00:00:00
364	30	1	7	2025-07-08 00:14:39.298
365	34	1	3	2025-07-08 02:04:40.29
366	29	1	3	2025-07-08 02:22:22.156
367	40	1	3	2025-07-09 11:56:07.309
368	40	1	3	2025-07-12 00:15:40.87
369	39	1	7	2025-07-12 00:00:00
370	34	1	7	2025-07-19 00:00:00
371	27	1	2	2025-07-26 00:00:00
372	43	1	2	2025-07-26 00:00:00
373	34	1	3	2025-07-16 00:00:00
374	33	1	2	2025-07-15 00:43:57.445
375	38	1	3	2025-07-15 21:18:36.848
376	33	1	3	2025-07-18 21:38:03.279
377	37	1	3	2025-07-25 00:00:00
378	47	1	4	2025-07-27 13:55:16.749
379	58	1	4	2025-07-27 13:55:16.749
380	3	1	4	2025-07-27 13:55:16.749
381	63	1	6	2025-07-27 14:00:34.917
382	39	1	4	2025-07-28 00:48:38.24
383	65	45	6	2025-07-28 03:51:38.427
\.


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 266
-- Name: categorie_client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorie_client_id_seq', 10, true);


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 249
-- Name: categorie_produit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorie_produit_id_seq', 62, true);


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 255
-- Name: circuit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.circuit_id_seq', 57, true);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 217
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_id_seq', 100, true);


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 219
-- Name: commande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commande_id_seq', 213, true);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 229
-- Name: facture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facture_id_seq', 1, false);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 264
-- Name: historique_commande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historique_commande_id_seq', 44, true);


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 253
-- Name: ligne_commande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ligne_commande_id_seq', 201, true);


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 221
-- Name: lignecommande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lignecommande_id_seq', 1, false);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 245
-- Name: objectif_commercial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.objectif_commercial_id_seq', 61, true);


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 227
-- Name: objectif_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.objectif_id_seq', 1, false);


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 251
-- Name: produit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produit_id_seq', 53, true);


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 247
-- Name: promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_id_seq', 32, true);


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 239
-- Name: raison_visite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.raison_visite_id_seq', 8, true);


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 225
-- Name: reclamation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reclamation_id_seq', 35, true);


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 241
-- Name: reglement_facture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reglement_facture_id_seq', 1, false);


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 231
-- Name: reglement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reglement_id_seq', 1, false);


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 260
-- Name: satisfaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.satisfaction_id_seq', 6, true);


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 268
-- Name: satisfaction_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.satisfaction_response_id_seq', 1, false);


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 258
-- Name: satisfaction_survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.satisfaction_survey_id_seq', 3, true);


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 262
-- Name: satisfaction_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.satisfaction_template_id_seq', 1, false);


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 274
-- Name: survey_affectation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.survey_affectation_id_seq', 235, true);


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 270
-- Name: survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.survey_id_seq', 14, true);


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 272
-- Name: survey_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.survey_question_id_seq', 33, true);


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 243
-- Name: type_reglement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_reglement_id_seq', 1, false);


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 233
-- Name: typereglement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.typereglement_id_seq', 1, false);


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 235
-- Name: unite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unite_id_seq', 69, true);


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 46, true);


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 223
-- Name: visite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visite_id_seq', 383, true);


--
-- TOC entry 5004 (class 2606 OID 42137)
-- Name: circuit PK_16d20c94e486b3613872aa43cad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit
    ADD CONSTRAINT "PK_16d20c94e486b3613872aa43cad" PRIMARY KEY (id);


--
-- TOC entry 5026 (class 2606 OID 107768)
-- Name: survey_affectation PK_427f29dc20556082889650a4dc3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_affectation
    ADD CONSTRAINT "PK_427f29dc20556082889650a4dc3" PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 74931)
-- Name: satisfaction_survey PK_47a5168c99cae653183310c9672; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_survey
    ADD CONSTRAINT "PK_47a5168c99cae653183310c9672" PRIMARY KEY (id);


--
-- TOC entry 4988 (class 2606 OID 17594)
-- Name: type_reglement PK_48143b7c064ba964ed9f3ff5f5b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_reglement
    ADD CONSTRAINT "PK_48143b7c064ba964ed9f3ff5f5b" PRIMARY KEY (id);


--
-- TOC entry 4992 (class 2606 OID 33994)
-- Name: objectif_commercial PK_69007392d4842ad83042693cc0f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectif_commercial
    ADD CONSTRAINT "PK_69007392d4842ad83042693cc0f" PRIMARY KEY (id);


--
-- TOC entry 5018 (class 2606 OID 91351)
-- Name: categorie_client PK_98c89d221ea4c9799d80158cb9e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie_client
    ADD CONSTRAINT "PK_98c89d221ea4c9799d80158cb9e" PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 91320)
-- Name: historique_commande PK_9c1bf1753021de67760046d9dc8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_commande
    ADD CONSTRAINT "PK_9c1bf1753021de67760046d9dc8" PRIMARY KEY (id);


--
-- TOC entry 5008 (class 2606 OID 42142)
-- Name: circuit_clients_client PK_9f253a57d6c6ffa99fe5342575f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit_clients_client
    ADD CONSTRAINT "PK_9f253a57d6c6ffa99fe5342575f" PRIMARY KEY ("circuitId", "clientId");


--
-- TOC entry 4978 (class 2606 OID 16712)
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- TOC entry 4982 (class 2606 OID 17500)
-- Name: raison_visite PK_bbf4cf5ba52e38753dfdc0df3db; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raison_visite
    ADD CONSTRAINT "PK_bbf4cf5ba52e38753dfdc0df3db" PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 107737)
-- Name: satisfaction_response PK_c284d85cab6b8280fa4955e4865; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_response
    ADD CONSTRAINT "PK_c284d85cab6b8280fa4955e4865" PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 83123)
-- Name: satisfaction_template PK_ebea112628e525740628e51707b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_template
    ADD CONSTRAINT "PK_ebea112628e525740628e51707b" PRIMARY KEY (id);


--
-- TOC entry 5024 (class 2606 OID 107761)
-- Name: survey_question PK_ec6d65e83fd7217202178b79907; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_question
    ADD CONSTRAINT "PK_ec6d65e83fd7217202178b79907" PRIMARY KEY (id);


--
-- TOC entry 5022 (class 2606 OID 107752)
-- Name: survey PK_f0da32b9181e9c02ecf0be11ed3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey
    ADD CONSTRAINT "PK_f0da32b9181e9c02ecf0be11ed3" PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 74958)
-- Name: satisfaction PK_f4046a033e783cef3ef7b06b656; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction
    ADD CONSTRAINT "PK_f4046a033e783cef3ef7b06b656" PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 34009)
-- Name: promotion PK_fab3630e0789a2002f1cadb7d38; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT "PK_fab3630e0789a2002f1cadb7d38" PRIMARY KEY (id);


--
-- TOC entry 4990 (class 2606 OID 17596)
-- Name: type_reglement UQ_6e12d72240fc81c194a9bd59a30; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_reglement
    ADD CONSTRAINT "UQ_6e12d72240fc81c194a9bd59a30" UNIQUE (nom);


--
-- TOC entry 4974 (class 2606 OID 16567)
-- Name: unite UQ_7fb4868bddf5f5ce11a41a0be5f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unite
    ADD CONSTRAINT "UQ_7fb4868bddf5f5ce11a41a0be5f" UNIQUE (nom);


--
-- TOC entry 4980 (class 2606 OID 16714)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 4956 (class 2606 OID 17540)
-- Name: commande UQ_a7f83d06c017678ec4cb3628ffb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT "UQ_a7f83d06c017678ec4cb3628ffb" UNIQUE (numero_commande);


--
-- TOC entry 4996 (class 2606 OID 34966)
-- Name: categorie_produit UQ_c26800a0b808030b74cc2a86648; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie_produit
    ADD CONSTRAINT "UQ_c26800a0b808030b74cc2a86648" UNIQUE (nom);


--
-- TOC entry 4984 (class 2606 OID 33961)
-- Name: raison_visite UQ_fc7f41918df50979c5f0712c77e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raison_visite
    ADD CONSTRAINT "UQ_fc7f41918df50979c5f0712c77e" UNIQUE (nom);


--
-- TOC entry 4998 (class 2606 OID 34751)
-- Name: categorie_produit categorie_produit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie_produit
    ADD CONSTRAINT categorie_produit_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 16409)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 16416)
-- Name: commande commande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT commande_pkey PRIMARY KEY (id);


--
-- TOC entry 4968 (class 2606 OID 16482)
-- Name: facture facture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facture
    ADD CONSTRAINT facture_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 34952)
-- Name: ligne_commande ligne_commande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commande
    ADD CONSTRAINT ligne_commande_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 16428)
-- Name: lignecommande lignecommande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignecommande
    ADD CONSTRAINT lignecommande_pkey PRIMARY KEY (id);


--
-- TOC entry 4966 (class 2606 OID 16470)
-- Name: objectif objectif_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectif
    ADD CONSTRAINT objectif_pkey PRIMARY KEY (id);


--
-- TOC entry 5000 (class 2606 OID 34763)
-- Name: produit produit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 16456)
-- Name: reclamation reclamation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reclamation
    ADD CONSTRAINT reclamation_pkey PRIMARY KEY (id);


--
-- TOC entry 4986 (class 2606 OID 17563)
-- Name: reglement_facture reglement_facture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement_facture
    ADD CONSTRAINT reglement_facture_pkey PRIMARY KEY (id);


--
-- TOC entry 4970 (class 2606 OID 16495)
-- Name: reglement reglement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement
    ADD CONSTRAINT reglement_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 16502)
-- Name: typereglement typereglement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typereglement
    ADD CONSTRAINT typereglement_pkey PRIMARY KEY (id);


--
-- TOC entry 4976 (class 2606 OID 16530)
-- Name: unite unite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unite
    ADD CONSTRAINT unite_pkey PRIMARY KEY (id);


--
-- TOC entry 4962 (class 2606 OID 16442)
-- Name: visite visite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite
    ADD CONSTRAINT visite_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 1259 OID 42144)
-- Name: IDX_da4a17a7ec819d7d1f44cf27bb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_da4a17a7ec819d7d1f44cf27bb" ON public.circuit_clients_client USING btree ("clientId");


--
-- TOC entry 5006 (class 1259 OID 42143)
-- Name: IDX_ef82220813c4dcfa5ffdc22760; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_ef82220813c4dcfa5ffdc22760" ON public.circuit_clients_client USING btree ("circuitId");


--
-- TOC entry 5052 (class 2606 OID 74964)
-- Name: satisfaction FK_00e705c1253bc2cec6ab9533d2f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction
    ADD CONSTRAINT "FK_00e705c1253bc2cec6ab9533d2f" FOREIGN KEY ("clientId") REFERENCES public.client(id);


--
-- TOC entry 5041 (class 2606 OID 25724)
-- Name: reglement_facture FK_03003604f316fc9d8137d6eb6ca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement_facture
    ADD CONSTRAINT "FK_03003604f316fc9d8137d6eb6ca" FOREIGN KEY (facture_id) REFERENCES public.facture(id) ON DELETE CASCADE;


--
-- TOC entry 5057 (class 2606 OID 107769)
-- Name: survey_question FK_036a359b4a0884d113f6232e96d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_question
    ADD CONSTRAINT "FK_036a359b4a0884d113f6232e96d" FOREIGN KEY ("surveyId") REFERENCES public.survey(id) ON DELETE CASCADE;


--
-- TOC entry 5029 (class 2606 OID 42121)
-- Name: commande FK_05743bd4380661370076bb86fba; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT "FK_05743bd4380661370076bb86fba" FOREIGN KEY ("clientId") REFERENCES public.client(id);


--
-- TOC entry 5045 (class 2606 OID 107837)
-- Name: produit FK_061c958557c7653be19664df77d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT "FK_061c958557c7653be19664df77d" FOREIGN KEY ("uniteId") REFERENCES public.unite(id);


--
-- TOC entry 5027 (class 2606 OID 17487)
-- Name: client FK_1b9092214f5762c4d1f372fc9e7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT "FK_1b9092214f5762c4d1f372fc9e7" FOREIGN KEY (commercial_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5037 (class 2606 OID 42162)
-- Name: reclamation FK_297da187993970a00d8f5639ddc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reclamation
    ADD CONSTRAINT "FK_297da187993970a00d8f5639ddc" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- TOC entry 5044 (class 2606 OID 91332)
-- Name: promotion FK_4887f3e313013a8f1f16c3b2ba0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT "FK_4887f3e313013a8f1f16c3b2ba0" FOREIGN KEY ("promotionId") REFERENCES public.promotion(id);


--
-- TOC entry 5030 (class 2606 OID 91305)
-- Name: commande FK_4d69a74a240570deefbdd41eef8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT "FK_4d69a74a240570deefbdd41eef8" FOREIGN KEY ("promotionId") REFERENCES public.promotion(id);


--
-- TOC entry 5040 (class 2606 OID 25714)
-- Name: reglement FK_4d755bfdb36b2b5e4bcb44fca8d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement
    ADD CONSTRAINT "FK_4d755bfdb36b2b5e4bcb44fca8d" FOREIGN KEY (type_reglement_id) REFERENCES public.type_reglement(id);


--
-- TOC entry 5034 (class 2606 OID 33969)
-- Name: visite FK_573d84b0dce9eb4457ec49b8185; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite
    ADD CONSTRAINT "FK_573d84b0dce9eb4457ec49b8185" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- TOC entry 5058 (class 2606 OID 107779)
-- Name: survey_affectation FK_58ad74bf1d69523ad0395655967; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_affectation
    ADD CONSTRAINT "FK_58ad74bf1d69523ad0395655967" FOREIGN KEY ("commercialId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5054 (class 2606 OID 91326)
-- Name: historique_commande FK_5b510352c4ddee81f70abb3a7a5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_commande
    ADD CONSTRAINT "FK_5b510352c4ddee81f70abb3a7a5" FOREIGN KEY ("modifieParId") REFERENCES public.users(id);


--
-- TOC entry 5059 (class 2606 OID 107784)
-- Name: survey_affectation FK_729804cc7e3b4bbd7fa2f132cf2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_affectation
    ADD CONSTRAINT "FK_729804cc7e3b4bbd7fa2f132cf2" FOREIGN KEY ("clientId") REFERENCES public.client(id) ON DELETE CASCADE;


--
-- TOC entry 5055 (class 2606 OID 91321)
-- Name: historique_commande FK_82e6f2a43d58702a19409f77163; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_commande
    ADD CONSTRAINT "FK_82e6f2a43d58702a19409f77163" FOREIGN KEY ("commandeId") REFERENCES public.commande(id) ON DELETE CASCADE;


--
-- TOC entry 5039 (class 2606 OID 25729)
-- Name: facture FK_86caca28773653213f05dd59da8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facture
    ADD CONSTRAINT "FK_86caca28773653213f05dd59da8" FOREIGN KEY (commande_id) REFERENCES public.commande(id) ON DELETE CASCADE;


--
-- TOC entry 5047 (class 2606 OID 34977)
-- Name: ligne_commande FK_87fe65406e9822a805187b8c47a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commande
    ADD CONSTRAINT "FK_87fe65406e9822a805187b8c47a" FOREIGN KEY (commande_id) REFERENCES public.commande(id) ON DELETE CASCADE;


--
-- TOC entry 5053 (class 2606 OID 74959)
-- Name: satisfaction FK_8d0374bd8c704f5880536276d65; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction
    ADD CONSTRAINT "FK_8d0374bd8c704f5880536276d65" FOREIGN KEY ("commercialId") REFERENCES public.users(id);


--
-- TOC entry 5056 (class 2606 OID 107738)
-- Name: satisfaction_response FK_8f12aa37a9b948359c3b95c2c25; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satisfaction_response
    ADD CONSTRAINT "FK_8f12aa37a9b948359c3b95c2c25" FOREIGN KEY ("surveyId") REFERENCES public.satisfaction_survey(id);


--
-- TOC entry 5035 (class 2606 OID 33974)
-- Name: visite FK_9622aa6bf735a51f2933f84cf16; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite
    ADD CONSTRAINT "FK_9622aa6bf735a51f2933f84cf16" FOREIGN KEY (raison_id) REFERENCES public.raison_visite(id);


--
-- TOC entry 5046 (class 2606 OID 34967)
-- Name: produit FK_9d841b89cb96ef0b5ef049c7c3d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT "FK_9d841b89cb96ef0b5ef049c7c3d" FOREIGN KEY ("categorieId") REFERENCES public.categorie_produit(id) ON DELETE CASCADE;


--
-- TOC entry 5038 (class 2606 OID 42167)
-- Name: reclamation FK_9d94bccc2a5465050de2eef7fd0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reclamation
    ADD CONSTRAINT "FK_9d94bccc2a5465050de2eef7fd0" FOREIGN KEY ("clientId") REFERENCES public.client(id);


--
-- TOC entry 5036 (class 2606 OID 33979)
-- Name: visite FK_a9154adcf7a85b86aacc120be4b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visite
    ADD CONSTRAINT "FK_a9154adcf7a85b86aacc120be4b" FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 5028 (class 2606 OID 91352)
-- Name: client FK_af604aaa92aa33c232fcb82adbb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT "FK_af604aaa92aa33c232fcb82adbb" FOREIGN KEY (categorie_id) REFERENCES public.categorie_client(id);


--
-- TOC entry 5031 (class 2606 OID 17552)
-- Name: commande FK_b5a8dabb134749742234510838f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT "FK_b5a8dabb134749742234510838f" FOREIGN KEY ("commercialId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5042 (class 2606 OID 25719)
-- Name: reglement_facture FK_b8332677d66b7b442bfd1a61afd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglement_facture
    ADD CONSTRAINT "FK_b8332677d66b7b442bfd1a61afd" FOREIGN KEY (reglement_id) REFERENCES public.reglement(id) ON DELETE CASCADE;


--
-- TOC entry 5060 (class 2606 OID 107774)
-- Name: survey_affectation FK_b8b1f8ee15aa713678cc95f0a06; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_affectation
    ADD CONSTRAINT "FK_b8b1f8ee15aa713678cc95f0a06" FOREIGN KEY ("surveyId") REFERENCES public.survey(id) ON DELETE CASCADE;


--
-- TOC entry 5049 (class 2606 OID 42145)
-- Name: circuit FK_c0e7c816a95f16922053e9ba39e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit
    ADD CONSTRAINT "FK_c0e7c816a95f16922053e9ba39e" FOREIGN KEY ("commercialId") REFERENCES public.users(id);


--
-- TOC entry 5048 (class 2606 OID 34982)
-- Name: ligne_commande FK_c5d545c092270e1e35c4abc2433; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ligne_commande
    ADD CONSTRAINT "FK_c5d545c092270e1e35c4abc2433" FOREIGN KEY (produit_id) REFERENCES public.produit(id) ON DELETE CASCADE;


--
-- TOC entry 5050 (class 2606 OID 42155)
-- Name: circuit_clients_client FK_da4a17a7ec819d7d1f44cf27bb2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit_clients_client
    ADD CONSTRAINT "FK_da4a17a7ec819d7d1f44cf27bb2" FOREIGN KEY ("clientId") REFERENCES public.client(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5043 (class 2606 OID 99544)
-- Name: objectif_commercial FK_e5b9d620cae1ec034e0dbf1f398; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectif_commercial
    ADD CONSTRAINT "FK_e5b9d620cae1ec034e0dbf1f398" FOREIGN KEY ("commercialId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5051 (class 2606 OID 42150)
-- Name: circuit_clients_client FK_ef82220813c4dcfa5ffdc227607; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circuit_clients_client
    ADD CONSTRAINT "FK_ef82220813c4dcfa5ffdc227607" FOREIGN KEY ("circuitId") REFERENCES public.circuit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5032 (class 2606 OID 17525)
-- Name: lignecommande fk_commande; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignecommande
    ADD CONSTRAINT fk_commande FOREIGN KEY (commande_id) REFERENCES public.commande(id) ON DELETE CASCADE;


--
-- TOC entry 5033 (class 2606 OID 16429)
-- Name: lignecommande lignecommande_commande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignecommande
    ADD CONSTRAINT lignecommande_commande_id_fkey FOREIGN KEY (commande_id) REFERENCES public.commande(id) ON DELETE CASCADE;


-- Completed on 2025-08-08 00:59:32

--
-- PostgreSQL database dump complete
--

