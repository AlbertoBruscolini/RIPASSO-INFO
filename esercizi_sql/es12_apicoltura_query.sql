-- ============================================================
-- ESERCIZIO 12 — Query Apicoltura (sql-exercises/es02)
-- ============================================================
-- 10 query sulla produzione di miele. Prerequisito: es11.
-- ============================================================

-- Q1) Tutti gli apicoltori
-- Query base: nessun filtro, restituisce ogni record della tabella.
SELECT * FROM Beekeeper;


-- Q2) Apicoltore con id = 1
-- Filtro su PK → restituisce al massimo una riga.
SELECT * FROM Beekeeper WHERE id = 1;


-- Q3) Apiari della Toscana
-- Confronto stringhe: 'Toscana' è case-sensitive in SQLite di default.
SELECT * FROM Apiary WHERE regione = 'Toscana';


-- Q4) Apiari con più di 10 arnie
-- Confronto numerico + ordinamento.
SELECT codice, num_arnie, localita, regione
FROM Apiary
WHERE num_arnie > 10
ORDER BY num_arnie DESC;


-- Q5) Apiari dell'apicoltore con id = 1
-- JOIN tra Apiary e Beekeeper per filtrare in base all'apicoltore.
-- In alternativa: SELECT * FROM Apiary WHERE beekeeper_id = 1 (più veloce).
SELECT a.codice, a.localita, a.regione
FROM Apiary  a
JOIN Beekeeper b ON a.beekeeper_id = b.id
WHERE b.id = 1;


-- Q6) Mieli di tipologia "DOP"
-- JOIN per "tradurre" l'id della tipologia nel suo nome.
SELECT h.denominazione, t.nome AS tipologia
FROM Honey h
JOIN Typology t ON h.typology_id = t.id
WHERE t.nome = 'DOP';


-- Q7) Produzioni del 2023
-- Triple JOIN: Production → Apiary, Production → Honey.
SELECT p.anno, p.quantita, a.codice, h.denominazione
FROM Production p
JOIN Apiary a ON p.apiary_code = a.codice
JOIN Honey  h ON p.honey_id    = h.id
WHERE p.anno = 2023;


-- Q8) Produzioni dell'apiario AP001
-- Mostra l'evoluzione delle produzioni di un singolo apiario nel tempo.
SELECT p.anno, p.quantita, h.denominazione
FROM Production p
JOIN Honey h ON p.honey_id = h.id
WHERE p.apiary_code = 'AP001'
ORDER BY p.anno;


-- Q9) Produzioni del miele "Millefiori"
-- Filtra le produzioni in base al nome del miele (non all'id).
SELECT p.anno, p.quantita, p.apiary_code
FROM Production p
JOIN Honey h ON p.honey_id = h.id
WHERE h.denominazione = 'Millefiori';


-- Q10) Produzioni in Toscana negli anni 2023-2024
-- Combinazione di WHERE con AND + BETWEEN.
-- BETWEEN 2023 AND 2024 → equivale a anno >= 2023 AND anno <= 2024.
SELECT p.anno, p.quantita, a.codice, h.denominazione
FROM Production p
JOIN Apiary a ON p.apiary_code = a.codice
JOIN Honey  h ON p.honey_id    = h.id
WHERE a.regione = 'Toscana' AND p.anno BETWEEN 2023 AND 2024;
