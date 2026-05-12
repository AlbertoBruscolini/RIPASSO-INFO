-- ============================================================
-- ESERCIZIO 15 — Query E-Commerce
-- ============================================================
-- Prerequisito: es14_ecommerce_setup.sql
-- ============================================================

-- Q1) Totale di ogni ordine (somma dei sub-totali delle righe)
-- Strategia: JOIN sulle 3 tabelle, GROUP BY ordine, SUM dei subtotali.
-- subtotale di una riga = quantita * prezzo_unitario.
SELECT
    o.id                                            AS ordine_id,
    c.nome                                          AS cliente,
    o.data_ordine,
    ROUND(SUM(r.quantita * r.prezzo_unitario), 2)  AS totale
FROM Ordine     o
JOIN Cliente    c ON o.cliente_id = c.id          -- ordine → cliente
JOIN RigaOrdine r ON o.id = r.ordine_id           -- ordine → righe
GROUP BY o.id                                       -- un gruppo per ogni ordine
ORDER BY totale DESC;


-- Q2) Cliente che ha speso di più
-- Stesso pattern: JOIN + GROUP BY + ORDER BY + LIMIT 1.
SELECT
    c.nome,
    ROUND(SUM(r.quantita * r.prezzo_unitario), 2) AS spesa_totale
FROM Cliente    c
JOIN Ordine     o ON c.id = o.cliente_id
JOIN RigaOrdine r ON o.id = r.ordine_id
GROUP BY c.id          -- raggruppo per cliente
ORDER BY spesa_totale DESC
LIMIT 1;               -- prendo solo il top 1


-- Q3) Prodotti più venduti (per quantità totale)
-- Per ogni prodotto sommiamo le quantità vendute nelle varie righe d'ordine.
SELECT
    p.nome,
    SUM(r.quantita) AS totale_venduti
FROM Prodotto   p
JOIN RigaOrdine r ON p.id = r.prodotto_id
GROUP BY p.id
ORDER BY totale_venduti DESC;


-- Q4) Numero ordini per stato
-- Aggregazione semplice senza JOIN.
SELECT stato, COUNT(*) AS numero
FROM Ordine
GROUP BY stato;


-- Q5) Clienti che non hanno mai ordinato (LEFT JOIN)
-- Tecnica classica per trovare "orfani":
--   LEFT JOIN + WHERE colonna_destra IS NULL.
SELECT c.nome, c.email
FROM Cliente c
LEFT JOIN Ordine o ON c.id = o.cliente_id
WHERE o.id IS NULL;          -- nessun ordine associato


-- Q6) Fatturato per categoria di prodotto
-- Aggrega le righe d'ordine per categoria.
SELECT
    p.categoria,
    ROUND(SUM(r.quantita * r.prezzo_unitario), 2) AS fatturato
FROM Prodotto   p
JOIN RigaOrdine r ON p.id = r.prodotto_id
GROUP BY p.categoria
ORDER BY fatturato DESC;


-- Q7) Dettaglio completo di un ordine (id = 1)
-- Mostra tutte le righe di un ordine specifico col nome dei prodotti.
SELECT
    p.nome,
    r.quantita,
    r.prezzo_unitario,
    ROUND(r.quantita * r.prezzo_unitario, 2) AS subtotale
FROM RigaOrdine r
JOIN Prodotto   p ON r.prodotto_id = p.id
WHERE r.ordine_id = 1;       -- filtra solo l'ordine 1


-- Q8) Prodotti con stock basso (< 50)
-- Query semplice di filtro: utile per il magazziniere.
SELECT nome, stock, categoria
FROM Prodotto
WHERE stock < 50
ORDER BY stock ASC;          -- più scarsi in cima
