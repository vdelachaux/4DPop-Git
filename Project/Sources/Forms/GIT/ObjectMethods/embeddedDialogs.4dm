var $e : Object
$e:=FORM Event:C1606

If ($e.code<0)
	
	var $name : Text
	$name:=OBJECT Get name:C1087(Object current:K67:2)
	
	// Get data associated with the subform
	var $form : Text
	var $ptr : Pointer  // The name of the current displayed sub-form
	OBJECT GET SUBFORM:C1139(*; $name; $ptr; $form)
	
	// Get data associated with the subform
	var $data : Object
	$data:=OBJECT Get value:C1743($name)
	
/*
	
Doing things, if need be
	
Possibly call "return" to avoid executing the "Standard actions" code that follows.
	
*/
	
	var $me : Object
	$me:=formGetInstance
	
	var $git : cs:C1710.Git
	$git:=$me.Git
	
	// MARK:Specific actions
	Case of 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.cancel))
			
			OBJECT SET VISIBLE:C603(*; $name; False:C215)
			return 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.push))
			
			OBJECT SET VISIBLE:C603(*; $name; False:C215)
			
			If ($git.remotes.length=0)
				
				var $gh : cs:C1710.gh
				$gh:=cs:C1710.gh.new()
				
				If (Not:C34($gh.available))
					
					$me.alertDialog.show({\
						title: $gh.lastError; \
						additional: "Installation instructions can be found at:\n\nhttps://github.com/cli/cli#installation"})
					
					return 
					
				End if 
				
				$gh.logIn()
				
				// Create remote
				var $remote : Text
				$remote:=$gh.createRepo($git.cwd.name)
				
				// Add the remote
				$git.execute("remote add -m -t origin "+$remote)
				
				$git.remotes.push({\
					name: "master"; \
					url: $remote\
					})
				
				$git.push("origin"; "refs/heads/master")
				
			Else 
				
				$git.push()
				
			End if 
			
			If ($git.success)
				
				$me.onActivate()
				
			Else 
				
				$me.alertDialog.show({\
					title: "Error"; \
					additional: $git.error})
				
			End if 
			
			return 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.pull))
			
			OBJECT SET VISIBLE:C603(*; $name; False:C215)
			
			Form:C1466.stash:=Bool:C1537($data.stash)
			
			$git.pull(Bool:C1537($data.rebase); Form:C1466.stash)
			$me.onActivate()
			
			RELOAD PROJECT:C1739
			return 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
	End case 
	
	// MARK:Standard actions
	Case of 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.close))
			
			OBJECT SET VISIBLE:C603(*; $name; False:C215)
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
	End case 
	
Else 
	
	// Standard form events
	
End if 