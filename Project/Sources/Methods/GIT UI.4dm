//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GIT UI
  // ID[9BABF27ABE474385B2C7B3CAC62A6343]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($t;$tBuffer)
C_OBJECT:C1216($ƒ;$o;$oTarget)
C_VARIANT:C1683($v)

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

$oTarget:=New object:C1471(\
"name";OBJECT Get name:C1087(Object with focus:K67:3))

$ƒ:=Form:C1466.ƒ

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: (FORM Get current page:C276=1)
		
		Case of 
				
				  //______________________________________________________
			: (Form:C1466.currentStaged=Null:C1517)\
				 & (Form:C1466.currentUnstaged=Null:C1517)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: ($oTarget.name="unstaged")
				
				Form:C1466.$.toComit.deselect()
				Form:C1466.$.unstage.disable()
				
				If (Form:C1466.currentUnstaged#Null:C1517)
					
					$oTarget.selected:=Form:C1466.selectedUnstaged
					$oTarget.current:=Form:C1466.currentUnstaged
					$oTarget.button:=Form:C1466.$.stage
					
				End if 
				
				  //______________________________________________________
			: ($oTarget.name="staged")
				
				Form:C1466.$.toStage.deselect()
				Form:C1466.$.stage.disable()
				
				If (Form:C1466.currentStaged#Null:C1517)
					
					$oTarget.selected:=Form:C1466.selectedStaged
					$oTarget.current:=Form:C1466.currentStaged
					$oTarget.button:=Form:C1466.$.unstage
					
				End if 
				
				  //______________________________________________________
		End case 
		
		If ($oTarget.button#Null:C1517)
			
			If ($oTarget.selected.length>0)
				
				Case of 
						
						  //––––––––––––––––––––––––––––––––––––––––––––––––
					: ($oTarget.current.status="??")\
						 | ($oTarget.current.status="A@")
						
						$v:=Form:C1466.ƒ.path($oTarget.current.path)
						
						Case of 
								
								  //______________________________________________________
							: (Value type:C1509($v)=Is object:K8:27)  // File
								
								If (Bool:C1537($v.exists))
									
									Case of 
											
											  //————————————————————————————————————
										: ($v.extension=".svg")  // Treat svg as text file
											
											$tBuffer:=$v.getText()
											
											  //————————————————————————————————————
										: (Is picture file:C1113($v.platformPath))
											
											  //#TO_DO
											
											  //————————————————————————————————————
										Else 
											
											$tBuffer:=$v.getText()
											
											  //————————————————————————————————————
									End case 
								End if 
								
								  //______________________________________________________
							: (Value type:C1509($v)=Is text:K8:3)  // Method
								
								If ($v="[ProjectForm]@")
									
									METHOD GET CODE:C1190($v;$tBuffer;*)
									
								Else 
									
									ARRAY TEXT:C222($aMethods;0x0000)
									METHOD GET PATHS:C1163(Path all objects:K72:16;$aMethods;*)
									
									If (Find in array:C230($aMethods;$v)>0)
										
										METHOD GET CODE:C1190($v;$tBuffer;*)
										
									End if 
								End if 
								
								  //______________________________________________________
							Else 
								
								  //
								
								  //______________________________________________________
						End case 
						
						If (Length:C16($tBuffer)>0)
							
							$tBuffer:=Replace string:C233($tBuffer;"<";"&lt;")
							$tBuffer:=Replace string:C233($tBuffer;">";"&gt;")
							
							ST SET TEXT:C1115($t;$tBuffer;ST Start text:K78:15;ST End text:K78:16)
							ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
								Attribute text color:K65:7;"green")
							
						End if 
						
						  //––––––––––––––––––––––––––––––––––––––––––––––––
					Else 
						
						$o:=Form:C1466.git
						
						Case of 
								
								  //______________________________________________________
							: ($oTarget.current.status="@D@")
								
								$o.execute("diff HEAD^ -- "+$oTarget.current.path)
								
								  //______________________________________________________
							: ($oTarget.name="staged")
								
								$o.diff($oTarget.current.path;"--cached")
								
								  //______________________________________________________
							Else 
								
								$o.diff($oTarget.current.path)
								
								  //______________________________________________________
						End case 
						
						$t:=GIT Diff ($oTarget.current.status)
						
						  //––––––––––––––––––––––––––––––––––––––––––––––––
				End case 
				
				$oTarget.button.enable()
				Form:C1466.diff:=$t
				
			Else 
				
				$oTarget.button.disable()
				Form:C1466.diff:=""
				
			End if 
			
		Else 
			
			Form:C1466.diff:=""
			Form:C1466.$.stage.disable()
			Form:C1466.$.unstage.disable()
			
		End if 
		
		Form:C1466.$.diff.setVisible(Length:C16(String:C10(Form:C1466.diff))>0)
		
		  //______________________________________________________
	: (FORM Get current page:C276=2)
		
		If (Form:C1466.commitFilesSelected#Null:C1517)
			
			If (Form:C1466.commitFilesSelected.length>0)
				
				OBJECT SET VISIBLE:C603(*;"diff1";True:C214)
				
				$o:=Form:C1466.commitFilesCurrent
				
				If ($o.status="A")
					
					Form:C1466.git.execute("diff "+Form:C1466.commitsCurrent.fingerprint.short+"^ -- "+$o.path)
					
				Else 
					
					Form:C1466.git.execute("diff "+Form:C1466.commitsCurrent.parent.short+" "+Form:C1466.commitsCurrent.fingerprint.short+" -- "+$o.path)
					
				End if 
				
				Form:C1466.diff:=GIT Diff ($o.status)
				
			Else 
				
				OBJECT SET VISIBLE:C603(*;"diff1";False:C215)
				Form:C1466.diff:=""
				
			End if 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;"diff1";False:C215)
			Form:C1466.diff:=""
			
		End if 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End