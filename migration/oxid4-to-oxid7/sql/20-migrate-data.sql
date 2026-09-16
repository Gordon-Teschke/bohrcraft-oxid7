SET NAMES utf8;
SET SESSION group_concat_max_len = 1048576;
USE bohrcraft_oxid7;

DROP PROCEDURE IF EXISTS bohrcraft_oxid7.migrate_oxid_table;
DROP PROCEDURE IF EXISTS bohrcraft_oxid7.merge_safe_config;

DELIMITER $$

CREATE PROCEDURE bohrcraft_oxid7.migrate_oxid_table(IN p_table VARCHAR(64))
BEGIN
  DECLARE v_columns LONGTEXT;
  DECLARE v_select LONGTEXT;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'bohrcraft_oxid4'
      AND TABLE_NAME = p_table AND TABLE_TYPE = 'BASE TABLE'
  ) OR NOT EXISTS (
    SELECT 1 FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'bohrcraft_oxid7'
      AND TABLE_NAME = p_table AND TABLE_TYPE = 'BASE TABLE'
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Migration table missing in source or target';
  END IF;

  SELECT
    GROUP_CONCAT(CONCAT('`', t.COLUMN_NAME, '`')
      ORDER BY t.ORDINAL_POSITION SEPARATOR ', '),
    GROUP_CONCAT(
      CASE
        WHEN t.COLUMN_NAME IN ('OXSHOPID', 'OXORDERSHOPID')
          THEN CONCAT('CAST(1 AS SIGNED) AS `', t.COLUMN_NAME, '`')
        WHEN p_table = 'oxdiscount' AND t.COLUMN_NAME = 'OXSORT'
          THEN CONCAT(
            '(SELECT COUNT(*) FROM `bohrcraft_oxid4`.`oxdiscount` d2 ',
            'WHERE d2.OXSHOPID = src.OXSHOPID AND d2.OXID <= src.OXID) ',
            'AS `OXSORT`'
          )
        WHEN s.COLUMN_NAME IS NOT NULL
          THEN CONCAT('src.`', t.COLUMN_NAME, '`')
        WHEN t.COLUMN_DEFAULT IS NOT NULL
          THEN CONCAT(QUOTE(t.COLUMN_DEFAULT), ' AS `', t.COLUMN_NAME, '`')
        WHEN t.IS_NULLABLE = 'YES'
          THEN CONCAT('NULL AS `', t.COLUMN_NAME, '`')
        WHEN t.DATA_TYPE IN (
          'tinyint', 'smallint', 'mediumint', 'int', 'bigint',
          'decimal', 'float', 'double', 'bit'
        ) THEN CONCAT('0 AS `', t.COLUMN_NAME, '`')
        ELSE CONCAT(QUOTE(''), ' AS `', t.COLUMN_NAME, '`')
      END
      ORDER BY t.ORDINAL_POSITION SEPARATOR ', '
    )
  INTO v_columns, v_select
  FROM information_schema.COLUMNS t
  LEFT JOIN information_schema.COLUMNS s
    ON s.TABLE_SCHEMA = 'bohrcraft_oxid4'
   AND s.TABLE_NAME = t.TABLE_NAME
   AND s.COLUMN_NAME = t.COLUMN_NAME
  WHERE t.TABLE_SCHEMA = 'bohrcraft_oxid7'
    AND t.TABLE_NAME = p_table;

  SET @delete_sql = CONCAT(
    'DELETE FROM `bohrcraft_oxid7`.`', p_table, '`'
  );
  PREPARE delete_stmt FROM @delete_sql;
  EXECUTE delete_stmt;
  DEALLOCATE PREPARE delete_stmt;

  SET @insert_sql = CONCAT(
    'INSERT INTO `bohrcraft_oxid7`.`', p_table, '` (', v_columns, ') ',
    'SELECT ', v_select,
    ' FROM `bohrcraft_oxid4`.`', p_table, '` src'
  );
  PREPARE insert_stmt FROM @insert_sql;
  EXECUTE insert_stmt;
  DEALLOCATE PREPARE insert_stmt;
END$$

CREATE PROCEDURE bohrcraft_oxid7.merge_safe_config(IN p_varname VARCHAR(100))
BEGIN
  UPDATE bohrcraft_oxid7.oxconfig target_cfg
  JOIN (
    SELECT OXVARTYPE,
      DECODE(OXVARVALUE, 'fq45QS09_fqyx09239QQ') AS decoded_value
    FROM bohrcraft_oxid4.oxconfig
    WHERE OXSHOPID = 'oxbaseshop'
      AND OXMODULE = ''
      AND OXVARNAME = p_varname
      AND DECODE(OXVARVALUE, 'fq45QS09_fqyx09239QQ') IS NOT NULL
      AND (
        OXVARTYPE NOT IN ('arr', 'aarr')
        OR LEFT(DECODE(OXVARVALUE, 'fq45QS09_fqyx09239QQ'), 2) = 'a:'
      )
    ORDER BY OXID
    LIMIT 1
  ) source_cfg
  SET target_cfg.OXVARTYPE = source_cfg.OXVARTYPE,
      target_cfg.OXVARVALUE = source_cfg.decoded_value
  WHERE target_cfg.OXSHOPID = 1
    AND target_cfg.OXMODULE = ''
    AND target_cfg.OXVARNAME = p_varname;
END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

CALL bohrcraft_oxid7.migrate_oxid_table('oxacceptedterms');
CALL bohrcraft_oxid7.migrate_oxid_table('oxaccessoire2article');
CALL bohrcraft_oxid7.migrate_oxid_table('oxactions');
CALL bohrcraft_oxid7.migrate_oxid_table('oxactions2article');
CALL bohrcraft_oxid7.migrate_oxid_table('oxaddress');
CALL bohrcraft_oxid7.migrate_oxid_table('oxadminlog');
CALL bohrcraft_oxid7.migrate_oxid_table('oxartextends');
CALL bohrcraft_oxid7.migrate_oxid_table('oxarticles');
CALL bohrcraft_oxid7.migrate_oxid_table('oxattribute');
CALL bohrcraft_oxid7.migrate_oxid_table('oxcategories');
CALL bohrcraft_oxid7.migrate_oxid_table('oxcategory2attribute');
CALL bohrcraft_oxid7.migrate_oxid_table('oxcontents');
CALL bohrcraft_oxid7.migrate_oxid_table('oxcounters');
CALL bohrcraft_oxid7.migrate_oxid_table('oxcountry');
CALL bohrcraft_oxid7.migrate_oxid_table('oxdel2delset');
CALL bohrcraft_oxid7.migrate_oxid_table('oxdelivery');
CALL bohrcraft_oxid7.migrate_oxid_table('oxdeliveryset');
CALL bohrcraft_oxid7.migrate_oxid_table('oxdiscount');
CALL bohrcraft_oxid7.migrate_oxid_table('oxfiles');
CALL bohrcraft_oxid7.migrate_oxid_table('oxgroups');
CALL bohrcraft_oxid7.migrate_oxid_table('oxinvitations');
CALL bohrcraft_oxid7.migrate_oxid_table('oxlinks');
CALL bohrcraft_oxid7.migrate_oxid_table('oxmanufacturers');
CALL bohrcraft_oxid7.migrate_oxid_table('oxmediaurls');
CALL bohrcraft_oxid7.migrate_oxid_table('oxnewssubscribed');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2action');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2article');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2attribute');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2category');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2delivery');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2discount');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2group');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2list');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2payment');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2selectlist');
CALL bohrcraft_oxid7.migrate_oxid_table('oxobject2seodata');
CALL bohrcraft_oxid7.migrate_oxid_table('oxorder');
CALL bohrcraft_oxid7.migrate_oxid_table('oxorderarticles');
CALL bohrcraft_oxid7.migrate_oxid_table('oxorderfiles');
CALL bohrcraft_oxid7.migrate_oxid_table('oxpayments');
CALL bohrcraft_oxid7.migrate_oxid_table('oxprice2article');
CALL bohrcraft_oxid7.migrate_oxid_table('oxpricealarm');
CALL bohrcraft_oxid7.migrate_oxid_table('oxratings');
CALL bohrcraft_oxid7.migrate_oxid_table('oxrecommlists');
CALL bohrcraft_oxid7.migrate_oxid_table('oxremark');
CALL bohrcraft_oxid7.migrate_oxid_table('oxreviews');
CALL bohrcraft_oxid7.migrate_oxid_table('oxselectlist');
CALL bohrcraft_oxid7.migrate_oxid_table('oxseo');
CALL bohrcraft_oxid7.migrate_oxid_table('oxseohistory');
CALL bohrcraft_oxid7.migrate_oxid_table('oxseologs');
CALL bohrcraft_oxid7.migrate_oxid_table('oxstates');
CALL bohrcraft_oxid7.migrate_oxid_table('oxtplblocks');
CALL bohrcraft_oxid7.migrate_oxid_table('oxuser');
CALL bohrcraft_oxid7.migrate_oxid_table('oxuserbasketitems');
CALL bohrcraft_oxid7.migrate_oxid_table('oxuserbaskets');
CALL bohrcraft_oxid7.migrate_oxid_table('oxuserpayments');
CALL bohrcraft_oxid7.migrate_oxid_table('oxvendor');
CALL bohrcraft_oxid7.migrate_oxid_table('oxvouchers');
CALL bohrcraft_oxid7.migrate_oxid_table('oxvoucherseries');
CALL bohrcraft_oxid7.migrate_oxid_table('oxwrapping');

