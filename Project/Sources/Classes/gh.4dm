property errors; history : Collection
property status : Object

Class constructor
	
	This:C1470.dataType:="text"
	This:C1470.data:=""
	This:C1470.dataError:=""
	
	This:C1470.timeout:=60
	This:C1470.currentDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2).path
	
	This:C1470.success:=False:C215
	This:C1470.available:=False:C215
	This:C1470.authorized:=False:C215
	
	This:C1470.errors:=[]
	This:C1470.history:=[]
	
	This:C1470.FindExe()
	
	If (This:C1470.available)
		
		This:C1470.authorized:=This:C1470.CheckToken()
		
	Else 
		
		This:C1470.errors.push("Gh is not installed.")
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastError() : Text
	
	If (This:C1470.errors.length>0)
		
		return This:C1470.errors[0]
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function FindExe()
	
	var $cmd; $error; $in; $out : Text
	
	If (Is macOS:C1572)
		
		$cmd:="find /usr -type f -name gh"
		LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		//FIXME:To test on Windows
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.exe:=Split string:C1554($out; "\n"; sk ignore empty strings:K86:1).first()
		This:C1470.available:=File:C1566(This:C1470.exe).exists
		
	End if 
	
	//MARK:- [auth]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetStatus() : Object
	
	var $cmd; $error; $in; $out : Text
	var $c : Collection
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	If (This:C1470.exe=Null:C1517)
		
		return 
		
	End if 
	
	$cmd:=This:C1470.exe+" auth status"
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		$c:=Split string:C1554($out; "\n"; sk ignore empty strings:K86:1)
		This:C1470.success:=Match regex:C1019("(?mi-s)Logged in to "+Replace string:C233($c[0]; "."; "\\.")+" as ([^\\s]*)"; $c[1]; 1; $pos; $len)
		
		If (This:C1470.success)
			
			return {\
				host: $c[0]; \
				user: Substring:C12($c[1]; $pos{1}; $len{1}); \
				scope: Split string:C1554(Substring:C12($c[4]; Position:C15(":"; $c[4])+1); ","; 2)\
				}
			
		End if 
	End if 
	
	This:C1470.errors.push("Failed to get the user status.")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Login()
	
	var $worker : 4D:C1709.SystemWorker
	
	If (Not:C34(This:C1470.authorized))
		
		$worker:=4D:C1709.SystemWorker.new(This:C1470.exe+" auth login -h github.com -p HTTPS -s repo"; This:C1470).wait()
		
		If (This:C1470.success)
			
			This:C1470.CheckToken()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Logout()
	
	var $worker : 4D:C1709.SystemWorker
	
	$worker:=4D:C1709.SystemWorker.new(This:C1470.exe+" auth logout -h "+(This:C1470.status.host || "github.com"); This:C1470).wait()
	
	If (This:C1470.success)
		
		This:C1470.authorized:=False:C215
		This:C1470.status:=Null:C1517
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CheckToken() : Boolean
	
	var $cmd; $error; $in; $out : Text
	
	$cmd:=This:C1470.exe+" auth token"
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.success:=Length:C16($out)>0
		
		If (This:C1470.success)
			
			This:C1470.status:=This:C1470.GetStatus()
			
		End if 
		
		return Length:C16($out)>0
		
	End if 
	
	//MARK:- [repo]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CreateRepo($name : Text; $private : Boolean; $options : Object) : Text
	
	var $cmd : Text
	var $worker : 4D:C1709.SystemWorker
	
	This:C1470.Login()
	
	If (This:C1470.authorized)
		
		$cmd:=This:C1470.exe+" repo create "
		$cmd+=This:C1470._compliantRepositoryName($name)
		$cmd+=$private ? " --private" : " --public"
		$worker:=4D:C1709.SystemWorker.new($cmd; This:C1470).wait()
		
		If (This:C1470.success)
			
			return This:C1470.remote
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function DeleteRepo($name : Text) : Boolean
	
	var $cmd : Text
	var $worker : 4D:C1709.SystemWorker
	
	This:C1470.Login()
	
	This:C1470.status:=This:C1470.status || This:C1470.GetStatus()
	
	If (This:C1470.status.scope.includes("delete_repo"))
		
		$cmd:=This:C1470.exe+" repo delete "
		$cmd+=This:C1470._compliantRepositoryName($name)
		$cmd+=" --yes"
		$worker:=4D:C1709.SystemWorker.new($cmd; This:C1470).wait()
		
		return This:C1470.success
		
	Else 
		
		// Try to refresh
		$cmd:=This:C1470.exe+"  auth refresh -h github.com -s delete_repo"
		$worker:=4D:C1709.SystemWorker.new($cmd; This:C1470).wait()
		
		If (This:C1470.success)
			
			This:C1470.GetStatus()
			return This:C1470.DeleteRepo($name)
			
		End if 
	End if 
	
	//MARK:- [System worker callbacks]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	
	//⚠️ The answers are all in the error stream
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?mi-s)([[:xdigit:]]{4}-[[:xdigit:]]{4}).*"; $info.data; 1; $pos; $len))
		
		var $winRef : Integer
		$winRef:=Open form window:C675("DEVICE ACTIVATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5)
		
		var $menubar : cs:C1710.menuBar
		$menubar:=cs:C1710.menuBar.new()
		$menubar.set($menubar.defaultMinimalMenuBar())
		
		var $otc : Text
		$otc:=Substring:C12($info.data; $pos{1}; $len{1})
		SET TEXT TO PASTEBOARD:C523($otc)
		
		DIALOG:C40("DEVICE ACTIVATION"; {otc: $otc; url: "https://github.com/login/device/"})
		CLOSE WINDOW:C154
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onTerminate($worker : 4D:C1709.SystemWorker)
	
	This:C1470.history.insert(0; {\
		commandLine: $worker.commandLine; \
		response: $worker.response; \
		responseError: $worker.responseError\
		})
	
	Case of 
			
			//______________________________________________________
		: (Position:C15("auth login"; $worker.commandLine)>0)
			
			This:C1470.success:=Match regex:C1019("(?mi-s)gh config set -h github.com git_protocol https"; $worker.responseError; 1)
			
			If (This:C1470.success)
				
				This:C1470.authorized:=True:C214
				
			End if 
			
			//______________________________________________________
		: (Position:C15("auth refresh"; $worker.commandLine)>0)
			
			This:C1470.success:=Match regex:C1019("(?mi-s)Authentication complete"; $worker.responseError; 1)
			
			If (This:C1470.success)
				
				This:C1470.authorized:=True:C214
				
			End if 
			
			//______________________________________________________
		: (Position:C15("repo create"; $worker.commandLine)>0)
			
			This:C1470.success:=($worker.response="https://github.com/@")
			
			If (This:C1470.success)
				
				This:C1470.remote:=$worker.response
				
			End if 
			
			//______________________________________________________
		: (Position:C15("repo delete"; $worker.commandLine)>0)
			
			This:C1470.success:=($worker.response#Null:C1517) && (Length:C16($worker.response)=0)\
				 && ($worker.responseError#Null:C1517) && (Length:C16($worker.responseError)=0)
			
			//______________________________________________________
		: (Position:C15("auth logout"; $worker.commandLine)>0)
			
			This:C1470.success:=($worker.response#Null:C1517) && (Length:C16($worker.response)=0)\
				 && ($worker.responseError#Null:C1517) && (Length:C16($worker.responseError)=0)
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			TRACE:C157
			
			//______________________________________________________
	End case 
	
	If (Not:C34(This:C1470.success))
		
		This:C1470.errors.push($worker.responseError)
		This:C1470._record("onTerminate"; $worker)
		
	End if 
	
	//MARK:- [private]
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _record($name : Text; $worker : 4D:C1709.SystemWorker)
	
	var $o : Object
	
	$o:={\
		commandLine: $worker.commandLine; \
		response: $worker.response; \
		responseError: $worker.responseError\
		}
	
	File:C1566("/RESOURCES/"+$name+".json"; *).setText(JSON Stringify:C1217($o; *))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _compliantRepositoryName($name : Text) : Text
	
	var $len; $pos : Integer
	var $c : Collection
	
	$name:=Lowercase:C14($name)
	$c:=[]
	
	While (Match regex:C1019("(?mi-s)([^[:alnum:]]+)"; $name; 1; $pos; $len))
		
		$c.push(Substring:C12($name; 1; $pos-1))
		$name:=Delete string:C232($name; 1; $pos+$len-1)
		
	End while 
	
	$c.push($name)
	
	return $c.join("-")