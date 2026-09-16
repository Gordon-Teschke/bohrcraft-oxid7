# Abschlussbericht: Bohrcraft Datenbankmigration OXID 4 nach OXID 7

## Umgebung

```text
Projektroot:        D:\__code_workspace_mcp\bohrcraft
OXID-4-Version:     OXID CE 4.9.7
OXID-7-Version:     oxideshop-ce v7.5.1 / Metapackage v7.5.0
Ziel-DB-Marker:     oxshops.OXVERSION = 6.0.0
MySQL-Version:      5.6.50-log
Quelle:             bohrcraft_oxid4 (read-only behandelt)
Ziel:               bohrcraft_oxid7
Schema-Zeichensatz: utf8 / utf8_general_ci
```

Der Auftragsname `bohr_oxid4` existiert lokal nicht. Der alte Shop ist in
`config.inc.php` auf `bohrcraft_oxid4` konfiguriert; dieses Schema wurde nach
Pruefung als Quelle verwendet.

## Backups

```text
Quelle Dump:
D:\__code_workspace_mcp\bohrcraft\.backups\20260916_113850\bohrcraft_oxid4_before.sql
SHA-256: A6FF13E8F30FEBD37F533CA548AF8AC1D66FA0A4D4105CE170A65CD7117788C7

Ziel Dump:
D:\__code_workspace_mcp\bohrcraft\.backups\20260916_113850\bohrcraft_oxid7_before.sql
SHA-256: 9424EA02BD8DCFAC13D7D8908BA4B01C86C7F2F3C16CDF5FA400D8AA7452C68B
```

Beide Dumps wurden vor der ersten Zielaenderung erzeugt und enthalten den
erfolgreichen `Dump completed`-Marker. Sie liegen ausserhalb der
Shopverzeichnisse und sind durch `.gitignore` von einer Versionierung
ausgeschlossen.

## Stoeberkiste-Referenz

Gefunden wurden unter `D:\__gordon_codex_home\stoeberkiste\migration` die
Skripte `oxid49_to_75_initial_transfer.sql`,
`oxid49_to_75_remaining_transfer.sql`,
`oxid49_to_75_config_shop_merge.sql` und
`oxid49_to_75_oxconfig_decoded_merge.sql`.

Uebernommen wurden das spaltenbasierte Mapping, die Shop-ID-Umsetzung auf `1`,
das Beibehalten der OXID-7-Struktur und die getrennte Behandlung von
`oxconfig`/`oxshops`. Fuer Bohrcraft wurden zusaetzlich eine strikte
Konfigurations-Whitelist, Quell-Checksummen, ID-Mengenpruefungen und die
explizite Custom-Schema-Migration umgesetzt. Keine Stoeberkiste-Daten oder
-IDs wurden uebernommen.

## Datenbankanalyse

- Quelle vorher/nachher: 73 Basistabellen, 67 Views, unveraendert.
- Ziel vorher: 69 Basistabellen, 63 Views.
- Ziel nachher: 72 Basistabellen, 63 Views.
- Custom-Tabellen migriert: `jtl_connector_link`, `oxattributeset`,
  `oxattribute2attributeset`.
- Belegte Custom-Spalten in Artikeln, Attributen, Kategorien und
  Attributzuordnungen migriert.
- OXID-7-only Medien-, Makaira- und Migrationstabellen erhalten.
- Trigger: keine in Quelle oder Ziel.

Details: `database-analysis.md` und `evidence/*-before.tsv` / `*-after.tsv`.

## Migration

- 60 gemeinsame OXID-Tabellen spaltenbasiert migriert.
- 3 Custom-Tabellen migriert.
- OXIDs und Beziehungen erhalten; 54 ID-Mengen ohne Abweichung.
- Shop-IDs auf numerisch `1` umgesetzt.
- `oxdiscount.OXSORT` wegen neuem OXID-7-Unique-Key deterministisch auf
  1, 2 und 3 gesetzt.
- Fachliche Shop-Stammdaten selektiv uebernommen.
- 14 gepruefte fachliche Core-Konfigurationen entschluesselt uebernommen.
- Alte Domains, Pfade, Cache, Sessions, Themes, Modulregistrierungen und
  Zugangsdaten nicht kopiert.
- Alte Views nicht kopiert; 63 Views mit dem offiziellen OXID-7.5.1-Generator neu erzeugt.

Nicht migrierte Altbereiche und Begruendungen stehen in `table-mapping.md`.

## Pruefung

Alle 63 migrierten Tabellen besitzen identische Datensatzanzahlen. Die
wichtigsten Fachbereiche sind in `verification.md` tabellarisch aufgefuehrt.

- 10 Artikelstichproben: OK
- 5 Benutzerstichproben: OK
- 10 Kategoriestichproben: OK
- Bestellungen: Quelle und Ziel jeweils 0, daher keine fachliche Stichprobe
- Neu entstandene Waisen: 0
- Quell-Checksummen vor/nachher: identisch
- Ziel-Views mit Quellreferenz: 0
- Ziel-Shop-ID-Abweichungen: 0

## Probleme

Behoben:

- OXID 7 verlangt fuer `oxdiscount` eindeutige Sortierungen pro Shop;
  OXID 4 hatte keine entsprechende Spalte. Deterministische Transformation
  dokumentiert und verifiziert.
- Defekte doppelte OXID-4-Zeilen fuer `aLanguages`/`aLanguageParams` erkannt;
  nur gueltige serialisierte Werte wurden uebernommen.

Verbleibend, bereits in der Quelle vorhanden:

- 1 Attributzuordnung ohne Artikel.
- 1488 Attributset-Zuordnungen zu 189 fehlenden Set-IDs.

Diese Altlasten wurden nicht automatisch geloescht, da sie nicht durch die
Migration entstanden sind und die Quelle unveraendert abzubilden war.

## Dateien

```text
.gitignore
migration/oxid4-to-oxid7/README.md
migration/oxid4-to-oxid7/database-analysis.md
migration/oxid4-to-oxid7/table-mapping.md
migration/oxid4-to-oxid7/verification.md
migration/oxid4-to-oxid7/completion-report.md
migration/oxid4-to-oxid7/sql/00-preflight.sql
migration/oxid4-to-oxid7/sql/10-preserve-custom-schema.sql
migration/oxid4-to-oxid7/sql/20-migrate-data.sql
migration/oxid4-to-oxid7/sql/40-verify.sql
migration/oxid4-to-oxid7/scripts/export-analysis.ps1
migration/oxid4-to-oxid7/scripts/run-migration.ps1
migration/oxid4-to-oxid7/scripts/verify-migration.ps1
migration/oxid4-to-oxid7/evidence/*.tsv
```

## Git

```text
Branch:       nicht vorhanden
Commit-SHA:   nicht vorhanden
Git-Status:   Projektroot ist kein Git-Repository
```

Es wurden keine SQL-Dumps, Zugangsdaten oder Kundendaten in Git aufgenommen.
Der Auftrag endet hier; Theme, Module, PHP, JavaScript, CSS, Medien und
Frontend wurden nicht bearbeitet.