DELETE FROM bohrcraft_oxid7.oxattributeset;
INSERT INTO bohrcraft_oxid7.oxattributeset (oxid, oxtitle)
SELECT oxid, oxtitle FROM bohrcraft_oxid4.oxattributeset;

DELETE FROM bohrcraft_oxid7.oxattribute2attributeset;
INSERT INTO bohrcraft_oxid7.oxattribute2attributeset
  (oxid, oxattributesetid, oxattributeid, oxposition, oxattributegroupid)
SELECT oxid, oxattributesetid, oxattributeid, oxposition, oxattributegroupid
FROM bohrcraft_oxid4.oxattribute2attributeset;

DELETE FROM bohrcraft_oxid7.jtl_connector_link;
INSERT INTO bohrcraft_oxid7.jtl_connector_link (endpointId, hostId, type)
SELECT endpointId, hostId, type FROM bohrcraft_oxid4.jtl_connector_link;

UPDATE bohrcraft_oxid7.oxshops target_shop
JOIN bohrcraft_oxid4.oxshops source_shop ON source_shop.OXID = 'oxbaseshop'
SET target_shop.OXDEFCURRENCY = source_shop.OXDEFCURRENCY,
    target_shop.OXDEFLANGUAGE = source_shop.OXDEFLANGUAGE,
    target_shop.OXNAME = source_shop.OXNAME,
    target_shop.OXTITLEPREFIX = source_shop.OXTITLEPREFIX,
    target_shop.OXTITLEPREFIX_1 = source_shop.OXTITLEPREFIX_1,
    target_shop.OXTITLEPREFIX_2 = source_shop.OXTITLEPREFIX_2,
    target_shop.OXTITLEPREFIX_3 = source_shop.OXTITLEPREFIX_3,
    target_shop.OXTITLESUFFIX = source_shop.OXTITLESUFFIX,
    target_shop.OXTITLESUFFIX_1 = source_shop.OXTITLESUFFIX_1,
    target_shop.OXTITLESUFFIX_2 = source_shop.OXTITLESUFFIX_2,
    target_shop.OXTITLESUFFIX_3 = source_shop.OXTITLESUFFIX_3,
    target_shop.OXSTARTTITLE = source_shop.OXSTARTTITLE,
    target_shop.OXSTARTTITLE_1 = source_shop.OXSTARTTITLE_1,
    target_shop.OXSTARTTITLE_2 = source_shop.OXSTARTTITLE_2,
    target_shop.OXSTARTTITLE_3 = source_shop.OXSTARTTITLE_3,
    target_shop.OXINFOEMAIL = source_shop.OXINFOEMAIL,
    target_shop.OXORDEREMAIL = source_shop.OXORDEREMAIL,
    target_shop.OXOWNEREMAIL = source_shop.OXOWNEREMAIL,
    target_shop.OXORDERSUBJECT = source_shop.OXORDERSUBJECT,
    target_shop.OXREGISTERSUBJECT = source_shop.OXREGISTERSUBJECT,
    target_shop.OXFORGOTPWDSUBJECT = source_shop.OXFORGOTPWDSUBJECT,
    target_shop.OXSENDEDNOWSUBJECT = source_shop.OXSENDEDNOWSUBJECT,
    target_shop.OXCOMPANY = source_shop.OXCOMPANY,
    target_shop.OXSTREET = source_shop.OXSTREET,
    target_shop.OXZIP = source_shop.OXZIP,
    target_shop.OXCITY = source_shop.OXCITY,
    target_shop.OXCOUNTRY = source_shop.OXCOUNTRY,
    target_shop.OXBANKNAME = source_shop.OXBANKNAME,
    target_shop.OXBANKNUMBER = source_shop.OXBANKNUMBER,
    target_shop.OXBANKCODE = source_shop.OXBANKCODE,
    target_shop.OXVATNUMBER = source_shop.OXVATNUMBER,
    target_shop.OXTAXNUMBER = source_shop.OXTAXNUMBER,
    target_shop.OXBICCODE = source_shop.OXBICCODE,
    target_shop.OXIBANNUMBER = source_shop.OXIBANNUMBER,
    target_shop.OXFNAME = source_shop.OXFNAME,
    target_shop.OXLNAME = source_shop.OXLNAME,
    target_shop.OXTELEFON = source_shop.OXTELEFON,
    target_shop.OXTELEFAX = source_shop.OXTELEFAX,
    target_shop.OXDEFCAT = source_shop.OXDEFCAT,
    target_shop.OXHRBNR = source_shop.OXHRBNR,
    target_shop.OXCOURT = source_shop.OXCOURT,
    target_shop.OXSEOACTIVE = source_shop.OXSEOACTIVE,
    target_shop.OXSEOACTIVE_1 = source_shop.OXSEOACTIVE_1,
    target_shop.OXSEOACTIVE_2 = source_shop.OXSEOACTIVE_2,
    target_shop.OXSEOACTIVE_3 = source_shop.OXSEOACTIVE_3
