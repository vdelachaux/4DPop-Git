property dataType; data; dataError : Text
property success; available : Boolean
property timeout : Integer
property errors; history : Collection


Class constructor($name : Text; $embedded : Boolean)
	
	This:C1470.timeout:=60
	This:C1470.dataType:="text"
	This:C1470.encoding:="UTF-8"
	This:C1470.variables:={}
	This:C1470.currentDirectory:=Null:C1517
	This:C1470.hideWindow:=True:C214
	
	This:C1470.data:=""
	This:C1470.dataError:=""
	
	This:C1470.success:=True:C214
	This:C1470.available:=False:C215
	
	This:C1470.errors:=[]
	This:C1470.history:=[]
	
	This:C1470.available:=This:C1470.getExe($name; $embedded)
	
	If (Not:C34(This:C1470.available))
		
		This:C1470._pushError("The "+$name+" command line interface is not available")
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastError() : Text
	
	return This:C1470.errors.length>0 ? This:C1470.errors.copy().pop() : ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Locates the exe to use
Function getExe($name : Text; $embedded : Boolean) : Boolean
	
	var $cmd; $error; $in; $out : Text
	var $file : 4D:C1709.File
	
	If (Not:C34($embedded))
		
		If (Is macOS:C1572)
			
			$cmd:="find /usr -type f -name "+$name
			LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $error)
			
			If (Bool:C1537(OK))
				
				This:C1470.exe:=Split string:C1554($out; "\n"; sk ignore empty strings:K86:1).first()
				
				return True:C214
				
			End if 
			
		Else 
			
			// TODO:On windows
			
		End if 
	End if 
	
	// Use embedded binary
	$file:=This:C1470._unsanboxed(File:C1566("/RESOURCES/Bin/"+(Is macOS:C1572 ? $name : $name+".exe")))
	This:C1470.exe:=$file.path
	
	If ($file.exists && Is macOS:C1572)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $file.parent.platformPath)
		LAUNCH EXTERNAL PROCESS:C811("chmod +x "+$name)
		
	End if 
	
	return $file.exists
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function execute($cmd : Text)
	
	$cmd:=[This:C1470.exe; $cmd].join(" ")
	
	This:C1470.history.push($cmd)
	
/*This._worker:=4D.SystemWorker.new(This._commands.shift(); This)*/
	This:C1470._worker:=4D:C1709.SystemWorker.new($cmd; This:C1470).wait()
	
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get EOL() : Text
	
	return Is macOS:C1572 ? "\r\n" : "\n"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function escape($in : Text) : Text
	
	var $char; $metacharacters; $out : Text
	
	$out:=$in
	
	Case of 
			
			//______________________________________________________
		: (Is macOS:C1572)  // Escape for bash or zsh
			
			For each ($char; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
				
				$out:=Replace string:C233($out; $char; "\\"+$char; *)
				
			End for each 
			
			//______________________________________________________
		: (Is Windows:C1573)  // Escape for cmd.exe
			
			$metacharacters:="&|<>()%^\" "
			
			For each ($char; Split string:C1554("&|<>()%^\" "; ""))
				
				If (Position:C15($char; $out; *)=0)
					
					continue
					
				End if 
				
				// Should quote
				If (Substring:C12($out; Length:C16($out))="\\")
					
					$out:="\""+$out+"\\\""
					
				Else 
					
					$out:="\""+$out+"\""
					
				End if 
				
				// <NOTHING MORE TO DO>
				
				break
				
			End for each 
			
			//______________________________________________________
	End case 
	
	return $out
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function quote($in : Text) : Text
	
	return "\""+$in+"\""
	
	//MARK:- [System worker callbacks]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	
	// Should be overloaded by the custom class
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onTerminate($worker : 4D:C1709.SystemWorker)
	
	// Should be overloaded by the custom class
	
	//MARK:- [private]
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
Function _pushError($error : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push($error)