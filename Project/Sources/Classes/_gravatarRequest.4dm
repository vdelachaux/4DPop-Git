Class constructor($headers : Object; $johnDoe : Picture)
	
	This:C1470.method:="GET"
	This:C1470.headers:=$headers
	This:C1470.body:=""
	This:C1470.johnDoe:=$johnDoe
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	var $p : Picture
	BLOB TO PICTURE:C682($request.response.body; $p)
	
	If (Form:C1466#Null:C1517)
		
		Form:C1466[$request.headers.user]:=$p
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	If (Form:C1466#Null:C1517)
		
		Form:C1466[$request.headers.user]:=This:C1470.johnDoe
		
	End if 