# Codex-Auftrag: Bohrcraft OXID 4 → OXID 7 – Schritt 1: Datenbankmigration

## Ziel

Für das Projekt **Bohrcraft** soll zunächst **ausschließlich die Datenbankmigration von OXID 4 nach OXID 7** durchgeführt werden.

Noch keine Arbeiten an:

- Theme
- Templates
- Modulen
- PHP-Code
- JavaScript
- CSS
- Frontend
- Shop-Design
- Zahlungsmodulen
- sonstiger Anwendungslogik

Nach erfolgreicher Datenbankmigration bitte stoppen und einen vollständigen Bericht liefern.

---

# 1. Datenbanken

Lokale Quelldatenbank:

```text
bohr_oxid4
```

Lokale OXID-7-Zieldatenbank:

```text
bohrcraft_oxid7
```

## Wichtige Regel

`bohr_oxid4` ist die Quelle und während des gesamten Vorgangs **read-only** zu behandeln.

Keine Änderungen an `bohr_oxid4`.

Insbesondere keine:

```sql
UPDATE
DELETE
INSERT
ALTER
DROP
TRUNCATE
CREATE
REPLACE
```

gegen diese Datenbank ausführen.

Alle Veränderungen ausschließlich in:

```text
bohrcraft_oxid7
```

durchführen.

---

# 2. Stöberkiste als Referenz verwenden

Wir haben bereits eine vergleichbare Migration **Stöberkiste OXID 4 → OXID 7** durchgeführt.

Bitte im vorhandenen Workspace / in vorhandenen Projekten gezielt danach suchen.

Suchbegriffe unter anderem:

```text
stoeberkiste
stoeber
oxid4
oxid7
migration
database
sql
upgrade
```

Besonders interessant sind:

- SQL-Migrationsskripte
- PHP-Migrationsskripte
- Mapping-Logik OXID 4 → OXID 7
- Dokumentation
- Tabellenvergleiche
- Datenprüfungen
- bekannte Sonderfälle
- Reihenfolge der Migration

Das dort bewährte Vorgehen soll soweit möglich als Vorlage verwendet werden.

Keine Stöberkiste-spezifischen Daten oder IDs nach Bohrcraft übernehmen.

---

# 3. Vorher Backups erstellen

Vor jeder Änderung:

## Quelle sichern

Vollständigen Dump erstellen von:

```text
bohr_oxid4
```

## Ziel sichern

Vollständigen Dump erstellen von:

```text
bohrcraft_oxid7
```

Die Dumps lokal außerhalb produktiver Verzeichnisse ablegen.

Im Abschlussbericht die Speicherorte nennen.

Keine Passwörter oder Zugangsdaten in Git committen.

---

# 4. OXID-Versionen feststellen

Vor der Migration exakt feststellen:

- OXID-Version der Quelldatenbank / des alten Shops
- OXID-Version des Zielshops
- MySQL-/MariaDB-Version
- Zeichensatz
- Collation

Nicht nur allgemein „OXID 4“ und „OXID 7“ dokumentieren.

---

# 5. Datenbankstrukturen vollständig analysieren

Beide Datenbanken vergleichen:

```text
bohr_oxid4
bohrcraft_oxid7
```

Für jede Datenbank erfassen:

- Tabellen
- Spalten
- Datentypen
- Primärschlüssel
- Indizes
- Unique Keys
- Auto-Increment
- Views
- Trigger, falls vorhanden
- Zeichensatz
- Collation

Zusätzlich unbedingt erkennen:

- kundenspezifische Tabellen
- zusätzliche Spalten in OXID-Core-Tabellen
- Modul-Tabellen
- alte nicht mehr benötigte Tabellen
- neue OXID-7-Tabellen

Eine strukturierte Vergleichsdokumentation erstellen.

---

# 6. Tabelleninhalte analysieren

Für alle relevanten Tabellen Datensatzanzahlen der alten Datenbank erfassen.

Mindestens prüfen:

```text
oxarticles
oxartextends
oxcategories
oxobject2category
oxattribute
oxobject2attribute
oxselectlist
oxobject2selectlist
oxvendor
oxmanufacturers
oxuser
oxaddress
oxorder
oxorderarticles
oxpayments
oxdelivery
oxdeliveryset
oxdiscount
oxvoucherseries
oxvouchers
oxcontents
oxmediaurls
oxlinks
oxshops
oxconfig
oxconfigdisplay
```

Nur tatsächlich vorhandene Tabellen verwenden.

Darüber hinaus alle Bohrcraft-spezifischen Tabellen erfassen.

---

# 7. Migrationsstrategie erstellen

Vor dem eigentlichen Import eine klare Mapping-Strategie erstellen.

Für jede relevante OXID-4-Tabelle bestimmen:

```text
Quelle
Ziel
direkt übernehmbar
muss transformiert werden
wird durch OXID 7 neu erzeugt
nicht mehr benötigt
Sonderfall
```

Besondere Aufmerksamkeit auf:

