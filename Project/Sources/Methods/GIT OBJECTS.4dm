//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : GIT OBJECTS
// ID[BBFA94B40A9249EBA8EF811FE6BF0D3E]
// Created 9-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
var $t : Text
var $indx : Integer
var $v
var $current; $e; $ƒ; $menu : Object
var $selected : Collection
var $file; $o : 4D:C1709.File
var $git : cs:C1710.Git

$e:=FORM Event:C1606
$ƒ:=Form:C1466.$
$git:=Form:C1466.git

Case of 
		
		//______________________________________________________
	: ($e.objectName=$ƒ.toStage.name)\
		 | ($e.objectName=$ƒ.toComit.name)
		
		$current:=Choose:C955($e.objectName="staged"; Form:C1466.currentStaged; Form:C1466.currentUnstaged)
		$selected:=Choose:C955($e.objectName="staged"; Form:C1466.selectedStaged; Form:C1466.selectedUnstaged)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Double Clicked:K2:5)
				
				If ($selected.length=1)
					
					Case of 
							
							//———————————————————————————————————————
						: ($e.objectName="unstaged")
							
							Form:C1466.ƒ.stage()
							
							//———————————————————————————————————————
						: ($e.objectName="staged")
							
							Form:C1466.ƒ.unstage()
							
							//———————————————————————————————————————
					End case 
				End if 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				If (Contextual click:C713)
					
					$menu:=menu
					
					If ($selected.length=1)
						
						$menu.append("Open"; "open")
						
						If (New collection:C1472("??"; " D"; "A ").indexOf($current.status)=-1)
							
							$menu.append("externalDiff"; "diffTool").shortcut("D")
							
						End if 
						
						$menu.line()
						
						If (New collection:C1472(" D").indexOf($current.status)=-1)
							
							$menu.append("showInFinder"; "show")
							$menu.append("deleteLocalFile"; "delete")
							
						End if 
						
						$menu.append("copyPath"; "copy")
						
						$menu.line()
						
					End if 
					
					If ($current#Null:C1517)
						
						Case of 
								
								//———————————————————————————————————————
							: ($e.objectName="unstaged")
								
								$menu.append("stage"; "stage").shortcut("S"; 512)
								$menu.append("discardChanges"; "discard")
								
								//———————————————————————————————————————
							: ($e.objectName="staged")
								
								$menu.append("unstage"; "unstage").shortcut("S"; 512)
								
								//———————————————————————————————————————
						End case 
						
						$menu.line()
						
					End if 
					
					Case of 
							
							//———————————————————————————————————————
						: ($e.objectName="unstaged")\
							 & (Form:C1466.unstaged.length>0)
							
							$menu.append("stageAll"; "stageAll").shortcut("S"; 512+2048)
							
							//———————————————————————————————————————
						: ($e.objectName="staged")\
							 & (Form:C1466.staged.length>0)
							
							$menu.append("unstageAll"; "unStageAll").shortcut("S"; 512+2048)
							
							//———————————————————————————————————————
					End case 
					
					If ($current#Null:C1517)
						
						$o:=File:C1566($current.path)
						
						$menu.line()\
							.append("ignore"; menu\
							.append(Replace string:C233(Get localized string:C991("ignoreFile"); "{file}"; $o.fullName); "ignoreFile")\
							.append(Replace string:C233(Get localized string:C991("ignoreAllExtensionFiles"); "{extension}"; $o.extension); "ignoreExtension")\
							.line()\
							.append("customPattern"; "ignoreCustom"))
						
					End if 
					
					If ($menu.popup().selected)
						
						Case of 
								
								//———————————————————————————————————————
							: ($menu.choice="copy")
								
								SET TEXT TO PASTEBOARD:C523($current.path)
								
								//———————————————————————————————————————
							: ($menu.choice="diffTool")
								
								$git.diffTool($current.path)
								
								//———————————————————————————————————————
							: ($menu.choice="discard")
								
								Form:C1466.ƒ.discard()
								
								//———————————————————————————————————————
							: ($menu.choice="delete")
								
								$o:=File:C1566(Convert path POSIX to system:C1107($current.path); fk platform path:K87:2)
								CONFIRM:C162(Replace string:C233(Get localized string:C991("areYouSureYouWantToDeleteTheFile"); "{name}"; $o.fullName))
								
								If (Bool:C1537(OK))
									
									File:C1566(Form:C1466.project.parent.parent.path+$current.path).delete()
									
									RELOAD PROJECT:C1739
									
									$git.status()
									
									Form:C1466.ƒ.refresh()
									Form:C1466.ƒ.updateUI()
									
								End if 
								
								//———————————————————————————————————————
							: ($menu.choice="open")
								
								$v:=Form:C1466.ƒ.path($current.path)
								
								Case of 
										
										//——————————————————————————————————
									: (Value type:C1509($v)=Is text:K8:3)  // Method
										
										METHOD OPEN PATH:C1213($v; *)
										
										//——————————————————————————————————
									: (Value type:C1509($v)=Is object:K8:27)  // File
										
										If (Bool:C1537($v.exists))
											
											If ($v.extension=".4dform")
												
												FORM EDIT:C1749(String:C10($v.parent.fullName))
												
											Else 
												
												OPEN URL:C673($v.platformPath)
												
											End if 
										End if 
										
										//——————————————————————————————————
								End case 
								
								//———————————————————————————————————————
							: ($menu.choice="show")
								
								SHOW ON DISK:C922(File:C1566(Form:C1466.project.parent.parent.path+$current.path).platformPath)
								
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
								
								$o:=File:C1566($current.path)
								
								$file:=$git.workingDirectory.file(".gitignore")
								$t:=$file.getText("UTF-8"; Document with CR:K24:21)
								
								Case of 
										
										//____________________________
									: ($menu.choice="ignoreFile")
										
										If ($current.status#"??")
											
											$git.untrack($current.path)
											
										End if 
										
										$t+="\r"+$current.path
										
										//____________________________
									: ($menu.choice="ignoreExtension")
										
										// #TO_DO: Must unstack all indexed files with this extension
										
										$t+="\r*"+$o.extension
										
										//____________________________
									: ($menu.choice="ignoreCustom")
										
										$o:=New object:C1471(\
											"window"; Open form window:C675("GIT PATTERN"; \
											Plain form window:K39:10; Horizontally centered:K39:1; \
											Vertically centered:K39:4; *); \
											"pattern"; $current.path; \
											"files"; $git.changes)
										
										DIALOG:C40("GIT PATTERN"; $o)
										CLOSE WINDOW:C154
										
										If (Bool:C1537(OK))
											
											$t+="\r"+$o.pattern
											
										End if 
										
										//____________________________
									Else 
										
										ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are going tout doux ;-)")
										
										//____________________________
								End case 
								
								$file.setText($t; "UTF-8"; Document with LF:K24:22)
								
								$git.status()
								Form:C1466.ƒ.refresh()
								Form:C1466.ƒ.updateUI()
								
								//———————————————————————————————————————
							Else 
								
								ALERT:C41("Unmanaged tool: \""+$menu.choice+"\"…\r\rWe are going tout doux ;-)")
								
								//———————————————————————————————————————
						End case 
					End if 
					
				Else 
					
					Form:C1466.ƒ.updateUI()
					
				End if 
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)
				
				Form:C1466.ƒ.updateUI()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: ($e.objectName=$ƒ.open.name)
		
		$menu:=menu\
			.append("openInTerminal"; "terminal").icon("/RESOURCES/Images/"+Form:C1466.template+"terminal.png")\
			.append("openInFinder"; "show").icon("/RESOURCES/Images/"+Form:C1466.template+"show.png")\
			.line()\
			.append("viewOnGithub"; "github").icon("/RESOURCES/Images/"+Form:C1466.template+"gitHub.png")
		
		$git.execute("config --get remote.origin.url")
		
		If (Not:C34($git.execute("config --get remote.origin.url")))
			
			$menu.disable()
			
		End if 
		
		If ($menu.popup().selected)
			
			Case of 
					
					//———————————————————————————————————————
				: ($menu.choice="terminal")
					
					$git.open($menu.choice)
					
					//———————————————————————————————————————
				: ($menu.choice="show")
					
					$git.open($menu.choice)
					
					//———————————————————————————————————————
				: ($menu.choice="github")
					
					$t:=Replace string:C233($git.result; "\n"; "")
					OPEN URL:C673($t)
					
					//———————————————————————————————————————
				Else 
					
					// A "Case of" statement should never omit "Else"
					//———————————————————————————————————————
			End case 
		End if 
		
		//______________________________________________________
	: ($e.objectName=$ƒ.stage.name)
		
		Form:C1466.ƒ.stage()
		
		//______________________________________________________
	: ($e.objectName=$ƒ.stageAll.name)
		
		Form:C1466.ƒ.stageAll()
		
		//______________________________________________________
	: ($e.objectName=$ƒ.unstage.name)
		
		Form:C1466.ƒ.unstage()
		
		//______________________________________________________
	: ($e.objectName=$ƒ.subject.name)
		
		$ƒ.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Get edited text:C655)))
		
		//______________________________________________________
	: ($e.objectName=$ƒ.amend.name)
		
		$ƒ.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
		
		//______________________________________________________
	: ($e.objectName=$ƒ.commit.name)
		
		Form:C1466.ƒ.commit()
		
		//______________________________________________________
	: ($e.objectName=$ƒ.diffTool.name)
		
		Case of 
				
				//————————————————————————————————
			: (Form:C1466.selectedUnstaged.length=1)
				
				$git.diffTool(Form:C1466.currentUnstaged.path)
				
				//————————————————————————————————
			: (Form:C1466.selectedStaged.length=1)
				
				$git.diffTool(Form:C1466.selectedStaged.path)
				
				//————————————————————————————————
		End case 
		
		//______________________________________________________
	: ($e.objectName=$ƒ.fetch.name)
		
		GIT("fetch")
		
		//______________________________________________________
	: ($e.objectName=$ƒ.pull.name)
		
		GIT("pull")
		
		//______________________________________________________
	: ($e.objectName=$ƒ.push.name)
		
		GIT("push")
		
		//______________________________________________________
	: ($e.objectName=$ƒ.menu.name)
		
		FORM GOTO PAGE:C247(1)
		
		//______________________________________________________
	: ($e.objectName="selector")
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Double Clicked:K2:5)
				
				GIT("switch")
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				$o:=$ƒ.selector.getParameter("data"; Null:C1517; Is object:K8:27)
				
				If ($o#Null:C1517)
					
					If (Contextual click:C713)
						
						//$menu:=menu
						
					Else 
						
						If (FORM Get current page:C276=2)
							
							$ƒ.commits.deselect()
							
							$indx:=Form:C1466.commits.extract("fingerprint.ref").indexOf(String:C10($o.ref))
							
							If ($indx#-1)
								
								$ƒ.commits.reveal($indx+1)
								$ƒ.commits.focus()
								
							End if 
							
						Else 
							
							FORM GOTO PAGE:C247(2)
							
						End if 
					End if 
				End if 
				
				//----------------------------------------
		End case 
		
		//______________________________________________________
	: ($e.objectName=$ƒ.commits.name)
		
		GIT DISPLAY COMMIT
		
		//______________________________________________________
	: ($e.objectName=$ƒ.detailCommit.name)
		
		Form:C1466.ƒ.updateUI()
		
		//______________________________________________________
	: ($e.objectName="detail_parent")
		
		$indx:=Form:C1466.commits.extract("fingerprint.short").indexOf(String:C10(Form:C1466.commitsCurrent.parent.short))
		
		If ($indx#-1)
			
			$ƒ.commits.reveal($indx+1)
			$ƒ.commits.focus()
			
		End if 
		
		//______________________________________________________
	Else 
		
		TRACE:C157  // A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 