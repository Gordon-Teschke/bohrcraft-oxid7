# Abschlussbericht: Bohrcraft OXID 4 nach OXID 7

Stand: 2026-09-16

Die Datenbank-, CMS-, Theme- und Funktionsportierung ist lokal abgeschlossen. Die produktive Referenzseite und die OXID-4-Installation wurden nur gelesen; sämtliche Datenbankänderungen erfolgten in `bohrcraft_oxid7`.

## A. Umgebung

| Komponente | Wert |
|---|---|
| Projektroot OXID 4 | `D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs` |
| Projektroot OXID 7 | `D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft` |
| OXID 4 | CE 4.9.7 |
| OXID 7 | CE 7.5.1, Metapackage 7.5.0 |
| FLOW | 2.3.0 |
| APEX | 3.1.0 |
| PHP OXID 4 | 7.1.6 |
| PHP OXID 7 | 8.3.32 |
| Composer | 2.8.11 |
| Node / npm | 24.18.0 / 11.16.0 |
| MySQL | 5.6.50-log |
| lokale URL | `http://local.bohrcraft-oxid7.de` |

Vor der Vollportierung wurde `bohrcraft_oxid7` nach `D:\__code_workspace_mcp\bohrcraft\.backups\20260916_123752\bohrcraft_oxid7_before_full_port.sql` gesichert. Größe: 20.715.983 Byte; SHA-256: `26D962EC35B97325B3620CAA0783530041C04EADB97FF592552C08E69A3E2AD6`. Der Dump liegt außerhalb des Repositories.

Aktiv blieben die vorhandenen Module `ddoemedialibrary`, `ddoewysiwyg`, `eyeable_assist`, `makaira_oxid-connect-essential`, `oegdproptin` und `oxps_usercentrics`; hinzu kam `bohrcraft_contact`.

## B. Neues Theme

| Eigenschaft | Wert |
|---|---|
| Theme-ID | `bohrcraft` |
| Parent | `apex` |
| Parent-Version | 3.1.0 |
| Installationspfad | `source\Application\views\bohrcraft` |
| Assets | `source\out\bohrcraft` |
| Aktiviert | ja |

Eigene Twig-Dateien:

- `form/contact.html.twig`
- `layout/header.html.twig`
- `layout/footer.html.twig`
- `page/info/contact.html.twig`
- `page/info/contact2.html.twig`
- `page/list/listoxomi.html.twig`
- `page/shop/start.html.twig`

Eigene Frontend-Schicht: `src/css/bohrcraft.css` und `src/js/bohrcraft.js`; Logos, Markenbilder und Favicons liegen unter `out/bohrcraft/img` bzw. im Asset-Root. Die gebauten APEX-3.1-Runtime-Assets sind Teil des Deployments. Es wurden weder APEX noch Dateien unter `vendor/` geändert. Eigene Sprachdateien waren nicht nötig: vorhandene APEX-Schlüssel werden wiederverwendet, die wenigen neuen Texte sind im jeweiligen Twig-Template vollständig DE/EN hinterlegt.

## C. Smarty nach Twig

| Bereich | relevante Smarty-Basis | neue Twig-Dateien | Status / Hinweis |
|---|---:|---:|---|
| Layout/Header/Footer | 3 | 2 | gezielt neu auf APEX aufgebaut |
| Startseite | 1 plus CMS-Includes | 1 | CMS bleibt redaktionelle Quelle |
| Kontakt/Katalog | 5 Templates/Core-Controller | 3 plus Modul | ohne Core-Hack portiert |
| OXOMI | 1 | 1 | Consent und Initialisierung neu strukturiert |
| Produktlisten/-detail | mehrere FLOW-Overrides | 0 | APEX-native Varianten, Attribute und Herstellerlogo genutzt |

Der offizielle OXID `smarty-to-twig-converter` wurde zunächst im Dry-run und danach ausschließlich gegen die Zieldatenbank ausgeführt. Das Ergebnis wurde manuell korrigiert: verschachteltes CMS wird mit `template_from_string` und `sanitize_html` gerendert, produktive absolute Links wurden root-relativ, und externe iframes wurden durch lokale Consent-Platzhalter ersetzt. Autoescaping wurde nicht global deaktiviert; Benutzereingaben bleiben escaped. Im Theme und in den relevanten Datenbankfeldern sind keine unbeabsichtigten Smarty-Tags übrig.

