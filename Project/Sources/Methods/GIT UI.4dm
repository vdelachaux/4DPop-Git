//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : GIT UI
// ID[9BABF27ABE474385B2C7B3CAC62A6343]
// Created 6-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
var $code; $t : Text
var $v
var $ƒ; $o; $target : Object

$target:=New object:C1471(\
"name"; OBJECT Get name:C1087(Object with focus:K67:3))

$ƒ:=Form:C1466.ƒ

Case of 
		
		//______________________________________________________
	: (FORM Get current page:C276=1)
		
		Case of 
				
				//______________________________________________________
			: (Form:C1466.currentStaged=Null:C1517)\
				 & (Form:C1466.currentUnstaged=Null:C1517)
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($target.name="unstaged")
				
				Form:C1466.$.toComit.deselect()
				Form:C1466.$.unstage.disable()
				
				If (Form:C1466.currentUnstaged#Null:C1517)
					
					$target.selected:=Form:C1466.selectedUnstaged
					$target.current:=Form:C1466.currentUnstaged
					$target.button:=Form:C1466.$.stage
					
				End if 
				
				//______________________________________________________
			: ($target.name="staged")
				
				Form:C1466.$.toStage.deselect()
				Form:C1466.$.stage.disable()
				
				If (Form:C1466.currentStaged#Null:C1517)
					
					$target.selected:=Form:C1466.selectedStaged
					$target.current:=Form:C1466.currentStaged
					$target.button:=Form:C1466.$.unstage
					
				End if 
				
				//______________________________________________________
		End case 
		
		If ($target.button#Null:C1517)
			
			If ($target.selected.length>0)
				
				Case of 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––
					: ($target.current.status="??")\
						 | ($target.current.status="A@")
						
						$v:=Form:C1466.ƒ.path($target.current.path)
						
						Case of 
								
								//______________________________________________________
							: (Value type:C1509($v)=Is object:K8:27)  // File
								
								If (Bool:C1537($v.exists))
									
									Case of 
											
											//————————————————————————————————————
										: ($v.extension=".svg")  // Treat svg as text file
											
											$code:=$v.getText()
											
											//————————————————————————————————————
										: (Is picture file:C1113($v.platformPath))
											
											// #TO_DO
											
											//————————————————————————————————————
										Else 
											
											$code:=$v.getText()
											
											//————————————————————————————————————
									End case 
								End if 
								
								//______________________________________________________
							: (Value type:C1509($v)=Is text:K8:3)  // Method
								
								If ($v="[ProjectForm]@")
									
									METHOD GET CODE:C1190($v; $code; *)
									
								Else 
									
									ARRAY TEXT:C222($aMethods; 0x0000)
									METHOD GET PATHS:C1163(Path all objects:K72:16; $aMethods; *)
									
									If (Find in array:C230($aMethods; $v)>0)
										
										METHOD GET CODE:C1190($v; $code; *)
										
									End if 
								End if 
								
								//______________________________________________________
							Else 
								
								//
								
								//______________________________________________________
						End case 
						
						If (Length:C16($code)>0)
							
							$code:=Replace string:C233($code; "<"; "&lt;")
							$code:=Replace string:C233($code; ">"; "&gt;")
							
							ST SET TEXT:C1115($t; $code; ST Start text:K78:15; ST End text:K78:16)
							ST SET ATTRIBUTES:C1093($t; ST Start text:K78:15; ST End text:K78:16; \
								Attribute text color:K65:7; "green")
							
						End if 
						
						//––––––––––––––––––––––––––––––––––––––––––––––––
					Else 
						
						$o:=Form:C1466.git
						
						Case of 
								
								//______________________________________________________
							: ($target.current.status="@D@")
								
								$o.execute("diff HEAD^ -- "+$target.current.path)
								
								//______________________________________________________
							: ($target.name="staged")
								
								$o.diff($target.current.path; "--cached")
								
								//______________________________________________________
							Else 
								
								$o.diff($target.current.path)
								
								//______________________________________________________
						End case 
						
						$t:=GIT Diff($target.current.status)
						
						//––––––––––––––––––––––––––––––––––––––––––––––––
				End case 
				
				$target.button.enable()
				Form:C1466.diff:=$t
				
			Else 
				
				$target.button.disable()
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
		
		Form:C1466.diff:=""
		OBJECT SET VISIBLE:C603(*; "diff1"; False:C215)
		
		If (Form:C1466.commitFilesSelected#Null:C1517)
			
			If (Form:C1466.commitFilesSelected.length>0)
				
				OBJECT SET VISIBLE:C603(*; "diff1"; True:C214)
				
				$o:=Form:C1466.commitFilesCurrent
				
				Case of 
						
						//______________________________________________________
					: (Length:C16(String:C10(Form:C1466.commitsCurrent.parent.short))=0)
						
						Form:C1466.git.execute("diff "+Form:C1466.commitsCurrent.fingerprint.short+" -- '"+$o.path+"'")
						
						//______________________________________________________
					: ($o.status="A")
						
						Form:C1466.git.execute("diff "+Form:C1466.commitsCurrent.fingerprint.short+"^ -- '"+$o.path+"'")
						
						//______________________________________________________
					Else 
						
						Form:C1466.git.execute("diff "+Form:C1466.commitsCurrent.parent.short+" "+Form:C1466.commitsCurrent.fingerprint.short+" -- '"+$o.path+"'")
						
						//______________________________________________________
				End case 
				
				Form:C1466.diff:=GIT Diff($o.status)
				
			End if 
		End if 
		
		//______________________________________________________
End case 