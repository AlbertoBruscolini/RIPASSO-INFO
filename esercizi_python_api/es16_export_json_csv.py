"""
============================================================
ESERCIZIO 16 — Esportare dati API in JSON e CSV
============================================================
TESTO:
1. Scarica tutti gli utenti da JSONPlaceholder
2. Salvali in un file JSON (utenti.json)
3. Salvali anche in CSV (utenti.csv) con colonne:
   id, nome, username, email, citta
============================================================
"""

import requests    # per la chiamata API
import json        # per scrivere file JSON
import csv         # per scrivere file CSV


def main() -> None:
    print("Scarico utenti...")
    r = requests.get("https://jsonplaceholder.typicode.com/users", timeout=10)
    r.raise_for_status()
    utenti = r.json()    # lista di dict

    # ====== SALVATAGGIO IN JSON ======
    # open(file, "w", ...) → apre il file in scrittura (sovrascrive se esiste).
    # encoding="utf-8" → supporta caratteri speciali (à, è, ù, ...).
    # `with` blocca → garantisce che il file venga chiuso anche in caso di errore.
    with open("utenti.json", "w", encoding="utf-8") as f:
        # json.dump(dati, file, ...) → scrive il JSON nel file.
        # indent=2 → formatta con 2 spazi di indentazione (più leggibile).
        # ensure_ascii=False → permette caratteri non-ASCII (accenti, ecc.).
        json.dump(utenti, f, indent=2, ensure_ascii=False)
    print(f"Salvati {len(utenti)} utenti in utenti.json")

    # ====== SALVATAGGIO IN CSV ======
    # newline="" → fondamentale su Windows per evitare righe vuote tra i record.
    with open("utenti.csv", "w", newline="", encoding="utf-8") as f:
        # csv.writer crea un oggetto per scrivere righe nel file.
        writer = csv.writer(f)
        # Prima riga: intestazione delle colonne.
        writer.writerow(["id", "nome", "username", "email", "citta"])
        # Una riga per ogni utente.
        for u in utenti:
            writer.writerow([
                u["id"],
                u["name"],
                u["username"],
                u["email"],
                u["address"]["city"]    # accesso annidato
            ])
    print(f"Salvati {len(utenti)} utenti in utenti.csv")

    # ====== VERIFICA: rileggiamo il CSV per controllare ======
    print("\nContenuto del CSV:")
    # "r" = read mode.
    with open("utenti.csv", "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for riga in reader:
            # Ogni `riga` è una lista di stringhe.
            # " | ".join(lista) → unisce gli elementi separandoli con " | ".
            print("  " + " | ".join(riga))


if __name__ == "__main__":
    main()
