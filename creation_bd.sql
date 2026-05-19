-- Épreuve finale : Services Web - Hiver 2026
-- Script de création de la base de données bibliotheques (PostgreSQL)

DROP TABLE IF EXISTS prets CASCADE;
DROP TABLE IF EXISTS livres CASCADE;
DROP TABLE IF EXISTS bibliotheques CASCADE;
DROP TABLE IF EXISTS utilisateurs CASCADE;

-- Table Utilisateurs
CREATE TABLE utilisateurs (
    id           SERIAL PRIMARY KEY,
    courriel     VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    cle_api      VARCHAR(64)  NOT NULL UNIQUE,
    cree_le      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Table Bibliotheques
CREATE TABLE bibliotheques (
    id             SERIAL PRIMARY KEY,
    nom            VARCHAR(255) NOT NULL,
    utilisateur_id INT          NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
);

-- Table Livres
CREATE TABLE livres (
    id              SERIAL PRIMARY KEY,
    titre           VARCHAR(255) NOT NULL,
    auteur          VARCHAR(255) NOT NULL,
    isbn            VARCHAR(20)  NOT NULL,
    statut          VARCHAR(20)  NOT NULL DEFAULT 'disponible'
                    CHECK (statut IN ('disponible', 'emprunté')),
    description     TEXT,
    ajoute_le       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    bibliotheque_id INT          NOT NULL REFERENCES bibliotheques(id) ON DELETE CASCADE
);

-- Table Prets
CREATE TABLE prets (
    id                 SERIAL PRIMARY KEY,
    livre_id           INT          NOT NULL REFERENCES livres(id) ON DELETE CASCADE,
    nom_emprunteur     VARCHAR(255) NOT NULL,
    date_debut         DATE         NOT NULL DEFAULT CURRENT_DATE,
    date_retour_prevue DATE         NOT NULL,
    est_termine        BOOLEAN      NOT NULL DEFAULT FALSE
);

-- Index pour la performance
CREATE INDEX idx_livres_biblio    ON livres(bibliotheque_id);
CREATE INDEX idx_utilisateurs_cle ON utilisateurs(cle_api);

-- Insertions initiales

INSERT INTO utilisateurs (courriel, mot_de_passe, cle_api)
VALUES (
    'admin@biblio.com',
    '$2a$12$LSp3zvHQBkoDZAJoSi8zCelQm/WOQJH7YviooDJ3n.sD6NlEO/7cK', -- Mot de Passe de test 
    'cle-test-123'
);

INSERT INTO bibliotheques (nom, utilisateur_id)
VALUES ('Bibliothèque Alcide-Fleury', 1);

INSERT INTO livres (titre, auteur, isbn, statut, bibliotheque_id)
VALUES ('Les Légendaires', 'Patrick Sobral', '978-2036046832', 'disponible', 1);