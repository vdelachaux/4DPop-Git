//%attributes = {"invisible":true}
// Runs (via CALL FORM, from another window/process, e.g. the 4DPop toolbar widget)
// IN the Git history window's own context: forces its commit list to rebuild and
// selects the new current branch's tip commit.

If (Form:C1466.__DIALOG__#Null:C1517) && (String:C10(OB Class:C1730(Form:C1466.__DIALOG__).name)="_GIT_Controller")
	
	var $controller : cs:C1710._GIT_Controller:=Form:C1466.__DIALOG__
	
	cs:C1710._commitsCache.me.invalidate()
	$controller._kickCommitsRefresh()
	
	// Select the new HEAD right away; list content/labels catch up once the async rebuild completes
	var $sha : Text:=String:C10($controller.Git.workingBranch.ref)
	
	If (Length:C16($sha)>0)
		
		var $indices : Collection:=Form:C1466.commits.indices("fingerprint.short = :1 "; $sha)
		
		If ($indices.length>0)
			
			$controller.commits.select($indices[0]+1)
			
		End if 
	End if 
	
End if 
