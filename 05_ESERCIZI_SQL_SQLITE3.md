# Esercizi — SQL con SQLite3

> Basati sul materiale di [angelogalantiscuola/2526_5M](https://github.com/angelogalantiscuola/2526_5M)  
> Per la teoria consulta `02_GUIDA_SQL_SQLITE3.md`

---

## Database di riferimento

Tutti gli esercizi usano i database definiti nel repository. Ecco la struttura:

### Database Scuola (`scuola.db`)

```sql
CREATE TABLE Studenti (
    Matricola INTEGER PRIMARY KEY,
    Nome      TEXT NOT NULL,
    Cognome   TEXT NOT NULL
);

CREATE TABLE Esami (
    Id        INTEGER PRIMARY KEY AUTOINCREMENT,
    Matricola INTEGER NOT NULL,
    Corso     TEXT    NOT NULL,
    Voto      INTEGER NOT NULL,
    FOREIGN KEY (Matricola) REFERENCES Studenti(Matricola)
);
```

**Dati di esempio:**
```sql
INSERT INTO Studenti VALUES (101, 'Mario',  'Rossi');
INSERT INTO Studenti VALUES (102, 'Lucia',  'Bianchi');
INSERT INTO Studenti VALUES (103, 'Paolo',  'Verdi');

INSERT INTO Esami (Matricola, Corso, Voto) VALUES
    (101, 'Matematica',  28),
    (101, 'Informatica', 30),
    (101, 'Fisica',      27),
    (102, 'Matematica',  25),
    (102, 'Informatica', 30),
    (102, 'Fisica',      22),
    (103, 'Matematica',  18),
    (103, 'Informatica', 24);
```

### Database Libreria (`libreria.db`)

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

---

## SEZIONE A — SELECT e WHERE

### Esercizio A1 — Select Base ⭐

**Obiettivo:** Recupera tutti gli studenti

```sql
-- Scrivi qui la tua query
```

**Soluzione:**
```sql
SELECT * FROM Studenti;
-- oppure più esplicito:
SELECT Matricola, Nome, Cognome FROM Studenti;
```

**Output atteso:**
```
101 | Mario | Rossi
102 | Lucia | Bianchi
103 | Paolo | Verdi
```

---

### Esercizio A2 — WHERE con confronto ⭐

**Obiettivo:** Trova tutti gli esami con voto superiore o uguale a 27

```sql
-- Scrivi qui la tua query
```

**Soluzione:**
```sql
SELECT * FROM Esami
WHERE Voto >= 27;
```

**Output atteso:**
```
1 | 101 | Matematica  | 28
2 | 101 | Informatica | 30
5 | 102 | Informatica | 30
```

---

### Esercizio A3 — WHERE con AND ⭐

**Obiettivo:** Trova gli esami di Informatica con voto almeno 28

**Soluzione:**
```sql
SELECT * FROM Esami
WHERE Corso = 'Informatica' AND Voto >= 28;
```

---

### Esercizio A4 — WHERE con IN ⭐

**Obiettivo:** Trova gli esami di Matematica o Fisica

**Soluzione:**
```sql
SELECT * FROM Esami
WHERE Corso IN ('Matematica', 'Fisica');
```

---

### Esercizio A5 — LIKE ⭐

**Obiettivo:** Trova tutti gli studenti il cui cognome inizia con 'B'

**Soluzione:**
```sql
SELECT * FROM Studenti
WHERE Cognome LIKE 'B%';
```

---

### Esercizio A6 — IS NULL ⭐

**Obiettivo:** Trova tutti i prestiti non ancora restituiti (sulla tabella libreria)

**Soluzione:**
```sql
SELECT * FROM Prestiti
WHERE data_restituzione IS NULL;
```

---

### Esercizio A7 — BETWEEN ⭐

**Obiettivo:** Trova gli esami con voto tra 24 e 28 (estremi inclusi)

**Soluzione:**
```sql
SELECT Corso, Voto FROM Esami
WHERE Voto BETWEEN 24 AND 28
ORDER BY Voto DESC;
```

---

## SEZIONE B — ORDER BY, LIMIT e DISTINCT

### Esercizio B1 — ORDER BY ⭐

**Obiettivo:** Mostra tutti gli esami ordinati per voto dal più alto al più basso

**Soluzione:**
```sql
SELECT * FROM Esami
ORDER BY Voto DESC;
```

---

### Esercizio B2 — ORDER BY multiplo ⭐

**Obiettivo:** Mostra gli esami ordinati prima per corso (A-Z) poi per voto (alto-basso)

**Soluzione:**
```sql
SELECT * FROM Esami
ORDER BY Corso ASC, Voto DESC;
```

---

### Esercizio B3 — LIMIT ⭐

**Obiettivo:** Mostra solo i 3 esami con il voto più alto

**Soluzione:**
```sql
SELECT * FROM Esami
ORDER BY Voto DESC
LIMIT 3;
```

---

### Esercizio B4 — DISTINCT ⭐

**Obiettivo:** Mostra tutti i corsi disponibili (senza duplicati)

**Soluzione:**
```sql
SELECT DISTINCT Corso FROM Esami
ORDER BY Corso;
```

---

## SEZIONE C — Funzioni di Aggregazione

### Esercizio C1 — COUNT ⭐

**Obiettivo:** Quanti studenti ci sono nel database?

**Soluzione:**
```sql
SELECT COUNT(*) AS totale_studenti FROM Studenti;
-- Output: 3
```

---

### Esercizio C2 — AVG ⭐

**Obiettivo:** Qual è la media di tutti i voti?

**Soluzione:**
```sql
SELECT AVG(Voto) AS media_voti FROM Esami;
-- Output: 25.5 (circa)
```

---

### Esercizio C3 — MAX e MIN ⭐

**Obiettivo:** Qual è il voto più alto e più basso?

**Soluzione:**
```sql
SELECT MAX(Voto) AS massimo, MIN(Voto) AS minimo FROM Esami;
-- Output: 30 | 18
```

---

### Esercizio C4 — Aggregazione con WHERE ⭐⭐

**Obiettivo:** Media dei voti solo per il corso di Informatica

**Soluzione:**
```sql
SELECT AVG(Voto) AS media_informatica
FROM Esami
WHERE Corso = 'Informatica';
```

---

## SEZIONE D — GROUP BY e HAVING

### Esercizio D1 — GROUP BY semplice ⭐⭐

**Obiettivo:** Conta quanti esami ci sono per ogni corso

**Soluzione:**
```sql
SELECT Corso, COUNT(*) AS num_esami
FROM Esami
GROUP BY Corso
ORDER BY num_esami DESC;
```

**Output atteso:**
```
Matematica  | 3
Informatica | 3
Fisica      | 2
```

---

### Esercizio D2 — GROUP BY con AVG ⭐⭐

**Obiettivo:** Calcola la media dei voti per ogni studente (mostra matricola e media)

**Soluzione:**
```sql
SELECT Matricola, AVG(Voto) AS media, COUNT(*) AS num_esami
FROM Esami
GROUP BY Matricola
ORDER BY media DESC;
```

---

### Esercizio D3 — GROUP BY con HAVING ⭐⭐

**Obiettivo:** Trova gli studenti con media superiore a 26

**Soluzione:**
```sql
SELECT Matricola, AVG(Voto) AS media
FROM Esami
GROUP BY Matricola
HAVING AVG(Voto) > 26
ORDER BY media DESC;
```

**Spiegazione:**
- `GROUP BY Matricola` → crea un gruppo per ogni studente
- `HAVING AVG(Voto) > 26` → filtra i gruppi dove la media è sopra 26
- Non puoi usare `WHERE AVG(...)` perché WHERE non supporta funzioni aggregate!

---

### Esercizio D4 — WHERE + GROUP BY + HAVING ⭐⭐⭐

**Obiettivo:** Media dei voti >= 18 (escludendo i 18) per studente, solo per studenti con almeno 2 esami superati (con voto >= 19)

**Soluzione:**
```sql
SELECT Matricola, AVG(Voto) AS media, COUNT(*) AS esami_superati
FROM Esami
WHERE Voto > 18
GROUP BY Matricola
HAVING COUNT(*) >= 2
ORDER BY media DESC;
```

**Ordine di esecuzione SQL:**
1. `FROM` → dalla tabella Esami
2. `WHERE` → filtra voto > 18
3. `GROUP BY` → raggruppa per matricola
4. `HAVING` → filtra gruppi con almeno 2 esami
5. `SELECT` → calcola le colonne
6. `ORDER BY` → ordina il risultato

---

## SEZIONE E — JOIN

### Esercizio E1 — INNER JOIN ⭐⭐

**Obiettivo:** Mostra nome, cognome di ogni studente insieme ai loro voti (tutti gli esami)

**Soluzione:**
```sql
SELECT s.Nome, s.Cognome, e.Corso, e.Voto
FROM Studenti s
JOIN Esami e ON s.Matricola = e.Matricola
ORDER BY s.Cognome, e.Corso;
```

**Spiegazione:**
- `s` è l'alias per `Studenti` → più corto da scrivere
- `ON s.Matricola = e.Matricola` → la condizione di collegamento
- Solo gli studenti che hanno almeno un esame appaiono nel risultato

---

### Esercizio E2 — JOIN con WHERE ⭐⭐

**Obiettivo:** Trova nome e cognome degli studenti che hanno preso 30 in Informatica

**Soluzione:**
```sql
SELECT s.Nome, s.Cognome
FROM Studenti s
JOIN Esami e ON s.Matricola = e.Matricola
WHERE e.Corso = 'Informatica' AND e.Voto = 30;
```

---

### Esercizio E3 — LEFT JOIN ⭐⭐

**Obiettivo:** Mostra tutti gli studenti, anche quelli senza esami (nella libreria: tutti i libri, anche quelli mai in prestito)

**Sul database Libreria:**
```sql
SELECT l.titolo, p.utente, p.data_prestito
FROM Libri l
LEFT JOIN Prestiti p ON l.id = p.libro_id
ORDER BY l.titolo;
```

**Spiegazione:**
- Con `LEFT JOIN`: appaiono TUTTI i libri, anche quelli senza prestiti
- Le colonne di `Prestiti` saranno `NULL` per i libri mai prestati
- Con `INNER JOIN`: sparirebbero i libri mai prestati

---

### Esercizio E4 — JOIN su 3 tabelle ⭐⭐⭐

**Obiettivo (database Libreria):** Mostra titolo libro, nome autore, nome utente in prestito

```sql
SELECT l.titolo, a.nome || ' ' || a.cognome AS autore, p.utente
FROM Libri l
JOIN Autori a   ON l.autore_id = a.id
JOIN Prestiti p ON l.id = p.libro_id
WHERE p.data_restituzione IS NULL
ORDER BY l.titolo;
```

**Nota:** `||` in SQLite concatena stringhe (come `+` in Python)

---

### Esercizio E5 — JOIN con GROUP BY ⭐⭐⭐

**Obiettivo:** Per ogni studente, mostra nome, cognome e media voti

**Soluzione:**
```sql
SELECT s.Nome, s.Cognome, ROUND(AVG(e.Voto), 2) AS media
FROM Studenti s
JOIN Esami e ON s.Matricola = e.Matricola
GROUP BY s.Matricola, s.Nome, s.Cognome
ORDER BY media DESC;
```

**Nota:** `ROUND(AVG(e.Voto), 2)` arrotonda a 2 decimali

---

### Esercizio E6 — LEFT JOIN per trovare "orfani" ⭐⭐⭐

**Obiettivo:** Trova gli studenti che NON hanno mai sostenuto esami

**Soluzione:**
```sql
SELECT s.Nome, s.Cognome
FROM Studenti s
LEFT JOIN Esami e ON s.Matricola = e.Matricola
WHERE e.Id IS NULL;
```

**Spiegazione:**
- `LEFT JOIN` → prende tutti gli studenti
- `WHERE e.Id IS NULL` → filtra quelli per cui non c'è nessun esame (NULL = nessuna corrispondenza)

---

## SEZIONE F — Python + SQLite3

### Esercizio F1 — Setup database Scuola ⭐

**Obiettivo:** Crea il file `scuola.db` con le due tabelle e inserisci i dati di esempio

```python
import sqlite3

def setup_scuola():
    conn   = sqlite3.connect("scuola.db")
    cursor = conn.cursor()
    
    # Crea le tabelle
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Studenti (
            Matricola INTEGER PRIMARY KEY,
            Nome      TEXT NOT NULL,
            Cognome   TEXT NOT NULL
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Esami (
            Id        INTEGER PRIMARY KEY AUTOINCREMENT,
            Matricola INTEGER NOT NULL,
            Corso     TEXT    NOT NULL,
            Voto      INTEGER NOT NULL,
            FOREIGN KEY (Matricola) REFERENCES Studenti(Matricola)
        )
    """)
    
    # Inserisci studenti
    studenti = [
        (101, 'Mario',  'Rossi'),
        (102, 'Lucia',  'Bianchi'),
        (103, 'Paolo',  'Verdi'),
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO Studenti VALUES (?, ?, ?)",
        studenti
    )
    
    # Inserisci esami
    esami = [
        (101, 'Matematica',  28),
        (101, 'Informatica', 30),
        (101, 'Fisica',      27),
        (102, 'Matematica',  25),
        (102, 'Informatica', 30),
        (102, 'Fisica',      22),
        (103, 'Matematica',  18),
        (103, 'Informatica', 24),
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO Esami (Matricola, Corso, Voto) VALUES (?, ?, ?)",
        esami
    )
    
    conn.commit()
    conn.close()
    print("Database scuola.db creato con successo!")

setup_scuola()
```

---

### Esercizio F2 — Funzioni di lettura ⭐⭐

**Obiettivo:** Implementa funzioni per leggere i dati della scuola

```python
import sqlite3

DB = "scuola.db"

def get_tutti_studenti():
    conn   = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Studenti ORDER BY Cognome")
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def get_esami_studente(matricola):
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute(
        "SELECT Corso, Voto FROM Esami WHERE Matricola = ? ORDER BY Corso",
        (matricola,)
    )
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def get_media_per_studente():
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT s.Nome, s.Cognome, ROUND(AVG(e.Voto), 2) AS media
        FROM Studenti s
        JOIN Esami e ON s.Matricola = e.Matricola
        GROUP BY s.Matricola
        ORDER BY media DESC
    """)
    risultati = cursor.fetchall()
    conn.close()
    return risultati

# Test
if __name__ == "__main__":
    print("=== Tutti gli studenti ===")
    for s in get_tutti_studenti():
        print(f"  {s[0]} - {s[1]} {s[2]}")
    
    print("\n=== Esami di Mario Rossi (101) ===")
    for corso, voto in get_esami_studente(101):
        print(f"  {corso}: {voto}")
    
    print("\n=== Medie per studente ===")
    for nome, cognome, media in get_media_per_studente():
        print(f"  {nome} {cognome}: {media}")
```

---

### Esercizio F3 — Database Libreria completo ⭐⭐⭐

**Obiettivo:** Dal repository `2526_5M/python-sqlite-exercises/es05_testo.md`  
Implementa il sistema completo della libreria con 7 funzioni.

```python
import sqlite3

DB = "libreria.db"

def create_tables():
    conn   = sqlite3.connect(DB)
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
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Prestiti (
            id                INTEGER PRIMARY KEY AUTOINCREMENT,
            libro_id          INTEGER,
            utente            TEXT NOT NULL,
            data_prestito     DATE NOT NULL,
            data_restituzione DATE,
            FOREIGN KEY (libro_id) REFERENCES Libri(id)
        )
    """)
    conn.commit()
    conn.close()

def insert_data():
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    
    autori = [
        ("Umberto",   "Eco"),
        ("Italo",     "Calvino"),
        ("Elena",     "Ferrante"),
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO Autori (nome, cognome) VALUES (?, ?)",
        autori
    )
    
    libri = [
        ("Il Nome della Rosa",     1, 1980, "Giallo"),
        ("Il Pendolo di Foucault", 1, 1988, "Giallo"),
        ("Se una notte d'inverno", 2, 1979, "Narrativa"),
        ("Le città invisibili",    2, 1972, "Narrativa"),
        ("L'amica geniale",        3, 2011, "Narrativa"),
        ("Storia di chi fugge",    3, 2012, "Narrativa"),
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO Libri (titolo, autore_id, anno, genere) VALUES (?, ?, ?, ?)",
        libri
    )
    
    prestiti = [
        (1, "Marco Neri",    "2024-01-10", "2024-01-25"),
        (2, "Anna Verde",    "2024-02-01", None),
        (3, "Luca Blu",      "2024-01-15", "2024-01-30"),
        (5, "Sara Gialli",   "2024-02-10", None),
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO Prestiti (libro_id, utente, data_prestito, data_restituzione) VALUES (?, ?, ?, ?)",
        prestiti
    )
    
    conn.commit()
    conn.close()

def query_libri_per_autore(autore_id):
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT l.titolo, l.anno, l.genere
        FROM Libri l
        JOIN Autori a ON l.autore_id = a.id
        WHERE a.id = ?
        ORDER BY l.anno
    """, (autore_id,))
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def query_prestiti_per_utente(utente):
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT l.titolo, p.data_prestito, p.data_restituzione
        FROM Prestiti p
        JOIN Libri l ON p.libro_id = l.id
        WHERE p.utente = ?
    """, (utente,))
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def query_libri_per_genere():
    conn   = sqlite3.connect(DB)
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

def query_autori_con_piu_libri():
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT a.nome, a.cognome, COUNT(l.id) AS num_libri
        FROM Autori a
        JOIN Libri l ON a.id = l.autore_id
        GROUP BY a.id
        ORDER BY num_libri DESC
    """)
    risultati = cursor.fetchall()
    conn.close()
    return risultati

def query_prestiti_non_restituiti():
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT l.titolo, p.utente, p.data_prestito
        FROM Prestiti p
        JOIN Libri l ON p.libro_id = l.id
        WHERE p.data_restituzione IS NULL
        ORDER BY p.data_prestito
    """)
    risultati = cursor.fetchall()
    conn.close()
    return risultati

if __name__ == "__main__":
    create_tables()
    insert_data()
    
    print("=== Libri di Umberto Eco (id=1) ===")
    for titolo, anno, genere in query_libri_per_autore(1):
        print(f"  {titolo} ({anno}) - {genere}")
    
    print("\n=== Prestiti per utente 'Anna Verde' ===")
    for titolo, inizio, fine in query_prestiti_per_utente("Anna Verde"):
        stato = fine if fine else "non restituito"
        print(f"  {titolo}: {inizio} → {stato}")
    
    print("\n=== Libri per genere ===")
    for genere, num in query_libri_per_genere():
        print(f"  {genere}: {num} libri")
    
    print("\n=== Autori per numero libri ===")
    for nome, cognome, num in query_autori_con_piu_libri():
        print(f"  {nome} {cognome}: {num} libri")
    
    print("\n=== Prestiti non restituiti ===")
    for titolo, utente, data in query_prestiti_non_restituiti():
        print(f"  '{titolo}' — {utente} (da {data})")
```

---

### Esercizio F4 — Funzione INSERT con return id ⭐⭐

**Obiettivo:** Aggiungi un nuovo autore e un suo libro, restituendo gli ID generati

```python
import sqlite3

DB = "libreria.db"

def aggiungi_autore(nome, cognome):
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Autori (nome, cognome) VALUES (?, ?)",
        (nome, cognome)
    )
    conn.commit()
    nuovo_id = cursor.lastrowid   # id assegnato automaticamente
    conn.close()
    return nuovo_id

def aggiungi_libro(titolo, autore_id, anno, genere):
    conn   = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Libri (titolo, autore_id, anno, genere) VALUES (?, ?, ?, ?)",
        (titolo, autore_id, anno, genere)
    )
    conn.commit()
    nuovo_id = cursor.lastrowid
    conn.close()
    return nuovo_id

# Test
autore_id = aggiungi_autore("Alessandro", "Manzoni")
print(f"Autore inserito con id: {autore_id}")

libro_id = aggiungi_libro("I Promessi Sposi", autore_id, 1840, "Narrativa")
print(f"Libro inserito con id: {libro_id}")
```

---

## SEZIONE G — Esercizi Avanzati SQL

### Esercizio G1 — Sottoquery ⭐⭐⭐

**Obiettivo:** Trova gli studenti con voto superiore alla media generale

```sql
SELECT s.Nome, s.Cognome, e.Corso, e.Voto
FROM Studenti s
JOIN Esami e ON s.Matricola = e.Matricola
WHERE e.Voto > (SELECT AVG(Voto) FROM Esami)
ORDER BY e.Voto DESC;
```

---

### Esercizio G2 — Ranking ⭐⭐⭐

**Obiettivo:** La classifica degli studenti per media voti (dal migliore al peggiore)

```sql
SELECT 
    s.Nome,
    s.Cognome,
    COUNT(e.Id)              AS num_esami,
    ROUND(AVG(e.Voto), 2)   AS media,
    MAX(e.Voto)              AS voto_max,
    MIN(e.Voto)              AS voto_min
FROM Studenti s
JOIN Esami e ON s.Matricola = e.Matricola
GROUP BY s.Matricola
ORDER BY media DESC;
```

---

### Esercizio G3 — UPDATE in Python ⭐⭐

**Obiettivo:** Scrivi una funzione Python che aggiorna il voto di un esame

```python
import sqlite3

def aggiorna_voto(esame_id, nuovo_voto):
    if not (18 <= nuovo_voto <= 30):
        print("Errore: voto non valido (deve essere tra 18 e 30)")
        return False
    
    conn   = sqlite3.connect("scuola.db")
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Esami SET Voto = ? WHERE Id = ?",
        (nuovo_voto, esame_id)
    )
    conn.commit()
    righe_modificate = cursor.rowcount   # quante righe ha modificato
    conn.close()
    
    if righe_modificate == 0:
        print(f"Nessun esame trovato con id {esame_id}")
        return False
    
    print(f"Voto aggiornato a {nuovo_voto} per esame {esame_id}")
    return True

aggiorna_voto(1, 29)   # modifica l'esame con id=1
aggiorna_voto(99, 25)  # esame inesistente
aggiorna_voto(2, 35)   # voto non valido
```

---

*Fine Esercizi SQL/SQLite3 — vedi anche `06_ESERCIZI_PYTHON_API.md`*
