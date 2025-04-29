Class extends widget

property errors:=[]
property filterdURLs:=[]
property success:=False:C215

property _url:=""

Class constructor($name : Text; $data; $parent : Object)
	
	Super:C1705($name; $parent)
	
	ARRAY TEXT:C222($filters; 0)
	ARRAY BOOLEAN:C223($allowed; 0)
	
	// All are forbidden
	APPEND TO ARRAY:C911($filters; "*")  // All
	APPEND TO ARRAY:C911($allowed; False:C215)
	
	APPEND TO ARRAY:C911($filters; "about:blank")  // Allow  blank HTML document
	APPEND TO ARRAY:C911($allowed; True:C214)
	
	WA SET URL FILTERS:C1030(*; This:C1470.name; $filters; $allowed)
	
	If ($data#Null:C1517)
		
		This:C1470.allow($data)
		
	Else 
		
		// Allow WA SET PAGE CONTENT
		APPEND TO ARRAY:C911($filters; "file*")
		APPEND TO ARRAY:C911($allowed; True:C214)  // To allow including HTML files
		
		WA SET URL FILTERS:C1030(*; This:C1470.name; $filters; $allowed)
		
	End if 
	
	// Active the contextual menu in debug mode
	WA SET PREFERENCE:C1041(*; This:C1470.name; WA enable contextual menu:K62:6; Not:C34(Is compiled mode:C492) | (Structure file:C489=Structure file:C489(*)))
	WA SET PREFERENCE:C1041(*; This:C1470.name; WA enable Web inspector:K62:7; True:C214)
	
	This:C1470.success:=True:C214
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get url() : Text
	
	return WA Get current URL:C1025(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set url($data)
	
	This:C1470.open($data)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function open($data)
	
	Case of 
			
			//……………………………………………………………………………………………………
		: ($data=Null:C1517)\
			 || (Value type:C1509($data)=Is text:K8:3)
			
			This:C1470._url:=String:C10($data)
			
			//……………………………………………………………………………………………………
		: (Value type:C1509($data)=Is object:K8:27)
			
			If (OB Instance of:C1731($data; 4D:C1709.File))
				
				This:C1470._url:="file:///"+$data.path
				
			Else 
				
				This:C1470._pushError(Current method name:C684+": $data is not a File object")
				
			End if 
			
			//……………………………………………………………………………………………………
		Else 
			
			This:C1470._pushError(Current method name:C684+": $data must be a text or a File object")
			
			//……………………………………………………………………………………………………
	End case 
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//……………………………………………………………………………………………………
		: (Length:C16(This:C1470._url)=0)
			
			This:C1470._url:="about:blank"
			
			//……………………………………………………………………………………………………
		: (This:C1470._url="internal")  // Current database server
			
			This:C1470._url:="127.0.0.1:"+String:C10(WEB Get server info:C1531.options.webPortID)
			
			//……………………………………………………………………………………………………
		: (This:C1470._url="localhost")\
			 & Is macOS:C1572  //#TURN_AROUND - In some cases, using "localhost" we get the error -30 "Server unreachable"
			
			This:C1470._url:="127.0.0.1"
			
			//……………………………………………………………………………………………………
	End case 
	
	This:C1470.allow(This:C1470._url)
	
	WA OPEN URL:C1020(*; This:C1470.name; This:C1470._url)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clear()
	
	This:C1470.open()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showInspector()
	
	WA OPEN WEB INSPECTOR:C1736(*; This:C1470.name)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get content() : Text
	
	return WA Get page content:C1038(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set content($content : Text)
	
	WA SET PAGE CONTENT:C1037(*; This:C1470.name; $content; "/")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set the web area content
Function setContent($content : Text)  //; $base : Text)
	
	//⚠️ As WA SET PAGE CONTENT, on Windows, don't accepts relative references,
	// the page to display must be processed and saved into a temp file then displayed with WA OPEN URL.
	
	var $file : 4D:C1709.File:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("index.html")
	$file.setText($content)
	This:C1470.load($file)
	
	return 
	
	//$base:=$base || "/"
	//WA SET PAGE CONTENT(*; This.name; $content; $base)
	//This.success:=True
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function load($file : 4D:C1709.File)
	
	If ($file=Null:C1517)
		
		This:C1470._pushError(Current method name:C684+": Missing a 4D File")
		return 
		
	End if 
	
	If (Not:C34($file.exists))
		
		This:C1470._pushError(Current method name:C684+": File not found: \""+$file.path+"\"")
		return 
		
	End if 
	
	var $x : Blob
	DOCUMENT TO BLOB:C525($file.platformPath; $x)
	
	If (OK=0)
		
		This:C1470._pushError(Current method name:C684+": DOCUMENT TO BLOB failed")
		return 
		
	End if 
	
	var $t:=Convert to text:C1012($x; "UTF-8")
	
	If (OK=0)
		
		This:C1470._pushError(Current method name:C684+": Convert to text failed")
		return 
		
	End if 
	
	This:C1470.success:=True:C214
	
	// Process tags
	PROCESS 4D TAGS:C816($t; $t)
	
	// Cleanup
	$t:=Replace string:C233($t; "\r\n"; "\r")
	$t:=Replace string:C233($t; "\r"; "\n")
	
	// Temporary allow "file:// "
	ARRAY TEXT:C222($filters; 0x0000)
	ARRAY BOOLEAN:C223($allowed; 0x0000)
	WA GET URL FILTERS:C1031(*; This:C1470.name; $filters; $allowed)
	
	var $o:={\
		filters: []; \
		allowDeny: []\
		}
	
	ARRAY TO COLLECTION:C1563($o.filters; $filters)
	ARRAY TO COLLECTION:C1563($o.allowDeny; $allowed)
	
	var $index:=Find in array:C230($filters; "file*")
	
	If ($index>0)
		
		$allowed{$index}:=True:C214
		
	Else 
		
		APPEND TO ARRAY:C911($filters; "file*")
		APPEND TO ARRAY:C911($allowed; True:C214)  // Allowed
		
	End if 
	
	WA SET URL FILTERS:C1030(*; This:C1470.name; $filters; $allowed)
	
	$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($file.fullName)
	$file.setText($t)
	
	WA OPEN URL:C1020(*; This:C1470.name; $file.platformPath)
	
	// Restore filters
	COLLECTION TO ARRAY:C1562($o.filters; $filters)
	COLLECTION TO ARRAY:C1562($o.allowDeny; $allowed)
	
	WA SET URL FILTERS:C1030(*; This:C1470.name; $filters; $allowed)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function evaluateJS($code : Text; $type : Integer) : Variant
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			return WA Evaluate JavaScript:C1029(*; This:C1470.name; $code; $type)
			
		Else 
			
			return WA Evaluate JavaScript:C1029(*; This:C1470.name; $code)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function executeJS($code : Text)
	
	WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; This:C1470.name; $code)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get canBackwards() : Boolean
	
	return WA Back URL available:C1026(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function back()
	
	WA OPEN BACK URL:C1021(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function backMenu()
	
	If (This:C1470.canBackwards)
		
		var $menu:=cs:C1710.menu.new(WA Create URL history menu:C1049(*; This:C1470.name; WA previous URLs:K62:1)).popup()
		
		If ($menu.selected)
			
			This:C1470.open($menu.choice)
			
		End if 
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get canForwards() : Boolean
	
	return WA Forward URL available:C1027(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function forward()
	
	WA OPEN FORWARD URL:C1022(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function forwardMenu()
	
	If (This:C1470.canBackwards)
		
		var $menu:=cs:C1710.menu.new(WA Create URL history menu:C1049(*; This:C1470.name; WA next URLs:K62:2)).popup()
		
		If ($menu.selected)
			
			This:C1470.open($menu.choice)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isLoaded() : Boolean
	
	return WA Get current URL:C1025(*; This:C1470.name)=This:C1470._url
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get loaded() : Boolean
	
	return WA Get current URL:C1025(*; This:C1470.name)=This:C1470._url
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastFilteredURL() : Text
	
	var $url : Text
	
	$url:=WA Get last filtered URL:C1035(*; This:C1470.name)
	This:C1470.filterdURLs.push($url)
	return $url
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function refresh()
	
	WA REFRESH CURRENT URL:C1023(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function zoomIn()
	
	WA ZOOM IN:C1039(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function zoomOut()
	
	WA ZOOM OUT:C1040(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function zoom($in : Boolean)
	
	If ($in)
		
		WA ZOOM IN:C1039(*; This:C1470.name)
		
	Else 
		
		WA ZOOM OUT:C1040(*; This:C1470.name)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stop()
	
	WA STOP LOADING URL:C1024(*; This:C1470.name)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get title() : Text
	
	return WA Get page title:C1036(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getTitle() : Text
	
	return WA Get page title:C1036(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function allow($data; $allow : Boolean)
	
	ARRAY TEXT:C222($filters; 0)
	ARRAY BOOLEAN:C223($allowed; 0)
	
	If ($data=Null:C1517)
		
		This:C1470._pushError(Current method name:C684+": Missing parameter")
		return 
		
	End if 
	
	$allow:=Count parameters:C259>=2 ? $allow : True:C214
	
	This:C1470.success:=True:C214
	
	WA GET URL FILTERS:C1031(*; This:C1470.name; $filters; $allowed)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($data)=Is text:K8:3)
			
			APPEND TO ARRAY:C911($filters; $data)
			APPEND TO ARRAY:C911($allowed; $allow)
			
			//______________________________________________________
		: (Value type:C1509($data)=Is collection:K8:32)
			
			var $filter
			For each ($filter; $data)
				
				APPEND TO ARRAY:C911($filters; String:C10($filter))
				APPEND TO ARRAY:C911($allowed; $allow)
				
			End for each 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError(Current method name:C684+"$1 must be a text or a text collection")
			return 
			
			//______________________________________________________
	End case 
	
	WA SET URL FILTERS:C1030(*; This:C1470.name; $filters; $allowed)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deny($data)
	
	This:C1470.allow($data; False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Detect which web rendering engine is being used for the Web Area
	// https://kb.4d.com/assetid=78601
Function getWebEngine() : Object
	
/*
An example result:
{"Browser" : "Chrome",
"userAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"}
	
*/
	
	var $t:=WA Get current URL:C1025(*; This:C1470.name)
	
	If (($t=":///")\
		 | (Length:C16($t)=0))
		
		WA OPEN URL:C1020(*; This:C1470.name; "about:blank")
		
	End if 
	
	$t:="var ua = window.navigator.userAgent.toLowerCase();"
	$t+="var res={\"userAgent\":ua};"
	
	// Chrome
	$t+="if(ua.indexOf(\"chrome\") > -1) "
	$t+="{ res.Browser=\"Chrome\"}"
	
	// Safari
	$t+="else if(ua.indexOf(\"safari\") > -1)"
	$t+=" {res.Browser=\"Safari\";}"
	
	// Internet Explorer
	$t+="else if(ua.indexOf(\"msie\") > -1 || "
	$t+="ua.indexOf(\"rv:\") > -1)"
	$t+=" {res.Browser= \"IE\";}"
	
	// Firefox
	$t+="else if(ua.indexOf(\"firefox\") > -1)"
	$t+=" {res.Browser=\"Firefox\";}"
	
	// AppleWebKit
	$t+="else if(ua.indexOf(\"macintosh\") > -1)"
	$t+=" {res.Browser=\"AppleWebKit\";}"
	
	// Edge
	$t+="else if(ua.indexOf(\"edge\") > -1 || "
	$t+="ua.indexOf(\"edg:\") > -1)"
	$t+=" {res.Browser=\"Edge\";}"
	
	// Chromium
	$t+="else if(ua.indexOf(\"chromium\") > -1)"
	$t+=" {res.Browser=\"Chromium\";}"
	
	$t+="; res"
	
	return WA Evaluate JavaScript:C1029(*; This:C1470.name; $t; Is object:K8:27)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastError() : Text
	
	return This:C1470.errors.length>0 ? This:C1470.errors[This:C1470.errors.length-1] : ""
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushError($error : Text)
	
	This:C1470.errors.push($error)
	This:C1470.success:=False:C215