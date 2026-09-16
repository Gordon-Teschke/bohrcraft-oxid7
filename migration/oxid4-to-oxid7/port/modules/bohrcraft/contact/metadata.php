<?php
declare(strict_types=1);
use Bohrcraft\Contact\Controller\CatalogController;
use Bohrcraft\Contact\Controller\ContactController;
$sMetadataVersion='2.1';
$aModule=[
'id'=>'bohrcraft_contact','title'=>'Bohrcraft contact forms',
'description'=>['de'=>'Portiert die Bohrcraft-Kontakt- und Katalogformulare ohne Core-Hacks.','en'=>'Ports the Bohrcraft contact and catalogue forms without core hacks.'],
'version'=>'1.0.0','author'=>'Bohrcraft Werkzeuge GmbH & Co. KG',
'extend'=>[\OxidEsales\Eshop\Application\Controller\ContactController::class=>ContactController::class],
'controllers'=>['contact2'=>CatalogController::class,'contact2a'=>CatalogController::class,'contact2b'=>CatalogController::class,'contactnew'=>CatalogController::class],
];
