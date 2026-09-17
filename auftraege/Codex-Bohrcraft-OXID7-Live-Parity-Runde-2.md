# Codex-Auftrag: Bohrcraft OXID 7 – Live-Parity Runde 2

## Ziel

Die OXID-7-Migration ist technisch lauffähig und wurde auf das öffentliche Staging ausgerollt. Jetzt soll **nicht erneut grundsätzlich migriert**, sondern die **verbleibenden sichtbaren und interaktiven Unterschiede zwischen Altseite und OXID-7-Staging systematisch gefunden und beseitigt** werden.

Referenz:

- Alt / OXID 4: `https://www.bohrcraft.de/`
- Neu / OXID 7 Staging: `https://bcraft.co-de.de/`

Die alte Seite ist die visuelle und interaktive Referenz. OXID 7, APEX, Twig, Bootstrap 5 und die vorhandenen OXID-7-Funktionen bleiben die technische Basis.

## Wichtig: vorhandenen Stand respektieren

Es existiert bereits die erste Visual-Parity-Umsetzung, u. a. in:

- `migration/oxid4-to-oxid7/port/source/Application/views/bohrcraft/`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/css/`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/src/js/`
- `migration/oxid4-to-oxid7/visual-parity.md`

Vorhandene Dateien umfassen insbesondere:

- `bohrcraft-tokens.css`
- `bohrcraft-layout.css`
- `bohrcraft-navigation.css`
- `bohrcraft-cms.css`
- `bohrcraft-components.css`
- `bohrcraft-responsive.css`
- `bohrcraft-navigation.js`
- `bohrcraft-animations.js`
- `bohrcraft-external.js`

Diese Arbeit **nicht wegwerfen und nicht neu anfangen**. Erst analysieren, warum der Live-Stand trotz der lokalen Verifikation noch Unterschiede zeigt.

## Umgebungen

### Lokal Windows

OXID 4:
`D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs`

OXID 7 Projektroot:
`D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft`

OXID 7 DocumentRoot:
`D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft\source`

Lokale URL:
`http://local.bohrcraft-oxid7.de/`

### Linux Staging

Projektroot:
`/var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft`

DocumentRoot:
`/var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft/source`

Composer:
`php /var/www/www.bohrcraft.de/composerphar/composer_v2_9.phar`

Staging:
`https://bcraft.co-de.de/`

Apache/PHP Runtime-User:
`www-data:www-data`

`source/tmp` muss für `www-data` schreibbar bleiben.

## Aktueller technischer Status

Das Linux-Deployment ist erfolgreich bis 10/10 durchgelaufen:

- Modul `bohrcraft_contact` installiert und aktiv
- Theme `bohrcraft` aktiv
- Composer Autoload erzeugt
- OXID Cache gelöscht
- `https://bcraft.co-de.de/` liefert HTTP 200
- `force_sid` wurde geprüft: im von Curl gelieferten HTML gibt es keine `force_sid`-Links
- Apache läuft als `www-data`
- `source/tmp` wurde auf `www-data:www-data` gesetzt

Damit bitte **keine Session-/force_sid-Baustelle erfinden**, solange die Browseranalyse keinen reproduzierbaren Fehler zeigt.

---

# 1. Echte Live-zu-Live-Analyse durchführen

Nicht nur lokalen Stand oder Quellcode vergleichen.

Mit Browser/Playwright beide Seiten parallel prüfen:

- `https://www.bohrcraft.de/`
- `https://bcraft.co-de.de/`

Mindestens folgende Viewports:

- 390x844
- 768x1024
- 1440x900
- 1920x1080

Jeweils:

- Above-the-fold Screenshot
- Ganzseitenscreenshot
- Header/Navi
- geöffnete Menüs
- Sprachumschaltung
- Sliderzustände
- Hoverzustände
- Sticky Header nach Scroll
- Footer
- repräsentative CMS-Unterseiten

Screenshots nach:
`migration/oxid4-to-oxid7/evidence/live-parity-round2/`

