# CMS- und Datenbankinhalte

Stand: 2026-09-16

## Sicherung

Vor der CMS-Konvertierung wurde die Ziel-Datenbank gesichert:

- Datei: D:\__code_workspace_mcp\bohrcraft\.backups\20260916_123752\bohrcraft_oxid7_before_full_port.sql
- Größe: 20.715.983 Byte
- SHA-256: 26D962EC35B97325B3620CAA0783530041C04EADB97FF592552C08E69A3E2AD6

Die Sicherung enthält Zugangsdaten weder im Dateinamen noch in Git und wird nicht committed.

## Relevante Inhalte

Manuell geprüft wurden insbesondere:

- oxstartwelcome
- bc_jobs
- bc_news
- bc_video1 bis bc_video5
- oxcompanyadress
- oxkontaktlinks
- oxkatalog
- oxsecurityinfo
- Kategorie Downloads / Online Blättern / News
- Action-/Banner-Langbeschreibungen

oxstartwelcome bleibt die redaktionelle Quelle der Startseite. Die verschachtelten Inhalte werden nach der manuellen Autoescaping-Korrektur als Twig-Templates gerendert. DE und EN bleiben getrennt erhalten.

## Konvertierungsregeln

port\scripts\protect-external-content.ps1 ist idempotent und führt nach der offiziellen Smarty-Konvertierung folgende Zielkorrekturen aus:

- YouTube-iframe in bc_video-Inhalten durch lokale Platzhalter ersetzen.
- youtube-nocookie.com als Ziel erhalten.
- produktive interne Absolute-URLs root-relativ machen.
- verschachtelte oCont-CMS-Ausgabe sicher als Template rendern.
- OXOMI-Kategorietemplate auf den Twig-Namen umstellen.

Das Skript greift nur auf die per Parameter benannte Ziel-Datenbank zu. Standard ist bohrcraft_oxid7.

## Prüfergebnis

| Tabelle | Spalte | Smarty vorher | Smarty danach | direkte iframe danach |
|---|---|---:|---:|---:|
| oxcontents | OXCONTENT / OXCONTENT_1 | 58 | 0 | 0 |
| oxcategories | OXLONGDESC / OXLONGDESC_1 | 2 | 0 | 0 |
| oxactions | OXLONGDESC / OXLONGDESC_1 | 4 | 0 | 0 |
| oxarticles / oxartextends | Langtexte | 0 | 0 | 0 |

Die Startseite rendert die verschachtelten HTML-Blöcke, ohne HTML als Text anzuzeigen. Harte interne Verweise auf die Produktivdomain wurden in den geprüften Feldern vollständig entfernt.
