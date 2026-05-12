"""
============================================================
ESERCIZIO 15 — Album e Foto (relazioni multi-livello)
============================================================
TESTO:
JSONPlaceholder offre anche /albums e /photos.
Recupera:
1. Tutti gli album dell'utente 1
2. Per ogni album, il numero di foto
3. Mostra l'album con piu' foto
============================================================
"""

import requests


BASE = "https://jsonplaceholder.typicode.com"


def main() -> None:
    # PASSO 1: scarica gli album dell'utente 1.
    # /albums?userId=1 → filtra per userId lato server.
    r = requests.get(f"{BASE}/albums", params={"userId": 1}, timeout=10)
    r.raise_for_status()
    albums = r.json()

    print(f"=== Album dell'utente 1: {len(albums)} ===\n")

    # Lista per accumulare info su album + numero foto.
    risultati = []

    # PASSO 2: per ogni album scarichiamo le foto.
    # ATTENZIONE: ogni iterazione fa una richiesta HTTP (può essere lento se molti album).
    for album in albums:
        # Endpoint /photos filtrato per albumId.
        rp = requests.get(f"{BASE}/photos", params={"albumId": album["id"]}, timeout=10)
        rp.raise_for_status()
        foto = rp.json()

        # Salviamo in una lista di dict (album + conteggio foto).
        risultati.append({
            "album": album,
            "foto":  len(foto)    # numero di foto in questo album
        })
        # Stampa progressiva: utile per vedere l'avanzamento.
        print(f"  Album [{album['id']:2d}] '{album['title'][:40]}' → {len(foto)} foto")

    # PASSO 3: troviamo l'album con il massimo numero di foto.
    if risultati:    # solo se la lista non è vuota
        # max(lista, key=funzione) → elemento con valore di chiave massimo.
        # x["foto"] è il numero di foto di ciascun elemento.
        top = max(risultati, key=lambda x: x["foto"])
        print(f"\n=== Album con piu' foto ===")
        print(f"  Titolo: {top['album']['title']}")
        print(f"  Numero foto: {top['foto']}")


if __name__ == "__main__":
    main()
