property method:="GET"
property body:=""

property headers : Object
property target : 4D:C1709.Function

Class constructor($headers : Object; $target : 4D:C1709.Function)
	
	This:C1470.headers:=$headers
	This:C1470.target:=$target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	var $p : Picture
	BLOB TO PICTURE:C682($request.response.body; $p)
	
	If (This:C1470.target#Null:C1517)
		
		This:C1470.target.call(Null:C1517; $p)
		
	Else 
		
		If (Form:C1466#Null:C1517)
			
			Form:C1466[$request.headers.user]:=$p
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	If (Form:C1466#Null:C1517)
		
		var $p : Picture
		READ PICTURE FILE:C678(File:C1566("/.PRODUCT_RESOURCES/Internal Components/runtime.4dbase/Resources/images/toolbox/users_groups/904.png").platformPath; $p)
		Form:C1466[$request.headers.user]:=$p
		
	End if 