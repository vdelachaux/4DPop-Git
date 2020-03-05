//%attributes = {"invisible":true}
C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$length;$pos)
C_TEXT:C284($t;$tBuffer)
C_OBJECT:C1216($ƒ;$o;$oButton;$oTarget)
C_COLLECTION:C1488($c)
C_VARIANT:C1683($v)

$t:=OBJECT Get name:C1087(Object with focus:K67:3)
$ƒ:=Form:C1466.ƒ

ASSERT:C1129(Not:C34(Shift down:C543))

Case of 
		
		  //______________________________________________________
	: (Form:C1466.currentStaged=Null:C1517)\
		 & (Form:C1466.currentUnstaged=Null:C1517)
		
		  // <NOTHING MORE TO DO>
		
		  //______________________________________________________
	: ($t="unstaged")
		
		$ƒ.toComit.deselect()
		$ƒ.unstage.disable()
		
		If (Form:C1466.currentUnstaged#Null:C1517)
			$c:=Form:C1466.selectedUnstaged
			$oTarget:=Form:C1466.currentUnstaged
			$oButton:=$ƒ.stage
			
		End if 
		
		  //______________________________________________________
	: ($t="staged")
		
		$ƒ.toStage.deselect()
		$ƒ.stage.disable()
		
		If (Form:C1466.currentStaged#Null:C1517)
			
			$c:=Form:C1466.selectedStaged
			$oTarget:=Form:C1466.currentStaged
			$oButton:=$ƒ.unstage
			
		End if 
		
		  //______________________________________________________
End case 

If ($oButton#Null:C1517)
	
	If ($c.length>0)
		
		Case of 
				
				  //––––––––––––––––––––––––––––––––––––––––––––––––
			: ($oTarget.status="??")
				
				$v:=convertPath ($oTarget.path)
				
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
						
						METHOD GET CODE:C1190($v;$tBuffer)
						
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
				
				If ($t="staged")
					
					$o.diff($oTarget.path;"--cached")
					
				Else 
					
					$o.diff($oTarget.path)
					
				End if 
				
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
						
						For each ($t;$c)
							
							Case of 
									
									  //…………………………………………………………………………………………………
								: (Length:C16($t)=0)
									
									  // <NOTHING MORE TO DO>
									
									  //…………………………………………………………………………………………………
								: ($t[[1]]="-")
									
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"red")
									
									  //…………………………………………………………………………………………………
								: ($t[[1]]="+")
									
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"green")
									
									  //…………………………………………………………………………………………………
								: (Character code:C91($t[[1]])=Character code:C91("@"))
									
									$t:=("\n"*Num:C11($l>0))+$t
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"gray")
									
									  //…………………………………………………………………………………………………
								: ($t[[1]]="\\")
									
									$t:=Delete string:C232($t;1;1)
									ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
										Attribute text color:K65:7;"gray")
									
									  //…………………………………………………………………………………………………
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
	$ƒ.stage.disable()
	$ƒ.unstage.disable()
	
End if 

$ƒ.diff.setVisible(Length:C16(String:C10(Form:C1466.diff))>0)