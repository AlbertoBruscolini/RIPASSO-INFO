-- ============================================================
-- ESERCIZIO 04 — Funzioni di Aggregazione
-- COUNT, SUM, AVG, MAX, MIN
-- ============================================================
-- Le funzioni di aggregazione operano su INSIEMI di righe
-- e restituiscono UN SOLO valore (il "riepilogo").
-- ============================================================

-- Q1) Quanti studenti?
-- COUNT(*) conta TUTTE le righe (anche con campi NULL).
-- AS totale_studenti → assegna un alias (nome) alla colonna nel risultato.
SELECT COUNT(*) AS totale_studenti FROM Studenti;


-- Q2) Quanti esami in totale?
-- COUNT(colonna) conta solo i valori NON NULL di quella colonna.
-- COUNT(*) conta tutte le righe → da preferire quando vuoi solo il numero di record.
SELECT COUNT(*) AS totale_esami FROM Esami;


-- Q3) Media generale dei voti (arrotondata a 2 decimali)
-- AVG calcola la media aritmetica → somma / numero di righe.
-- ROUND(valore, cifre) arrotonda a un numero di cifre decimali specificato.
-- Es: AVG = 25.4666... → ROUND(..., 2) = 25.47
SELECT ROUND(AVG(Voto), 2) AS media_generale FROM Esami;


-- Q4) Voto massimo e minimo
-- Puoi mettere più funzioni aggregate nella stessa SELECT.
-- Vengono calcolate insieme su tutte le righe.
SELECT MAX(Voto) AS massimo, MIN(Voto) AS minimo FROM Esami;


-- Q5) Somma di tutti i voti
-- SUM(colonna) somma tutti i valori (non NULL) della colonna.
SELECT SUM(Voto) AS somma_voti FROM Esami;


-- Q6) Media voto solo per il corso di Informatica
-- WHERE filtra le righe PRIMA dell'aggregazione.
-- Risultato: una sola riga con la media calcolata sui soli esami di Informatica.
SELECT
    'Informatica'           AS corso,        -- valore costante (stringa)
    ROUND(AVG(Voto), 2)    AS media,        -- media dei voti filtrati
    COUNT(*)                AS num_esami     -- numero di esami filtrati
FROM Esami
WHERE Corso = 'Informatica';


-- Q7) Quanti esami sono stati passati (voto >= 18)?
-- WHERE filtra le righe (in Italia 18 è la sufficienza universitaria).
SELECT COUNT(*) AS passati FROM Esami WHERE Voto >= 18;


-- Q8) Statistiche complete su un colpo solo
-- Quando devi calcolare più aggregati sullo stesso insieme,
-- conviene farlo in un'unica query (più efficiente di 5 query separate).
SELECT
    COUNT(*)                AS totale,    -- numero totale di esami
    ROUND(AVG(Voto), 2)    AS media,     -- voto medio
    MAX(Voto)               AS massimo,   -- voto massimo
    MIN(Voto)               AS minimo,    -- voto minimo
    SUM(Voto)               AS somma      -- somma di tutti i voti
FROM Esami;
