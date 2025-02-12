//%attributes = {"invisible":true,"executedOnServer":true}
// Executed on the server
#DECLARE() : Object

var $file : 4D:C1709.File:=Folder:C1567("/PACKAGE/Project"; *).files().query("extension = .4DProject").first()

If ($file#Null:C1517)
	
	return JSON Parse:C1218($file.getText())
	
End if 