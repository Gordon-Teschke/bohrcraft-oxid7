SET NAMES utf8;

SELECT area, old_count, new_count, new_count - old_count AS difference,
       IF(old_count = new_count, 'OK', 'MISMATCH') AS status
FROM (
  SELECT 'Artikel' area,
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxarticles) old_count,
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxarticles) new_count
  UNION ALL SELECT 'Aktive Artikel',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxarticles WHERE OXACTIVE=1),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxarticles WHERE OXACTIVE=1)
  UNION ALL SELECT 'Varianten',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxarticles WHERE OXPARENTID<>''),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxarticles WHERE OXPARENTID<>'')
  UNION ALL SELECT 'Artikel-Langtexte',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxartextends),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxartextends)
  UNION ALL SELECT 'Kategorien',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxcategories),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxcategories)
  UNION ALL SELECT 'Kategoriezuordnungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxobject2category),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxobject2category)
  UNION ALL SELECT 'Attribute',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxattribute),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxattribute)
  UNION ALL SELECT 'Attributzuordnungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxobject2attribute),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxobject2attribute)
  UNION ALL SELECT 'Attributsets',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxattributeset),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxattributeset)
  UNION ALL SELECT 'Attributset-Zuordnungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxattribute2attributeset),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxattribute2attributeset)
  UNION ALL SELECT 'Auswahllisten',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxselectlist),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxselectlist)
  UNION ALL SELECT 'Auswahllistenzuordnungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxobject2selectlist),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxobject2selectlist)
  UNION ALL SELECT 'Hersteller',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxmanufacturers),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxmanufacturers)
  UNION ALL SELECT 'Lieferanten',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxvendor),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxvendor)
  UNION ALL SELECT 'Kunden',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxuser),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxuser)
  UNION ALL SELECT 'Lieferadressen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxaddress),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxaddress)
  UNION ALL SELECT 'Bestellungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxorder),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxorder)
  UNION ALL SELECT 'Bestellpositionen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxorderarticles),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxorderarticles)
  UNION ALL SELECT 'CMS-Inhalte',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxcontents),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxcontents)
  UNION ALL SELECT 'Zahlungsarten',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxpayments),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxpayments)
  UNION ALL SELECT 'Versandarten',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxdeliveryset),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxdeliveryset)
  UNION ALL SELECT 'Versandregeln',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxdelivery),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxdelivery)
  UNION ALL SELECT 'Rabatte',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxdiscount),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxdiscount)
  UNION ALL SELECT 'Gutscheine',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxvouchers),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxvouchers)
  UNION ALL SELECT 'Gutscheinserien',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxvoucherseries),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxvoucherseries)
  UNION ALL SELECT 'Medienreferenzen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.oxmediaurls),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.oxmediaurls)
  UNION ALL SELECT 'JTL-Verknuepfungen',
    (SELECT COUNT(*) FROM bohrcraft_oxid4.jtl_connector_link),
    (SELECT COUNT(*) FROM bohrcraft_oxid7.jtl_connector_link)
) counts
ORDER BY area;

SET SESSION group_concat_max_len=1048576;
SELECT GROUP_CONCAT(
  CONCAT(
    'SELECT ''', s.TABLE_NAME, ''' AS table_name, ',
    '(SELECT COUNT(*) FROM `bohrcraft_oxid4`.`', s.TABLE_NAME, '`) AS old_count, ',
    '(SELECT COUNT(*) FROM `bohrcraft_oxid7`.`', s.TABLE_NAME, '`) AS new_count, ',
    'IF((SELECT COUNT(*) FROM `bohrcraft_oxid4`.`', s.TABLE_NAME, '`)=',
    '(SELECT COUNT(*) FROM `bohrcraft_oxid7`.`', s.TABLE_NAME, '`),',
    '''OK'',''MISMATCH'') AS status'
  )
  ORDER BY s.TABLE_NAME SEPARATOR ' UNION ALL '
) INTO @all_count_sql
FROM information_schema.TABLES s
JOIN information_schema.TABLES t
  ON t.TABLE_SCHEMA='bohrcraft_oxid7'
 AND t.TABLE_NAME=s.TABLE_NAME
 AND t.TABLE_TYPE='BASE TABLE'
WHERE s.TABLE_SCHEMA='bohrcraft_oxid4'
  AND s.TABLE_TYPE='BASE TABLE'
  AND s.TABLE_NAME NOT IN ('oxconfig','oxconfigdisplay','oxshops');
PREPARE all_count_stmt FROM @all_count_sql;
EXECUTE all_count_stmt;
DEALLOCATE PREPARE all_count_stmt;

