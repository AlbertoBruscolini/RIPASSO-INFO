-- ============================================================
-- ESERCIZIO 09 — Query AVANZATE Libreria
-- ============================================================

-- Q1) Quanti libri per genere
-- GROUP BY su genere → un gruppo per ogni genere distinto.
SELECT genere, COUNT(*) AS num_libri
FROM Libri
GROUP BY genere
ORDER BY num_libri DESC;


-- Q2) Autori con più di 1 libro
-- JOIN + GROUP BY per associare libri a autori.
-- HAVING filtra i gruppi con COUNT > 1.
SELECT
    a.nome,
    a.cognome,
    COUNT(l.id) AS num_libri
FROM Autori a
JOIN Libri  l ON a.id = l.autore_id
GROUP BY a.id
HAVING COUNT(l.id) > 1
ORDER BY num_libri DESC;


-- Q3) Prestiti non ancora restituiti (data_restituzione IS NULL)
-- julianday(data) → giorni dal 24 nov 4714 a.C. (formato interno SQLite).
-- julianday('now') - julianday(data) → quanti giorni sono passati.
SELECT
    p.id,
    l.titolo,
    p.utente,
    p.data_prestito,
    julianday('now') - julianday(p.data_prestito) AS giorni_aperto
FROM Prestiti p
JOIN Libri    l ON p.libro_id = l.id
WHERE p.data_restituzione IS NULL     -- attenzione: si usa IS NULL, NON = NULL
ORDER BY p.data_prestito;


-- Q4) Per ogni utente: numero prestiti totali, restituiti, in corso
-- CASE WHEN ... THEN ... ELSE ... END → "if/else" in SQL.
-- SUM(CASE WHEN cond THEN 1 ELSE 0 END) → conta condizionalmente.
SELECT
    utente,
    COUNT(*)                                                AS totali,
    -- conta i restituiti (data_restituzione NOT NULL)
    SUM(CASE WHEN data_restituzione IS NOT NULL THEN 1 ELSE 0 END) AS restituiti,
    -- conta gli "in corso" (data_restituzione NULL)
    SUM(CASE WHEN data_restituzione IS NULL     THEN 1 ELSE 0 END) AS in_corso
FROM Prestiti
GROUP BY utente;


-- Q5) Libro più prestato (top 1)
-- Per ogni libro conta i prestiti, ordina decrescente, prendi il primo.
SELECT
    l.titolo,
    COUNT(p.id) AS num_prestiti
FROM Libri    l
JOIN Prestiti p ON l.id = p.libro_id
GROUP BY l.id
ORDER BY num_prestiti DESC
LIMIT 1;


-- Q6) Sottoquery: libri pubblicati dopo l'anno medio
-- La subquery scalare restituisce un singolo numero (la media).
SELECT titolo, anno
FROM Libri
WHERE anno > (SELECT AVG(anno) FROM Libri)
ORDER BY anno DESC;


-- Q7) Libri MAI prestati (LEFT JOIN + IS NULL)
-- Tecnica classica per trovare elementi senza relazione.
SELECT l.titolo, l.genere
FROM Libri l
LEFT JOIN Prestiti p ON l.id = p.libro_id     -- LEFT: mostra TUTTI i libri
WHERE p.id IS NULL;                            -- ...quelli senza prestiti
