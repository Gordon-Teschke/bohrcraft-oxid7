# Smarty-zu-Twig-Portierung

Stand: 2026-09-16

## Automatische Konvertierung

Verwendet wurde der offizielle lokale OXID-Konverter unter D:\xampp_php8\htdocs\smarty-to-twig-converter-master. Die Datenbankverbindung stammt ausschließlich aus dem Bootstrap der OXID-7-Zielinstanz; im Repository befinden sich keine Kennwörter.

Vor dem Schreiben meldete der Dry-Run 64 Felder:

| Bereich | DE | EN | Summe |
|---|---:|---:|---:|
| oxcontents.OXCONTENT | 29 | 29 | 58 |
| oxcategories.OXLONGDESC | 1 | 1 | 2 |
| oxactions.OXLONGDESC | 3 | 1 | 4 |
| oxarticles / oxartextends | 0 | 0 | 0 |

Danach wurde derselbe Lauf ohne Dry-Run nur gegen bohrcraft_oxid7 ausgeführt. Die OXID-4-Datenbank blieb unverändert. Das reproduzierbare Skript port\scripts\run-smarty-to-twig.ps1 arbeitet standardmäßig als Dry-Run und schreibt erst mit dem Schalter Apply.

## Manuelle Nacharbeit

Das Converter-Ergebnis wurde nicht ungeprüft übernommen.

1. Autoescaping: In oxstartwelcome waren sieben verschachtelte CMS-Inhalte als normaler Twig-Ausdruck ausgegeben worden. Das führte zu sichtbarem HTML-Quelltext. Die Ausgabe wurde auf include mit template_from_string und sanitize_html umgestellt.
2. Externe Frames: Alle fünf zweisprachigen bc_video-Blöcke enthielten direkte iframe-Elemente. Sie wurden in lokale click-to-load-Platzhalter umgewandelt.
3. OXOMI-Template: Der alte Wert page/list/listoxomi.tpl wurde auf page/list/listoxomi geändert.
4. Harte Produktiv-URLs: interne Verweise auf https://www.bohrcraft.de/ wurden in CMS-, Kategorie- und Action-HTML auf Root-relative Links umgestellt.
5. Theme-Templates: Die wenigen benötigten Smarty-Templates wurden fachlich neu als APEX-Twig-Overrides geschrieben statt mechanisch aus FLOW zu kopieren.
6. Core-Hacks: Die Kontaktlogik wurde als OXID-7-Modul neu implementiert.

## Problemklassen

- Autoescaping ist für normale Felder aktiv; gepflegtes CMS-HTML wird gezielt über die OXID-Twig-Helfer gerendert.
- Nicht vorhandene CMS-Blöcke werden mit ignore missing toleriert.
- Es wurden keine doppelten Twig-Blöcke eingeführt.
- Arrays und Properties in den neuen Templates folgen der APEX-3.1-Syntax.
- Alte Smarty-section-Konstrukte, reguläre Smarty-Ausdrücke und die Syntax mit eckigen Klammern wurden nicht übernommen.
- Bootstrap-3-Klassen in bestehendem CMS-HTML werden durch eine kleine Kompatibilitätsschicht abgefangen; neue Templates verwenden Bootstrap 5.

## Ergebnis

Die automatisierte Vollprüfung meldet in oxcontents, oxcategories und oxactions null verbleibende Smarty-Treffer. In den relevanten CMS-Feldern existieren außerdem null direkte iframe-Elemente.
