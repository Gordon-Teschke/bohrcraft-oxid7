# OXID 7 Visual- und Interaction-Parity

Stand: 2026-09-16

## A. Ausgangslage und Referenzen

Ziel war die visuelle und interaktive Angleichung der bereits migrierten OXID-7-Seite an die produktive OXID-4-Seite, ohne die Datenbankmigration oder bestehende OXID-7-Funktionen neu aufzubauen.

- Produktive Referenz: https://www.bohrcraft.de/
- Öffentliches OXID-7-Staging: https://bcraft.co-de.de/
- Lokale OXID-7-Prüfung: http://local.bohrcraft-oxid7.de/
- Alte lokale OXID-4-Quelle: D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs
- OXID-7-Laufzeit: D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft

Die Browseranalyse wurde mit 320x568, 360x800, 390x844, 768x1024, 1024x768, 1440x900 und 1920x1080 durchgeführt. Für die vier Kernbreiten 390, 768, 1440 und 1920 wurden zusätzlich Ganzseitenaufnahmen erzeugt.

## B. CSS-Analyse der Altseite

Die aktive Kaskade der produktiven Seite bestand in dieser Reihenfolge aus megamenu.min.css, pushmenu.min.css, pushmenuCustom.min.css, jquery.flexslider.min.css, styles.min.css und codecookiebanner.css. Entscheidend waren nicht die alten Frameworks selbst, sondern ihre sichtbaren Ergebnisse.

Ermittelte Desktop-Werte:

| Merkmal | OXID 4 | OXID 7 nach Anpassung |
|---|---:|---:|
| Schrift | Poppins | Poppins, lokal eingebettet |
| Grundtext | 16 px / 22,86 px | 16 px / 22,86 px |
| Textfarbe | #676767 | #676767 |
| Inhaltsbreite | 1170 px | 1170 px |
| Kopfbereich inkl. Navigation | 145 px | 145 px |
| Navigation | 40 px, #002e67 | 40 px, #002e67 |
| Startseiten-Hero | 267 px | 267 px |
| H1 | 36 px, 500 | 36 px, 500 |
| Footer | ca. 370 px | ca. 372 px |

Das Designsystem liegt nun getrennt in bohrcraft-tokens.css, bohrcraft-layout.css, bohrcraft-navigation.css, bohrcraft-cms.css, bohrcraft-components.css und bohrcraft-responsive.css. bohrcraft.css ist der einzige Einstiegspunkt. Poppins und Material Icons werden lokal geladen; damit entstehen keine externen Font-Abhängigkeiten und keine ausgeschriebenen Icon-Namen beim Laden.

## C. JavaScript- und Animationsanalyse

Die Altseite lud jQuery, FlexSlider, jQuery UI, start.min.js, scripts.min.js, hamburgernav, jquery.pushMenu, pushMenuInit sowie die Consent-Skripte. Sichtbar relevant waren:

- automatischer Startseitenslider mit Hover-Pause und Touch-Bedienung,
- fixierte Navigation nach dem Scrollen,
- Desktop-Megamenü mit weichem Ein-/Ausblenden,
- mobile Auf-/Zuklapp-Navigation,
- dezenter Schatten auf Kacheln beim Hover,
- Consent-gesteuertes Nachladen externer Inhalte.

Die OXID-7-Umsetzung verwendet keine alten Frameworks neu. Das Verhalten ist in drei kleine Dateien getrennt:

- bohrcraft-navigation.js: Megamenü, mobile Untermenüs, Escape/Außenklick und Sticky Navigation,
- bohrcraft-animations.js: Bootstrap-Carousel, 5,5 Sekunden Intervall, Hover-Pause, Touch und Reduced Motion,
- bohrcraft-external.js: bestehende Einwilligungslogik für YouTube, Maps und OXOMI.

prefers-reduced-motion wird respektiert. In diesem Modus werden Übergänge und automatisches Weiterschalten unterdrückt.

## D. Umgesetzte Komponenten

