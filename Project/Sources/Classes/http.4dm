property success : Boolean
property method : Text
property headers : Object
property errors; METHODS; warnings : Collection

Class constructor($url : Text; $method : Text; $headers : Object; $body)
	
	This:C1470.success:=True:C214
	This:C1470.URL:=$url
	
	This:C1470[""]:={\
		METHODS: ["HEAD"; "GET"; "POST"; "PATCH"; "PUSH"; "DELETE"]\
		}
	
	This:C1470.errors:=[]
	This:C1470.warnings:=[]
	
	This:C1470.method:=Length:C16($method)=0 ? "GET" : $method  // GET is the default method
	
	If (Not:C34(This:C1470[""].METHODS.includes(This:C1470.method)))
		
		This:C1470._pushError("method must be in : "+This:C1470[""].METHODS.join(", "))
		return 
		
	End if 
	
	This:C1470.headers:=$headers || {}  // Empty object if not provided
	This:C1470.body:=$body  // Note that "body" is a variant!
	
	// MARK:Delegates 📦
	This:C1470.HTTPRequest:=4D:C1709.HTTPRequest
	
	This:C1470.dev:=(Structure file:C489=Structure file:C489(*))
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get error() : Text
	
	return This:C1470.errors.length>0 ? This:C1470.errors.last() : ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onResponse method, if you want to handle the request asynchronously
	ASSERT:C1129(False:C215; "👀 onResponse() must be overriden by the subclass!")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onError method, if you want to handle the request asynchronously
	ASSERT:C1129(False:C215; "👀 onError() must be overriden by the subclass!")
	
	//MARK:-[PRIVATE]
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushError($message : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push($message)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushWarning($message : Text)
	
	This:C1470.warnings.push($message)
	