## D. Datenbank / CMS

| Tabelle | Felder | Smarty vorher | danach | Status |
|---|---|---:|---:|---|
| `oxcontents` | `OXCONTENT`, `OXCONTENT_1` | 58 | 0 | OK, alle betroffenen DE/EN-Inhalte geprüft |
| `oxcategories` | `OXLONGDESC`, `OXLONGDESC_1` | 2 | 0 | OK |
| `oxactions` | `OXLONGDESC`, `OXLONGDESC_1` | 4 | 0 | OK |
| `oxarticles` / `oxartextends` | Langtexte | 0 | 0 | OK |

Direkte iframes in `oxcontents`: 0. Harte interne Links auf `https://www.bohrcraft.de/` in den geprüften CMS-, Kategorie- und Action-Feldern: 0. Das OXOMI-Kategorietemplate ist genau einmal als `page/list/listoxomi` zugeordnet. `protect-external-content.ps1` reproduziert die manuellen Nacharbeiten idempotent.

Die vorherige Datenmigration bleibt vollständig dokumentiert: 63 migrierte Tabellen haben identische Alt-/Neu-Counts, 54 OXID-ID-Mengen stimmen, die Quell-Checksummen vor/nachher sind identisch und es entstanden keine neuen Waisen.

## E. Externe Einbindungen

| Dienst | Fundstelle alt | neue Implementierung | Consent | Testergebnis |
|---|---|---|---|---|
| YouTube | `bc_video1` bis `bc_video5`, direkte iframes | lokale Platzhalter in CMS, JS erzeugt iframe | expliziter Klick je Video | vor Klick 0 iframes, danach ein `youtube-nocookie.com`-iframe |
| OXOMI | Download-Kategorie, altes `listoxomi.tpl` | `listoxomi.html.twig` plus einmaliger Script-Loader | global zustimmen/ablehnen | vor Zustimmung kein Script, danach Kataloge sichtbar, keine Konsolenfehler |
| Google Maps | Kontakt/Anfahrt | Twig-Platzhalter mit `data-external-src` | expliziter Klick | vor Klick kein iframe, danach Google-Maps-iframe |
| sonstige | Cookie-/Consent-Module | bestehende Module unangetastet | kein konkurrierender allgemeiner Cookie-Layer | OK |

Es wurden keine API-Keys oder Zugangsdaten ins Repository aufgenommen.

## F. Funktionsvergleich

| Seite/Funktion | Alt | Neu | Status | Abweichung |
|---|---|---|---|---|
| Startseite | FLOW/Smarty, CMS-Bausteine | APEX/Twig, gleiche CMS-Bausteine | OK | Layout technisch modernisiert |
| Desktop-Navigation | Megamenü | APEX-Megamenü | OK | Bootstrap 5 |
| mobile Navigation | FLOW-Menü | APEX-Collapse mit Menü/Suche | OK | bewusst APEX-nativ |
| Marken | Profi Plus, Profi Basic, Bohrcraft | Inhalte/Logos/Links erhalten | OK | keine fachliche |
| Produktübersicht | FLOW-Raster | APEX-Raster, migrierte Kategorien/Bilder | OK | APEX-Optik |
| Produktdetail | eigene FLOW-Anpassungen | APEX Varianten/Attribute/Herstellerlogo | OK | Altcode entfallen |
| Downloads/PDFs | lokale Dateien | 431 Dateien übernommen, Stichproben 200 | OK | keine |
| Anwendungstabellen | lokale PDFs/CMS | übernommen | OK | keine |
| Katalog/OXOMI | externe Einbindung | Consent-gesteuerte Einbindung | OK | Datenschutz modernisiert |
| Videos | direkte iframes | 2-Klick No-Cookie | OK | Datenschutz modernisiert |
| Unternehmen | CMS/Kategorien | migriert | OK | keine fachliche |
| Kontakt/Katalogformular | Core-Hacks | `bohrcraft_contact`-Modul | OK | echter Mailversand nicht ausgelöst |
| Anfahrt | Maps | 2-Klick Maps | OK | Datenschutz modernisiert |
| Impressum/Datenschutz | CMS DE/EN | CMS DE/EN | OK | keine |
| DE/EN | vorhanden | Navigation, CMS, Rechtliches und Formtexte vorhanden | OK | keine |

