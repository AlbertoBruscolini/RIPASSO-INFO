"""
============================================================
ESERCIZIO 05 — PUT: aggiornare una risorsa
============================================================
TESTO:
Aggiorna completamente il todo con id=1 cambiandone titolo
e stato di completamento.
PUT sostituisce TUTTI i campi (a differenza di PATCH).

ENDPOINT: PUT /todos/1
============================================================
"""

import requests


def aggiorna_todo(todo_id: int, dati: dict) -> dict | None:
    # f-string per inserire l'id nell'URL: /todos/1, /todos/2, ecc.
    url = f"https://jsonplaceholder.typicode.com/todos/{todo_id}"

    try:
        # requests.put(url, json=dati) → invia PUT con body JSON.
        # PUT viene usato per AGGIORNARE una risorsa esistente.
        # Per convenzione REST: PUT sostituisce TUTTI i campi (idempotente).
        # Per modifiche parziali si usa PATCH invece.
        response = requests.put(url, json=dati, timeout=10)

        # Status atteso: 200 OK (oppure 204 No Content).
        response.raise_for_status()

        # JSONPlaceholder restituisce l'oggetto aggiornato (con i nuovi valori).
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore: {e}")
        return None


def main() -> None:
    # Definiamo i nuovi valori per il todo.
    # ATTENZIONE: PUT richiede l'oggetto COMPLETO, non solo i campi cambiati!
    nuovo_stato = {
        "userId":    1,
        "title":     "Nuovo titolo del todo",
        "completed": True       # in Python True/False (in JSON diventa true/false)
    }

    # Chiamata della funzione che fa il PUT.
    risultato = aggiorna_todo(1, nuovo_stato)

    # Se non c'è stato errore, mostriamo il risultato.
    if risultato:
        # Operatore ternario Python: valore_se_vero if condizione else valore_se_falso
        stato = "completato" if risultato["completed"] else "non completato"
        print("=== Todo aggiornato ===")
        print(f"ID:       {risultato['id']}")
        print(f"Titolo:   {risultato['title']}")
        print(f"Stato:    {stato}")


if __name__ == "__main__":
    main()
