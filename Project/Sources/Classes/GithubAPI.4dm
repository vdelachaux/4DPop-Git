property method : Text
property headers : Object
property METHODS : Collection

Class constructor($method : Text; $headers : Object; $body)
	
	This:C1470.URL:="https://api.github.com"
	
	This:C1470.METHODS:=[\
		"HEAD"; \
		"GET"; \
		"POST"; \
		"PATCH"; \
		"PUSH"; \
		"DELETE"\
		]
	
	// GET is the default method
	$method:=Length:C16($method)=0 ? "GET" : $method
	
	If (This:C1470.METHODS.indexOf($method)=-1)
		
		ASSERT:C1129(False:C215; "method must be in : "+This:C1470.METHODS.join(", "))
		return 
		
	End if 
	
	This:C1470.method:=$method
	This:C1470.headers:=$headers
	This:C1470.body:=$body  // Note that "body" is a variant!
	
	This:C1470.headers:=This:C1470.headers || {}  // Empty object if not provided
	
	This:C1470.headers["User-Agent"]:="4DPop-git"
	This:C1470.headers["X-GitHub-Api-Version"]:="2022-11-28"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function authToken($token : Text) : cs:C1710.GithubAPI
	
	This:C1470.headers.Authorization:="Bearer "+$token
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CommpliantRepositoryName($name : Text) : Text
	
	var $len; $pos : Integer
	var $c : Collection
	
	$c:=[]
	
	While (Match regex:C1019("(?mi-s)([^[:alnum:]]+)"; $name; 1; $pos; $len))
		
		$c.push(Substring:C12($name; 1; $pos-1))
		
		$name:=Delete string:C232($name; 1; $pos+$len-1)
		
	End while 
	
	$c.push($name)
	
	return $c.join("-")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onResponse method, if you want to handle the request asynchronously
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onError method, if you want to handle the request asynchronously
	
	