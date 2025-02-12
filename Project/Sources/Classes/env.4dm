property machineName; userName; fileURI : Text
property applicationsFolder; cacheFolder; desktopFolder; documentsFolder; homeFolder; systemFolder : 4D:C1709.Folder
property mainScreen; systemInfos : Object
property screens : Collection
property mainScreenID; menuBarHeight; toolBarHeight : Integer

property currencySymbol; decimalSeparator; thousandSeparator; dateSeparator : Text
property dateLongPattern; dateMediumPattern; dateShortPattern : Text
property timeSeparator; timeAMLabel; timePMLabel; timeLongPattern; timeMediumPattern; timeShortPattern : Text
property dateDayPosition; dateMonthPosition; dateYearPosition : Integer


Class constructor($full : Boolean)
	
	Super:C1705()
	
	This:C1470.machineName:=Current machine:C483
	This:C1470.userName:=Current system user:C484
	This:C1470.systemInfos:=System info:C1571
	
	This:C1470.applicationsFolder:=Folder:C1567(fk applications folder:K87:20)
	
	var $userPref : 4D:C1709.Folder:=Folder:C1567(fk user preferences folder:K87:10)
	
	Case of 
			
			// ________________________________________________________________________________
		: (Is Windows:C1573)
			
			This:C1470.cacheFolder:=$userPref.folder("../../Local").folder($userPref.name)
			
			// ________________________________________________________________________________
		: (Is macOS:C1572)
			
			This:C1470.cacheFolder:=$userPref.folder("../../Caches").folder($userPref.name)
			
			// ________________________________________________________________________________
		Else 
			
			This:C1470.cacheFolder:=Folder:C1567(fk home folder:K87:24).folder(".cache").folder($userPref.name)
			
			// ________________________________________________________________________________
	End case 
	
	This:C1470.desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
	This:C1470.documentsFolder:=Folder:C1567(fk documents folder:K87:21)
	This:C1470.homeFolder:=Folder:C1567(fk home folder:K87:24)
	This:C1470.systemFolder:=Folder:C1567(fk system folder:K87:13)
	
	This:C1470.screens:=Null:C1517
	This:C1470.mainScreenID:=0
	This:C1470.mainScreen:=Null:C1517
	This:C1470.menuBarHeight:=0
	This:C1470.toolBarHeight:=0
	
	This:C1470.fileURI:="file:"+("/"*(2+Num:C11(Is Windows:C1573)))
	
	$full:=Count parameters:C259>=1 ? $full : False:C215
	
	If ($full && (Is macOS:C1572 || Is Windows:C1573))
		
		This:C1470.getScreenInfos()
		
	End if 
	
	This:C1470.updateEnvironmentValues(True:C214)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get macos() : Boolean
	
	return Is macOS:C1572
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get windows() : Boolean
	
	return Is Windows:C1573
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get linux() : Boolean
	
	return Not:C34(Is Windows:C1573) & Not:C34(Is macOS:C1572)
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function startupDisk($path : Text; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567("/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update user & system values that may have been modified
Function updateEnvironmentValues($system : Boolean)
	
	var $value : Text
	
	Use (This:C1470)
		
		If ($system)  // To update the  volumes
			
			// ⚠️ time-consuming
			This:C1470.systemInfos:=OB Copy:C1225(System info:C1571; ck shared:K85:29; This:C1470)
			
		End if 
		
		GET SYSTEM FORMAT:C994(Currency symbol:K60:3; $value)
		This:C1470.currencySymbol:=$value
		
		GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $value)
		This:C1470.decimalSeparator:=$value
		
		GET SYSTEM FORMAT:C994(Thousand separator:K60:2; $value)
		This:C1470.thousandSeparator:=$value
		
		GET SYSTEM FORMAT:C994(Date separator:K60:10; $value)
		This:C1470.dateSeparator:=$value
		
		GET SYSTEM FORMAT:C994(Short date day position:K60:12; $value)
		This:C1470.dateDayPosition:=Num:C11($value)
		
		GET SYSTEM FORMAT:C994(Short date month position:K60:13; $value)
		This:C1470.dateMonthPosition:=Num:C11($value)
		
		GET SYSTEM FORMAT:C994(Short date year position:K60:14; $value)
		This:C1470.dateYearPosition:=Num:C11($value)
		
		GET SYSTEM FORMAT:C994(System date long pattern:K60:9; $value)
		This:C1470.dateLongPattern:=$value
		
		GET SYSTEM FORMAT:C994(System date medium pattern:K60:8; $value)
		This:C1470.dateMediumPattern:=$value
		
		GET SYSTEM FORMAT:C994(System date short pattern:K60:7; $value)
		This:C1470.dateShortPattern:=$value
		
		GET SYSTEM FORMAT:C994(Time separator:K60:11; $value)
		This:C1470.timeSeparator:=$value
		
		GET SYSTEM FORMAT:C994(System time AM label:K60:15; $value)
		This:C1470.timeAMLabel:=$value
		
		GET SYSTEM FORMAT:C994(System time PM label:K60:16; $value)
		This:C1470.timePMLabel:=$value
		
		GET SYSTEM FORMAT:C994(System time long pattern:K60:6; $value)
		This:C1470.timeLongPattern:=$value
		
		GET SYSTEM FORMAT:C994(System time medium pattern:K60:5; $value)
		This:C1470.timeMediumPattern:=$value
		
		GET SYSTEM FORMAT:C994(System time short pattern:K60:4; $value)
		This:C1470.timeShortPattern:=$value
		
	End use 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getScreenInfos()
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe screen commands are delegated to the application process
	$signal:=New signal:C1641("env")
	CALL WORKER:C1389("$nonThreadSafe"; "envNonThreadSafe"; $signal)
	$signal.wait()
	
	KILL WORKER:C1390("$nonThreadSafe")
	
	Use (This:C1470)
		
		//%W-550.2
		This:C1470.screens:=$signal.screens.copy(ck shared:K85:29; This:C1470)
		This:C1470.mainScreenID:=$signal.mainScreenID
		This:C1470.mainScreen:=This:C1470.screens[This:C1470.mainScreenID-1]
		This:C1470.menuBarHeight:=$signal.menuBarHeight
		This:C1470.toolBarHeight:=$signal.toolBarHeight
		//%W+550.2
		
	End use 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the horizontal & vertical offsets for each window type
shared Function windowOffsets($type : Integer; $isWindows : Boolean) : Object
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe screen commands are delegated to the application process
	$signal:=New signal:C1641("env")
	
	Use ($signal)
		
		$signal.action:="windowOffsets"
		
	End use 
	
	CALL WORKER:C1389("$nonThreadSafe"; "envNonThreadSafe"; $signal)
	$signal.wait()
	
	KILL WORKER:C1390("$nonThreadSafe")
	
	return {h: Num:C11($signal.hOffset); v: Num:C11($signal.vOffset)}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function library($path : Text; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.homeFolder.folder("Library/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function preferences($path : Text; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.homeFolder.folder("Library/Preferences/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function caches($path; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.homeFolder.folder("Library/Caches/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function logs($path : Text; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.homeFolder.folder("Library/Logs/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function applicationSupport($path : Text; $create : Boolean) : Object
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.homeFolder.folder("Library/Application Support/")
	
	return Count parameters:C259>=1 ? This:C1470._postProcessing($folder; $path; $create) : $folder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// From url syntax, returns either a 4D.File or a 4D.Folder, if exists
Function decodePathURL($url : Text) : Object
	
	If (Position:C15("file:"; $url)#1)
		
		return 
		
	End if 
	
	$url:=Replace string:C233($url; This:C1470.fileURI; "")
	
	If (Length:C16($url)=0)  // Root
		
		return Is Windows:C1573\
			 ? Folder:C1567("c:/"; fk posix path:K87:1)\
			 : Folder:C1567("/"; fk posix path:K87:1)
		
	End if 
	
	If (Bool:C1537(Try(Folder:C1567($url).exists)))  // Folder
		
		return Folder:C1567($url)
		
	End if 
	
	// File
	If ($url[[Length:C16($url)]]#"/")\
		 && (Bool:C1537(Try(File:C1566($url).exists)))
		
		return File:C1566($url)
		
	End if 
	
	//MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _postProcessing($target : Object; $pathOrCreate; $create : Boolean) : Object
	
	If (Count parameters:C259>=2)
		
		If (Value type:C1509($pathOrCreate)=Is boolean:K8:9)
			
			If ($pathOrCreate)
				
				$target.create()
				
			End if 
			
		Else 
			
			$target:=($pathOrCreate="@/") ? $target.folder($pathOrCreate) : $target.file($pathOrCreate)
			
		End if 
		
		If ($create)
			
			$target.create()
			
		End if 
	End if 
	
	return $target