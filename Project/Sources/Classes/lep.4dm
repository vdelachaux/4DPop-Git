// Class extends tools

Class constructor
	
	// Super()
	
	This:C1470.reset()
	
	//====================================================================
Function launch($command; $arguments : Text)->$this : cs:C1710.lep
	
	var $input; $output : Blob
	var $error; $t : Text
	var $len; $pid; $pos : Integer
	
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=Null:C1517
	This:C1470.pid:=0
	
	If (Value type:C1509($command)=Is object:K8:27)
		
		This:C1470.command:=This:C1470.escape($command.path)
		
	Else 
		
		// Path must be POSIX
		This:C1470.command:=String:C10($command)
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.command="shell")
				
				This:C1470.command:="/bin/sh"
				
				//______________________________________________________
			: (This:C1470.command="bat")
				
				This:C1470.command:="cmd.exe /C start /B"
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.command:=This:C1470.command+" "+This:C1470.escape($arguments)
		
	End if 
	
	For each ($t; This:C1470.environmentVariables)
		
		SET ENVIRONMENT VARIABLE:C812($t; String:C10(This:C1470.environmentVariables[$t]))
		
	End for each 
	
	Case of 
			
			//……………………………………………………………………
		: (This:C1470.inputStream=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is text:K8:3)\
			 | (Value type:C1509(This:C1470.inputStream)=Is alpha field:K8:1)
			
			CONVERT FROM TEXT:C1011(This:C1470.inputStream; This:C1470.charSet; $input)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is boolean:K8:9)
			
			CONVERT FROM TEXT:C1011(Choose:C955(This:C1470.inputStream; "true"; "false"); This:C1470.charSet; $input)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.inputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.inputStream)=Is real:K8:4)
			
			CONVERT FROM TEXT:C1011(String:C10(This:C1470.inputStream; "&xml"); This:C1470.charSet; $input)
			
			//……………………………………………………………………
		Else 
			
			$output:=This:C1470.inputStream  // Blob
			
			//……………………………………………………………………
	End case 
	
	LAUNCH EXTERNAL PROCESS:C811(This:C1470.command; $input; $output; $error; $pid)
	
	$t:=Convert to text:C1012($output; This:C1470.charSet)
	
	If (Length:C16($error)=0)
		
		// ⚠️ Some commands return the error in the output stream
		If (Position:C15("ERROR:"; $t)>0)
			
			$error:=$t
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($error)=0)
	
	If (This:C1470.success)
		
		This:C1470.pid:=$pid
		
		// Remove the last line feed, if any
		If ($t[[Length:C16($t)]]="\n")
			
			$t:=Substring:C12($t; 1; Length:C16($t)-1)
			
		End if 
		
		Case of 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is text:K8:3)
				
				This:C1470.outputStream:=$t
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is object:K8:27)
				
				If (Length:C16($t)>0)
					
					This:C1470.success:=(Match regex:C1019("(?ms-i)^(?:\\{.*\\})|(?:^\\[.*\\])$"; $t; 1))
					
				End if 
				
				If (This:C1470.success)
					
					This:C1470.outputStream:=JSON Parse:C1218($t)
					
				Else 
					
					This:C1470.errorStream:=$t
					
				End if 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is collection:K8:32)
				
				This:C1470.outputStream:=Split string:C1554($t; "\n")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is boolean:K8:9)
				
				This:C1470.outputStream:=($t="true")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is longint:K8:6)\
				 | (This:C1470.outputType=Is integer:K8:5)\
				 | (This:C1470.outputType=Is integer 64 bits:K8:25)\
				 | (This:C1470.outputType=Is real:K8:4)
				
				This:C1470.outputStream:=Num:C11($t)
				
				//……………………………………………………………………
			Else 
				
				This:C1470.outputStream:=$output  // Blob
				
				//……………………………………………………………………
		End case 
		
	Else 
		
		This:C1470.pid:=0
		This:C1470.outputStream:=Null:C1517
		This:C1470.errorStream:=$error
		This:C1470.errors.push($error)
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
	// Restores the initial values of the class
Function reset()->$this : cs:C1710.lep
	
	This:C1470.success:=True:C214
	This:C1470.errors:=New collection:C1472
	This:C1470.command:=Null:C1517
	This:C1470.inputStream:=Null:C1517
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=Null:C1517
	This:C1470.pid:=0
	
	This:C1470.setCharSet()
	This:C1470.setOutputType()
	This:C1470.setEnvironnementVariable()
	
	$this:=This:C1470
	
	//====================================================================
	// Execute the external process in synchronous mode
	// ⚠️ Must be call before .launch()
