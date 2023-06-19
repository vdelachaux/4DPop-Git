//USE: databaseNonThreadSafe
//USE: noERROR

Class extends _classCore

Class constructor($full : Boolean)
	
	var $pathname : Text
	var $o : Object
	var $file : 4D:C1709.File
	var $signal : 4D:C1709.Signal
	
	Super:C1705()
	
	This:C1470.isCompiled:=Is compiled mode:C492(*)
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	
	This:C1470.isDebug:=This:C1470.isInterpreted\
		 | (Position:C15("debug"; Application version:C493(*))>0)\
		 | Folder:C1567(fk user preferences folder:K87:10).file("_vdl").exists
	
	This:C1470.type:=Choose:C955(Application type:C494; "Local"; "Volume desktop"; "Unkwon (2)"; "Desktop"; "Remote"; "Server")
	This:C1470.isRemote:=(This:C1470.type="Remote")
	This:C1470.isLocal:=Not:C34(This:C1470.isRemote)
	
	$pathname:=Structure file:C489(*)
	
	This:C1470.isMatrix:=(Structure file:C489=$pathname)
	This:C1470.isComponent:=Not:C34(This:C1470.isMatrix)
	
	If (This:C1470.isRemote)
		
		This:C1470.name:=$pathname
		This:C1470.isDataless:=False:C215
		
		This:C1470.databaseFolder:=Folder:C1567(fk remote database folder:K87:9).folder("4D/Components")
		
	Else 
		
		This:C1470.structureFile:=File:C1566($pathname; fk platform path:K87:2)
		
		$pathname:=Data file:C490
		This:C1470.isDataless:=(Length:C16($pathname)=0)
		
		If (Not:C34(This:C1470.isDataless))
			
			This:C1470.dataFile:=File:C1566($pathname; fk platform path:K87:2)
			This:C1470.dataFolder:=This:C1470.dataFile.parent
			This:C1470.dataReadOnly:=Is data file locked:C716
			
		End if 
		
		This:C1470.name:=This:C1470.structureFile.name
		
		// Unsanboxing
		This:C1470.databaseFolder:=Folder:C1567(Folder:C1567("/PACKAGE/"; *).platformPath; fk platform path:K87:2)
		
		This:C1470.plistFile:=This:C1470.databaseFolder.file("Info.plist")
		
		If (This:C1470.plistFile.exists)
			
			$o:=This:C1470.plistFile.getAppInfo()
			
			If ($o.CFBundleShortVersionString#Null:C1517)
				
				This:C1470.version:=String:C10($o.CFBundleShortVersionString)
				
				If ($o.CFBundleVersion#Null:C1517)
					
					This:C1470.version:=This:C1470.version+" ("+String:C10($o.CFBundleVersion)+")"
					
				End if 
			End if 
		End if 
		
		This:C1470.preferencesFolder:=This:C1470.databaseFolder.folder("Preferences")
		This:C1470.settingsFolder:=This:C1470.databaseFolder.folder("Settings")
		This:C1470.resourcesFolder:=This:C1470.databaseFolder.folder("Resources")
		
		$file:=This:C1470.settingsFolder.file("buildApp.4DSettings")
		
		If (Not:C34($file.exists))
			
			$file:=This:C1470.preferencesFolder.file("BuildApp.xml")
			
			If ($file.exists)
				
				$file.copyTo(This:C1470.settingsFolder; "buildApp.4DSettings")
				
			End if 
		End if 
		
		If (Not:C34($file.exists))
			
			// Create a default file
			If (File:C1566("/RESOURCES/BuildApp.xml").exists)
				
				$file.setText(Replace string:C233(File:C1566("/RESOURCES/BuildApp.xml").getText(); "{BuildApplicationName}"; This:C1470.name))
				
			End if 
		End if 
		
		This:C1470.buildAppSettingsFile:=$file
		
	End if 
	
	This:C1470.userPreferencesFolder:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.name || "projet")
	
	If (Not:C34(Is macOS:C1572) && Not:C34(Is Windows:C1573))
		
		This:C1470.isProject:=True:C214
		This:C1470.isBinary:=False:C215
		
		return 
		
	Else 
		
		This:C1470.isProject:=This:C1470.structureFile.extension=".4DProject"
		This:C1470.isBinary:=Not:C34(This:C1470.isProject)
	End if 
	
	$full:=Count parameters:C259>=1 ? $full : False:C215
	
	//%W-550.2
	If ($full)
		
		// Non-thread-safe commands are delegated to the application process
		$signal:=New signal:C1641("database")
		CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
		$signal.wait()
		
		KILL WORKER:C1390("$nonThreadSafe")
		
		This:C1470.components:=$signal.components.copy()
		This:C1470.plugins:=$signal.plugins.copy()
		
		Case of 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Value type:C1509($signal.parameters)=Is collection:K8:32)
				
				This:C1470.parameters:=$signal.parameters.copy()
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Value type:C1509($signal.parameters)=Is object:K8:27)
				
				This:C1470.parameters:=OB Copy:C1225($signal.parameters)
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				This:C1470.parameters:=$signal.parameters
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
		
	Else 
		
		This:C1470.components:=New collection:C1472
		This:C1470.plugins:=New collection:C1472
		
	End if 
	//%W+550.2
	
	// Make a _singleton
	This:C1470.Singletonize(This:C1470)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mode() : Text
	
	return Bool:C1537(This:C1470.isCompiled) ? "compiled" : "interpreted"
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ Only test tables that are available via REST.
Function isDataEmpty() : Boolean
	
	var $table : Text
	var $empty : Boolean
	
	If (This:C1470.isDataless)
		
		return True:C214
		
	End if 
	
	$empty:=True:C214
	
	For each ($table; ds:C1482) Until (Not:C34($empty))
		
		$empty:=ds:C1482[$table].all().length=0
		
	End for each 
	
	return $empty
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isMethodAvailable($name : Text) : Boolean
	
	var $signal : 4D:C1709.Signal
	
	$signal:=New signal:C1641("database")
	
	//%W-550.2
	Use ($signal)
		
		$signal.action:="methodAvailable"
		$signal.name:=$name
		
	End use 
	
	CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
	$signal.wait()
	
	return $signal.available
	//%W+550.2
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isComponentAvailable($name : Text) : Boolean
	
	return This:C1470.components.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isPluginAvailable($name : Text) : Boolean
	
	return This:C1470.plugins.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if the database folder is writable
