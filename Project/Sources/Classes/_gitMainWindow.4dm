/// **_gitMainWindow** — tracks the currently open Git history window reference
/// via a small marker file, NOT an in-memory shared singleton: a `RELOAD
/// PROJECT` (routinely triggered by checkout/pull/push, including from the
/// widget itself) resets shared singletons, and the widget/main window can
/// also be two separate loaded instances of the component — a file on disk
/// sidesteps both problems.

property file : 4D:C1709.File:=Folder:C1567(fk user preferences folder:K87:10).file("4DPop-Git-mainWindow.txt")

singleton Class constructor
	
	// <NOTHING TO DO> — state lives in the marker file, not in this instance
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// The registered window reference, or 0 when no Git history window is open.
Function get windowRef() : Integer
	
	If (Not:C34(This:C1470.file.exists))
		
		return 0
		
	End if 
	
	return Num:C11(This:C1470.file.getText())
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Registers the Git history window reference (call from its own onActivate).
Function register($windowRef : Integer)
	
	This:C1470.file.setText(String:C10($windowRef))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Clears the registration (call when the window closes).
Function unregister()
	
	If (This:C1470.file.exists)
		
		This:C1470.file.delete()
		
	End if 
