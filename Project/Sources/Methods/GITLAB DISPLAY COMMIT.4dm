//%attributes = {"invisible":true}
C_BLOB:C604($x)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

Form:C1466.commitDetail.clear()

$o:=Form:C1466.commitsCurrent

If ($o#Null:C1517)
	
	OBJECT SET VISIBLE:C603(*;"detail_@";True:C214)
	
	Form:C1466.git.execute("diff --name-status "+$o.fingerprint.short+" "+$o.parent.short)
	
	If (Form:C1466.git.success)
		
		For each ($t;Split string:C1554(Form:C1466.git.result;"\n";sk ignore empty strings:K86:1+sk trim spaces:K86:2))
			
			$c:=Split string:C1554($t;"\t";sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			Form:C1466.commitDetail.push(New object:C1471("status";$c[0];"path";$c[1]))
			
		End for each 
	End if 
	
	If ($o.author.avatar=Null:C1517)
		
		If (HTTP Get:C1157("https://www.gravatar.com/avatar/"+Generate digest:C1147($o.author.mail;MD5 digest:K66:1);$x)=200)
			
			BLOB TO PICTURE:C682($x;$p)
			$o.author.avatar:=$p
			
		End if 
	End if 
	
Else 
	
	OBJECT SET VISIBLE:C603(*;"detail_@";False:C215)
	
End if 

Form:C1466.$.selector.deselect()