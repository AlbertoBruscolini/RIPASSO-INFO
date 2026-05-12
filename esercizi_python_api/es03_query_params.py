"""
============================================================
ESERCIZIO 03 — GET con Query Parameters
============================================================
TESTO:
Recupera tutti i post dell'utente con userId=1.
Usa il dizionario `params` invece di costruire la stringa
URL manualmente.

ENDPOINT: /posts?userId=1
============================================================
"""

import requests


def main() -> None:
    # URL base senza query string. I parametri li passiamo separatamente.
    url = "https://jsonplaceholder.typicode.com/posts"

    # Dizionario dei query parameters. requests li aggiunge automaticamente all'URL.
    # In questo caso: ...posts?userId=1
    # Vantaggio rispetto a f-string: requests gestisce l'URL encoding (es. spazi → %20).
    params = {"userId": 1}

    # Passiamo il dizionario `params` al metodo get().
    response = requests.get(url, params=params, timeout=10)
    response.raise_for_status()  # solleva eccezione se errore HTTP

    # response.url mostra come l'URL è stato effettivamente costruito.
    # Utile per debug: verifichiamo che i parametri siano stati aggiunti.
    print(f"URL effettivamente chiamato: {response.url}\n")

    # Risposta = lista di post filtrati lato server (solo quelli con userId=1).
    posts = response.json()
    print(f"Post dell'utente 1: {len(posts)} trovati\n")

    # Stampa formattata: l'ID viene allineato su 3 cifre, il titolo troncato a 50 caratteri.
    for p in posts:
        print(f"[{p['id']:3d}] {p['title'][:50]}")


if __name__ == "__main__":
    main()
