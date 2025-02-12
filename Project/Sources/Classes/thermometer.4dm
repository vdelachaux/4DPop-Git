Class extends widget

Class constructor($name : Text)  //; $datasource : Variant)
	
	Super:C1705($name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function asynchronous() : cs:C1710.thermometer
	
	return This:C1470.indicatorType(Asynchronous progress bar:K42:36)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isAsynchronous() : Boolean
	
	var $type : Integer
	
	$type:=This:C1470.getIndicatorType()
	
	return ($type=Asynchronous progress bar:K42:36) | ($type=Barber shop:K42:35) | ($type=0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function barber : cs:C1710.thermometer
	
	return This:C1470.indicatorType(Barber shop:K42:35)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isBarber() : Boolean
	
	return This:C1470.getIndicatorType()=Barber shop:K42:35
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function progress : cs:C1710.thermometer
	
	return This:C1470.indicatorType(Progress bar:K42:34)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isProgress() : Boolean
	
	return This:C1470.getIndicatorType()=Progress bar:K42:34
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function indicatorType($type : Integer) : cs:C1710.thermometer
	
	OBJECT SET INDICATOR TYPE:C1246(*; This:C1470.name; $type)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getIndicatorType() : Integer
	
	return OBJECT Get indicator type:C1247(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function start() : cs:C1710.thermometer
	
	If (Asserted:C1132(This:C1470.isAsynchronous()))
		
		This:C1470.setValue(1)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stop() : cs:C1710.thermometer
	
	If (Asserted:C1132(This:C1470.isAsynchronous()))
		
		This:C1470.setValue(0)
		
	End if 
	
	return This:C1470
	