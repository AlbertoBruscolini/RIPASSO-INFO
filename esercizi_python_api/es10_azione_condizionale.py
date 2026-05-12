"""
============================================================
ESERCIZIO 10 — Azione Condizionale (es11 del repo)
============================================================
TESTO:
1. Recupera i post dell'utente 1
2. Conta i commenti di ciascun post
3. Trova il post con più commenti
4. Se ha < 5 commenti -> CREA un nuovo commento (POST)
   Altrimenti      -> ELIMINA il commento più vecchio (DELETE)
============================================================
"""

import requests
from typing import Optional


BASE_URL = "https://jsonplaceholder.typicode.com"


# Ognuna di queste funzioni isola una operazione API specifica.
# Vantaggi: codice più leggibile, riutilizzabile, testabile.

def get_posts_by_user(user_id: int) -> Optional[list]:
    """Recupera la lista di post pubblicati da un utente."""
    try:
        r = requests.get(f"{BASE_URL}/posts", params={"userId": user_id}, timeout=10)
        r.raise_for_status()
        return r.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore: {e}")
        return None


def get_comments(post_id: int) -> Optional[list]:
    """Recupera i commenti di un singolo post."""
    try:
        r = requests.get(f"{BASE_URL}/posts/{post_id}/comments", timeout=10)
        r.raise_for_status()
        return r.json()
    except requests.exceptions.RequestException:
        # In caso di errore restituiamo lista vuota (per non bloccare il flusso).
        return []


def create_comment(post_id: int, name: str, email: str, body: str) -> Optional[dict]:
    """Crea un nuovo commento via POST."""
    # Payload da inviare nel body della POST.
    payload = {"postId": post_id, "name": name, "email": email, "body": body}
    try:
        r = requests.post(f"{BASE_URL}/comments", json=payload, timeout=10)
        r.raise_for_status()
        return r.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore creazione: {e}")
        return None


def delete_comment(comment_id: int) -> bool:
    """Elimina un commento via DELETE. Ritorna True se ha avuto successo."""
    try:
        r = requests.delete(f"{BASE_URL}/comments/{comment_id}", timeout=10)
        r.raise_for_status()
        return True
    except requests.exceptions.RequestException as e:
        print(f"Errore eliminazione: {e}")
        return False


def main() -> None:
    user_id = 1
    # Soglia di decisione: sotto questo numero creiamo, sopra eliminiamo.
    SOGLIA = 5

    print("FASE 1: Recupero post")
    posts = get_posts_by_user(user_id)
    if not posts:    # None o lista vuota
        return

    print("\nFASE 2: Conteggio commenti per ogni post")
    # Variabili per tenere traccia del massimo durante l'iterazione.
    max_count = -1        # inizia a -1 così qualsiasi conteggio è "maggiore"
    max_post_id = None    # id del post col massimo
    max_comments = []     # lista commenti di quel post

    # Per ogni post, scarichiamo i commenti e contiamo.
    for post in posts:
        # `comments or []` → se comments è None, usa lista vuota
        comments = get_comments(post["id"]) or []
        print(f"  Post [{post['id']:3d}] commenti: {len(comments)}")

        # Aggiorniamo il massimo se necessario.
        if len(comments) > max_count:
            max_count = len(comments)
            max_post_id = post["id"]
            max_comments = comments

    print(f"\nPost con piu' commenti: ID {max_post_id} con {max_count} commenti")

    print(f"\nFASE 3: Azione condizionale (soglia: {SOGLIA})")
    # SCELTA CONDIZIONALE: crea o elimina?
    if max_count < SOGLIA:
        # CASO A: pochi commenti → creiamo un nuovo commento (POST).
        nuovo = create_comment(
            post_id=max_post_id,
            name="Bot Commento",
            email="bot@example.com",
            body="Commento automatico"
        )
        if nuovo:
            print(f"  < {SOGLIA}: Creato commento nuovo, ID={nuovo['id']}")
    else:
        # CASO B: tanti commenti → eliminiamo il più vecchio (DELETE).
        # Convenzione: id più basso = commento più vecchio.
        # min(lista, key=funzione) → elemento con valore di chiave minimo.
        # Qui la chiave è c["id"] → trova l'elemento con id più piccolo.
        commento_piu_vecchio = min(max_comments, key=lambda c: c["id"])
        if delete_comment(commento_piu_vecchio["id"]):
            print(f"  >= {SOGLIA}: Eliminato commento ID={commento_piu_vecchio['id']}")


if __name__ == "__main__":
    main()
