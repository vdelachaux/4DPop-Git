//%attributes = {"invisible":true}
var $manager : Text
var $instance : 4D:C1709.Class

$manager:="handleMenus"
$instance:=formGetInstance

If (Asserted:C1132(OB Instance of:C1731($instance[$manager]; 4D:C1709.Function); "The function \""+$manager+"\" is missing in the class\""+$instance.__CLASS__.name+"\""))
	
	$instance[$manager](Get selected menu item parameter:C1005)
	
End if 