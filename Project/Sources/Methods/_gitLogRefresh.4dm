//%attributes = {"invisible":true}
// Runs in a background worker (CALL WORKER): fetch the full `git log` without
// freezing the UI, cache the raw output, then ask the dialog to rebuild its
// commit list (CALL FORM → Form.__DIALOG__.onCommitsRefreshed).

#DECLARE($caller : Integer)

var $git:=cs:C1710.Git.me
var $success:=False:C215

If ($git.command#Null:C1517)
	
	var $cmd : Text:=$git.command+"log --all --format=%s|%an|%h|%aI|%H|%p|%P|%ae|%gd|%D"
	
	var $worker:=4D:C1709.SystemWorker.new($cmd; {currentDirectory: $git.workspace; dataType: "text"})
	
	If ($worker#Null:C1517)
		
		$worker.wait()
		
		If (Length:C16($worker.response)>0)
			
			cs:C1710._commitsCache.me.store($worker.response)
			$success:=True:C214
			
		End if 
	End if 
End if 

If (Not:C34($success))
	
	cs:C1710._commitsCache.me.abortLoading()
	
End if 

If ($caller#0)
	
	CALL FORM:C1391($caller; Formula:C1597(Form:C1466.__DIALOG__.onCommitsRefreshed()))
	
End if 