| Komponente | Ergebnis |
|---|---|
| Header | 105-px-Kopf mit Bohrcraft-Logo, Slogan, Profi-Plus/Basic-Kennung und Sprachauswahl |
| Hauptnavigation | 40-px-Leiste in Bohrcraft-Blau, Desktop- und Mobilzustand |
| Marken-Megamenü | Drei CMS-gesteuerte Markenblöcke aus oxsubmenumarken1 bis 3; DE/EN-Ziele |
| Mobile Navigation | Aufklappbare Ebene, Fokus-/Escape-Verhalten, kein horizontaler Überlauf |
| Slider | Höhe, Rhythmus, Autoplay, Navigation, Hover-Pause und Touch angeglichen |
| CMS-Kacheln | panel1, panel2, panel3, bottom-section und Bootstrap-3-Spaltenklassen kompatibel |
| Produktkacheln | alte Bild-/Textproportionen und Hover-Schatten wiederhergestellt |
| Footer | Kontakt, Information, Kategorien sowie rechtliche und Consent-Links |
| Externe Inhalte | YouTube-nocookie, Google Maps und OXOMI erst nach Einwilligung |
| Formulare | Responsive Felder, Pflichtfelder und Datenschutz-Checkbox erhalten |

APEX-Core-Dateien wurden nicht verändert. Die Anpassungen liegen ausschließlich im Bohrcraft-Child-Theme, in dessen Assets und im vorhandenen lokalen Deployment-Skript.

## E. CMS-Kompatibilität

Die importierten CMS-Inhalte wurden nicht unnötig umgeschrieben. Eine Read-only-Inventur ergab 119 aktive CMS-/Kategorietexte. Häufige Altklassen sind unter anderem img-responsive (64), row (46), col-sm-6 (44), col-lg-4 (30), col-xs-12 (28), bottom-section (24), panel2 (24), panel1 (20), imgl (17) und panel3 (8).

bohrcraft-cms.css stellt die benötigten Bootstrap-3-artigen Rasterklassen, Bildverhalten, Panelvarianten, Überschriften, Tabellen, lange Links und Formularregeln bereit. Der Content bleibt damit weiterhin im CMS pflegbar. Das Markenmenü nutzt die bestehenden CMS-Snippets statt fest kopierter Markentexte.

## F. Seiten- und Sprachmatrix

Die Regression umfasste 45 konkrete URLs in drei repräsentativen Breiten (1440, 768 und 390 Pixel), insgesamt 135 Browserprüfungen. Enthalten waren:

- Startseite Deutsch und Englisch,
- Markenübersicht und drei Markenseiten in beiden Sprachen,
- Produktübersicht, Toolrange, Kategorien, Unterkategorien und zwei Artikeldetails,
- Downloads, Anwendungen, Katalog und Videos,
- Unternehmensprofil, Qualität und Karriere jeweils DE/EN,
- Kontaktübersicht, Inland, Ausland, Support, Team, Formular und Anfahrt,
- Impressum, AGB und Datenschutz in beiden Sprachen.

Ergebnis: 135/135 Seitenprüfungen ohne Browserfehler und ohne horizontalen Überlauf. Zusätzlich lieferten 45/45 direkte HTTP-Prüfungen Status 200. Die Sprachumschaltung wurde für Deutsch und Englisch geprüft.

## G. Funktionsregression

- YouTube: vor Einwilligung kein iframe; nach Klick genau ein youtube-nocookie-iframe.
- Google Maps: vor Einwilligung kein iframe; nach Klick wird die Karte geladen.
- OXOMI: Aktivierung entfernt den Platzhalter, zeigt das Grid und lädt das OXOMI-Skript.
- Kontaktformular: lokale POST-Action, zehn erforderliche Felder inklusive Datenschutz und vorhandener Submit-Button; es wurde bewusst keine reale Nachricht versendet.
- Downloads: 18 Links auf neun eindeutige PDF-Pfade; alle referenzierten lokalen Dateien vorhanden.
- Browserkonsole: für lokale Seiten nach dem finalen Lauf keine Fehler oder Warnungen.
- OXID-/Apache-Logs: nach dem finalen Deployment und Crawl keine neuen Bohrcraft-Fehler.
- JavaScript: Syntaxprüfung aller drei neuen Dateien erfolgreich.

## H. Responsive Abnahme

Alle sieben geforderten Viewports wurden nach der letzten CSS-Anpassung erneut aufgenommen. Geprüft wurden Header, Navigation, Slider, Kacheln, Tabellen, lange Datenschutzlinks, Footer, mobile Menüs und externe Platzhalter. Auf 320 bis 1920 Pixel Breite trat kein horizontaler Seitenüberlauf auf.

