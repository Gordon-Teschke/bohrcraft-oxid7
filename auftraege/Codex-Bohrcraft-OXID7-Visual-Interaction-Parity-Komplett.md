# Codex-Auftrag: Bohrcraft OXID 7 – vollständige visuelle und interaktive Angleichung an die bestehende OXID-4-Webseite

## Auftragstyp

Dies ist ein **abschließender Visual-/Interaction-Parity-Pass** für die bereits technisch portierte Bohrcraft-Webseite.

Die bestehende OXID-7-Portierung funktioniert technisch, entspricht aber optisch und bei den JavaScript-Animationen noch deutlich zu wenig der bisherigen Bohrcraft-Webseite.

Dieser Auftrag soll **in einem Durchgang vollständig umgesetzt** werden.

Nicht nach einzelnen Seiten oder Teilbereichen auf Freigabe warten.

---

# 1. Referenzen

## Bestehende produktive OXID-4-Seite

Diese Seite ist die verbindliche Referenz für:

- Erscheinungsbild
- Seitenaufbau
- Größenverhältnisse
- Typografie
- Abstände
- Navigation
- Megamenü
- Slider
- CMS-Layouts
- Animationen
- Hover-Effekte
- Übergänge
- responsive Verhalten
- Footer
- Formulare
- Seitenrhythmus

```text
https://www.bohrcraft.de/
```

Die produktive Webseite ist **read-only**.

Unter keinen Umständen dort Änderungen durchführen.

---

## Neue öffentliche OXID-7-Version / Staging

Diese Version ist der aktuelle Stand der Portierung:

```text
https://bcraft.co-de.de/
```

Sie soll nach Abschluss visuell und interaktiv möglichst nahe an der bestehenden Seite liegen.

---

