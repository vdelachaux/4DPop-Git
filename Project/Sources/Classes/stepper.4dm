Class extends widget

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text; $parent : Object)
	
	Super:C1705($name; $parent)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function start($show : Boolean) : cs:C1710.stepper
	
	If ($show)
		
		Super:C1706.show()
		
	End if 
	
	This:C1470.setValue(1)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stop($hide : Boolean) : cs:C1710.stepper
	
	This:C1470.setValue(0)
	
	If ($hide)
		
		Super:C1706.hide()
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRunning() : Boolean
	
	return This:C1470.getValue()#0