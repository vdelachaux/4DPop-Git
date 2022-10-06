Class extends widget

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text; $datasource : Variant)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($name; $datasource)
		
	Else 
		
		Super:C1705($name)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function start()
	
	This:C1470.setValue(1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function stop()
	
	This:C1470.setValue(0)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function isRunning() : Boolean
	
	return (This:C1470.getValue()#0)