## Lokale OXID-4-Quelle

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs
```

Altes Bohrcraft-Theme:

```text
D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs\application\views\bohrcraft_2
```

Parent:

```text
FLOW 2.3.0
```

---

## Lokale OXID-7-Version

```text
D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs
```

Lokale URL:

```text
http://local.bohrcraft-oxid7.de
```

Neue technische Basis:

```text
OXID 7.5.1
APEX 3.1.0
Twig
Bootstrap 5
```

---

# 2. Bestehende Migration NICHT neu machen

Die Datenbank- und Funktionsmigration ist bereits abgeschlossen.

Vorhandene Migration:

```text
migration/oxid4-to-oxid7/
```

Vorhandene Portierung:

```text
migration/oxid4-to-oxid7/port/
```

Nicht erneut:

- Datenbank komplett migrieren
- Smarty-Konvertierung komplett neu starten
- Medienmigration neu erfinden
- Kontaktmodul neu schreiben
- OXOMI neu konzipieren
- Consent neu konzipieren

Stattdessen auf dem vorhandenen funktionierenden Stand aufbauen.

Vor Änderungen zuerst lesen:

```text
migration/oxid4-to-oxid7/completion-report.md
migration/oxid4-to-oxid7/theme-analysis.md
migration/oxid4-to-oxid7/verification.md
migration/oxid4-to-oxid7/smarty-to-twig.md
migration/oxid4-to-oxid7/cms-content-conversion.md
migration/oxid4-to-oxid7/external-integrations.md
migration/oxid4-to-oxid7/legacy-special-code.md
```

---

# 3. Warum ein weiterer Pass erforderlich ist

Die bisherige Portierung war technisch erfolgreich, hat aber viele Designentscheidungen bewusst durch APEX ersetzt.

Im bisherigen Abschlussbericht stehen unter anderem sinngemäß:

```text
Layout technisch modernisiert
APEX-Megamenü
mobile Navigation bewusst APEX-nativ
APEX-Raster
APEX-Optik
```

Genau das ist für diesen Auftrag **nicht mehr ausreichend**.

Die bisherige Bohrcraft-Frontend-Schicht ist sehr klein:

```text
src/css/bohrcraft.css
src/js/bohrcraft.js
```

`bohrcraft.js` enthält hauptsächlich:

- Consent
- YouTube laden
- Google Maps laden
- OXOMI laden

Es enthält praktisch keine Nachbildung der alten visuellen Animationen.

Das Ergebnis ist deshalb funktional korrekt, aber optisch und im Bewegungsverhalten noch zu weit von `www.bohrcraft.de` entfernt.

---

# 4. Neues Ziel

Die technische Basis bleibt:

```text
OXID 7
APEX Child Theme
Twig
Bootstrap 5
Vanilla JavaScript
```

Aber:

> Die sichtbare Webseite soll wieder klar wie die bestehende Bohrcraft-Webseite wirken und nicht wie ein nur leicht angepasstes APEX-Theme.

Dabei ist **keine pixelgenaue Kopie um jeden Preis** erforderlich.

Sehr wohl erforderlich ist aber:

- gleiche visuelle Identität
- gleiche Grundgeometrie
- vergleichbare Abstände
- vergleichbare Typografie
- gleicher Seitenrhythmus
- gleiche Art der Navigation
- gleiche CMS-Layouts
- gleiche oder sehr ähnliche Animationen
- gleiche Bildwirkung
- gleiche Hover-Zustände
- gleiche Desktop-/Mobil-Logik

Technisch veraltete Komponenten dürfen modern umgesetzt werden.

Das sichtbare Ergebnis soll aber dem alten Verhalten entsprechen.

---

# 5. Ganz wichtig: nicht nur Screenshots von Startseiten vergleichen

Beide Seiten vollständig untersuchen.

Die vorhandene Webseite besteht überwiegend aus CMS-/Informationsseiten.

Daher ist eine sehr hohe visuelle Übereinstimmung realistisch.

---

# 6. Zuerst reproduzierbare Browseranalyse erstellen

Vor CSS-/JS-Änderungen mit Playwright oder einem vergleichbaren Browserwerkzeug automatisiert beide Seiten erfassen.

## Viewports

Mindestens:

```text
Desktop:    1440 x 900
Laptop:     1280 x 800
Tablet:      768 x 1024
Smartphone:  390 x 844
```

Für jede relevante Seite:

- vollständigen Screenshot alt
- vollständigen Screenshot neu
- Above-the-fold-Screenshot alt
- Above-the-fold-Screenshot neu

erzeugen.

Screenshots dürfen unter einem Evidence-Verzeichnis liegen, sollen aber nicht unnötig das Git aufblasen.

Zum Beispiel:

```text
migration/oxid4-to-oxid7/evidence/visual/
```

Bei großen Binärmengen ggf. `.gitignore` verwenden und nur die Vergleichsdokumentation committen.

---

# 7. Browserzustände ebenfalls erfassen

Nicht nur statische Seiten.

Zusätzlich Screenshots / DOM-Zustände erfassen für:

- Navigation geschlossen
- Navigation geöffnet
- Megamenü geöffnet
- Hover auf Hauptnavigation
- Hover auf Teaser/Kacheln
- Slider vor/nach Wechsel
- Seite nach Scroll
- mobile Navigation geöffnet
- YouTube vor Freigabe
- YouTube nach Freigabe
- OXOMI vor Zustimmung
- OXOMI nach Zustimmung
- Maps vor Klick
- Maps nach Klick
- Kontaktformular
- Formularvalidierung

---

# 8. Vollständige Seitenmatrix

Mindestens folgende Bereiche in DE und wo vorhanden auch EN vergleichen.

## Startseite

```text
/
de/home/
en/home/
```

bzw. die tatsächlich verwendeten SEO-URLs.

Prüfen:

- Header
- Logo
- Markenlogos
- Navigation
- Slider
- Banner
- Einleitung
- Kennzahlen / Leistungsmerkmale
- Markenbereich
- Anwendungstabellen
- YouTube-Bereich
- Innovationen
- Aktionen
- Katalog
- Footer

---

## Marken

- Markenübersicht
- Profi Plus
- Profi Basic
- Bohrcraft

Die alte Markenübersicht enthält drei deutlich gestaltete Markenbereiche.

Das darf nicht zu einer generischen APEX-Liste verflachen.

---

## Produkte

- Unser Werkzeugprogramm
- Übersicht
- mindestens drei Kategorie-/Unterkategorie-Seiten
- mindestens zwei repräsentative Produktdetailseiten, auch wenn der Shopverkauf nicht im Vordergrund steht

Produktübersicht insbesondere auf:

- Raster
- Bildgrößen
- Weißraum
- Textposition
- Zeilenumbrüche
- Hover
- Kachelgrößen

prüfen.

---

## Service

- Downloads / Online Blättern / News
- Anwendungstabellen & Empfehlungen
- Kataloganforderung
- Videos

---

## Unternehmen

- Unternehmensprofil
- Qualität
- Karriere & Ausbildung

---

## Kontakt

- Vertrieb National
- Vertrieb International
- Vertriebsunterstützung
- Unser Team
- Anfrageformular
- Anfahrt

---

## Rechtliches

- Impressum
- AGB
- Datenschutz

---

# 9. Alte CSS-Kaskade wirklich analysieren

Nicht anhand von Vermutungen nachbauen.

Im OXID-4-Shop feststellen, **welche CSS-Dateien tatsächlich geladen werden**.

Dazu:

- altes Theme analysieren
- Browser-Network-Requests prüfen
- `<link>`-Reihenfolge prüfen
- Template-Includes prüfen
- `oxstyle`-Aufrufe prüfen
- Build-Dateien prüfen

Eine Liste erstellen:

```text
Datei
geladen?
auf welchen Seiten?
Zweck
Bohrcraft-spezifisch?
Framework?
noch relevant?
OXID-7-Ersatz
```

Besonders unterscheiden:

```text
FLOW Standard
Bootstrap 3
Bohrcraft CSS
Plugin CSS
Animations-CSS
historische / ungenutzte Dateien
```

Nur **tatsächlich aktive** visuelle Regeln rekonstruieren.

---

# 10. Alte JavaScript-Kaskade vollständig analysieren

Genauso mit JavaScript.

Nicht die 854 alten Custom-/Bibliotheksdateien pauschal kopieren.

Stattdessen feststellen:

- welche Skripte im Browser wirklich geladen werden
- welche Skripte DOM-Ready-Handler registrieren
- welche Plugins tatsächlich initialisiert werden
- welche Dateien nur Altlasten sind
- welche Skripte sichtbare Animationen erzeugen

Insbesondere suchen nach:

```text
animate
animation
transition
fade
fadeIn
fadeOut
slide
slideDown
slideUp
carousel
slider
owl
slick
swiper
wow
aos
scroll
waypoint
hover
transform
opacity
parallax
delay
easing
collapse
dropdown
megamenu
```

Zusätzlich alte Bohrcraft-Dateien untersuchen wie:

```text
codecookiescript.js
variantscrolloffset.js
oxomiscript20.js
```

sowie alle weiteren tatsächlich eingebundenen Theme-Skripte.

---

# 11. Animationen explizit portieren

Alle auf der alten Live-Seite sichtbaren Animationen dokumentieren.

Für jede Animation:

```text
Seite/Element
Trigger
Startzustand
Endzustand
Dauer
Delay
Easing
Desktop/Mobil
alte Implementierung
neue Implementierung
```

Dann modern nachbauen.

Keine jQuery-/Bootstrap-3-Abhängigkeit nur wegen einer Animation wieder einführen.

Bevorzugt:

```text
CSS transitions
CSS keyframes
IntersectionObserver
requestAnimationFrame
Bootstrap-5 APIs
Vanilla JavaScript
```

---

# 12. Bewegungsverhalten muss wieder nach Bohrcraft aussehen

Besonders prüfen:

- Sliderübergänge
- automatischer Sliderwechsel
- Hover auf Bildern/Kacheln
- Navigation / Dropdown / Megamenü
- Ein-/Ausblenden von Bereichen
- Scroll-Reveals
- Bild-/Textbewegungen
- Buttons / Links
- mobile Menüanimationen

Falls eine Animation auf der alten Seite subtil ist, nicht unnötig übertreiben.

Ziel ist **Legacy-Parität**, keine neue Animation-Show.

---

# 13. Startseitenslider

Die alte Seite verwendet mehrere große Banner, darunter die vorhandenen Bohrcraft-Bannergrafiken.

Den alten Slider exakt untersuchen:

- Höhe
- Breite
- Full-width oder Container
- Bildzuschnitt
- `object-fit`
- Auto-Play
- Interval
- Übergang
- Dauer
- Navigation
- Punkte/Pfeile
- Hover/Pause
- Smartphoneverhalten

APEX-Promo-Slider darf technisch weiterverwendet werden, wenn er entsprechend angepasst werden kann.

Falls nicht:

eine kleine moderne Bohrcraft-Komponente bauen, ohne das APEX-Theme selbst zu ändern.

---

# 14. Header neu angleichen

Der aktuelle OXID-7-Header ist technisch stark an APEX angelehnt.

Das reicht optisch noch nicht.

Alte Seite genau vermessen:

- Gesamthöhe
- Logo
- Position Logo
- maximale Contentbreite
- Markenlogos
- Sprache
- Suche
- Navigation
- horizontale Abstände
- Hintergrund
- Linien
- Sticky-Verhalten, falls vorhanden
- Breakpoints

Der OXID-7-Header soll diese Geometrie übernehmen.

---

# 15. Megamenü ist ein wichtiger Unterschied

Die alte Seite besitzt kein rein generisches Kategorienmenü.

Im alten Desktop-Menü werden bei `Marken` unter anderem drei Marken visuell präsentiert:

- Profi Plus
- Profi Basic
- Bohrcraft

mit:

- Markenbildern
- Kurzbeschreibung
- weiterführendem Link

Dieses Verhalten auf der alten Seite nachvollziehen und wiederherstellen.

Auch die anderen Hauptpunkte sollen in Struktur, Breite, Position und Animation der alten Navigation entsprechen.

Die bestehende APEX-Kategorienlogik darf Daten liefern.

Die Darstellung muss jedoch Bohrcraft-spezifisch werden.

---

# 16. Mobile Navigation

Die aktuelle APEX-Version verwendet eine APEX-/Bootstrap-native Mobile-Navigation.

Diese unterscheidet sich sichtbar vom alten Auftritt.

Vergleichen:

- Position Menübutton
- Logo
- Suchfunktion
- Sprache
- Öffnungsrichtung
- Einrückungen
- Submenü
- Back-Navigation
- Animationsdauer
- Höhe / Scrollverhalten

Dann das Verhalten möglichst nahe an der alten Seite rekonstruieren.

Kein unnötiger Fixed-Bottom-Navigationsbalken, falls dieser auf der Referenzseite nicht vorhanden ist.

---

# 17. Footer angleichen

Die alte Seite besitzt klar erkennbare Bereiche:

```text
Kontakt
Information
Kategorien
```

mit Unternehmensdaten und Icons.

Der aktuelle neue Footer wurde frei auf APEX-Basis gestaltet.

Bitte wieder stärker an die alte Referenz angleichen:

- Hintergrundfarbe
- Höhe
- Spaltenbreiten
- Überschriften
- Icondarstellung
- Schriftgrößen
- Linkabstände
- vertikaler Rhythmus
- Copyright
- Responsive

Externe-Content-Einstellungen dürfen weiterhin angeboten werden, sollen sich aber optisch einfügen.

---

# 18. Bohrcraft Designsystem extrahieren

Aus der alten Seite ein kleines CSS-Tokensystem ableiten.

Mindestens:

```css
--bc-primary
--bc-primary-dark
--bc-secondary
--bc-text
--bc-muted
--bc-background
--bc-border

