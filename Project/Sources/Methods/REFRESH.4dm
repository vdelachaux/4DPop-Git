//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : REFRESH
  // ID[E7E96C5C8639422BA12B4632C5637E46]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$length;$pos)
C_TEXT:C284($t;$tBuffer)
C_OBJECT:C1216($o;$oButton;$oTarget)
C_COLLECTION:C1488($c)
C_VARIANT:C1683($v)

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

  // Optional parameters
If (Count parameters:C259>=1)
	
	  // <NONE>
	
End if 

$t:=OBJECT Get name:C1087(Object with focus:K67:3)

ASSERT:C1129(Not:C34(Shift down:C543))

  // ----------------------------------------------------
Case of 
		
		  //———————————————————————————————————
	: (Form:C1466.currentStaged=Null:C1517)\
		 & (Form:C1466.currentUnstaged=Null:C1517)
		
		  // <NOTHING MORE TO DO>
		
		  //———————————————————————————————————
	: ($t="unstaged")
		
		Form:C1466.$.toComit.deselect()
		Form:C1466.$.unstage.disable()
		
		If (Form:C1466.currentUnstaged#Null:C1517)
			
			$c:=Form:C1466.selectedUnstaged
			$oTarget:=Form:C1466.currentUnstaged
			$oButton:=Form:C1466.$.stage
			
		End if 
		
		  //———————————————————————————————————
	: ($t="staged")
		
		Form:C1466.$.toStage.deselect()
		Form:C1466.$.stage.disable()
		
		If (Form:C1466.currentStaged#Null:C1517)
			
			$c:=Form:C1466.selectedStaged
			$oTarget:=Form:C1466.currentStaged
			$oButton:=Form:C1466.$.unstage
			
		End if 
		
		  //———————————————————————————————————
End case 

If ($oButton#Null:C1517)
	
	If ($c.length>0)
		
		Case of 
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
			: (Position:C15("D";$oTarget.status)>0)
				
				ST SET TEXT:C1115($t;"deleted";ST Start text:K78:15;ST End text:K78:16)
				ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
					Attribute text color:K65:7;"red")
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
			: ($oTarget.status="??")
				
				$v:=resolvePath ($oTarget.path)
				
				Case of 
						
						  //———————————————————————————————————
					: (Value type:C1509($v)=Is object:K8:27)  // File
						
						If (Bool:C1537($v.exists))
							
							If (Is picture file:C1113($v.platformPath))
								
								  //#TO_DO
								
							Else 
								
								$tBuffer:=$v.getText()
								
							End if 
						End if 
						
						  //———————————————————————————————————
					: (Value type:C1509($v)=Is text:K8:3)  // Method
						
						METHOD GET CODE:C1190($v;$tBuffer;*)
						
						
						  //———————————————————————————————————
					Else 
						
						  //
						
						  //———————————————————————————————————
				End case 
				
				If (Length:C16($tBuffer)>0)
					
					ST SET TEXT:C1115($t;$tBuffer;ST Start text:K78:15;ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
						Attribute text color:K65:7;"green")
					
				End if 
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				$o:=Form:C1466.git
				
				If ($t="staged")
					
					$o.diff($oTarget.path;"--cached")
					
				Else 
					
					$o.diff($oTarget.path)
					
				End if 
				
				If (Length:C16($o.result)>0)
					
					$c:=Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1)
					
					  // Delete the initial lines
					$b:=True:C214
					
					While $b & ($c.length>0)
						
						$b:=(Position:C15("@";String:C10($c[0]))#1)
						
						If ($b)
							
							$c.remove(0;1)
							
						End if 
					End while 
					
					If ($c.length>0)
						
						$l:=0
						
						For each ($t;$c)
							
							Case of 
									
									  //———————————————————————————————————
								: (Length:C16($t)=0)
									
									  // <NOTHING MORE TO DO>
									
									  //———————————————————————————————————
								: ($t[[1]]="-")
									
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"red")
									
									  //———————————————————————————————————
								: ($t[[1]]="+")
									
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"green")
									
									  //———————————————————————————————————
								: (Character code:C91($t[[1]])=Character code:C91("@"))
									
									$t:="\n"+$t
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"gray")
									
									  //———————————————————————————————————
								: ($t[[1]]="\\")
									
									$t:=Delete string:C232($t;1;1)
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"gray")
									
									  //———————————————————————————————————
							End case 
							
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
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
		
		$oButton.enable()
		Form:C1466.diff:=$t
		
	Else 
		
		$oButton.disable()
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