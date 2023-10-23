Class extends widgetDelegate

property data : Object

Class constructor($name : Text; $data : Object)
	
	Super:C1705($name)
	
	This:C1470.data:=$data || {}
	
	If (This:C1470.data#Null:C1517) && (This:C1470.data.currentValue#Null:C1517)
		
		This:C1470.data.placeholder:=This:C1470.data.placeholder#Null:C1517\
			 ? This:C1470.data.placeholder\
			 : This:C1470.data.currentValue
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get values() : Collection
	
	return This:C1470.data.values
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set values($values : Collection)
	
	This:C1470.data.values:=$values
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get currentValue() : Variant
	
	return This:C1470.data.currentValue
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set currentValue($value)
	
	This:C1470.data.currentValue:=$value
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get index() : Variant
	
	return This:C1470.data.index
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set index($index : Integer)
	
	This:C1470.data.index:=$index
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get placeholder() : Text
	
	return String:C10(This:C1470.data.placeholder)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set placeholder($placeholder : Text)
	
	This:C1470.data.placeholder:=$placeholder
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Reset
Function clear() : cs:C1710.dropDownDelegate
	
	This:C1470.data.index:=-1
	This:C1470.data.currentValue:=String:C10(This:C1470.data.placeholder)
	
	return This:C1470
	