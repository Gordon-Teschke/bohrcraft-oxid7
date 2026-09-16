# Verifikation

## Counts

| Datenbereich | Alt | Neu | Differenz | Status |
|---|---:|---:|---:|---|
| Artikel | 6920 | 6920 | 0 | OK |
| Aktive Artikel | 6920 | 6920 | 0 | OK |
| Varianten | 6430 | 6430 | 0 | OK |
| Artikel-Langtexte | 7087 | 7087 | 0 | OK |
| Kategorien | 92 | 92 | 0 | OK |
| Kategoriezuordnungen | 6913 | 6913 | 0 | OK |
| Attribute | 53 | 53 | 0 | OK |
| Attributzuordnungen | 43584 | 43584 | 0 | OK |
| Attributsets | 63 | 63 | 0 | OK |
| Attributset-Zuordnungen | 1832 | 1832 | 0 | OK |
| Auswahllisten | 0 | 0 | 0 | OK |
| Auswahllistenzuordnungen | 0 | 0 | 0 | OK |
| Hersteller | 3 | 3 | 0 | OK |
| Lieferanten | 0 | 0 | 0 | OK |
| Kunden | 10 | 10 | 0 | OK |
| Lieferadressen | 0 | 0 | 0 | OK |
| Bestellungen | 0 | 0 | 0 | OK |
| Bestellpositionen | 0 | 0 | 0 | OK |
| CMS-Inhalte | 72 | 72 | 0 | OK |
| Zahlungsarten | 7 | 7 | 0 | OK |
| Versandarten | 3 | 3 | 0 | OK |
| Versandregeln | 5 | 5 | 0 | OK |
| Rabatte | 3 | 3 | 0 | OK |
| Gutscheine | 0 | 0 | 0 | OK |
| Gutscheinserien | 0 | 0 | 0 | OK |
| Medienreferenzen | 0 | 0 | 0 | OK |
| JTL-Verknuepfungen | 13471 | 13471 | 0 | OK |

Darueber hinaus wurden alle 63 migrierten Tabellen einzeln verglichen; jede
weist identische Alt-/Neu-Counts auf. Fuer 54 Tabellen mit OXID-Schluessel
wurden beide ID-Mengen verglichen: keine fehlende und keine zusaetzliche OXID.

## Stichproben

- 10 Artikel: OXID, Artikelnummer, Titel, Preis, MwSt., Aktivstatus, Bestand,
  Parent, Attributset, Langtext und Anzahl Kategoriebeziehungen stimmen.
- 5 Benutzer: OXID, E-Mail, Name, Rechnungsanschrift und Anzahl
  Lieferadressen stimmen.
- 10 Kategorien: OXID, Titel, Parent, Aktivstatus, Sortierung und
  Megamenuefelder stimmen.
- Bestellstichprobe: nicht moeglich, da die Quelle keine Bestellungen und
  keine Bestellpositionen enthaelt. Die Null-Counts stimmen.

Die verwendeten OXIDs und Einzelstatus stehen in
`evidence/verification-results.tsv`; personenbezogene Feldwerte werden dort
nicht ausgegeben.

## Referenzielle Konsistenz

Neu entstandene Waisen: keine.

Vor der Migration bereits vorhandene und unveraendert uebernommene Altlasten:

- 1 Attributzuordnung ohne vorhandenen Artikel.
- 1488 Attributset-Zuordnungen zu 189 nicht vorhandenen Set-IDs.

Alle anderen geprueften Beziehungen sind fehlerfrei: Kategorie/Artikel,
Bestellung/Position, Benutzer/Adresse, Variante/Parent, Attribut/Artikel,
Auswahlliste/Artikel und Attributset/Attribut.

## Quelle read-only

Die Checksummen aller 73 Quell-Basistabellen wurden vor und nach der Migration
verglichen. Beide Dateien besitzen denselben SHA-256-Hash:

```text
D3DF4144FBC5AD68ADDDFEFB678D0A3A7B9173BAFE4B2508ED51DDEC36F4D532
```

Damit ist verifiziert, dass `bohrcraft_oxid4` unveraendert blieb.

## Views und Shop-IDs

- 63 OXID-7-Views vorhanden.
- 0 Views referenzieren `bohrcraft_oxid4`.
- 32 migrierte Shop-ID-Felder geprueft; 0 Werte weichen von Ziel-Shop-ID 1 ab.

