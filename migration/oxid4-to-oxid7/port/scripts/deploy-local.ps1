[CmdletBinding()]
param([string]$ShopRoot='D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft',[string]$Php='D:\xampp_php8\php\php.exe',[string]$Composer='composer')
$ErrorActionPreference='Stop'
$portRoot=Split-Path -Parent $PSScriptRoot
$source=Join-Path $ShopRoot 'source'
$themeSource=Join-Path $portRoot 'source\Application\views\bohrcraft'
$outSource=Join-Path $portRoot 'source\out\bohrcraft'
$moduleSource=Join-Path $portRoot 'modules\bohrcraft\contact'
$themeTarget=Join-Path $source 'Application\views\bohrcraft'
$outTarget=Join-Path $source 'out\bohrcraft'
$moduleTarget=Join-Path $ShopRoot 'modules\bohrcraft\contact'
foreach($target in @($themeTarget,$outTarget,$moduleTarget)){[IO.Directory]::CreateDirectory($target)|Out-Null}
Copy-Item -Path (Join-Path $themeSource '*') -Destination $themeTarget -Recurse -Force
Copy-Item -Path (Join-Path $outSource '*') -Destination $outTarget -Recurse -Force
Copy-Item -Path (Join-Path $moduleSource '*') -Destination $moduleTarget -Recurse -Force
$composerJson=Join-Path $ShopRoot 'composer.json'
$config=Get-Content -LiteralPath $composerJson -Raw|ConvertFrom-Json -AsHashtable
$config['autoload']=[ordered]@{'psr-4'=[ordered]@{'Bohrcraft\Contact\'='modules/bohrcraft/contact/src/'}}
[IO.File]::WriteAllText($composerJson,($config|ConvertTo-Json -Depth 20)+[Environment]::NewLine,[Text.UTF8Encoding]::new($false))
Push-Location $ShopRoot
try{& $Composer dump-autoload;if($LASTEXITCODE){throw 'Composer dump-autoload failed.'}}finally{Pop-Location}
$console=Join-Path $ShopRoot 'vendor\bin\oe-console'
Push-Location (Join-Path $source 'out\modules')
try{$moduleConfig=Join-Path $ShopRoot 'var\configuration\shops\1\modules\bohrcraft_contact.yaml';if(Test-Path -LiteralPath $moduleConfig){& $Php $console oe:module:deactivate bohrcraft_contact -n;if($LASTEXITCODE){throw 'Module deactivation failed.'}};& $Php $console oe:module:install $moduleTarget -n;if($LASTEXITCODE){throw 'Module installation failed.'};& $Php $console oe:module:activate bohrcraft_contact -n;if($LASTEXITCODE){throw 'Module activation failed.'}}finally{Pop-Location}
Push-Location $ShopRoot
try{& $Php $console oe:theme:activate bohrcraft -n;if($LASTEXITCODE){throw 'Theme activation failed.'};& $Php $console oe:cache:clear}finally{Pop-Location}
Write-Host 'Bohrcraft theme and contact module deployed and activated.'
