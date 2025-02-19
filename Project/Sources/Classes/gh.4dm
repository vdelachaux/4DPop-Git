/* Github CLI 

GitHub CLI, or gh, is a command-line interface to GitHub for use in your terminal or your scripts.

https://cli.github.com/manual/

*/
property dataType:="text"
property data:=""
property dataError:=""

property timeout:=60

property success:=True:C214
property available:=False:C215
property authorized:=False:C215

property errors:=[]
property history:=[]

property exe; remote : Text
property status : Object

singleton Class constructor
	
	This:C1470.available:=This:C1470._exe()
	
	If (This:C1470.available)
		
		This:C1470.authorized:=This:C1470.checkToken()
		
	Else 
		
		This:C1470.errors.push("The GitHub command line interface is not available")
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastError() : Text
	
	return This:C1470.errors.length>0 ? This:C1470.errors[0] : ""
	
	// MARK:- [auth]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Verifies and returns information about the authentication state.
Function getStatus() : Object
	
	var $cmd; $error; $in; $out : Text
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	If (This:C1470.exe=Null:C1517)
		
		return 
		
	End if 
	
	$cmd:=This:C1470.exe+" auth status"
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		var $c:=Split string:C1554($out; "\n"; sk ignore empty strings:K86:1)
		This:C1470.success:=Match regex:C1019("(?mi-s)Logged in to "+Replace string:C233($c[0]; "."; "\\.")+" as ([^\\s]*)"; $c[1]; 1; $pos; $len)
		
		If (This:C1470.success)
			
			return {\
				host: $c[0]; \
				user: Substring:C12($c[1]; $pos{1}; $len{1}); \
				scope: Split string:C1554(Substring:C12($c[4]; Position:C15(":"; $c[4])+1); ","; sk trim spaces:K86:2)\
				}
			
		End if 
	End if 
	
	This:C1470.errors.push("Failed to get the user status.")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Authenticate with a GitHub host.
Function login() : Boolean
	
	If (This:C1470.authorized)
		
		return True:C214
		
	End if 
	
	var $worker:=4D:C1709.SystemWorker.new(This:C1470.exe+" auth login -h github.com -p HTTPS -s repo"; This:C1470).wait()
	
	If (This:C1470.success)
		
		return This:C1470.checkToken()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Remove authentication for a GitHub host.
Function logout()
	
	var $worker:=4D:C1709.SystemWorker.new(This:C1470.exe+" auth logout -h "+(This:C1470.status.host || "github.com"); This:C1470).wait()
	
	If (This:C1470.success)
		
		This:C1470.authorized:=False:C215
		This:C1470.status:=Null:C1517
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Checks whether the gh authentication token is configured and valid
Function checkToken() : Boolean
	
	var $cmd; $error; $in; $out : Text
	
	$cmd:=This:C1470.exe+" auth token"
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.success:=Length:C16($out)>0
		
		If (This:C1470.success)
			
			This:C1470.status:=This:C1470.getStatus()
			
		End if 
		
		return Length:C16($out)>0
		
	End if 
	
	//MARK:- [repo]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Create a new GitHub repository.
