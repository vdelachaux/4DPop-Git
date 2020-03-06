//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : UPDATE
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

ASSERT:C1129(Not:C34(Shift down:C543))

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
			: ($oTarget.current.status="@D@")
				
				$t:="deleted"
				ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
					Attribute text color:K65:7;"red")
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
			: ($oTarget.current.status="??")
				
				$v:=resolvePath ($oTarget.current.path)
				
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
						
						METHOD GET CODE:C1190($v;$tBuffer;*)
						
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
				
				If ($oTarget.name="staged")
					
					$o.diff($oTarget.current.path;"--cached")
					
				Else 
					
					$o.diff($oTarget.current.path)
					
				End if 
				
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
											$tColor:="gray"
											
											  //…………………………………………………………………………………………………
										: ($tBuffer[[1]]="\\")
											
											$tBuffer:=Delete string:C232($tBuffer;1;1)
											$tColor:="gray"
											
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