Nicht in Git einchecken, wenn dort bereits die bisherige Evidenz bewusst ausgeschlossen ist.

---

# 2. Sprache / Sprachumschaltung hat hohe Priorität

Der aktuelle Header verwendet weiterhin:

```twig
{{ include_widget({ cl: "oxwLanguageList", ... }) }}
```

Das ist funktional okay, aber die sichtbare Darstellung/Interaktion muss der alten Bohrcraft-Seite entsprechen.

Prüfen:

- Position Desktop
- Position Mobile
- DE/EN Darstellung
- aktive Sprache
- Hover/Fokus
- Dropdown bzw. Umschaltverhalten
- Pfeile/Icons
- Abstände
- Schrift
- Hintergrund/Rahmen
- URL beim Umschalten
- Verhalten auf Unterseiten
- Verhalten auf CMS-Seiten
- Verhalten auf Produkt-/Kategorieseiten

OXID-Sprachlogik nicht neu implementieren. Falls nötig, nur das Widget-Template im Child-Theme überschreiben.

Keine hart codierten Sprach-URLs bauen, wenn OXID die korrekte Sprach-URL bereits liefern kann.

---

# 3. Animationen exakt prüfen

Die aktuelle Datei `bohrcraft-animations.js` behandelt im Wesentlichen nur den Startseiten-Carousel.

Das reicht offensichtlich noch nicht für vollständige Live-Parity.

Altseite im Browser beobachten und katalogisieren:

- Startseitenslider
- Übergangsrichtung
- Geschwindigkeit
- Pause zwischen Slides
- Fade vs. Slide
- Navigation/Indikatoren
- Hover-Pause
- Touch
- Header-/Sticky-Verhalten
- Megamenü Ein-/Ausblendung
- Mobile Navigation
- Untermenü-Auf-/Zuklappen
- Kachel-Hover
- Bild-Hover
- Link-/Button-Hover
- mögliche Scroll-/Reveal-Effekte
- Markenmenü
- Sprachumschalter
- Footer-Interaktionen

Für jeden sichtbaren Effekt dokumentieren:

1. Altseite: Trigger
2. Altseite: Dauer
3. Altseite: easing
4. Altseite: Endzustand
5. OXID 7 aktuell
6. notwendige Korrektur

Keine jQuery-/FlexSlider-/PushMenu-Abhängigkeiten zurückholen, nur das sichtbare Verhalten modern nachbauen.

Bevorzugt:

- CSS transitions/keyframes
- Vanilla JS
- IntersectionObserver
- Bootstrap-5-APIs, wenn bereits vorhanden

`prefers-reduced-motion` weiter respektieren.

---

# 4. Navigation/Header erneut live vergleichen

Prüfen und korrigieren:

- Gesamthöhe Header
- Logo-Größe/-Position
- Slogan
- Profi Plus / Profi Basic Logos
- vertikale Ausrichtung
- Navigationshöhe
- Menüpunkte
- Abstände
- aktive Zustände
- Hover
- Megamenü-Breite
- Megamenü-Position
- Schatten
- Ein-/Ausblendung
- Markenmenü
- Sticky Header
- Übergang normal -> sticky
- Mobile Burger
- Mobile Untermenüs
- Escape
- Außenklick
- Tastatur/Fokus

Die vorhandene `bohrcraft-navigation.js` weiterentwickeln statt unnötig eine zweite Navigation einzuführen.

---

# 5. CSS-Parity auf Unterseiten prüfen

Nicht nur die Startseite.

Mindestens:

## Start
- DE
- EN

## Marken
- Übersicht
- Bohrcraft
- Profi Plus
- Profi Basic

## Produkte
- Produktübersicht
- Kategorie
- Unterkategorie
- Artikeldetail

## Service
- Downloads
- Anwendungen
- Katalog
- Videos / OXOMI

## Unternehmen
- Profil
- Qualität
- Karriere

## Kontakt
- Übersicht
- Inland
- Ausland
- Support
- Team
- Kontaktformular
- Anfahrt