--bc-font-body
--bc-font-heading

--bc-container-width
--bc-section-gap
--bc-radius
--bc-transition-fast
--bc-transition-normal
```

Werte nicht erfinden.

Aus alter CSS-/Computed-Style-Analyse bestimmen.

---

# 19. Typografie exakt untersuchen

Alt gegen Neu vergleichen:

- verwendete Fonts
- Fallbacks
- Font Weight
- H1
- H2
- H3
- H4
- Body
- Navigation
- Buttons
- Footer
- Line-height
- Letter-spacing
- Textfarben

Auf CMS-Seiten macht bereits die Typografie einen großen Teil des visuellen Unterschieds aus.

---

# 20. Containerbreiten und Seitenrhythmus

Für typische Desktopbreiten ermitteln:

```text
Viewport
Contentbreite alt
Contentbreite neu
linker Rand
rechter Rand
Section Padding oben/unten
```

Aktuelle `container-xxl`-Standardwerte dürfen nicht automatisch als richtig gelten.

Bohrcraft-Containerbreite bei Bedarf gezielt überschreiben.

---

# 21. CMS-Kompatibilitätsschicht

Die Inhalte wurden aus OXID 4 übernommen und enthalten teilweise altes Bootstrap-/Theme-Markup.

Bestehende Beispiele im aktuellen CSS:

```text
.img-responsive
.panel1container
.panel3
.col-xs-12
```

Das zeigt, dass bereits eine Kompatibilitätsschicht begonnen wurde.

Diese jetzt systematisch vervollständigen.

Im gesamten CMS-Bestand vorkommende Legacy-Klassen inventarisieren.

Beispielsweise suchen nach:

```text
col-xs-
col-sm-
col-md-
col-lg-
img-responsive
panel
panel-
row
container
pull-left
pull-right
text-
hidden-
visible-
btn-
```

Zusätzlich alle Bohrcraft-eigenen Klassen erfassen.

Für jede häufig verwendete Klasse entscheiden:

```text
CSS-Kompatibilität
HTML-Transformation
nicht mehr nötig
```

---

# 22. CMS nicht unnötig hart umschreiben

Da die Seite überwiegend CMS ist:

**bevorzugt eine saubere CSS-Kompatibilitätsschicht schaffen**, statt jeden einzelnen CMS-Block manuell umzuschreiben.

Nur wenn das alte HTML semantisch oder technisch nicht mehr sinnvoll ist, gezielt modernisieren.

Keine CMS-Texte hart in Twig kopieren.

Redaktionelle Inhalte müssen redaktionell bleiben.

---

# 23. Startseiten-CMS

Besonders analysieren:

```text
oxstartwelcome
bc_jobs
bc_news
bc_video1
bc_video2
bc_video3
bc_video4
bc_video5
```

und alle von `oxstartwelcome` eingebundenen Inhalte.

Die Startseite soll nicht nur inhaltlich, sondern auch strukturell wieder der alten Seite entsprechen.

---

# 24. Markenübersicht

Alte Seite:

- drei klar getrennte Markenbereiche
- Bild / Logo
- Claim
- Beschreibung
- visuell starke Trennung

Die neue Version muss dieses Layout erhalten.

Nicht als generische Bootstrap-Karten interpretieren, falls die Referenz anders aussieht.

---

# 25. Produktübersicht

Die Seite `Übersicht` ist visuell wichtig.

Sie enthält eine große Matrix von Werkzeugbereichen.

Genau prüfen:

- Anzahl Spalten je Breakpoint
- Bildgrößen
- Textposition
- Abstände
- Zeilenumbrüche
- Kachelhöhen
- Hover
- Gruppierungen
- Leerflächen

Die bestehende OXID-7-Datenquelle darf verwendet werden.

Die Darstellung soll aber näher an die alte Seite.

---

# 26. Unternehmensseiten

Insbesondere:

## Unternehmensprofil

Alte Seite enthält:

- Textabschnitte
- mindestens zwei Bilder
- bewusst platzierte Bild/Text-Komposition

## Qualität

- großes Bild
- Zitat
- Textabschnitt

## Karriere

- Text
- Stellenbereich
- Kontaktinformationen

Diese Seiten nicht einfach als generischen `content`-Block mit APEX-Standardtypografie behandeln.

---

# 27. Kontakt-/Vertriebsseiten

National / International / Vertriebsunterstützung enthalten:

- Kontaktinformationen
- Bilder / Karten
- Querverlinkungen

Geometrie und Bildpositionen mit alter Seite vergleichen.

---

# 28. Downloadseite

OXOMI-Funktion ist bereits technisch korrekt.

Jetzt optisch angleichen:

- Hinweisbereich
- Consent
- Katalogbereich
- Logos
- Downloadlinks
- Abstände
- Überschriften
- Buttons

OXOMI selbst nicht beschädigen.

---

# 29. Anwendungstabellen

Die alten CMS-Inhalte zeigen eine klare Liste von Dokumenten.

Neue Seite soll dieselbe ruhige Informationshierarchie erhalten.

Nicht unnötig zu großen APEX-Buttons/Karten aufblasen.

---

# 30. Videos

YouTube-Consent bleibt.

Aber:

- Größe Video-Platzhalter
- Aspect Ratio
- Überschrift
- Datum
- Abstand
- Text
- Position der Freigabeschaltfläche

an Referenzseite angleichen.

Nach Freigabe weiterhin:

```text
youtube-nocookie.com
```

verwenden.

---

# 31. Kontaktformulare

Funktionierende neue Formularlogik nicht neu schreiben.

Optisch vergleichen:

- Labelposition
- Inputhöhe
- Spalten
- Pflichtfeldkennzeichnung
- Radio-/Checkboxen
- Datenschutz
- Buttons
- Breite
- Abstände
- Fehlermeldungen

Die alte Optik darf auf Bootstrap-5-Formulartechnik nachgebildet werden.

---

# 32. Rechtliche Seiten

Impressum, AGB, Datenschutz benötigen keine Spezialshow.

Hier besonders:

- Lesebreite
- Schriftgröße
- line-height
- H2/H3/H4
- Absatzabstände
- Linkfarbe
- Tabellen/listen

angleichen.

---

# 33. Bestehende neue Funktionen unbedingt erhalten

Diese bereits funktionierenden Bereiche dürfen durch die optische Angleichung nicht regressieren:

- Twig
- DE/EN
- YouTube 2-Klick
- `youtube-nocookie.com`
- OXOMI Consent
- OXOMI Laden
- Google Maps 2-Klick
- Kontaktmodul
- Formularvalidierung
- PDF Downloads
- SEO URLs
- APEX als Parent
- responsive Basis
- PHP 8.3
- OXID 7.5.1

---

# 34. Keine alten Frameworks wieder einschleppen

Nicht zurückbringen:

- Bootstrap 3
- altes FLOW als Runtime
- altes jQuery nur für Effekte
- veraltete jQuery-Plugins
- alte Core-Hacks
- komplette alte JS-Bibliotheksordner
- komplette alte CSS-Bibliotheksordner

Das alte Verhalten soll **modern nachimplementiert** werden.

---

# 35. APEX nicht verändern

Keine Änderungen direkt in:

```text
vendor/
APEX Parent Theme
```

Alle Anpassungen in:

```text
bohrcraft Child Theme
Bohrcraft Assets
Bohrcraft Modul
```

---

# 36. CSS-Struktur aufräumen

Die bisherige einzelne Mini-Datei darf sinnvoll erweitert und gegliedert werden.

Zum Beispiel:

```text
src/css/
    bohrcraft.css
    bohrcraft-layout.css
    bohrcraft-navigation.css
    bohrcraft-cms.css
    bohrcraft-components.css
    bohrcraft-responsive.css