Function synchronous($mode : Boolean)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.setEnvironnementVariable("asynchronous"; Choose:C955($mode; "true"; "false"))
		
	Else 
		
		This:C1470.setEnvironnementVariable("asynchronous"; "true")
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
	// Execute the external process in asynchronous mode
	// ⚠️ Must be call before .launch()
Function asynchronous($mode : Boolean)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.setEnvironnementVariable("asynchronous"; Choose:C955($mode; "false"; "true"))
		
	Else 
		
		This:C1470.setEnvironnementVariable("asynchronous"; "false")
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function setCharSet($charset : Text)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.charSet:=$charset
		
	Else 
		
		// Reset
		This:C1470.charSet:="UTF-8"
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function setOutputType($outputType : Integer)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.outputType:=$outputType
		
	Else 
		
		// Reset
		This:C1470.outputType:=Is text:K8:3
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function setDirectory($folder : 4D:C1709.Folder)->$this : cs:C1710.lep
	
	If (Count parameters:C259>=1)
		
		This:C1470.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=$folder.platformPath
		
	Else 
		
		This:C1470.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=""
		
	End if 
	
	This:C1470.success:=True:C214
	
	$this:=This:C1470
	
	//====================================================================
	// Returns an object containing all the environment variables
Function getEnvironnementVariables()->$variables : Object
	
	var $c : Collection
	var $t : Text
	
	This:C1470.launch(Choose:C955(Is macOS:C1572; "/usr/bin/env"; "set"))
	
	If (This:C1470.success)
		
		$variables:=New object:C1471
		
		For each ($t; Split string:C1554(This:C1470.outputStream; "\n"; sk ignore empty strings:K86:1))
			
			$c:=Split string:C1554($t; "=")
			
			If ($c.length=2)
				
				$variables[$c[0]]:=$c[1]
				
			End if 
		End for each 
		
		// Add the currents variables
		For each ($t; This:C1470.environmentVariables)
			
			If ($variables[$t]=Null:C1517)
				
				$variables[$t]:=This:C1470.environmentVariables[$t]
				
			End if 
		End for each 
	End if 
	
	//====================================================================
	// Returns the content of an environment variable from its name
