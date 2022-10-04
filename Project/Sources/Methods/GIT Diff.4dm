//%attributes = {"invisible":true}
#DECLARE($diff : Text) : Text

If (False:C215)
	C_TEXT:C284(GIT Diff; $1)
	C_TEXT:C284(GIT Diff; $0)
End if 

var $color; $line; $styled : Text
var $continue : Boolean
var $indx; $len; $pos : Integer
var $o : Object
var $c : Collection
var $git : cs:C1710.git

$git:=Form:C1466.git

If ($git.success)
	
	If (Length:C16($git.result)>0)
		
		$c:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1)
		
		// Delete the initial lines
		$continue:=True:C214
		
		While ($c.length>0) & $continue
			
			$continue:=(Position:C15("@"; String:C10($c[0]))#1)
			
			If ($continue)
				
				$c.remove(0; 1)
				
			End if 
		End while 
		
		If ($c.length>0)
			
			Case of 
					
					//______________________________________________________
				: ($diff="A")\
					 | ($diff="??")
					
					ST SET TEXT:C1115($styled; $c.join("\n"); ST Start text:K78:15; ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; \
						Attribute text color:K65:7; "green")
					
					//______________________________________________________
				: ($diff="@D@")
					
					ST SET TEXT:C1115($styled; $c.join("\n"); ST Start text:K78:15; ST End text:K78:16)
					ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; \
						Attribute text color:K65:7; "red")
					
					//______________________________________________________
				Else 
					
					For each ($line; $c)
						
						If (Length:C16($line)>0)
							
							$color:="gray"
							
							Case of 
									
									//…………………………………………………………………………………………………
								: ($line[[1]]="-")
									
									$color:="red"
									
									//…………………………………………………………………………………………………
								: ($line[[1]]="+")
									
									$color:="green"
									
									//…………………………………………………………………………………………………
								: (Character code:C91($line[[1]])=Character code:C91("@"))
									
									$line:="\n"+$line
									
									//…………………………………………………………………………………………………
								: ($line[[1]]="\\")
									
									$line:=Delete string:C232($line; 1; 1)
									
									//…………………………………………………………………………………………………
							End case 
							
							ST SET TEXT:C1115($styled; $line; ST Start text:K78:15; ST End text:K78:16)
							ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; \
								Attribute text color:K65:7; $color)
							
						End if 
						
						$c[$indx]:=$styled
						$indx+=1
						
					End for each 
					
					$styled:=$c.join("\n")
					
					$styled:=Replace string:C233($styled; "<br/>"; "")
					
					// Separate blocks
					$indx:=1
					
					While (Match regex:C1019("(?mi-s)^(<[^>]*>@@[^$]*)$"; $styled; $indx; $pos; $len))
						
						If ($pos>1)
							
							$styled:=Substring:C12($styled; 1; $pos-1)+"\n"+Substring:C12($styled; $pos)
							
						End if 
						
						$indx+=$len
						
					End while 
					
					// Remove unnecessary line breaks
					While (Position:C15("\n\n"; $styled)>0)
						
						$styled:=Replace string:C233($styled; "\n\n"; "\n")
						
					End while 
					
					If (Position:C15("\n"; $styled)=1)
						
						$styled:=Delete string:C232($styled; 1; 1)
						
					End if 
					
					//______________________________________________________
			End case 
		End if 
	End if 
	
Else 
	
	$o:=$git.history.pop()
	ST SET TEXT:C1115($styled; String:C10($o.cmd)+"\r\r"+String:C10($o.error); ST Start text:K78:15; ST End text:K78:16)
	ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; \
		Attribute text color:K65:7; "red")
	
End if 

return $styled