- geänderte Datentypen
- neue Pflichtfelder
- entfernte Felder
- umbenannte Felder
- neue Tabellenstruktur
- Sprachfelder
- Serialisierungen
- Konfigurationswerte

---

# 8. IDs erhalten

Bestehende OXIDs nach Möglichkeit unverändert übernehmen.

Das betrifft insbesondere Beziehungen zwischen:

- Artikeln
- Kategorien
- Varianten
- Attributen
- Auswahllisten
- Kunden
- Adressen
- Bestellungen
- Bestellpositionen
- Zahlungsarten
- Versandarten
- Rabatten
- Gutscheinen
- CMS-Inhalten

Keine unnötige Neuerzeugung von IDs.

---

# 9. Daten vollständig migrieren

Die fachlich relevanten Daten aus:

```text
bohr_oxid4
```

nach:

```text
bohrcraft_oxid7
```

übernehmen.

Mindestens:

## Shopdaten

- Shop-Grunddaten
- Sprachen, soweit relevant
- Kategorien
- Hersteller
- Lieferanten

## Artikel

- Artikel
- Varianten
- Preise
- MwSt.-Angaben
- Lagerdaten
- Kurztexte
- Langtexte
- Suchbegriffe
- EAN
- MPN
- Gewichte
- Maße
- Aktiv-Status

## Beziehungen

- Artikel → Kategorie
- Artikel → Attribute
- Artikel → Auswahllisten
- Varianten → Parent
- Hersteller → Artikel

## Kunden

- Benutzer
- Rechnungsadressen
- Lieferadressen
- Kundengruppen-Zuordnungen

## Bestellungen

- Bestellungen
- Bestellpositionen
- historische Bestelldaten

## CMS

- Inhalte
- CMS-Seiten
- relevante Links

## Shoplogik-Daten

- Zahlungsarten
- Versandarten
- Versandregeln
- Rabatte
- Gutscheine
- Gutscheinserien

## Medienreferenzen

Nur Datenbankreferenzen übernehmen.

Dateien/Bilder selbst sind **noch nicht Teil dieses Auftrags**.

---

# 10. Mehrsprachigkeit beachten

Die vorhandenen Sprachfelder korrekt analysieren.

Insbesondere OXID-typische Felder wie:

```text
OXTITLE
OXTITLE_1
OXTITLE_2
...
```

nicht ungeprüft behandeln.

Feststellen:

- welche Sprachen im Altshop tatsächlich genutzt werden
- welche Sprachreihenfolge OXID 7 verwendet
- welche Inhalte in welcher Sprache vorhanden sind

Alle relevanten Sprachdaten erhalten.

---

# 11. oxconfig besonders vorsichtig behandeln

`oxconfig` und vergleichbare technische Konfigurationstabellen **nicht 1:1 blind kopieren**.

Jeden relevanten Eintrag klassifizieren:

```text
fachliche Shopkonfiguration
OXID-Core-Konfiguration
Modulkonfiguration
Pfad
Domain
Cache
Session
Theme
veraltet
versionsabhängig
```

Nur Werte übernehmen, die in OXID 7 sinnvoll sind.

Keine alten:

- Dateipfade
- Domains
- Cache-Werte
- Session-Werte
- Theme-Werte
- Modul-Altlasten

blind übertragen.

---

# 12. Views nicht aus OXID 4 kopieren

Alte OXID-Views wie:

```text
oxv_*
```

nicht übernehmen.

Nach Abschluss der Datenmigration die für OXID 7 vorgesehenen Views mit dem OXID-7-Mechanismus neu erzeugen.

---

# 13. Migration reproduzierbar machen

Keine rein manuelle Datenbankbastelei.

Unter dem Projekt eine nachvollziehbare Migrationsstruktur anlegen, zum Beispiel:

```text
migration/
└── oxid4-to-oxid7/
    ├── README.md
    ├── database-analysis.md
    ├── table-mapping.md
    ├── verification.md
    ├── sql/
    └── scripts/
```

Die genaue Struktur darf sinnvoll verbessert werden.

Alle tatsächlich benötigten SQL-/Migrationsskripte dort ablegen.

Die Migration soll später erneut ausgeführt werden können.

---

# 14. Ziel-Datenbank darf zurückgesetzt werden

Falls für eine saubere reproduzierbare Migration notwendig, darf:

```text
bohrcraft_oxid7
```

gesichert und anschließend neu aufgebaut bzw. bereinigt werden.

Aber:

- vorher Dump erstellen
- keine Quelle verändern
- Vorgehen dokumentieren
- OXID-7-Basisstruktur erhalten bzw. sauber wiederherstellen

Nicht einfach OXID-4-Tabellen komplett über die OXID-7-Struktur kopieren.

---

# 15. Datenprüfung nach Migration

Nach der Migration systematisch Alt gegen Neu vergleichen.

Mindestens Counts prüfen für:

