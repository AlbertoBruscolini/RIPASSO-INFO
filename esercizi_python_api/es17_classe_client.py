"""
============================================================
ESERCIZIO 17 — Classe Client API (Object Oriented)
============================================================
TESTO:
Riorganizza le funzioni in una classe `PostsClient`.
La classe mantiene la `BASE_URL` come attributo e fornisce
metodi: get_all, get_by_id, get_by_user, create, update, delete.
============================================================
"""

import requests
from typing import Optional


# Definizione di una classe (programmazione orientata agli oggetti).
# `class NomeClasse:` introduce una nuova classe.
class PostsClient:
    """Client per l'API /posts di JSONPlaceholder."""

    # __init__ è il "costruttore": viene chiamato quando si crea un'istanza.
    # `self` rappresenta l'istanza corrente (come `this` in altri linguaggi).
    # base_url ha un valore di default → posso creare il client senza argomenti.
    def __init__(self, base_url: str = "https://jsonplaceholder.typicode.com"):
        # Salviamo base_url come attributo dell'istanza (accessibile con self.base_url).
        self.base_url = base_url

    # Metodo: funzione che appartiene alla classe.
    # Il primo parametro è sempre `self` (l'istanza).
    def get_all(self) -> list:
        """GET /posts → restituisce tutti i post."""
        # Possiamo usare self.base_url ovunque dentro i metodi.
        r = requests.get(f"{self.base_url}/posts", timeout=10)
        r.raise_for_status()
        return r.json()

    def get_by_id(self, post_id: int) -> Optional[dict]:
        """GET /posts/{id} → singolo post, None se non trovato."""
        r = requests.get(f"{self.base_url}/posts/{post_id}", timeout=10)
        # Controllo manuale del 404 prima di raise_for_status.
        if r.status_code == 404:
            return None    # post inesistente: ritorniamo None invece di errore
        r.raise_for_status()
        return r.json()

    def get_by_user(self, user_id: int) -> list:
        """GET /posts?userId=N → post di un utente specifico."""
        r = requests.get(f"{self.base_url}/posts", params={"userId": user_id}, timeout=10)
        r.raise_for_status()
        return r.json()

    def create(self, user_id: int, title: str, body: str) -> dict:
        """POST /posts → crea un nuovo post."""
        payload = {"userId": user_id, "title": title, "body": body}
        r = requests.post(f"{self.base_url}/posts", json=payload, timeout=10)
        r.raise_for_status()
        return r.json()

    def update(self, post_id: int, data: dict) -> dict:
        """PUT /posts/{id} → aggiorna un post."""
        r = requests.put(f"{self.base_url}/posts/{post_id}", json=data, timeout=10)
        r.raise_for_status()
        return r.json()

    def delete(self, post_id: int) -> bool:
        """DELETE /posts/{id} → elimina un post. Ritorna True se ok."""
        r = requests.delete(f"{self.base_url}/posts/{post_id}", timeout=10)
        return r.ok    # True se status 2xx


def main() -> None:
    # Creiamo un'istanza della classe (chiamando il costruttore).
    # Senza argomenti perché base_url ha un default.
    client = PostsClient()

    # Ora possiamo usare il client come un oggetto, chiamando i suoi metodi.
    # Vantaggio rispetto a funzioni libere: la base_url è "salvata" nell'istanza.
    print("Totale post:", len(client.get_all()))

    # Recupero singolo post.
    post = client.get_by_id(1)
    print(f"\nPost 1: {post['title'][:50]}")

    # Filtraggio per utente.
    miei = client.get_by_user(1)
    print(f"\nPost dell'utente 1: {len(miei)}")

    # Creazione.
    nuovo = client.create(1, "Test", "Corpo di prova")
    print(f"\nCreato: ID {nuovo['id']}")

    # Aggiornamento (PUT richiede oggetto completo).
    aggiornato = client.update(1, {"userId": 1, "title": "Aggiornato", "body": "x", "id": 1})
    print(f"Aggiornato: {aggiornato['title']}")

    # Eliminazione.
    successo = client.delete(1)
    print(f"Eliminato: {successo}")


if __name__ == "__main__":
    main()
