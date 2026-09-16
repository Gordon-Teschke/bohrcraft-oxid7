<?php
declare(strict_types=1);
namespace Bohrcraft\Contact\Controller;
use OxidEsales\Eshop\Core\Registry;
use OxidEsales\Eshop\Core\UtilsView;
/** @eshopExtension @mixin \OxidEsales\Eshop\Application\Controller\ContactController */
class ContactController extends ContactController_parent
{
public function send()
{
$request=Registry::getRequest();$values=$request->getRequestParameter('editval',[]);$values=is_array($values)?$values:[];
$required=['oxuser__oxfname','oxuser__oxlname','oxuser__oxstreet','oxuser__postcode','oxuser__city','oxuser__country','oxuser__oxfon','oxuser__oxusername'];
foreach($required as $field){if(trim((string)($values[$field]??''))===''){Registry::get(UtilsView::class)->addErrorToDisplay('ERROR_MESSAGE_INPUT_NOTALLFIELDS');return false;}}
if(!$request->getRequestParameter('c_oegdproptin')){Registry::get(UtilsView::class)->addErrorToDisplay('OEGDPROPTIN_CONTACT_FORM_ERROR_MESSAGE');return false;}
$labels=['oxuser__oxcompany'=>'Firma','oxuser__oxstreet'=>'Straße','oxuser__postcode'=>'PLZ','oxuser__city'=>'Ort','oxuser__country'=>'Land','oxuser__oxfon'=>'Telefon','oxuser__oxiam'=>'Ich bin'];$details=[];
foreach($labels as $field=>$label){$value=trim(strip_tags((string)($values[$field]??'')));if($value!=='')$details[]=$label.': '.$value;}
$message=trim(strip_tags((string)$request->getRequestParameter('c_message','')));
$_POST['c_message']=implode(PHP_EOL,$details).($details?PHP_EOL.PHP_EOL:'').$message;
return parent::send();
}
}
