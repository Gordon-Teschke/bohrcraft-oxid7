# Tabellen-Mapping

## Direkt beziehungsweise spaltenbasiert migriert

Die folgenden gemeinsamen Tabellen wurden in die vorhandene OXID-7-Struktur
geschrieben. Nur Zielspalten wurden befuellt; neue OXID-7-Spalten erhielten
ihre Zieldefaults. `OXSHOPID` und `OXORDERSHOPID` wurden auf numerisch `1`
abgebildet.

```text
oxacceptedterms              oxaccessoire2article
oxactions                    oxactions2article
oxaddress                    oxadminlog
oxartextends                 oxarticles
oxattribute                  oxcategories
oxcategory2attribute         oxcontents
oxcounters                   oxcountry
oxdel2delset                 oxdelivery
oxdeliveryset                oxdiscount
oxfiles                      oxgroups
oxinvitations                oxlinks
oxmanufacturers              oxmediaurls
oxnewssubscribed             oxobject2action
oxobject2article             oxobject2attribute
oxobject2category            oxobject2delivery
oxobject2discount            oxobject2group
oxobject2list                oxobject2payment
oxobject2selectlist          oxobject2seodata
oxorder                      oxorderarticles
oxorderfiles                 oxpayments
oxprice2article              oxpricealarm
oxratings                    oxrecommlists
oxremark                     oxreviews
oxselectlist                 oxseo
oxseohistory                 oxseologs
oxstates                     oxtplblocks
oxuser                       oxuserbasketitems
oxuserbaskets                oxuserpayments
oxvendor                     oxvouchers
oxvoucherseries              oxwrapping
```

## Custom-Daten

| Quelle | Ziel | Strategie |
|---|---|---|
| `jtl_connector_link` | gleiche Tabelle | Ziel als InnoDB angelegt, 13.471 Zeilen migriert |
| `oxattributeset` | gleiche Tabelle | Ziel als InnoDB angelegt, 63 Zeilen migriert |
| `oxattribute2attributeset` | gleiche Tabelle | Ziel als InnoDB angelegt, 1.832 Zeilen migriert |
| belegte Custom-Spalten | gleiche Coretabellen | explizit angelegt und mitmigriert |

## Transformiert

- Alle Shop-IDs: `oxbaseshop` nach numerisch `1`.
- `oxdiscount.OXSORT`: OXID 4 besitzt die Spalte nicht, OXID 7 fordert einen
  pro Shop eindeutigen Wert. Die drei Rabatte erhielten deterministisch die
  Sortierungen 1, 2 und 3 nach OXID-Reihenfolge.
- Neue OXID-7-Felder wie `oxarticles.OXHIDDEN`,
  `oxdeliveryset.OXTRACKINGURL`, Hersteller-Bildfelder und
  `oxtplblocks.OXTHEME` wurden mit den OXID-7-Defaults befuellt.
- `oxshops`: fachliche Stammdaten wurden aktualisiert; `OXID`, `OXVERSION`,
  `OXEDITION`, Domain, SMTP und technische Zielwerte blieben erhalten.

## Konfiguration

`oxconfig` wurde nicht komplett ersetzt. Entschluesselt und nur in bereits
vorhandene OXID-7-Coreeintraege uebernommen wurden:

```text
aCMSfolder
aHomeCountry
aLanguageParams
aLanguages
aMustFillFields
aOrderfolder
blAllowNegativeStock
blCalculateDelCostIfNotLoggedIn
blConfirmAGB
blEnableIntangibleProdAgreement
blEnterNetPrice
blOtherCountryOrder
blShippingCountryVat
dDefaultVAT
```

Nicht uebernommen wurden alte Domains, Pfade, Cache-/Sessionwerte,
Modulregistrierungen, Modulgeheimnisse, Zahlungsanbieter-Zugangsdaten,
Theme-Konfigurationen und Entwicklungswerte. `oxconfigdisplay` blieb als
OXID-7-Metadatenbestand unveraendert.

## Nicht migriert

| Tabelle/Bereich | Grund |
|---|---|
| `adodb_logsql`, `oxlogs`, `oxstatistics` | technische Altprotokolle/-statistik |
| `oxcaptcha` | fluechtiger Laufzeitbestand |
| `oxgbentries` | leer und in der Zielstruktur nicht vorhanden |
| `oxnews`, `oxnewsletter` | entfernte OXID-4-Corefunktion; keine OXID-7-Zieltabelle |
| alte `oxv_*` und `newview` | Views werden aus der OXID-7-Struktur neu erzeugt |
| Dateien und Bilder | ausdruecklich ausserhalb dieses Auftrags |

## OXID-7-only erhalten

Die Medien-/Makaira-Tabellen und alle vier `oxmigrations_*`-Tabellen wurden
weder geleert noch ueberschrieben. Damit bleibt die Zielbasis upgradefaehig.