Die vollständige Alt-Theme-Matrix und die Entscheidung je Override stehen in `theme-analysis.md`; Sondercode außerhalb des Themes ist in `legacy-special-code.md` klassifiziert.

## G. Tests

`port/scripts/verify-port.ps1` meldet alle Prüfpunkte grün:

- 4/4 PHP-Dateien syntaktisch gültig
- `bohrcraft.js` besteht `node --check`
- 13/13 repräsentative DE-/EN-Seiten liefern HTTP 200 ohne Fatal-/Template-Fehler
- 3/3 PDF-Stichproben liefern HTTP 200 und `application/pdf`
- 0 Smarty-Reste im Theme und in den relevanten DB-Feldern
- OXOMI-Zuordnung und iframe-Schutz korrekt

Browserprüfung:

- Desktop 1440x900, Tablet 768x1024, Smartphone 390x844
- mobiler Menüschalter öffnet `Marken`, `Produkte`, `Service`, `Unternehmen`, `Kontakt`
- Startseite, Kontakt und OXOMI ohne relevante Browser-Warnung oder -Fehler
- YouTube, OXOMI und Maps erst nach Freigabe/Klick
- zehn Pflichtfelder verhindern leeres Kontaktformular ohne Netzwerkversand
- produktseitig Varianten, Attributtabelle, Herstellerlogo und Bilder sichtbar

Das OXID-Log erhielt seit dem letzten behobenen Zwischenfehler um 13:07:40 keine neuen Einträge. Apache meldete während der Endprüfung keine Bohrcraft-Fehler; ein separates PHP-Fehlerlog existiert lokal nicht. Details und URL-Liste: `verification.md`.

## H. Offene Punkte

| Problem | Auswirkung | Grund | nächster Schritt |
|---|---|---|---|
| Echter E-Mail-Versand nicht ausgelöst | SMTP/Zustellung nicht end-to-end bewiesen | verhindert unbeabsichtigte externe Nachricht | mit freigegebener Testadresse einmal gezielt senden |
| Produktionsdeployment nicht durchgeführt | Ergebnis ist nur lokal aktiv | Produktivsystem war ausdrücklich nur Referenz | separaten Deployment-/Abnahmetermin verwenden |

Es gibt keinen lokalen technischen Blocker. Ein CAPTCHA war in der ausgewerteten lokalen Formularlogik nicht aktiv; Pflichtfelder und Datenschutz-Zustimmung sind umgesetzt.

## I. Git und Dateien

Repository: `D:\__code_workspace_mcp\bohrcraft-oxid7`, Branch `main`.

Neu bzw. ergänzt wurden:

- `migration/oxid4-to-oxid7/port/source/Application/views/bohrcraft/`
- `migration/oxid4-to-oxid7/port/source/out/bohrcraft/`
- `migration/oxid4-to-oxid7/port/modules/bohrcraft/contact/`
- `migration/oxid4-to-oxid7/port/scripts/`
- sieben Analyse-, Konvertierungs- und Prüfberichte unter `migration/oxid4-to-oxid7/`
- `README.md`, `verification.md` und dieser Abschlussbericht ergänzt

Dumps, Zugangsdaten, Laufzeit-Cache und die rund 1,3 GB Medienbestände bleiben außerhalb von Git.

Commits der Vollportierung:

- `a4ceebd` `feat: create bohrcraft apex child theme`
- `e784117` `feat: port contact and external content workflows`
- Dokumentation und Verifikation: dieser abschließende Dokumentationscommit

Der abschließende Arbeitsbaum wird nach dem Commit erneut auf Sauberkeit geprüft.