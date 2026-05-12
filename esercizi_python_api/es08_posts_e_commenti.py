"""
============================================================
ESERCIZIO 08 — Post + Commenti + Nuovo commento
(da python-api-exercises/es09 del repo 2526_5M)
============================================================
TESTO:
1. Recupera tutti i post dell'utente con id=1
2. Per il primo post, recupera i commenti
3. Crea un nuovo commento per quel post

Tutto con gestione errori.
============================================================
"""

import requests
from typing import Optional


# Costante: URL base dell'API. Usare una costante evita di ripetere la stringa
# ovunque e rende più facile cambiare endpoint (es. da test a produzione).
BASE_URL = "https://jsonplaceholder.typicode.com"


def get_posts_by_user(user_id: int) -> Optional[list]:
    """Recupera tutti i post pubblicati dall'utente con ID specificato."""
    try:
        # Endpoint: /posts?userId=N → filtra lato server.
        # f"{BASE_URL}/posts" → concatena la base con il path.
        response = requests.get(f"{BASE_URL}/posts", params={"userId": user_id}, timeout=10)
        response.raise_for_status()
        # Restituisce una lista (anche vuota se non ci sono risultati).
        return response.json()
    except requests.exceptions.RequestException as e:
        # In caso di errore stampiamo info e restituiamo None per segnalare il fallimento.
        print(f"Errore nel recupero dei post: {e}")
        return None


def get_comments_for_post(post_id: int) -> Optional[list]:
    """Recupera i commenti per un post specifico."""
    try:
        # Endpoint nested: /posts/{id}/comments → mostra la relazione 1-a-N.
        response = requests.get(f"{BASE_URL}/posts/{post_id}/comments", timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nel recupero dei commenti: {e}")
        return None


def create_comment(post_id: int, name: str, email: str, body: str) -> Optional[dict]:
    """Crea un nuovo commento per un post specifico."""
    # Costruiamo il payload (il body della richiesta) come dict.
    # Le chiavi devono corrispondere a quelle del modello dell'API.
    comment_data = {"postId": post_id, "name": name, "email": email, "body": body}
    try:
        # POST → crea una nuova risorsa. json=dati invia il dict come JSON.
        response = requests.post(f"{BASE_URL}/comments", json=comment_data, timeout=10)
        response.raise_for_status()  # 201 Created se tutto ok
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nella creazione del commento: {e}")
        return None


def main() -> None:
    user_id = 1

    # FASE 1: recupera tutti i post dell'utente.
    posts = get_posts_by_user(user_id)
    # if not posts → True se posts è None OPPURE è una lista vuota.
    # In entrambi i casi non possiamo proseguire.
    if not posts:
        return

    # Stampa intestazione + lista post.
    print(f"--- Post dell'utente {user_id} ---")
    for post in posts:
        # :3d → intero su 3 cifre. [:50] → primi 50 caratteri.
        print(f"ID {post['id']:3d} | {post['title'][:50]}")

    # FASE 2: prendiamo l'id del primo post per recuperarne i commenti.
    # posts[0] = primo elemento della lista. ["id"] = sua chiave id.
    first_post_id = posts[0]["id"]
    comments = get_comments_for_post(first_post_id)
    # Distinguiamo None (errore) da lista vuota (nessun commento).
    if comments is None:
        return

    print(f"\n--- Commenti del post {first_post_id} ---")
    for c in comments:
        # Tronchiamo a 40 caratteri per non sporcare l'output.
        print(f"- {c['name'][:40]}")

    # FASE 3: creiamo un nuovo commento per il primo post.
    new_comment = create_comment(
        post_id=first_post_id,
        name="Nuovo Commentatore",
        email="nuovo@example.com",
        body="Questo e' un commento aggiunto tramite API!"
    )
    # Se non None, mostriamo i dettagli del commento creato.
    if new_comment:
        print(f"\n--- Nuovo Commento Creato ---")
        # JSONPlaceholder restituisce un id fittizio (501) anche se non salva davvero.
        print(f"ID:    {new_comment['id']}")
        print(f"Nome:  {new_comment['name']}")
        print(f"Email: {new_comment['email']}")


if __name__ == "__main__":
    main()
