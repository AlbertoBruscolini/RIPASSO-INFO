# Guida Completa — Python e le API REST

> Basata sul materiale di [angelogalantiscuola/IT](https://github.com/angelogalantiscuola/IT) e [angelogalantiscuola/2526_5M](https://github.com/angelogalantiscuola/2526_5M)

---

## Indice

1. [Cos'è una API?](#1-cosè-una-api)
2. [HTTP — Il Protocollo del Web](#2-http--il-protocollo-del-web)
3. [REST — Lo Stile Architetturale](#3-rest--lo-stile-architetturale)
4. [JSON — Il Formato dei Dati](#4-json--il-formato-dei-dati)
5. [La Libreria `requests`](#5-la-libreria-requests)
6. [GET — Leggere Dati](#6-get--leggere-dati)
7. [POST — Creare Dati](#7-post--creare-dati)
8. [PUT — Aggiornare Dati](#8-put--aggiornare-dati)
9. [DELETE — Eliminare Dati](#9-delete--eliminare-dati)
10. [Gestione degli Errori](#10-gestione-degli-errori)
11. [Query Parameters e Headers](#11-query-parameters-e-headers)
12. [API di Test: JSONPlaceholder](#12-api-di-test-jsonplaceholder)
13. [Struttura Consigliata di uno Script API](#13-struttura-consigliata-di-uno-script-api)

---

## 1. Cos'è una API?

**API** (Application Programming Interface) è un insieme di regole che permette a due programmi di comunicare tra loro.

Una **Web API** (o HTTP API) permette a un programma di richiedere dati o servizi a un server remoto via Internet.

### Analogia

Immagina di essere al ristorante:
- Tu sei il **client** (il programma Python)
- Il cameriere è la **API** (l'interfaccia)
- La cucina è il **server** (il database/backend)

Tu fai un'**ordine** (richiesta HTTP) → il cameriere la porta in cucina → ti porta il **piatto** (risposta JSON).

### Perché usare le API?

- Accedere a dati di terze parti (meteo, mappe, social network)
- Comunicare tra frontend e backend
- Integrare servizi diversi (pagamenti, notifiche, ecc.)

---

## 2. HTTP — Il Protocollo del Web

**HTTP** (HyperText Transfer Protocol) è il protocollo che definisce come client e server si scambiano messaggi.

### Caratteristica fondamentale: Stateless

Ogni richiesta HTTP è **indipendente** dalle precedenti. Il server non ricorda le richieste passate. Questo significa che ogni richiesta deve contenere tutte le informazioni necessarie.

### I Metodi HTTP

| Metodo | Significato | Uso tipico |
|---|---|---|
| `GET` | Leggi/recupera dati | Ottenere una lista, un singolo elemento |
| `POST` | Crea un nuovo dato | Creare un utente, inviare un form |
| `PUT` | Sostituisci completamente | Aggiornare tutto l'oggetto |
| `PATCH` | Modifica parziale | Aggiornare solo un campo |
| `DELETE` | Elimina | Cancellare una risorsa |

### I Codici di Stato HTTP

```
2xx → Successo
    200 OK               - richiesta riuscita
    201 Created          - risorsa creata con successo
    204 No Content       - successo ma nessun dato da restituire

3xx → Reindirizzamento
    301 Moved Permanently - l'URL è cambiato definitivamente
    302 Found             - reindirizzamento temporaneo

4xx → Errore del Client
    400 Bad Request       - richiesta malformata
    401 Unauthorized      - autenticazione richiesta
    403 Forbidden         - non hai i permessi
    404 Not Found         - risorsa non trovata
    422 Unprocessable     - dati validi ma logicamente errati

5xx → Errore del Server
    500 Internal Server Error - errore generico del server
    503 Service Unavailable   - server temporaneamente offline
```

### Struttura di una Richiesta HTTP

```
GET /posts/1 HTTP/1.1
Host: jsonplaceholder.typicode.com
Accept: application/json
Authorization: Bearer il-mio-token
```

### Struttura di una Risposta HTTP

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "title": "Titolo del post",
  "body": "Contenuto del post",
  "userId": 1
}
```

---

## 3. REST — Lo Stile Architetturale

**REST** (REpresentational State Transfer) è uno stile architetturale per progettare API web.

### Principi REST

1. **Client-Server**: client e server sono separati e indipendenti
2. **Stateless**: ogni richiesta è auto-contenuta
3. **Cacheable**: le risposte possono essere messe in cache
4. **Uniform Interface**: interfaccia uniforme basata su risorse

### URL RESTful: le risorse sono sostantivi

```
✅ REST corretto           ❌ NON REST
/utenti                   /getUtenti
/utenti/42                /getUtenteById?id=42
/utenti/42/posts          /getPostsUtente?userId=42
/prodotti                 /creaProdotto
```

### CRUD → HTTP Mapping

| Operazione | HTTP Method | URL | Descrizione |
|---|---|---|---|
| Read all | `GET` | `/utenti` | Lista di tutti gli utenti |
| Read one | `GET` | `/utenti/42` | Un utente specifico |
| Create | `POST` | `/utenti` | Crea un nuovo utente |
| Update all | `PUT` | `/utenti/42` | Sostituisce l'utente 42 |
| Update partial | `PATCH` | `/utenti/42` | Modifica campi dell'utente 42 |
| Delete | `DELETE` | `/utenti/42` | Elimina l'utente 42 |

---

## 4. JSON — Il Formato dei Dati

**JSON** (JavaScript Object Notation) è il formato standard per lo scambio di dati nelle API REST.

### Struttura JSON

```json
{
  "id": 1,
  "nome": "Mario",
  "cognome": "Rossi",
  "attivo": true,
  "punteggio": 9.5,
  "indirizzo": null,
  "hobby": ["calcio", "lettura", "coding"],
  "contatti": {
    "email": "mario@example.com",
    "telefono": "333-123456"
  }
}
```

### Tipi di dato JSON

| JSON | Python |
|---|---|
| `"stringa"` | `str` |
| `42` | `int` |
| `3.14` | `float` |
| `true` / `false` | `True` / `False` |
| `null` | `None` |
| `[1, 2, 3]` | `list` |
| `{"chiave": "valore"}` | `dict` |

### Python ↔ JSON

```python
import json

# Da Python dict a JSON string
dato = {"nome": "Mario", "età": 25}
json_string = json.dumps(dato)
print(json_string)   # '{"nome": "Mario", "età": 25}'

# Da JSON string a Python dict
json_string = '{"nome": "Mario", "voto": 30}'
dato = json.loads(json_string)
print(dato["nome"])  # Mario
print(dato["voto"])  # 30
```

---

## 5. La Libreria `requests`

### Installazione

```bash
pip install requests
```

### Import

```python
import requests
```

### Il ciclo di vita di una richiesta

```
Python script
    │
    ▼
requests.get(url)     ← costruisce la richiesta HTTP
    │
    ▼
[Internet] → Server
    │
    ▼
response              ← oggetto Response di ritorno
    │
    ├── response.status_code   → 200, 404, 500, ...
    ├── response.headers       → intestazioni HTTP
    ├── response.text          → corpo come stringa
    └── response.json()        → corpo parsato come dict/list
```

---

## 6. GET — Leggere Dati

### 6.1 GET base

```python
import requests

url = "https://jsonplaceholder.typicode.com/posts/1"
response = requests.get(url)

print(response.status_code)   # 200
print(response.json())        # dizionario Python
```

### 6.2 GET con controllo errori

```python
import requests

def get_post(post_id):
    url = f"https://jsonplaceholder.typicode.com/posts/{post_id}"
    
    response = requests.get(url)
    response.raise_for_status()   # lancia eccezione se status >= 400
    
    return response.json()

post = get_post(1)
print(f"Titolo: {post['title']}")
print(f"Autore (userId): {post['userId']}")
```

### 6.3 GET una lista

```python
import requests

def get_tutti_gli_utenti():
    url = "https://jsonplaceholder.typicode.com/users"
    response = requests.get(url)
    response.raise_for_status()
    
    utenti = response.json()   # lista di dizionari
    
    for utente in utenti:
        print(f"ID: {utente['id']} — {utente['name']} — {utente['email']}")
    
    return utenti

get_tutti_gli_utenti()
```

### 6.4 GET con query parameters

I query parameters filtrano i risultati lato server:

```python
import requests

# Metodo 1: nell'URL direttamente
url = "https://jsonplaceholder.typicode.com/posts?userId=1"
response = requests.get(url)

# Metodo 2: dizionario params (consigliato — gestisce l'encoding automaticamente)
params = {"userId": 1}
response = requests.get(
    "https://jsonplaceholder.typicode.com/posts",
    params=params
)

posts = response.json()
print(f"Post di userId=1: {len(posts)}")
for p in posts:
    print(f"  [{p['id']}] {p['title']}")
```

---

## 7. POST — Creare Dati

```python
import requests

def crea_post(user_id, titolo, contenuto):
    url = "https://jsonplaceholder.typicode.com/posts"
    
    # I dati da inviare come body della richiesta
    nuovo_post = {
        "userId": user_id,
        "title":  titolo,
        "body":   contenuto
    }
    
    # Usiamo json= per inviare automaticamente in formato JSON
    # e impostare l'header Content-Type: application/json
    response = requests.post(url, json=nuovo_post)
    response.raise_for_status()
    
    post_creato = response.json()
    print(f"Post creato con ID: {post_creato['id']}")
    print(f"Titolo: {post_creato['title']}")
    
    return post_creato

crea_post(1, "Il mio primo post", "Questo è il contenuto del post")
```

**Output tipico:**
```
Post creato con ID: 101
Titolo: Il mio primo post
```

> **Nota:** JSONPlaceholder non salva davvero i dati, ma simula la risposta con un `id` fittizio.

---

## 8. PUT — Aggiornare Dati

`PUT` sostituisce **completamente** la risorsa (devi inviare tutti i campi).

```python
import requests

def aggiorna_todo(todo_id, user_id, titolo, completato):
    url = f"https://jsonplaceholder.typicode.com/todos/{todo_id}"
    
    todo_aggiornato = {
        "id":        todo_id,
        "userId":    user_id,
        "title":     titolo,
        "completed": completato
    }
    
    response = requests.put(url, json=todo_aggiornato)
    response.raise_for_status()
    
    risultato = response.json()
    stato = "completato" if risultato["completed"] else "non completato"
    print(f"Todo {todo_id} aggiornato → {risultato['title']} [{stato}]")
    
    return risultato

aggiorna_todo(1, 1, "Studiare Python", True)
```

---

## 9. DELETE — Eliminare Dati

```python
import requests

def elimina_commento(commento_id):
    url = f"https://jsonplaceholder.typicode.com/comments/{commento_id}"
    
    response = requests.delete(url)
    response.raise_for_status()
    
    # DELETE di solito restituisce 200 con {} oppure 204 No Content
    if response.status_code == 200:
        print(f"Commento {commento_id} eliminato con successo")
    elif response.status_code == 204:
        print(f"Commento {commento_id} eliminato (No Content)")
    
    return True

elimina_commento(5)
```

---

## 10. Gestione degli Errori

### 10.1 raise_for_status()

```python
response = requests.get(url)
response.raise_for_status()   # lancia HTTPError se status >= 400
```

### 10.2 Gestione completa con try/except

```python
import requests

def fetch_data(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    
    except requests.exceptions.HTTPError as e:
        # Errore HTTP (4xx, 5xx)
        print(f"Errore HTTP {response.status_code}: {e}")
    
    except requests.exceptions.ConnectionError:
        # Nessuna connessione Internet
        print("Errore: impossibile connettersi al server")
    
    except requests.exceptions.Timeout:
        # Il server ha impiegato troppo tempo
        print("Errore: il server non ha risposto in tempo")
    
    except requests.exceptions.RequestException as e:
        # Qualsiasi altro errore requests
        print(f"Errore generico: {e}")
    
    return None   # nessun dato da restituire in caso di errore
```

### 10.3 Controllare il codice di stato manualmente

```python
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
elif response.status_code == 404:
    print("Risorsa non trovata")
elif response.status_code == 401:
    print("Autenticazione richiesta")
else:
    print(f"Errore: {response.status_code}")
```

---

## 11. Query Parameters e Headers

### Query Parameters

Parametri aggiuntivi nell'URL per filtrare o configurare la richiesta:

```python
import requests

# Filtrare per userId
params = {
    "userId": 1,
    "_limit": 5    # alcuni servizi supportano _limit, _page
}
response = requests.get(
    "https://jsonplaceholder.typicode.com/posts",
    params=params
)
# URL risultante: .../posts?userId=1&_limit=5
print(response.url)   # mostra l'URL completo costruito
```

### Headers

Metadati della richiesta (autenticazione, formato, ecc.):

```python
headers = {
    "Authorization": "Bearer il-mio-token-segreto",
    "Content-Type":  "application/json",
    "Accept":        "application/json"
}

response = requests.get(url, headers=headers)
```

### Timeout

Sempre impostare un timeout per evitare che il programma si blocchi:

```python
response = requests.get(url, timeout=10)  # 10 secondi
```

---

## 12. API di Test: JSONPlaceholder

[JSONPlaceholder](https://jsonplaceholder.typicode.com) è un'API gratuita per fare pratica.

### Endpoint disponibili

| Endpoint | Dati |
|---|---|
| `/posts` | 100 post |
| `/comments` | 500 commenti |
| `/albums` | 100 album |
| `/photos` | 5000 foto |
| `/todos` | 200 todo |
| `/users` | 10 utenti |

### Relazioni tra risorse

```
/posts?userId=1          → post dell'utente 1
/posts/1/comments        → commenti del post 1
/albums?userId=1         → album dell'utente 1
/photos?albumId=1        → foto dell'album 1
/todos?userId=1          → todo dell'utente 1
```

### Esempio completo — post + commenti

```python
import requests

def mostra_post_con_commenti(user_id):
    # 1. Recupera i post dell'utente
    posts_response = requests.get(
        "https://jsonplaceholder.typicode.com/posts",
        params={"userId": user_id}
    )
    posts_response.raise_for_status()
    posts = posts_response.json()
    
    print(f"Post dell'utente {user_id}: {len(posts)} trovati")
    
    for post in posts[:3]:   # solo i primi 3
        print(f"\n--- Post [{post['id']}]: {post['title'][:40]}...")
        
        # 2. Recupera i commenti di quel post
        commenti_response = requests.get(
            f"https://jsonplaceholder.typicode.com/posts/{post['id']}/comments"
        )
        commenti_response.raise_for_status()
        commenti = commenti_response.json()
        
        print(f"    Commenti: {len(commenti)}")
        for c in commenti[:2]:
            print(f"    - {c['name'][:40]} ({c['email']})")

mostra_post_con_commenti(1)
```

---

## 13. Struttura Consigliata di uno Script API

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"


def get_todos_utente(user_id):
    """Recupera tutti i todos di un utente."""
    try:
        response = requests.get(
            f"{BASE_URL}/todos",
            params={"userId": user_id},
            timeout=10
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nel recupero todos: {e}")
        return []


def trova_primo_incompleto(todos):
    """Trova il primo todo non completato."""
    for todo in todos:
        if not todo["completed"]:
            return todo
    return None


def segna_come_completato(todo):
    """Aggiorna un todo come completato."""
    try:
        todo_aggiornato = {**todo, "completed": True}
        response = requests.put(
            f"{BASE_URL}/todos/{todo['id']}",
            json=todo_aggiornato,
            timeout=10
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Errore nell'aggiornamento: {e}")
        return None


def main():
    user_id = 1
    print(f"=== Todo Manager per utente {user_id} ===\n")
    
    todos = get_todos_utente(user_id)
    if not todos:
        print("Nessun todo trovato")
        return
    
    completati = sum(1 for t in todos if t["completed"])
    incompleti  = len(todos) - completati
    
    print(f"Totale todos  : {len(todos)}")
    print(f"Completati    : {completati}")
    print(f"Non completati: {incompleti}")
    
    primo_incompleto = trova_primo_incompleto(todos)
    
    if primo_incompleto:
        print(f"\nPrimo todo incompleto: [{primo_incompleto['id']}] {primo_incompleto['title']}")
        risultato = segna_come_completato(primo_incompleto)
        if risultato and risultato["completed"]:
            print("✓ Segnato come completato!")
    else:
        print("\nTutti i todos sono già completati!")


if __name__ == "__main__":
    main()
```

---

*Fine Guida Python API — per gli esercizi vedi `06_ESERCIZI_PYTHON_API.md`*
