# Guida Completa a SQL con SQLite3

> Basata sul materiale di [angelogalantiscuola/IT](https://github.com/angelogalantiscuola/IT) e [angelogalantiscuola/2526_5M](https://github.com/angelogalantiscuola/2526_5M)

---

## Indice

1. [Cos'è SQL e SQLite?](#1-cosè-sql-e-sqlite)
2. [DDL — Creazione Struttura](#2-ddl--creazione-struttura)
3. [DML — Manipolazione Dati](#3-dml--manipolazione-dati)
4. [SELECT — Interrogare il Database](#4-select--interrogare-il-database)
5. [WHERE — Filtrare i Dati](#5-where--filtrare-i-dati)
6. [ORDER BY e LIMIT](#6-order-by-e-limit)
7. [Funzioni di Aggregazione](#7-funzioni-di-aggregazione)
8. [GROUP BY e HAVING](#8-group-by-e-having)
9. [JOIN — Unire le Tabelle](#9-join--unire-le-tabelle)
10. [Sottoquery](#10-sottoquery)
11. [Python + SQLite3](#11-python--sqlite3)
12. [SQL Injection e Sicurezza](#12-sql-injection-e-sicurezza)

---

## 1. Cos'è SQL e SQLite?

**SQL (Structured Query Language)** è il linguaggio standard per comunicare con i database relazionali. È un linguaggio **dichiarativo**: dici **cosa** vuoi, non **come** ottenerlo.

**SQLite** è un database relazionale:
- **File-based**: tutti i dati sono in un solo file `.db` o `.sqlite`
- **Serverless**: non serve installare un server
- **Integrato in Python**: il modulo `sqlite3` è incluso nella libreria standard
- **Ideale per** sviluppo, test, app desktop, app mobile

### SQL si divide in due parti

| Categoria | Sigla | Comandi | Scopo |
|---|---|---|---|
| Data Definition Language | DDL | `CREATE`, `ALTER`, `DROP` | Struttura del database |
| Data Manipulation Language | DML | `INSERT`, `UPDATE`, `DELETE`, `SELECT` | Dati nel database |

---

## 2. DDL — Creazione Struttura

### 2.1 CREATE TABLE

```sql
CREATE TABLE Studenti (
    matricola INTEGER PRIMARY KEY,
    nome      TEXT    NOT NULL,
    cognome   TEXT    NOT NULL,
    email     TEXT    UNIQUE
);
```

### 2.2 Tipi di dato in SQLite

| Tipo | Uso | Esempio |
|---|---|---|
| `INTEGER` | Numeri interi | id, voto, anno |
| `TEXT` | Testo | nome, cognome, email |
| `REAL` | Numeri decimali | prezzo, superficie |
| `DATE` | Date (memorizzate come TEXT) | data_nascita |
| `BLOB` | Dati binari | immagini, file |

### 2.3 Vincoli (Constraints)

| Vincolo | Significato |
|---|---|
| `PRIMARY KEY` | Identificatore univoco; in SQLite `INTEGER PK` è auto-increment |
| `NOT NULL` | Il campo non può essere vuoto |
| `UNIQUE` | Il valore deve essere unico in tutta la colonna |
| `DEFAULT valore` | Valore predefinito se non specificato |
| `FOREIGN KEY` | Chiave esterna — collega a un'altra tabella |

### 2.4 Foreign Key con riferimento

```sql
CREATE TABLE Esami (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    matricola INTEGER NOT NULL,
    corso     TEXT    NOT NULL,
    voto      INTEGER NOT NULL,
    FOREIGN KEY (matricola) REFERENCES Studenti(matricola)
);
```

> **Nota SQLite**: Per attivare i vincoli di FK in SQLite devi eseguire:
> ```sql
> PRAGMA foreign_keys = ON;
> ```

### 2.5 Tabella con chiave primaria composta (raccordo N-a-N)

```sql
CREATE TABLE Iscrizione (
    studente_id INTEGER NOT NULL,
    corso_id    INTEGER NOT NULL,
    data_iscr   DATE,
    PRIMARY KEY (studente_id, corso_id),
    FOREIGN KEY (studente_id) REFERENCES Studenti(id),
    FOREIGN KEY (corso_id)    REFERENCES Corsi(id)
);
```

### 2.6 DROP TABLE

```sql
DROP TABLE IF EXISTS NomeTabella;
```

### 2.7 Database di esempio — Libreria

Dal repository `2526_5M/db/libreria.sql`:

```sql
CREATE TABLE Autori (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    nome    TEXT NOT NULL,
    cognome TEXT NOT NULL
);

CREATE TABLE Libri (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    titolo    TEXT NOT NULL,
    autore_id INTEGER,
    anno      INTEGER,
    genere    TEXT,
    FOREIGN KEY (autore_id) REFERENCES Autori(id)
);

CREATE TABLE Prestiti (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    libro_id          INTEGER,
    utente            TEXT NOT NULL,
    data_prestito     DATE NOT NULL,
    data_restituzione DATE,
    FOREIGN KEY (libro_id) REFERENCES Libri(id)
);
```

### 2.8 Database di esempio — Scuola

Dal repository `2526_5M/db/scuola.sql`:

```sql
CREATE TABLE Studenti (
    Matricola INTEGER PRIMARY KEY,
    Nome      TEXT NOT NULL,
    Cognome   TEXT NOT NULL
);

CREATE TABLE Esami (
    Id        INTEGER PRIMARY KEY AUTOINCREMENT,
    Matricola INTEGER,
    Corso     TEXT NOT NULL,
    Voto      INTEGER NOT NULL,
    FOREIGN KEY (Matricola) REFERENCES Studenti(Matricola)
);
```

---

## 3. DML — Manipolazione Dati

### 3.1 INSERT INTO

```sql
-- Forma completa (consigliata)
INSERT INTO Studenti (matricola, nome, cognome)
VALUES (101, 'Mario', 'Rossi');

-- Forma abbreviata (sconsigliata: dipende dall'ordine delle colonne)
INSERT INTO Studenti VALUES (101, 'Mario', 'Rossi');
```

#### INSERT multiplo

```sql
INSERT INTO Studenti (matricola, nome, cognome) VALUES
    (101, 'Mario',  'Rossi'),
    (102, 'Lucia',  'Bianchi'),
    (103, 'Paolo',  'Verdi');
```

#### INSERT OR IGNORE

Evita errori se la riga esiste già (utile nei test):

```sql
INSERT OR IGNORE INTO Studenti (matricola, nome, cognome)
VALUES (101, 'Mario', 'Rossi');
```

### 3.2 UPDATE

```sql
-- Aggiorna uno specifico studente
UPDATE Studenti
SET nome = 'Marco'
WHERE matricola = 101;

-- Aggiorna tutti (ATTENZIONE: senza WHERE modifica tutto!)
UPDATE Esami
SET voto = voto + 1
WHERE corso = 'Matematica';
```

### 3.3 DELETE

```sql
-- Elimina una riga specifica
DELETE FROM Studenti
WHERE matricola = 101;

-- Elimina tutti i record (la struttura rimane)
DELETE FROM Studenti;
```

---

## 4. SELECT — Interrogare il Database

### 4.1 Selezione base

```sql
-- Tutte le colonne
SELECT * FROM Studenti;

-- Colonne specifiche
SELECT nome, cognome FROM Studenti;

-- Con alias
SELECT nome AS "Nome Studente", cognome AS Cognome FROM Studenti;
```

### 4.2 SELECT DISTINCT

Rimuove i duplicati:

```sql
SELECT DISTINCT genere FROM Libri;
SELECT DISTINCT corso   FROM Esami;
```

---

## 5. WHERE — Filtrare i Dati

### 5.1 Operatori di confronto

```sql
SELECT * FROM Esami WHERE voto = 30;
SELECT * FROM Esami WHERE voto >= 27;
SELECT * FROM Esami WHERE voto <> 18;    -- diverso da
SELECT * FROM Esami WHERE voto != 18;    -- uguale a <>
```

### 5.2 Operatori logici

```sql
-- AND: entrambe le condizioni vere
SELECT * FROM Esami WHERE voto >= 27 AND corso = 'Matematica';

-- OR: almeno una condizione vera
SELECT * FROM Esami WHERE corso = 'Fisica' OR corso = 'Chimica';

-- NOT: inverte la condizione
SELECT * FROM Studenti WHERE NOT cognome = 'Rossi';
```

### 5.3 BETWEEN

```sql
SELECT * FROM Esami WHERE voto BETWEEN 24 AND 30;
-- Equivale a: voto >= 24 AND voto <= 30
```

### 5.4 IN

```sql
SELECT * FROM Libri WHERE genere IN ('Giallo', 'Fantasy', 'Fantascienza');
-- Più compatto di: genere = 'Giallo' OR genere = 'Fantasy' OR ...
```

### 5.5 LIKE — Ricerca testuale

```sql
-- Inizia con 'M'
SELECT * FROM Studenti WHERE nome LIKE 'M%';

-- Finisce con 'i'
SELECT * FROM Studenti WHERE cognome LIKE '%i';

-- Contiene 'ar'
SELECT * FROM Studenti WHERE nome LIKE '%ar%';

-- Secondo carattere è 'a' (underscore = un singolo carattere)
SELECT * FROM Studenti WHERE nome LIKE '_a%';
```

### 5.6 IS NULL / IS NOT NULL

```sql
-- Prestiti non ancora restituiti
SELECT * FROM Prestiti WHERE data_restituzione IS NULL;

-- Prestiti restituiti
SELECT * FROM Prestiti WHERE data_restituzione IS NOT NULL;
```

---

## 6. ORDER BY e LIMIT

### ORDER BY

```sql
-- Crescente (default)
SELECT * FROM Esami ORDER BY voto ASC;

-- Decrescente
SELECT * FROM Esami ORDER BY voto DESC;

-- Ordinamento multiplo
SELECT * FROM Libri ORDER BY genere ASC, anno DESC;
```

### LIMIT e OFFSET

```sql
-- Solo i primi 5 risultati
SELECT * FROM Studenti LIMIT 5;

-- Salta i primi 10, mostra i successivi 5 (utile per la paginazione)
SELECT * FROM Studenti LIMIT 5 OFFSET 10;
```

### Top N

```sql
-- I 3 voti più alti
SELECT * FROM Esami ORDER BY voto DESC LIMIT 3;
```

---

## 7. Funzioni di Aggregazione

Le funzioni di aggregazione calcolano un valore su un insieme di righe.

| Funzione | Significato | Esempio |
|---|---|---|
| `COUNT(*)` | Conta le righe | `COUNT(*)` → numero totale |
| `COUNT(colonna)` | Conta valori non NULL | `COUNT(data_restituzione)` |
| `SUM(colonna)` | Somma | `SUM(voto)` |
| `AVG(colonna)` | Media | `AVG(voto)` |
| `MAX(colonna)` | Massimo | `MAX(voto)` |
| `MIN(colonna)` | Minimo | `MIN(voto)` |

### Esempi

```sql
-- Quanti studenti ci sono?
SELECT COUNT(*) AS totale_studenti FROM Studenti;

-- Media dei voti
SELECT AVG(voto) AS media FROM Esami;

-- Voto più alto e più basso
SELECT MAX(voto) AS massimo, MIN(voto) AS minimo FROM Esami;

-- Somma di tutti i voti
SELECT SUM(voto) AS somma_voti FROM Esami;

-- Quanti prestiti sono stati restituiti?
SELECT COUNT(data_restituzione) AS restituiti FROM Prestiti;
```

---

## 8. GROUP BY e HAVING

### GROUP BY

`GROUP BY` raggruppa le righe che hanno lo stesso valore in una colonna e applica una funzione aggregata a ciascun gruppo.

```sql
-- Numero di esami per ogni corso
SELECT corso, COUNT(*) AS num_esami
FROM Esami
GROUP BY corso;

-- Media voti per studente
SELECT matricola, AVG(voto) AS media
FROM Esami
GROUP BY matricola;

-- Numero di libri per genere
SELECT genere, COUNT(*) AS num_libri
FROM Libri
GROUP BY genere;
```

### HAVING

`HAVING` filtra i **gruppi** (come WHERE filtra le righe).

```sql
-- Solo i corsi con più di 5 esami
SELECT corso, COUNT(*) AS num_esami
FROM Esami
GROUP BY corso
HAVING COUNT(*) > 5;

-- Studenti con media sopra il 27
SELECT matricola, AVG(voto) AS media
FROM Esami
GROUP BY matricola
HAVING AVG(voto) > 27;
```

### WHERE vs HAVING

| | WHERE | HAVING |
|---|---|---|
| **Filtra** | Righe singole | Gruppi |
| **Si usa con** | Colonne normali | Funzioni aggregate |
| **Momento** | Prima del GROUP BY | Dopo il GROUP BY |

```sql
-- WHERE filtra prima del raggruppamento
-- HAVING filtra dopo
SELECT corso, AVG(voto) AS media
FROM Esami
WHERE voto >= 18               -- filtra gli esami con voto >= 18
GROUP BY corso
HAVING AVG(voto) >= 27;        -- filtra i gruppi con media >= 27
```

---

## 9. JOIN — Unire le Tabelle

Il `JOIN` è l'operazione più potente del modello relazionale: unisce righe di tabelle diverse basandosi su colonne comuni.

### 9.1 INNER JOIN (o semplicemente JOIN)

Restituisce solo le righe che hanno corrispondenza in **entrambe** le tabelle.

```sql
-- Nomi degli studenti con i loro voti
SELECT s.nome, s.cognome, e.corso, e.voto
FROM Studenti s
JOIN Esami e ON s.matricola = e.matricola;
```

**Sintassi con alias:** `Studenti s` → `s` è l'alias per `Studenti`

```sql
-- Titolo del libro e nome dell'autore
SELECT l.titolo, a.nome, a.cognome
FROM Libri l
JOIN Autori a ON l.autore_id = a.id;
```

### 9.2 JOIN su più tabelle

```sql
-- Studenti, materie e voti (3 tabelle)
SELECT s.nome, s.cognome, e.corso, e.voto
FROM Studenti s
JOIN Esami e ON s.matricola = e.matricola
ORDER BY s.cognome, e.voto DESC;
```

### 9.3 LEFT JOIN

Restituisce **tutte** le righe della tabella sinistra, anche se non hanno corrispondenza a destra (in quel caso i campi destri sono `NULL`).

```sql
-- Tutti gli studenti, anche quelli senza esami
SELECT s.nome, s.cognome, e.corso, e.voto
FROM Studenti s
LEFT JOIN Esami e ON s.matricola = e.matricola;
```

```sql
-- Tutti i libri, anche quelli mai in prestito
SELECT l.titolo, p.utente, p.data_prestito
FROM Libri l
LEFT JOIN Prestiti p ON l.id = p.libro_id;
```

### 9.4 Differenza tra JOIN e LEFT JOIN

| | INNER JOIN | LEFT JOIN |
|---|---|---|
| **Righe restituite** | Solo con corrispondenza | Tutte le righe sinistre |
| **Valori mancanti** | La riga non appare | Appare con NULL a destra |
| **Uso tipico** | "Mostrami solo X che ha Y" | "Mostrami tutti gli X, anche senza Y" |

### 9.5 Esempio avanzato — Music Store

Dal database `music-store.sql` (repository 2526_5M):

```sql
-- Artista, album e traccia
SELECT ar.name AS artista, al.title AS album, t.name AS traccia
FROM artists ar
JOIN albums al ON ar.id = al.artist_id
JOIN tracks t  ON al.id = t.album_id
ORDER BY ar.name, al.title;

-- Quante tracce ha ogni artista?
SELECT ar.name AS artista, COUNT(t.id) AS num_tracce
FROM artists ar
JOIN albums al ON ar.id = al.artist_id
JOIN tracks t  ON al.id = t.album_id
GROUP BY ar.id, ar.name
ORDER BY num_tracce DESC;
```

---

## 10. Sottoquery

Una **sottoquery** è una `SELECT` annidata all'interno di un'altra query.

```sql
-- Studenti con voto superiore alla media
SELECT s.nome, s.cognome, e.voto
FROM Studenti s
JOIN Esami e ON s.matricola = e.matricola
WHERE e.voto > (SELECT AVG(voto) FROM Esami);

-- Libri dello stesso genere del libro 'Il Nome della Rosa'
SELECT titolo FROM Libri
WHERE genere = (
    SELECT genere FROM Libri WHERE titolo = 'Il Nome della Rosa'
);
```

---

## 11. Python + SQLite3

### 11.1 Il flusso completo

```python
import sqlite3

# 1. Connessione (crea il file se non esiste)
conn = sqlite3.connect("scuola.db")

# 2. Cursor — esegue le query
cursor = conn.cursor()

# 3. Esegui la query
cursor.execute("SELECT * FROM Studenti")

# 4. Recupera i risultati
righe = cursor.fetchall()   # lista di tuple
# oppure: riga = cursor.fetchone()  ← una sola riga

# 5. Chiudi la connessione
conn.close()
```

### 11.2 Creare tabelle

```python
import sqlite3

conn   = sqlite3.connect("scuola.db")
cursor = conn.cursor()

cursor.execute("""
    CREATE TABLE IF NOT EXISTS Studenti (
        matricola INTEGER PRIMARY KEY,
        nome      TEXT NOT NULL,
        cognome   TEXT NOT NULL
    )
""")

cursor.execute("""
    CREATE TABLE IF NOT EXISTS Esami (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        matricola INTEGER NOT NULL,
        corso     TEXT    NOT NULL,
        voto      INTEGER NOT NULL,
        FOREIGN KEY (matricola) REFERENCES Studenti(matricola)
    )
""")

conn.commit()
conn.close()
```

### 11.3 Inserire dati — Query Parametrizzate

**IMPORTANTE:** Non costruire mai la query con l'input utente direttamente!

```python
# ❌ MAI FARE QUESTO (SQL Injection!)
nome_utente = input("Nome: ")
cursor.execute(f"SELECT * FROM Studenti WHERE nome = '{nome_utente}'")

# ✅ SEMPRE usare query parametrizzate con ?
cursor.execute("SELECT * FROM Studenti WHERE nome = ?", (nome_utente,))
```

```python
conn   = sqlite3.connect("scuola.db")
cursor = conn.cursor()

# INSERT singolo
cursor.execute(
    "INSERT OR IGNORE INTO Studenti (matricola, nome, cognome) VALUES (?, ?, ?)",
    (101, "Mario", "Rossi")
)

# INSERT multiplo con executemany
studenti = [
    (101, "Mario",  "Rossi"),
    (102, "Lucia",  "Bianchi"),
    (103, "Paolo",  "Verdi"),
]
cursor.executemany(
    "INSERT OR IGNORE INTO Studenti (matricola, nome, cognome) VALUES (?, ?, ?)",
    studenti
)

conn.commit()   # ← obbligatorio per INSERT/UPDATE/DELETE
conn.close()
```

### 11.4 Leggere i risultati

```python
conn   = sqlite3.connect("scuola.db")
cursor = conn.cursor()

# Tutti i risultati
cursor.execute("SELECT * FROM Studenti")
studenti = cursor.fetchall()
for riga in studenti:
    print(riga)           # riga è una tupla: (101, 'Mario', 'Rossi')
    print(riga[0], riga[1], riga[2])

# Un solo risultato
cursor.execute("SELECT * FROM Studenti WHERE matricola = ?", (101,))
studente = cursor.fetchone()
if studente:
    print(f"Trovato: {studente[1]} {studente[2]}")

conn.close()
```

### 11.5 Risultati come dizionari (row_factory)

```python
conn = sqlite3.connect("scuola.db")
conn.row_factory = sqlite3.Row   # ← abilita accesso per nome colonna

cursor = conn.cursor()
cursor.execute("SELECT * FROM Studenti")

for riga in cursor.fetchall():
    print(riga["nome"], riga["cognome"])   # accesso per nome!

conn.close()
```

### 11.6 Struttura consigliata con funzioni

```python
import sqlite3

DB_PATH = "libreria.db"

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def create_tables():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Autori (
            id      INTEGER PRIMARY KEY AUTOINCREMENT,
            nome    TEXT NOT NULL,
            cognome TEXT NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Libri (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            titolo    TEXT NOT NULL,
            autore_id INTEGER,
            anno      INTEGER,
            genere    TEXT,
            FOREIGN KEY (autore_id) REFERENCES Autori(id)
        )
    """)
    conn.commit()
    conn.close()

def insert_autore(nome, cognome):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Autori (nome, cognome) VALUES (?, ?)",
        (nome, cognome)
    )
    conn.commit()
    autore_id = cursor.lastrowid   # id del record appena inserito
    conn.close()
    return autore_id

def get_libri_per_autore(autore_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT l.titolo, l.anno, l.genere
        FROM Libri l
        JOIN Autori a ON l.autore_id = a.id
        WHERE a.id = ?
    """, (autore_id,))
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def get_libri_per_genere():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT genere, COUNT(*) AS num_libri
        FROM Libri
        GROUP BY genere
        ORDER BY num_libri DESC
    """)
    risultati = cursor.fetchall()
    conn.close()
    return risultati

if __name__ == "__main__":
    create_tables()
    autore_id = insert_autore("Umberto", "Eco")
    print(f"Autore inserito con id: {autore_id}")
```

### 11.7 Gestione errori con try/except

```python
import sqlite3

def esegui_query(query, parametri=()):
    try:
        conn   = sqlite3.connect("scuola.db")
        cursor = conn.cursor()
        cursor.execute(query, parametri)
        conn.commit()
        return cursor.fetchall()
    except sqlite3.IntegrityError as e:
        print(f"Errore di integrità: {e}")
    except sqlite3.OperationalError as e:
        print(f"Errore operativo: {e}")
    finally:
        conn.close()
```

---

## 12. SQL Injection e Sicurezza

> Dal file `03_Sviluppo_Web_e_Database/01_Database/16_SQL_Injection.md`

### Cos'è SQL Injection?

Un attacco in cui input malevolo viene inserito in una query SQL, modificandone la logica.

### Esempio di attacco

```python
# L'utente inserisce: ' OR '1'='1
username = "' OR '1'='1"

# ❌ Query vulnerabile
query = f"SELECT * FROM utenti WHERE username = '{username}'"
# Diventa: SELECT * FROM utenti WHERE username = '' OR '1'='1'
# Restituisce TUTTI gli utenti!
```

### Difesa: query parametrizzate

```python
# ✅ Query sicura — il parametro non viene mai interpolato nella stringa
cursor.execute(
    "SELECT * FROM utenti WHERE username = ?",
    (username,)
)
# SQLite tratta il valore come dato, mai come codice SQL
```

**Regola d'oro:** Non costruire mai query SQL concatenando stringhe con input utente. Usa **sempre** i placeholder `?` (SQLite) o `%s` (MySQL).

---

*Fine Guida SQL/SQLite3 — per gli esercizi vedi `05_ESERCIZI_SQL_SQLITE3.md`*
