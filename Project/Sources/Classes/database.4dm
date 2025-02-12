property type; name; version : Text
property isCompiled; isInterpreted; isDebug; isProject; isBinary; isRemote; isLocal; isServer; isMatrix; isComponent; isDataless; internal : Boolean
property dataReadOnly; isModifiable : Boolean
property databaseFolder; dataFolder : 4D:C1709.Folder
property preferencesFolder; settingsFolder; resourcesFolder; userPreferencesFolder : 4D:C1709.Folder
property structureFile; dataFile; plistFile; buildAppSettingsFile : 4D:C1709.File
property components; plugins : Collection
property parameters : Variant
property project : Object
property compatibilityVersion : Integer

property motor : cs:C1710.motor

Class extends _classCore

Class constructor($full : Boolean)
	
	Super:C1705()
	
	// MARK:-Delegates 📦
	This:C1470.motor:=cs:C1710.motor.me
	
	This:C1470.type:=\
		This:C1470.motor.isLocal ? "Local" : \
		This:C1470.motor.isServer ? "Server" : \
		This:C1470.motor.isRemote ? "Remote" : "???"
	
	This:C1470.isCompiled:=Is compiled mode:C492(*)
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	
	This:C1470.isDebug:=This:C1470.isInterpreted\
		 || This:C1470.motor.isDebug\
		 || Folder:C1567(fk user preferences folder:K87:10).file("_vdl").exists
	
	This:C1470.isRemote:=This:C1470.motor.isRemote
	This:C1470.isLocal:=This:C1470.motor.isLocal
	This:C1470.isServer:=This:C1470.motor.isServer
	
	var $pathname : Text
	$pathname:=Structure file:C489(*)
	
	This:C1470.internal:=Length:C16($pathname)=0  // Only true for internal 4D components if no database is open
	
	If (Not:C34(This:C1470.internal))
		
		This:C1470.databaseFolder:=Try(Folder:C1567(Folder:C1567("/PACKAGE/"; *).platformPath; fk platform path:K87:2))
		
	End if 
	
	If (This:C1470.isRemote)
		
		This:C1470.name:=$pathname
		This:C1470.isDataless:=False:C215
		
		This:C1470.isMatrix:=False:C215
		This:C1470.isComponent:=False:C215
		
		This:C1470.isModifiable:=(This:C1470.databaseFolder#Null:C1517) && Not:C34(This:C1470.databaseFolder.file(This:C1470.name+".4DZ").exists)
		
	Else 
		
		This:C1470.isMatrix:=(Structure file:C489=$pathname)
		This:C1470.isComponent:=Not:C34(This:C1470.isMatrix)
		
		If (Not:C34(This:C1470.internal))
			
			This:C1470.structureFile:=File:C1566($pathname; fk platform path:K87:2)
			This:C1470.name:=This:C1470.structureFile.name
			This:C1470.isModifiable:=Not:C34(This:C1470.structureFile.extension=".4DZ")
			
			$pathname:=Data file:C490
			This:C1470.isDataless:=(Length:C16($pathname)=0)
			
			If (Not:C34(This:C1470.isDataless))
				
				This:C1470.dataFile:=File:C1566($pathname; fk platform path:K87:2)
				This:C1470.dataFolder:=This:C1470.dataFile.parent
				This:C1470.dataReadOnly:=Is data file locked:C716
				
			End if 
			
			If (This:C1470.databaseFolder#Null:C1517)
				
				This:C1470.plistFile:=This:C1470.databaseFolder.file("Info.plist")
				
				If (This:C1470.plistFile.exists)
					
					var $o : Object
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
				
			End if 
			
			var $file : 4D:C1709.File
			$file:=This:C1470.settingsFolder.file("buildApp.4DSettings")
			
			If (Not:C34($file.exists))
				
				$file:=This:C1470.preferencesFolder.file("BuildApp.xml")
				
				If ($file.exists)
					
					$file.copyTo(This:C1470.settingsFolder; "buildApp.4DSettings")
					
				End if 
			End if 
			
			If (Not:C34($file.exists))\
				 && (File:C1566("/RESOURCES/BuildApp.xml").exists)
				
				// Create a default file
				$file.setText(Replace string:C233(File:C1566("/RESOURCES/BuildApp.xml").getText(); "{BuildApplicationName}"; This:C1470.name))
				
			End if 
			
			This:C1470.buildAppSettingsFile:=$file
			
			This:C1470.userPreferencesFolder:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.name)
			
		End if 
	End if 
	
	If (Not:C34(Is macOS:C1572) && Not:C34(Is Windows:C1573))
		
		This:C1470.isProject:=True:C214
		This:C1470.isBinary:=False:C215
		
		return 
		
	Else 
		
		This:C1470.isProject:=Bool:C1537(Get database parameter:C643(Is host database a project:K37:99))
		This:C1470.isBinary:=Not:C34(This:C1470.isProject)
		
	End if 
	
	If (This:C1470.isProject)
		
		This:C1470.project:=getProject  // Executed on the server
		This:C1470.compatibilityVersion:=This:C1470.project=Null:C1517 ? -1 : This:C1470.project.compatibilityVersion
		
	End if 
	
	ARRAY TEXT:C222($textArray; 0x0000)
	COMPONENT LIST:C1001($textArray)
	
	This:C1470.components:=[]
	ARRAY TO COLLECTION:C1563(This:C1470.components; $textArray)
	
	ARRAY INTEGER:C220($intArray; 0x0000)
	PLUGIN LIST:C847($intArray; $textArray)
	
	This:C1470.plugins:=[]
	ARRAY TO COLLECTION:C1563(This:C1470.plugins; $textArray)
	
	var $custom : Text
	var $int : Integer:=Get database parameter:C643(User param value:K37:94; $custom)
	
	If (Length:C16($custom)>0)
		
		// Decode special entities
		$custom:=Replace string:C233($custom; "&amp;"; "&")
		$custom:=Replace string:C233($custom; "&lt;"; "<")
		$custom:=Replace string:C233($custom; "&gt;"; ">")
		$custom:=Replace string:C233($custom; "&apos;"; "'")
		$custom:=Replace string:C233($custom; "&quot;"; "\"")
		
		This:C1470.parameters:=This:C1470.isJson($custom) ? JSON Parse:C1218($custom) : $custom
		
	End if 
	
	If (Not:C34(This:C1470.internal))
		
		// Make a _singleton
		This:C1470.Singletonize(This:C1470)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mode() : Text
	
	return Bool:C1537(This:C1470.isCompiled) ? "compiled" : "interpreted"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get compiled() : Boolean
	
	return This:C1470.isCompiled
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get interpreted() : Boolean
	
	return This:C1470.isInterpreted
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get local() : Boolean
	
	return This:C1470.isLocal
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get remote() : Boolean
	
	return This:C1470.isRemote
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get server() : Boolean
	
	return This:C1470.isServer
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isDataEmpty($legacy : Boolean) : Boolean
	
	var $table : Text
	var $i : Integer
	
	If (This:C1470.isDataless)
		
		return True:C214
		
	End if 
	
	If ($legacy)
		
		For ($i; 1; Last table number:C254; 1)
			
			If (Is table number valid:C999($i))\
				 && (Records in table:C83(Table:C252($i)->)>0)
				
				return 
				
			End if 
		End for 
		
	Else 
		
		// ⚠️ Only test tables that are available via REST
		For each ($table; ds:C1482)
			
			If (ds:C1482[$table].getCount()>0)
				
				return 
				
			End if 
		End for each 
	End if 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isMethodAvailable($name : Text) : Boolean
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET NAMES:C1166($methods)
	
	return Find in array:C230($methods; $name)>0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isComponentAvailable($name : Text) : Boolean
	
	return This:C1470.components.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isPluginAvailable($name : Text) : Boolean
	
	return This:C1470.plugins.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if the database folder is writable
Function isWritable() : Boolean
	
	var $success : Boolean
	var $file : 4D:C1709.File
	
	If (This:C1470.databaseFolder=Null:C1517)
		
		return 
		
	End if 
	
	$file:=This:C1470.databaseFolder.file("._")
	
	Try
		
		$success:=$file.create()
		$file.delete()
		
	End try
	
	return $success
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deleteGeometry()
	
	var $folder : 4D:C1709.Folder
	
	$folder:=This:C1470.userPreferencesFolder.folder("4D Window Bounds v"+Delete string:C232(This:C1470.motor._version; 3; 2))
	
	If ($folder.exists)
		
		$folder:=This:C1470.isMatrix\
			 ? $folder.folders().query("fullName = :1"; "[projectForm]").pop()\
			 : $folder.folders().query("fullName = :1"; File:C1566(Structure file:C489; fk platform path:K87:2).name).pop()
		
		If ($folder#Null:C1517)\
			 && ($folder.exists)
			
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
		 && This:C1470.isModifiable\
		 && (This:C1470.databaseFolder#Null:C1517))
		
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
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET NAMES:C1166($methods; $filter)
	
	var $c : Collection:=[]
	ARRAY TO COLLECTION:C1563($c; $methods)
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setUserParam($userParam)
	
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
	
	SET DATABASE PARAMETER:C642(User param value:K37:94; $userParam)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Start debug log recording
	// After deleting existing log files, if any
Function startDebugLog($delete : Boolean)
	
	If ($delete)
		
		This:C1470.deleteDebugLogs()
		
	End if 
	
	This:C1470.debugLog(True:C214)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Stop debug log recording
Function stopDebugLog
	
	This:C1470.debugLog(False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Start/Stop debug log recording
Function debugLog($tart : Boolean)
	
	SET DATABASE PARAMETER:C642(Debug log recording:K37:34; Num:C11($tart))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deletes existing log files, if any
Function deleteDebugLogs()
	
	var $file : 4D:C1709.File
	
	For each ($file; Folder:C1567(fk logs folder:K87:17; *).files().query("name = :1 & extension = '.txt'"; This:C1470.type="server" ? "4DBebugLogServer_@" : "4DDebugLog_@"))
		
		$file.delete()
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function startDiagnosticLog
	
	This:C1470.diagnosticLog(True:C214)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stopDiagnosticLog
	
	This:C1470.diagnosticLog(False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function diagnosticLog($enable : Boolean)
	
	SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; Num:C11($enable))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restart($options; $message : Text)
	
	If (This:C1470.databaseFolder=Null:C1517)
		
		This:C1470._pushError("No database")
		return 
		
	End if 
	
	If (This:C1470.isServer)
		
		If ($options#Null:C1517)
			
			If ($message#Null:C1517)
				
				RESTART 4D:C1292(Num:C11($options); $message)
				
			Else 
				
				RESTART 4D:C1292(Num:C11($options))
				
			End if 
			
		Else 
			
			RESTART 4D:C1292
			
		End if 
		
	Else 
		
		If ($options#Null:C1517)
			
			SET DATABASE PARAMETER:C642(User param value:K37:94; $options)
			
		End if 
		
		OPEN DATABASE:C1321(This:C1470.structureFile.platformPath)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restartCompiled($userParam) : Object
	
	return This:C1470._restart(True:C214; $userParam)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restartInterpreted($userParam) : Object
	
	return This:C1470._restart(False:C215; $userParam)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _restart($compiled : Boolean; $userParam) : Object
	
	var $root; $xml : Text
	var $file : 4D:C1709.File
	
	If (This:C1470.databaseFolder=Null:C1517)
		
		This:C1470._pushError("No database")
		return 
		
	End if 
	
	Try
		
		$root:=DOM Create XML Ref:C861("database_shortcut")
		
		XML SET OPTIONS:C1090($root; XML indentation:K45:34; XML with indentation:K45:35)
		
		DOM SET XML ATTRIBUTE:C866($root; \
			"structure_opening_mode"; 1+Num:C11(Bool:C1537($compiled)); \
			"structure_file"; "file:///"+This:C1470.structureFile.path; \
			"data_file"; "file:///"+This:C1470.dataFile.path)
		
		If ($userParam#Null:C1517)
			
			If (Value type:C1509($userParam)=Is object:K8:27)\
				 | (Value type:C1509($userParam)=Is collection:K8:32)
				
				DOM SET XML ATTRIBUTE:C866($root; \
					"user_param"; JSON Stringify:C1217($userParam))
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($root; \
					"user_param"; String:C10($userParam))
				
			End if 
		End if 
		
		DOM EXPORT TO VAR:C863($root; $xml)
		DOM CLOSE XML:C722($root)
		
		$file:=This:C1470.databaseFolder.file("restart.4DLink")
		$file.setText($xml)
		
		OPEN DATABASE:C1321(String:C10($file.platformPath))
		
	Catch
		
		This:C1470._pushError(Last errors:C1799.length>0 ? Last errors:C1799[0].message : "Failed to restart the database")
		
	End try
	
	//MARK:-⚠️ NOT THREAD SAFE
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setUpdateFolder($folder; $silent : Boolean)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($folder)=Is object:K8:27)\
			 && (OB Instance of:C1731($folder; 4D:C1709.Folder))
			
			SET UPDATE FOLDER:C1291(String:C10($folder.platformPath); $silent)
			
			//______________________________________________________
		: (Value type:C1509($folder)=Is text:K8:3)
			
			SET UPDATE FOLDER:C1291($folder; $silent)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "folder must be a folder platform pathname or a 4D.Folder!")
			
			//______________________________________________________
	End case 
	
	