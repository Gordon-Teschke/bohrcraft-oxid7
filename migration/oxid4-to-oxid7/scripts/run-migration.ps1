[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$migrationRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Split-Path -Parent (Split-Path -Parent $migrationRoot)
$mysql = 'C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe'
$loginPath = 'bohrcraft_migration'

$backup = Get-ChildItem -LiteralPath (Join-Path $projectRoot '.backups') -Directory |
    Sort-Object Name -Descending |
    Where-Object {
        (Test-Path (Join-Path $_.FullName 'bohrcraft_oxid4_before.sql')) -and
        (Test-Path (Join-Path $_.FullName 'bohrcraft_oxid7_before.sql'))
    } |
    Select-Object -First 1

if (-not $backup) {
    throw 'No complete source/target before-backup pair found.'
}

foreach ($dumpName in 'bohrcraft_oxid4_before.sql', 'bohrcraft_oxid7_before.sql') {
    $dumpPath = Join-Path $backup.FullName $dumpName
    $dumpTail = Get-Content -LiteralPath $dumpPath -Tail 3
    if ((Get-Item -LiteralPath $dumpPath).Length -le 0 -or
        -not ($dumpTail -match 'Dump completed')) {
        throw "Backup is incomplete: $dumpPath"
    }
}

$sqlFiles = @(
    '00-preflight.sql',
    '10-preserve-custom-schema.sql',
    '20-migrate-data.sql'
)

foreach ($sqlFile in $sqlFiles) {
    $path = Join-Path (Join-Path $migrationRoot 'sql') $sqlFile
    $sql = Get-Content -Raw -LiteralPath $path

    $sourceWritePattern = '(?im)^\s*(INSERT\s+INTO|UPDATE|DELETE\s+FROM|ALTER\s+TABLE|DROP\s+TABLE|TRUNCATE\s+TABLE|CREATE\s+TABLE|REPLACE\s+INTO)\s+`?bohrcraft_oxid4`?\.'
    if ($sql -match $sourceWritePattern) {
        throw "Read-only guard rejected source write in $sqlFile"
    }

    Write-Host "Running $sqlFile"
    $result = $sql | & $mysql --login-path=$loginPath --batch --raw 2>&1
    if ($LASTEXITCODE -ne 0) {
        $result | Write-Host
        throw "$sqlFile failed with exit code $LASTEXITCODE"
    }
    $result | Write-Host
}

$php = 'D:\xampp_php8\php\php.exe'
$viewGenerator = 'D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft\vendor\bin\oe-eshop-db_views_generate'
if (-not (Test-Path -LiteralPath $viewGenerator)) {
    throw "OXID view generator not found: $viewGenerator"
}

Write-Host 'Running OXID 7 view generator'
$viewResult = & $php $viewGenerator 2>&1
if ($LASTEXITCODE -ne 0) {
    $viewResult | Write-Host
    throw "OXID view generator failed with exit code $LASTEXITCODE"
}
$viewResult | Write-Host

Write-Host "Migration and OXID view generation completed. Backup: $($backup.FullName)"

