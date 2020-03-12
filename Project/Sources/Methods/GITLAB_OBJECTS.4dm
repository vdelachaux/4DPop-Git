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
C_TEXT:C284($t)
C_OBJECT:C1216($event;$file;$menu;$o;$oCurrent)
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
							
							$menu.append("externalDiff";"diffTool").shortcut("D")
							
						End if 
						
						$menu.line()
						
						If (New collection:C1472(" D").indexOf($oCurrent.status)=-1)
							
							$menu.append("showInFinder";"show")
							
						End if 
						
						$menu.append("copyPath";"copy")
						
						$menu.line()
						
					End if 
					
					If ($oCurrent#Null:C1517)
						
						Case of 
								
								  //———————————————————————————————————————
							: ($event.objectName="unstaged")
								
								$menu.append("stage";"stage").shortcut("S";512)
								$menu.append("discardChanges";"discard")
								
								  //———————————————————————————————————————
							: ($event.objectName="staged")
								
								$menu.append("unstage";"unstage").shortcut("S";512)
								
								  //———————————————————————————————————————
						End case 
						
						$menu.line()
						
					End if 
					
					Case of 
							
							  //———————————————————————————————————————
						: ($event.objectName="unstaged")\
							 & (Form:C1466.unstaged.length>0)
							
							$menu.append("stageAll";"stageAll").shortcut("S";512+2048)
							
							  //———————————————————————————————————————
						: ($event.objectName="staged")\
							 & (Form:C1466.staged.length>0)
							
							$menu.append("unstageAll";"unStageAll").shortcut("S";512+2048)
							
							  //———————————————————————————————————————
					End case 
					
					If ($oCurrent#Null:C1517)
						
						$o:=File:C1566($oCurrent.path)
						
						$menu.line()\
							.append("ignore";menu \
							.append(Replace string:C233(Get localized string:C991("ignoreFile");"{file}";$o.fullName);"ignoreFile")\
							.append(Replace string:C233(Get localized string:C991("ignoreAllExtensionFiles");"{extension}";$o.extension);"ignoreExtension")\
							.line()\
							.append("customPattern";"ignoreCustom"))
						
					End if 
					
					If ($menu.popup().selected)
						
						Case of 
								
								  //———————————————————————————————————————
							: ($menu.choice="copy")
								
								SET TEXT TO PASTEBOARD:C523($oCurrent.path)
								
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
										
										METHOD OPEN PATH:C1213($v;*)
										
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
							: ($menu.choice="ignore@")
								
								$o:=File:C1566($oCurrent.path)
								
								$file:=Form:C1466.git.workingDirectory.file(".gitignore")
								$t:=$file.getText("UTF-8";Document with CR:K24:21)
								
								Case of 
										  //____________________________
									: ($menu.choice="ignoreFile")
										
										If ($oCurrent.status#"??")
											
											Form:C1466.git.untrack($oCurrent.path)
											
										End if 
										
										$t:=$t+"\r"+$oCurrent.path
										
										  //____________________________
									: ($menu.choice="ignoreExtension")
										
										  // #TO_DO: Must unstack all indexed files with this extension
										
										$t:=$t+"\r*"+$o.extension
										
										  //____________________________
									: ($menu.choice="ignoreCustom")
										
										$o:=New object:C1471(\
											"window";Open form window:C675("ADD_PATTERN";\
											Plain form window:K39:10;Horizontally centered:K39:1;\
											Vertically centered:K39:4;*);\
											"pattern";$oCurrent.path;\
											"files";Form:C1466.git.changes)
										
										DIALOG:C40("ADD_PATTERN";$o)
										CLOSE WINDOW:C154
										
										If (Bool:C1537(OK))
											
											$t:=$t+"\r"+$o.pattern
											
										End if 
										
										  //____________________________
									Else 
										
										ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are going tout doux ;-)")
										
										  //____________________________
								End case 
								
								$file.setText($t;"UTF-8";Document with CRLF:K24:20)
								
								Form:C1466.git.status()
								Form:C1466.ƒ.update()
								Form:C1466.ƒ.refresh()
								
								  //———————————————————————————————————————
							Else 
								
								ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are going tout doux ;-)")
								
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
				
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($event.objectName=Form:C1466.$.open.name)
		
		$menu:=menu \
			.append("openInTerminal";"terminal").icon("/RESOURCES/Images/terminal.png")\
			.append("openInFinder";"show").icon("/RESOURCES/Images/finder.png")\
			.line()\
			.append("viewOnGithub";"github").icon("/RESOURCES/Images/gitHub.png").disable()
		
		If ($menu.popup().selected)
			
			Case of 
					
					  //———————————————————————————————————————
				: ($menu.choice="terminal")
					
					Form:C1466.git.terminal()
					
					  //———————————————————————————————————————
				: ($menu.choice="show")
					
					Form:C1466.git.show()
					
					  //———————————————————————————————————————
				Else 
					
					  // A "Case of" statement should never omit "Else"
					
					  //———————————————————————————————————————
			End case 
		End if 
		
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
	: ($event.objectName="selector")
		
		
		
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