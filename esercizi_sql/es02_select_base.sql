-- ============================================================
-- ESERCIZIO 02 — SELECT base (database Scuola)
-- ============================================================
-- 8 query di selezione semplice. Esegui ognuna separatamente.
-- Prerequisito: aver eseguito es01_setup_scuola.sql
-- ============================================================

-- Q1) Tutti gli studenti
-- SELECT * → "tutte le colonne". È sconsigliato in produzione perché:
--   - se la tabella cambia, anche il risultato cambia silenziosamente;
--   - è più lento (legge dati che magari non servono).
-- In esempi/test però va benissimo.
SELECT * FROM Studenti;


-- Q2) Solo nome e cognome
-- Elencando le colonne otteniamo solo i campi che ci servono.
-- L'ordine nella SELECT determina l'ordine delle colonne in output.
SELECT Nome, Cognome FROM Studenti;


-- Q3) Tutti gli esami con voto >= 27
-- WHERE filtra le righe: vengono mostrate SOLO quelle che soddisfano la condizione.
-- Operatori di confronto: =, <>, !=, <, >, <=, >=
SELECT * FROM Esami
WHERE Voto >= 27;


-- Q4) Esami di Matematica con voto >= 25
-- AND → entrambe le condizioni devono essere VERE.
-- OR  → almeno UNA condizione deve essere VERA.
-- Stringhe SQL: si usano gli apici singoli ('Matematica'), MAI doppi.
SELECT * FROM Esami
WHERE Corso = 'Matematica' AND Voto >= 25;


-- Q5) Esami di Matematica O di Fisica (uso IN)
-- IN (...) è più leggibile di una catena di OR.
-- Equivalente a: WHERE Corso = 'Matematica' OR Corso = 'Fisica'.
SELECT * FROM Esami
WHERE Corso IN ('Matematica', 'Fisica');


-- Q6) Studenti con cognome che inizia per 'B'
-- LIKE serve per la ricerca testuale "fuzzy".
--   %  → qualsiasi sequenza di caratteri (zero o più)
--   _  → un singolo carattere
-- 'B%'   = inizia con B
-- '%n'   = finisce con n
-- '%ar%' = contiene "ar"
SELECT * FROM Studenti
WHERE Cognome LIKE 'B%';


-- Q7) Esami con voto compreso tra 25 e 28 (estremi inclusi)
-- BETWEEN x AND y equivale a: campo >= x AND campo <= y.
-- Funziona anche con date e numeri decimali.
SELECT * FROM Esami
WHERE Voto BETWEEN 25 AND 28;


-- Q8) Lista dei corsi unici (senza duplicati)
-- DISTINCT elimina i duplicati nel risultato.
-- ORDER BY ordina le righe: ASC = crescente (default), DESC = decrescente.
SELECT DISTINCT Corso FROM Esami
ORDER BY Corso;
