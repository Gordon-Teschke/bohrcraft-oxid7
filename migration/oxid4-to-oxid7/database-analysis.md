# Datenbankanalyse

Stand: 2026-09-16, MySQL 5.6.50-log.

## Versionen und Zeichensaetze

| Bereich | Ergebnis |
|---|---|
| Quellshop | OXID CE 4.9.7, `oxshops.OXVERSION=4.9.7` |
| Zielshop | `oxideshop-ce v7.5.1`, Metapackage `v7.5.0` |
| Ziel-DB-Marker | `oxshops.OXVERSION=6.0.0`, der von OXID 7 weitergefuehrte DB-Marker |
| Quelle | `bohrcraft_oxid4`, UTF-8 / `utf8_general_ci` |
| Ziel | `bohrcraft_oxid7`, UTF-8 / `utf8_general_ci` |
| Serverdefault | Latin-1 / `latin1_swedish_ci`; beide Projektschemas weichen korrekt auf UTF-8 ab |

Die Version ist direkt im Ziel-`composer.lock` unter
`D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft` belegt. Zusaetzlich
ist die Core-Struktur identisch mit der lokal installierten
Stoeberkiste-7.5.1-Referenz.

## Struktur vor und nach der Migration

| Kennzahl | Quelle | Ziel vorher | Ziel nachher |
|---|---:|---:|---:|
| Basistabellen | 73 | 69 | 72 |
| Views | 67 | 63 | 63 |
| Spalten inkl. Views | 2192 | 2078 | 2136 |
| Index-Metadatenzeilen | 247 | 235 | 242 |
| Unique-/Primary-Indexzeilen | 88 | 95 | 97 |
| Trigger | 0 | 0 | 0 |
| Auto-Increment-Spalten | 2 | 2 | 2 |

Vollstaendige Tabellen-, Spalten- und Indexlisten liegen als TSV unter
`evidence/tables-before.tsv`, `evidence/columns-before.tsv`,
`evidence/indexes-before.tsv` sowie den jeweiligen `*-after.tsv`-Dateien.

## Tabellenunterschiede

Nur in OXID 4 vorhanden:

- `adodb_logsql`: technisches Alt-Log, nicht migriert
- `jtl_connector_link`: belegte Connector-Daten, als Custom-Tabelle migriert
- `oxattributeset`, `oxattribute2attributeset`: belegte Bohrcraft-Modultabellen,
  migriert
- `oxcaptcha`: fluechtige Laufzeitdaten, nicht migriert
- `oxgbentries`, `oxlogs`: leer/veraltet, nicht migriert
- `oxnews`, `oxnewsletter`: in OXID 7 entfernte Alt-Core-Tabellen; nicht als
  OXID-7-Coretabellen wieder angelegt
- `oxstatistics`: technische Altstatistik, nicht migriert

Nur in der OXID-7-Basis vorhanden und unveraendert erhalten:

- `ddmedia`
- `makaira_connect_changes`
- `oxmigrations_ce`
- `oxmigrations_ddoemedialibrary`
- `oxmigrations_eyeable_assist`
- `oxmigrations_makaira_connect`

## Custom-Spalten

Migriert, weil in Bohrcraft belegt:

| Tabelle | Spalten | Belegte Zeilen |
|---|---|---:|
| `oxarticles` | `oxattributeset` | 6913 |
| `oxattribute` | `codeisfilterableinvartable`, `codeisvisibleinvartable` | 3 / 47 |
| `oxcategories` | sieben `MM*`-Megamenuefelder | 1 individuelle / 1 Megamenue-Kategorie |
| `oxobject2attribute` | `featureicon`, `datatype` | 38 Feature-Icons |

Nicht in den OXID-7-Core zurueckgefuehrt, weil leer beziehungsweise fachlich
entfernt: `OXTAGS*`, Trusted-Shops-Altfelder, `OXFBID`.

## Mehrsprachigkeit

- Sprach-ID 0: Deutsch, aktiv und Standard.
- Sprach-ID 1: Englisch, aktiv.
- 358 Artikel und 83 Kategorien besitzen englische Inhalte.
- Sprach-IDs 2 und 3 enthalten keine relevanten Artikel-/Kategorieinhalte.
- Die gueltige `aLanguages`-/`aLanguageParams`-Konfiguration wurde entschluesselt
  uebernommen. Eine zusaetzliche defekte OXID-4-Dublette wurde erkannt und
  verworfen.

## Views

Die 67 Quell-Views, darunter `newview` und alle `oxv_*`, wurden nicht kopiert.
Die 63 Ziel-Views wurden mit dem offiziellen OXID-7.5.1-Kommando
`vendor/bin/oe-eshop-db_views_generate` neu erzeugt. Alle erhaltenen
Custom-Spalten sind enthalten; keine Ziel-View referenziert die Quelle.