SELECT check_name, problem_count,
       CASE
         WHEN problem_count=0 THEN 'OK'
         WHEN check_name='Attributzuordnung ohne Artikel'
          AND problem_count=(
            SELECT COUNT(*)
            FROM bohrcraft_oxid4.oxobject2attribute rel
            LEFT JOIN bohrcraft_oxid4.oxarticles art ON art.OXID=rel.OXOBJECTID
            WHERE art.OXID IS NULL
          ) THEN 'PREEXISTING_SOURCE'
         WHEN check_name='Attributset-Zuordnung ohne Set'
          AND problem_count=(
            SELECT COUNT(*)
            FROM bohrcraft_oxid4.oxattribute2attributeset rel
            LEFT JOIN bohrcraft_oxid4.oxattributeset aset
              ON aset.oxid=rel.oxattributesetid
            WHERE aset.oxid IS NULL
          ) THEN 'PREEXISTING_SOURCE'
         ELSE 'ERROR'
       END AS status
FROM (
  SELECT 'Kategoriezuordnung ohne Artikel' check_name, COUNT(*) problem_count
  FROM bohrcraft_oxid7.oxobject2category rel
  LEFT JOIN bohrcraft_oxid7.oxarticles art ON art.OXID=rel.OXOBJECTID
  WHERE art.OXID IS NULL
  UNION ALL SELECT 'Kategoriezuordnung ohne Kategorie', COUNT(*)
  FROM bohrcraft_oxid7.oxobject2category rel
  LEFT JOIN bohrcraft_oxid7.oxcategories cat ON cat.OXID=rel.OXCATNID
  WHERE cat.OXID IS NULL
  UNION ALL SELECT 'Bestellposition ohne Bestellung', COUNT(*)
  FROM bohrcraft_oxid7.oxorderarticles pos
  LEFT JOIN bohrcraft_oxid7.oxorder ord ON ord.OXID=pos.OXORDERID
  WHERE ord.OXID IS NULL
  UNION ALL SELECT 'Adresse ohne Benutzer', COUNT(*)
  FROM bohrcraft_oxid7.oxaddress adr
  LEFT JOIN bohrcraft_oxid7.oxuser usr ON usr.OXID=adr.OXUSERID
  WHERE usr.OXID IS NULL
  UNION ALL SELECT 'Variante ohne Parent', COUNT(*)
  FROM bohrcraft_oxid7.oxarticles var
  LEFT JOIN bohrcraft_oxid7.oxarticles parent ON parent.OXID=var.OXPARENTID
  WHERE var.OXPARENTID<>'' AND parent.OXID IS NULL
  UNION ALL SELECT 'Attributzuordnung ohne Artikel', COUNT(*)
  FROM bohrcraft_oxid7.oxobject2attribute rel
  LEFT JOIN bohrcraft_oxid7.oxarticles art ON art.OXID=rel.OXOBJECTID
  WHERE art.OXID IS NULL
  UNION ALL SELECT 'Attributzuordnung ohne Attribut', COUNT(*)
  FROM bohrcraft_oxid7.oxobject2attribute rel
  LEFT JOIN bohrcraft_oxid7.oxattribute att ON att.OXID=rel.OXATTRID
  WHERE att.OXID IS NULL
  UNION ALL SELECT 'Auswahllistenzuordnung ohne Artikel', COUNT(*)
  FROM bohrcraft_oxid7.oxobject2selectlist rel
  LEFT JOIN bohrcraft_oxid7.oxarticles art ON art.OXID=rel.OXOBJECTID
  WHERE art.OXID IS NULL
  UNION ALL SELECT 'Auswahllistenzuordnung ohne Liste', COUNT(*)
  FROM bohrcraft_oxid7.oxobject2selectlist rel
  LEFT JOIN bohrcraft_oxid7.oxselectlist list ON list.OXID=rel.OXSELNID
  WHERE list.OXID IS NULL
  UNION ALL SELECT 'Attributset-Zuordnung ohne Set', COUNT(*)
  FROM bohrcraft_oxid7.oxattribute2attributeset rel
  LEFT JOIN bohrcraft_oxid7.oxattributeset aset ON aset.oxid=rel.oxattributesetid
  WHERE aset.oxid IS NULL
  UNION ALL SELECT 'Attributset-Zuordnung ohne Attribut', COUNT(*)
  FROM bohrcraft_oxid7.oxattribute2attributeset rel
  LEFT JOIN bohrcraft_oxid7.oxattribute att ON att.OXID=rel.oxattributeid
  WHERE att.OXID IS NULL
) integrity_checks
ORDER BY check_name;

