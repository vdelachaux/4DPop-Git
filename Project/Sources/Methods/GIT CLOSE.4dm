//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method: GIT CLOSE
// Called from the method editor's on_close macro: GIT CLOSE("<method_path/>")
// Records a close request for the method's history window. The window honours it on its
// timer UNLESS it is cancelled by an immediate re-open (the on_close event fires right
// before the "open" macro on the same user action), so a spurious close never reaches a
// freshly opened window — only a genuine editor close (with no following open) closes it.
// ----------------------------------------------------
#DECLARE($target : Text)

var $file:=cs:C1710.Git.me.sourceFile($target)

If ($file=Null:C1517)
	
	return 
	
End if 

If (Storage:C1525.gitHistoryClose=Null:C1517)
	
	Use (Storage:C1525)
		Storage:C1525.gitHistoryClose:=New shared object:C1526
	End use 
	
End if 

Use (Storage:C1525.gitHistoryClose)
	Storage:C1525.gitHistoryClose["$githist:"+$file.path]:=Milliseconds:C459
End use 
