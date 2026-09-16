# Codex-Auftrag: Bohrcraft vollständig von OXID 4 / Flow / Smarty auf OXID 7 / APEX / Twig portieren

## Ziel

Die bestehende Bohrcraft-Webseite soll lokal **vollständig von OXID 4 auf OXID 7 portiert** werden.

Der Auftrag umfasst nicht nur ein neues Theme, sondern die komplette funktionale und optische Übernahme der bestehenden OXID-4-Webseite auf die vorhandene OXID-7-Installation.

Die Umsetzung soll **in einem zusammenhängenden Durchgang** erfolgen.

Nicht nach einzelnen Teilaufgaben auf Freigabe warten.

Erst stoppen, wenn die lokale OXID-7-Version funktional und optisch soweit wie möglich der bestehenden Bohrcraft-Seite entspricht und die wichtigen Sonderfunktionen ebenfalls portiert und getestet wurden.

---

# 1. Verbindliche Ausgangsdaten

## Produktive Referenzseite

Die aktuelle OXID-4-Webseite ist erreichbar unter:

```text
https://www.bohrcraft.de
```

Diese Seite ist **nur Referenz** für:

- Aussehen
- Seitenstruktur
- Navigation
- Inhalte
- responsive Verhalten
- externe Einbindungen
- Formulare
- funktionales Verhalten

Keine Änderungen am Produktivsystem durchführen.

---

## Lokale OXID-4-Version

Webroot:

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs
```

Das aktuelle Bohrcraft-Theme basiert auf FLOW und befindet sich unter:

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs\application\views\bohrcraft_2
```

Diese Installation ist die wichtigste technische Referenz für die bisherige Implementierung.

Sie darf analysiert werden.

Keine unnötigen Änderungen an der OXID-4-Version vornehmen.

---

## Lokale OXID-7-Version

Webroot:

```text
D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs
```

Lokale URL:

```text
local.bohrcraft-oxid7.de
```

Zu Beginn feststellen, ob die lokale Seite über HTTP oder HTTPS angesprochen wird, und anschließend die tatsächlich funktionierende URL verwenden.

---

## Datenbanken

Bereits bekannte Datenbanken:

```text
OXID 4 Quelle:
bohr_oxid4

OXID 7 Ziel:
bohrcraft_oxid7
```

Die OXID-4-Datenbank ist weiterhin als Quelle zu behandeln.

Keine destruktiven Änderungen an:

```text
bohr_oxid4
```

vornehmen.

Falls die Datenbankmigration aus dem vorangegangenen Auftrag bereits abgeschlossen wurde, darauf aufbauen und diese nicht unnötig neu durchführen.

Vor Änderungen an `bohrcraft_oxid7` einen aktuellen Dump erstellen.

---

# 2. Grundprinzip der Portierung

Die neue Bohrcraft-Version soll technisch auf:

```text
OXID 7
APEX
Twig
Bootstrap 5 / aktuelle APEX-Frontendstruktur
```

basieren.

Die alte Seite basiert auf:

```text
OXID 4
FLOW
Smarty
```

Es soll **kein altes FLOW-Theme künstlich unter OXID 7 weiterbetrieben werden**.

Stattdessen:

> Eine saubere Bohrcraft-Version auf Basis des installierten APEX-Themes erstellen und die fachlich sowie optisch benötigten Anpassungen aus `bohrcraft_2` gezielt auf APEX/Twig übertragen.

---

# 3. Zuerst Umgebung vollständig inventarisieren

Vor Änderungen bitte dokumentieren:

```text
OXID-4-Version:
OXID-7-Version:
PHP OXID 4:
PHP OXID 7:
Composer-Version:
Node-Version:
npm-Version:
Datenbank-Version:
installierte APEX-Version:
aktive Themes:
aktive Module:
```

Insbesondere aus:

```text
D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\composer.json
D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\composer.lock
```

die exakte OXID- und APEX-Version ermitteln.

Die neue Bohrcraft-Theme-Version muss zur tatsächlich installierten APEX-Version passen.

Nicht anhand einer angenommenen OXID-Version arbeiten.

---

# 4. Git prüfen

Vor Änderungen im OXID-7-Projekt:

```bash
git status
git branch --show-current
git log -5 --oneline
```

Bestehende Änderungen nicht überschreiben.

Keine fremden Dateien löschen.

Keine Zugangsdaten, Dumps mit Kundendaten oder Secrets einchecken.

---

# 5. Vollständige Analyse des alten Themes `bohrcraft_2`

