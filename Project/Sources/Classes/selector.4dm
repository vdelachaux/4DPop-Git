Class extends widget

/**
The selector class is intended to manage Dropdown, Combo Box and Tab Control widgets
*/

Class constructor($name : Text; $values : Collection)
	
	If (Count parameters:C259>=1)
		
		Super:C1705($name)
		
	Else 
		
		Super:C1705()
		
	End if 
	
	// The "binding" property is designed to store a collection of values linked to the values
	// This allows to display a localized widget while keeping the uniqueness of the associated value
	This:C1470.data:=New object:C1471(\
		"values"; New collection:C1472; \
		"binding"; New collection:C1472; \
		"currentValue"; ""; \
		"index"; -1)
	
	If ($values#Null:C1517)
		
		This:C1470.data.values:=$values
		
	End if 
	
	// Todo: get the datasource type to return a correct value
	
	// MARK:-COMPUTED ATTRIBUTES
	// === === === === === === === === === === === === === === === === === === === === ===
Function get values() : Collection
	
	return (This:C1470.data ? This:C1470.data.values : Null:C1517)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set values($values : Collection)
	
	This:C1470.data.values:=$values
	
	// Todo: manage binding length if any
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get binding() : Collection
	
	return (This:C1470.data ? This:C1470.data.binding : Null:C1517)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set binding($values : Collection)
	
	This:C1470.data.binding:=$values
	
	// Todo: manage values length if any
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get index() : Integer
	
	return (This:C1470.data ? This:C1470.data.index : -1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set index($index : Integer)
	
	This:C1470.data.index:=$index
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get current() : Text
	
	If (This:C1470.data.binding.length>0)\
		 && (This:C1470.data.binding.length=This:C1470.data.values.length)
		
		return (This:C1470.data.index#-1 ? This:C1470.data.binding[This:C1470.data.index] : This:C1470.data.currentValue)
		
	Else 
		
		return (This:C1470.data.currentValue)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set current($current)
	
	If (This:C1470.data.binding.length>0)\
		 && (This:C1470.data.binding.length=This:C1470.data.values.length)
		
		// Search for the value into the binded values
		This:C1470.data.index:=This:C1470.data.binding.indexOf($current)
		
		If (This:C1470.data.index#-1)
			
			// Link to the value to be displayed
			This:C1470.data.currentValue:=This:C1470.data.values[This:C1470.data.index]
			
		Else 
			
			// Keeping the past value
			This:C1470.data.currentValue:=$current
			
		End if 
		
	Else 
		
		// Keeping the past value
		This:C1470.data.currentValue:=$current
		
	End if 
	
	// MARK:-FUNCTIONS
	// === === === === === === === === === === === === === === === === === === === === ===
	// Selects an element by its position or by its value (or that of the linked data).
Function select($element)
	
	var $index : Integer
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($element)=Is text:K8:3)
			
			If (This:C1470.data.binding.length>0)\
				 && (This:C1470.data.binding.length=This:C1470.data.values.length)
				
				$index:=This:C1470.data.binding.indexOf($element)
				This:C1470.data.currentValue:=$index#-1 ? This:C1470.data.values[$index] : $element
				
			Else 
				
				This:C1470.data.currentValue:=$element
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($element)=Is real:K8:4)\
			 | (Value type:C1509($element)=Is longint:K8:6)
			
			If (Asserted:C1132(($element>=0) && ($element<This:C1470.data.values.length); "Invalid index: "+String:C10($element)))
				
				This:C1470.data.currentValue:=This:C1470.data.values[$element]
				
			End if 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "element parameter must be a text or a number")
			
			//______________________________________________________
	End case 