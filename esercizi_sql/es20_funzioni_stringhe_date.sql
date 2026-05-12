-- ============================================================
-- ESERCIZIO 20 — Funzioni su Stringhe e Date in SQLite
-- ============================================================
-- SQLite mette a disposizione molte funzioni built-in per
-- manipolare stringhe e date. Vediamo le più utili.
-- ============================================================

-- ----- STRINGHE -----

-- Q1) Concatenazione con ||
-- || è l'operatore di concatenazione in SQL standard.
-- (In MySQL invece si usa la funzione CONCAT(...)).
SELECT Nome || ' ' || Cognome AS nominativo
FROM Studenti;


-- Q2) UPPER, LOWER, LENGTH
-- UPPER  → tutto maiuscolo
-- LOWER  → tutto minuscolo
-- LENGTH → lunghezza in caratteri
SELECT
    UPPER(Nome)     AS nome_maiuscolo,
    LOWER(Cognome)  AS cognome_minuscolo,
    LENGTH(Nome)    AS lunghezza_nome
FROM Studenti;


-- Q3) SUBSTR (sottostringa) — primi 3 caratteri del cognome
-- SUBSTR(stringa, inizio, lunghezza)
-- ATTENZIONE: gli indici in SQL partono da 1 (NON da 0 come in Python).
SELECT Cognome, SUBSTR(Cognome, 1, 3) AS prime_3_lettere
FROM Studenti;


-- Q4) REPLACE — sostituisce 'a' con '@'
-- REPLACE(stringa, da_cercare, sostituto) → cambia tutte le occorrenze.
SELECT REPLACE(Nome, 'a', '@') AS nome_modificato
FROM Studenti;


-- Q5) LIKE con caratteri jolly
--     % = qualsiasi sequenza di caratteri (zero o più)
--     _ = un singolo carattere
-- Esempio: '_o%' = la seconda lettera è 'o', il resto qualsiasi.
SELECT * FROM Studenti
WHERE Cognome LIKE '_o%';


-- Q6) TRIM — rimuove spazi all'inizio e alla fine
-- Esistono anche LTRIM (solo a sinistra) e RTRIM (solo a destra).
SELECT TRIM('   spazi   ') AS pulito;


-- ----- DATE -----
-- SQLite memorizza le date come stringhe nel formato ISO 'YYYY-MM-DD'.
-- Le funzioni date/time interpretano queste stringhe correttamente.

-- Q7) Data corrente
-- DATE('now')     → solo data (es. '2026-05-12')
-- DATETIME('now') → data + ora (es. '2026-05-12 14:30:00')
SELECT DATE('now') AS oggi,
       DATETIME('now') AS adesso;


-- Q8) Formattazione data
-- strftime(formato, data) → formatta la data secondo il pattern.
-- %d = giorno, %m = mese, %Y = anno (4 cifre), %y = anno (2 cifre).
SELECT strftime('%d/%m/%Y', data_prestito) AS data_formattata
FROM Prestiti;


-- Q9) Calcolo età (anni dalla data di nascita)
-- julianday(data) → giorno giuliano (numero in virgola mobile).
-- Differenza tra julianday → numero di giorni intercorrenti.
-- Diviso 365.25 → numero di anni (compresi gli anni bisestili).
-- CAST(... AS INTEGER) → converte in intero (tronca i decimali).
SELECT
    nome,
    data_nascita,
    CAST((julianday('now') - julianday(data_nascita)) / 365.25 AS INTEGER) AS eta
FROM Studente;


-- Q10) Prestiti aperti da più di 30 giorni
-- Combiniamo IS NULL con confronto di julianday.
SELECT
    p.id,
    p.utente,
    p.data_prestito,
    CAST(julianday('now') - julianday(p.data_prestito) AS INTEGER) AS giorni_aperto
FROM Prestiti p
WHERE p.data_restituzione IS NULL                              -- non restituito
  AND julianday('now') - julianday(p.data_prestito) > 30;       -- aperto da oltre 30 giorni


-- Q11) Aggiungere 30 giorni a una data
-- date(data, modificatore) → applica il modificatore alla data.
-- '+30 days' aggiunge 30 giorni. Esistono anche '-N days', '+N months', '+N years'.
SELECT
    id,
    data_prestito,
    date(data_prestito, '+30 days') AS data_scadenza
FROM Prestiti;


-- Q12) Estrarre anno e mese
-- %Y = anno, %m = mese (sempre 2 cifre con zero davanti se necessario).
-- GROUP BY su 'YYYY-MM' raggruppa per mese specifico (es. tutti i prestiti di gennaio 2024).
SELECT
    id,
    strftime('%Y', data_prestito) AS anno,
    strftime('%m', data_prestito) AS mese,
    COUNT(*)                       AS num_prestiti
FROM Prestiti
GROUP BY strftime('%Y-%m', data_prestito);