Function createRepo($name : Text; $private : Boolean; $options : Object) : Text
	
	This:C1470.login()
	
	If (This:C1470.authorized)
		
		var $c:=[\
			This:C1470.exe; \
			"repo"; \
			"create"; \
			This:C1470._compliantRepositoryName($name); \
			$private ? "--private" : "--public"\
			]
		
		var $worker:=4D:C1709.SystemWorker.new($c.join(" "); This:C1470).wait()
		
		If (This:C1470.success)
			
			return This:C1470.remote
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Delete a GitHub repository.
Function deleteRepo($name : Text) : Boolean
	
	This:C1470.login()
	
	This:C1470.status:=This:C1470.status || This:C1470.getStatus()
	
	If (This:C1470.status.scope.includes("delete_repo"))
		
		var $c:=[\
			This:C1470.exe; \
			"repo"; \
			"delete"; \
			This:C1470._compliantRepositoryName($name); \
			"--yes"\
			]
		
		var $worker:=4D:C1709.SystemWorker.new($c.join(" "); This:C1470).wait()
		
		return This:C1470.success
		
	Else 
		
		// Try to refresh
		var $cmd:=This:C1470.exe+"  auth refresh -h github.com -s delete_repo"
		$worker:=4D:C1709.SystemWorker.new($cmd; This:C1470).wait()
		
		If (This:C1470.success)
			
			This:C1470.getStatus()
			
			return This:C1470.deleteRepo($name)
			
		End if 
	End if 
	
	//MARK:- [System worker callbacks]
	// §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	
	//⚠️ The answers are all in the error stream
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?mi-s)([[:xdigit:]]{4}-[[:xdigit:]]{4}).*"; $info.data; 1; $pos; $len))
		
		var $winRef:=Open form window:C675("DEVICE ACTIVATION"; Movable form dialog box:K39:8; Horizontally centered:K39:1; At the top:K39:5)
		var $menubar:=cs:C1710.menuBar.new().defaultMinimalMenuBar().set()
		
		var $otc:=Substring:C12($info.data; $pos{1}; $len{1})
		SET TEXT TO PASTEBOARD:C523($otc)
		
		DIALOG:C40("DEVICE ACTIVATION"; {otc: $otc; url: "https://github.com/login/device/"})
		CLOSE WINDOW:C154
		
	End if 
	
	// §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§ §§§
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
				
				This:C1470.remote:=Split string:C1554($worker.response; "\n"; sk ignore empty strings:K86:1).join("\n")
				
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
	
	// MARK:- Private
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Locates the exe to use
Function _exe() : Boolean
	
	var $error; $in; $out : Text
	
	If (Is macOS:C1572)
		
		var $cmd:="find /usr -type f -name gh"
		LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			This:C1470.exe:=Split string:C1554($out; "\n"; sk ignore empty strings:K86:1).first()
			
		Else 
			
			// Use embedded binary
			This:C1470.exe:=This:C1470._unsanboxed(File:C1566("/RESOURCES/bin/gh")).path
			
		End if 
		
	Else 
		
		// Use embedded binary
		This:C1470.exe:=This:C1470._unsanboxed(File:C1566("/RESOURCES/bin/gh.exe")).path
		
	End if 
	
	return (Length:C16(This:C1470.exe)>0) && File:C1566(This:C1470.exe).exists
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _unsanboxed($target : Object) : Object
	
	Case of 
			//______________________________________________________
		: (OB Instance of:C1731($target; 4D:C1709.File))
			
			return File:C1566($target.platformPath; fk platform path:K87:2)
			
			//______________________________________________________
		: (OB Instance of:C1731($target; 4D:C1709.Folder))
			
			return Folder:C1567($target.platformPath; fk platform path:K87:2)
			
			//______________________________________________________
		Else 
			
			This:C1470.errors.push("Bad parameter")
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _record($name : Text; $worker : 4D:C1709.SystemWorker)
	
	var $o:={\
		commandLine: $worker.commandLine; \
		response: $worker.response; \
		responseError: $worker.responseError\
		}
	
	File:C1566("/LOGS/GitHub CLI "+$name+".json"; *).setText(JSON Stringify:C1217($o; *))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _compliantRepositoryName($name : Text) : Text
	
	var $len; $pos : Integer
	
	$name:=Lowercase:C14($name)
	var $c:=[]
	
	While (Match regex:C1019("(?mi-s)([^[:alnum:]]+)"; $name; 1; $pos; $len))
		
		$c.push(Substring:C12($name; 1; $pos-1))
		$name:=Delete string:C232($name; 1; $pos+$len-1)
		
	End while 
	
	$c.push($name)
	
	return $c.join("-")