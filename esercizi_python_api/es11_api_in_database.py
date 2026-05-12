"""
============================================================
ESERCIZIO 11 — Scarica da API e salva in SQLite
============================================================
TESTO:
1. Scarica tutti gli utenti da JSONPlaceholder
2. Salvali in un database SQLite locale (utenti_api.db)
3. Stampa il contenuto del database

Mostra come integrare API + database.
============================================================
"""

import requests   # per chiamate HTTP
import sqlite3    # database SQLite (incluso nella libreria standard)


# Costante: nome del file del database. Sarà creato se non esiste.
DB_PATH = "utenti_api.db"


def crea_db() -> None:
    """Crea la tabella Utenti se non esiste già."""
    # connect() apre la connessione (crea il file .db se manca).
    conn = sqlite3.connect(DB_PATH)

    # conn.execute() esegue una sola query SQL.
    # IF NOT EXISTS → evita errore se la tabella esiste già.
    conn.execute("""
        CREATE TABLE IF NOT EXISTS Utenti (
            id       INTEGER PRIMARY KEY,
            nome     TEXT NOT NULL,
            username TEXT NOT NULL,
            email    TEXT NOT NULL,
            citta    TEXT,
            telefono TEXT,
            website  TEXT
        )
    """)
    conn.commit()   # salva le modifiche su disco
    conn.close()    # chiude la connessione (importante!)


def scarica_e_salva() -> int:
    """Scarica gli utenti dall'API e li salva nel DB. Ritorna il numero salvato."""
    # GET /users → lista di tutti gli utenti (10).
    response = requests.get("https://jsonplaceholder.typicode.com/users", timeout=10)
    response.raise_for_status()
    utenti = response.json()

    # Apriamo una connessione al DB per scrivere i dati.
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()    # il cursor è l'oggetto che esegue query

    # Iteriamo su ogni utente e lo inseriamo nel database.
    for u in utenti:
        # INSERT OR REPLACE → se esiste già un utente con quell'id lo sostituisce.
        # IMPORTANTE: usiamo i placeholder ? per evitare SQL Injection!
        # I valori sono passati come tupla nel 2° argomento.
        cursor.execute("""
            INSERT OR REPLACE INTO Utenti
                (id, nome, username, email, citta, telefono, website)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            u["id"],
            u["name"],
            u["username"],
            u["email"],
            u["address"]["city"],   # citta annidata nel dict address
            u["phone"],
            u["website"],
        ))

    conn.commit()    # SALVA le modifiche su disco (senza commit non vengono persistite!)
    conn.close()
    return len(utenti)


def leggi_db() -> list:
    """Legge tutti gli utenti dal database e li restituisce."""
    conn = sqlite3.connect(DB_PATH)
    # row_factory = sqlite3.Row → permette di accedere ai campi per nome (riga["nome"]).
    # Senza questa riga, dovremmo usare gli indici (riga[0], riga[1], ...).
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Utenti ORDER BY nome")
    # fetchall() → restituisce tutte le righe come una lista.
    righe = cursor.fetchall()
    conn.close()
    return righe


def main() -> None:
    print("1) Creazione database...")
    crea_db()

    print("2) Scaricamento dati dall'API...")
    n = scarica_e_salva()
    print(f"   Scaricati e salvati: {n} utenti")

    print("\n3) Contenuto del database:")
    # Header tabella formattato.
    print(f"   {'ID':>3} | {'Nome':<25} | {'Email':<30} | Citta")
    print("   " + "-" * 80)

    # Ciclo su tutte le righe lette dal DB.
    for u in leggi_db():
        # Grazie a row_factory possiamo accedere con u["nome"] invece di u[1].
        print(f"   {u['id']:>3} | {u['nome']:<25} | {u['email']:<30} | {u['citta']}")


if __name__ == "__main__":
    main()
