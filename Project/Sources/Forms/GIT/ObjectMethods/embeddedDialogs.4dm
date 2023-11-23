var $e : Object
$e:=FORM Event:C1606

If ($e.code<0)
	
	var $me : Object
	$me:=OBJECT Get value:C1743(OBJECT Get name:C1087).me.instance.data
	
	// MARK:-Specific actions
	var $form : Object
	$form:=formGetInstance
	
	var $git : cs:C1710.Git
	$git:=$form.Git
	
	Case of 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: ($me.CANCELLED)
			
			// <NOTHING MORE TO DO>
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($me.push))
			
			If ($git.remotes.length=0)
				
				var $gh : cs:C1710.gh
				$gh:=cs:C1710.gh.new()
				
				If (Not:C34($gh.available))
					
					$form.alertDialog.show({\
						title: $gh.lastError; \
						additional: "Installation instructions can be found at:\n\nhttps://github.com/cli/cli#installation"})
					
					return   // 📌 Avoid executing code that follows
					
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
				
				If ($me.force)
					
					$git.forcePush()
					
				Else 
					
					$git.push()
					
				End if 
			End if 
			
			If ($git.success)
				
				$form.onActivate()
				
			Else 
				
				$form.alertDialog.show({\
					title: "Error"; \
					additional: $git.error})
				
				return   // 📌 Avoid executing code that follows
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($me.pull))
			
			Form:C1466.stash:=Bool:C1537($me.stash)
			
			$git.pull(Bool:C1537($me.rebase); Form:C1466.stash)
			$form.onActivate()
			
			RELOAD PROJECT:C1739
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
	End case 
	
	// MARK:-Standard actions
	$me.me.hide()
	
	return 
	
End if 

// MARK:-Standard (positive) form events

//
