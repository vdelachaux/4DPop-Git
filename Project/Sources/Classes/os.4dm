property version; machine; processor : Text
property language; ipv4; ipv6 : Text
property macOS:=Is macOS:C1572
property Windows:=Is Windows:C1573
property linux : Boolean
property isARM; isRoseta : Boolean
property user; startupDisk : Object
property volumes : Collection
property systemFolder:=Folder:C1567(fk system folder:K87:13)
property applicationsFolder:=Folder:C1567(fk applications folder:K87:20)
property temporaryFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)

// FIXME: Hmm, these are the user's folders
property homeFolder:=Folder:C1567(fk home folder:K87:24)
property desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
property documentsFolder:=Folder:C1567(fk documents folder:K87:21)

property libraryFolder; cacheFolder; logsFolder : 4D:C1709.Folder

shared singleton Class constructor
	
	This:C1470.linux:=Not:C34(This:C1470.macOS) && Not:C34(This:C1470.Windows)
	
	var $infos:=System info:C1571
	
	This:C1470.version:=$infos.osVersion
	This:C1470.machine:=$infos.machineName
	This:C1470.processor:=$infos.processor
	
	This:C1470.isARM:=This:C1470.macOS ? $infos.processor="Apple M@" : False:C215  // TODO
	This:C1470.isRoseta:=This:C1470.macOS ? Bool:C1537($infos.macRosetta) : False:C215
	
	This:C1470.user:=OB Copy:C1225({\
		name: $infos.userName; \
		account: $infos.accountName}; ck shared:K85:29; This:C1470)
	
	This:C1470.language:=$infos.osLanguage
	
	This:C1470.ipv4:=Try($infos.networkInterfaces[0].ipAddresses.query("type=ipv4").first().ip)
	This:C1470.ipv6:=Try($infos.networkInterfaces[0].ipAddresses.query("type=ipv6").first().ip)
	
	This:C1470.volumes:=This:C1470.getVolumes($infos).copy(ck shared:K85:29; This:C1470)
	
	If (This:C1470.macOS)
		
		This:C1470.startupDisk:=This:C1470.volumes.query("name=:1"; Folder:C1567("/").fullName).first()
		
	Else 
		
		// TODO: Not defined for other OS (maybe find a way to do it later?)
		This:C1470.startupDisk:=Null:C1517
		
	End if 
	
	This:C1470.libraryFolder:=Is macOS:C1572\
		 ? This:C1470.homeFolder.folder("Library")\
		 : This:C1470.homeFolder.folder("AppData")
	
	This:C1470.cacheFolder:=This:C1470.libraryFolder.folder("Caches")
	This:C1470.logsFolder:=This:C1470.libraryFolder.folder("Logs")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
shared Function getVolumes($infos : Object) : Collection
	
	$infos:=$infos || System info:C1571
	
	return $infos.volumes