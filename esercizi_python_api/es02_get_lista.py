"""
============================================================
ESERCIZIO 02 — GET di una lista di risorse
============================================================
TESTO:
Recupera tutti gli utenti dall'endpoint /users e stampa
id, nome ed email di ciascuno. Stampa anche il totale.

ENDPOINT: https://jsonplaceholder.typicode.com/users
============================================================
"""

import requests   # libreria per richieste HTTP


def main() -> None:
    # Endpoint /users → restituisce un ARRAY JSON di utenti (10 elementi).
    # A differenza di /users/1 (singolo oggetto), qui otteniamo una lista.
    url = "https://jsonplaceholder.typicode.com/users"

    # Eseguiamo la richiesta GET con timeout di 10 secondi.
    response = requests.get(url, timeout=10)

    # raise_for_status() lancia un'eccezione HTTPError se status >= 400.
    # Se status = 200, non fa nulla. Permette di gestire errori con try/except.
    response.raise_for_status()

    # response.json() ora restituisce una LISTA di dizionari (non un singolo dict).
    utenti = response.json()

    # len(lista) → numero di elementi nella lista.
    print(f"=== {len(utenti)} utenti trovati ===\n")

    # Iteriamo su ogni utente della lista (ciclo for su collezione).
    for u in utenti:
        # Formattazione: :2d → numero intero allineato su 2 cifre
        #                :<25 → stringa allineata a sinistra su 25 caratteri
        print(f"[{u['id']:2d}] {u['name']:<25} {u['email']}")
        # Accesso a campi annidati: address è un dict dentro u, .city è una sua chiave.
        print(f"      Citta: {u['address']['city']}")
        print()   # riga vuota di separazione


if __name__ == "__main__":
    main()
