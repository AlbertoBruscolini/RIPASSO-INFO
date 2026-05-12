"""
============================================================
ESERCIZIO 18 — Retry automatico con backoff
============================================================
TESTO:
Implementa una funzione che, in caso di errore di rete,
riprova fino a 3 volte con attesa crescente (1s, 2s, 4s).
Questo si chiama "exponential backoff".
============================================================
"""

import requests
import time          # per time.sleep() (mette in pausa il programma)
from typing import Optional


def fetch_with_retry(url: str, max_tentativi: int = 3) -> Optional[dict]:
    """GET con retry esponenziale.

    - Tenta la richiesta fino a `max_tentativi` volte.
    - Attesa tra i tentativi: 1s, 2s, 4s (raddoppia ogni volta).
    - Se tutti i tentativi falliscono, restituisce None.
    """
    # `attesa` è il tempo di pausa prima del prossimo tentativo (in secondi).
    # Parte da 1 e raddoppia ogni volta (backoff esponenziale).
    attesa = 1

    # range(1, N+1) → 1, 2, 3 (incluso N, escluso N+1).
    # Iteriamo i tentativi numerati da 1 a max_tentativi.
    for tentativo in range(1, max_tentativi + 1):
        try:
            # Tentiamo la richiesta.
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            # Successo: usciamo subito dal loop e restituiamo i dati.
            return response.json()

        except requests.exceptions.RequestException as e:
            # Errore (rete, timeout, HTTPError, ...).
            print(f"  [Tentativo {tentativo}/{max_tentativi}] Errore: {e}")

            # Se non è l'ultimo tentativo, aspettiamo e riproviamo.
            if tentativo < max_tentativi:
                print(f"  Attendo {attesa} secondi...")
                # time.sleep(N) → mette in pausa l'esecuzione per N secondi.
                time.sleep(attesa)
                # Raddoppiamo l'attesa per il prossimo tentativo (backoff).
                # Es: 1 → 2 → 4 → 8 ...
                attesa *= 2

    # Se siamo qui, tutti i tentativi sono falliti.
    print(f"  Tutti i {max_tentativi} tentativi falliti")
    return None


def main() -> None:
    # TEST 1: URL valido → dovrebbe riuscire al primo tentativo.
    print("Test 1: URL valido")
    dati = fetch_with_retry("https://jsonplaceholder.typicode.com/posts/1")
    if dati:
        print(f"  OK -> Titolo: {dati['title'][:50]}\n")

    # TEST 2: URL inesistente → fallisce tutti i tentativi (con backoff).
    # Usiamo solo 2 tentativi per non aspettare troppo (1s + 2s = 3s totali).
    print("Test 2: URL non raggiungibile")
    dati = fetch_with_retry("https://server-finto-12345.invalid/data", max_tentativi=2)


if __name__ == "__main__":
    main()
