-- ============================================================
-- ESERCIZIO 17 — VIEW e INDEX (concetti avanzati)
-- ============================================================
-- VIEW = "query salvata" usabile come tabella
-- INDEX = struttura che velocizza le ricerche su una colonna
--
-- VIEW: utile per nascondere complessità (es. JOIN ripetuti).
-- INDEX: utile su colonne usate spesso in WHERE/JOIN.
-- ============================================================

-- Q1) Creazione di una VIEW per le medie degli studenti
-- DROP VIEW IF EXISTS → cancella la view se esiste (utile per reset).
DROP VIEW IF EXISTS MediaStudenti;

-- CREATE VIEW nome AS SELECT ... → definisce una query "virtuale".
-- Ogni volta che leggi la view, la query viene ri-eseguita sui dati attuali.
CREATE VIEW MediaStudenti AS
SELECT
    s.Matricola,
    s.Nome,
    s.Cognome,
    ROUND(AVG(e.Voto), 2) AS media,
    COUNT(e.Id)           AS num_esami
FROM Studenti s
JOIN Esami    e ON s.Matricola = e.Matricola
GROUP BY s.Matricola;

-- Ora possiamo interrogare la VIEW come una tabella normale.
-- Vantaggio: non dobbiamo riscrivere il JOIN+GROUP BY ogni volta.
SELECT * FROM MediaStudenti
ORDER BY media DESC;


-- Q2) VIEW per i prestiti aperti
-- Anche le view possono usare funzioni SQL avanzate (qui julianday).
DROP VIEW IF EXISTS PrestitiAperti;
CREATE VIEW PrestitiAperti AS
SELECT
    p.id,
    l.titolo,
    p.utente,
    p.data_prestito,
    julianday('now') - julianday(p.data_prestito) AS giorni_aperto
FROM Prestiti p
JOIN Libri    l ON p.libro_id = l.id
WHERE p.data_restituzione IS NULL;

SELECT * FROM PrestitiAperti;


-- Q3) Creazione di un INDEX per velocizzare le query
-- CREATE INDEX nome_indice ON tabella(colonna) → crea un indice.
-- IF NOT EXISTS → se l'indice esiste già non lo ricrea (no errore).
--
-- Quando crearli? Su colonne usate frequentemente:
--   - in WHERE (filtri)
--   - in JOIN (condizioni di unione)
--   - in ORDER BY (ordinamenti)
-- Svantaggio: gli INSERT/UPDATE diventano un po' più lenti
-- perché l'indice deve essere mantenuto aggiornato.
CREATE INDEX IF NOT EXISTS idx_esami_matricola ON Esami(Matricola);
CREATE INDEX IF NOT EXISTS idx_esami_corso     ON Esami(Corso);
CREATE INDEX IF NOT EXISTS idx_libri_genere    ON Libri(genere);


-- Q4) Vedi l'effetto dell'indice (EXPLAIN QUERY PLAN)
-- EXPLAIN QUERY PLAN mostra COME SQLite eseguirà la query.
-- Senza indice: "SCAN TABLE Esami" (legge tutta la tabella).
-- Con indice: "SEARCH TABLE Esami USING INDEX ..." (usa l'indice).
EXPLAIN QUERY PLAN
SELECT * FROM Esami WHERE Corso = 'Informatica';


-- Q5) Cancella una VIEW e un INDEX (cleanup)
-- DROP VIEW e DROP INDEX rimuovono questi oggetti dal DB.
-- Commentati per non eliminarli durante il test.
-- DROP VIEW IF EXISTS MediaStudenti;
-- DROP INDEX IF EXISTS idx_esami_matricola;
