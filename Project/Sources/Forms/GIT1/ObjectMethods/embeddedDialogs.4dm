var $e:=FORM Event:C1606

If ($e.code<0)
	
	var $this : Object:=OBJECT Get value:C1743(OBJECT Get name:C1087).me.instance.data
	
	// MARK:-Specific actions
	var $form : cs:C1710._GIT_Controller:=formGetInstance
	var $git : cs:C1710.Git:=$form.Git
	
	Case of 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: ($this.CANCELLED)
			
			// <NOTHING MORE TO DO>
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($this.push))
			
			If ($git.remotes.length=0)
				
				// Handles its own alerts and refresh
				$form.CreateGithubRepository()
				return   // 📌 Avoid executing code that follows
				
			End if 
			
			If ($this.force)
				
				$git.forcePush()
				
			Else 
				
				$git.push()
				
			End if 
			
			If ($git.success)
				
				$form.onActivate()
				
			Else 
				
				$form.onDialogAlert({\
					title: "Error"; \
					additional: $git.error})
				
				return   // 📌 Avoid executing code that follows
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($this.pull))
			
			Form:C1466.stash:=Bool:C1537($this.stash)
			
			$git.pull(Bool:C1537($this.rebase); Bool:C1537($this.stash))
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($this.checkout))
			
			$form.checkout:={\
				noChange: $this.noChange; \
				stash: $this.stash; \
				discard: $this.discard}
			
			Case of 
					
					// ______________________________________________________
				: ($form.checkout.noChange)
					
					$git.stash("save"; "4DPop autostash "+String:C10(Current date:C33; Internal date long:K1:5)+" at "+String:C10(Current time:C178; HH MM:K7:2))
					var $success:=$git.checkout($this.branch).success
					
					// ______________________________________________________
				: ($form.checkout.stash)
					
					$form.autostash:=True:C214
					
					$git.stash("save")
					$success:=$git.checkout($this.branch).success
					$git.stash("pop")
					
					// ______________________________________________________
				: ($form.checkout.discard)
					
					$form.Discard(Form:C1466.unstaged)
					$success:=$git.checkout($this.branch).success
					
					// ______________________________________________________
			End case 
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			If (Not:C34($success))
				
				$form.onDialogAlert({main: "Git encountered an error"; additional: $git.error})
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		: (Bool:C1537($this.newBranch))
			
			Case of 
					
					// ______________________________________________________
				: (Length:C16(String:C10($this.branch))=0)
					
					BEEP:C151
					
					// ______________________________________________________
				: ($form.checkout.noChange)
					
					$git.stash("save"; "4DPop autostash "+String:C10(Current date:C33; Internal date long:K1:5)+" at "+String:C10(Current time:C178; HH MM:K7:2))
					$success:=$git.branch($this.checkout ? "createAndUse" : "create"; $this.branch).success
					
					// ______________________________________________________
				: ($form.checkout.stash)
					
					$form.autostash:=True:C214
					
					$git.stash("save")
					$success:=$git.branch($this.checkout ? "createAndUse" : "create"; $this.branch).success
					$git.stash("pop")
					
					// ______________________________________________________
				: ($form.checkout.discard)
					
					$form.Discard(Form:C1466.unstaged)
					$success:=$git.branch($this.checkout ? "createAndUse" : "create"; $this.branch).success
					
					// ______________________________________________________
			End case 
			
			RELOAD PROJECT:C1739
			
			$form.onActivate()
			
			If (Not:C34($success))
				
				$form.onDialogAlert({main: "Git encountered an error"; additional: $git.error})
				
			End if 
			
			//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
	End case 
	
	// MARK:-Standard actions
	$this.me.hide()
	
	return 
	
End if 

// MARK:-Standard (positive) form events

//
