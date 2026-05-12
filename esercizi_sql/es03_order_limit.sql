-- ============================================================
-- ESERCIZIO 03 — ORDER BY, LIMIT, OFFSET
-- ============================================================
-- ORDER BY: ordina le righe del risultato.
-- LIMIT:    limita il numero di righe restituite.
-- OFFSET:   salta le prime N righe (utile per paginazione).
-- ============================================================

-- Q1) Esami dal voto più alto al più basso
-- DESC = descending (decrescente). ASC = ascending (default, crescente).
-- Si può omettere ASC perché è il default.
SELECT * FROM Esami
ORDER BY Voto DESC;


-- Q2) Ordinamento multiplo: prima per corso (A-Z), poi per voto (alto-basso)
-- L'ordine ha senso solo a parità del campo precedente.
-- Esempio: tutti gli esami di Fisica vengono ordinati per voto DESC;
-- poi tutti quelli di Informatica per voto DESC; ecc.
SELECT * FROM Esami
ORDER BY Corso ASC, Voto DESC;


-- Q3) I 3 voti più alti
-- LIMIT N → restituisce al massimo N righe.
-- Combinato con ORDER BY DESC → "top N".
SELECT * FROM Esami
ORDER BY Voto DESC
LIMIT 3;


-- Q4) I 3 voti più bassi
-- ASC + LIMIT → "bottom N".
SELECT * FROM Esami
ORDER BY Voto ASC
LIMIT 3;


-- Q5) Paginazione: pagina 2 con 3 risultati per pagina
--    (salta 3, prendi 3)
-- OFFSET salta le prime N righe del risultato.
-- Formula generica: OFFSET = (numero_pagina - 1) * righe_per_pagina
-- Es. pagina 2 con 3 righe/pagina → OFFSET = (2-1)*3 = 3
SELECT * FROM Esami
ORDER BY Id           -- ordinamento stabile, fondamentale per la paginazione
LIMIT 3 OFFSET 3;


-- Q6) Studenti ordinati per cognome (A-Z) e a parità di cognome per nome
-- Esempio: "Rossi Alessio" prima di "Rossi Bruno".
SELECT * FROM Studenti
ORDER BY Cognome ASC, Nome ASC;
