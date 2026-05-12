"""
============================================================
ESERCIZIO 12 — Statistiche sui post
============================================================
TESTO:
Genera un report statistico:
1. Numero totale di post
2. Numero di post per ciascun utente
3. Top 3 utenti con piu' post
4. Lunghezza media dei titoli e dei corpi
5. Post piu' lungo (per corpo)
============================================================
"""

import requests


BASE_URL = "https://jsonplaceholder.typicode.com"


def main() -> None:
    print("Scaricamento dati...")
    # Due chiamate HTTP: una per i post (100 elementi), una per gli utenti (10).
    # .json() viene chiamato direttamente sull'oggetto Response.
    posts = requests.get(f"{BASE_URL}/posts", timeout=10).json()
    users = requests.get(f"{BASE_URL}/users", timeout=10).json()

    print(f"\n=== STATISTICHE POST ===\n")
    print(f"Numero totale di post: {len(posts)}")

    # Dict comprehension: per ogni utente, mappa id → nome.
    # Equivalente a: user_names = {}; for u in users: user_names[u["id"]] = u["name"]
    # Utile per fare "lookup" veloce dell'utente.
    user_names = {u["id"]: u["name"] for u in users}

    # CONTEGGIO POST PER UTENTE
    # Inizializziamo un dict vuoto.
    conteggio = {}
    # Per ogni post, incrementiamo il contatore del suo autore.
    for p in posts:
        uid = p["userId"]
        # conteggio.get(uid, 0) → restituisce il valore se esiste, altrimenti 0.
        # Evita KeyError la prima volta che vediamo quell'utente.
        conteggio[uid] = conteggio.get(uid, 0) + 1

    # STAMPA tabella ordinata
    print("\nPost per utente:")
    print(f"  {'Utente':<25} | Post")
    print("  " + "-" * 38)
    # sorted(conteggio.items()) → ordina per chiave (uid crescente).
    # .items() su un dict restituisce coppie (chiave, valore).
    for uid, count in sorted(conteggio.items()):
        # .get() con default "?" evita errori se l'utente non è nella mappa.
        nome = user_names.get(uid, "?")
        print(f"  {nome:<25} | {count}")

    # TOP 3 UTENTI
    # sorted(..., key=lambda x: x[1], reverse=True) → ordina per il 2° elemento (count) decrescente.
    # [:3] → prendi solo i primi 3.
    top3 = sorted(conteggio.items(), key=lambda x: x[1], reverse=True)[:3]
    print("\nTop 3 utenti con piu' post:")
    # enumerate(..., start=1) → aggiunge un indice partendo da 1.
    for i, (uid, count) in enumerate(top3, 1):
        print(f"  {i}. {user_names.get(uid)} ({count} post)")

    # LUNGHEZZE
    # List comprehension: crea liste con la lunghezza di ogni titolo/corpo.
    lunghezze_titoli = [len(p["title"]) for p in posts]
    lunghezze_corpi  = [len(p["body"])  for p in posts]

    # Media = somma / numero. sum() e len() sono built-in di Python.
    media_titoli = sum(lunghezze_titoli) / len(lunghezze_titoli)
    media_corpi  = sum(lunghezze_corpi)  / len(lunghezze_corpi)

    # :.1f → 1 cifra decimale.
    print(f"\nLunghezza media titoli: {media_titoli:.1f} caratteri")
    print(f"Lunghezza media corpi:  {media_corpi:.1f} caratteri")

    # POST PIU' LUNGO
    # max(lista, key=funzione) → elemento con valore di chiave massimo.
    # Qui cerchiamo il post con il body più lungo.
    piu_lungo = max(posts, key=lambda p: len(p["body"]))
    print(f"\nPost piu' lungo (per corpo):")
    print(f"  ID: {piu_lungo['id']}")
    print(f"  Lunghezza: {len(piu_lungo['body'])} caratteri")
    print(f"  Titolo: {piu_lungo['title']}")


if __name__ == "__main__":
    main()
