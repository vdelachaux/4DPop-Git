//%attributes = {"invisible":true}
<<<<<<< HEAD
  // ----------------------------------------------------
  // Project method : ACTIONS
  // ID[729EF4A4ABD24823A8476241DAF87DE2]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($event;$menu;$oTarget)
C_COLLECTION:C1488($cTarget)
C_VARIANT:C1683($v)

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

$event:=FORM Event:C1606

$oTarget:=Choose:C955($event.objectName="staged";Form:C1466.currentStaged;Form:C1466.currentUnstaged)
$cTarget:=Choose:C955($event.objectName="staged";Form:C1466.selectedStaged;Form:C1466.selectedUnstaged)
=======
C_OBJECT:C1216($event;$menu;$oTarget)
C_VARIANT:C1683($v)

$event:=FORM Event:C1606

$oTarget:=Choose:C955($event.objectName="staged";Form:C1466.currentStaged;Form:C1466.currentUnstaged)
>>>>>>> gitlab

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			$menu:=menu 
			
<<<<<<< HEAD
			If ($cTarget.length=1)
				
				$menu.append("Open";"open")
				
				If (New collection:C1472("??";" D";"A ").indexOf($oTarget.status)=-1)
					
					$menu.append("External Diff";"diffTool").shortcut("D")
					
				End if 
				
				If (New collection:C1472(" D").indexOf($oTarget.status)=-1)
					
					$menu.append("Show in Finder";"show")
					
				End if 
				
				$menu.line()
				
			End if 
			
			Case of 
					
					  //———————————————————————————————————————
				: ($event.objectName="unstaged")
					
					If ($cTarget.length>0)
						
						$menu.append("Stage";"stage").shortcut("S";512)\
							.append("Discard Changes…";"discard")\
							.line()
=======
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
>>>>>>> gitlab
						
					End if 
					
					$menu.append("Stage All";"stageAll").shortcut("S";512+2048)
					
<<<<<<< HEAD
					  //———————————————————————————————————————
				: ($event.objectName="staged")
					
					If ($cTarget.length>0)
						
						$menu.append("Unstage";"unstage").shortcut("S";512)\
							.line()
						
					End if 
					
					$menu.append("Unstage All";"unStageAll").shortcut("S";512+2048)
					
					  //———————————————————————————————————————
				Else 
					
					  // A "Case of" statement should never omit "Else"
					  //———————————————————————————————————————
=======
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
>>>>>>> gitlab
			End case 
			
			If ($menu.popup().selected)
				
<<<<<<< HEAD
				Case of 
						
						  //———————————————————————————————————————
					: ($menu.choice="show")
						
						SHOW ON DISK:C922(File:C1566(Form:C1466.project.parent.parent.path+$oTarget.path).platformPath)
						
						  //———————————————————————————————————————
					: ($menu.choice="stage")
						
						Form:C1466.ƒ.stage()
						
						  //———————————————————————————————————————
					: ($menu.choice="stageAll")
						
						Form:C1466.ƒ.stageAll()
						
						  //———————————————————————————————————————
					: ($menu.choice="unstage")
						
						Form:C1466.ƒ.unstage()
						
						  //———————————————————————————————————————
					: ($menu.choice="discard")
						
						Form:C1466.ƒ.discard()
						
						  //———————————————————————————————————————
					: ($menu.choice="open")
						
						$v:=resolvePath ($oTarget.path)
=======
				
				
				Case of 
						
						  //______________________________________________________
					: ($menu.choice="stage")
						
						STAGE 
						
						  //______________________________________________________
					: ($menu.choice="open")
						
						$v:=convertPath ($oTarget.path)
>>>>>>> gitlab
						
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
						
<<<<<<< HEAD
						  //———————————————————————————————————————
=======
						  //______________________________________________________
>>>>>>> gitlab
					: ($menu.choice="diffTool")
						
						Form:C1466.git.diffTool($oTarget.path)
						
<<<<<<< HEAD
						  //———————————————————————————————————————
					Else 
						
						ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are going tout doux ;-)")
						
						  //———————————————————————————————————————
=======
						  //______________________________________________________
					Else 
						
						ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are goint tout doux ;-)")
						
						  //______________________________________________________
>>>>>>> gitlab
				End case 
			End if 
			
		Else 
			
<<<<<<< HEAD
			Form:C1466.ƒ.refresh()
=======
			Form:C1466.refresh()
>>>>>>> gitlab
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Double Clicked:K2:5)  // Stage
		
		Case of 
				
<<<<<<< HEAD
				  //———————————————————————————————————————
			: ($event.objectName="unstaged")
				
				Form:C1466.ƒ.stage()
				
				  //———————————————————————————————————————
			: ($event.objectName="staged")
				
				Form:C1466.ƒ.unstage()
				
				  //———————————————————————————————————————
			Else 
				
				ALERT:C41("We are going tout doux ;-)")
				
				  //———————————————————————————————————————
		End case 
		
		  //______________________________________________________
	: ($event.code=On Selection Change:K2:29)
		
		Form:C1466.ƒ.refresh()
=======
				  //______________________________________________________
			: ($event.objectName="unstaged")
				
				STAGE 
				
			Else 
				
				ALERT:C41("We are goint tout doux ;-)")
				
		End case 
		
		
		  //______________________________________________________
	: ($event.code=On Selection Change:K2:29)
		
		Form:C1466.refresh()
>>>>>>> gitlab
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
<<<<<<< HEAD
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End
=======
End case 
>>>>>>> gitlab
