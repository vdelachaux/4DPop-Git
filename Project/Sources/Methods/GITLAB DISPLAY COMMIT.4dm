//%attributes = {"invisible":true}
C_BLOB:C604($x)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

  // Clear list
Form:C1466.$.detailCommit.deselect()

Form:C1466.commitDetail.clear()

$o:=Form:C1466.commitsCurrent

If ($o#Null:C1517)
	
	OBJECT SET VISIBLE:C603(*;"detail_@";True:C214)
	
	If (Form:C1466.git.diffList($o.parent.short;$o.fingerprint.short))
		
		For each ($t;Split string:C1554(Form:C1466.git.result;"\n";sk ignore empty strings:K86:1+sk trim spaces:K86:2))
			
			$c:=Split string:C1554($t;"\t";sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			Form:C1466.commitDetail.push(New object:C1471(\
				"status";$c[0];\
				"path";$c[1]))
			
		End for each 
	End if 
	
	If ($o.author.avatar=Null:C1517)
		
		$t:=Generate digest:C1147($o.author.mail;MD5 digest:K66:1)
		
		If (Form:C1466[$t]=Null:C1517)
			
			If (HTTP Get:C1157("https://www.gravatar.com/avatar/"+$t;$x)=200)
				
				BLOB TO PICTURE:C682($x;$p)
				Form:C1466[$t]:=$p
				
			End if 
		End if 
		
		$o.author.avatar:=Form:C1466[$t]
		
	End if 
	
Else 
	
	OBJECT SET VISIBLE:C603(*;"detail_@";False:C215)
	
End if 

Form:C1466.$.selector.deselect()