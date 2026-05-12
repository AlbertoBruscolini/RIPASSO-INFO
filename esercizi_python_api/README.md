# Esercizi Python — API REST

20 file `.py` ordinati per difficoltà, basati su [JSONPlaceholder](https://jsonplaceholder.typicode.com) (API pubblica gratuita).

## Prerequisiti

```bash
pip install requests
```

## Come eseguirli

```bash
python es01_get_singolo.py
python es02_get_lista.py
# ...
```

## Indice

### Sezione A — GET base
| # | File | Argomento | Livello |
|---|---|---|---|
| 01 | `es01_get_singolo.py` | Prima richiesta GET | ⭐ |
| 02 | `es02_get_lista.py` | Lista di risorse + raise_for_status | ⭐ |
| 03 | `es03_query_params.py` | Query parameters con `params=` | ⭐ |

### Sezione B — POST, PUT, DELETE
| 04 | `es04_post_crea.py` | POST per creare una risorsa | ⭐⭐ |
| 05 | `es05_put_aggiorna.py` | PUT per aggiornare | ⭐⭐ |
| 06 | `es06_delete.py` | DELETE per eliminare | ⭐⭐ |

### Sezione C — Gestione errori
| 07 | `es07_gestione_errori.py` | HTTPError, ConnectionError, Timeout | ⭐⭐ |
| 18 | `es18_retry_e_timeout.py` | Retry con backoff esponenziale | ⭐⭐⭐ |

### Sezione D — Esercizi dal repository
| 08 | `es08_posts_e_commenti.py` | (es09 del repo) Post + Commenti + Crea | ⭐⭐ |
| 09 | `es09_todo_manager.py` | (es10 del repo) GET + PUT su todos | ⭐⭐ |
| 10 | `es10_azione_condizionale.py` | (es11 del repo) POST/DELETE condizionale | ⭐⭐⭐ |
| 19 | `es19_biblioteca_completa.py` | (es12 del repo) Filtri su biblioteca | ⭐⭐ |

### Sezione E — Integrazioni e progetti
| 11 | `es11_api_in_database.py` | Salva API in SQLite | ⭐⭐⭐ |
| 12 | `es12_statistiche_post.py` | Statistiche aggregate sui post | ⭐⭐ |
| 13 | `es13_input_interattivo.py` | Menu CLI interattivo | ⭐⭐ |
| 14 | `es14_filtri_e_ricerca.py` | Ricerca testuale sui post | ⭐⭐ |
| 15 | `es15_album_e_foto.py` | Endpoint multipli (albums + photos) | ⭐⭐ |
| 16 | `es16_export_json_csv.py` | Esporta dati in JSON e CSV | ⭐⭐ |
| 17 | `es17_classe_client.py` | Riorganizzazione OOP (classe Client) | ⭐⭐⭐ |
| 20 | `es20_dashboard_completo.py` | Dashboard utente multi-endpoint | ⭐⭐⭐ |

## Ordine consigliato di studio

1. **Basi GET**: 01 → 02 → 03
2. **CRUD completo**: 04 → 05 → 06
3. **Errori e robustezza**: 07 → 18
4. **Esercizi del repo**: 08 → 09 → 10 → 19
5. **Progetti integrati**: 12 → 13 → 14 → 15 → 16
6. **Persistenza e OO**: 11 → 17 → 20

## Endpoint usati

| Endpoint | Risorse |
|---|---|
| `/posts` | 100 post |
| `/comments` | 500 commenti |
| `/albums` | 100 album |
| `/photos` | 5000 foto |
| `/todos` | 200 todo |
| `/users` | 10 utenti |

## Domanda di teoria

- `GET` recupera, `POST` crea, `PUT` sostituisce, `PATCH` modifica, `DELETE` elimina
- `200 OK`, `201 Created`, `404 Not Found`, `500 Internal Server Error`
- **Stateless**: ogni richiesta è indipendente dalle altre
- `response.raise_for_status()` lancia eccezione se status >= 400
- `response.json()` → dict/list Python
- Sempre usare `timeout=10` per evitare blocchi infiniti