- Artikel
- aktive Artikel
- Kategorien
- Kategoriezuordnungen
- Varianten
- Attribute
- Attributzuordnungen
- Auswahllisten
- Hersteller
- Lieferanten
- Kunden
- Adressen
- Bestellungen
- Bestellpositionen
- CMS-Inhalte
- Zahlungsarten
- Versandarten
- Rabatte
- Gutscheine

Abweichungen dokumentieren.

Bei Abweichungen angeben:

```text
Differenz
Grund
beabsichtigt / Fehler
```

---

# 16. Stichproben durchführen

Nicht nur Datensatzanzahlen vergleichen.

Mindestens mehrere repräsentative Datensätze vollständig vergleichen.

## Artikel

Prüfen:

- OXID
- Artikelnummer
- Titel
- Preis
- MwSt.
- Aktiv
- Lager
- Kategorie
- Variante
- Beschreibung

## Kunde

Prüfen:

- OXID
- E-Mail
- Name
- Rechnungsadresse
- Lieferadresse

## Bestellung

Prüfen:

- OXID
- Bestellnummer
- Datum
- Kunde
- Gesamtbetrag
- Positionen

## Kategorie

Prüfen:

- OXID
- Titel
- Parent
- Aktiv
- Sortierung

---

# 17. Referenzielle Konsistenz prüfen

Nach Migration gezielt nach verwaisten Datensätzen suchen.

Beispielsweise:

- Kategoriezuordnung ohne Artikel
- Kategoriezuordnung ohne Kategorie
- Bestellposition ohne Bestellung
- Adresse ohne Benutzer
- Variante ohne Parent
- Attributzuordnung ohne Artikel
- Auswahllistenzuordnung ohne Artikel

Gefundene Probleme untersuchen und korrigieren, sofern sie durch die Migration entstanden sind.

---

# 18. Keine weiteren Projektarbeiten

Dieser Auftrag endet nach erfolgreicher Datenbankmigration.

Noch NICHT bearbeiten:

- PHP-Kompatibilität
- OXID-Module
- Theme
- Twig
- Smarty
- CSS
- JavaScript
- Bilder kopieren
- Medien-Dateien kopieren
- Frontendfehler
- Checkout
- Zahlungsanbieter
- Mail
- SEO-Redirects

Diese Schritte folgen später separat.

---

# 19. Git

Vor Beginn:

```bash
git status
```

prüfen.

Vorhandene fremde Änderungen nicht überschreiben.

Nur migrationsbezogene Dateien committen.

Keine:

- SQL-Dumps mit echten Kundendaten
- Passwörter
- Zugangsdaten
- `.env`-Secrets

in Git aufnehmen.

Sinnvolle Commit-Message zum Beispiel:

```text
feat: prepare bohrcraft oxid4 to oxid7 database migration
```

oder mehrere klar getrennte Commits.

---

# 20. Definition of Done

Schritt 1 ist abgeschlossen, wenn:

- `bohr_oxid4` unverändert geblieben ist
- beide Datenbanken gesichert wurden
- OXID-Versionen festgestellt wurden
- Tabellenstrukturen verglichen wurden
- Custom-Tabellen und Custom-Felder erkannt wurden
- ein nachvollziehbares Tabellen-Mapping existiert
- relevante Daten nach `bohrcraft_oxid7` migriert wurden
- OXIDs und Beziehungen soweit möglich erhalten wurden
- alte Views nicht übernommen wurden
- OXID-7-Views neu erzeugt wurden
- Daten-Counts verglichen wurden
- Stichproben erfolgreich geprüft wurden
- referenzielle Konsistenz geprüft wurde
- die Migration reproduzierbar dokumentiert ist
- keine Arbeiten außerhalb der Datenbankmigration vorgenommen wurden

Danach **STOPP**.

---

# 21. Abschlussbericht

Am Ende bitte liefern:

## Umgebung

```text
Projektroot:
OXID-4-Version:
OXID-7-Version:
MySQL/MariaDB-Version:
Quelle:
Ziel:
```

## Backups

```text
Quelle Dump:
Ziel Dump:
```

## Stöberkiste-Referenz

- was gefunden wurde
- welche Vorgehensweise übernommen wurde

## Datenbankanalyse

- Tabellen OXID 4
- Tabellen OXID 7
- Custom-Tabellen
- Custom-Spalten

## Migration

- migrierte Tabellen
- transformierte Tabellen
- nicht migrierte Tabellen
- Begründungen

## Prüfung

Tabelle mit:

```text
Datenbereich | Alt | Neu | Differenz | Status
```

## Probleme

- gefundene Probleme
- behobene Probleme
- verbleibende Probleme

## Dateien

Alle neu erstellten:

- SQL-Dateien
- Scripts
- Dokumentationen

auflisten.

## Git

- Branch
- Commit-SHA(s)
- Git-Status

---

# Wichtig

Dieser Auftrag betrifft **nur die Datenbank**.

Nach erfolgreicher Migration und Prüfung bitte **nicht selbständig mit Theme, Modulen oder Shop-Code weitermachen**, sondern den Abschlussbericht liefern und auf den nächsten Auftrag warten.
