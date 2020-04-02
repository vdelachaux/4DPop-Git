//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$length;$pos)
C_TEXT:C284($t;$tBuffer;$tColor)
C_OBJECT:C1216($git;$o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(GITLAB Diff ;$0)
	C_TEXT:C284(GITLAB Diff ;$1)
End if 

$git:=Form:C1466.git

If ($git.success)
	
	If (Length:C16($git.result)>0)
		
		$c:=Split string:C1554($git.result;"\n";sk ignore empty strings:K86:1)
		
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
			
			Case of 
					
					  //______________________________________________________
				: ($1="A")\
					 | ($1="??")
					
					ST SET TEXT:C1115($t;$c.join("\n");ST Start text:K78:15;ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
						Attribute text color:K65:7;"green")
					
					  //______________________________________________________
				: ($1="@D@")
					
					ST SET TEXT:C1115($t;$c.join("\n");ST Start text:K78:15;ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
						Attribute text color:K65:7;"red")
					
					  //______________________________________________________
				Else 
					
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
					
					  //______________________________________________________
			End case 
		End if 
	End if 
	
Else 
	
	$o:=$git.history.pop()
	ST SET TEXT:C1115($t;String:C10($o.cmd)+"\r\r"+String:C10($o.error);ST Start text:K78:15;ST End text:K78:16)
	ST SET ATTRIBUTES:C1093($t;ST Start text:K78:15;ST End text:K78:16;\
		Attribute text color:K65:7;"red")
	
End if 

$0:=$t