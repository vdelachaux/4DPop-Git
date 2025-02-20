//%attributes = {}
// ----------------------------------------------------
// Project method: GIT OPEN
// ID[52DD5F426D1647FF837AF213147FFC6B]
// Created 4-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($run : Boolean)

If (Count parameters:C259=0)
	
	BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; Current method name:C684; True:C214; *))
	return 
	
End if 

If (Is macOS:C1572)\
 && (Form:C1466#Null:C1517)
	
	var $winRef:=Open form window:C675("SETTINGS"; Sheet form window:K39:12)
	
Else 
	
	$winRef:=Open form window:C675("SETTINGS"; Controller form window:K39:17; Horizontally centered:K39:1; At the top:K39:5; *)
	
End if 

DIALOG:C40("SETTINGS")
CLOSE WINDOW:C154