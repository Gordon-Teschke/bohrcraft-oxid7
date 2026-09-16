[CmdletBinding()]
param([string]$ShopRoot='D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft',[string]$BaseUrl='http://local.bohrcraft-oxid7.de',[string]$Database='bohrcraft_oxid7',[string]$LoginPath='bohrcraft_migration',[string]$MySql='C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe',[string]$Php='D:\xampp_php8\php\php.exe')
$ErrorActionPreference='Stop'
$results=[Collections.Generic.List[object]]::new()
function Add-Result($Check,$Passed,$Details){$results.Add([pscustomobject]@{Check=$Check;Passed=[bool]$Passed;Details=$Details})}
$portRoot=Split-Path -Parent $PSScriptRoot
Get-ChildItem -LiteralPath $portRoot -Recurse -Filter '*.php'|ForEach-Object{$output=& $Php -l $_.FullName 2>&1;Add-Result "php:$($_.Name)" ($LASTEXITCODE -eq 0) ($output -join ' ')}
& node --check (Join-Path $portRoot 'source\out\bohrcraft\src\js\bohrcraft.js')
Add-Result 'javascript:bohrcraft.js' ($LASTEXITCODE -eq 0) 'node --check'
$urls=@('/','/de/Marken/','/Produkte/Unser-Werkzeugprogramm/','/Service/Aktionen','/Unternehmen/Profil','/kontakt/','/index.php?cl=contact2','/de/Service/Downloads-Online-Blaettern-News/','/de/Datenschutz/','/de/Impressum/','/de/Nach-Hersteller/Bohrcraft/Werkzeughalter-mit-Knarre-kurze-Ausfuehrung.html','/Brands/','/Privacy-Policy/')
foreach($path in $urls){try{$response=Invoke-WebRequest -Uri ($BaseUrl+$path) -UseBasicParsing -MaximumRedirection 8 -TimeoutSec 30;$clean=($response.StatusCode -eq 200 -and $response.Content -notmatch 'Fatal error|Template not found|EXCEPTION_SYSTEMCOMPONENT');Add-Result "http:$path" $clean "status=$($response.StatusCode); bytes=$($response.Content.Length)"}catch{Add-Result "http:$path" $false $_.Exception.Message}}
$downloads=@('/out/files/PDF/AGB_Bohrcraft.pdf','/out/files/PDF/BOHRCRAFT_HK2024_DE_EN_web.pdf','/out/files/PDF/anwendung-empfehlung/anwendungsuebersicht_spiralbohrer.pdf')
foreach($path in $downloads){try{$response=Invoke-WebRequest -Uri ($BaseUrl+$path) -UseBasicParsing -Method Head -MaximumRedirection 8 -TimeoutSec 30;Add-Result "download:$path" ($response.StatusCode -eq 200) "status=$($response.StatusCode); type=$($response.Headers['Content-Type'])"}catch{Add-Result "download:$path" $false $_.Exception.Message}}
$smartyFiles=Get-ChildItem -LiteralPath (Join-Path $portRoot 'source\Application\views\bohrcraft') -Recurse -File|Select-String -Pattern '\[\{' -List
Add-Result 'theme:smarty-remnants' ($smartyFiles.Count -eq 0) (($smartyFiles|ForEach-Object Path)-join '; ')
$query="SELECT CONCAT('smarty=',SUM(c)) FROM (SELECT (OXCONTENT REGEXP '\\[\\{')+(OXCONTENT_1 REGEXP '\\[\\{') c FROM oxcontents UNION ALL SELECT (OXLONGDESC REGEXP '\\[\\{')+(OXLONGDESC_1 REGEXP '\\[\\{') FROM oxcategories UNION ALL SELECT (OXLONGDESC REGEXP '\\[\\{')+(OXLONGDESC_1 REGEXP '\\[\\{') FROM oxactions) x; SELECT CONCAT('iframe=',SUM((OXCONTENT LIKE '%<iframe%')+(OXCONTENT_1 LIKE '%<iframe%'))) FROM oxcontents; SELECT CONCAT('oxomi_template=',COUNT(*)) FROM oxcategories WHERE OXTEMPLATE='page/list/listoxomi';"
$dbOutput=& $MySql "--login-path=$LoginPath" --batch --raw --skip-column-names $Database -e $query
Add-Result 'database:smarty' ($dbOutput -contains 'smarty=0') ($dbOutput -join '; ')
Add-Result 'database:external-iframes' ($dbOutput -contains 'iframe=0') ($dbOutput -join '; ')
Add-Result 'database:oxomi-template' ($dbOutput -contains 'oxomi_template=1') ($dbOutput -join '; ')
$outputPath=Join-Path (Split-Path -Parent $portRoot) 'evidence\full-port-verification.tsv'
[IO.Directory]::CreateDirectory((Split-Path -Parent $outputPath))|Out-Null
$lines=[Collections.Generic.List[string]]::new();$lines.Add([string]::Join([char]9,@('check','passed','details')))
foreach($item in $results){$detail=$item.Details.Replace([char]13,' ').Replace([char]10,' ');$lines.Add([string]::Join([char]9,@($item.Check,$item.Passed,$detail)))}
[IO.File]::WriteAllLines($outputPath,$lines,[Text.UTF8Encoding]::new($false))
$results|Format-Table -AutoSize
if($results.Where({-not $_.Passed}).Count){throw 'One or more port verification checks failed.'}