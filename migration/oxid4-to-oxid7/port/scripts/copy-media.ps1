[CmdletBinding()]
param([string]$Oxid4Root='D:\xampp\htdocs\www.bohrcraft-oxid4.de\httpdocs',[string]$Oxid7Root='D:\xampp_php8\htdocs\www.bohrcraft.de\httpdocs\bohrcraft')
$ErrorActionPreference='Stop'
$pairs=@(
@((Join-Path $Oxid4Root 'out\pictures'),(Join-Path $Oxid7Root 'source\out\pictures')),
@((Join-Path $Oxid4Root 'out\files'),(Join-Path $Oxid7Root 'source\out\files')),
@((Join-Path $Oxid4Root 'out\downloads'),(Join-Path $Oxid7Root 'source\out\downloads')))
foreach($pair in $pairs){& robocopy.exe $pair[0] $pair[1] /E /R:2 /W:1 /NFL /NDL /NP;if($LASTEXITCODE -gt 7){throw "Robocopy failed with exit code $LASTEXITCODE for $($pair[0])"}}
foreach($pair in $pairs){$s=Get-ChildItem -LiteralPath $pair[0] -Recurse -File|Measure-Object Length -Sum;$t=Get-ChildItem -LiteralPath $pair[1] -Recurse -File|Measure-Object Length -Sum;[pscustomobject]@{Path=(Split-Path $pair[0] -Leaf);SourceFiles=$s.Count;TargetFiles=$t.Count;SourceBytes=$s.Sum;TargetBytes=$t.Sum}}