SELECT 'Artikel' sample_type, src.OXID,
       IF(src.OXARTNUM <=> dst.OXARTNUM
          AND src.OXTITLE <=> dst.OXTITLE
          AND src.OXPRICE <=> dst.OXPRICE
          AND src.OXVAT <=> dst.OXVAT
          AND src.OXACTIVE <=> dst.OXACTIVE
          AND src.OXSTOCK <=> dst.OXSTOCK
          AND src.OXPARENTID <=> dst.OXPARENTID
          AND src.oxattributeset <=> dst.oxattributeset
          AND (SELECT OXLONGDESC FROM bohrcraft_oxid4.oxartextends WHERE OXID=src.OXID)
              <=> (SELECT OXLONGDESC FROM bohrcraft_oxid7.oxartextends WHERE OXID=dst.OXID)
          AND (SELECT COUNT(*) FROM bohrcraft_oxid4.oxobject2category WHERE OXOBJECTID=src.OXID)
              = (SELECT COUNT(*) FROM bohrcraft_oxid7.oxobject2category WHERE OXOBJECTID=dst.OXID),
          'OK','MISMATCH') AS status
FROM bohrcraft_oxid4.oxarticles src
JOIN bohrcraft_oxid7.oxarticles dst ON dst.OXID=src.OXID
ORDER BY src.OXID LIMIT 10;

SELECT 'Kunde' sample_type, src.OXID,
       IF(src.OXUSERNAME <=> dst.OXUSERNAME
          AND src.OXFNAME <=> dst.OXFNAME
          AND src.OXLNAME <=> dst.OXLNAME
          AND src.OXSTREET <=> dst.OXSTREET
          AND src.OXSTREETNR <=> dst.OXSTREETNR
          AND src.OXZIP <=> dst.OXZIP
          AND src.OXCITY <=> dst.OXCITY
          AND src.OXCOUNTRYID <=> dst.OXCOUNTRYID
          AND (SELECT COUNT(*) FROM bohrcraft_oxid4.oxaddress WHERE OXUSERID=src.OXID)
              = (SELECT COUNT(*) FROM bohrcraft_oxid7.oxaddress WHERE OXUSERID=dst.OXID),
          'OK','MISMATCH') AS status
FROM bohrcraft_oxid4.oxuser src
JOIN bohrcraft_oxid7.oxuser dst ON dst.OXID=src.OXID
ORDER BY src.OXID LIMIT 5;

SELECT 'Kategorie' sample_type, src.OXID,
       IF(src.OXTITLE <=> dst.OXTITLE
          AND src.OXPARENTID <=> dst.OXPARENTID
          AND src.OXACTIVE <=> dst.OXACTIVE
          AND src.OXSORT <=> dst.OXSORT
          AND src.MMINDIVIDUALCONTENT <=> dst.MMINDIVIDUALCONTENT
          AND src.MMISINMEGAMENU <=> dst.MMISINMEGAMENU,
          'OK','MISMATCH') AS status
FROM bohrcraft_oxid4.oxcategories src
JOIN bohrcraft_oxid7.oxcategories dst ON dst.OXID=src.OXID
ORDER BY src.OXID LIMIT 10;

SELECT 'Bestellung' sample_type, src.OXID,
       IF(src.OXORDERNR <=> dst.OXORDERNR
          AND src.OXORDERDATE <=> dst.OXORDERDATE
          AND src.OXUSERID <=> dst.OXUSERID
          AND src.OXTOTALORDERSUM <=> dst.OXTOTALORDERSUM
          AND (SELECT COUNT(*) FROM bohrcraft_oxid4.oxorderarticles WHERE OXORDERID=src.OXID)
              = (SELECT COUNT(*) FROM bohrcraft_oxid7.oxorderarticles WHERE OXORDERID=dst.OXID),
          'OK','MISMATCH') AS status
FROM bohrcraft_oxid4.oxorder src
JOIN bohrcraft_oxid7.oxorder dst ON dst.OXID=src.OXID
ORDER BY src.OXID LIMIT 5;

SELECT 'Source views copied' check_name,
       COUNT(*) problem_count,
       IF(COUNT(*)=0,'OK','ERROR') status
FROM information_schema.VIEWS target_view
WHERE target_view.TABLE_SCHEMA='bohrcraft_oxid7'
  AND target_view.VIEW_DEFINITION LIKE '%bohrcraft_oxid4%';

SELECT 'OXID-7 views present' check_name,
       COUNT(*) actual_count,
       IF(COUNT(*)=63,'OK','ERROR') status
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA='bohrcraft_oxid7' AND TABLE_NAME LIKE 'oxv\\_%';

