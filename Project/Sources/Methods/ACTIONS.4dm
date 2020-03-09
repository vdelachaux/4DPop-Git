//%attributes = {"invisible":true}
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

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			$menu:=menu 
			
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
			
			If ($oTarget#Null:C1517)
				
				Case of 
						
						  //———————————————————————————————————————
					: ($event.objectName="unstaged")
						
						$menu.append("Stage";"stage").shortcut("S";512)
						$menu.append("Discard Changes…";"discard")
						
						  //———————————————————————————————————————
					: ($event.objectName="staged")
						
						$menu.append("Unstage";"unstage").shortcut("S";512)
						
						  //———————————————————————————————————————
				End case 
				
				$menu.line()
				
			End if 
			
			  //If ($cTarget.length>0)
			
			Case of 
					
					  //———————————————————————————————————————
				: ($event.objectName="unstaged")
					
					$menu.append("Stage All";"stageAll").shortcut("S";512+2048)
					
					  //———————————————————————————————————————
				: ($event.objectName="staged")
					
					$menu.append("Unstage All";"unStageAll").shortcut("S";512+2048)
					
					  //———————————————————————————————————————
			End case 
			
			  //End if 
			
			If ($menu.popup().selected)
				
				Case of 
						
						  //———————————————————————————————————————
					: ($menu.choice="diffTool")
						
						Form:C1466.git.diffTool($oTarget.path)
						
						  //———————————————————————————————————————
					: ($menu.choice="discard")
						
						Form:C1466.ƒ.discard()
						
						  //———————————————————————————————————————
					: ($menu.choice="open")
						
						$v:=resolvePath ($oTarget.path)
						
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
						End case 
						
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
					Else 
						
						ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are goint tout doux ;-)")
						
						  //———————————————————————————————————————
				End case 
			End if 
			
			
		Else 
			
			Form:C1466.ƒ.refresh()
			
		End if 
		
		  //______________________________________________________
	: ($event.code=On Selection Change:K2:29)
		
		Form:C1466.ƒ.refresh()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //________________________________________
End case 