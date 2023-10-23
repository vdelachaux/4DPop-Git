//%attributes = {}
#DECLARE($data : Object; $function : Text)

If (False:C215)
	C_OBJECT:C1216(formCallBack; $1)
	C_TEXT:C284(formCallBack; $2)
End if 

var $instance : 4D:C1709.Class

$function:=Length:C16($function)>0 ? $function : "callback"
$instance:=formGetInstance

If (Asserted:C1132(OB Instance of:C1731($instance[$function]; 4D:C1709.Function); "The function \""+$function+"\" is missing in the class\""+$instance.__CLASS__.name+"\""))
	
	$instance[$function]($data)
	
End if 