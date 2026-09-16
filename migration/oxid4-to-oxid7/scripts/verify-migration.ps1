[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$migrationRoot = Split-Path -Parent $PSScriptRoot
$evidenceDir = Join-Path $migrationRoot 'evidence'
$mysql = 'C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe'
$loginPath = 'bohrcraft_migration'
$verificationSql = Join-Path (Join-Path $migrationRoot 'sql') '40-verify.sql'

$sql = Get-Content -Raw -LiteralPath $verificationSql
$output = $sql | & $mysql --login-path=$loginPath --batch --raw 2>&1
if ($LASTEXITCODE -ne 0) {
    $output | Write-Host
    throw "Verification SQL failed with exit code $LASTEXITCODE"
}

$resultPath = Join-Path $evidenceDir 'verification-results.tsv'
$output | Set-Content -Encoding utf8 -LiteralPath $resultPath
$output | Write-Host

$failedLines = @($output | Where-Object { $_ -match "`t(MISMATCH|ERROR)$" })
if ($failedLines.Count -gt 0) {
    throw "Verification reported $($failedLines.Count) mismatch/error row(s)."
}

$beforePath = Join-Path $evidenceDir 'source-checksums-before.tsv'
$afterPath = Join-Path $evidenceDir 'source-checksums-after.tsv'
if (-not (Test-Path $beforePath) -or -not (Test-Path $afterPath)) {
    throw 'Source checksum evidence before/after is incomplete.'
}

$sourceDifference = @(Compare-Object `
    -ReferenceObject (Get-Content -LiteralPath $beforePath) `
    -DifferenceObject (Get-Content -LiteralPath $afterPath))
if ($sourceDifference.Count -gt 0) {
    $sourceDifference | Format-Table | Out-String | Write-Host
    throw 'Read-only source verification failed: checksum differences found.'
}

Write-Host 'Verification passed, including unchanged source checksums.'

