//%attributes = {"preemptive":"incapable"}
// ----------------------------------------------------
// Project method: GIT OPEN
// ID[52DD5F426D1647FF837AF213147FFC6B]
// Created 4-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($run : Boolean)

If (Count parameters:C259=0)
	
	BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; Current method name:C684; True:C214; *))
	
	return 
	
End if 

var $git:=cs:C1710.Git.me

If ($git.root=Null:C1517) || Not:C34($git.root.exists)
	
	CONFIRM:C162(Localized string:C991("thisDatabaseIsNotUnderGitControl"); Localized string:C991("initializeTheGitRepository"))
	
	If (Bool:C1537(OK))
		
		$git.init()
		
	Else 
		
		return 
		
	End if 
End if 

If ($git.root.parent.path#$git.workspace.path)
	
	CONFIRM:C162(Localized string:C991("thisDatabaseIsUnderGitSourceControlButNotAtThisLevel"))
	
	If (Not:C34(Bool:C1537(OK)))
		
		return 
		
	End if 
End if 

var $winRef:=Open form window:C675("GIT"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
DIALOG:C40("GIT")
CLOSE WINDOW:C154