Function isWritable() : Boolean
	
	var $writable : Boolean
	var $methodCalledOnError : Text
	var $file : 4D:C1709.File
	
	$methodCalledOnError:=Method called on error:C704
	ON ERR CALL:C155(Formula:C1597(noError).source)
	$file:=This:C1470.databaseFolder.file("._")
	$writable:=$file.create()
	$file.delete()
	ON ERR CALL:C155($methodCalledOnError)
	
	return $writable
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deleteGeometry()
	
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470.userPreferencesFolder.folder("4D Window Bounds v"+Delete string:C232(Application version:C493; 3; 2))
	
	If ($folder.exists)
		
		$folder:=This:C1470.isMatrix\
			 ? $folder.folders().query("fullName = :1"; "[projectForm]").pop()\
			 : $folder.folders().query("fullName = :1"; File:C1566(Structure file:C489; fk platform path:K87:2).name).pop()
		
		If ($folder#Null:C1517) && ($folder.exists)
			
			$folder.delete(fk recursive:K87:7)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function compile($options : Object) : Boolean
	
	var $compile; $error : Object
	
	If (Count parameters:C259>0)
		
		$compile:=Compile project:C1760($options)
		
	Else 
		
		$compile:=Compile project:C1760
		
	End if 
	
	This:C1470.errors:=$compile.errors.query("isError = :1"; True:C214)
	
	return $compile.success
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clearCompiledCode()
	
	var $folder : 4D:C1709.Folder
	
	If (This:C1470.isProject\
		 && This:C1470.isInterpreted\
		 && Not:C34(This:C1470.isRemote))
		
		$folder:=This:C1470.structureFile.parent.parent.folder("Libraries")
		
		If ($folder.exists)
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		$folder:=This:C1470.structureFile.parent.folder("DerivedData/CompiledCode")
		
		If ($folder.exists)
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		For each ($folder; This:C1470.databaseFolder.folders().query("name = userPreferences"))
			
			$folder:=$folder.folder("CompilerIntermediateFiles")
			
			If ($folder.exists)
				
				$folder.delete(Delete with contents:K24:24)
				
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function methods($filter : Text) : Collection
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("database")
	
	//%W-550.2
	Use ($signal)
		
		$signal.action:="methods"
		$signal.filter:=$filter
		
	End use 
	
	CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
	$signal.wait()
	
	return $signal.methods.copy()
	//%W+550.2
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setUserParam($userParam)
	
	var $signal : 4D:C1709.Signal
	
	Case of 
			
			//__________________________
		: ($userParam=Null:C1517)
			
			$userParam:=""
			
			//__________________________
		: (Value type:C1509($userParam)=Is text:K8:3)
			
			// <NOTHING MORE TO DO>
			
			//__________________________
		: (Value type:C1509($userParam)=Is object:K8:27)\
			 | (Value type:C1509($userParam)=Is collection:K8:32)
			
			$userParam:=JSON Stringify:C1217($userParam)
			
			//__________________________
		Else 
			
			$userParam:=String:C10($userParam)
			
			//__________________________
	End case 
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("database")
	
	Use ($signal)
		
		//%W-550.2
		$signal.userParam:=$userParam
		//%W+550.2
		
	End use 
	
	CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
	$signal.wait()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restart($options; $message : Text)
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("database")
	
	//%W-550.2
	Use ($signal)
		
		$signal.action:="restart"
		$signal.this:=OB Copy:C1225(This:C1470; ck shared:K85:29; $signal)
		
		If ($options#Null:C1517)
			
			$signal.options:=$options
			
		End if 
		
		If (Length:C16($message)>0)
			
			$signal.options:=$message
			
		End if 
	End use 
	//%W+550.2
	
	CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
	$signal.wait()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restartCompiled($userParam) : Object
	
	return This:C1470._restart(True:C214; $userParam)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restartInterpreted($userParam) : Object
	
	return This:C1470._restart(False:C215; $userParam)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _restart($compiled : Boolean; $userParam) : Object
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("database")
	
	//%W-550.2
	Use ($signal)
		
		$signal.action:="_restart"
		$signal.this:=OB Copy:C1225(This:C1470; ck shared:K85:29; $signal)
		$signal.compiled:=$compiled
		
		If ($userParam#Null:C1517)
			
			$signal.userParam:=$userParam
			
		End if 
	End use 
	
	CALL WORKER:C1389("$nonThreadSafe"; "databaseNonThreadSafe"; $signal)
	$signal.wait()
	
	return $signal.result
	//%W+550.2