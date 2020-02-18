//%attributes = {}
C_TEXT:C284($tVersion)
C_OBJECT:C1216($o)

$o:=git 

$tVersion:=$o.version()

$o.init()

If (False:C215)
	
	$o.status()
	
	If ($o.changes.length>0)
		
		$o.stage()
		
		$o.status()
		
		$o.commit()
		
	End if 
	
Else 
	
	  // A "If" statement should never omit "Else" 
	
End if 





