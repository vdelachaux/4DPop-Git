//%attributes = {"invisible":true}
C_OBJECT:C1216($event;$menu;$oTarget)
C_VARIANT:C1683($v)

$event:=FORM Event:C1606

$oTarget:=Choose:C955($event.objectName="staged";Form:C1466.currentStaged;Form:C1466.currentUnstaged)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			$menu:=menu 
			
			Case of 
					
					  //______________________________________________________
				: ($event.objectName="unstaged")
					
					If (Form:C1466.selectedUnstaged.length=1)
						
						$menu.append("Open";"open")
						$menu.append("External Diff";"diffTool").shortcut("D")
						$menu.append("Show in Finder";"show")
						$menu.line()
						
					End if 
					
					If (Form:C1466.selectedUnstaged.length>0)
						
						$menu.append("Stage";"stage").shortcut("S";512)
						$menu.append("Discard Changes…";"discard")
						$menu.line()
						
					End if 
					
					$menu.append("Stage All";"stageAll").shortcut("S";512+2048)
					
					  //______________________________________________________
				: ($event.objectName="staged")
					
					If (Form:C1466.selectedStaged.length=1)
						
						$menu.append("Open";"open")
						$menu.append("External Diff";"diffTool").shortcut("D")
						$menu.append("Show in Finder";"show")
						$menu.line()
						
					End if 
					
					If (Form:C1466.selectedStaged.length>0)
						
						$menu.append("Unstage";"unstage").shortcut("S";512)
						$menu.line()
						
					End if 
					
					$menu.append("Unstage All";"stageAll").shortcut("S";512+2048)
					
					  //______________________________________________________
				: (False:C215)
					
					  //______________________________________________________
				Else 
					
					  // A "Case of" statement should never omit "Else"
					  //______________________________________________________
			End case 
			
			If ($menu.popup().selected)
				
				
				
				Case of 
						
						  //______________________________________________________
					: ($menu.choice="stage")
						
						STAGE 
						
						  //______________________________________________________
					: ($menu.choice="open")
						
						$v:=convertPath ($oTarget.path)
						
						Case of 
								
								  //——————————————————————————————————
							: (Value type:C1509($v)=Is text:K8:3)  // Method
								
								METHOD OPEN PATH:C1213($v)
								
								  //——————————————————————————————————
							: (Value type:C1509($v)=Is object:K8:27)  // File
								
								If (Bool:C1537($v.exists))
									
									OPEN URL:C673($v.platformPath)
									
								End if 
								
								  //——————————————————————————————————
							Else 
								
								  //
								
								  //——————————————————————————————————
						End case 
						
						  //______________________________________________________
					: ($menu.choice="diffTool")
						
						Form:C1466.git.diffTool($oTarget.path)
						
						  //______________________________________________________
					Else 
						
						ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are goint tout doux ;-)")
						
						  //______________________________________________________
				End case 
			End if 
			
		Else 
			
			Form:C1466.refresh()
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Double Clicked:K2:5)  // Stage
		
		Case of 
				
				  //______________________________________________________
			: ($event.objectName="unstaged")
				
				STAGE 
				
			Else 
				
				ALERT:C41("We are goint tout doux ;-)")
				
		End case 
		
		
		  //______________________________________________________
	: ($event.code=On Selection Change:K2:29)
		
		Form:C1466.refresh()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 