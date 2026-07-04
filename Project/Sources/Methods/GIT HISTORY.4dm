//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method: GIT HISTORY
// Displays the commit history of the method / class file currently being edited.
// Called from the method editor contextual macro: GIT HISTORY("<method_path/>").
// Re-entered in a dedicated window process with (File; True) — the two modes are told
// apart by the type of $target (a 4D.File for the window body, a Text path for the macro).
// The matching on_close macro calls GIT CLOSE (a separate method).
// ----------------------------------------------------
#DECLARE($target : Variant; $run : Boolean)

var $git:=cs:C1710.Git.me

If (Value type:C1509($target)#Is text:K8:3)  // <== Window process body ($target = File)
	
	var $data:={file: $target}
	
	var $winRef:=Open form window:C675("HISTORY"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("HISTORY"; $data)
	CLOSE WINDOW:C154
	
	return 
	
End if 

// <== Macro entry: validate then open a dedicated window process
If ($git.root=Null:C1517) || (Not:C34($git.root.exists))
	
	ALERT:C41(Localized string:C991("thisDatabaseIsNotUnderGitControl"))
	return 
	
End if 

var $file:=$git.sourceFile(String:C10($target))

If ($file=Null:C1517) || (Not:C34($file.exists))
	
	ALERT:C41(Localized string:C991("methodFileNotFound"))
	return 
	
End if 

// Cancel any close request left by the on_close event (GIT CLOSE) that fired just before us
If (Storage:C1525.gitHistoryClose#Null:C1517)
	
	Use (Storage:C1525.gitHistoryClose)
		OB REMOVE:C1226(Storage:C1525.gitHistoryClose; "$githist:"+$file.path)
	End use 
	
End if 

// Unique process per file: the trailing * makes New process reuse an already-open window
// (it returns the existing process number instead of creating a new one), and BRING TO
// FRONT then raises it. The name is keyed on the file path to stay unique.
BRING TO FRONT:C326(New process:C317("GIT HISTORY"; 0; "$githist:"+$file.path; $file; True:C214; *))
