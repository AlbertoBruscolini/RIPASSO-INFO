-- ============================================================
-- ESERCIZIO 08 — Query Libreria (sql-exercises/es06)
-- ============================================================
-- 7 query base/intermedie sulla libreria.
-- Prerequisito: es07_setup_libreria.sql eseguito
-- ============================================================

-- Q1) Titolo libro + nome autore (JOIN)
-- || concatena stringhe: 'nome' || ' ' || 'cognome' → "nome cognome".
-- L'INNER JOIN unisce Libri e Autori dove autore_id corrisponde all'id dell'autore.
SELECT l.titolo, a.nome || ' ' || a.cognome AS autore
FROM Libri  l
JOIN Autori a ON l.autore_id = a.id
ORDER BY l.titolo;


-- Q2) Tutti i prestiti con titolo libro e utente
-- JOIN tra Prestiti e Libri per arricchire il prestito col titolo del libro.
SELECT p.id, l.titolo, p.utente, p.data_prestito, p.data_restituzione
FROM Prestiti p
JOIN Libri    l ON p.libro_id = l.id
ORDER BY p.data_prestito;


-- Q3) Libri pubblicati dopo il 2020
-- WHERE con confronto numerico sull'anno.
SELECT * FROM Libri
WHERE anno > 2020
ORDER BY anno DESC;


-- Q4) Numero di prestiti per utente
-- Aggregazione semplice: GROUP BY + COUNT.
SELECT utente, COUNT(*) AS num_prestiti
FROM Prestiti
GROUP BY utente
ORDER BY num_prestiti DESC;


-- Q5) Libri ordinati per genere e poi per anno
-- ORDER BY a 2 livelli: prima per genere (A-Z), poi per anno (crescente).
SELECT titolo, genere, anno FROM Libri
ORDER BY genere ASC, anno ASC;


-- Q6) Solo prestiti restituiti (data_restituzione NOT NULL)
-- IS NOT NULL → il campo deve avere un valore (non NULL).
SELECT p.id, l.titolo, p.utente, p.data_restituzione
FROM Prestiti p
JOIN Libri    l ON p.libro_id = l.id
WHERE p.data_restituzione IS NOT NULL;


-- Q7) LEFT JOIN: tutti gli autori con il loro numero di libri,
--    inclusi quelli senza libri
-- LEFT JOIN garantisce che TUTTI gli autori appaiano nel risultato.
-- COUNT(l.id) → conta solo i libri reali (NULL non vengono contati).
-- Se usassimo COUNT(*) anche gli autori senza libri risulterebbero con count=1!
SELECT
    a.nome,
    a.cognome,
    COUNT(l.id) AS num_libri
FROM Autori a
LEFT JOIN Libri l ON a.id = l.autore_id
GROUP BY a.id
ORDER BY num_libri DESC;
