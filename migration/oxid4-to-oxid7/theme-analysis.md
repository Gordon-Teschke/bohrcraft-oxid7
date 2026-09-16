# Theme-Analyse OXID 4 zu OXID 7

Stand: 2026-09-16

## Ausgangslage

- OXID-4-Root: D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs
- altes Theme: application\views\bohrcraft_2
- Parent-Theme: FLOW 2.3.0
- OXID-4-Version: 4.9.7
- Live-Referenz: https://www.bohrcraft.de/
- OXID-7-Root: D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft
- OXID-7-Version: 7.5.1, Metapackage 7.5.0
- APEX-Version: 3.1.0
- PHP: 8.3.32
- Node: 24.18.0

Die Live-Seite wurde im Browser inventarisiert. Erhalten bleiben die Hauptnavigation Marken, Produkte, Service, Unternehmen und Kontakt, DE/EN, die Aktionsbanner, die in CMS-Blöcken gepflegte Startseite, die Bohrcraft-Markenfamilie sowie Footer und Rechtliches.

## Vergleich bohrcraft_2 zu FLOW

Ohne node_modules und Build-Artefakte wurden 197 identische Dateien, 32 gegenüber FLOW geänderte Dateien und 854 nur im alten Theme vorhandene Dateien klassifiziert. Der hohe Custom-only-Wert stammt überwiegend aus historischen Bibliotheken, Flaggen, DataTables-Artefakten, Sicherungskopien und nicht mehr benötigten Bootstrap-3-Abhängigkeiten.

Fachlich relevante Abweichungen:

- Layout: eigener Header, Footer, Navigation, Cookie-Hinweis und Bohrcraft-Branding.
- Startseite: Inhalte aus oxstartwelcome sowie bc_jobs, bc_news und bc_video1 bis bc_video5.
- Produktlisten: Herstellerlogos, Preis-/B2B-Bedingungen und eine eigene OXOMI-Liste.
- Produktdetail: Herstellerlogo, Variantenverhalten, Attributtabelle und abweichende Spaltenaufteilung.
- Kontakt: erweiterte Felder, Datenschutz-Zustimmung und zusätzliche Katalogformulare.
- Externe Inhalte: OXOMI, YouTube und früher optional Google Maps.
- Sprachen: eigene deutsche und englische Texte.

APEX 3.1 stellt Varianten, Attribute, Herstellerlogo, Produktlisten, dynamische Bilder, Bootstrap-5-Navigation und responsive Produktdetails nativ bereit. Diese Funktionen werden deshalb nicht durch kopierte FLOW-Templates ersetzt. Überschrieben werden nur die sieben fachlich notwendigen Twig-Dateien:

- form/contact.html.twig
- layout/header.html.twig
- layout/footer.html.twig
- page/info/contact.html.twig
- page/info/contact2.html.twig
- page/list/listoxomi.html.twig
- page/shop/start.html.twig

## Sondercode außerhalb des Themes

Gefunden wurden die OXID-4-Core-Controller application\controllers\contact.php, contact2.php, contact2a.php, contact2b.php und contactnew.php. Diese Core-Hacks wurden nicht übernommen. Die benötigte Logik liegt nun im separaten Modul bohrcraft_contact mit PSR-4-Autoloading.

Historische Module wie code_megamenu, code_ajaxcategory, code_ajaxfilter, code_attributeset, code_featureicon, code_producthighlight und code_seo wurden untersucht. Ihre sichtbaren Aufgaben werden entweder von APEX/OXID 7 nativ abgedeckt, sind reine OXID-4-Technik oder waren nicht mehr Bestandteil des aktiven Live-Verhaltens. Sie wurden deshalb nicht als inkompatibler Altcode kopiert.

## Neues Theme

- Theme-ID: bohrcraft
- Parent: apex
- zulässige Parent-Version: 3.1.0
- Runtime-Pfad: source\Application\views\bohrcraft
- Assets: source\out\bohrcraft
- Aktiviert: ja

Die APEX-Quellen im Vendor-Verzeichnis wurden nicht geändert. Das Child-Theme enthält nur eigene Templates, Einstellungen, Logos, Favicons, Bohrcraft-CSS und Bohrcraft-JavaScript. Die bereits gebauten APEX-Runtime-Assets werden als reproduzierbare Basis mitgeführt; styles.min.css enthält zusätzlich die kleine Bohrcraft-CSS-Schicht.

## Medien

Der komplette lokale Bestand wurde in die OXID-7-Runtime übernommen:

| Bereich | Quelle Dateien | Ziel Dateien | Quellbytes | Hinweis |
|---|---:|---:|---:|---|
| pictures | 7.151 | 7.156 | 873.153.072 | fünf zusätzliche, von OXID 7 dynamisch erzeugte Bilder |
| files | 431 | 431 | 429.850.802 | identische Dateizahl und Bytezahl |
| downloads | 7 | 8 | 2.130.271 | eine vorhandene leere/technische Zieldatei, Nutzdaten identisch |

Die Binärmedien werden nicht in Git dupliziert. port\scripts\copy-media.ps1 kopiert und verifiziert sie reproduzierbar.
