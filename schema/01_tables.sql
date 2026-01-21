-- 01_tables.sql
-- Table definitions for charity association database


-- Table definitions


CREATE TABLE MEMBRES (
    id_membre NUMBER PRIMARY KEY,
    nom VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telephone VARCHAR2(20) NOT NULL,
    date_adhesion DATE NOT NULL,
    role VARCHAR2(30) DEFAULT 'benevole'
);

CREATE TABLE GROUPES (
    id_groupe NUMBER PRIMARY KEY,
    nom_groupe VARCHAR2(50) UNIQUE NOT NULL,
    jour_activite VARCHAR2(100),
    heure_debut TIMESTAMP,
    heure_fin TIMESTAMP,
    nombre_min_benevoles NUMBER DEFAULT 1,
    nombre_max_benevoles NUMBER,
    description VARCHAR2(200)
);

CREATE TABLE MEMBRE_GROUPE (
    id_membre_groupe NUMBER PRIMARY KEY,
    id_membre NUMBER NOT NULL,
    id_groupe NUMBER NOT NULL
);

CREATE TABLE REGIME_ALIMENTAIRE (
    id_regime NUMBER PRIMARY KEY,
    nom_regime VARCHAR2(50) NOT NULL UNIQUE,
    description VARCHAR2(200) NOT NULL
);

CREATE TABLE BENEFICIAIRES (
    id_beneficiaire NUMBER PRIMARY KEY,
    id_carte NUMBER NOT NULL UNIQUE,
    nom VARCHAR2(50) NOT NULL,
    prenom_referent VARCHAR2(50) NOT NULL,
    nb_adultes NUMBER DEFAULT 1 NOT NULL,
    nb_enfants NUMBER DEFAULT 0 NOT NULL,
    nb_bebes NUMBER DEFAULT 0 NOT NULL,
    adresse VARCHAR2(200) NOT NULL,
    telephone VARCHAR2(20) NOT NULL,
    nb_absences NUMBER DEFAULT 0 NOT NULL,
    id_regime NUMBER NOT NULL
);

CREATE TABLE PRODUITS (
    id_produit NUMBER PRIMARY KEY,
    nom_produit VARCHAR2(100) NOT NULL,
    type_produit VARCHAR2(50) NOT NULL,
    unite NUMBER DEFAULT 1 NOT NULL,
    quantite_stock NUMBER DEFAULT 0 NOT NULL,
    seuil_alerte NUMBER DEFAULT 10 NOT NULL
);

CREATE TABLE DONS (
    id_don NUMBER PRIMARY KEY,
    date_don DATE NOT NULL,
    type_don VARCHAR2(30) NOT NULL,
    montant NUMBER DEFAULT 0 NOT NULL,
    description VARCHAR2(200)
);

CREATE TABLE DON_PRODUIT (
    id_don_produit NUMBER PRIMARY KEY,
    id_don NUMBER NOT NULL,
    id_produit NUMBER NOT NULL
);

CREATE TABLE PRODUIT_REGIME (
    id_produit_regime NUMBER PRIMARY KEY,
    id_produit NUMBER NOT NULL,
    id_regime NUMBER NOT NULL
);

CREATE TABLE COLIS (
    id_colis NUMBER PRIMARY KEY,
    id_groupe NUMBER,
    id_beneficiaire NUMBER NOT NULL,
    statut VARCHAR2(30) DEFAULT 'en preparation' NOT NULL,
    date_preparation DATE NOT NULL,
    taille VARCHAR2(10) NOT NULL
);

CREATE TABLE COLIS_PRODUIT (
    id_colis_produit NUMBER PRIMARY KEY,
    id_colis NUMBER NOT NULL,
    id_produit NUMBER NOT NULL,
    quantite_utilisee NUMBER DEFAULT 1 NOT NULL
);

CREATE TABLE DISTRIBUTIONS (
    id_distribution NUMBER PRIMARY KEY,
    id_colis NUMBER NOT NULL,
    id_beneficiaire NUMBER NOT NULL,
    id_groupe NUMBER,
    nb_absences NUMBER DEFAULT 0,
    date_distribution DATE NOT NULL,
    recupere NUMBER(1) DEFAULT 0 NOT NULL
);

CREATE TABLE PRODUIT_BENEFICIAIRES (
    id_produit_beneficiaire NUMBER PRIMARY KEY,
    id_produit NUMBER NOT NULL,
    id_beneficiaire NUMBER NOT NULL
);
