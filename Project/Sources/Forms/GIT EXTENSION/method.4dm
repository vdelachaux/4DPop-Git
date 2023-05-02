var $e : Object

$e:=FORM Event:C1606

Case of 
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		BEEP:C151
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		var $branch : Text
		var $success : Boolean
		var $c : Collection
		var $git : cs:C1710.git
		
		If (Not:C34(Bool:C1537(Form:C1466.inited)))
			
			Form:C1466.timer:=20
			Form:C1466.branch:=""
			Form:C1466.changes:=0
			Form:C1466.fetchNumber:=0
			Form:C1466.pushNumber:=0
			
			$c:=Split string:C1554(Application version:C493; "")
			
			Form:C1466.release:=$c[2]#"0"
			Form:C1466.lts:=Not:C34(Form:C1466.release)
			
			Form:C1466.major:=$c[0]+$c[1]
			Form:C1466.minor:=Form:C1466.release ? "R"+$c[2] : "."+$c[3]
			Form:C1466.alpha:=Application version:C493(*)="A@"
			
			Form:C1466.version:=Form:C1466.major+Form:C1466.minor
			
			If (Form:C1466.alpha)
				
				Form:C1466.version:="DEV ("+Form:C1466.version+")"
				
			End if 
			
			
			var $folder : 4D:C1709.Folder
			$folder:=Folder:C1567(Folder:C1567("/PACKAGE"; *).platformPath; fk platform path:K87:2)
			
			While ($folder#Null:C1517)\
				 && Not:C34($folder.folder(".git").exists)
				
				$folder:=$folder.parent
				
			End while 
			
			If ($folder#Null:C1517) && ($folder.exists)
				
				//This.gitInstance:=cs.git.new($folder)
				
			Else 
				
				This:C1470.gitInstance:=Null:C1517
				
			End if 
			
			Form:C1466.inited:=True:C214
			
		End if 
		
		$git:=This:C1470.gitInstance
		
		If ($git#Null:C1517)
			
			$branch:=$git.currentBranch
			
			If ($branch#Form:C1466.branch)
				
				Form:C1466.branch:=$branch
				
				If (Form:C1466.alpha)
					
					$success:=(Form:C1466.branch="main")\
						 || (Form:C1466.branch="master")\
						 || (Form:C1466.branch=(Form:C1466.major+Form:C1466.minor+"@"))\
						 || (Split string:C1554(Form:C1466.branch; "/").length>1)
					
				Else 
					
					If (Form:C1466.release)
						
						$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
							 || (Form:C1466.branch=(Form:C1466.major+"RX"))
						
					Else 
						
						$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
							 || (Form:C1466.branch=(Form:C1466.major+".X"))
						
					End if 
				End if 
				
				If ($success)
					
					This:C1470.branch.foregroundColor:=Foreground color:K23:1
					This:C1470.branch.fontStyle:=Plain:K14:1
					This:C1470.branch.setHelpTip("\""+$branch+"\" is the current branch")
					
				Else 
					
					This:C1470.branch.foregroundColor:="red"
					This:C1470.branch.fontStyle:=Bold:K14:2
					This:C1470.branch.setHelpTip("WARNING:\nYou are editing the \""+$branch+"\" branch of \""+Folder:C1567("/PACKAGE"; *).name+"\" \nwith a "+Form:C1466.version+" version of 4D.")
					
				End if 
			End if 
			
			Form:C1466.fetchNumber:=$git.branchFetchNumber($branch)
			Form:C1466.pushNumber:=$git.branchPushNumber($branch)
			Form:C1466.changes:=$git.status()
			
			This:C1470.gitItems.show()
			This:C1470.initRepository.hide()
			
			This:C1470.refresh(60*This:C1470.timer)
			
		Else 
			
			This:C1470.gitItems.hide()
			This:C1470.initRepository.show()
			
		End if 
		
		SET TIMER:C645(Num:C11(Form:C1466.timer))
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 