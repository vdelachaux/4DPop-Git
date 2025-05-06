var $e:=FORM Event:C1606

If ($e.code<0)
	
	var $data : Object:=OBJECT Get value:C1743(OBJECT Get name:C1087).me.instance.data
	
	// MARK:-Specific actions
	var $form : cs:C1710._GIT_Controller:=formGetInstance
	var $git : cs:C1710.Git:=$form.Git
	
	Case of 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: ($data.CANCELLED)
			
			// <NOTHING MORE TO DO>
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.push))
			
			$git.updateRemotes()
			
			If ($git.remotes.length=0)  // Create
				
				var $gh:=cs:C1710.gh.me
				
				If (Not:C34($gh.available))
					
					$form.onDialogAlert({\
						title: $gh.lastError; \
						additional: "Installation instructions can be found at:\n\nhttps://github.com/cli/cli#installation"})
					
					return   // 📌 Avoid executing code that follows
					
				End if 
				
				If (Not:C34($gh.login()))
					
					return 
					
				End if 
				
				// Create remote
				var $remote:=$gh.createRepo($git.workspace.name)
				
				// Add the remote
				If ($git.execute("remote add -m -t origin "+$remote))
					
					$git.addRemote($git.currentBranch; $remote)
					$git.push("origin"; $git.currentBranch)
					
				End if 
				
			Else 
				
				If ($data.force)
					
					$git.forcePush()
					
				Else 
					
					$git.push()
					
				End if 
			End if 
			
			If ($git.success)
				
				$form.onActivate()
				
			Else 
				
				$form.onDialogAlert({\
					title: "Error"; \
					additional: $git.error || Localized string:C991("unknownError")})
				
				return   // 📌 Avoid executing code that follows
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.pull))
			
			Form:C1466.stash:=Bool:C1537($data.stash)
			
			$git.pull(Bool:C1537($data.rebase); Bool:C1537($data.stash))
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.checkout))
			
			$form.checkout:={\
				noChange: $data.noChange; \
				stash: $data.stash; \
				discard: $data.discard}
			
			Case of 
					
					// ______________________________________________________
				: ($form.checkout.noChange)
					
					var $t:=Replace string:C233(Localized string:C991("autostash"); "{date}"; String:C10(Current date:C33; Internal date long:K1:5))
					$git.stash("save"; Replace string:C233($t; "{time}"; String:C10(Current time:C178; HH MM:K7:2)))
					var $success:=$git.checkout($data.branch).success
					
					// ______________________________________________________
				: ($form.checkout.stash)
					
					$form.autostash:=True:C214
					
					$git.stash("save")
					$success:=$git.checkout($data.branch).success
					$git.stash("pop")
					
					// ______________________________________________________
				: ($form.checkout.discard)
					
					$form.Discard(Form:C1466.unstaged)
					$success:=$git.checkout($data.branch).success
					
					// ______________________________________________________
			End case 
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			If (Not:C34($success))
				
				$form.onDialogAlert({main: Localized string:C991("gitEncounteredAnError"); additional: $git.error})
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($data.newBranch))
			
			Case of 
					
					// ______________________________________________________
				: (Length:C16(String:C10($data.branch))=0)
					
					BEEP:C151
					
					// ______________________________________________________
				: ($form.checkout.noChange)
					
					$t:=Replace string:C233(Localized string:C991("autostash"); "{date}"; String:C10(Current date:C33; Internal date long:K1:5))
					$git.stash("save"; Replace string:C233($t; "{time}"; String:C10(Current time:C178; HH MM:K7:2)))
					$success:=$git.branch($data.checkout ? "createAndUse" : "create"; $data.branch).success
					
					// ______________________________________________________
				: ($form.checkout.stash)
					
					$form.autostash:=True:C214
					
					$git.stash("save")
					$success:=$git.branch($data.checkout ? "createAndUse" : "create"; $data.branch).success
					$git.stash("pop")
					
					// ______________________________________________________
				: ($form.checkout.discard)
					
					$form.Discard(Form:C1466.unstaged)
					$success:=$git.branch($data.checkout ? "createAndUse" : "create"; $data.branch).success
					
					// ______________________________________________________
			End case 
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			If (Not:C34($success))
				
				$form.onDialogAlert({main: Localized string:C991("gitEncounteredAnError"); additional: $git.error})
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
	End case 
	
	// MARK:-Standard actions
	$data.me.hide()
	
	return 
	
End if 

// MARK:-Standard (positive) form events

//
