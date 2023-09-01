Class constructor
	
	This:C1470.dataType:="text"
	This:C1470.data:=""
	This:C1470.dataError:=""
	
	This:C1470.timeout:=60
	This:C1470.currentDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2).path
	
	This:C1470.loggedIn:=False:C215
	
	//⚠️ The answers are all in the error stream
	
Function onResponse($systemWorker : 4D:C1709.SystemWorker)
	
	// .response is always empty
	
Function onData($systemWorker : 4D:C1709.SystemWorker; $info : Object)
	
	// Never called
	
Function onDataError($systemWorker : 4D:C1709.SystemWorker; $info : Object)
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?mi-s)([[:xdigit:]]{4}-[[:xdigit:]]{4}).*"; $info.data; 1; $pos; $len))
		
		var $winRef : Integer
		$winRef:=Open form window:C675("DEVICE ACTIVATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5)
		DIALOG:C40("DEVICE ACTIVATION"; {otc: Substring:C12($info.data; $pos{1}; $len{1})})
		CLOSE WINDOW:C154
		
	End if 
	
Function onTerminate($systemWorker : 4D:C1709.SystemWorker)
	
	This:C1470.loggedIn:=Match regex:C1019("(?mi-s)gh config set -h github.com git_protocol https"; $systemWorker.responseError; 1)
	
	If (Not:C34(This:C1470.loggedIn))
		
		var $body : Text
		$body:="Response: "+$systemWorker.response
		$body+="ResponseError: "+$systemWorker.responseError
		
		This:C1470._createFile("onTerminate"; $body)
		
	End if 
	
Function _createFile($title : Text; $body : Text)
	
	TEXT TO DOCUMENT:C1237(Get 4D folder:C485(Current resources folder:K5:16; *)+$title+".txt"; $body)
	