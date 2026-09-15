//%attributes = {"invisible":true}
// Runs in a background worker (CALL WORKER): fetch the full `git log` AND build
// the ready-to-display commit collection (graph/SVG rendering) without ever
// touching the dialog's own process, then ask it to display the result
// (CALL FORM → Form.__DIALOG__.onCommitsRefreshed).
#DECLARE($params : Object)

var $caller : Integer:=$params.caller
var $git:=cs:C1710.Git.me
var $success:=False:C215

If ($git.command#Null:C1517)
	
	var $cmd : Text:=$git.command+"log --all --format=%s|%an|%h|%aI|%H|%p|%P|%ae|%gd|%D"
	
	var $worker:=4D:C1709.SystemWorker.new($cmd; {currentDirectory: $git.workspace; dataType: "text"})
	
	If ($worker#Null:C1517)
		
		$worker.wait()
		
		If (Length:C16($worker.response)>0)
			
			$success:=True:C214
			
			If (cs:C1710._commitsCache.me.hasChanged($worker.response))
				
				// Preload gravatar avatars HERE (blocking HTTP wait) and build the graph
				// + label pictures HERE (CPU-heavy), so the form process never blocks
				cs:C1710._gravatars.me.preloadFromLog($worker.response)
				
				var $commits:=cs:C1710._commitsBuilder.new(Bool:C1537($params.darkScheme)).build($worker.response; $git)
				
				cs:C1710._commitsCache.me.store($worker.response; $commits)
				
			Else 
				
				cs:C1710._commitsCache.me.abortLoading()
				
			End if 
			
		End if 
	End if 
End if 

If (Not:C34($success))
	
	cs:C1710._commitsCache.me.abortLoading()
	
End if 

If ($caller#0)
	
	CALL FORM:C1391($caller; Formula:C1597(Form:C1466.__DIALOG__.onCommitsRefreshed()))
	
End if 