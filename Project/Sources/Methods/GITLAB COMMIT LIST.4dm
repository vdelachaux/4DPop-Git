//%attributes = {}
C_TEXT:C284($t)
C_OBJECT:C1216($git;$o)
C_COLLECTION:C1488($c)

If (FORM Get current page:C276=2)
	
	OBJECT SET VISIBLE:C603(*;"detail_@";False:C215)
	
	$git:=Form:C1466.git
	
	  // Update commit list
	Form:C1466.commits.clear()
	
	$git.execute("log --abbrev-commit --format=%s,%an,%h,%aI,%H,%p,%P,%ae")
	
/*
0 = message
1 = author name
2 = short sha
3 = time stamp
4 = sha
5 = parent short sha
6 = parent sh
7 = author mail
*/
	
	  // One commit per line
	For each ($t;Split string:C1554($git.result;"\n";sk ignore empty strings:K86:1))
		
		$c:=Split string:C1554($t;",")
		
		If ($c.length>=8)
			
			$o:=New object:C1471(\
				"title";$c[0];\
				"author";New object:C1471("name";$c[1];"mail";$c[7]);\
				"stamp";String:C10(Date:C102($c[3]))+" at "+String:C10(Time:C179($c[3])+?00:00:00?);\
				"fingerprint";New object:C1471("short";$c[2];"long";$c[4]);\
				"parent";New object:C1471(\
				"short";$c[5];\
				"long";$c[6]))
			
			Form:C1466.commits.push($o)
			
		End if 
	End for each 
	
	  // Update UI
	Form:C1466.ƒ.refresh()
	
Else 
	
	  // <NOTHING MORE TO DO>
	
End if 