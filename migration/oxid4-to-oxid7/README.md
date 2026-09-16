# Bohrcraft OXID 4.9.7 nach OXID 7.5.1 - Datenbankmigration

Diese Migration uebernimmt ausschliesslich Datenbankdaten aus der read-only
behandelten Quelle `bohrcraft_oxid4` in das Ziel `bohrcraft_oxid7`.

Der im Auftrag genannte Name `bohr_oxid4` existiert lokal nicht. Der Altshop
verwendet laut `config.inc.php` und MySQL-Datenverzeichnis tatsaechlich
`bohrcraft_oxid4`.

## Voraussetzungen

- MySQL 5.6 auf `127.0.0.1:3306`
- Login-Path `bohrcraft_migration`
- Vorher-Dumps beider Schemas
- Ausfuehrung aus diesem Verzeichnis

## Reihenfolge

```powershell
pwsh -File .\scripts\export-analysis.ps1 -Label before
pwsh -File .\scripts\run-migration.ps1
pwsh -File .\scripts\export-analysis.ps1 -Label after
pwsh -File .\scripts\verify-migration.ps1
```

Die SQL-Dateien schreiben niemals in `bohrcraft_oxid4`. Alle DDL-/DML-Ziele
sind vollqualifiziert als `bohrcraft_oxid7` angegeben.

## Strategie

- OXIDs und Beziehungen bleiben erhalten.
- OXID-4-Shopkennungen (`oxbaseshop`) werden in OXID 7 auf Shop-ID `1`
  abgebildet.
- Gemeinsame OXID-Tabellen werden spaltenbasiert in die vorhandene
  OXID-7-Struktur uebernommen.
- OXID-7-only Tabellen und Migrationshistorien bleiben erhalten.
- `oxconfig` wird nicht blind kopiert. Nur eine explizite fachliche Whitelist
  wird aus OXID 4 entschluesselt und in bereits vorhandene OXID-7-Eintraege
  geschrieben.
- Alte Pfade, Domains, Cache-, Session-, Theme- und Modulwerte werden nicht
  uebernommen.
- Drei belegte Bohrcraft-Modultabellen und die belegten Custom-Spalten werden
  erhalten. Entfernte OXID-4-Core-Felder ohne Nutzdaten werden nicht angelegt.
- Alte Quell-Views werden nicht kopiert. Die Views werden mit dem offiziellen
  OXID-7.5.1-Generator neu erzeugt; die erhaltenen Custom-Spalten werden dabei
  automatisch aufgenommen.

Siehe auch `database-analysis.md`, `table-mapping.md` und `verification.md`.

