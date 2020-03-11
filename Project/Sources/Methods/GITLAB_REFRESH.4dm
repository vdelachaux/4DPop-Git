//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GITLAB_REFRESH
  // ID[9BABF27ABE474385B2C7B3CAC62A6343]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$length;$pos)
C_TEXT:C284($t;$tBuffer;$tColor)
C_OBJECT:C1216($ƒ;$o;$oTarget)
C_COLLECTION:C1488($c)
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
			: ($oTarget.current.status="??")
				
				$v:=Form:C1466.ƒ.path($oTarget.current.path)
				
				Case of 
						
						  //______________________________________________________
					: (Value type:C1509($v)=Is object:K8:27)  // File
						
						If (Bool:C1537($v.exists))
							
							If (Is picture file:C1113($v.platformPath))
								
								  //#TO_DO
								
							Else 
								
								$tBuffer:=$v.getText()
								
							End if 
						End if 
						
						  //______________________________________________________
					: (Value type:C1509($v)=Is text:K8:3)  // Method
						
						ARRAY TEXT:C222($aMethods;0x0000)
						METHOD GET PATHS:C1163(Path all objects:K72:16;$aMethods;*)
						
						If (Find in array:C230($aMethods;$v)>0)
							
							METHOD GET CODE:C1190($v;$tBuffer;*)
							
						End if 
						
						  //______________________________________________________
					Else 
						
						  //
						
						  //______________________________________________________
				End case 
				
				If (Length:C16($tBuffer)>0)
					
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
						
						  //$o.diff($oTarget.current.path;"diff HEAD^ -- ")
						
						  //______________________________________________________
					: ($oTarget.name="staged")
						
						$o.diff($oTarget.current.path;"--cached")
						
						  //______________________________________________________
					Else 
						
						$o.diff($oTarget.current.path)
						
						  //______________________________________________________
				End case 
				
				If ($o.success)
					
					If (Length:C16($o.result)>0)
						
						$c:=Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1)
						
						  // Delete the initial lines
						$b:=True:C214
						
						While ($c.length>0) & $b
							
							$b:=(Position:C15("@";String:C10($c[0]))#1)
							
							If ($b)
								
								$c.remove(0;1)
								
							End if 
						End while 
						
						If ($c.length>0)
							
							$l:=0
							
							For each ($tBuffer;$c)
								
								If (Length:C16($tBuffer)>0)
									
									$tColor:="gray"
									
									Case of 
											
											  //…………………………………………………………………………………………………
										: ($tBuffer[[1]]="-")
											
											$tColor:="red"
											
											  //…………………………………………………………………………………………………
										: ($tBuffer[[1]]="+")
											
											$tColor:="green"
											
											  //…………………………………………………………………………………………………
										: (Character code:C91($tBuffer[[1]])=Character code:C91("@"))
											
											$tBuffer:="\n"+$tBuffer
											
											  //…………………………………………………………………………………………………
										: ($tBuffer[[1]]="\\")
											
											$tBuffer:=Delete string:C232($tBuffer;1;1)
											
											  //…………………………………………………………………………………………………
									End case 
									
									ST SET TEXT:C1115($t;$tBuffer;ST Start text:K78:15;ST End text:K78:16)
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;$tColor)
									
								End if 
								
								$c[$l]:=$t
								$l:=$l+1
								
							End for each 
							
							$t:=$c.join("\n")
							
							$t:=Replace string:C233($t;"<br/>";"")
							
							  // Separate blocks
							$l:=1
							
							While (Match regex:C1019("(?mi-s)^(<[^>]*>@@[^$]*)$";$t;$l;$pos;$length))
								
								If ($pos>1)
									
									$t:=Substring:C12($t;1;$pos-1)+"\n"+Substring:C12($t;$pos)
									
								End if 
								
								$l:=$l+$length
								
							End while 
							
							  // Remove unnecessary line breaks
							
							While (Position:C15("\n\n";$t)>0)
								
								$t:=Replace string:C233($t;"\n\n";"\n")
								
							End while 
							
							If (Position:C15("\n";$t)=1)
								
								$t:=Delete string:C232($t;1;1)
								
							End if 
						End if 
					End if 
					
				Else 
					
					ST SET TEXT:C1115($t;String:C10($o.error);ST Start text:K78:15;ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
						Attribute text color:K65:7;"red")
					
				End if 
				
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

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End