-- ============================================================
-- ESERCIZIO 07 — Setup database "Libreria"
-- ============================================================
-- Tre tabelle: Autori, Libri, Prestiti
-- Fonte: db/libreria.sql + python-sqlite-exercises/es05
-- ============================================================

-- Attiva il controllo delle foreign key (disattivato di default in SQLite).
PRAGMA foreign_keys = ON;

-- Eliminiamo le tabelle nell'ordine INVERSO rispetto alla creazione
-- (figlie prima, padre dopo) per non violare le FK.
DROP TABLE IF EXISTS Prestiti;
DROP TABLE IF EXISTS Libri;
DROP TABLE IF EXISTS Autori;

-- ============================================================
-- CREAZIONE TABELLE
-- ============================================================

-- Autori: tabella "padre" (non dipende da nessun'altra).
CREATE TABLE Autori (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    nome    TEXT NOT NULL,
    cognome TEXT NOT NULL
);

-- Libri: tabella "figlia" di Autori (un libro appartiene a un autore).
CREATE TABLE Libri (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    titolo    TEXT NOT NULL,
    autore_id INTEGER,                          -- FK verso Autori.id
    anno      INTEGER,
    genere    TEXT,
    FOREIGN KEY (autore_id) REFERENCES Autori(id)
);

-- Prestiti: tabella "nipote" (figlia di Libri).
-- data_restituzione può essere NULL → prestito ancora in corso.
CREATE TABLE Prestiti (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    libro_id          INTEGER,                  -- FK verso Libri.id
    utente            TEXT NOT NULL,
    data_prestito     TEXT NOT NULL,            -- formato ISO 'YYYY-MM-DD'
    data_restituzione TEXT,                     -- NULL = ancora in prestito
    FOREIGN KEY (libro_id) REFERENCES Libri(id)
);

-- ============================================================
-- POPOLAMENTO DATI DI ESEMPIO
-- ============================================================

-- Specifichiamo l'id manualmente (per riferimenti coerenti negli INSERT successivi).
INSERT INTO Autori (id, nome, cognome) VALUES
    (1, 'Mario',      'Rossi'),
    (2, 'Lucia',      'Bianchi'),
    (3, 'Alessandro', 'Verdi');

-- I libri si riferiscono agli autori tramite autore_id.
-- L'autore 1 (Mario Rossi) ha 3 libri → utile per testare GROUP BY.
INSERT INTO Libri (id, titolo, autore_id, anno, genere) VALUES
    (1, 'Il mistero del castello',  1, 2020, 'Giallo'),
    (2, 'Viaggio nel tempo',         1, 2018, 'Fantascienza'),
    (3, 'La cucina italiana',        2, 2019, 'Cucina'),
    (4, 'Storia antica',             3, 2021, 'Storia'),
    (5, 'Romanzo moderno',           3, 2022, 'Narrativa'),
    (6, 'Il ritorno del castello',   1, 2023, 'Giallo');

-- Prestiti: alcuni con data_restituzione, altri NULL (in corso).
INSERT INTO Prestiti (id, libro_id, utente, data_prestito, data_restituzione) VALUES
    (1, 1, 'Mario Rossi',      '2023-01-01', '2023-01-15'),
    (2, 2, 'Lucia Bianchi',    '2023-02-01', NULL),         -- non restituito
    (3, 3, 'Alessandro Verdi', '2023-03-01', '2023-03-10'),
    (4, 4, 'Mario Rossi',      '2023-04-01', NULL);          -- non restituito

-- ============================================================
-- VERIFICA: conta i record inseriti in ogni tabella
-- ============================================================
SELECT 'Autori:'   AS info, COUNT(*) FROM Autori
UNION ALL SELECT 'Libri:',    COUNT(*) FROM Libri
UNION ALL SELECT 'Prestiti:', COUNT(*) FROM Prestiti;
