//%attributes = {"preemptive":"incapable"}
// ----------------------------------------------------
// Project method: GIT OPEN
// ID[52DD5F426D1647FF837AF213147FFC6B]
// Created 4-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($run : Boolean)

var $winRef : Integer
var $folder : 4D:C1709.Folder

If (Count parameters:C259=0)
	
	BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; Current method name:C684; True:C214; *))
	return 
	
End if 

$folder:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)

OK:=Num:C11($folder.folder(".git").exists)

If (OK=0)
	
	While ($folder#Null:C1517)
		
		$folder:=$folder.parent
		
		If ($folder#Null:C1517) && ($folder.folder(".git").exists)
			
			OK:=1
			break
			
		End if 
	End while 
	
	If (OK=0)
		
		CONFIRM:C162(Localized string:C991("thisDatabaseIsNotUnderGitControl"); Localized string:C991("initializeTheGitRepository"))
		
	Else 
		
		CONFIRM:C162(Localized string:C991("thisDatabaseIsUnderGitSourceControlButNotAtThisLevel"))
		
	End if 
End if 

If (Bool:C1537(OK))
	
	$winRef:=Open form window:C675("GIT"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("GIT")
	CLOSE WINDOW:C154
	
End if 