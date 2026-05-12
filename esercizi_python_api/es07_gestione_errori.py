"""
============================================================
ESERCIZIO 07 — Gestione completa degli errori
============================================================
TESTO:
Implementa una funzione che gestisca tutti i possibili
errori della libreria requests:
- HTTPError (4xx, 5xx)
- ConnectionError (nessuna rete)
- Timeout
- RequestException (catch-all)

Testa la funzione su:
- Una risorsa esistente (status 200)
- Una risorsa inesistente (status 404)
============================================================
"""

import requests
# Optional[dict] = "un dict oppure None" (sintassi vecchia, equivalente a `dict | None`).
from typing import Optional


# Funzione che fa una GET e gestisce TUTTI gli errori possibili.
def fetch_safe(url: str) -> Optional[dict]:
    """Esegue una GET gestendo tutti gli errori possibili."""
    try:
        # Tentiamo la richiesta GET.
        response = requests.get(url, timeout=10)
        # Se status >= 400, raise_for_status lancia HTTPError.
        response.raise_for_status()
        # Successo: parsiamo il body JSON e restituiamo il dict.
        return response.json()

    # Cattura 1: HTTPError (status code 4xx o 5xx).
    # L'oggetto eccezione `e` contiene `e.response` con tutti i dettagli.
    except requests.exceptions.HTTPError as e:
        # Estraiamo il codice di stato dalla risposta che ha causato l'errore.
        codice = e.response.status_code
        # Gestione personalizzata in base allo status code.
        if codice == 404:
            print(f"[404] Risorsa non trovata: {url}")
        elif codice == 401:
            # 401 = mancano credenziali di autenticazione
            print(f"[401] Non autorizzato")
        elif codice == 500:
            # 500 = errore generico sul server (non colpa nostra)
            print(f"[500] Errore del server")
        else:
            print(f"[{codice}] Errore HTTP: {e}")

    # Cattura 2: nessuna connessione Internet, DNS non funziona, ecc.
    except requests.exceptions.ConnectionError:
        print("[ERRORE] Nessuna connessione a Internet")

    # Cattura 3: il server non ha risposto entro il timeout (10 secondi).
    except requests.exceptions.Timeout:
        print("[ERRORE] Timeout: il server non ha risposto")

    # Cattura 4 (catch-all): qualsiasi altro errore di requests.
    # Deve essere ULTIMA perché RequestException è la classe padre delle altre.
    except requests.exceptions.RequestException as e:
        print(f"[ERRORE] Errore generico: {e}")

    # Se siamo qui, c'è stato un errore: restituiamo None.
    return None


def main() -> None:
    # === TEST 1: risorsa esistente (status 200) ===
    print("=== Test 1: risorsa esistente ===")
    post = fetch_safe("https://jsonplaceholder.typicode.com/posts/1")
    # Controlliamo che post non sia None prima di usarlo (evita AttributeError).
    if post:
        print(f"Trovato: {post['title']}\n")

    # === TEST 2: risorsa inesistente (status 404) ===
    print("=== Test 2: risorsa inesistente ===")
    # id=9999 non esiste → il server risponde 404.
    post = fetch_safe("https://jsonplaceholder.typicode.com/posts/9999")
    print()

    # === TEST 3: dominio inesistente (ConnectionError) ===
    print("=== Test 3: dominio inesistente ===")
    # Il dominio ".invalid" è riservato e non risolve mai → ConnectionError.
    post = fetch_safe("https://dominio-che-non-esiste-12345.invalid/data")


if __name__ == "__main__":
    main()
