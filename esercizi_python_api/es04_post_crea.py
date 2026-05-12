"""
============================================================
ESERCIZIO 04 — POST: creare una nuova risorsa
============================================================
TESTO:
Crea un nuovo post inviando i dati come JSON nel body.
Usa il parametro `json=` di requests che imposta in automatico
il Content-Type: application/json.

ENDPOINT: POST /posts
============================================================
"""

import requests


# La funzione restituisce un dict (in caso di successo) oppure None (errore).
# `dict | None` è la sintassi Python 3.10+ per "Optional[dict]".
def crea_post(user_id: int, titolo: str, corpo: str) -> dict | None:
    # URL dell'endpoint per la creazione di un nuovo post.
    url = "https://jsonplaceholder.typicode.com/posts"

    # Costruiamo il dizionario con i dati da inviare nel body della richiesta.
    # Le chiavi devono corrispondere a quelle che l'API si aspetta.
    nuovo_post = {
        "userId": user_id,
        "title":  titolo,
        "body":   corpo,
    }

    # try/except permette di gestire eventuali errori senza far crashare il programma.
    try:
        # requests.post(url, json=dati) → invia POST con body JSON.
        # Il parametro `json=` fa due cose automaticamente:
        #   1. Serializza il dict in stringa JSON
        #   2. Imposta l'header Content-Type: application/json
        response = requests.post(url, json=nuovo_post, timeout=10)

        # Se la creazione fallisce (status 4xx/5xx), solleva HTTPError.
        response.raise_for_status()

        # Successo: il server risponde con il post creato + ID assegnato.
        return response.json()
    except requests.exceptions.RequestException as e:
        # Cattura QUALSIASI eccezione legata a requests (HTTPError, Timeout, ConnError).
        print(f"Errore: {e}")
        return None


def main() -> None:
    # Chiamiamo la funzione crea_post con parametri di esempio.
    risultato = crea_post(
        user_id=1,
        titolo="Il mio primo post via API",
        corpo="Questo post e' stato creato con Python e requests!"
    )

    # Verifichiamo che la creazione sia andata a buon fine (risultato != None).
    if risultato:
        print("=== Post creato ===")
        # Lo status code per la creazione è solitamente 201 Created.
        # L'API simula la creazione e restituisce un id fittizio (101 nel caso di JSONPlaceholder).
        print(f"ID assegnato: {risultato['id']}")
        print(f"Titolo:       {risultato['title']}")
        print(f"User ID:      {risultato['userId']}")


if __name__ == "__main__":
    main()
