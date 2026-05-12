# Esercizi SQL / SQLite3

20 file `.sql` ordinati per difficoltà.

## Come eseguirli

### Opzione 1: SQLite CLI
```bash
sqlite3 mydatabase.db < es01_setup_scuola.sql
sqlite3 mydatabase.db < es02_select_base.sql
```

### Opzione 2: Python
```python
import sqlite3
with open("es01_setup_scuola.sql", "r", encoding="utf-8") as f:
    sql = f.read()
conn = sqlite3.connect("mydatabase.db")
conn.executescript(sql)
conn.commit()
conn.close()
```

### Opzione 3: DB Browser for SQLite (GUI)
Scarica da [sqlitebrowser.org](https://sqlitebrowser.org) e apri il file `.sql`.

## Indice esercizi

### Sezione A — Database Scuola
| # | File | Argomento | Livello |
|---|---|---|---|
| 01 | `es01_setup_scuola.sql` | DDL + INSERT iniziale | ⭐ |
| 02 | `es02_select_base.sql` | SELECT, WHERE, IN, LIKE, BETWEEN | ⭐ |
| 03 | `es03_order_limit.sql` | ORDER BY, LIMIT, OFFSET | ⭐ |
| 04 | `es04_aggregati.sql` | COUNT, SUM, AVG, MAX, MIN | ⭐⭐ |
| 05 | `es05_group_by_having.sql` | GROUP BY e HAVING | ⭐⭐ |
| 06 | `es06_join.sql` | INNER JOIN, LEFT JOIN, orfani | ⭐⭐ |

### Sezione B — Database Libreria (sql-exercises/es06)
| 07 | `es07_setup_libreria.sql` | Setup Autori + Libri + Prestiti | ⭐ |
| 08 | `es08_libreria_query.sql` | 7 query (JOIN, WHERE, GROUP BY) | ⭐⭐ |
| 09 | `es09_libreria_avanzato.sql` | Query con CASE WHEN, sottoquery | ⭐⭐⭐ |
| 10 | `es10_update_delete.sql` | UPDATE, DELETE con WHERE e subquery | ⭐⭐ |

### Sezione C — Apicoltura (sql-exercises/es02, es03)
| 11 | `es11_apicoltura_setup.sql` | Setup 5 tabelle | ⭐⭐ |
| 12 | `es12_apicoltura_query.sql` | 10 query base | ⭐⭐ |
| 13 | `es13_apicoltura_aggregati.sql` | GROUP BY su produzione miele | ⭐⭐⭐ |

### Sezione D — E-Commerce (creato ex novo)
| 14 | `es14_ecommerce_setup.sql` | Cliente/Prodotto/Ordine + N:N | ⭐⭐ |
| 15 | `es15_ecommerce_query.sql` | Fatturato, top clienti, stock | ⭐⭐⭐ |

### Sezione E — Avanzato
| 16 | `es16_subquery.sql` | Sottoquery, IN, EXISTS | ⭐⭐⭐ |
| 17 | `es17_views_indexes.sql` | CREATE VIEW, CREATE INDEX | ⭐⭐⭐ |
| 18 | `es18_palestra_completo.sql` | Setup + Query Palestra (N:N+data) | ⭐⭐⭐ |
| 19 | `es19_universita_completa.sql` | Università con media ponderata | ⭐⭐⭐ |
| 20 | `es20_funzioni_stringhe_date.sql` | UPPER, SUBSTR, julianday, strftime | ⭐⭐ |

## Ordine consigliato di studio

1. **Basi**: 01 → 02 → 03 → 04 → 05 → 06
2. **Libreria**: 07 → 08 → 09 → 10
3. **Modificare dati**: 10
4. **Apicoltura**: 11 → 12 → 13
5. **E-Commerce**: 14 → 15
6. **Avanzato**: 16 → 17 → 20 → 18 → 19
