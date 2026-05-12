"""
============================================================
ESERCIZIO 20 — Dashboard completo dell'utente
============================================================
TESTO:
Crea un report COMPLETO per un utente:
1. Anagrafica (nome, email, citta, telefono, azienda)
2. Numero post pubblicati
3. Numero album posseduti + numero foto totali
4. Numero todo (totali, completati, percentuale)

Esegue molte richieste parallele (concettualmente in sequenza).
============================================================
"""

import requests


BASE = "https://jsonplaceholder.typicode.com"


# === FUNZIONI HELPER (ciascuna fa una richiesta API specifica) ===

def get_user(user_id: int) -> dict | None:
    """Recupera l'anagrafica di un utente."""
    r = requests.get(f"{BASE}/users/{user_id}", timeout=10)
    # Caso speciale: utente inesistente → 404 → restituiamo None.
    if r.status_code == 404:
        return None
    r.raise_for_status()
    return r.json()


def count_resource(resource: str, user_id: int) -> int:
    """Conta gli elementi di una collezione filtrata per userId.

    `resource` è il nome dell'endpoint (es. "posts", "albums").
    Restituisce solo il NUMERO di elementi, non la lista.
    """
    r = requests.get(f"{BASE}/{resource}", params={"userId": user_id}, timeout=10)
    r.raise_for_status()
    return len(r.json())   # len() conta gli elementi della lista


def get_todos(user_id: int) -> list:
    """Recupera tutti i todos di un utente (intera lista)."""
    r = requests.get(f"{BASE}/todos", params={"userId": user_id}, timeout=10)
    r.raise_for_status()
    return r.json()


def count_photos(user_id: int) -> int:
    """Conta tutte le foto di tutti gli album dell'utente.

    Strategia:
    1. Ottieni la lista di album dell'utente
    2. Per ogni album, conta le sue foto
    3. Somma tutti i conteggi
    """
    # Step 1: lista album.
    r = requests.get(f"{BASE}/albums", params={"userId": user_id}, timeout=10)
    r.raise_for_status()
    albums = r.json()

    # Step 2 + 3: ciclo che somma le foto.
    totale = 0
    for a in albums:
        # Una richiesta HTTP per ogni album (può essere lenta!).
        rp = requests.get(f"{BASE}/photos", params={"albumId": a["id"]}, timeout=10)
        rp.raise_for_status()
        # Aggiungiamo il numero di foto di questo album al totale.
        totale += len(rp.json())
    return totale


def dashboard(user_id: int) -> None:
    """Stampa il report completo per un utente."""
    # 1) Anagrafica
    user = get_user(user_id)
    # is None controlla esplicitamente che user sia None (vs lista vuota, 0, ecc.).
    if user is None:
        print(f"Utente {user_id} non trovato")
        return

    # 2) Conteggi base (post + album, ognuno una richiesta HTTP)
    n_posts  = count_resource("posts",  user_id)
    n_albums = count_resource("albums", user_id)

    # 3) Todos: serve la lista intera per calcolare la percentuale di completamento
    todos = get_todos(user_id)
    n_todos     = len(todos)
    # Conta quanti todos sono completati (somma di 1 per ogni todo con completed=True).
    n_completed = sum(1 for t in todos if t["completed"])
    # Calcoliamo la percentuale.
    # ATTENZIONE: dividere per 0 lancia ZeroDivisionError → controllo if/else.
    # `(if n_todos else 0)` → se n_todos è 0/falsy, usa 0 per evitare errore.
    percentuale = (n_completed / n_todos * 100) if n_todos else 0

    # 4) Foto totali (richiesta più costosa: molte chiamate HTTP).
    n_photos = count_photos(user_id)

    # === STAMPA DEL REPORT ===
    # "=" * 60 → ripete il carattere "=" 60 volte (linea separatrice).
    print("=" * 60)
    print(f"     DASHBOARD UTENTE {user_id}")
    print("=" * 60)
    print(f"Nome:     {user['name']}")
    print(f"Username: {user['username']}")
    print(f"Email:    {user['email']}")
    print(f"Telefono: {user['phone']}")
    # Accessi annidati al dict (address contiene city; company contiene name).
    print(f"Citta:    {user['address']['city']}")
    print(f"Azienda:  {user['company']['name']}")
    print("-" * 60)
    print(f"Post pubblicati: {n_posts}")
    print(f"Album:           {n_albums}")
    print(f"Foto totali:     {n_photos}")
    # :.1f → 1 cifra decimale per la percentuale.
    print(f"Todo:            {n_todos} (completati: {n_completed} -> {percentuale:.1f}%)")
    print("=" * 60)


def main() -> None:
    # Esempio: genera la dashboard dell'utente 1.
    # Prova a cambiare il numero per altri utenti (1-10).
    dashboard(1)


if __name__ == "__main__":
    main()
