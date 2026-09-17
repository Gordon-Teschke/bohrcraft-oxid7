# Bohrcraft OXID 7 – Live-Parity Runde 2

Stand: 17.09.2026

## Status

Die Altseite `https://www.bohrcraft.de/` und das öffentliche OXID-7-Staging `https://bcraft.co-de.de/` wurden vor der Änderung live in 390×844, 768×1024, 1440×900 und 1920×1080 verglichen. Die Korrekturen sind lokal in OXID 7 ausgerollt und technisch sowie in einer 72-Fälle-Browsermatrix geprüft.

Der abschließende Nachweis auf `bcraft.co-de.de` ist noch offen: Im Repository und in der lokalen SSH-Konfiguration ist kein belastbarer SSH-Zielhost für den Server mit `/var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft` hinterlegt. Der einzige konfigurierte Host `hybris-svn` ist nach read-only Prüfung nicht dieser Webserver. Deshalb wurde nicht auf einen geratenen Host oder Pfad deployt.

## Gefundene Abweichungen, Ursachen und Korrekturen

| Bereich | Live Altseite | Staging vor Änderung | Ursache | Lokal nach Änderung |
|---|---|---|---|---|
| Header 390 px | 190 px | 208 px | Mobile Raster und Navigation waren zu hoch | 190 px |
| Slider 390 px | sichtbar, 70,31 px | ausgeblendet | Responsive-Regel versteckte den Slider | sichtbar, 70,31 px |
| Header 768 px | 408,55 px | 186 px | Tablet nutzte fälschlich Mobile-Header | 408,55 px mit dreizeiligem historischen Raster |
| Slider 768 px | 141,19 px | 220 px | feste Höhe statt Bildverhältnis | 141,19 px |
| Slider 1440 px | 267,19 px | 267 px | nur in diesem Viewport zufällig passend | 267,19 px |
| Slider 1920 px | 357,19 px | 267 px | feste Höhe | 357,19 px durch `aspect-ratio: 16/3` |
| Slogan | „Präzision für Industrie und Handwerk“ | „Kompetenz seit 1975“ | falscher Headertext | Referenztext DE/EN |
| Familienlogos Desktop | Profi Basic, dann Profi Plus | Plus, dann Basic | Grid-Autoplacement | Basic, dann Plus; auf Mobile wie Referenz Plus über Basic |
| Sprache | 46×40-px-Flächen, Flagge 18×12 px, aktive Sprache weiß | ca. 29×20 px, kein Referenzzustand; Klickfläche von Navigation überlagert | APEX-Z-Index 123 und zu kleine Linkflächen | 46×40 px, aktiver Zustand, Fokus/Hover; Sprache liegt mit Z-Index 124/125 über APEX |
| Mobile Schrift | 16 px | 15 px | APEX/Responsive-Vererbung | 16 px |
| Profil-H1 Desktop | 36 px / 39,6 px / Gewicht 200 / y≈198,1 | 24 px / 26,4 px / Gewicht 500 / y≈225,6 | APEX-H2-Stil und zu hoher Breadcrumb | 36 px / 39,6 px / Gewicht 200 / y≈198,6 |
| Profil-Bildfolge | zweite Bildzeile Bild links, Text rechts | Text links, Bild rechts | alte Bootstrap-3-Klassen `col-sm-push-6`/`pull-6` wirkungslos | Kompatibilitätsregeln stellen die Referenzreihenfolge wieder her |
| Kategorie Spiralbohrer | vier klassische, gerahmte Unterkategoriekacheln | großes Hero-Kategoriebild und runde APEX-Icons | APEX-Standardkategorielayout | Hero-Bild ausgeblendet, 4-Spalten-Kacheln; Mobile 1 Spalte |
| Kontaktformular | Felder untereinander | mehrere Felder paarweise | Bootstrap-5-Spalten im neuen Formular | Formularfelder wieder einspaltig, Funktion und Pflichtfelder bleiben erhalten |
| Horizontaler Overflow | auf Kernseiten keiner | einzelne CMS-Ränder/ungewrapptes langes H1 | Bootstrap-3-Row-Ränder und lange Begriffe | in 72 lokalen Fällen keiner |
| Asset-Versionierung | einzelne Dateien | `bohrcraft.css` mit sechs festen Datums-Imports | manuelle `?v=`-Parameter | sechs CSS-Dateien direkt über OXID registriert, jeweils mit mtime-Querystring |
| Preload | keine Warnung | `scripts.min.js` ohne Query preloaded, später mit mtime-Query geladen; zusätzlich ungenutzte APEX-Fonts | Preload- und Nutzungs-URL waren nicht identisch | Child-Override entfernt JS- und ungenutzte Font-Preloads; APEX-Parent bleibt unverändert |

## Sprache

Die vorhandene OXID-Sprachlogik und `oxwLanguageList` bleiben unverändert. Es gibt keine hart codierten Sprach-URLs und keine Session-ID-Manipulation.