```

oder eine ähnlich sinnvolle Struktur.

Keine Pflicht, exakt diese Dateien anzulegen.

Aber keine unwartbare 5.000-Zeilen-Müllhalde erzeugen.

Build-Prozess korrekt integrieren.

---

# 37. JavaScript sinnvoll trennen

Bei wachsendem Umfang:

```text
bohrcraft.js
bohrcraft-navigation.js
bohrcraft-animations.js
bohrcraft-external.js
```

oder vergleichbar.

Bestehende Consent-/OXOMI-Funktion kann ausgelagert werden, wenn dies ohne Regression erfolgt.

---

# 38. Reduced Motion

Neue Animationen müssen berücksichtigen:

```css
@media (prefers-reduced-motion: reduce)
```

Animationen dort sinnvoll reduzieren.

---

# 39. Performance

Kein visuelles Matching durch schwere Bibliotheken erkaufen.

Ziele:

- keine großen zusätzlichen Frameworks
- kein Layout Thrashing
- keine permanenten Scroll-Handler ohne Throttling
- `IntersectionObserver` für Scroll-Animationen
- Bilder möglichst vorhandene OXID-Mechanismen nutzen
- keine unnötigen Netzwerkrequests

---

# 40. Vergleichsmethode nach jeder größeren Änderung

Nach jeder größeren Komponente erneut Alt/Neu Screenshots erzeugen.

Für visuelle Diagnose optional:

- halbtransparente Overlays
- ImageMagick `compare`
- Pixel-Diff

verwenden.

Eine starre Pixel-Diff-Prozentzahl ist **kein** Abnahmekriterium, weil Rendering/Fonts dynamisch abweichen können.

Die Diff-Bilder dienen zur Fehlersuche.

---

# 41. Computed-Style-Vergleich

Für zentrale Elemente automatisiert CSS-Werte erfassen.

Beispielselektoren fachlich passend bestimmen für:

```text
body
main
header
logo
nav
nav-link
mega-menu
h1
h2
h3
content wrapper
hero/slider
footer
form-control
button
```

Werte vergleichen:

```text
width
max-width
height
padding
margin
font-family
font-size
font-weight
line-height
color
background-color
border
border-radius
box-shadow
display
grid/flex properties
```

Dies ist wesentlich verlässlicher als nach Gefühl CSS zu verändern.

---

# 42. Keine Shop-Optik erzwingen

Bohrcraft ist in dieser Nutzung im Wesentlichen eine Unternehmens-/Produktinformationsseite.

Daher sollen keine sichtbaren APEX-Shop-Komponenten dominieren, die auf der alten Seite nicht vorhanden sind.

Prüfen:

- Warenkorb
- Merkzettel
- Konto
- Preisboxen
- Checkout-Hinweise
- Commerce-Widgets

Nur anzeigen, wenn fachlich benötigt bzw. auf der alten Seite sichtbar.

---

# 43. Besonderheit alte Navigation

Auf der alten öffentlichen Seite ist im Megamenü bei `Marken` eine echte visuelle Markenpräsentation erkennbar.

Nicht lediglich:

```text
Marken
  Profi Plus
  Profi Basic
  Bohrcraft
