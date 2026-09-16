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
## Vollportierung: automatisierte Prüfung

`port/scripts/verify-port.ps1` wurde nach dem letzten Deployment erfolgreich ausgeführt. Geprüft wurden vier PHP-Dateien, `bohrcraft.js`, verbliebene Smarty-Tags im Theme, CMS-Sondercode in der Datenbank, 13 repräsentative HTTP-Seiten und drei PDF-Downloads. Alle Prüfpunkte sind bestanden.

| Bereich | Ergebnis |
|---|---|
| PHP-Lint Theme/Modul | 4/4 OK |
| JavaScript `node --check` | OK |
| Smarty-Reste Theme | 0 |
| Smarty-Reste relevante DB-Felder | 0 |
| direkte CMS-iframes vor Consent | 0 |
| OXOMI-Kategorietemplate | 1 korrekt zugeordnet |
| repräsentative Seiten | 13/13 HTTP 200 |
| PDF-Downloads | 3/3 HTTP 200, `application/pdf` |

Getestete Seiten:

- Startseite, Marken, Werkzeugprogramm, Aktionen und Unternehmensprofil
- Kontakt und Katalogbestellung
- Downloads/OXOMI, Datenschutz und Impressum
- ein Produktdetail mit Varianten, Bild und Attributtabelle
- englische Marken- und Datenschutzseite

Getestete Downloads:

- `AGB_Bohrcraft.pdf`
- `BOHRCRAFT_HK2024_DE_EN_web.pdf`
- `anwendungsuebersicht_spiralbohrer.pdf`

## Browser-, Consent- und Responsive-Tests

Die lokale URL ist `http://local.bohrcraft-oxid7.de`. Mit dem In-App-Browser wurden DOM, Interaktion, Konsole und drei Viewports geprüft.

| Prüfung | Desktop 1440x900 | Tablet 768x1024 | Smartphone 390x844 |
|---|---|---|---|
| Logo/Header | OK | OK | OK, Logo 179 px breit |
| Hauptnavigation | sichtbar | mobiler Schalter öffnet alle fünf Hauptpunkte | mobiler Schalter vorhanden |
| horizontaler Überlauf | nur 3 px APEX-Rundung | nur 3 px APEX-Rundung | nur 3 px APEX-Rundung |
| YouTube vor Klick | kein iframe | kein iframe | kein iframe |
| Kontaktformular | OK | OK | 335 px breit, 10 Pflichtfelder |
| Browser-Konsole | keine relevanten Einträge | 0 Warnungen/Fehler | 0 Warnungen/Fehler |

YouTube lädt vor dem Klick weder iframe noch Video. Nach `Video laden` wurde genau ein `youtube-nocookie.com`-iframe erzeugt. OXOMI war vor Einwilligung nicht geladen; nach Zustimmung erschienen Kataloginhalte und zwei OXOMI-Skripte ohne Konsolenfehler. Google Maps war vor Klick nicht vorhanden und wurde erst durch `Karte laden` eingebettet. Das Kontaktformular wurde leer abgeschickt: die HTML5-Pflichtfeldprüfung markierte alle zehn Pflichtfelder, die URL blieb unverändert und es wurde keine Mail versendet.

## Medien und Logs

| Bereich | Quelle | Ziel | Ergebnis |
|---|---:|---:|---|
| `pictures` | 7.151 Dateien / 873.153.072 Byte | 7.156 Dateien / 873.180.593 Byte | OK; fünf dynamisch erzeugte Zielbilder |
| `files` | 431 / 429.850.802 Byte | 431 / 429.850.802 Byte | identisch |
| `downloads` | 7 / 2.130.271 Byte | 8 / 2.130.271 Byte | Nutzdaten identisch, eine technische Zieldatei |

Das OXID-Log wurde während der Endprüfung beobachtet. Sein letzter Eintrag ist ein behobener Zwischenstand vom 16.09.2026 13:07:40; die abschließenden Deployments, HTTP-, Browser- und Formularprüfungen erzeugten keine neuen Einträge. Das Apache-Log enthält seit dem Neustart um 12:14:04 keine Bohrcraft-bezogenen Fehler. Ein separates PHP-Fehlerlog ist in dieser XAMPP-Installation nicht vorhanden.

## Alt-/Neu-Vergleich

| Seite/Funktion | OXID 4 / Live | OXID 7 lokal | Status / Abweichung |
|---|---|---|---|
| Startseite | FLOW/Smarty, CMS-Blöcke | APEX/Twig, gleiche CMS-Quellen | bewusst modernisiert, Inhalt/CI erhalten |
| Navigation | Desktop/Mobil, fünf Hauptbereiche | APEX-Megamenü plus mobiler Collapse | OK |
| Marken | drei Markenbereiche | Daten/Links und Logos erhalten | OK |
| Produkte | eigene FLOW-Templates | native APEX-Listen/-Details | bewusst modernisiert; Varianten/Attribute/Herstellerlogo OK |
| Downloads | lokale PDFs und OXOMI | lokale PDFs plus Consent-OXOMI | OK |
| Videos | direkte CMS-iframes | 2-Klick, `youtube-nocookie.com` | datenschutzgerecht modernisiert |
| Unternehmen | CMS/Kategorien | migrierte CMS-/Kategorieinhalte | OK |
| Kontakt | Core-Hacks und Smarty | Modul plus Twig-Formular | OK; echter Mailversand nicht ausgelöst |
| Anfahrt | Google Maps | Klick-zum-Laden | OK |
| Rechtliches | CMS DE/EN | CMS DE/EN | OK |
| Sprache | DE/EN | DE/EN | OK |