## Rechtliches
- Impressum
- AGB
- Datenschutz

Auf jeder Seite vergleichen:

- Inhaltsbreite
- Schriftfamilie
- Fontgrößen
- Zeilenhöhen
- Überschriften
- Textfarben
- Hintergrundfarben
- Abstände
- Raster
- Bilder
- Tabellen
- Buttons
- Links
- Panels/Kacheln
- Footer-Anschluss
- responsive Umbrüche

Insbesondere alte CMS-Klassen weiter berücksichtigen.

---

# 6. Preload-Warnung sauber beheben

Auf Staging erscheint derzeit in Chrome:

```text
The resource https://bcraft.co-de.de/out/bohrcraft/src/js/scripts.min.js
was preloaded using link preload but not used within a few seconds from the window's load event.
```

Ursache wurde bereits lokalisiert:

APEX:

`source/Application/views/apex/tpl/layout/base.html.twig`

enthält:

```twig
<link rel="preload"
      href="{{ oViewConf.getResourceUrl('js/scripts.min.js')|raw }}"
      as="script">
```

und später:

```twig
{{ script({ include: 'js/scripts.min.js', dynamic: __oxid_include_dynamic }) }}
```

Wichtig:

- **APEX-Parent nicht ändern**
- **vendor nicht ändern**
- falls der Preload auf Bohrcraft keinen Nutzen hat, im Child-Theme sauber überschreiben
- falls das Script tatsächlich benötigt wird, Ursache klären, warum der Browser Preload und spätere Nutzung nicht als identische Ressource betrachtet
- `as="script"`, URL, dynamische Ausgabe, Querystrings und ggf. `crossorigin` vergleichen
- Lösung muss nach Cache-Clear in Chrome ohne diese Warnung funktionieren

Keine Änderung nur zum „Verstecken“ der Meldung.

---

# 7. Browser-Konsole muss sauber werden

Auf allen Kernseiten prüfen:

- Errors: 0
- relevante Warnings: 0

Ausnahmen nur dokumentieren, wenn eindeutig extern/unvermeidbar.

Besonders prüfen:

- scripts.min.js preload
- Bootstrap
- Content Security Policy
- Mixed Content
- 404 Assets
- Fonts
- Bilder
- OXOMI
- YouTube
- Maps
- JS doppelt geladen
- Event Listener doppelt registriert

---

# 8. Keine Doppel-Ladung von CSS/JS

Netzwerk- und DOM-Analyse:

- `styles.min.css`
- `bohrcraft.css`
- alle `bohrcraft-*.css`
- `scripts.min.js`
- Bootstrap
- `bohrcraft-navigation.js`
- `bohrcraft-animations.js`
- `bohrcraft-external.js`

Prüfen:

- wird etwas doppelt geladen?
- wird APEX JS durch Child-Theme versehentlich zweimal eingebunden?
- gibt es alte `<script>`-Referenzen in CMS-Inhalten?
- gibt es CSS-Imports plus direkte Includes derselben Datei?

Danach nur eine klare Ladequelle je Asset.

---

# 9. Live-Assets und Cache-Busting

Der Einstieg `bohrcraft.css` enthält aktuell feste Versionsparameter wie:

```css
@import url("bohrcraft-tokens.css?v=20260916-2");
```

Prüfen, ob der Live-Browser wirklich die aktuelle Version bekommt.

Falls sinnvoll:

- konsistentes Cache-Busting herstellen
- keine manuell veraltenden Datumsstrings in sechs Einzelimports
- vorhandene OXID Asset-/Versionierungsmechanismen bevorzugen

Nach Deployment:

- OXID Cache löschen
- Browser mit Disable Cache testen
- Response Header / ETag / Last-Modified prüfen
- sicherstellen, dass Staging tatsächlich die neue Datei ausliefert

---

# 10. Linux-Deployment berücksichtigen

Bestehendes Deployment-Skript darf erweitert werden.

Anforderungen:

