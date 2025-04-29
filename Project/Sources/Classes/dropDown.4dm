Class extends widget

property data; _backup : Object

Class constructor($name : Text; $data : Object; $parent : Object)
	
	Super:C1705($name; $parent)
	
	This:C1470._populate($data)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get values() : Collection
	
	return This:C1470.data.values
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set values($values : Collection)
	
	This:C1470.data.values:=$values
	This:C1470.data.index:=-1
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get value() : Variant
	
	If (This:C1470.data.index#-1)\
		 || (OB Instance of:C1731(This:C1470; cs:C1710.dropDown))
		
		return This:C1470.data.currentValue
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set value($value)
	
	This:C1470.data.currentValue:=$value
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get index() : Integer
	
	return This:C1470.data.index
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set index($index : Integer)
	
	This:C1470.data.index:=$index
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get placeholder() : Variant
	
	return String:C10(This:C1470.data.placeholder)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set placeholder($placeholder)
	
	This:C1470.data.placeholder:=$placeholder
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get valueType() : Integer
	
	return This:C1470.data.type
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clear()
	
	var $current : Variant:=This:C1470.data.currentValue
	CLEAR VARIABLE:C89($current)
	This:C1470.data.currentValue:=$current
	
	This:C1470.data.currentValue:=This:C1470.data.currentValue || This:C1470.data.placeholder
	This:C1470.data.index:=-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function reset($data : Object)
	
	This:C1470._populate($data)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restore()
	
	This:C1470._populate(This:C1470._backup)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _populate($data : Object)
	
	If ($data#Null:C1517)
		
		This:C1470.data:=$data
		This:C1470.data.values:=This:C1470.data.values || []
		
		// Check that values is a scalar collection of Numeric, Text, Date or Time
		var $v
		var $type : Integer
		For each ($v; This:C1470.data.values)
			
			$type:=Value type:C1509($v)
			$type:=$type=Is integer:K8:5 ? Is longint:K8:6 : $type
			
			If (Not:C34([Is text:K8:3; Is date:K8:7; Is time:K8:8; Is longint:K8:6; Is real:K8:4].includes($type)))
				
				throw:C1805(_error("The list of values must be a collection of strings, numbers, dates or times."))
				return 
				
			End if 
		End for each 
		
		This:C1470.data.type:=$type
		
		If ($data.currentValue#Null:C1517)
			
			If ($data.index=Null:C1517)
				
				$data.index:=This:C1470.data.values.indexOf($data.currentValue)
				
			End if 
			
		Else 
			
			This:C1470.data.index:=$data.index#Null:C1517 ? $data.index : -1
			
		End if 
		
		This:C1470.data.placeholder:=$data.placeholder || $data.currentValue  // Default is current value
		
	Else 
		
		This:C1470.data:={values: []}
		
	End if 
	
	This:C1470.clear()
	
	This:C1470._backup:=OB Copy:C1225(This:C1470.data)