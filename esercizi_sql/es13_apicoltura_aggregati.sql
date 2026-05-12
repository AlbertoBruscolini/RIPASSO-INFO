-- ============================================================
-- ESERCIZIO 13 — Aggregati Apicoltura (sql-exercises/es03)
-- ============================================================
-- Query con GROUP BY, HAVING, JOIN multipli su database
-- apicoltura. Analisi della produzione.
-- ============================================================

-- Q1) Produzione totale per anno
-- GROUP BY anno → un gruppo per ogni anno presente nei dati.
-- SUM(quantita) → somma le quantità di ciascun gruppo.
SELECT anno, ROUND(SUM(quantita), 2) AS totale_kg
FROM Production
GROUP BY anno
ORDER BY anno;


-- Q2) Media produzione per apiario (su tutti gli anni)
-- AVG e COUNT su ogni gruppo (apiario).
SELECT
    apiary_code,
    ROUND(AVG(quantita), 2) AS media_kg,
    COUNT(*)                 AS num_anni       -- numero di anni con dati
FROM Production
GROUP BY apiary_code
ORDER BY media_kg DESC;


-- Q3) Apiari con produzione totale superiore a 200 kg (HAVING)
-- HAVING filtra DOPO l'aggregazione: solo i gruppi con SUM > 200.
SELECT
    apiary_code,
    ROUND(SUM(quantita), 2) AS totale_kg
FROM Production
GROUP BY apiary_code
HAVING SUM(quantita) > 200
ORDER BY totale_kg DESC;


-- Q4) Produzione per tipo di miele e per anno
-- GROUP BY su PIÙ colonne → raggruppa per (miele, anno) combinato.
-- Esempio: Millefiori-2022, Millefiori-2023, Acacia-2022, ...
SELECT
    h.denominazione,
    p.anno,
    ROUND(SUM(p.quantita), 2) AS totale_kg
FROM Production p
JOIN Honey h ON p.honey_id = h.id
GROUP BY h.id, p.anno
ORDER BY h.denominazione, p.anno;


-- Q5) Per ogni anno: produzione massima e minima
-- MAX e MIN su ogni gruppo (anno).
SELECT
    anno,
    MAX(quantita) AS massima,
    MIN(quantita) AS minima
FROM Production
GROUP BY anno;


-- Q6) Produzione media per arnia (totale / num_arnie per apiario)
-- Combinazione di JOIN + GROUP BY + calcolo personalizzato.
-- SUM(quantita) / a.num_arnie → media per arnia.
-- Nota: a.num_arnie è una colonna NON aggregata ma OK perché costante per gruppo.
SELECT
    a.codice,
    a.num_arnie,
    ROUND(SUM(p.quantita), 2)             AS totale_produzione,
    ROUND(SUM(p.quantita)/a.num_arnie, 2) AS media_per_arnia
FROM Apiary    a
JOIN Production p ON a.codice = p.apiary_code
GROUP BY a.codice;


-- Q7) Apicoltori e numero totale di apiari + arnie
-- JOIN per associare apiari e apicoltori, aggregazione su entrambe le metriche.
SELECT
    b.nome,
    COUNT(a.codice)         AS num_apiari,    -- quanti apiari ha questo apicoltore
    SUM(a.num_arnie)        AS totale_arnie    -- quante arnie in totale
FROM Beekeeper b
JOIN Apiary    a ON b.id = a.beekeeper_id
GROUP BY b.id
ORDER BY totale_arnie DESC;


-- Q8) Mieli con la maggiore produzione totale
-- Triple JOIN + GROUP BY + ORDER BY + LIMIT → "top 3".
SELECT
    h.denominazione,
    t.nome                     AS tipologia,
    ROUND(SUM(p.quantita), 2) AS totale_kg
FROM Honey      h
JOIN Typology  t  ON h.typology_id = t.id
JOIN Production p ON h.id          = p.honey_id
GROUP BY h.id
ORDER BY totale_kg DESC
LIMIT 3;
