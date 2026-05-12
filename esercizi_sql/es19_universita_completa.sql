-- ============================================================
-- ESERCIZIO 19 — Università (Setup + Query AVANZATO)
-- ============================================================
-- 5 tabelle con relazione N:N (Iscrizione studente-corso).
-- Include: CHECK constraint, media ponderata, EXISTS, JOIN multipli.
-- ============================================================

PRAGMA foreign_keys = ON;

-- Eliminazione tabelle nell'ordine corretto.
DROP TABLE IF EXISTS Iscrizione;
DROP TABLE IF EXISTS Corso;
DROP TABLE IF EXISTS Professore;
DROP TABLE IF EXISTS Dipartimento;
DROP TABLE IF EXISTS Studente;

-- Dipartimento: nome UNIQUE per evitare duplicati ("Informatica" una sola volta).
CREATE TABLE Dipartimento (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

-- Professore: appartiene a un dipartimento.
CREATE TABLE Professore (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nome            TEXT NOT NULL,
    cognome         TEXT NOT NULL,
    dipartimento_id INTEGER,
    FOREIGN KEY (dipartimento_id) REFERENCES Dipartimento(id)
);

-- Studente: PK = matricola (non auto-increment, valore manuale).
CREATE TABLE Studente (
    matricola    INTEGER PRIMARY KEY,
    nome         TEXT NOT NULL,
    cognome      TEXT NOT NULL,
    data_nascita TEXT
);

-- Corso: ha un professore + CHECK sui crediti.
CREATE TABLE Corso (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome          TEXT NOT NULL,
    crediti       INTEGER NOT NULL CHECK (crediti > 0),    -- crediti positivi
    professore_id INTEGER,
    FOREIGN KEY (professore_id) REFERENCES Professore(id)
);

-- Iscrizione: tabella N:N tra Studente e Corso.
-- PK composta = uno studente può iscriversi a un corso solo una volta.
-- CHECK sul voto: deve essere nel range 18-30 (votazione italiana).
CREATE TABLE Iscrizione (
    studente_id INTEGER NOT NULL,
    corso_id    INTEGER NOT NULL,
    data_esame  TEXT,
    voto        INTEGER CHECK (voto BETWEEN 18 AND 30),
    PRIMARY KEY (studente_id, corso_id),
    FOREIGN KEY (studente_id) REFERENCES Studente(matricola),
    FOREIGN KEY (corso_id)    REFERENCES Corso(id)
);

-- ============================================================
-- DATI
-- ============================================================

INSERT INTO Dipartimento (nome) VALUES
    ('Informatica'), ('Matematica'), ('Fisica');

INSERT INTO Professore (nome, cognome, dipartimento_id) VALUES
    ('Marco',  'Rossi',   1),
    ('Anna',   'Bianchi', 1),
    ('Paolo',  'Verdi',   2),
    ('Sara',   'Galli',   3);

INSERT INTO Studente (matricola, nome, cognome, data_nascita) VALUES
    (1001, 'Luca',     'Costa',  '2002-04-15'),
    (1002, 'Giulia',   'Marini', '2003-07-22'),
    (1003, 'Federico', 'Russo',  '2001-11-30'),
    (1004, 'Elena',    'Greco',  '2002-09-05');

INSERT INTO Corso (nome, crediti, professore_id) VALUES
    ('Programmazione',      9,  1),
    ('Database',            6,  2),
    ('Analisi Matematica',  12, 3),
    ('Fisica I',            9,  4);

-- Iscrizioni: alcuni studenti con tutti gli esami, altri parziali.
INSERT INTO Iscrizione VALUES
    (1001, 1, '2024-06-15', 28),
    (1001, 2, '2024-07-10', 30),
    (1001, 3, '2024-09-01', 25),
    (1002, 1, '2024-06-15', 26),
    (1002, 2, '2024-07-10', 28),
    (1002, 4, '2024-09-20', 30),
    (1003, 1, '2024-06-15', 22),
    (1003, 3, '2024-09-01', 18),
    (1004, 2, '2024-07-10', 30);

-- ============================================================
-- QUERY AVANZATE
-- ============================================================

-- Q1) Tutti gli esami con info complete (4 JOIN)
-- Mostra come navigare un grafo di relazioni con JOIN concatenati.
-- L'output è una "vista denormalizzata" che combina tutte le info.
SELECT
    s.nome || ' ' || s.cognome AS studente,
    c.nome                     AS corso,
    c.crediti,
    p.cognome                  AS docente,
    d.nome                     AS dipartimento,
    i.voto,
    i.data_esame
FROM Iscrizione   i
JOIN Studente     s ON i.studente_id = s.matricola
JOIN Corso        c ON i.corso_id    = c.id
JOIN Professore   p ON c.professore_id = p.id
JOIN Dipartimento d ON p.dipartimento_id = d.id
ORDER BY studente, c.nome;


-- Q2) Media voti per studente (con somma crediti)
-- MEDIA SEMPLICE: AVG dei voti (ogni esame pesa uguale).
-- MEDIA PONDERATA: somma(voto*crediti)/somma(crediti) → tiene conto del peso del corso.
-- La ponderata è quella che conta per la laurea in università.
SELECT
    s.nome,
    s.cognome,
    COUNT(i.corso_id)         AS esami_sostenuti,
    SUM(c.crediti)             AS crediti_acquisiti,
    ROUND(AVG(i.voto), 2)     AS media,
    -- Media ponderata: ogni voto pesa per i crediti del corso.
    -- Il "* 1.0" forza la divisione a virgola mobile (evita la divisione intera).
    ROUND(SUM(i.voto * c.crediti) * 1.0 / SUM(c.crediti), 2) AS media_ponderata
FROM Studente   s
JOIN Iscrizione i ON s.matricola = i.studente_id
JOIN Corso      c ON i.corso_id  = c.id
GROUP BY s.matricola
ORDER BY media_ponderata DESC;


-- Q3) Numero studenti iscritti per corso
-- LEFT JOIN garantisce che anche i corsi senza iscritti appaiano nel report.
SELECT
    c.nome,
    COUNT(i.studente_id) AS num_iscritti
FROM Corso c
LEFT JOIN Iscrizione i ON c.id = i.corso_id
GROUP BY c.id
ORDER BY num_iscritti DESC;


-- Q4) Professori e numero esami corretti
-- Catena di LEFT JOIN: professore → corso → iscrizione.
-- Anche prof senza corsi (o corsi senza iscritti) appaiono con count=0.
SELECT
    p.nome,
    p.cognome,
    COUNT(i.studente_id) AS esami_corretti
FROM Professore p
LEFT JOIN Corso       c ON p.id = c.professore_id
LEFT JOIN Iscrizione  i ON c.id = i.corso_id
GROUP BY p.id;


-- Q5) Studenti con tutti gli esami passati con voto >= 25
-- Logica: NESSUN esame con voto < 25 AND ALMENO UN esame esiste.
-- NOT EXISTS → vero se la subquery non restituisce nulla.
-- EXISTS → vero se la subquery restituisce almeno una riga.
SELECT s.nome, s.cognome
FROM Studente s
WHERE NOT EXISTS (
    -- Nessun esame "negativo" (voto < 25)
    SELECT 1 FROM Iscrizione i
    WHERE i.studente_id = s.matricola AND i.voto < 25
)
AND EXISTS (
    -- Almeno un esame esiste (escludiamo studenti senza esami)
    SELECT 1 FROM Iscrizione i WHERE i.studente_id = s.matricola
);
