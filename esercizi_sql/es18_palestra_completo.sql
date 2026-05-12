-- ============================================================
-- ESERCIZIO 18 — Palestra (Setup + Query, COMPLETO)
-- ============================================================
-- Iscritti, Istruttori, Corsi, Partecipazioni (N:N + data)
-- Esempio di chiave primaria composta con 3 colonne.
-- ============================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Partecipazione;
DROP TABLE IF EXISTS Corso;
DROP TABLE IF EXISTS Istruttore;
DROP TABLE IF EXISTS Iscritto;

-- Iscritto: cliente della palestra. CHECK limita i valori possibili.
CREATE TABLE Iscritto (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    nome             TEXT NOT NULL,
    cognome          TEXT NOT NULL,
    data_iscrizione  TEXT NOT NULL,
    -- CHECK con IN: il tipo può essere SOLO uno dei due valori elencati.
    tipo_abbonamento TEXT CHECK (tipo_abbonamento IN ('Mensile','Annuale'))
);

CREATE TABLE Istruttore (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nome            TEXT NOT NULL,
    cognome         TEXT NOT NULL,
    specializzazione TEXT
);

-- Corso: ogni corso ha un istruttore (FK).
CREATE TABLE Corso (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome          TEXT NOT NULL,
    giorno        TEXT NOT NULL,
    ora_inizio    TEXT NOT NULL,
    durata_min    INTEGER NOT NULL,
    istruttore_id INTEGER,
    FOREIGN KEY (istruttore_id) REFERENCES Istruttore(id)
);

-- Partecipazione: tabella N:N con TIMESTAMP.
-- PK composta da 3 campi: stesso iscritto può ripartecipare al corso in date diverse.
CREATE TABLE Partecipazione (
    iscritto_id          INTEGER NOT NULL,
    corso_id             INTEGER NOT NULL,
    data_partecipazione  TEXT NOT NULL,
    -- PK COMPOSTA: la combinazione (iscritto + corso + data) deve essere unica.
    -- Senza questa, lo stesso iscritto potrebbe risultare due volte nello stesso corso lo stesso giorno.
    PRIMARY KEY (iscritto_id, corso_id, data_partecipazione),
    FOREIGN KEY (iscritto_id) REFERENCES Iscritto(id),
    FOREIGN KEY (corso_id)    REFERENCES Corso(id)
);

-- ============================================================
-- DATI DI ESEMPIO
-- ============================================================

INSERT INTO Iscritto (nome, cognome, data_iscrizione, tipo_abbonamento) VALUES
    ('Mario',  'Rossi',   '2024-01-15', 'Annuale'),
    ('Giulia', 'Verdi',   '2024-09-01', 'Mensile'),
    ('Luca',   'Bianchi', '2024-03-10', 'Annuale');

INSERT INTO Istruttore (nome, cognome, specializzazione) VALUES
    ('Anna',  'Neri',    'Yoga'),
    ('Carlo', 'Galli',   'Crossfit'),
    ('Sara',  'Costa',   'Pilates');

INSERT INTO Corso (nome, giorno, ora_inizio, durata_min, istruttore_id) VALUES
    ('Yoga Mattutino',    'Lunedì',   '08:00', 60, 1),
    ('Crossfit Intenso',  'Martedì',  '19:00', 75, 2),
    ('Pilates',           'Mercoledì','18:00', 50, 3),
    ('Yoga Serale',       'Giovedì',  '20:00', 60, 1);   -- stesso istruttore Anna

-- Partecipazioni: simuliamo alcuni giorni di frequentazione.
INSERT INTO Partecipazione VALUES
    (1, 1, '2024-10-07'),       -- Mario al Yoga il 7/10
    (1, 1, '2024-10-14'),       -- Mario al Yoga il 14/10 (diverso giorno)
    (1, 4, '2024-10-10'),
    (2, 1, '2024-10-07'),
    (2, 3, '2024-10-09'),
    (3, 2, '2024-10-08'),
    (3, 2, '2024-10-15');

-- ============================================================
-- QUERY
-- ============================================================

-- Q1) Tutti i corsi con nome istruttore
-- JOIN per "decodificare" l'istruttore_id nel nome+cognome.
SELECT c.nome, c.giorno, c.ora_inizio,
       i.nome || ' ' || i.cognome AS istruttore
FROM Corso c
JOIN Istruttore i ON c.istruttore_id = i.id
ORDER BY c.giorno;


-- Q2) Numero partecipazioni per iscritto
-- LEFT JOIN per includere anche gli iscritti senza partecipazioni.
-- COUNT(p.iscritto_id) → conta solo i record reali (NULL non vengono contati).
SELECT
    i.nome,
    i.cognome,
    COUNT(p.iscritto_id) AS partecipazioni
FROM Iscritto i
LEFT JOIN Partecipazione p ON i.id = p.iscritto_id
GROUP BY i.id
ORDER BY partecipazioni DESC;


-- Q3) Corsi più frequentati
-- LEFT JOIN per includere anche corsi senza partecipazioni.
SELECT
    c.nome,
    COUNT(p.corso_id) AS num_partecipazioni
FROM Corso c
LEFT JOIN Partecipazione p ON c.id = p.corso_id
GROUP BY c.id
ORDER BY num_partecipazioni DESC;


-- Q4) Iscritti che hanno frequentato corsi di Yoga
-- DISTINCT evita di mostrare lo stesso iscritto più volte
-- (Mario ha partecipato a Yoga più di una volta).
-- LIKE 'Yoga%' cattura sia "Yoga Mattutino" che "Yoga Serale".
SELECT DISTINCT i.nome, i.cognome
FROM Iscritto       i
JOIN Partecipazione p ON i.id = p.iscritto_id
JOIN Corso          c ON p.corso_id = c.id
WHERE c.nome LIKE 'Yoga%';