Function getEnvironnementVariable($name : Text; $nonDiacritic : Boolean)->$value : Text
	
	var $o : Object
	var $t : Text
	var $isDiacritic : Boolean
	
	This:C1470.success:=Count parameters:C259>=1
	
	If (This:C1470.success)
		
		$isDiacritic:=True:C214
		
		If (Count parameters:C259>=2)
			
			$isDiacritic:=$nonDiacritic
			
		End if 
		
		$t:=This:C1470._shortcut($name)
		
		If ($isDiacritic)
			
			If (This:C1470.environmentVariables[$t]#Null:C1517)
				
				$value:=This:C1470.environmentVariables[$t]
				
			Else 
				
				$o:=This:C1470.getEnvironnementVariables()
				This:C1470.success:=$o[$name]#Null:C1517
				
				If (This:C1470.success)
					
					$value:=$o[$name]
					
				Else 
					
					This:C1470.errors.push("Variable \""+$name+"\" not found")
					
				End if 
			End if 
			
		Else 
			
			$o:=OB Entries:C1720(This:C1470.environmentVariables).query("key = :1"; $t).pop()
			
			If ($o=Null:C1517)
				
				$o:=OB Entries:C1720(This:C1470.getEnvironnementVariables()).query("key = :1"; $t).pop()
				
			End if 
			
			If ($o#Null:C1517)
				
				$value:=$o.value
				
			End if 
		End if 
		
	Else 
		
		This:C1470.errors.push("Missing variable name parameter")
		
	End if 
	
	//====================================================================
Function setEnvironnementVariable($variables; $value : Text)->$this : cs:C1710.lep
	
	var $v : Variant
	var $o : Object
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//……………………………………………………………………
		: (Count parameters:C259=0)
			
			This:C1470.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY"; ""; \
				"_4D_OPTION_HIDE_CONSOLE"; "true"; \
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true"\
				)
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is text:K8:3)
			
			If (Count parameters:C259>=2)
				
				This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=$value
				
			Else 
				
				// Reset
				If (This:C1470._shortcut($variables)="_4D_OPTION_CURRENT_DIRECTORY")
					
					//empty string
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=""
					
				Else 
					
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:="false"
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is object:K8:27)
			
			For each ($o; OB Entries:C1720($variables))
				
				This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=String:C10($o.value)
				
			End for each 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is collection:K8:32)
			
			For each ($v; $variables)
				
				If (Value type:C1509($v)=Is object:K8:27)
					
					$o:=OB Entries:C1720($v).pop()
					This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=$o.value
					
				Else 
					
					// ERROR
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Waiting for a parameter Text, Object or Collection")
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//====================================================================
Function escape($text : Text)->$escaped : Text
	
	var $t : Text
	
	$escaped:=$text
	
	For each ($t; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
		
		$escaped:=Replace string:C233($escaped; $t; "\\"+$t; *)
		
	End for each 
	
	//====================================================================
	// Enclose, if necessary, the string in single quotation marks
Function singleQuoted($tring : Text)->$quoted : Text
	
	$quoted:=Choose:C955(Match regex:C1019("^'.*'$"; $tring; 1); $tring; "'"+$tring+"'")  // Already done // Do it
	
	//====================================================================
	// Write access to a file or a directory with all its subfolders and files
Function writable($cible : 4D:C1709.Document)->$this : cs:C1710.lep
	
	If (Bool:C1537($cible.exists))
		
		If (Is macOS:C1572)
			
/*
chmod [-fv] [-R [-H | -L | -P]] mode file ...
chmod [-fv] [-R [-H | -L | -P]] [-a | +a | =a] ACE file ...
chmod [-fhv] [-R [-H | -L | -P]] [-E] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-C] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-N] file ...
			
The generic options are as follows:
     -f      Do not display a diagnostic message if chmod could not modify the
             mode for file.
     -H      If the -R option is specified, symbolic links on the command line
             are followed.  (Symbolic links encountered in the tree traversal
             are not followed by default.)
     -h      If the file is a symbolic link, change the mode of the link
             itself rather than the file that the link points to.
     -L      If the -R option is specified, all symbolic links are followed.
     -P      If the -R option is specified, no symbolic links are followed.
             This is the default.
     -R      Change the modes of the file hierarchies rooted in the files
             instead of just the files themselves.
     -v      Cause chmod to be verbose, showing filenames as the mode is modi-
             fied.  If the -v flag is specified more than once, the old and
             new modes of the file will also be printed, in both octal and
             symbolic notation.
     The -H, -L and -P options are ignored unless the -R option is specified.
     In addition, these options override each other and the command's actions
     are determined by the last one specified.
*/
			
			
			If ($cible.isFolder)
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
				
			Else 
				
				This:C1470.launch("chmod u+rwX "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
		Else 
			
/*
ATTRIB [+R | -R] [+A | -A ] [+S | -S] [+H | -H] [+I | -I]
       [drive:][path][filename] [/S [/D] [/L]]
			
  +   Sets an attribute.
  -   Clears an attribute.
  R   Read-only file attribute.
  A   Archive file attribute.
  S   System file attribute.
  H   Hidden file attribute.
  I   Not content indexed file attribute.
      Spécifie un ou plusieurs fichiers à traiter par attrib.
  /S  Processes matching files in the current folder and all subfolders.
  /D  Process folders as well.
  /L  Work on the attributes of the Symbolic Link versus the target of the Symbolic Link
*/
			
			If ($cible.isFolder)
				
				This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
				This:C1470.launch("attrib.exe -R /D /S")
				
			Else 
				
				This:C1470.launch("attrib.exe -R "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
			
		End if 
		
	Else 
		
		This:C1470._pushError("Invalid pathname: "+String:C10($cible.path))
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
	// Write access to a directory with all its sub-folders and files
Function unlock($cible : 4D:C1709.folder)->$this : cs:C1710.lep
	
	If (Bool:C1537($cible.exists))
		
		If ($cible.isFolder)
			
			This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
			
			If (Is macOS:C1572)
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
				
			Else 
				
				This:C1470.launch("attrib.exe -R /D /S")
				
			End if 
			
		Else 
			
			This:C1470._pushError($cible.path+" is not a directory!")
			
		End if 
		
	Else 
		
		This:C1470._pushError("Invalid pathname: "+String:C10($cible.path))
		
	End if 
	
	$this:=This:C1470
	
	//====================================================================
Function _shortcut($string : Text)->$variable : Text
	
	Case of   // Shortcuts
			
			//…………………………………………………………………………………………
		: ($string="directory")\
			 | ($string="currentDirectory")
			
			$variable:="_4D_OPTION_CURRENT_DIRECTORY"
			
			//…………………………………………………………………………………………
		: ($string="asynchronous")\
			 | ($string="non-blocking")
			
			$variable:="_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"
			
			//…………………………………………………………………………………………
		: ($string="console")\
			 | ($string="hideConsole")
			
			$variable:="_4D_OPTION_HIDE_CONSOLE"
			
			//…………………………………………………………………………………………
		Else 
			
			$variable:=$string
			
			//…………………………………………………………………………………………
	End case 
	
	//====================================================================
Function _pushError($desription : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push(Get call chain:C1662[1].name+" - "+$desription)
	