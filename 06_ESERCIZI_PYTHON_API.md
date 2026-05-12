# Esercizi — Python e le API REST

> Basati sul materiale di [angelogalantiscuola/2526_5M](https://github.com/angelogalantiscuola/2526_5M)  
> Per la teoria consulta `03_GUIDA_PYTHON_API.md`

---

## Prerequisiti

```bash
pip install requests
```

**API di test:** [JSONPlaceholder](https://jsonplaceholder.typicode.com) — gratuita, no account, no chiavi.

---

## SEZIONE A — GET Base

### Esercizio A1 — Prima richiesta GET ⭐

**Obiettivo:** Recupera e stampa il post con id=1

**Guida:**
1. Importa `requests`
2. Definisci l'URL: `https://jsonplaceholder.typicode.com/posts/1`
3. Fai la richiesta con `requests.get()`
4. Stampa lo status code e il contenuto JSON

```python
# Scrivi qui la tua soluzione
```

**Soluzione:**
```python
import requests

url = "https://jsonplaceholder.typicode.com/posts/1"
response = requests.get(url)

print(f"Status code: {response.status_code}")

post = response.json()
print(f"ID: {post['id']}")
print(f"Titolo: {post['title']}")
print(f"Autore (userId): {post['userId']}")
print(f"Corpo: {post['body'][:50]}...")
```

**Output atteso:**
```
Status code: 200
ID: 1
Titolo: sunt aut facere repellat provident occaecati...
Autore (userId): 1
Corpo: quia et suscipit suscipit recusandae consequuntur...
```

---

### Esercizio A2 — Lista di risorse ⭐

**Obiettivo:** Recupera tutti gli utenti e stampa id, nome ed email di ciascuno

**Soluzione:**
```python
import requests

response = requests.get("https://jsonplaceholder.typicode.com/users")
response.raise_for_status()

utenti = response.json()
print(f"Totale utenti: {len(utenti)}\n")

for utente in utenti:
    print(f"[{utente['id']}] {utente['name']} — {utente['email']}")
```

---

### Esercizio A3 — Risorsa singola con input ⭐

**Obiettivo:** Chiedi all'utente un ID di post (tra 1 e 100) e mostra titolo e corpo

**Soluzione:**
```python
import requests

post_id = int(input("Inserisci l'ID del post (1-100): "))

url = f"https://jsonplaceholder.typicode.com/posts/{post_id}"
response = requests.get(url)

if response.status_code == 200:
    post = response.json()
    print(f"\nTitolo: {post['title']}")
    print(f"Corpo:\n{post['body']}")
elif response.status_code == 404:
    print("Post non trovato")
else:
    print(f"Errore: {response.status_code}")
```

---

### Esercizio A4 — GET con query parameters ⭐⭐

**Obiettivo:** Recupera tutti i post dell'utente con ID 1 e stampali

**Guida:**
- Endpoint: `https://jsonplaceholder.typicode.com/posts`
- Parametro: `userId=1`
- Usa il dizionario `params={"userId": 1}`

**Soluzione:**
```python
import requests

params   = {"userId": 1}
response = requests.get(
    "https://jsonplaceholder.typicode.com/posts",
    params=params
)
response.raise_for_status()

posts = response.json()
print(f"Post dell'utente 1: {len(posts)} trovati\n")

for post in posts:
    print(f"[{post['id']}] {post['title']}")
```

---

## SEZIONE B — POST, PUT, DELETE

### Esercizio B1 — POST: creare una risorsa ⭐⭐

**Obiettivo:** Crea un nuovo post con titolo e corpo a scelta

**Guida:**
1. Crea un dizionario con i dati del post
2. Usa `requests.post(url, json=dati)`
3. Controlla la risposta: deve avere status 201

**Soluzione:**
```python
import requests

url = "https://jsonplaceholder.typicode.com/posts"

nuovo_post = {
    "userId": 1,
    "title":  "Il mio primo post via API",
    "body":   "Questo post è stato creato con Python e requests!"
}

response = requests.post(url, json=nuovo_post)
response.raise_for_status()

print(f"Status code: {response.status_code}")   # 201 Created

post_creato = response.json()
print(f"ID assegnato: {post_creato['id']}")
print(f"Titolo: {post_creato['title']}")
```

---

### Esercizio B2 — PUT: aggiornare completamente ⭐⭐

**Obiettivo:** Dal repository `2526_5M/python-api-exercises/es10_testo.md`  
Recupera i todos dell'utente 1, trova il primo non completato, aggiornalo come completato con PUT

**Soluzione:**
```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

# 1. Recupera tutti i todos
response = requests.get(f"{BASE_URL}/todos", params={"userId": 1})
response.raise_for_status()
todos = response.json()

# 2. Statistiche
completati = sum(1 for t in todos if t["completed"])
incompleti  = len(todos) - completati

print(f"Totale todos  : {len(todos)}")
print(f"Completati    : {completati}")
print(f"Non completati: {incompleti}\n")

# 3. Trova il primo incompleto
primo_incompleto = None
for todo in todos:
    if not todo["completed"]:
        primo_incompleto = todo
        break

if primo_incompleto is None:
    print("Tutti i todos sono già completati!")
else:
    print(f"Primo incompleto: [{primo_incompleto['id']}] {primo_incompleto['title']}")
    
    # 4. Aggiornalo con PUT
    todo_aggiornato = {**primo_incompleto, "completed": True}
    
    put_response = requests.put(
        f"{BASE_URL}/todos/{primo_incompleto['id']}",
        json=todo_aggiornato
    )
    put_response.raise_for_status()
    
    risultato = put_response.json()
    stato = "completato" if risultato["completed"] else "non completato"
    print(f"Todo aggiornato → {risultato['title']} [{stato}]")
```

---

### Esercizio B3 — DELETE: eliminare una risorsa ⭐⭐

**Obiettivo:** Elimina il commento con id=5 e conferma l'eliminazione

**Soluzione:**
```python
import requests

commento_id = 5
url = f"https://jsonplaceholder.typicode.com/comments/{commento_id}"

response = requests.delete(url)
response.raise_for_status()

print(f"Commento {commento_id} eliminato")
print(f"Status code: {response.status_code}")
print(f"Risposta: {response.json()}")   # {} su JSONPlaceholder
```

---

## SEZIONE C — Esercizi dal Repository (es09 → es11)

### Esercizio C1 — es09: Post + Commenti + Nuovo Commento ⭐⭐

**Obiettivo:** Testo originale da `2526_5M/python-api-exercises/es09_testo.md`

1. Recupera tutti i post dell'utente 1 e stampali
2. Prendi il primo post e recupera i suoi commenti
3. Crea un nuovo commento per quel post via POST

**Soluzione:**
```python
import requests

BASE = "https://jsonplaceholder.typicode.com"

# 1. Recupera post dell'utente 1
print("=== Post dell'utente 1 ===")
posts_resp = requests.get(f"{BASE}/posts", params={"userId": 1})
posts_resp.raise_for_status()
posts = posts_resp.json()

for p in posts:
    print(f"  [{p['id']}] {p['title'][:50]}")

# 2. Commenti del primo post
primo_post = posts[0]
print(f"\n=== Commenti del post {primo_post['id']} ===")

commenti_resp = requests.get(f"{BASE}/posts/{primo_post['id']}/comments")
commenti_resp.raise_for_status()
commenti = commenti_resp.json()

for c in commenti:
    print(f"  [{c['id']}] {c['name'][:40]}")
    print(f"         Da: {c['email']}")

# 3. Crea un nuovo commento
print("\n=== Creazione nuovo commento ===")
nuovo_commento = {
    "postId": primo_post["id"],
    "name":   "Commento di Mario",
    "email":  "mario@scuola.it",
    "body":   "Ottimo post! Molto interessante."
}

post_resp = requests.post(f"{BASE}/comments", json=nuovo_commento)
post_resp.raise_for_status()

creato = post_resp.json()
print(f"Commento creato:")
print(f"  ID: {creato['id']}")
print(f"  Nome: {creato['name']}")
print(f"  Email: {creato['email']}")
print(f"  Corpo: {creato['body']}")
```

---

### Esercizio C2 — es11: Post con più commenti + azione condizionale ⭐⭐⭐

**Obiettivo:** Testo originale da `2526_5M/python-api-exercises/es11_testo.md`

1. Recupera i post dell'utente 1
2. Per ogni post, conta i commenti
3. Trova il post con più commenti
4. Se ha meno di 5 commenti → crea un nuovo commento (POST)
5. Se ha 5 o più commenti → elimina il commento più vecchio (DELETE)

**Soluzione:**
```python
import requests

BASE = "https://jsonplaceholder.typicode.com"

def get_posts_utente(user_id):
    resp = requests.get(f"{BASE}/posts", params={"userId": user_id})
    resp.raise_for_status()
    return resp.json()

def get_commenti_post(post_id):
    resp = requests.get(f"{BASE}/posts/{post_id}/comments")
    resp.raise_for_status()
    return resp.json()

def crea_commento(post_id):
    payload = {
        "postId": post_id,
        "name":   "Nuovo commento automatico",
        "email":  "bot@scuola.it",
        "body":   "Commento aggiunto automaticamente"
    }
    resp = requests.post(f"{BASE}/comments", json=payload)
    resp.raise_for_status()
    return resp.json()

def elimina_commento(commento_id):
    resp = requests.delete(f"{BASE}/comments/{commento_id}")
    resp.raise_for_status()
    return resp.status_code == 200

def main():
    print("=== Analisi post utente 1 ===\n")
    posts = get_posts_utente(1)
    
    # Per ogni post recupera il numero di commenti
    post_info = []
    for post in posts:
        commenti = get_commenti_post(post["id"])
        post_info.append({
            "post":     post,
            "commenti": commenti,
            "num":      len(commenti)
        })
        print(f"  Post [{post['id']}]: {len(commenti)} commenti — {post['title'][:40]}")
    
    # Trova il post con più commenti
    max_info = max(post_info, key=lambda x: x["num"])
    print(f"\nPost con più commenti: [{max_info['post']['id']}] con {max_info['num']} commenti")
    
    # Azione condizionale
    SOGLIA = 5
    if max_info["num"] < SOGLIA:
        print(f"Ha meno di {SOGLIA} commenti → Creo un nuovo commento")
        nuovo = crea_commento(max_info["post"]["id"])
        print(f"  Nuovo commento creato con id: {nuovo['id']}")
    else:
        print(f"Ha {max_info['num']} commenti (>= {SOGLIA}) → Elimino il più vecchio")
        commento_piu_vecchio = max_info["commenti"][0]   # il primo = il più vecchio
        eliminato = elimina_commento(commento_piu_vecchio["id"])
        if eliminato:
            print(f"  Commento {commento_piu_vecchio['id']} eliminato")

main()
```

---

## SEZIONE D — Gestione Errori

### Esercizio D1 — Gestione errore 404 ⭐⭐

**Obiettivo:** Prova a recuperare un post inesistente (id=9999) e gestisci l'errore correttamente

**Soluzione:**
```python
import requests

def get_post_sicuro(post_id):
    try:
        url = f"https://jsonplaceholder.typicode.com/posts/{post_id}"
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    
    except requests.exceptions.HTTPError as e:
        if response.status_code == 404:
            print(f"Post {post_id} non trovato (404)")
        else:
            print(f"Errore HTTP {response.status_code}: {e}")
        return None
    
    except requests.exceptions.ConnectionError:
        print("Errore: nessuna connessione a Internet")
        return None
    
    except requests.exceptions.Timeout:
        print("Errore: il server non ha risposto entro 10 secondi")
        return None

# Test
post = get_post_sicuro(1)
if post:
    print(f"Post trovato: {post['title']}")

post_inesistente = get_post_sicuro(9999)
# Output: Post 9999 non trovato (404)
```

---

### Esercizio D2 — Funzione generica con retry ⭐⭐⭐

**Obiettivo:** Scrivi una funzione che riprova la richiesta fino a 3 volte in caso di errore

```python
import requests
import time

def richiesta_con_retry(url, metodo="GET", dati=None, tentativi=3):
    for tentativo in range(1, tentativi + 1):
        try:
            if metodo == "GET":
                response = requests.get(url, timeout=10)
            elif metodo == "POST":
                response = requests.post(url, json=dati, timeout=10)
            else:
                raise ValueError(f"Metodo {metodo} non supportato")
            
            response.raise_for_status()
            return response.json()
        
        except requests.exceptions.RequestException as e:
            print(f"Tentativo {tentativo}/{tentativi} fallito: {e}")
            if tentativo < tentativi:
                time.sleep(1)   # aspetta 1 secondo prima di riprovare
    
    print("Tutti i tentativi falliti")
    return None

# Test
dati = richiesta_con_retry("https://jsonplaceholder.typicode.com/users/1")
if dati:
    print(f"Utente: {dati['name']}")
```

---

## SEZIONE E — Esercizi Integrati (API + SQLite)

### Esercizio E1 — Scarica e salva nel database ⭐⭐⭐

**Obiettivo:** Recupera i 10 utenti da JSONPlaceholder e salvali in un database SQLite locale

```python
import requests
import sqlite3

def crea_db_utenti():
    conn   = sqlite3.connect("utenti_api.db")
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Utenti (
            id       INTEGER PRIMARY KEY,
            nome     TEXT NOT NULL,
            username TEXT NOT NULL,
            email    TEXT NOT NULL,
            citta    TEXT
        )
    """)
    conn.commit()
    conn.close()

def scarica_e_salva_utenti():
    # 1. Scarica dalla API
    response = requests.get("https://jsonplaceholder.typicode.com/users")
    response.raise_for_status()
    utenti = response.json()
    
    # 2. Salva nel database
    conn   = sqlite3.connect("utenti_api.db")
    cursor = conn.cursor()
    
    for u in utenti:
        cursor.execute("""
            INSERT OR REPLACE INTO Utenti (id, nome, username, email, citta)
            VALUES (?, ?, ?, ?, ?)
        """, (
            u["id"],
            u["name"],
            u["username"],
            u["email"],
            u["address"]["city"]
        ))
    
    conn.commit()
    salvati = cursor.rowcount
    conn.close()
    
    print(f"{len(utenti)} utenti scaricati, {salvati} salvati nel database")

def leggi_utenti_db():
    conn   = sqlite3.connect("utenti_api.db")
    cursor = conn.cursor()
    cursor.execute("SELECT id, nome, email, citta FROM Utenti ORDER BY nome")
    utenti = cursor.fetchall()
    conn.close()
    return utenti

if __name__ == "__main__":
    crea_db_utenti()
    scarica_e_salva_utenti()
    
    print("\n=== Utenti nel database ===")
    for uid, nome, email, citta in leggi_utenti_db():
        print(f"[{uid}] {nome} — {email} ({citta})")
```

---

### Esercizio E2 — Analisi post per utente ⭐⭐⭐

**Obiettivo:** Per ogni utente recuperato, conta i suoi post e salva le statistiche

```python
import requests
import sqlite3

BASE = "https://jsonplaceholder.typicode.com"

def analisi_post_per_utente():
    # Recupera utenti
    utenti = requests.get(f"{BASE}/users").json()
    # Recupera tutti i post
    posts  = requests.get(f"{BASE}/posts").json()
    
    # Conta post per userId
    conteggio = {}
    for post in posts:
        uid = post["userId"]
        conteggio[uid] = conteggio.get(uid, 0) + 1
    
    # Stampa risultati
    print(f"{'Nome':<30} {'Post':>6}")
    print("-" * 38)
    
    # Ordina per numero di post (decrescente)
    utenti_ordinati = sorted(
        utenti,
        key=lambda u: conteggio.get(u["id"], 0),
        reverse=True
    )
    
    for u in utenti_ordinati:
        num_post = conteggio.get(u["id"], 0)
        print(f"{u['name']:<30} {num_post:>6}")

analisi_post_per_utente()
```

---

### Esercizio E3 — Todo Manager Completo ⭐⭐⭐

**Obiettivo:** Script completo per gestire i todos di un utente  
(Basato su `es10_testo.md` del repository)

```python
import requests

BASE = "https://jsonplaceholder.typicode.com"

def get_todos(user_id):
    try:
        resp = requests.get(f"{BASE}/todos", params={"userId": user_id}, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nel recupero todos: {e}")
        return []

def completa_todo(todo):
    try:
        aggiornato = {**todo, "completed": True}
        resp = requests.put(f"{BASE}/todos/{todo['id']}", json=aggiornato, timeout=10)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nell'aggiornamento: {e}")
        return None

def stampa_todo(todo):
    stato = "✓" if todo["completed"] else "✗"
    print(f"  [{stato}] ({todo['id']:3d}) {todo['title'][:50]}")

def main():
    user_id = 1
    print(f"=== Todo Manager — Utente {user_id} ===\n")
    
    todos = get_todos(user_id)
    if not todos:
        return
    
    completati = [t for t in todos if t["completed"]]
    incompleti  = [t for t in todos if not t["completed"]]
    
    print(f"Totale     : {len(todos)}")
    print(f"Completati : {len(completati)}")
    print(f"Incompleti : {len(incompleti)}\n")
    
    if incompleti:
        print("Todos non completati:")
        for t in incompleti[:5]:
            stampa_todo(t)
        
        primo = incompleti[0]
        print(f"\nCompleto il primo: [{primo['id']}] {primo['title']}")
        risultato = completa_todo(primo)
        if risultato and risultato["completed"]:
            print("  Aggiornato con successo!")
    else:
        print("Tutti i todos sono completati!")

main()
```

---

## SEZIONE F — Domande di Teoria

### Quiz sulla teoria delle API

**1.** Qual è la differenza tra `GET` e `POST`?
> `GET` recupera dati (nessun corpo nella richiesta). `POST` crea dati (invia un corpo JSON). `GET` è idempotente: chiamarlo più volte non cambia lo stato del server.

**2.** Cosa significa status code `404`?
> "Not Found" — la risorsa richiesta non esiste sul server.

**3.** Perché usare `params={"userId": 1}` invece di costruire l'URL manualmente?
> `requests` gestisce automaticamente l'encoding dei caratteri speciali (spazi, accenti, ecc.) e rende il codice più leggibile e manutenibile.

**4.** Cosa fa `response.raise_for_status()`?
> Se lo status code è >= 400 (errore client o server), lancia un'eccezione `HTTPError`. Se è 2xx, non fa nulla. Permette di gestire gli errori con `try/except`.

**5.** Qual è la differenza tra `PUT` e `PATCH`?
> `PUT` sostituisce l'intero oggetto (devi inviare tutti i campi). `PATCH` aggiorna solo i campi specificati nel body.

**6.** Perché HTTP è "stateless"?
> Ogni richiesta è indipendente: il server non ricorda le richieste precedenti. Se hai bisogno di "memoria" (es. login), devi inviare un token di autenticazione in ogni richiesta.

**7.** Cos'è `response.json()`?
> Converte il corpo della risposta (stringa JSON) in un dizionario o lista Python. Equivale a `json.loads(response.text)`.

**8.** Cosa succede se chiami `requests.get()` senza `timeout=...`?
> La richiesta potrebbe bloccarsi indefinitamente se il server non risponde. È sempre buona pratica impostare un timeout (es. `timeout=10`).

---

## Riepilogo Metodi HTTP

| Metodo | requests | URL tipico | Body? | Idempotente? |
|---|---|---|---|---|
| GET | `requests.get(url)` | `/posts/1` | No | Sì |
| POST | `requests.post(url, json=dati)` | `/posts` | Sì | No |
| PUT | `requests.put(url, json=dati)` | `/posts/1` | Sì | Sì |
| PATCH | `requests.patch(url, json=dati)` | `/posts/1` | Sì | No |
| DELETE | `requests.delete(url)` | `/posts/1` | No | Sì |

---

*Fine Esercizi Python API — vedi anche `04_ESERCIZI_MERMAID.md` e `05_ESERCIZI_SQL_SQLITE3.md`*
