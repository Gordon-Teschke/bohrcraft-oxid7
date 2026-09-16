# Externe Einbindungen und Consent

Stand: 2026-09-16

## YouTube

Alt: direkte iframe-Elemente in bc_video1 bis bc_video5, überwiegend youtube-nocookie.com.

Neu: Die Datenbankinhalte enthalten lokale Platzhalter mit data-external-src. bohrcraft.js erzeugt den iframe erst nach dem Button Video laden. Die No-Cookie-Domain bleibt erhalten.

Browsertest: vor dem Klick 0 YouTube-iframes und 0 YouTube-Skripte; nach dem Klick genau ein iframe auf https://www.youtube-nocookie.com/embed/Rj8ab3Jk6l0.

## OXOMI

Alt: page/list/listoxomi.tpl, Cookie oxomiconsent, Portal 3001715, global geladene OXOMI-Bibliothek.

Neu: page/list/listoxomi.html.twig zeigt zunächst nur einen lokalen Hinweis. Ohne Zustimmung wird kein OXOMI-Skript geladen. Nach Zustimmung wird https://oxomi.com/assets/frontend/v2/oxomi.js geladen, Portal 3001715 mit DE oder EN initialisiert und universalSearch gerendert. Die Entscheidung wird weiterhin im Cookie oxomiconsent gespeichert.

Browsertest: vor Zustimmung kein OXOMI-Skript; nach Klick ist die Suchoberfläche sichtbar und liefert Inhaltstypen.

## Google Maps

Alt: im alten Kontakt-Template deaktivierter/auskommentierter iframe; APEX würde die Karte sofort laden.

Neu: Das Kontakt-Override verhindert jeden automatischen Abruf. Die Adresse Am Eichholz 15, 42897 Remscheid wird lokal angezeigt. Der Google-Maps-iframe entsteht ausschließlich nach dem Button Karte laden.

Browsertest: vor Klick 0 Google-Maps-iframes; nach Klick genau ein Embed-iframe.

## Consent-Oberfläche

Der lokale Hinweis unterscheidet technisch notwendige Session-Cookies von OXOMI. Auswahl bestätigen setzt den OXOMI-Wert entsprechend, Ablehnen setzt 0. Videos und Maps verlangen unabhängig davon einen expliziten Einzelklick. Im Footer kann die Entscheidung über Externe Inhalte einstellen erneut geöffnet werden.

Es werden vor Zustimmung weder OXOMI, YouTube noch Google Maps durch das Bohrcraft-Theme geladen.
