"""
============================================================
ESERCIZIO 09 — Todo Manager (da python-api-exercises/es10)
============================================================
TESTO:
1. Recupera tutti i todo dell'utente con id=1
2. Mostra le statistiche (totale, completati, incompleti)
3. Trova il PRIMO todo incompleto
4. Segnalo come completato con PUT
============================================================
"""

import requests
from typing import Optional


BASE_URL = "https://jsonplaceholder.typicode.com"


def get_todos_by_user(user_id: int) -> Optional[list]:
    # Recupera la lista di todos filtrata per userId con query parameter.
    try:
        response = requests.get(f"{BASE_URL}/todos", params={"userId": user_id}, timeout=10)
        response.raise_for_status()
        return response.json()    # lista di dict (ciascuno: id, title, completed, userId)
    except requests.exceptions.RequestException as e:
        print(f"Errore nel recupero dei todos: {e}")
        return None


def update_todo(todo_id: int, dati: dict) -> Optional[dict]:
    # PUT su /todos/{id} → sostituisce i campi forniti.
    try:
        response = requests.put(f"{BASE_URL}/todos/{todo_id}", json=dati, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nell'aggiornamento: {e}")
        return None


def main() -> None:
    user_id = 1
    # 1) Scarica tutti i todos dell'utente.
    todos = get_todos_by_user(user_id)
    # Se None (errore) o lista vuota, usciamo.
    if not todos:
        return

    # 2) CALCOLA LE STATISTICHE
    # len() restituisce il numero di elementi della lista.
    total = len(todos)

    # sum() su un'espressione generatrice:
    # "1 per ogni t completato" → conta i True.
    # Equivalente a: sum([1 if t["completed"] else 0 for t in todos])
    completati = sum(1 for t in todos if t["completed"])

    # Differenza: incompleti = totale - completati.
    incompleti = total - completati

    print(f"=== Todos dell'utente {user_id} ===")
    print(f"Totale:     {total}")
    print(f"Completati: {completati}")
    print(f"Incompleti: {incompleti}")

    # 3) TROVA IL PRIMO TODO INCOMPLETO
    # next(generatore, default) → restituisce il primo elemento del generatore,
    # oppure il default se non c'è nessun elemento.
    # (t for t in todos if not t["completed"]) → generatore dei todo non completati.
    primo_incompleto = next((t for t in todos if not t["completed"]), None)

    # Se non c'è nessun todo incompleto, non c'è nulla da aggiornare.
    if primo_incompleto is None:
        print("\nNessun todo incompleto trovato.")
        return

    print(f"\n--- Primo todo incompleto ---")
    print(f"ID:     {primo_incompleto['id']}")
    print(f"Titolo: {primo_incompleto['title']}")

    # 4) SEGNA COME COMPLETATO con PUT
    # Inviamo solo il campo da modificare. JSONPlaceholder accetta anche aggiornamenti parziali.
    aggiornato = update_todo(primo_incompleto["id"], {"completed": True})
    if aggiornato:
        print(f"\n--- Aggiornato ---")
        print(f"Completed = {aggiornato['completed']}")  # True se tutto ok


if __name__ == "__main__":
    main()
