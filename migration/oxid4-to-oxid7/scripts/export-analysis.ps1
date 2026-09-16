[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('before', 'after')]
    [string]$Label
)

$ErrorActionPreference = 'Stop'
$migrationRoot = Split-Path -Parent $PSScriptRoot
$evidenceDir = Join-Path $migrationRoot 'evidence'
$mysql = 'C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe'
$loginPath = 'bohrcraft_migration'

New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null

function Invoke-MySqlQuery {
    param(
        [Parameter(Mandatory)][string]$Sql,
        [switch]$SkipColumnNames
    )

    $arguments = @("--login-path=$loginPath", '--batch', '--raw')
    if ($SkipColumnNames) {
        $arguments += '--skip-column-names'
    }
    $arguments += @('-e', $Sql)

    $output = & $mysql @arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "MySQL query failed: $output"
    }
    return $output
}

$tablesSql = @'
SELECT TABLE_SCHEMA,TABLE_NAME,TABLE_TYPE,IFNULL(ENGINE,'') AS ENGINE,
       IFNULL(TABLE_COLLATION,'') AS TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA IN ('bohrcraft_oxid4','bohrcraft_oxid7')
ORDER BY TABLE_SCHEMA,TABLE_TYPE,TABLE_NAME
'@
Invoke-MySqlQuery -Sql $tablesSql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "tables-$Label.tsv")

$columnsSql = @'
SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,ORDINAL_POSITION,COLUMN_TYPE,
       IS_NULLABLE,IFNULL(COLUMN_DEFAULT,'<NULL>') AS COLUMN_DEFAULT,
       EXTRA,IFNULL(COLLATION_NAME,'') AS COLLATION_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA IN ('bohrcraft_oxid4','bohrcraft_oxid7')
ORDER BY TABLE_SCHEMA,TABLE_NAME,ORDINAL_POSITION
'@
Invoke-MySqlQuery -Sql $columnsSql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "columns-$Label.tsv")

$indexesSql = @'
SELECT TABLE_SCHEMA,TABLE_NAME,INDEX_NAME,NON_UNIQUE,SEQ_IN_INDEX,COLUMN_NAME,
       IFNULL(SUB_PART,'') AS SUB_PART,INDEX_TYPE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA IN ('bohrcraft_oxid4','bohrcraft_oxid7')
ORDER BY TABLE_SCHEMA,TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX
'@
Invoke-MySqlQuery -Sql $indexesSql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "indexes-$Label.tsv")

$countsSql = @'
SET SESSION group_concat_max_len=1048576;
SELECT GROUP_CONCAT(
  CONCAT('SELECT ''',TABLE_SCHEMA,''' AS schema_name, ''',TABLE_NAME,
         ''' AS table_name, COUNT(*) AS row_count FROM ',CHAR(96),TABLE_SCHEMA,
         CHAR(96),'.',CHAR(96),TABLE_NAME,CHAR(96))
  ORDER BY TABLE_SCHEMA,TABLE_NAME SEPARATOR ' UNION ALL '
) INTO @sql
FROM information_schema.TABLES
WHERE TABLE_SCHEMA IN ('bohrcraft_oxid4','bohrcraft_oxid7')
  AND TABLE_TYPE='BASE TABLE';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
'@
Invoke-MySqlQuery -Sql $countsSql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "counts-$Label.tsv")

$sourceTablesSql = @'
SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='bohrcraft_oxid4' AND TABLE_TYPE='BASE TABLE'
ORDER BY TABLE_NAME
'@
$sourceTables = @(Invoke-MySqlQuery -Sql $sourceTablesSql -SkipColumnNames)
$qualifiedTables = $sourceTables | ForEach-Object { "``bohrcraft_oxid4``.``$_``" }
$checksumSql = 'CHECKSUM TABLE ' + ($qualifiedTables -join ',')
Invoke-MySqlQuery -Sql $checksumSql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "source-checksums-$Label.tsv")

$summarySql = @'
SELECT VERSION() AS mysql_version,@@character_set_server AS server_charset,
       @@collation_server AS server_collation;
SELECT SCHEMA_NAME,DEFAULT_CHARACTER_SET_NAME,DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA
WHERE SCHEMA_NAME IN ('bohrcraft_oxid4','bohrcraft_oxid7')
ORDER BY SCHEMA_NAME;
SELECT 'source' AS schema_role,OXID,OXVERSION,OXEDITION,OXDEFLANGUAGE
FROM bohrcraft_oxid4.oxshops
UNION ALL
SELECT 'target',OXID,OXVERSION,OXEDITION,OXDEFLANGUAGE
FROM bohrcraft_oxid7.oxshops;
'@
Invoke-MySqlQuery -Sql $summarySql |
    Set-Content -Encoding utf8 -LiteralPath (Join-Path $evidenceDir "environment-$Label.tsv")

Write-Host "Analysis exported to $evidenceDir ($Label)"
