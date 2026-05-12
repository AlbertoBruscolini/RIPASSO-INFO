-- ============================================================
-- ESERCIZIO 10 — UPDATE e DELETE
-- ============================================================
-- ATTENZIONE: queste query MODIFICANO i dati!
-- Senza WHERE, modificano TUTTE le righe della tabella!
-- Esegui prima un backup o usa una copia del DB.
-- ============================================================

-- Q1) Aumenta di 1 punto i voti di Informatica (max 30)
-- UPDATE tabella SET colonna = nuovo_valore WHERE condizione
-- MIN(a, b) → restituisce il minore tra a e b → "tetto" al voto 30.
UPDATE Esami
SET Voto = MIN(Voto + 1, 30)
WHERE Corso = 'Informatica';


-- Q2) Aggiorna il cognome dello studente con matricola 101
-- WHERE con condizione su PK → modifica una sola riga.
UPDATE Studenti
SET Cognome = 'Rossi-Verdi'
WHERE Matricola = 101;


-- Q3) Segna come restituito il prestito id=2 (database libreria)
-- UPDATE per "chiudere" un prestito (campo NULL → data).
UPDATE Prestiti
SET data_restituzione = '2024-01-15'
WHERE id = 2;


-- Q4) Cancella tutti gli esami con voto 18
-- DELETE FROM tabella WHERE condizione → cancella le righe corrispondenti.
-- ATTENZIONE: senza WHERE cancellerebbe TUTTE le righe!
DELETE FROM Esami
WHERE Voto = 18;


-- Q5) Cancella un prestito specifico
DELETE FROM Prestiti
WHERE id = 4;


-- Q6) UPDATE con sottoquery: aggiungi 1 voto agli esami
--    degli studenti con media inferiore a 25
--
-- Sottoquery (subquery): una SELECT dentro un'altra istruzione.
-- Qui: prima troviamo le matricole con media < 25, poi le usiamo nella WHERE.
UPDATE Esami
SET Voto = Voto + 1
WHERE Matricola IN (
    -- Sottoquery: restituisce le matricole degli studenti "in difficoltà"
    SELECT Matricola
    FROM Esami
    GROUP BY Matricola
    HAVING AVG(Voto) < 25
)
AND Voto < 30;        -- non superare mai il massimo


-- Q7) DELETE con sottoquery: cancella i prestiti dei libri
--    con anno < 2019
-- Sottoquery che restituisce gli id dei libri "vecchi".
DELETE FROM Prestiti
WHERE libro_id IN (
    SELECT id FROM Libri WHERE anno < 2019
);
