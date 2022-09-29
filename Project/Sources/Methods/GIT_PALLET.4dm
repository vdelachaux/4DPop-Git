//%attributes = {}
var $window : Integer

If (Folder:C1567(fk database folder:K87:14; *).file(".git/HEAD").exists)
	
	$window:=Open form window:C675("GIT_PALLET"; -Palette window:K34:3; On the right:K39:3; At the top:K39:5; *)
	DIALOG:C40("GIT_PALLET")
	CLOSE WINDOW:C154($window)
	
Else 
	
	// A "If" statement should never omit "Else" 
	
End if 

