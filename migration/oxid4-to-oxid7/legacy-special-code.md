# Bewertung der OXID-4-Sonderanpassungen

Stand: 2026-09-16

| Altbereich | Fundstelle | Entscheidung OXID 7 |
|---|---|---|
| Kontakt und Katalog | application/controllers/contact*.php | als PSR-4-Modul bohrcraft_contact portiert |
| Megamenü | code_megamenu und Theme-Header | APEX-Kategorienavigation verwendet |
| Ajax-Kategorien und Filter | code_ajaxcategory, code_ajaxfilter | native OXID-7/APEX-Liste verwendet |
| Attributset und Detailtabelle | code_attributeset, productdetailstable.tpl | native APEX-Spezifikation/Varianten geprüft |
| Feature-Icons | code_featureicon | sichtbare Produktinhalte bleiben über migrierte Daten/CMS erhalten; OXID-4-Modul nicht kopiert |
| Produkt-Highlight | code_producthighlight | APEX-Actions/Banner und Produktlisten verwendet |
| SEO | code_seo | vorhandene oxseo-Daten aus der Datenmigration verwendet |
| OXOMI | listoxomi.tpl und oxomiscript20.js | als gezieltes Twig-Template und modernes Vanilla-JS portiert |
| Cookie-Skript | codecookiescript.js | als kleine consent-gesteuerte Vanilla-JS-Lösung ersetzt |
| Varianten-Scrolloffset | variantscrolloffset.js | APEX-Variantenverhalten verwendet |
| Bootstrap-3-Libraries | Theme-JavaScript und CSS | nicht kopiert; Bootstrap 5.2.3 aus APEX |

Es wurden keine OXID-4-Core-Dateien in OXID 7 überschrieben. Proprietäre oder veraltete Module wurden nicht blind übernommen.
