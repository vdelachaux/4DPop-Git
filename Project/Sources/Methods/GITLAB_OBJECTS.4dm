//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GITLAB_OBJECTS
  // ID[BBFA94B40A9249EBA8EF811FE6BF0D3E]
  // Created 9-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($event;$menu;$oCurrent)
C_COLLECTION:C1488($cSelected)
C_VARIANT:C1683($v)

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.toStage.name)\
		 | ($event.objectName=Form:C1466.$.toComit.name)
		
		$oCurrent:=Choose:C955($event.objectName="staged";Form:C1466.currentStaged;Form:C1466.currentUnstaged)
		$cSelected:=Choose:C955($event.objectName="staged";Form:C1466.selectedStaged;Form:C1466.selectedUnstaged)
		
		Case of 
				
				  //______________________________________________________
			: ($event.code=On Double Clicked:K2:5)
				
				If ($cSelected.length=1)
					
					Case of 
							
							  //———————————————————————————————————————
						: ($event.objectName="unstaged")
							
							Form:C1466.ƒ.stage()
							
							  //———————————————————————————————————————
						: ($event.objectName="staged")
							
							Form:C1466.ƒ.unstage()
							
							  //———————————————————————————————————————
					End case 
					
				End if 
				
				  //______________________________________________________
			: ($event.code=On Clicked:K2:4)
				
				If (Contextual click:C713)
					
					$menu:=menu 
					
					If ($cSelected.length=1)
						
						$menu.append("Open";"open")
						
						If (New collection:C1472("??";" D";"A ").indexOf($oCurrent.status)=-1)
							
							$menu.append("External Diff";"diffTool").shortcut("D")
							
						End if 
						
						If (New collection:C1472(" D").indexOf($oCurrent.status)=-1)
							
							$menu.append("Show in Finder";"show")
							
						End if 
						
						$menu.line()
						
					End if 
					
					If ($oCurrent#Null:C1517)
						
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
					
					Case of 
							
							  //———————————————————————————————————————
						: ($event.objectName="unstaged")\
							 & (Form:C1466.unstaged.length>0)
							
							$menu.append("Stage All";"stageAll").shortcut("S";512+2048)
							
							  //———————————————————————————————————————
						: ($event.objectName="staged")\
							 & (Form:C1466.staged.length>0)
							
							$menu.append("Unstage All";"unStageAll").shortcut("S";512+2048)
							
							  //———————————————————————————————————————
					End case 
					
					If ($menu.popup().selected)
						
						Case of 
								
								  //———————————————————————————————————————
							: ($menu.choice="diffTool")
								
								Form:C1466.git.diffTool($oCurrent.path)
								
								  //———————————————————————————————————————
							: ($menu.choice="discard")
								
								Form:C1466.ƒ.discard()
								
								  //———————————————————————————————————————
							: ($menu.choice="open")
								
								$v:=Form:C1466.ƒ.path($oCurrent.path)
								
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
								
								SHOW ON DISK:C922(File:C1566(Form:C1466.project.parent.parent.path+$oCurrent.path).platformPath)
								
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
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.stage.name)
		
		Form:C1466.ƒ.stage()
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.stageAll.name)
		
		Form:C1466.ƒ.stageAll()
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.unstage.name)
		
		Form:C1466.ƒ.unstage()
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.subject.name)
		
		Form:C1466.$.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Get edited text:C655)))
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.amend.name)
		
		Form:C1466.$.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.commit.name)
		
		Form:C1466.ƒ.commit()
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.diffTool.name)
		
		If (Form:C1466.selectedUnstaged.length=1)
			
			Form:C1466.git.diffTool(Form:C1466.currentUnstaged.path)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End