WHERE target_shop.OXID = 1;

CALL bohrcraft_oxid7.merge_safe_config('aCMSfolder');
CALL bohrcraft_oxid7.merge_safe_config('aHomeCountry');
CALL bohrcraft_oxid7.merge_safe_config('aLanguageParams');
CALL bohrcraft_oxid7.merge_safe_config('aLanguages');
CALL bohrcraft_oxid7.merge_safe_config('aMustFillFields');
CALL bohrcraft_oxid7.merge_safe_config('aOrderfolder');
CALL bohrcraft_oxid7.merge_safe_config('blAllowNegativeStock');
CALL bohrcraft_oxid7.merge_safe_config('blCalculateDelCostIfNotLoggedIn');
CALL bohrcraft_oxid7.merge_safe_config('blConfirmAGB');
CALL bohrcraft_oxid7.merge_safe_config('blEnableIntangibleProdAgreement');
CALL bohrcraft_oxid7.merge_safe_config('blEnterNetPrice');
CALL bohrcraft_oxid7.merge_safe_config('blOtherCountryOrder');
CALL bohrcraft_oxid7.merge_safe_config('blShippingCountryVat');
CALL bohrcraft_oxid7.merge_safe_config('dDefaultVAT');

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;

DROP PROCEDURE bohrcraft_oxid7.migrate_oxid_table;
DROP PROCEDURE bohrcraft_oxid7.merge_safe_config;

SELECT 'data migration finished' AS status;

