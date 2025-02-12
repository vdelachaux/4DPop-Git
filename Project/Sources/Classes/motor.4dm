property app : Object  // Application (macOS: 4D.app folder, Windows: 4D.exe file)
property name : Text  // Application name
property root : 4D:C1709.Folder  // The application root folder
property exe : 4D:C1709.File  // Executable file
property cache : 4D:C1709.Folder  // The cache folder

property type : Integer  // Application type
property versionType : Integer  // Version type

property infos : Object  // Application info
property languages : Object  // The different used languages

property components : Collection  // The loaded components names
property plugins : Collection  // The loaded plugins

property isLocal; isServer; isRemote; isMerged; isDemo; isHeadless; asService; isDebug; isSDI : Boolean
property appVersion : Object

property favorites : 4D:C1709.Folder

property _version; __version : Text

shared singleton Class constructor()
	
	var $buildNumber : Integer
	This:C1470._version:=Application version:C493($buildNumber)
	This:C1470.__version:=Application version:C493(*)
	
	This:C1470.app:=Is macOS:C1572\
		 ? Folder:C1567(Application file:C491; fk platform path:K87:2)\
		 : File:C1566(Application file:C491; fk platform path:K87:2)
	
	This:C1470.name:=This:C1470.app.name
	
	This:C1470.root:=Is macOS:C1572\
		 ? This:C1470.app.folder("Contents")\
		 : This:C1470.app.parent
	
	This:C1470.exe:=Is macOS:C1572\
		 ? This:C1470.root.folder("MacOS").file(This:C1470.root.file("Info.plist").getAppInfo().CFBundleExecutable)\
		 : This:C1470.app
	
	If (This:C1470.exe#Null:C1517)
		
		This:C1470.cache:=cs:C1710.os.me.cacheFolder.folder(This:C1470.exe.name)
		
	End if 
	
	This:C1470.type:=Application type:C494
	
	This:C1470.isLocal:=(This:C1470.type=4D Local mode:K5:1) || (This:C1470.type=4D Desktop:K5:4)
	This:C1470.isServer:=This:C1470.type=4D Server:K5:6
	This:C1470.isRemote:=This:C1470.type=4D Remote mode:K5:5
	
	This:C1470.versionType:=Version type:C495
	
	This:C1470.isMerged:=This:C1470.versionType ?? Merged application:K5:28
	This:C1470.isDemo:=This:C1470.versionType ?? Demo version:K5:9
	
	This:C1470.infos:=OB Copy:C1225(Application info:C1599; ck shared:K85:29; This:C1470)
	
	This:C1470.isHeadless:=Bool:C1537(This:C1470.infos.headless)
	This:C1470.asService:=Bool:C1537(This:C1470.infos.launchedAsService)
	
	var $o:={\
		internal: Get database localization:C1009(Internal 4D localization:K5:24; *); \
		current: Get database localization:C1009(Current localization:K5:22; *); \
		default: Get database localization:C1009(Default localization:K5:21; *); \
		os: Get database localization:C1009(User system localization:K5:23; *); \
		programming: (Command name:C538(1)="Sum" ? "intl" : "fr")\
		}
	
	This:C1470.languages:=OB Copy:C1225($o; ck shared:K85:29; This:C1470)
	
	var $c:=[]
	
	ARRAY TEXT:C222($textArray; 0x0000)
	COMPONENT LIST:C1001($textArray)
	ARRAY TO COLLECTION:C1563($c; $textArray)
	This:C1470.components:=$c.copy(ck shared:K85:29; This:C1470)
	
	ARRAY INTEGER:C220($intArray; 0x0000)
	PLUGIN LIST:C847($intArray; $textArray)
	ARRAY TO COLLECTION:C1563($c; $textArray)
	This:C1470.plugins:=$c.copy(ck shared:K85:29; This:C1470)
	
	$c:=Split string:C1554(This:C1470._version; "")
	$o:={\
		major: Num:C11($c[0]+$c[1]); \
		release: Num:C11($c[2]); \
		revision: Num:C11($c[3]); \
		build: $buildNumber\
		}
	
	$c:=Split string:C1554(This:C1470.__version; "")
	$o.isFinal:=$c[0]="F"
	$o.isBeta:=$c[0]="B"
	$o.isAlpha:=Not:C34($o.isFinal) & Not:C34($o.isBeta)
	
	
	If ($o.isAlpha)
		
		$o.internal:=$c[1]+$c[2]+$c[3]
		
	Else 
		
		If ($o.isBeta)
			
			$o.internal:=$c[1]+$c[2]
			
		End if 
	End if 
	
	This:C1470.appVersion:=OB Copy:C1225($o; ck shared:K85:29; This:C1470)
	
	This:C1470.favorites:=Folder:C1567(fk user preferences folder:K87:10)\
		.folder("Favorites v"+String:C10(This:C1470.appVersion.major)+"/"+(This:C1470.isLocal ? "Local" : "Remote"))
	
	This:C1470.isDebug:=Position:C15("debug"; String:C10(This:C1470.__version))>0
	This:C1470.isSDI:=Is macOS:C1572 ? True:C214 : Bool:C1537(This:C1470.infos.SDIMode)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get major() : Text
	
	return String:C10(This:C1470.appVersion.major)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get build() : Text
	
	return String:C10(This:C1470.appVersion.build)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get branch() : Text
	
	return This:C1470._getInfos("branch")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get version() : Text
	
	return This:C1470._getInfos("version")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get shortVersion() : Text
	
	return This:C1470._getInfos("short-version")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get longVersion() : Text
	
	return This:C1470._getInfos("long-version")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getInfos($type : Text) : Text
	
/*
The Application version command returns an encoded string value that expresses
The version number of the 4D environment you are running.
	
- If you do not pass the optional * parameter, a 4-character string is returned,
formatted as follows:
       1-2   LTS version
       3     Release number
       4     Revision number
	
ie:
"1800" for 18
"1820" for 18 Release 2
"1830" for 18 Release 3
"1801" for 18.1 (first fix release of 18)
"1802" for 18.2 (second fix release of 18)
	
- If you pass the optional * parameter, an 8-character string is returned,
	
formatted as follows:
1      "F" denotes a final version
       "B" denotes a beta version
       Other characters denote an 4D internal version
2-3-4  Internal 4D compilation number
5-6    LTS version
7      Release number
8      Revision number
*/
	
	// 🆕 20R8+ the 3rd digit (R value) is expressed in Hex :  "20F0" for 20R15
	
	var $o:=This:C1470.appVersion
	
	Try
		
		Case of 
				
				//______________________________________________________
			: ($type="application")
				
				return Choose:C955(Num:C11(This:C1470.type); "4D local"; "4D Volume desktop"; "#NA"; "4D Desktop"; "4D Remote"; "4D Server")
				
				//______________________________________________________
			: ($type="product")  // Marketing ie. 4D 20
				
				return This:C1470._getInfos("application")+" "+String:C10($o.major)
				
				//______________________________________________________
			: ($type="major")
				
				return String:C10($o.major)
				
				//______________________________________________________
			: ($type="version")  // Marketing + minor or release + build
				
				If ($o.release=0)
					
					return This:C1470._getInfos("short-version")+" build "+String:C10($o.major)+"."+String:C10($o.build)+" LTS"
					
				Else 
					
					return This:C1470._getInfos("short-version")+" build "+String:C10($o.major)+"R"+String:C10(This:C1470.hex2long(String:C10($o.release)))+"."+String:C10($o.build)
					
				End if 
				
				//______________________________________________________
			: ($type="long-version")
				
				Case of 
						
						//………………………………………………………
					: ($o.isFinal)
						
						return This:C1470._getInfos("version")
						
						//………………………………………………………
					: ($o.isBeta)
						
						return This:C1470._getInfos("version")+" (beta "+$o.internal+")"
						
						//………………………………………………………
					: ($o.isAlpha)
						
						return This:C1470._getInfos("version")+" (A"+$o.internal+")"
						
						//………………………………………………………
				End case 
				
				//______________________________________________________
			: ($type="short-version")  // Marketing + minor or release
				
				If ($o.release=0)
					
					return This:C1470._getInfos("product")+Choose:C955($o.revision#0; "."+String:C10($o.revision); "")
					
				Else 
					
					return This:C1470._getInfos("product")+" R"+String:C10(This:C1470.hex2long(String:C10($o.release)))
					
				End if 
				
				//______________________________________________________
			: ($type="web-version")
				
/*
Return the short version string of the product
minor or release without space for web compatibility
*/
				
				If ($o.release=0)
					
					return Replace string:C233(This:C1470._getInfos("major"); " "; "")
					
				Else 
					
					return Replace string:C233(This:C1470._getInfos("major")+"R"+String:C10(This:C1470.hex2long(String:C10($o.release))); " "; "")
					
				End if 
				
				//______________________________________________________
			: ($type="build")
				
				return String:C10($o.build)
				
				//______________________________________________________
			: ($type="branch")
				
				If ($o.release=0)
					
					return String:C10($o.major)+Choose:C955($o.revision#0; "."+String:C10($o.revision); "")+" LTS"
					
				Else 
					
					return String:C10($o.major)+"R"+String:C10(This:C1470.hex2long(String:C10($o.release)))
					
				End if 
				
				//______________________________________________________
			Else 
				
				return "Unknown entry point: \""+$type+"\""
				
				//______________________________________________________
		End case 
		
	Catch
		
		return "NA"
		
	End try
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get newConnectionsAllowed() : Boolean
	
	return This:C1470.infos.newConnectionsAllowed
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function acceptNewConnections
	
	If (Asserted:C1132(This:C1470.isServer; Current method name:C684+" - In local mode this method does nothing"))
		
		REJECT NEW REMOTE CONNECTIONS:C1635(False:C215)
		This:C1470.infos.newConnectionsAllowed:=True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function rejectNewConnections
	
	If (Asserted:C1132(This:C1470.isServer; Current method name:C684+" - In local mode this method does nothing"))
		
		REJECT NEW REMOTE CONNECTIONS:C1635(True:C214)
		This:C1470.infos.newConnectionsAllowed:=False:C215
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restart($delay : Integer; $message : Text)
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			RESTART 4D:C1292($delay; $message)
			
		Else 
			
			RESTART 4D:C1292($delay)
			
		End if 
		
	Else 
		
		RESTART 4D:C1292
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function quit($delay : Integer)
	
	QUIT 4D:C291($delay)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Starts a 4D client and connects it to the current server
Function autoConnect($client : Object; $userParam) : Object
	
	var $result:={success: False:C215}
	
	If (Not:C34(This:C1470.isServer))
		
		$result.error:="The running application is not a server"
		return $result
		
	End if 
	
	var $infos:=This:C1470.infos
	
	If ($infos.IPAddressesToListen.length=0)
		
		$result.error:="No IP Adress to listen"
		return $result
		
	End if 
	
	var $root:=DOM Create XML Ref:C861("database_shortcut")
	
	If (Not:C34(Bool:C1537(OK)))
		
		$result.error:="Failed to create XML Ref"
		return $result
		
	End if 
	
	XML SET OPTIONS:C1090($root; XML indentation:K45:34; XML with indentation:K45:35)
	
	DOM SET XML ATTRIBUTE:C866($root; \
		"is_remote"; True:C214; \
		"server_database_name"; This:C1470.name; \
		"server_path"; $infos.IPAddressesToListen[0]+":"+String:C10($infos.portID))
	
	If ($userParam#Null:C1517)
		
		If (Value type:C1509($userParam)=Is object:K8:27)\
			 | (Value type:C1509($userParam)=Is collection:K8:32)
			
			DOM SET XML ATTRIBUTE:C866($root; "user_param"; JSON Stringify:C1217($userParam))
			
		Else 
			
			DOM SET XML ATTRIBUTE:C866($root; "user_param"; String:C10($userParam))
			
		End if 
	End if 
	
	var $xml : Text
	DOM EXPORT TO VAR:C863($root; $xml)
	DOM CLOSE XML:C722($root)
	
	var $4DLink : 4D:C1709.File:=This:C1470.root.file("autoconnect.4DLink")
	$4DLink.setText($xml)
	
	If (Not:C34($4DLink.exists))
		
		$result.error:="Failed to create file: "+$4DLink.path
		return $result
		
	End if 
	
	// Launch 4D client
	Case of 
			
			//______________________________________________________
		: (Is Windows:C1573)
			
			var $cmd : Text:=$client.path+" "+Char:C90(Double quote:K15:41)+$4DLink.platformPath+Char:C90(Double quote:K15:41)
			
			//______________________________________________________
		: (Is macOS:C1572)
			
			$cmd:="open -F -n -a "+Char:C90(Quote:K15:44)+$client.path+Char:C90(Quote:K15:44)+" "+Char:C90(Quote:K15:44)+$4DLink.path+Char:C90(Quote:K15:44)
			
			//______________________________________________________
	End case 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "FALSE")
	var $error; $input; $output : Text
	LAUNCH EXTERNAL PROCESS:C811($cmd; $input; $output; $error)
	
	If (Bool:C1537(OK))
		
		$result.success:=Length:C16($error)=0 ? True:C214 : $error
		
	Else 
		
		$result.error:="Failed to launch application "+String:C10($client.name)
		
	End if 
	
	return $result
	
	//MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isPreemptive() : Boolean
	
	return Process info:C1843(Current process:C322).preemptive
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function hex2long($hex) : Integer
	
	$hex:=Uppercase:C13($hex)
	var $length:=Length:C16($hex)
	
	var $i : Integer
	var $num : Real
	For ($i; $length; 1; -1)
		
		//%W-533.1
		var $charCode:=Character code:C91($hex[[$i]])
		//%W+533.1
		
		Case of 
				
				// ……………………………………………………………
			: (($charCode>47)\
				 && ($charCode<58))  // 0..9
				
				$num+=(($charCode-48)*(16^($length-$i)))
				
				// ……………………………………………………………
			: (($charCode>64)\
				 && ($charCode<71))  // A..F
				
				$num+=(($charCode-55)*(16^($length-$i)))
				
				// ……………………………………………………………
			Else   // "x" of Ox or other gizmo...
				
				break
				
				// ……………………………………………………………
		End case 
	End for 
	
	return Int:C8($num)