```

sondern die visuelle Darstellung mit:

- Logo/Bild
- Claim
- Beschreibung
- Link

wiederherstellen.

Das ist eine der charakteristischen Komponenten der Seite.

---

# 44. Funktion und Optik getrennt bewerten

Bisherige Verifikation hat HTTP 200, JS-Fehlerfreiheit und Funktionen geprüft.

Dieser Auftrag benötigt zusätzlich eine zweite Qualitätsachse:

```text
Funktion
Optik
Interaktion
```

Beispiel:

```text
Startseite
Funktion: OK
Optik: 85 %
Interaktion: OK
```

Keine künstliche Prozentzahl als Selbstzweck.

Stattdessen konkrete Abweichungen dokumentieren.

---

# 45. Abnahmematrix

Am Ende für jede Seite:

```text
Seite
Desktop Optik
Tablet Optik
Mobile Optik
Animationen
Interaktion
Inhalte
Status
Restabweichung
```

Status nur:

```text
OK
bewusst modernisiert
Blocker
```

`bewusst modernisiert` nur für wirklich sinnvolle technische Modernisierungen wie Consent.

Nicht als Ausrede für sichtbar abweichendes Layout verwenden.

---

# 46. Browser-Konsole und Logs

Nach visueller Anpassung erneut prüfen:

- JS Console
- Network
- 404
- 500
- Mixed Content
- CSP
- OXID Log
- Apache/PHP Log

Keine Regression akzeptieren.

---

# 47. Responsive Endprüfung

Mindestens:

```text
1920 x 1080
1440 x 900
1280 x 800
1024 x 768
768 x 1024
390 x 844
360 x 800
```

Besonders Navigation und CMS-Grids prüfen.

---

# 48. Staging prüfen

Nach lokaler Fertigstellung prüfen, ob es einen bereits vorhandenen und sicheren Deploymentweg nach:

```text
https://bcraft.co-de.de/
```

gibt.

Falls ja und dieser eindeutig nur Staging betrifft:

- deployen
- dort erneut prüfen

Falls dafür keine bestehende sichere Deploymentkonfiguration vorhanden ist:

- nicht improvisieren
- lokalen Stand fertigstellen
- Deploymentblocker dokumentieren

`www.bohrcraft.de` niemals beschreiben/deployen.

---

# 49. Git

Vor Beginn:

```bash
git status
git branch --show-current
git log -10 --oneline
```

Bestehende Migration nicht zerstören.

Sinnvolle Commits beispielsweise:

```text
feat: restore bohrcraft legacy visual language
feat: align bohrcraft navigation and header
feat: restore bohrcraft cms layouts
feat: port bohrcraft legacy interactions
fix: align responsive bohrcraft presentation
test: verify visual parity against legacy site
```

---

# 50. Dokumentation

Neue Datei anlegen:

```text
migration/oxid4-to-oxid7/visual-parity.md
```

Darin:

## Referenz

- alte URL
- neue URL
- getestete Browser
- Viewports

## CSS

- alte aktive CSS-Dateien
- übernommene Designregeln
- verworfene Altlasten

## JavaScript

- alte aktive Animationen
- moderne Nachimplementierung

## Seitenvergleich

für alle Seiten.

## Bewusste Abweichungen

nur begründete Fälle.

---

# 51. Definition of Done

Der Auftrag ist erst fertig, wenn:

- alte und neue Webseite systematisch gecrawlt wurden
- alle relevanten CMS-Seiten geprüft wurden
- DE und EN geprüft wurden
- aktive alte CSS-Kaskade analysiert wurde
- aktive alte JS-/Animation-Kaskade analysiert wurde
- Header der alten Seite deutlich angenähert wurde
- Megamenü der alten Seite deutlich angenähert wurde
- Marken-Megamenü visuell wiederhergestellt wurde
- mobile Navigation angeglichen wurde
- Startseitenslider angeglichen wurde
- Startseiten-CMS optisch angeglichen wurde
- Markenübersicht angeglichen wurde
- Produktübersicht angeglichen wurde
- Unternehmensseiten angeglichen wurden
- Service-/Downloadseiten angeglichen wurden
- Kontakt-/Vertriebsseiten angeglichen wurden
- Footer angeglichen wurde
- Typografie angeglichen wurde
- Containerbreiten angeglichen wurden
- Abstände und Seitenrhythmus angeglichen wurden
- relevante alte Hover-Effekte wieder vorhanden sind
- relevante alte Scroll-/Einblendanimationen wieder vorhanden sind
- responsive Layouts stimmen
- keine neuen JS-/PHP-/Twig-Fehler entstanden sind
- YouTube Consent weiterhin funktioniert
- OXOMI weiterhin funktioniert
- Maps weiterhin funktioniert
- Kontaktformular weiterhin funktioniert
- finale Screenshot-/Vergleichsmatrix erstellt wurde

---

# 52. Abschlussbericht

Am Ende liefern:

## A. Ausgangslage

```text
Git-Commit vorher:
Theme:
APEX:
alte Referenz:
neue Referenz:
```

## B. CSS-Analyse

```text
Alte aktive CSS-Dateien:
Alte ungenutzte CSS-Dateien:
Neue/angepasste CSS-Dateien:
```

## C. JS-/Animationsanalyse

Tabelle:

```text
Effekt | Alt | Neu | Status
```

## D. Komponenten

Tabelle:

```text
Komponente | vorher OXID7 | nachher | Status
```

Mindestens:

- Header
- Navigation
- Megamenü
- Slider
- CMS-Content
- Marken
- Produktübersicht
- Service
- Unternehmen
- Kontakt
- Footer
- Mobile

## E. Seitenmatrix

Alle geprüften Seiten mit Desktop/Tablet/Mobile.

## F. Regression

- YouTube
- OXOMI
- Maps
- Kontakt
- DE/EN
- PDFs
- Console
- Logs

## G. Screenshots

Speicherort der visuellen Vergleichsevidenz.

## H. Git

```text
Branch:
Commits:
Git Status:
```

---

# 53. Arbeitsprinzip

Der wichtigste Punkt dieses Auftrags:

> Nicht versuchen, die alte FLOW-Technik zu retten.  
> Aber das **sichtbare Bohrcraft-Design und das Bewegungsverhalten** müssen wiederhergestellt werden.

APEX bleibt die technische Basis.

FLOW und die alte Live-Seite sind die visuelle Referenz.

Da der überwiegende Teil der Webseite aus CMS-/Informationsseiten besteht, ist eine sehr hohe visuelle Übereinstimmung technisch realistisch.

---

# 54. Nicht nach Teilergebnissen stoppen

Nicht nach:

- Header
- Startseite
- CSS
- Animationen
- Desktop

stoppen.

Den Auftrag vollständig durchführen.

Erst abschließen, wenn die gesamte öffentliche Seite in den definierten Viewports gegen die alte Referenz geprüft wurde.

## Zielbild

`bcraft.co-de.de` soll technisch OXID 7/APEX/Twig bleiben, aber für einen Besucher wieder eindeutig wie die bestehende Bohrcraft-Webseite wirken.
