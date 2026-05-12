"""
============================================================
ESERCIZIO 01 — GET di una singola risorsa (BASE)
============================================================
TESTO:
Usa la libreria `requests` per recuperare il post con id=1
dall'API JSONPlaceholder.
Stampa: status code, ID, titolo, contenuto.

ENDPOINT: https://jsonplaceholder.typicode.com/posts/1
============================================================
"""

# Importiamo la libreria requests: gestisce richieste HTTP (GET, POST, PUT, DELETE).
# Per installarla: pip install requests
import requests


# Definiamo una funzione main() per organizzare il codice.
# `-> None` indica che la funzione non restituisce nulla (type hint).
def main() -> None:
    # URL dell'endpoint: punta a un post specifico (id=1).
    # JSONPlaceholder è una API pubblica di test che restituisce dati finti.
    url = "https://jsonplaceholder.typicode.com/posts/1"

    # requests.get(url) invia una richiesta HTTP GET all'URL.
    # timeout=10 → se il server non risponde entro 10 secondi, lancia eccezione.
    # Restituisce un oggetto Response con: status_code, headers, body, ecc.
    response = requests.get(url, timeout=10)

    # response.status_code → codice numerico HTTP (200 = OK, 404 = Not Found, ecc.)
    print(f"Status code: {response.status_code}")
    # response.url → mostra l'URL effettivamente chiamato (utile per debug query params)
    print(f"URL chiamato: {response.url}\n")

    # Controlliamo se la risposta è andata a buon fine (status 200).
    if response.status_code == 200:
        # response.json() → parsa il corpo (formato JSON) in un dict Python.
        # Esempio: '{"id":1, "title":"x"}' → {"id": 1, "title": "x"}
        post = response.json()

        # Accediamo ai campi del dizionario con la sintassi post["chiave"].
        print(f"ID:     {post['id']}")
        print(f"User:   {post['userId']}")
        print(f"Titolo: {post['title']}")
        # post['body'][:80] → prende i primi 80 caratteri della stringa body.
        print(f"Corpo:  {post['body'][:80]}...")
    else:
        # Se status != 200 stampiamo un messaggio di errore generico.
        print("Errore nella richiesta")


# Costrutto idiomatico Python: esegue main() solo se lo script viene avviato
# direttamente (non se viene importato da un altro file).
if __name__ == "__main__":
    main()
