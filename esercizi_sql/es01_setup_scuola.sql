-- ============================================================
-- ESERCIZIO 01 — Setup database "Scuola" (DDL + INSERT)
-- ============================================================
-- Crea le tabelle Studenti ed Esami con dati di esempio.
-- Studente: Matricola PK, Nome, Cognome.
-- Esami: Id PK autoincrement, Matricola FK, Corso, Voto.
-- Fonte: db/scuola.sql + python-sqlite-exercises/es04
-- ============================================================

-- PRAGMA è un comando speciale di SQLite per impostare opzioni del DB.
-- foreign_keys = ON attiva il controllo dei vincoli di chiave esterna.
-- Senza questo, SQLite NON controlla che le FK siano valide!
PRAGMA foreign_keys = ON;

-- DROP TABLE IF EXISTS → elimina la tabella se esiste (utile per reset).
-- IMPORTANTE: cancella PRIMA la tabella figlia (Esami) per via delle FK,
-- POI la tabella padre (Studenti). L'ordine è inverso rispetto alla creazione.
DROP TABLE IF EXISTS Esami;
DROP TABLE IF EXISTS Studenti;

-- ============================================================
-- DDL: CREAZIONE DELLE TABELLE
-- ============================================================

-- Tabella "padre": Studenti
CREATE TABLE Studenti (
    Matricola INTEGER PRIMARY KEY,   -- PK: identificatore univoco di ogni studente
    Nome      TEXT NOT NULL,         -- NOT NULL: il campo NON può essere vuoto
    Cognome   TEXT NOT NULL
);

-- Tabella "figlia": Esami (un esame appartiene a uno studente)
CREATE TABLE Esami (
    -- AUTOINCREMENT → il valore viene assegnato automaticamente da SQLite
    Id        INTEGER PRIMARY KEY AUTOINCREMENT,
    Matricola INTEGER NOT NULL,      -- riferimento allo studente
    Corso     TEXT    NOT NULL,
    Voto      INTEGER NOT NULL,
    -- FOREIGN KEY: dichiara che Matricola in Esami punta a Matricola in Studenti.
    -- Garantisce che non si possa inserire un esame con matricola inesistente.
    FOREIGN KEY (Matricola) REFERENCES Studenti(Matricola)
);

-- ============================================================
-- DML: INSERIMENTO DEI DATI
-- ============================================================

-- INSERT INTO ... VALUES ... → inserisce nuove righe nella tabella.
-- Elencando le colonne possiamo scegliere quali campi popolare
-- (gli altri prendono il default o NULL).
INSERT INTO Studenti (Matricola, Nome, Cognome) VALUES
    (101, 'Mario',    'Rossi'),
    (102, 'Lucia',    'Bianchi'),
    (103, 'Paolo',    'Verdi'),
    (104, 'Giulia',   'Neri'),
    (105, 'Francesco','Galli');    -- studente intenzionalmente SENZA esami

-- Inseriamo gli esami SENZA specificare Id (autoincrement lo genera).
INSERT INTO Esami (Matricola, Corso, Voto) VALUES
    (101, 'Matematica',  28),
    (101, 'Informatica', 30),
    (101, 'Fisica',      27),
    (102, 'Matematica',  25),
    (102, 'Informatica', 30),
    (102, 'Fisica',      22),
    (103, 'Matematica',  18),
    (103, 'Informatica', 24),
    (104, 'Matematica',  30),
    (104, 'Informatica', 28),
    (104, 'Fisica',      29);
-- Studente 105 (Francesco Galli) NON ha esami → utile per LEFT JOIN

-- ============================================================
-- VERIFICA: conta le righe inserite
-- ============================================================
-- UNION ALL unisce i risultati di più SELECT in una sola tabella
-- (senza eliminare i duplicati, a differenza di UNION semplice).
SELECT 'Studenti inseriti:' AS info, COUNT(*) AS totale FROM Studenti
UNION ALL
SELECT 'Esami inseriti:',           COUNT(*)            FROM Esami;
