-- ============================================================
-- ESERCIZIO 06 — JOIN (INNER e LEFT)
-- ============================================================
-- Database: Scuola (Studenti + Esami)
-- Prerequisito: es01_setup_scuola.sql eseguito
--
-- Il JOIN unisce righe di tabelle diverse basandosi su una
-- condizione di uguaglianza (di solito FK = PK).
-- ============================================================

-- Q1) INNER JOIN: studente + tutti i suoi esami
--    (gli studenti senza esami NON appaiono)
--
-- "FROM Studenti s" → 's' è un alias (nome corto) per la tabella.
-- "JOIN Esami e ON ..." → unisci con la tabella Esami quando la condizione è vera.
-- "ON s.Matricola = e.Matricola" → collega le righe dove le matricole coincidono.
SELECT s.Nome, s.Cognome, e.Corso, e.Voto
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
ORDER BY s.Cognome, e.Corso;


-- Q2) JOIN + WHERE: chi ha preso 30 in Informatica?
-- Il JOIN unisce le tabelle, WHERE filtra il risultato unito.
SELECT s.Nome, s.Cognome
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
WHERE e.Corso = 'Informatica' AND e.Voto = 30;


-- Q3) LEFT JOIN: TUTTI gli studenti, anche quelli senza esami
--    (Francesco Galli appare con NULL nei campi di Esami)
--
-- LEFT JOIN mantiene TUTTE le righe della tabella SINISTRA (Studenti).
-- Se non c'è corrispondenza nella tabella destra (Esami),
-- i campi di destra sono NULL.
SELECT s.Nome, s.Cognome, e.Corso, e.Voto
FROM Studenti s
LEFT JOIN Esami e ON s.Matricola = e.Matricola
ORDER BY s.Cognome;


-- Q4) LEFT JOIN per trovare gli "orfani":
--    Studenti che NON hanno mai sostenuto un esame
--
-- Trucco classico: LEFT JOIN + WHERE colonna_destra IS NULL.
-- Otteniamo le righe che NON hanno corrispondenza nella tabella di destra.
SELECT s.Matricola, s.Nome, s.Cognome
FROM Studenti s
LEFT JOIN Esami e ON s.Matricola = e.Matricola
WHERE e.Id IS NULL;          -- studenti senza esami associati


-- Q5) JOIN + GROUP BY: media voti per ogni studente
-- Il JOIN unisce le tabelle, GROUP BY raggruppa per studente,
-- le funzioni aggregate calcolano i totali per ogni gruppo.
SELECT
    s.Nome,
    s.Cognome,
    ROUND(AVG(e.Voto), 2) AS media,
    COUNT(e.Id)            AS num_esami     -- COUNT su e.Id evita di contare NULL
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
GROUP BY s.Matricola           -- meglio raggruppare per la PK
ORDER BY media DESC;


-- Q6) JOIN + GROUP BY + HAVING: solo studenti con media > 27
SELECT
    s.Nome,
    s.Cognome,
    ROUND(AVG(e.Voto), 2) AS media
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
GROUP BY s.Matricola
HAVING AVG(e.Voto) > 27       -- filtra dopo aver calcolato la media
ORDER BY media DESC;
