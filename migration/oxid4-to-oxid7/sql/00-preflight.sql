SET NAMES utf8;

SELECT IF(
  (SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = 'bohrcraft_oxid4') = 1,
  'OK source schema exists',
  'ERROR source schema missing'
) AS source_preflight;

SELECT IF(
  (SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = 'bohrcraft_oxid7') = 1,
  'OK target schema exists',
  'ERROR target schema missing'
) AS target_preflight;

SELECT IF(
  (SELECT COUNT(*) FROM information_schema.TABLES
   WHERE TABLE_SCHEMA = 'bohrcraft_oxid4' AND TABLE_NAME = 'oxarticles'
     AND TABLE_TYPE = 'BASE TABLE') = 1,
  'OK source core table exists',
  'ERROR source core table missing'
) AS source_table_preflight;

SELECT IF(
  (SELECT COUNT(*) FROM information_schema.TABLES
   WHERE TABLE_SCHEMA = 'bohrcraft_oxid7' AND TABLE_NAME = 'oxarticles'
     AND TABLE_TYPE = 'BASE TABLE') = 1,
  'OK target core table exists',
  'ERROR target core table missing'
) AS target_table_preflight;

SELECT OXID, OXVERSION, OXEDITION FROM bohrcraft_oxid4.oxshops;
SELECT OXID, OXVERSION, OXEDITION FROM bohrcraft_oxid7.oxshops;