- Projektcode darf `root:root` bleiben
- `source/tmp` muss am Ende des Deployments `www-data:www-data` gehören
- Verzeichnisse in `source/tmp`: 775
- Dateien in `source/tmp`: 664
- niemals pauschal 777
- Composer:
  `php /var/www/www.bohrcraft.de/composerphar/composer_v2_9.phar`
- Modul `bohrcraft_contact` idempotent installierbar/aktivierbar
- vorhandenen OXID-Modul-Symlink sicher behandeln
- Theme aktivieren
- Cache löschen
- HTTP-Smoke-Test

Nicht blind andere Runtime-Verzeichnisse umchownen.

---

# 11. Technische Grenzen

Nicht erlaubt:

- Änderungen in `vendor/`
- Änderungen direkt im APEX-Parent
- OXID-Core-Hacks
- Bootstrap 3 als Runtime-Abhängigkeit wieder einführen
- jQuery nur für alte Animationen wieder einführen
- FlexSlider wieder einführen
- PushMenu wieder einführen
- Funktionsverluste im Kontaktmodul
- Consent-Gating entfernen
- OXOMI/YouTube/Maps ungefragt automatisch laden
- hart codierte Session-IDs
- pauschales `chmod 777`

---

# 12. Tests nach jeder relevanten Änderung

Automatisieren, soweit sinnvoll:

- PHP lint
- JS Syntax
- HTTP 200
- Browserconsole
- horizontales Overflow
- Sprache DE -> EN -> DE
- Menü Desktop
- Menü Mobile
- Sticky
- Slider autoplay
- Slider manuell
- Slider hover pause
- Slider touch
- Kontaktformular Pflichtfelder
- YouTube Consent
- Maps Consent
- OXOMI Consent
- Downloads/PDF
- repräsentative Produktseite

---

# 13. Abschlussdokumentation

`migration/oxid4-to-oxid7/visual-parity-round2.md`

muss enthalten:

- tatsächlich gefundene Live-Abweichungen
- Ursache je Abweichung
- geänderte Dateien
- Vorher/Nachher-Messwerte
- Browser-/Viewport-Matrix
- Animationen vorher/nachher
- Sprachumschaltung vorher/nachher
- Konsolenstatus
- Preload-Warnung: Ursache + Lösung
- verbliebene bewusste Abweichungen
- exakte Deployment-Schritte für Linux
- Commit-Hash

Wichtig: Nicht einfach „alles stimmt“ behaupten. Nur Punkte als erledigt markieren, die auf **`bcraft.co-de.de` nach dem echten Deployment** verifiziert wurden.

---

# Definition of Done

- [ ] Live-Altseite und Live-Staging systematisch verglichen
- [ ] Sprachumschaltung sichtbar und funktional an Altseite angeglichen
- [ ] relevante Animationen der Altseite inventarisiert
- [ ] relevante Animationen im OXID-7-Theme nachgebildet
- [ ] Header/Navi/Megamenü live angeglichen
- [ ] repräsentative Unterseiten live angeglichen
- [ ] Desktop, Tablet und Mobile geprüft
- [ ] `scripts.min.js` Preload-Warnung geklärt und beseitigt
- [ ] Browserconsole auf Kernseiten sauber
- [ ] keine Doppel-Ladung von Bohrcraft Assets
- [ ] OXID/APEX/Modul/Consent weiterhin funktionsfähig
- [ ] Linux-Deployment wiederholbar
- [ ] `source/tmp` nach Deployment korrekt für `www-data` beschreibbar
- [ ] finaler Check direkt auf `https://bcraft.co-de.de/`
- [ ] Dokumentation `visual-parity-round2.md`
- [ ] sauberer Git-Commit

## Erwartete Arbeitsweise

Nicht nach dem ersten sichtbaren Unterschied stoppen.

Den kompletten Auftrag in einem Durchgang bearbeiten, testen, deploybaren Stand herstellen und am Ende eine kompakte Ergebnisliste mit Commit-Hash liefern.
