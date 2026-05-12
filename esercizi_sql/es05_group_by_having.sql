-- ============================================================
-- ESERCIZIO 05 — GROUP BY e HAVING
-- ============================================================
-- GROUP BY raggruppa le righe che hanno lo STESSO valore in
-- una o più colonne, e applica le funzioni aggregate
-- separatamente a ogni gruppo.
-- ============================================================

-- Q1) Numero di esami per corso
-- GROUP BY Corso → crea un gruppo per ogni corso distinto.
-- COUNT(*) viene calcolato SU OGNI GRUPPO (non sul totale).
-- ORDER BY usa l'alias creato nella SELECT.
SELECT Corso, COUNT(*) AS num_esami
FROM Esami
GROUP BY Corso
ORDER BY num_esami DESC;


-- Q2) Media voti per corso
-- Per ogni corso (gruppo), calcola la media dei voti.
SELECT Corso, ROUND(AVG(Voto), 2) AS media
FROM Esami
GROUP BY Corso
ORDER BY media DESC;


-- Q3) Per ogni studente: numero esami e media
-- Possiamo aggregare su più funzioni nello stesso GROUP BY.
SELECT
    Matricola,
    COUNT(*)            AS num_esami,        -- quanti esami ha sostenuto
    ROUND(AVG(Voto), 2) AS media,             -- voto medio
    MAX(Voto)           AS voto_massimo       -- voto più alto
FROM Esami
GROUP BY Matricola
ORDER BY media DESC;


-- Q4) HAVING: solo corsi con media superiore a 26
-- IMPORTANTE: WHERE filtra le RIGHE, HAVING filtra i GRUPPI.
-- HAVING può usare funzioni aggregate (AVG, COUNT, ...), WHERE no.
SELECT Corso, ROUND(AVG(Voto), 2) AS media
FROM Esami
GROUP BY Corso
HAVING AVG(Voto) > 26;     -- senza HAVING tornerebbero tutti i corsi


-- Q5) HAVING: studenti con almeno 3 esami sostenuti
SELECT Matricola, COUNT(*) AS num_esami
FROM Esami
GROUP BY Matricola
HAVING COUNT(*) >= 3;


-- Q6) WHERE + GROUP BY + HAVING insieme
--     Media voti per studente, considerando solo esami passati,
--     mostrando solo studenti con media >= 27
--
-- ORDINE DI ESECUZIONE SQL (importante!):
--   1. FROM       → seleziona la tabella
--   2. WHERE      → filtra le righe (PRIMA dell'aggregazione)
--   3. GROUP BY   → raggruppa
--   4. HAVING     → filtra i gruppi
--   5. SELECT     → calcola le colonne
--   6. ORDER BY   → ordina il risultato
--   7. LIMIT      → limita il numero di righe
SELECT
    Matricola,
    ROUND(AVG(Voto), 2) AS media_passati,
    COUNT(*)            AS esami_passati
FROM Esami
WHERE Voto >= 18           -- filtra le righe PRIMA del raggruppamento
GROUP BY Matricola
HAVING AVG(Voto) >= 27;   -- filtra i gruppi DOPO l'aggregazione


-- Q7) Quanti studenti hanno preso 30?
-- DISTINCT dentro COUNT → conta studenti unici (non occorrenze).
-- Senza DISTINCT, uno studente con due 30 verrebbe contato due volte.
SELECT COUNT(DISTINCT Matricola) AS numero_lode
FROM Esami
WHERE Voto = 30;