Das Verzeichnis:

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs\application\views\bohrcraft_2
```

vollständig untersuchen.

Nicht nur die Dateien betrachten, die offensichtlich geändert aussehen.

Erfassen:

- `theme.php`
- Templates
- Blöcke
- Smarty-Vererbung
- Includes
- CSS
- SCSS/LESS, falls vorhanden
- JavaScript
- Bilder
- Icons
- Fonts
- Sprachdateien
- Theme-Konfiguration
- eigene Smarty-Funktionen
- eigene Includes
- Inline-JavaScript
- externe Skripte
- externe Stylesheets

Dann gegen das ursprüngliche FLOW-Theme der installierten OXID-4-Version vergleichen.

Ziel:

> Herausfinden, welche Dateien tatsächlich Bohrcraft-spezifisch sind und welche nur unveränderte FLOW-Kopien darstellen.

Eine Datei-/Funktions-Matrix erstellen:

```text
Datei alt
FLOW-Original
Bohrcraft geändert?
Zweck
APEX-Ziel
Portierungsstatus
```

Nicht blind das komplette alte Theme konvertieren.

Nur benötigte Bohrcraft-Anpassungen in die neue APEX-Struktur übernehmen.

---

# 6. Neue Bohrcraft-Version als APEX-Child-Theme

Eine eigene Theme-Version mit ID vorzugsweise:

```text
bohrcraft
```

erstellen.

Das Theme soll ein echtes OXID-Child-Theme des installierten APEX-Themes sein.

Konzeptionell:

```php
'parentTheme' => 'apex'
```

und die tatsächlich installierte APEX-Version bei `parentVersions` berücksichtigen.

Wichtig:

- APEX nicht direkt verändern
- keine Dateien unter `vendor/` verändern
- nur tatsächlich benötigte APEX-Templates überschreiben
- APEX-Verzeichnis nicht komplett kopieren
- Theme als eigenes Paket / in der für die vorhandene OXID-7-Installation vorgesehenen Struktur anlegen
- vorhandene Composer-Struktur respektieren

Die exakte Zielposition anhand der bestehenden OXID-7-Installation bestimmen.

---

# 7. Theme-Struktur sauber anlegen

Das neue Bohrcraft-Theme soll mindestens enthalten, soweit benötigt:

```text
theme.php
composer.json
tpl/
out/
de/
en/
package.json
vite.config.js
```

aber nur Dateien anlegen, die nach der real verwendeten APEX-Version tatsächlich benötigt werden.

Assets möglichst über den APEX/Vite-Weg bauen.

Keine unnötigen Kopien erzeugen.

---

# 8. Live-Seite als optische und funktionale Referenz analysieren

Die bestehende Seite:

```text
https://www.bohrcraft.de
```

vor und während der Portierung systematisch untersuchen.

Nicht nur die Startseite ansehen.

Mindestens folgende Bereiche vergleichen:

## Startseite

- Header
- Logo
- Navigation
- mobile Navigation
- Slider / Banner
- Teaser
- Firmenvorstellung
- Kennzahlen / Vorteile
- Marken
- Anwendungstabellen
- YouTube-Inhalt
- Innovationen
- Aktionen / Promotions
- Katalog
- Footer

## Marken

```text
Brands / Marken
```

mit den Bereichen:

- Profi Plus
- Profi Basic
- Bohrcraft

## Produkte

- Werkzeugprogramm
- Produktübersicht / Summary
- Produktkategorien
- Unterkategorien
- Produktdarstellung, sofern vorhanden
- technische Inhalte

## Service

- Downloads / Online-Blättern / News
- Anwendungstabellen & Empfehlungen
- Kataloganforderung
- Videos

## Unternehmen

- Unternehmensprofil
- Qualität
- Karriere / Ausbildung

## Kontakt

- Vertrieb national
- Vertrieb international
- Vertriebsunterstützung
- Team
- Anfrageformular
- Anfahrt

## Rechtliches

- Impressum
- AGB
- Datenschutz

Die alte lokale OXID-4-Version bleibt dabei die technische Referenz, die produktive Seite die optische/funktionale Referenz.

---

# 9. Zweisprachigkeit vollständig erhalten

Die bestehende Webseite hat deutsch- und englischsprachige Inhalte.

Beide Sprachen müssen vollständig übernommen werden.

Prüfen:

- Navigation
- CMS-Inhalte
- Kategorien
- Seitentitel
- Buttons
- Formulare
- Fehlermeldungen
- Footer
- Meta-Daten
- individuelle Theme-Sprachtexte

Neue Theme-Sprachdateien nach OXID-7-/APEX-Konvention erstellen.

Bei einem Child-Theme vorhandene APEX-Texte nicht duplizieren, sondern nur benötigte Anpassungen in den vorgesehenen Custom-Language-Dateien hinterlegen.

---

# 10. Smarty vollständig nach Twig portieren

Alle Bohrcraft-relevanten Smarty-Templates analysieren und nach Twig übertragen.

Dabei nicht nur Dateiendungen ersetzen.

Beispiele alter Smarty-Konstrukte suchen:

```text
[{$...}]
[{if ...}]
[{else}]
[{foreach ...}]
[{include ...}]
[{assign ...}]
[{capture ...}]
[{oxcontent ...}]
[{oxmultilang ...}]
[{oxgetseourl ...}]
[{oxscript ...}]
[{oxstyle ...}]
[{oxeval ...}]
[{oxifcontent ...}]
[{oxhasrights ...}]
[{oxid_include_widget ...}]
```

Passende Twig-/OXID-7-Syntax verwenden.

Der offizielle OXID `smarty-to-twig-converter` darf als Hilfsmittel eingesetzt werden.

ABER:

> Das Ergebnis des Konverters niemals ungeprüft übernehmen.

---

# 11. Bekannte Smarty→Twig-Probleme ausdrücklich prüfen

Nach automatischer oder manueller Konvertierung mindestens folgende Fälle gezielt prüfen:

## Autoescaping

Twig escaped standardmäßig Variablen.

`|raw` nur dort verwenden, wo tatsächlich vertrauenswürdiger HTML-Inhalt gerendert werden soll.

Kein pauschales Abschalten des Escapings.

---

## Variablen-Scope

Twig-Variablen haben in:

```text
blocks
for
if
```

andere Scope-Eigenschaften als alte Smarty-Konstrukte.

Alle Variablen prüfen, die innerhalb eines Blocks gesetzt und später außerhalb verwendet werden.

---

## Duplicate Blocks

Twig erlaubt keine problematischen mehrfachen Blockdefinitionen.

Alte Smarty-Vererbungslogik gegebenenfalls neu strukturieren.

---

## Arrayzugriffe

Dynamische Smarty-Zugriffe korrekt nach Twig portieren.

Beispiel sinngemäß:

```text
$myArray.$itemIndex
```

muss als echter dynamischer Twig-Arrayzugriff umgesetzt werden.

---

## NULL / nicht vorhandene Properties

Alte Smarty-Abfragen auf möglicherweise nicht vorhandene OXID-Felder dürfen in Twig keine Methodenaufrufe auf vermeintlichen Properties auslösen.

Defensive Prüfungen verwenden.

---

## reguläre Ausdrücke

Regex-Konstrukte nach Konvertierung manuell prüfen.

---

## Smarty `section`

Alte `section`-Schleifen nicht blind übernehmen.

Sauber in Twig-`for`-Logik überführen.

---

# 12. Besonders wichtig: Smarty in Datenbankinhalten / `oxcontents`

Das ist ein zentraler Teil des Auftrags.

Die bestehende OXID-4-Seite kann Smarty-Code **nicht nur in Template-Dateien**, sondern auch direkt in Datenbankinhalten enthalten.

Insbesondere untersuchen:

```text
oxcontents.OXCONTENT
oxcontents.OXCONTENT_1
oxcontents.OXCONTENT_2
oxcontents.OXCONTENT_3
```

und alle tatsächlich vorhandenen weiteren Sprachfelder.

Außerdem prüfen:

```text
oxactions.OXLONGDESC*
oxartextends.OXLONGDESC*
oxcategories.OXLONGDESC*
```

sowie Bohrcraft-spezifische Text-/HTML-Felder.

---

# 13. Smarty-Vorkommen in der kompletten Datenbank suchen

Auf:

```text
bohrcraft_oxid7
```

alle relevanten TEXT-/MEDIUMTEXT-/LONGTEXT-/VARCHAR-Felder auf Smarty-Syntax untersuchen.

Typische Suchmuster:

```text
[{
[{$
[{if
[{foreach
[{include
[{assign
[{capture
[{literal
[{ox
[{/if
[{/foreach
```

Zusätzlich suchen nach:

```text
oxcontent
oxeval
oxmultilang
oxscript
oxstyle
oxgetseourl
oxid_include_widget
```

Ergebnis als Report ablegen.

Beispiel:

```text
Tabelle
Spalte
OXID / Primärschlüssel
Sprache
gefundenes Smarty-Konstrukt
Portierungsstatus
```

---

# 14. Datenbank-Konvertierung nur auf OXID-7-Ziel

Falls der offizielle OXID Smarty-to-Twig-Konverter für Datenbankinhalte eingesetzt wird:

NIEMALS gegen:

```text
bohr_oxid4
```

laufen lassen.

Nur gegen:

```text
bohrcraft_oxid7
```

und vorher einen Dump anlegen.

Der Konverter unterstützt u. a. OXID-Datenbankfelder wie:

```text
oxcontents.OXCONTENT*
oxactions.OXLONGDESC*
oxartextends.OXLONGDESC*
oxcategories.OXLONGDESC*
```

Zusätzliche Bohrcraft-Felder gegebenenfalls gezielt über `--database-columns` berücksichtigen.

Konvertierung reproduzierbar dokumentieren bzw. skripten.

---

# 15. `oxcontents` anschließend manuell prüfen

Nach der automatischen Konvertierung jedes `oxcontents`-Element mit konvertierter Syntax prüfen.

Insbesondere:

- Twig-Syntax valide?
- HTML unverändert?
- JavaScript unverändert?
- Links unverändert?
- Sprachversionen korrekt?
- Includes funktionieren?
- `oxcontent` korrekt zu `include_content` konvertiert?
- `oxeval` korrekt umgesetzt?
- externe Einbindungen noch funktionsfähig?
- keine Smarty-Reste vorhanden?

Am Ende automatisiert prüfen, ob relevante Smarty-Syntax in der OXID-7-Datenbank übrig geblieben ist.

Restvorkommen klassifizieren als:

```text
echter Fehler
bewusstes Textbeispiel
False Positive
noch offen
```

---

# 16. Rendering von CMS-Inhalten korrekt behandeln

APEX/Twig verwendet für CMS-Inhalte die OXID-7-Mechanismen.

Nicht einfach ungeparstes HTML ausgeben.

Bestehende OXID-Mechanismen wie sinngemäß:

```twig
{{ oView.getParsedContent()|raw }}
```

verwenden, sofern dies der installierten OXID/APEX-Version entspricht.

Wichtig:

`|raw` nur für den von OXID geparsten, vertrauenswürdigen CMS-Inhalt einsetzen.

Keine allgemeinen Benutzereingaben ungeescaped ausgeben.

---

# 17. YouTube-Videos in Content vollständig übernehmen

Die aktuelle Bohrcraft-Seite verwendet YouTube-Inhalte.

Auf der Live-Seite ist unter anderem eine Einbindung über:

```text
youtube-nocookie.com
```

vorhanden.

Alle YouTube-Einbindungen suchen in:

- `oxcontents`
- Kategorien
- Langtexten
- Aktionen
- Smarty-Templates
- JavaScript
- sonstigen Bohrcraft-Quelldateien

Prüfen:

- iframe-URLs
- `youtube-nocookie.com`
- responsive Darstellung
- Breite/Höhe
- Seitenverhältnis
- Lazy Loading
- Consent-Verhalten
- deutsch/englisch
- mehrere Videos auf einer Seite

Die Videos müssen unter OXID 7/Twig wieder funktionieren.

Keine Umstellung auf normale `youtube.com`-Embeds, wenn bisher bewusst die No-Cookie-Domain verwendet wird.

---

# 18. Externe Inhalte datenschutzgerecht behandeln

Externe Inhalte dürfen nicht durch die Portierung plötzlich ungefragt geladen werden.

Bestehendes Consent-Verhalten untersuchen und erhalten.

Besonders:

- YouTube
- OXOMI
- Google Maps
- sonstige Drittanbieter

Keine externe Verbindung auslösen, bevor sie nach dem auf der Altseite vorgesehenen Verfahren zulässig ist.

Wenn die bisherige Umsetzung technisch veraltet ist, darf sie modernisiert werden, aber das fachliche Consent-Verhalten muss erhalten bleiben.

---

# 19. OXOMI vollständig übernehmen

Die bestehende Seite verwendet OXOMI von scireum.

Der aktuelle Download-/Katalogbereich zeigt externe OXOMI-Inhalte erst nach Zustimmung.

Bitte in OXID 4 und in der Datenbank gezielt suchen nach:

```text
oxomi
OXOMI
scireum
portal
catalog
catalogue
katalog
```

Untersuchen:

- wo das OXOMI-Script geladen wird
- welche IDs / Portalparameter verwendet werden
- ob die Einbindung direkt im `oxcontents` steht
- ob Smarty zur Script-Erzeugung benutzt wird
- wie Consent gespeichert wird
- wie die Einbindung in DE/EN funktioniert
- ob mehrere OXOMI-Bereiche existieren

---

# 20. OXOMI unter Twig sauber umsetzen

Zielverhalten:

1. Seite öffnet ohne unerlaubtes Nachladen externer OXOMI-Ressourcen.
2. Hinweis auf externen Inhalt wird angezeigt.
3. Benutzer kann zustimmen oder ablehnen.
4. Erst nach Zustimmung wird OXOMI initialisiert.
5. Kataloge / Aktionen / Dokumente werden korrekt angezeigt.
6. Script wird nicht mehrfach geladen.
7. Mehrfaches Navigieren führt nicht zu JS-Fehlern.
8. Mobile Darstellung funktioniert.

Falls sinnvoll, technische OXOMI-Initialisierung aus `oxcontents` in eine saubere Twig-/JS-Komponente auslagern.

Die Inhalte selbst sollen weiterhin redaktionell über CMS steuerbar bleiben, sofern dies bisher der Fall ist.

---

# 21. Bestehende Kontakt- und Anfrageformulare übernehmen

Die bestehende Seite enthält ein umfangreiches Kontakt-/Anfrageformular.

Funktional mindestens prüfen:

- Vorname
- Nachname
- Firma
- Straße
- PLZ
- Ort
- Land
- Telefon
- E-Mail
- Kundentyp
- Nachricht
- Datenschutz-Zustimmung
- CAPTCHA / Bot-Schutz, sofern lokal vorhanden
- Pflichtfeldvalidierung
- Fehlermeldungen
- Versand / Verarbeitung

Die Formularlogik nicht allein über das Theme nachbauen, wenn dafür bestehende Controller/Module verantwortlich sind.

Erst vorhandene OXID-4-Implementierung analysieren.

Notwendige PHP-/Controller-/Modul-Anpassungen für OXID 7 sind Teil dieses Gesamtauftrags.

---

# 22. Alle alten Sonderanpassungen außerhalb des Themes finden

Nicht davon ausgehen, dass alles unter `bohrcraft_2` liegt.

Im gesamten OXID-4-Webroot suchen nach Bohrcraft-spezifischen Änderungen:

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs
```

Insbesondere:

- eigene Module
- Core-Erweiterungen
- Controller
- Models
- Widgets
- Smarty-Plugins
- PHP-Helfer
- AJAX-Endpunkte
- Kontaktformularlogik
- Captcha
- Navigation
- Sprachumschaltung
- SEO-Anpassungen
- Consent
- OXOMI
- YouTube
- Google Maps
- Downloads
- PDF-Links

Auch nach Referenzen auf:

```text
bohrcraft_2
bohrcraft
oxomi
youtube
youtube-nocookie
maps
contact
captcha
```

suchen.

---

# 23. Keine alten Core-Hacks übernehmen

Falls die OXID-4-Installation veränderte OXID-Core-Dateien enthält:

Nicht nach OXID 7 kopieren.

Stattdessen:

1. Änderung identifizieren
2. fachlichen Zweck verstehen
3. OXID-7-kompatibel als:
   - Modul
   - Service
   - Controller-Erweiterung
   - Theme-Anpassung
   - Event
   - Twig-Erweiterung
   umsetzen

---

# 24. Navigation vollständig nachbilden

Die bestehende Hauptnavigation und deren Hierarchie muss erhalten bleiben.

Aktuelle Hauptbereiche:

```text
Marken / Brands
Produkte / Products
Service
Unternehmen / Company
Kontakt / Contact
```

Untermenüs und verschachtelte Ebenen ebenfalls übernehmen.

Besonders mobile Navigation testen.

Nicht nur Desktop nachbauen.

---

# 25. Startseite exakt untersuchen

Die Startseite ist kein Standard-APEX-Startlayout.

Alle Bestandteile aus alter lokaler Seite und Live-Seite identifizieren.

Unter anderem:

- Banner / Slider
- Jubiläums-/Headline-Bereich
- Leistungsmerkmale
- Marken-/Teaserblöcke
- Anwendungstabellen
- Video
- Innovationen
- Aktionen
- Katalog
- Kontakt-/Footerbereich

Feststellen, welche Teile aus:

- CMS
- Aktionen
- Kategorien
- Theme-Templates
- Datenbank
- JavaScript

kommen.

Dann passend für OXID 7/Twig nachbauen.

---

# 26. Produktübersicht erhalten

Die vorhandene Produktübersicht enthält zahlreiche Werkzeugbereiche.

Darstellung unter OXID 7 vollständig übernehmen.

Prüfen:

- Kategorie-Icons
- Bilder
- Links
- Sortierung
- Übersetzungen
- Responsive Raster
- Hoververhalten
- Unterkategorien

Keine Inhalte hart in Twig einprogrammieren, wenn sie bisher aus OXID-Daten kommen.

---

# 27. Downloads und PDFs

Alle PDF-/Download-Funktionen übernehmen.

Besonders:

- Anwendungstabellen
- Anwendungsempfehlungen
- Logos
- EPS/JPG-Downloads
- Kataloge
- weitere Dokumente

Prüfen:

- Dateipfade
- vorhandene Dateien
- Sprachabhängigkeit
- Download-Links
- `target`
- Content-Type
- 404

---

# 28. Bilder und Assets übernehmen

Vom alten Theme und der alten Shopinstallation benötigte Dateien übernehmen:

- Logo
- Favicons
- Sliderbilder
- Banner
- Kategorie-/CMS-Grafiken
- Icons
- Downloads
- Hintergrundgrafiken
- Theme-Bilder

Dabei nicht einfach komplette Altverzeichnisse kopieren.

Nur benötigte Assets übernehmen und sauber im neuen Theme bzw. im vorgesehenen OXID-Medienbereich ablegen.

Dateiverweise in CMS-Inhalten ggf. anpassen.

---

# 29. CSS auf APEX / Bootstrap 5 portieren

Nicht das komplette alte FLOW-CSS auf APEX legen.

Vorgehen:

1. altes Bohrcraft-CSS analysieren
2. tatsächliche CI-Regeln extrahieren
3. Layout möglichst mit APEX/Bootstrap-5-Strukturen abbilden
4. nur notwendige Custom-Regeln ergänzen

Erhalten werden sollen:

- Bohrcraft-Farben
- Typografie
- Abstände
- Navigation
- Header/Footer
- Karten
- Teaser
- Formulare
- Responsive Verhalten

Alte Bootstrap-3/4-Klassen nicht blind übernehmen.

---

# 30. JavaScript modernisieren, Verhalten erhalten

Alte JS-Dateien analysieren.

Prüfen auf:

- jQuery-Abhängigkeiten
- Bootstrap-alt APIs
- `.live()`
- `.delegate()`
- alte Eventsyntax
- veraltete Plugins
- globale Variablen
- Inline-Skripte
- document ready
- externe JS-Einbindungen

Wo sinnvoll auf modernes Vanilla-JS bzw. die von APEX verwendeten Mechanismen umstellen.

Fachliches Verhalten erhalten.

---

# 31. Consent / Cookies

Bestehendes Consent-System analysieren.

Prüfen:

- Cookie-Einstellungen
- externe Inhalte
- OXOMI
- YouTube
- Google Maps
- Sprache
- Widerrufsmöglichkeit
- Speicherung der Auswahl

Nicht versehentlich ein zweites konkurrierendes Consent-System daneben bauen.

---

# 32. Google Maps / Anfahrt ebenfalls prüfen

Die aktuelle Datenschutzerklärung beschreibt eine 2-Klick-Lösung für Google Maps.

Daher die alte Seite und Quellen auf Google-Maps-Einbindung prüfen.

Falls vorhanden:

- erst nach Zustimmung laden
- Anfahrt-Seite funktionsfähig halten
- keine API-Keys im Repository speichern
- vorhandene Konfiguration weiterverwenden, soweit technisch zulässig

---

# 33. SEO und URLs

Die Migration soll keine unnötigen URL-Änderungen erzeugen.

Vergleichen:

- CMS-SEO-URLs
- Kategorien
- Produkte
- Sprach-URLs
- canonical URLs
- Meta-Titel
- Meta-Descriptions

Lokale URL muss natürlich auf:

```text
local.bohrcraft-oxid7.de
```

zeigen.

Keine produktive Domain fest in Templates verdrahten.

---

# 34. Template-Verweise und harte Pfade entfernen

Im alten Theme suchen nach:

```text
www.bohrcraft.de
http://
https://
/application/views/
bohrcraft_2
xampp
absolute Windows paths
```

Harte Pfade nur übernehmen, wenn fachlich erforderlich.

OXID-/Twig-Helfer für URLs und Assets verwenden.

---

# 35. APEX-Templates nur gezielt überschreiben

Für jeden Override dokumentieren:

```text
APEX-Datei
Bohrcraft-Datei
Grund des Overrides
betroffene Funktion
```

Wenn etwas durch:

- Theme-Setting
- CSS
- CMS
- Block
- Modul-Template-Extension

lösbar ist, kein unnötiges komplettes Template kopieren.

Ziel:

> Möglichst kleine und wartbare Differenz zu APEX.

---

# 36. Twig-Templates validieren

Alle Twig-Dateien auf Syntaxfehler prüfen.

Zusätzlich lokales Rendering testen.

Keine verbleibenden:

```text
TemplateNotFound
SyntaxError
LoaderError
RuntimeError
unknown function
unknown filter
unknown tag
```

akzeptieren.

---

# 37. APEX Assets korrekt bauen

Falls die installierte APEX-Version Vite/npm verwendet:

- Node-Abhängigkeiten sauber installieren
- vorhandene Lockfiles respektieren
- Theme-Assets bauen
- keine unnötigen globalen npm-Installationen
- Build dokumentieren

Danach prüfen, dass keine 404 auf:

```text
CSS
JS
Fonts
Images
```

auftreten.

---

# 38. Cache nach Änderungen sauber leeren

Nach relevanten Änderungen:

- OXID Cache
- Twig Cache
- generierte Theme-Assets
- ggf. Views

mit den zur installierten OXID-Version passenden Werkzeugen erneuern.

Keine alten OXID-4-Cachedateien übernehmen.

---

# 39. Funktionstest lokal

Nach Abschluss die lokale Seite vollständig testen.

URL:

```text
local.bohrcraft-oxid7.de
```

Mindestens:

## Global

- Startseite
- Header
- Desktop-Navigation
- Mobile-Navigation
- Logo
- Sprachwechsel DE/EN
- Footer
- interne Links

## Marken

- alle Markenbereiche

## Produkte

- Werkzeugprogramm
- Übersicht
- mehrere Produkt-/Kategoriepfade

## Service

- Downloads
- PDFs
- Anwendungstabellen
- Kataloganforderung
- Video-Seite

## Unternehmen

- Unternehmensprofil
- Qualität
- Karriere

## Kontakt

- Vertrieb
- Team
- Formular
- Anfahrt

## Rechtliches

- Impressum
- AGB
- Datenschutz

---

# 40. YouTube-Test

Mindestens testen:

```text
Startseite
Video-Seite
weitere Inhalte mit YouTube
```

Prüfen:

- Consent / Freigabe
- `youtube-nocookie.com`
- responsive Darstellung
- Video startet
- keine Console Errors
- keine vorzeitigen externen Requests, falls Consent erforderlich

---

# 41. OXOMI-Test

Downloads-/Katalogseite testen:

## Vor Zustimmung

- OXOMI noch nicht geladen
- Hinweistexte sichtbar
- Zustimmen / Ablehnen sichtbar

## Nach Zustimmung

- Script lädt
- OXOMI-Inhalt sichtbar
- keine JS-Fehler
- Kataloge funktionieren
- responsive Darstellung

## Sprache

- Deutsch
- Englisch

prüfen.

---

# 42. `oxcontents`-Test

Alle CMS-Inhalte mit konvertierter Smarty-/Twig-Syntax aufrufen.

Besonders die Einträge, in denen gefunden wurden:

- `oxcontent`
- `oxeval`
- `oxmultilang`
- `include`
- YouTube
- OXOMI
- JavaScript
- dynamische URLs

Kein Smarty-Code darf als Text im Browser erscheinen.

Keine Twig-Ausdrücke dürfen als Text im Browser erscheinen.

---

# 43. Browser-Konsole und Netzwerk prüfen

Auf repräsentativen Seiten prüfen:

- JavaScript Errors
- CSP-Fehler
- Mixed Content
- 404
- 500
- blockierte Assets
- doppelt geladene Skripte
- externe Requests vor Consent
- falsche MIME-Types

Relevante Fehler beheben.

---

# 44. PHP-/OXID-Logs prüfen

Während und nach der Portierung kontrollieren:

- Apache Error Log
- PHP Error Log
- OXID Logs

Keine relevanten:

- Fatal Errors
- Exceptions
- Twig Errors
- SQL Errors
- Deprecated-Meldungen aus eigenem portiertem Code

stehen lassen.

Third-Party-Warnings nur dann offen lassen, wenn nicht durch unseren Code verursacht und sauber dokumentiert.

---

# 45. Responsive testen

Mindestens Größenklassen:

```text
Desktop
Tablet
Smartphone
```

Besonders:

- Navigation
- Startseite
- Slider
- Produktübersicht
- YouTube
- OXOMI
- PDFs/Downloadlisten
- Kontaktformulare
- Footer

prüfen.

---

# 46. Vergleich Alt vs. Neu

Für repräsentative Seiten einen Vergleich erstellen:

```text
Seite
OXID 4
OXID 7
Optik
Funktion
Abweichung
Status
```

Status:

```text
OK
bewusst modernisiert
noch zu korrigieren
Blocker
```

Wichtige visuelle Unterschiede vor Abschluss korrigieren.

APEX darf intern moderner sein, aber die Bohrcraft-Identität und Seitenlogik sollen erkennbar erhalten bleiben.

---

# 47. Automatisierte Prüfungen anlegen

Soweit sinnvoll kleine Prüfskripte erstellen für:

- verbleibende Smarty-Tags in Theme-Dateien
- verbleibende Smarty-Tags in DB
- kaputte interne Links
- fehlende Assets
- Twig-Syntax
- wichtige HTTP-Statuscodes
- externe Inhalte / Consent
- CMS-Inhalte mit Sondercode

Diese Skripte unter einem nachvollziehbaren Projektverzeichnis ablegen.

---

# 48. Dokumentationsstruktur

Unter z. B.:

```text
migration/oxid4-to-oxid7/
```

ergänzen bzw. fortführen:

```text
README.md
theme-analysis.md
smarty-to-twig.md
cms-content-conversion.md
external-integrations.md
verification.md
```

Falls bereits eine Datenbank-Migrationsdokumentation aus dem vorherigen Auftrag existiert, diese nicht ersetzen, sondern ergänzen.

---

# 49. Git-Commits

Sinnvolle, nachvollziehbare Commits erstellen.

Beispielsweise:

```text
feat: create bohrcraft apex child theme
feat: port bohrcraft templates from smarty to twig
feat: migrate bohrcraft cms content to twig
feat: port bohrcraft external content integrations
feat: restore bohrcraft site functionality on oxid7
fix: align oxid7 frontend with legacy bohrcraft site
test: verify bohrcraft oxid7 migration
```

Nicht zwingend exakt diese Aufteilung verwenden.

Aber bitte keine einzige chaotische Riesenänderung ohne nachvollziehbare Historie, wenn eine sinnvolle Trennung möglich ist.

---

# 50. Nicht auf Freigabe nach jedem Schritt warten

Der Auftrag soll vollständig abgearbeitet werden.

Nicht stoppen nach:

- Theme-Erstellung
- Smarty-Konvertierung
- `oxcontents`
- OXOMI
- YouTube
- CSS
- Formularen

sondern bis zum End-to-End-Test weiterarbeiten.

Nur bei einem echten Blocker stoppen.

Ein echter Blocker wäre z. B.:

- erforderliche proprietäre Quelle fehlt
- notwendige Zugangsdaten fehlen
- benötigte externe API kann ohne Konfiguration technisch nicht getestet werden
- unumkehrbare fachliche Entscheidung ist aus Quellcode und Live-Seite nicht ableitbar

Bei einem solchen Blocker:

1. vorhandene Arbeit sichern
2. nichts destruktiv improvisieren
3. konkreten Blocker nennen
4. exakte benötigte Information nennen

---

# 51. Definition of Done

Der Auftrag ist erst abgeschlossen, wenn mindestens:

- exakte OXID-7-/APEX-Version ermittelt wurde
- `bohrcraft_2` vollständig analysiert wurde
- Unterschiede zu FLOW dokumentiert wurden
- APEX-Child-Theme `bohrcraft` existiert
- APEX selbst nicht verändert wurde
- relevante Smarty-Templates nach Twig portiert wurden
- OXID-4-Sonderanpassungen außerhalb des Themes gefunden und bewertet wurden
- relevante PHP-Anpassungen OXID-7-kompatibel sind
- `oxcontents` und weitere DB-HTML-Felder auf Smarty geprüft wurden
- Smarty-Code in relevanten DB-Inhalten zu Twig migriert wurde
- keine unbeabsichtigten Smarty-Reste vorhanden sind
- YouTube-Inhalte funktionieren
- `youtube-nocookie.com` soweit bisher verwendet erhalten ist
- OXOMI funktioniert
- OXOMI-Consent funktioniert
- Google-Maps-/externe-Content-Verhalten geprüft ist
- DE/EN funktionieren
- Navigation Desktop/Mobil funktioniert
- Startseite portiert ist
- Produktübersicht funktioniert
- Downloads/PDFs funktionieren
- Kontakt-/Anfragefunktionen funktionieren
- Footer und rechtliche Seiten funktionieren
- Assets sauber gebaut sind
- keine relevanten 404/500 vorhanden sind
- keine relevanten Twig-/PHP-/JS-Fehler vorhanden sind
- responsive Darstellung geprüft wurde
- Alt-/Neu-Vergleich dokumentiert wurde
- Git sauber ist

---

# 52. Abschlussbericht

Am Ende bitte einen ausführlichen Bericht liefern.

## A. Umgebung

```text
Projektroot OXID 4:
Projektroot OXID 7:
OXID 4 Version:
OXID 7 Version:
FLOW Version:
APEX Version:
PHP Version:
Node Version:
```

---

## B. Neues Theme

```text
Theme-ID:
Parent:
Parent-Version:
Installationspfad:
Aktiviert:
```

Auflisten:

- eigene Twig-Dateien
- eigene CSS-/JS-Dateien
- eigene Assets
- Sprachdateien

---

## C. Smarty → Twig

Tabelle:

```text
Bereich | Smarty-Dateien | Twig-Dateien | Status | Hinweise
```

Zusätzlich:

- automatische Converter-Nutzung
- manuelle Korrekturen
- problematische Konstrukte

---

## D. Datenbank / CMS

Tabelle:

```text
Tabelle | Spalte | Treffer Smarty vorher | Treffer danach | Status
```

Besonders:

```text
oxcontents
oxartextends
oxcategories
oxactions
```

sowie Custom-Felder.

---

## E. Externe Einbindungen

Für:

```text
YouTube
OXOMI
Google Maps
sonstige
```

jeweils:

- Fundstelle alt
- neue Implementierung
- Consent-Verhalten
- Testergebnis

---

## F. Funktionsvergleich

```text
Seite/Funktion | Alt | Neu | Status | Abweichung
```

Mindestens:

- Startseite
- Navigation
- mobile Navigation
- Marken
- Produktübersicht
- Downloads
- Anwendungstabellen
- Katalog
- Videos
- Unternehmen
- Kontakt
- Formular
- Anfahrt
- Impressum
- Datenschutz
- DE/EN

---

## G. Tests

Dokumentieren:

- URLs
- HTTP Status
- Browser-Konsole
- PHP Log
- OXID Log
- Twig
- responsive Tests

---

## H. Offene Punkte

Nur echte Restpunkte aufführen.

Für jeden:

```text
Problem
Auswirkung
Grund
nächster Schritt
```

---

## I. Git

```text
Branch:
Commits:
Git Status:
```

Geänderte und neu angelegte Dateien auflisten.

---

# 53. Technische Referenzen

Bei Unsicherheiten bitte die zur **tatsächlich installierten OXID-7-Version** passende offizielle Dokumentation verwenden.

Relevante Themen:

```text
OXID APEX Theme
OXID Child Themes
OXID Twig Template Engine
OXID Smarty-to-Twig Converter
OXID Twig Template Extensions
```

Wichtiger Grundsatz:

> Der Smarty-to-Twig-Converter ist ein Hilfsmittel, kein Ersatz für manuelle Prüfung.

---

# 54. Wichtigster Grundsatz

Die Aufgabe ist keine oberflächliche „neues Theme drauf“-Migration.

Ziel ist:

> Die bestehende Bohrcraft-Webseite fachlich, optisch und funktional vollständig auf eine saubere OXID-7-/APEX-/Twig-Basis zu portieren.

Dabei sollen möglichst viele Standardfunktionen aus APEX genutzt werden.

Bohrcraft-spezifische Anpassungen müssen sauber isoliert bleiben.

Keine Änderungen direkt im APEX-Theme oder unter `vendor/`.

Die produktive Seite `www.bohrcraft.de` dient als Referenz und wird niemals verändert.

## Auftrag vollständig in einem Durchgang umsetzen und erst nach dem End-to-End-Test abschließen.
