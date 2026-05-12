-- ============================================================
-- ESERCIZIO 16 — Sottoquery (subquery)
-- ============================================================
-- Le sottoquery permettono di usare il risultato di una SELECT
-- dentro un'altra SELECT (o WHERE/UPDATE/DELETE).
--
-- Tipi principali:
--   1. Sottoquery SCALARE → restituisce un singolo valore
--   2. Sottoquery di LISTA → restituisce una colonna di valori (usata con IN)
--   3. Sottoquery CORRELATA → fa riferimento alla query esterna
--   4. Sottoquery EXISTS    → controlla se ci sono risultati
-- ============================================================

-- Q1) Studenti con voto superiore alla media generale (db scuola)
-- La sottoquery SCALARE (SELECT AVG...) restituisce UN SOLO numero
-- che viene usato come confronto nella WHERE esterna.
SELECT s.Nome, s.Cognome, e.Corso, e.Voto
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
WHERE e.Voto > (SELECT AVG(Voto) FROM Esami)   -- subquery scalare
ORDER BY e.Voto DESC;


-- Q2) Libri pubblicati nell'anno più recente (db libreria)
-- La subquery (SELECT MAX...) trova l'anno massimo.
-- Poi la query esterna seleziona i libri di quell'anno.
SELECT * FROM Libri
WHERE anno = (SELECT MAX(anno) FROM Libri);


-- Q3) Autore con più libri (sottoquery + ranking)
-- Step 1 (subquery): trova autore_id con il maggior numero di libri.
-- Step 2 (query esterna): mostra il nome e cognome di quell'autore.
SELECT a.nome, a.cognome
FROM Autori a
WHERE a.id = (
    SELECT autore_id
    FROM Libri
    GROUP BY autore_id
    ORDER BY COUNT(*) DESC
    LIMIT 1                       -- prende solo il primo (top 1)
);


-- Q4) Clienti che hanno fatto almeno 1 ordine (sottoquery con IN)
-- IN (sottoquery) → la subquery restituisce una LISTA di valori.
-- DISTINCT evita di avere lo stesso cliente_id più volte.
SELECT nome, email FROM Cliente
WHERE id IN (SELECT DISTINCT cliente_id FROM Ordine);


-- Q5) Prodotti il cui prezzo è superiore alla media
-- Sottoquery scalare che calcola la media dei prezzi.
SELECT nome, prezzo FROM Prodotto
WHERE prezzo > (SELECT AVG(prezzo) FROM Prodotto);


-- Q6) NOT IN: prodotti mai venduti
-- NOT IN → l'opposto di IN: il valore NON deve essere nella lista.
-- ATTENZIONE: NOT IN ha problemi con NULL nella subquery!
SELECT nome, categoria FROM Prodotto
WHERE id NOT IN (SELECT DISTINCT prodotto_id FROM RigaOrdine);


-- Q7) Sottoquery correlata: per ogni ordine il totale
-- "Correlata" = la sottoquery fa riferimento alla riga esterna (qui: o.id).
-- Viene eseguita UNA VOLTA PER OGNI RIGA della tabella esterna (lenta!).
-- Spesso si può riscrivere con JOIN + GROUP BY (più efficiente).
SELECT
    o.id,
    o.data_ordine,
    (SELECT ROUND(SUM(r.quantita * r.prezzo_unitario), 2)
     FROM RigaOrdine r
     WHERE r.ordine_id = o.id) AS totale_ordine    -- riferimento a o.id
FROM Ordine o;


-- Q8) EXISTS: studenti che hanno preso almeno un 30
-- EXISTS (subquery) → TRUE se la subquery restituisce ALMENO UNA riga.
-- "SELECT 1" è una convenzione: non importa cosa restituisce la subquery,
-- importa solo SE restituisce qualcosa.
-- Più efficiente di IN su grandi quantità di dati.
SELECT s.Nome, s.Cognome
FROM Studenti s
WHERE EXISTS (
    SELECT 1 FROM Esami e
    WHERE e.Matricola = s.Matricola AND e.Voto = 30
);