Lokal geprüft:

- Desktop Profil DE → EN: `/de/Unternehmen/Profil/` → `/Company/Company-profile/`
- Ergebnis: `lang="en"`, H1 „Company profile“
- Mobile EN → DE: korrekte OXID-Ziel-URL und deutscher Inhalt
- Klickzieltest: `elementFromPoint` trifft nach der Korrektur den sichtbaren Sprachlink
- aktive Sprache, Hover und Tastaturfokus sind sichtbar

Auf dem unveränderten Staging wurden im echten Browser 26 Links mit `force_sid` reproduziert, obwohl Curl im HTML keine `force_sid`-Links sieht. Lokal sind es 0. Da das Verhalten umgebungsabhängig ist, wurde es nicht im Theme versteckt und die OXID-Sprachlogik nicht ersetzt. Die Server-/Sessionkonfiguration muss nach dem echten Deployment auf dem Staging-Host geprüft werden.

## Animationen und Interaktionen

| Effekt | Altseite | OXID 7 vor Änderung | Nach Änderung |
|---|---|---|---|
| Startslider Autoplay | Slide, 7000 ms Pause, 600 ms Übergang | 5500-ms-Konfiguration beabsichtigt; wegen Ladefolge nicht zuverlässig aktiv, APEX-Standard konnte übernehmen | Bootstrap 5, 7000 ms, 600 ms `ease-in-out`; gemessen: bei 5,2 s unverändert, bei 7,5 s nächster Slide |
| Slider Hover | keine Pause | `pause: hover` möglich | `pause: false` |
| Slider Touch/Wrap | aktiv | Bootstrap-Standard | `touch: true`, `wrap: true` |
| Slider Bedienelemente | 40×40 px, schwarze Kreise; keine Punkte | weiße Standardpfeile und Indikatoren | Referenzoptik, Indikatoren ausgeblendet |
| Reduced Motion | nicht systematisch | bereits berücksichtigt | bleibt berücksichtigt; Autoplay aus und CSS-Dauern minimal |
| Sticky Header | ca. 200 ms | ca. 500 ms | 200 ms; IntersectionObserver, sticky Logo geprüft |
| Megamenü | ca. 500 ms Ein-/Ausblendung | vorhandener moderner Nachbau | 500 ms, Fokus/Hover, 3 Markenkarten; keine Altbibliothek |
| Mobile Hauptmenü | Burger, Untermenüs auf/zu | grundlegend vorhanden | Tablet-Breakpoint korrigiert; Untermenüs, Escape und Außenklick schließen geprüft |
| Kachel-/Link-Hover | Schatten/Farbwechsel | vorhanden | beibehalten; auf Touch kein künstlicher Hover |

Es wurden weder jQuery noch FlexSlider, PushMenu oder Bootstrap 3 als Runtime-Abhängigkeit zurückgebracht.

## Geänderte Dateien

