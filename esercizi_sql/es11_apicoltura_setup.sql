-- ============================================================
-- ESERCIZIO 11 — Setup Apicoltura (sql-exercises/es02)
-- ============================================================
-- Sistema di tracciamento produzione miele italiana.
-- 5 tabelle:
--   Typology  → categorie di miele (Nazionale, Regionale, ...)
--   Honey     → singoli mieli (Millefiori, Acacia, ...)
--   Beekeeper → apicoltori
--   Apiary    → apiari (luoghi con arnie)
--   Production → produzione annuale (apiario × miele × anno)
-- ============================================================

PRAGMA foreign_keys = ON;

-- Eliminazione tabelle in ordine inverso (dalle più dipendenti).
DROP TABLE IF EXISTS Production;
DROP TABLE IF EXISTS Apiary;
DROP TABLE IF EXISTS Beekeeper;
DROP TABLE IF EXISTS Honey;
DROP TABLE IF EXISTS Typology;

-- Tipologia: categoria di miele. Il nome è UNIQUE (non possono esistere duplicati).
CREATE TABLE Typology (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nome        TEXT NOT NULL UNIQUE,
    descrizione TEXT
);

-- Honey: tipo specifico di miele, riferito a una tipologia.
CREATE TABLE Honey (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    denominazione TEXT NOT NULL,
    typology_id   INTEGER,
    FOREIGN KEY (typology_id) REFERENCES Typology(id)
);

CREATE TABLE Beekeeper (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

-- Apiary: la PK è il codice testuale (es. 'AP001') invece di un integer.
-- SQLite supporta PK di qualsiasi tipo.
CREATE TABLE Apiary (
    codice         TEXT    PRIMARY KEY,
    num_arnie      INTEGER NOT NULL,
    localita       TEXT,
    comune         TEXT,
    provincia      TEXT,
    regione        TEXT,
    beekeeper_id   INTEGER,
    FOREIGN KEY (beekeeper_id) REFERENCES Beekeeper(id)
);

-- Production: tabella di "fatti" (fact table in stile data warehouse).
-- Lega Apiary + Honey + anno con una quantità prodotta.
CREATE TABLE Production (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    anno         INTEGER NOT NULL,
    quantita     REAL    NOT NULL,         -- REAL = numero con virgola
    apiary_code  TEXT,                      -- FK testuale (verso Apiary.codice)
    honey_id     INTEGER,                   -- FK numerica (verso Honey.id)
    FOREIGN KEY (apiary_code) REFERENCES Apiary(codice),
    FOREIGN KEY (honey_id)    REFERENCES Honey(id)
);

-- ============================================================
-- DATI DI ESEMPIO
-- ============================================================

-- 4 categorie ufficiali del miele italiano.
INSERT INTO Typology (nome, descrizione) VALUES
    ('Nazionale',     'Prodotto in tutta Italia'),
    ('Regionale',     'Specifico di una o più regioni'),
    ('Territoriale',  'Specifico di territori particolari'),
    ('DOP',           'Denominazione di Origine Protetta');

-- 5 mieli: ognuno collegato a una tipologia.
INSERT INTO Honey (denominazione, typology_id) VALUES
    ('Millefiori',                    1),  -- Nazionale
    ('Acacia',                        1),
    ('Erica',                         2),  -- Regionale
    ('Asfodelo',                      3),  -- Territoriale
    ('Miele delle Dolomiti Bellunesi', 4); -- DOP

INSERT INTO Beekeeper (nome) VALUES
    ('Apicoltura Rossi'),
    ('Miele del Sole'),
    ('Casa delle Api');

-- 4 apiari distribuiti in regioni diverse.
INSERT INTO Apiary (codice, num_arnie, localita, comune, provincia, regione, beekeeper_id) VALUES
    ('AP001', 15, 'Chianti',       'Greve',   'FI', 'Toscana',  1),
    ('AP002',  8, 'Langhe',        'Alba',    'CN', 'Piemonte', 1),
    ('AP003', 25, 'Bellunese',     'Belluno', 'BL', 'Veneto',   2),
    ('AP004',  5, 'Maremma',       'Grosseto','GR', 'Toscana',  3);

-- Produzione: chiave logica = (apiary_code, honey_id, anno).
-- Tracciamo le produzioni di 2022, 2023, 2024.
INSERT INTO Production (anno, quantita, apiary_code, honey_id) VALUES
    (2022, 120.5, 'AP001', 1),  -- Millefiori dal Chianti
    (2023, 135.0, 'AP001', 1),
    (2022,  85.0, 'AP002', 2),  -- Acacia dalle Langhe
    (2023,  95.5, 'AP002', 2),
    (2023, 250.0, 'AP003', 5),  -- DOP Dolomiti dal Bellunese
    (2024, 280.0, 'AP003', 5);

SELECT 'Setup apicoltura completato' AS info;
