SET NAMES utf8;
USE bohrcraft_oxid7;

DROP PROCEDURE IF EXISTS bohrcraft_oxid7.add_column_if_missing;

DELIMITER $$

CREATE PROCEDURE bohrcraft_oxid7.add_column_if_missing(
  IN p_table VARCHAR(64),
  IN p_column VARCHAR(64),
  IN p_definition TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'bohrcraft_oxid7'
      AND TABLE_NAME = p_table
      AND COLUMN_NAME = p_column
  ) THEN
    SET @ddl = CONCAT(
      'ALTER TABLE `bohrcraft_oxid7`.`', p_table,
      '` ADD COLUMN `', p_column, '` ', p_definition
    );
    PREPARE ddl_stmt FROM @ddl;
    EXECUTE ddl_stmt;
    DEALLOCATE PREPARE ddl_stmt;
  END IF;
END$$

DELIMITER ;

CALL bohrcraft_oxid7.add_column_if_missing(
  'oxarticles', 'oxattributeset', 'CHAR(32) NULL'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxattribute', 'codeisfilterableinvartable', 'TINYINT(1) NULL DEFAULT 0'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxattribute', 'codeisvisibleinvartable', 'TINYINT(1) NULL DEFAULT 0'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxobject2attribute', 'featureicon', 'VARCHAR(255) NULL'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxobject2attribute', 'datatype', 'VARCHAR(10) NULL'
);

CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMINDIVIDUALCONTENT', 'TEXT NULL'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMISINDIVIDUAL', 'TINYINT(1) NULL DEFAULT 0'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMMAXCOLUMNS', 'TINYINT(1) NULL DEFAULT 0'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMISINMEGAMENU', 'TINYINT(1) NULL DEFAULT 0'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMRIGHTCONTENT', 'TEXT NULL'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMLEFTCONTENT', 'TEXT NULL'
);
CALL bohrcraft_oxid7.add_column_if_missing(
  'oxcategories', 'MMBOTTOMCONTENT', 'TEXT NULL'
);

DROP PROCEDURE bohrcraft_oxid7.add_column_if_missing;

CREATE TABLE IF NOT EXISTS bohrcraft_oxid7.oxattributeset (
  oxid CHAR(32) NOT NULL,
  oxtitle VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (oxid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS bohrcraft_oxid7.oxattribute2attributeset (
  oxid CHAR(32) NOT NULL,
  oxattributesetid CHAR(32) NOT NULL COMMENT 'id of the corresponds attributeset',
  oxattributeid CHAR(32) NOT NULL,
  oxposition INT(11) DEFAULT NULL,
  oxattributegroupid CHAR(32) NOT NULL,
  PRIMARY KEY (oxid),
  KEY oxattribute2attributeset_oxattribute_fk (oxattributeid),
  KEY oxattribute2attributeset_oxattributset_fk (oxattributesetid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS bohrcraft_oxid7.jtl_connector_link (
  endpointId CHAR(64) COLLATE utf8_unicode_ci NOT NULL,
  hostId INT(10) NOT NULL,
  type INT(10) DEFAULT NULL,
  KEY endpointId (endpointId),
  KEY hostId (hostId),
  KEY type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

