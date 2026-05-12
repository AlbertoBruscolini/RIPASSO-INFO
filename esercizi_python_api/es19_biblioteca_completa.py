"""
============================================================
ESERCIZIO 19 — Biblioteca completa (es12 del repo)
============================================================
TESTO:
Esercizio ispirato a python-api-exercises/es12 del repo 2526_5M.

Il repo usa un server locale (localhost:3001) con endpoint:
  /authors, /genres, /books

Per evitare di avviare il server, qui usiamo dati LOCALI
embedded (la stessa struttura di db_biblioteca.json del repo).

Compiti:
1. Recupera i libri dell'autore 1 -> stampa titoli e pagine
2. Filtra solo i libri disponibili
3. Somma le pagine dei libri disponibili
4. Conta i libri del genere "Fantasy"
============================================================
"""

# Dati embedded — simulano il database del server locale del repo.
# Lista di dict, ognuno rappresenta un record (riga della tabella).

AUTHORS = [
    {"id": 1, "name": "J.R.R. Tolkien", "country": "UK"},
    {"id": 2, "name": "Italo Calvino",  "country": "IT"},
    {"id": 3, "name": "Umberto Eco",    "country": "IT"},
]

GENRES = [
    {"id": 100, "name": "Narrativa"},
    {"id": 101, "name": "Fantasy"},
    {"id": 102, "name": "Giallo"},
]

# Ogni libro ha: id, riferimento all'autore (FK), riferimento al genere (FK),
# titolo, numero pagine, e flag di disponibilità.
BOOKS = [
    {"id": 1, "author_id": 1, "genre_id": 101, "title": "Il Signore degli Anelli", "pages": 1200, "available": True},
    {"id": 2, "author_id": 1, "genre_id": 101, "title": "Lo Hobbit",                "pages": 320,  "available": True},
    {"id": 3, "author_id": 1, "genre_id": 101, "title": "Il Silmarillion",         "pages": 480,  "available": False},
    {"id": 4, "author_id": 2, "genre_id": 100, "title": "Le citta invisibili",     "pages": 180,  "available": True},
    {"id": 5, "author_id": 3, "genre_id": 102, "title": "Il nome della rosa",      "pages": 600,  "available": True},
]


# === FUNZIONI DI ACCESSO AI DATI (simulano gli endpoint dell'API) ===

def get_books_by_author(author_id: int) -> list:
    """Restituisce i libri di un autore specifico.

    List comprehension: [espressione for x in lista if condizione]
    Equivale a: result = []; for b in BOOKS: if b["author_id"] == author_id: result.append(b)
    """
    return [b for b in BOOKS if b["author_id"] == author_id]


def get_author(author_id: int) -> dict | None:
    """Trova un autore per id, restituisce None se non esiste."""
    # next(generatore, default):
    # - prende il primo elemento del generatore
    # - se il generatore è vuoto, restituisce `default` (qui None)
    return next((a for a in AUTHORS if a["id"] == author_id), None)


def get_genre(genre_id: int) -> dict | None:
    """Trova un genere per id."""
    return next((g for g in GENRES if g["id"] == genre_id), None)


def get_books_by_genre(genre_id: int) -> list:
    """Filtra i libri per genere."""
    return [b for b in BOOKS if b["genre_id"] == genre_id]


def main() -> None:
    # 1) LIBRI DELL'AUTORE 1
    autore = get_author(1)
    libri  = get_books_by_author(1)
    print(f"=== Libri di {autore['name']} ===")
    for b in libri:
        # :<30 → stringa allineata a sinistra su 30 caratteri (per tabella).
        # :4d → intero su 4 cifre.
        print(f"  [{b['id']}] {b['title']:<30} {b['pages']:4d} pagine")

    # 2) FILTRA SOLO I DISPONIBILI
    # List comprehension con condizione → solo libri con available=True.
    disponibili = [b for b in libri if b["available"]]
    print(f"\n=== Libri disponibili ({len(disponibili)}) ===")
    for b in disponibili:
        print(f"  - {b['title']}")

    # 3) SOMMA PAGINE DEI DISPONIBILI
    # sum() su un generatore: somma le pagine di ogni libro disponibile.
    # `b["pages"] for b in disponibili` è una generator expression (più efficiente
    # di una list comprehension perché non crea la lista intermedia in memoria).
    totale_pagine = sum(b["pages"] for b in disponibili)
    print(f"\nTotale pagine disponibili: {totale_pagine}")

    # 4) LIBRI DEL GENERE "FANTASY" (id=101)
    genere = get_genre(101)
    libri_fantasy = get_books_by_genre(101)
    print(f"\n=== Genere '{genere['name']}': {len(libri_fantasy)} libri ===")
    for b in libri_fantasy:
        print(f"  - {b['title']}")


if __name__ == "__main__":
    main()
