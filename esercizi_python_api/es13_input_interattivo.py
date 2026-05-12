"""
============================================================
ESERCIZIO 13 — Menu Interattivo
============================================================
TESTO:
Crea un menu interattivo che permette all'utente di:
1. Vedere un post specifico
2. Vedere tutti i post di un utente
3. Creare un nuovo post
4. Uscire

Gestisce input non validi.
============================================================
"""

import requests


BASE_URL = "https://jsonplaceholder.typicode.com"


def mostra_post(post_id: int) -> None:
    """Mostra un singolo post dato il suo id."""
    try:
        r = requests.get(f"{BASE_URL}/posts/{post_id}", timeout=10)
        r.raise_for_status()
        p = r.json()
        # Stampa formattata su più righe.
        print(f"\n[Post {p['id']}]")
        print(f"Titolo: {p['title']}")
        print(f"Corpo:  {p['body']}")
    except requests.exceptions.HTTPError:
        # Se status >= 400 (es. 404 se l'id non esiste).
        print(f"Post {post_id} non trovato.")


def mostra_post_utente(user_id: int) -> None:
    """Mostra tutti i post di uno specifico utente."""
    try:
        r = requests.get(f"{BASE_URL}/posts", params={"userId": user_id}, timeout=10)
        r.raise_for_status()
        posts = r.json()

        # Gestione caso "nessun risultato".
        if not posts:
            print(f"Nessun post per utente {user_id}.")
            return

        print(f"\nPost dell'utente {user_id}:")
        for p in posts:
            # Allineamento ID su 3 cifre, titolo troncato a 60 caratteri.
            print(f"  [{p['id']:3d}] {p['title'][:60]}")
    except requests.exceptions.RequestException as e:
        print(f"Errore: {e}")


def crea_post() -> None:
    """Crea un nuovo post chiedendo i dati all'utente."""
    # input() → legge una stringa dall'utente (premendo Invio).
    # int() converte la stringa in intero, lanciando ValueError se non è valida.
    try:
        user_id = int(input("User ID: "))
        titolo  = input("Titolo: ")
        corpo   = input("Corpo:  ")
    except ValueError:
        # ValueError = stringa non convertibile in int (es. "abc").
        print("Input non valido")
        return

    try:
        # POST con i dati raccolti dall'input.
        r = requests.post(
            f"{BASE_URL}/posts",
            json={"userId": user_id, "title": titolo, "body": corpo},
            timeout=10
        )
        r.raise_for_status()
        creato = r.json()
        # JSONPlaceholder restituisce l'id assegnato (101).
        print(f"Post creato! ID: {creato['id']}")
    except requests.exceptions.RequestException as e:
        print(f"Errore: {e}")


def main() -> None:
    # Loop infinito: continua finché l'utente non sceglie "Esci".
    while True:
        print("\n=== MENU ===")
        print("1) Vedi un post")
        print("2) Vedi tutti i post di un utente")
        print("3) Crea un nuovo post")
        print("0) Esci")

        # .strip() rimuove spazi/invio iniziali e finali (utile per evitare bug).
        scelta = input("\nScelta: ").strip()

        # Confronto con stringhe (la scelta è sempre una stringa da input()).
        if scelta == "1":
            try:
                pid = int(input("ID del post (1-100): "))
                mostra_post(pid)
            except ValueError:
                print("ID non valido")
        elif scelta == "2":
            try:
                uid = int(input("User ID (1-10): "))
                mostra_post_utente(uid)
            except ValueError:
                print("ID non valido")
        elif scelta == "3":
            crea_post()
        elif scelta == "0":
            print("Ciao!")
            break   # esce dal while True
        else:
            # Qualsiasi altra cosa è una scelta non valida.
            print("Scelta non valida")


if __name__ == "__main__":
    main()
