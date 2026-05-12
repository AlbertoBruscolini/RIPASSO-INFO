"""
============================================================
ESERCIZIO 14 — Filtri e Ricerca
============================================================
TESTO:
1. Scarica tutti i post
2. Cerca tutti i post che contengono una parola chiave
   nel titolo o nel corpo (case-insensitive)
3. Stampa i risultati ordinati per id
============================================================
"""

import requests


def cerca_post(keyword: str) -> list:
    """Cerca la keyword nei titoli o corpi di tutti i post."""
    # Scarichiamo TUTTI i post (l'API restituisce 100 elementi).
    r = requests.get("https://jsonplaceholder.typicode.com/posts", timeout=10)
    r.raise_for_status()
    posts = r.json()

    # Convertiamo la keyword in minuscolo una sola volta (ottimizzazione).
    # Poi confrontiamo SEMPRE minuscolo con minuscolo → case-insensitive.
    keyword_lower = keyword.lower()

    # Lista che accumulerà i post che corrispondono.
    risultati = []
    for p in posts:
        # `in` su una stringa: True se la sottostringa è contenuta.
        # Es: "hello" in "hello world" → True
        if (keyword_lower in p["title"].lower() or
            keyword_lower in p["body"].lower()):
            # Se troviamo la keyword in titolo OPPURE corpo, aggiungiamo.
            risultati.append(p)
    return risultati


def main() -> None:
    # Chiede all'utente la parola da cercare.
    # .strip() rimuove gli spazi (importante perché " ciao " ≠ "ciao").
    keyword = input("Inserisci una parola da cercare: ").strip()

    # Gestione input vuoto.
    if not keyword:
        print("Parola vuota, esco")
        return

    # Chiamata della funzione di ricerca.
    risultati = cerca_post(keyword)

    print(f"\nTrovati {len(risultati)} post che contengono '{keyword}':\n")

    # Mostriamo solo i primi 20 risultati (slicing della lista).
    # lista[:20] → primi 20 elementi (o tutti se sono meno).
    for p in risultati[:20]:
        print(f"[{p['id']:3d}] {p['title'][:60]}")

    # Se ci sono più di 20 risultati, informiamo l'utente.
    if len(risultati) > 20:
        print(f"\n... e altri {len(risultati) - 20} risultati.")


if __name__ == "__main__":
    main()