- `migration/oxid4-to-oxid7/port/source/Application/views/bohrcraft/tpl/layout/base.html.twig`
- `migration/oxid4-to-oxid7/port/source/Application/views/bohrcraft/tpl/layout/header.html.twig`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/bohrcraft.css`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/bohrcraft-layout.css`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/bohrcraft-navigation.css`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/bohrcraft-cms.css`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/bohrcraft-responsive.css`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/js/bohrcraft-navigation.js`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/js/bohrcraft-animations.js`
- `deploy-bohrcraft-oxid7.sh`
- diese Dokumentation

Der APEX-Parent und `vendor/` wurden nicht verändert.

## Browser- und Testmatrix

Vorher-Livevergleich:

- 4 Viewports × Altseite/Staging
- jeweils Fold- und Full-Page-Screenshot der Startseite
- 18 repräsentative Pfade auf Mobile und Desktop
- Sprache, Markenmenü, Footer, Header, Slider und Asset-Identitäten

Lokaler Nachtest:

- 18 Pfade × 4 Viewports = 72 Fälle
- 0 Navigationsfehler
- 0 kaputte Bilder
- 0 horizontale Overflows
- 0 doppelte Script- oder Stylesheet-URLs
- 0 `force_sid`-Links
- Body-Schrift 16 px

Geprüfte Pfadgruppen: Start, Marken/Bohrcraft/Profi Plus/Profi Basic, Produktübersicht/Kategorie/Artikel, Downloads/Anwendungen/Videos, Profil/Qualität/Karriere, Kontakt/Kontaktformular/Anfahrt und Datenschutz. Zusätzlich deckt der automatisierte HTTP-Test Impressum, englische Seiten, Katalogformular und PDF-Downloads ab.

Evidenz liegt unter `migration/oxid4-to-oxid7/evidence/live-parity-round2/` und bleibt gemäß `.gitignore` außerhalb von Git.

## Technische Verifikation

`verify-port.ps1` ist vollständig grün:

- PHP-Lint: 4/4
- JavaScript-Syntax: 3/3
- HTTP: 13/13 mit Status 200 und ohne Fatal-/Templatefehler
- PDF-Downloads: 3/3 mit Status 200
- keine Smarty-Reste im Theme
- Datenbankprüfungen: `smarty=0`, `iframe=0`, `oxomi_template=1`

Zusätzliche Browserprüfungen:

- Kontaktformular bleibt nach leerem Submit auf derselben URL; 10 Pflichtfelder sind ungültig
- Sliderpfeil schaltet den aktiven Slide
- Sticky Header wird nach Scroll aktiv und sitzt bei y=0
- Mobile Menü und Untermenü öffnen; Außenklick und Escape schließen
- lokaler Browser-Log: keine Einträge
- aktueller Staging-Browser-Log vor Deployment: keine Einträge
- lokaler DOM-Preload: nur `styles.min.css`; kein JS- oder Font-Preload

Ein endgültiger Konsolenstatus „nach Deployment“ kann erst nach dem echten Staging-Deployment bestätigt werden.

## Bewusste verbleibende Unterschiede

- Artikeldetails behalten die OXID-7/APEX-Funktionen für Varianten, Preis und Warenkorb. Das alte OXID-4-Detailmarkup wurde nicht auf Kosten dieser Funktionen nachgebaut.
- OXOMI, YouTube und Google Maps bleiben Consent-gesteuert. Unterschiedliche Seitenhöhen bei unterschiedlichem Consent-Status sind beabsichtigt.
- Das reproduzierbare browserabhängige `force_sid` auf Staging ist kein Themefix und muss serverseitig geprüft werden.
- Die öffentliche Staging-Seite zeigt bis zum Deployment weiterhin den alten Stand dieser Runde.

## Linux-Deployment

Voraussetzung: Repository/Deployment-Paket liegt auf dem echten Staging-Host und der MySQL-Login-Path ist für den ausführenden Benutzer eingerichtet.

```bash
cd /pfad/zum/bohrcraft-oxid7-repository
chmod 750 deploy-bohrcraft-oxid7.sh
sudo mysql_config_editor set \
  --login-path=bohrcraft_migration \
  --host=127.0.0.1 \
  --port=3306 \
  --user=DB_BACKUP_USER \
  --password
sudo ./deploy-bohrcraft-oxid7.sh \
  --package-root "$PWD/migration/oxid4-to-oxid7/port" \
  --mysql-login-path bohrcraft_migration \
  --url https://bcraft.co-de.de
```

Das Skript:

1. validiert Shoproot, Composer-PHAR und Paket,
2. legt Code- und Datenbankbackup an,
3. kopiert nur Child-Theme und Kontaktmodul,
4. lintet PHP,
5. erhält bestehende Composer-Autoload-Einträge,
6. erzeugt den Autoloader,
7. setzt Codebesitz passend zum vorhandenen Shop,
8. setzt ausschließlich `source/tmp` auf `www-data:www-data`, Verzeichnisse 775 und Dateien 664,
9. installiert/aktiviert `bohrcraft_contact` idempotent,
10. aktiviert das Theme, leert den OXID-Cache und prüft sechs DE/EN-Kern-URLs per HTTP.

Nur wenn bereits ein extern geprüftes Datenbankbackup vorliegt, darf bewusst `--skip-db-backup` verwendet werden. `chmod 777` ist nicht enthalten.

Nach dem Deployment zwingend:

```bash
stat -c '%U:%G %a %n' \
  /var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft/source/tmp
curl -fsS https://bcraft.co-de.de/ >/dev/null
curl -fsS https://bcraft.co-de.de/Company/Company-profile/ >/dev/null
```

Danach im Browser mit deaktiviertem Cache dieselbe 4-Viewport-Matrix, DE → EN → DE, Slider, Sticky Header, Desktop-/Mobilemenü, Konsolenstatus, Preloads und `force_sid` erneut prüfen.

## Commit

Implementierungs-Commit: `WIRD_NACH_DEM_COMMIT_EINGETRAGEN`

## Definition of Done – ehrlicher Stand

- [x] Live-Altseite und Live-Staging systematisch vor der Änderung verglichen
- [x] Sprachumschaltung lokal sichtbar und funktional angeglichen
- [x] relevante Animationen inventarisiert und modern nachgebildet
- [x] Header/Navi/Megamenü lokal angeglichen
- [x] repräsentative Unterseiten lokal angeglichen
- [x] Desktop, Tablet und Mobile lokal geprüft
- [x] Preload-Ursache geklärt und lokal beseitigt
- [x] lokal keine Doppel-Ladung von Bohrcraft-Assets
- [x] OXID/APEX/Modul/Consent lokal funktionsfähig
- [x] Linux-Deployment wiederholbar vorbereitet
- [ ] Korrekturen auf `bcraft.co-de.de` deployt
- [ ] finaler Check direkt auf `bcraft.co-de.de` nach Deployment
- [ ] `force_sid` im Staging-Browser serverseitig geklärt
