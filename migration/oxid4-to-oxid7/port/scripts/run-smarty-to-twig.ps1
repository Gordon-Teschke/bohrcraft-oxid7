[CmdletBinding()]
param([string]$ShopRoot='D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft',[string]$ConverterRoot='D:\xampp_php8\htdocs\smarty-to-twig-converter-master',[string]$Php='D:\xampp_php8\php\php.exe',[switch]$Apply)
$ErrorActionPreference='Stop'
$bootstrap=(Join-Path $ShopRoot 'source\bootstrap.php').Replace('\','/')
$config=Join-Path ([IO.Path]::GetTempPath()) ('bohrcraft-converter-'+[guid]::NewGuid().ToString('N')+'.php')
$content=@'
<?php
use OxidEsales\Eshop\Core\DatabaseProvider;
require '__BOOTSTRAP__';
$db=DatabaseProvider::getDb();
$db->setFetchMode($db::FETCH_MODE_ASSOC);
$sourceConverter=new \toTwig\SourceConverter\DatabaseConverter($db->getPublicConnection());
return \toTwig\Config\Config::create()->setSourceConverter($sourceConverter);
'@
$content=$content.Replace('__BOOTSTRAP__',$bootstrap)
try{[IO.File]::WriteAllText($config,$content,[Text.UTF8Encoding]::new($false));Push-Location $ConverterRoot;try{$arguments=@('.\toTwig','convert',"--config-path=$config",'--verbose');if(-not $Apply){$arguments+='--dry-run'};& $Php @arguments;if($LASTEXITCODE){throw 'Smarty-to-Twig conversion failed.'}}finally{Pop-Location}}finally{if(Test-Path -LiteralPath $config){Remove-Item -LiteralPath $config -Force}}
