-- ============================================================
-- ESERCIZIO 14 — Setup E-Commerce
-- ============================================================
-- Cliente, Prodotto, Ordine, RigaOrdine (N:N tra Ordine e Prodotto)
-- Mostra un caso classico di modello "ordine con righe".
-- ============================================================

PRAGMA foreign_keys = ON;

-- Cancelliamo in ordine inverso per non violare FK.
DROP TABLE IF EXISTS RigaOrdine;
DROP TABLE IF EXISTS Ordine;
DROP TABLE IF EXISTS Prodotto;
DROP TABLE IF EXISTS Cliente;

-- Cliente: anagrafica. email UNIQUE per evitare duplicati.
CREATE TABLE Cliente (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    nome  TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,             -- non possono esistere due clienti con stessa email
    citta TEXT
);

-- Prodotto: catalogo. CHECK definisce un vincolo personalizzato.
CREATE TABLE Prodotto (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    nome      TEXT NOT NULL,
    prezzo    REAL NOT NULL CHECK (prezzo > 0),    -- prezzo deve essere positivo
    stock     INTEGER DEFAULT 0,                    -- DEFAULT = valore predefinito
    categoria TEXT
);

-- Ordine: "testata" dell'ordine.
-- DEFAULT 'in attesa' → se non specificato, lo stato iniziale è "in attesa".
CREATE TABLE Ordine (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id  INTEGER NOT NULL,
    data_ordine TEXT NOT NULL,
    stato       TEXT DEFAULT 'in attesa',
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id)
);

-- RigaOrdine: tabella di raccordo N:N tra Ordine e Prodotto.
-- PK COMPOSTA (ordine_id, prodotto_id) → ogni prodotto compare al massimo
-- una volta per ordine (quantita riporta il numero di pezzi).
CREATE TABLE RigaOrdine (
    ordine_id       INTEGER NOT NULL,
    prodotto_id     INTEGER NOT NULL,
    quantita        INTEGER NOT NULL CHECK (quantita > 0),  -- almeno 1 pezzo
    prezzo_unitario REAL    NOT NULL,                       -- prezzo storico
    PRIMARY KEY (ordine_id, prodotto_id),                   -- chiave composta
    FOREIGN KEY (ordine_id)   REFERENCES Ordine(id),
    FOREIGN KEY (prodotto_id) REFERENCES Prodotto(id)
);

-- ============================================================
-- DATI DI ESEMPIO
-- ============================================================

INSERT INTO Cliente (nome, email, citta) VALUES
    ('Anna Rossi',     'anna@example.com',  'Milano'),
    ('Luca Bianchi',   'luca@example.com',  'Roma'),
    ('Sara Verdi',     'sara@example.com',  'Torino'),
    ('Marco Galli',    'marco@example.com', 'Napoli');     -- non farà ordini → orfano

INSERT INTO Prodotto (nome, prezzo, stock, categoria) VALUES
    ('Mouse Wireless',     19.90, 100, 'Informatica'),
    ('Tastiera Meccanica', 89.00,  50, 'Informatica'),
    ('Monitor 24 pollici',179.00,  30, 'Informatica'),
    ('Libro Python',       29.50,  80, 'Libri'),
    ('Libro SQL',          24.90,  60, 'Libri'),
    ('Cuffie Bluetooth',   59.00,  40, 'Audio');

-- 4 ordini di 3 clienti diversi (cliente 4 non ordina nulla).
INSERT INTO Ordine (cliente_id, data_ordine, stato) VALUES
    (1, '2024-10-15', 'consegnato'),
    (2, '2024-10-20', 'spedito'),
    (1, '2024-11-01', 'in attesa'),
    (3, '2024-11-05', 'consegnato');

-- Righe d'ordine: dettaglio dei prodotti acquistati in ciascun ordine.
INSERT INTO RigaOrdine (ordine_id, prodotto_id, quantita, prezzo_unitario) VALUES
    (1, 1, 2, 19.90),   -- ordine 1: 2 mouse
    (1, 4, 1, 29.50),   -- ordine 1: 1 libro Python
    (2, 3, 1, 179.00),  -- ordine 2: 1 monitor
    (2, 2, 1, 89.00),   -- ordine 2: 1 tastiera
    (3, 6, 1, 59.00),   -- ordine 3: 1 cuffie
    (4, 4, 2, 29.50),   -- ordine 4: 2 libri Python
    (4, 5, 1, 24.90);   -- ordine 4: 1 libro SQL

SELECT 'Setup e-commerce completato' AS info;
