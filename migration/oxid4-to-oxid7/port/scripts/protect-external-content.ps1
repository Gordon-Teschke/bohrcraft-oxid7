[CmdletBinding()]
param(
    [string]$LoginPath = 'bohrcraft_migration',
    [string]$Database = 'bohrcraft_oxid7',
    [string]$MySql = 'C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
function Convert-HexToUtf8([string]$Hex) {
    if ([string]::IsNullOrEmpty($Hex)) { return '' }
    $bytes = [byte[]]::new($Hex.Length / 2)
    for ($i = 0; $i -lt $Hex.Length; $i += 2) { $bytes[$i / 2] = [Convert]::ToByte($Hex.Substring($i, 2), 16) }
    return [Text.Encoding]::UTF8.GetString($bytes)
}
function Convert-Utf8ToHex([string]$Text) {
    return ([BitConverter]::ToString([Text.Encoding]::UTF8.GetBytes($Text))).Replace('-', '')
}
function Protect-ExternalFrames([string]$Text, [string]$ButtonLabel, [string]$Explanation) {
    $pattern = '<iframe\b(?=[^>]*\bsrc=(["''])(?<src>.*?)\1)[^>]*>\s*</iframe>'
    $replacement = {
        param($match)
        $src = $match.Groups['src'].Value
        return '<div class="bohrcraft-external" data-external-provider="youtube" data-external-src="' + $src + '">' +
            '<p>' + $Explanation + '</p>' +
            '<button class="btn btn-primary" type="button" data-load-external="youtube">' + $ButtonLabel + '</button></div>'
    }
    $result = [regex]::Replace($Text, $pattern, $replacement, [Text.RegularExpressions.RegexOptions]::IgnoreCase)
    return $result.Replace('https://www.bohrcraft.de/', '/')
}
$query = "SELECT OXID, HEX(OXCONTENT), HEX(OXCONTENT_1) FROM oxcontents WHERE OXLOADID LIKE 'bc_video%'"
$rows = & $MySql "--login-path=$LoginPath" --batch --raw --skip-column-names $Database -e $query
if ($LASTEXITCODE -ne 0) { throw 'Reading CMS video content failed.' }
$sql = [Collections.Generic.List[string]]::new()
foreach ($row in $rows) {
    $columns = $row -split [char]9, 3
    if ($columns.Count -ne 3) { continue }
    $de = Protect-ExternalFrames (Convert-HexToUtf8 $columns[1]) 'Video laden' 'Das Video wird erst nach deinem Klick von YouTube geladen.'
    $en = Protect-ExternalFrames (Convert-HexToUtf8 $columns[2]) 'Load video' 'The video is loaded from YouTube only after your click.'
    $sql.Add("UPDATE oxcontents SET OXCONTENT=CONVERT(0x$(Convert-Utf8ToHex $de) USING utf8), OXCONTENT_1=CONVERT(0x$(Convert-Utf8ToHex $en) USING utf8) WHERE OXID='$($columns[0])';")
}
$sql.Add("UPDATE oxcontents SET OXCONTENT=REPLACE(OXCONTENT,'https://www.bohrcraft.de/','/'), OXCONTENT_1=REPLACE(OXCONTENT_1,'https://www.bohrcraft.de/','/');")
$sql.Add("UPDATE oxcategories SET OXLONGDESC=REPLACE(OXLONGDESC,'https://www.bohrcraft.de/','/'), OXLONGDESC_1=REPLACE(OXLONGDESC_1,'https://www.bohrcraft.de/','/');")
$sql.Add("UPDATE oxactions SET OXLONGDESC=REPLACE(OXLONGDESC,'https://www.bohrcraft.de/','/'), OXLONGDESC_1=REPLACE(OXLONGDESC_1,'https://www.bohrcraft.de/','/');")
$sql.Add("UPDATE oxcontents SET OXCONTENT=REPLACE(OXCONTENT,'{{ oCont.oxcontents__oxcontent.value }}','{{ include(template_from_string(oCont.oxcontents__oxcontent.value)) | sanitize_html }}'), OXCONTENT_1=REPLACE(OXCONTENT_1,'{{ oCont.oxcontents__oxcontent.value }}','{{ include(template_from_string(oCont.oxcontents__oxcontent.value)) | sanitize_html }}');")
$sql.Add("UPDATE oxcategories SET OXTEMPLATE='page/list/listoxomi' WHERE OXTEMPLATE='page/list/listoxomi.tpl';")
$tempSql = Join-Path ([IO.Path]::GetTempPath()) ('bohrcraft-cms-' + [guid]::NewGuid().ToString('N') + '.sql')
try {
    [IO.File]::WriteAllLines($tempSql, $sql, [Text.UTF8Encoding]::new($false))
    & $MySql "--login-path=$LoginPath" --default-character-set=utf8 $Database "--execute=source $($tempSql.Replace('\','/'))"
    if ($LASTEXITCODE -ne 0) { throw 'Updating CMS content failed.' }
}
finally {
    if (Test-Path -LiteralPath $tempSql) { Remove-Item -LiteralPath $tempSql -Force }
}
Write-Host "Protected $($rows.Count) bilingual CMS video rows and updated the OXOMI category template."