## I. Screenshot-Evidenz

Die lokale Evidenz liegt unter migration/oxid4-to-oxid7/evidence/visual-parity und bleibt wegen ihres Umfangs bewusst außerhalb von Git.

- before: 208 reguläre Vergleichsbilder plus zwei geöffnete Megamenü-Zustände.
- after: 143 reguläre finale Bilder plus 13 Interaktionszustände und drei JSON-Prüfprotokolle.
- crawl-results.json: Browsermatrix und Overflow-Ergebnis.
- http-status.json: direkte HTTP-Statusprüfung.
- computed-styles.json: gemessene Kernwerte der Referenz und der lokalen Umsetzung.

Repräsentative Zustände sind local-home-1440x900-fold.png, local-megamenu-1440-open.png, local-mobile-menu-390-open.png, local-sticky-1440.png, local-slider-next-1440.png und local-product-hover-1440.png.

## J. Bewusste Abweichungen

- Die alten jQuery-, FlexSlider- und Pushmenu-Implementierungen wurden nicht übernommen; ihr sichtbares Verhalten wurde mit den vorhandenen OXID-7-/Bootstrap-Mitteln nachgebildet.
- Die Gesamthöhe einzelner Seiten kann durch OXID-7-Markup und importierte Textinhalte geringfügig abweichen. Die gemessenen Kerngeometrien, Schriftwerte und Breakpoint-Zustände stimmen überein.
- Externe Anbieter können in einer isolierten lokalen Umgebung nach der Einwilligung netzwerkbedingt abweichend reagieren; das Consent-Gating und die erzeugten Ziel-URLs wurden verifiziert.

## K. Deployment

Das lokale Deployment-Skript wurde so korrigiert, dass ein bereits konfiguriertes Kontaktmodul nur deaktiviert und wieder aktiviert wird. Eine erneute Installation erfolgt nur, wenn die Modulkonfiguration fehlt. Dadurch werden wiederholbare lokale Deployments nicht mehr durch eine Modul-Diskrepanz abgebrochen.

Die finale Version wurde lokal ausgerollt, das Bohrcraft-Theme aktiviert, der Autoloader aktualisiert und der OXID-Cache geleert.

Für https://bcraft.co-de.de/ ist im Repository kein belastbarer Deployment-Zugang und kein freigegebener Zielpfad dokumentiert. Daher wurde das öffentliche Staging nicht verändert. Die öffentliche Staging-Prüfung bleibt bis zur Bereitstellung dieses Deployment-Wegs offen; es wurde kein Zugang geraten und kein produktiver Pfad zweckentfremdet.

## L. Definition of Done

- [x] Altseite und OXID-7-Seite über die vollständige Seitenmatrix verglichen.
- [x] Sieben Viewports und relevante Interaktionszustände dokumentiert.
- [x] CSS-Kaskade, JS-Verhalten und Animationen der Altseite analysiert.
- [x] Header, Navigation, Megamenü, Slider, CMS-Bausteine und Footer angeglichen.
- [x] Mobile Navigation und Reduced Motion umgesetzt.
- [x] Bestehende OXID-7-Funktionen und Consent-Flows erhalten.
- [x] Keine alten Frontend-Frameworks und keine APEX-Core-Änderungen eingeführt.
- [x] Lokales Deployment und Regression erfolgreich.
- [x] Screenshots und maschinenlesbare Prüfergebnisse erzeugt.
- [ ] Öffentliches Staging ausrollen und dort erneut prüfen; blockiert durch fehlenden dokumentierten Deployment-Weg.

## M. Betroffene Dateien

Die wesentlichen Änderungen liegen in:

- source/Application/views/bohrcraft/tpl/layout/header.html.twig
- source/Application/views/bohrcraft/tpl/layout/footer.html.twig
- source/out/bohrcraft/src/css/bohrcraft*.css
- source/out/bohrcraft/src/js/bohrcraft-*.js
- source/out/bohrcraft/src/fonts/
- source/out/bohrcraft/img/logo_profibasic.png
- scripts/deploy-local.ps1

Die vier Seitentemplates start.html.twig, listoxomi.html.twig, contact.html.twig und contact2.html.twig laden das alte Sammelskript nicht mehr doppelt; die drei neuen Skripte werden zentral im Header registriert.