"""
============================================================
ESERCIZIO 06 — DELETE: eliminare una risorsa
============================================================
TESTO:
Elimina il commento con id=5 e verifica il successo
controllando lo status code.

DELETE non ha corpo richiesta. Risposta tipica:
- 200 OK con body vuoto, oppure
- 204 No Content

ENDPOINT: DELETE /comments/5
============================================================
"""

import requests


# La funzione restituisce True se l'eliminazione è riuscita, False altrimenti.
def elimina_commento(commento_id: int) -> bool:
    # Costruzione URL con l'id del commento da eliminare.
    url = f"https://jsonplaceholder.typicode.com/comments/{commento_id}"

    try:
        # requests.delete(url) → invia richiesta HTTP DELETE.
        # Non c'è body (a differenza di POST/PUT).
        response = requests.delete(url, timeout=10)

        # raise_for_status: solleva eccezione se status >= 400.
        response.raise_for_status()

        # response.ok è True se status_code è 2xx (200-299), False altrimenti.
        # Equivale a: 200 <= response.status_code < 300
        return response.ok
    except requests.exceptions.RequestException as e:
        print(f"Errore: {e}")
        return False


def main() -> None:
    commento_id = 5

    # Chiamiamo la funzione e otteniamo True/False.
    successo = elimina_commento(commento_id)

    # if successo: equivale a if successo == True:
    if successo:
        print(f"Commento {commento_id} eliminato con successo!")
    else:
        print(f"Impossibile eliminare il commento {commento_id}")


if __name__ == "__main__":
    main()
