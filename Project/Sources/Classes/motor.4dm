Class extends _classCore

property infos; languages; os : Object

Class constructor
	
	Super:C1705()
	
	This:C1470.exe:=Is macOS:C1572 ? Folder:C1567(Application file:C491; fk platform path:K87:2) : File:C1566(Application file:C491; fk platform path:K87:2)
	
	This:C1470._version:=Application version:C493
	This:C1470.__version:=Application version:C493(*)
	
	This:C1470.type:=Application type:C494
	This:C1470.versionType:=Version type:C495
	This:C1470.infos:=Get application info:C1599
	This:C1470.os:=Get system info:C1571
	
	This:C1470.languages:={\
		internal: Get database localization:C1009(Internal 4D localization:K5:24; *); \
		current: Get database localization:C1009(Current localization:K5:22; *); \
		default: Get database localization:C1009(Default localization:K5:21; *); \
		os: Get database localization:C1009(User system localization:K5:23; *); \
		programming: (Command name:C538(1)="Sum" ? "en" : "fr")\
		}
	
	// Make a _singleton
	This:C1470.Singletonize(This:C1470)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get root() : 4D:C1709.Folder
	
	return Is macOS:C1572 ? This:C1470.exe.folder("Contents") : This:C1470.exe.parent
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get local() : Boolean
	
	return (This:C1470.type=4D Local mode:K5:1) | (This:C1470.type=4D Desktop:K5:4)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get server() : Boolean
	
	return This:C1470.type=4D Server:K5:6
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get remote() : Boolean
	
	return This:C1470.type=4D Remote mode:K5:5
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get headless() : Boolean
	
	return Bool:C1537(This:C1470.infos.headless)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get service() : Boolean
	
	return Bool:C1537(This:C1470.infos.launchedAsService)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get demo() : Boolean
	
	return This:C1470.versionType ?? Demo version:K5:9
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get merged() : Boolean
	
	return This:C1470.versionType ?? Merged application:K5:28
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get branch() : Text
	
	return This:C1470._getInfos("branch")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get buildNumber() : Integer
	
	var $version : Text
	var $buildNumber : Integer
	
	$version:=Application version:C493($buildNumber)
	return $buildNumber
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get version() : Text
	
	return This:C1470._getInfos("version")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get shortVersion() : Text
	
	return This:C1470._getInfos("short-version")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get longVersion() : Text
	
	return This:C1470._getInfos("long-version")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get ipv4() : Text
	
	If (This:C1470.os.networkInterfaces#Null:C1517)\
		 && (This:C1470.os.networkInterfaces.length>0)\
		 && (This:C1470.os.networkInterfaces[0].ipAddresses#Null:C1517)\
		 && (This:C1470.os.networkInterfaces[0].ipAddresses.query("type=ipv4").length>0)
		
		return This:C1470.os.networkInterfaces[0].ipAddresses.query("type=ipv4").pop().ip
		
	Else 
		
		return "#NA"
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get machine() : Text
	
	return String:C10(This:C1470.os.machineName)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get arm() : Boolean
	
	return This:C1470.os.processor="Apple M@"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get debug() : Boolean
	
	return Position:C15("debug"; This:C1470._version)>0
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get newConnectionsAllowed() : Boolean
	
	return This:C1470.infos.newConnectionsAllowed
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get sdi() : Boolean
	
	return Is macOS:C1572 ? True:C214 : Bool:C1537(This:C1470.infos.SDIMode)
	
	//MARK:-THREAD SAFE
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function acceptNewConnections
	
	If (Asserted:C1132(This:C1470.server; Current method name:C684+" - In local mode this method does nothing"))
		
		REJECT NEW REMOTE CONNECTIONS:C1635(False:C215)
		This:C1470.infos.newConnectionsAllowed:=True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function rejectNewConnections
	
	If (Asserted:C1132(This:C1470.server; Current method name:C684+" - In local mode this method does nothing"))
		
		REJECT NEW REMOTE CONNECTIONS:C1635(True:C214)
		This:C1470.infos.newConnectionsAllowed:=False:C215
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getInfos($type : Text) : Text
	
	var $major; $release; $revision : Text
	var $c : Collection
	
/*
The Application version command returns an encoded string value that expresses
The version number of the 4D environment you are running.
	
- If you do not pass the optional * parameter, a 4-character string is returned,
	
formatted as follows:
1-2   LTS version
3     Release number
4     Revision number
	
ie:
"1800" for v18
"1820" for v18 Release 2
"1830" for v18 Release 3
"1801" for v18.1 (first fix release of v18)
"1802" for v18.2 (second fix release of v18)
	
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
	
	$c:=Split string:C1554(This:C1470._version; "")
	$major:=$c[0]+$c[1]  // LTS version
	$release:=$c[2]  // Release number
	$revision:=$c[3]  // Revision number
	
	Case of 
			
			//______________________________________________________
		: ($type="application")
			
			return Choose:C955(Num:C11(This:C1470.type); "4D local"; "4D Volume desktop"; "#NA"; "4D Desktop"; "4D Remote"; "4D Server")
			
			//______________________________________________________
		: ($type="product")
			
			// Returns the current product name ie. 4D v18
			return This:C1470._getInfos("application")+" v"+$major
			
			//______________________________________________________
		: ($type="major")
			
			return $major
			
			//______________________________________________________
		: ($type="version")
			
/*
Return the long version string of the product
Marketing + minor or release + build
*/
			
			If ($release="0")
				
				// 4D v18.1 build 18.128437
				return This:C1470._getInfos("short-version")+" build "+$major+"."+String:C10(This:C1470.buildNumber)
				
			Else 
				
				// 4D v18 R2 build 18R2.128437
				return This:C1470._getInfos("short-version")+" build "+$major+"R"+$release+"."+String:C10(This:C1470.buildNumber)
				
			End if 
			
			//______________________________________________________
		: ($type="long-version")
			
			$c:=Split string:C1554(This:C1470.__version; "")
			
			Case of 
					
					//………………………………………………………
				: ($c[0]="F")  // "F" denotes a final version
					
					return This:C1470._getInfos("version")
					
					//………………………………………………………
				: ($c[0]="B")  // "B" denotes a beta version
					
					return This:C1470._getInfos("version")+" (beta "+$c[1]+$c[2]+")"
					
					//………………………………………………………
				Else   // Other characters denote an 4D internal version ie: 4D v18 R6 build 18R6.257882 (A1)
					
					return This:C1470._getInfos("version")+" ("+$c[0]+$c[3]+")"
					
					//………………………………………………………
			End case 
			
			//______________________________________________________
		: ($type="short-version")
			
/*
Return the short version string of the product
Marketing + minor or release
*/
			
			If ($release="0")
				
				// Revision number
				return This:C1470._getInfos("product")+Choose:C955($revision#"0"; "."+$revision; "")
				
			Else 
				
				// Release number
				return This:C1470._getInfos("product")+" R"+$release
				
			End if 
			
			//______________________________________________________
		: ($type="web-version")
			
/*
Return the short version string of the product
minor or release without space for web compatibility
*/
			
			If ($release="0")
				
				// 14
				return Replace string:C233(This:C1470._getInfos("major"); " "; "")
				
			Else 
				
				// 14R5
				return Replace string:C233(This:C1470._getInfos("major")+"R"+$release; " "; "")
				
			End if 
			
			//______________________________________________________
		: ($type="build")
			
			return String:C10(This:C1470.buildNumber)
			
			//______________________________________________________
		: ($type="branch")
			
			If ($release="0")
				
				// Revision number
				return $major+Choose:C955($revision#"0"; "."+$revision; "")
				
			Else 
				
				// Release number
				return $major+"R"+$release
				
			End if 
			
			//______________________________________________________
			
		Else 
			
			return "Unknown entry point: \""+$type+"\""
			
			//______________________________________________________
	End case 
	
	//MARK:-NOT THREAD SAFE
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restart($delay : Integer; $message : Text)
	
	//%T-
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			RESTART 4D:C1292($delay; $message)
			
		Else 
			
			RESTART 4D:C1292($delay)
			
		End if 
		
	Else 
		
		RESTART 4D:C1292
		
	End if 
	//%T+
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function quit($delay : Integer)
	
	//%T-
	QUIT 4D:C291($delay)
	//%T+
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setUpdateFolder($folder; $silent : Boolean)
	
	//%T-
	If (Value type:C1509($folder)=Is object:K8:27)
		
		If (OB Instance of:C1731($folder; 4D:C1709.Folder))
			
			SET UPDATE FOLDER:C1291(String:C10($folder.platformPath); $silent)
			
		Else 
			
			// ERROR
			
		End if 
		
	Else 
		
		SET UPDATE FOLDER:C1291(String:C10($folder); $silent)
		
	End if 
	//%T+