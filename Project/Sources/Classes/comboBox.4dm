Class extends dropDown

property _ordered; automaticExpand : Boolean

Class constructor($name : Text; $data : Object)
	
	Super:C1705($name; $data)
	
	This:C1470._ordered:=Bool:C1537($data.ordered)
	This:C1470.automaticExpand:=Bool:C1537($data.automaticExpand)
	
	If (This:C1470.automaticExpand)
		
		This:C1470._automaticExpandInit()
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get automaticExpand() : Boolean
	
	return Bool:C1537(This:C1470.data.automaticExpand)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set automaticExpand($auto : Boolean)
	
	This:C1470.data.automaticExpand:=$auto
	
	If ($auto)
		
		This:C1470._automaticExpandInit()
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get filter() : Text
	
	return OBJECT Get filter:C1073(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set filter($filter)
	
	var $separator : Text
	
	If (Value type:C1509($filter)=Is longint:K8:6)\
		 | (Value type:C1509($filter)=Is real:K8:4)  // Predefined formats
		
		Case of 
				
				//………………………………………………………………………
			: ($filter=Is integer:K8:5)\
				 | ($filter=Is longint:K8:6)\
				 | ($filter=Is integer 64 bits:K8:25)
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is real:K8:4)
				
				GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $separator)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";.;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is time:K8:8)
				
				GET SYSTEM FORMAT:C994(Time separator:K60:11; $separator)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";:\"")
				
				//………………………………………………………………………
			: ($filter=Is date:K8:7)
				
				GET SYSTEM FORMAT:C994(Date separator:K60:10; $separator)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";/\"")
				
				//………………………………………………………………………
			Else 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "")  // Text as default
				
				//………………………………………………………………………
		End case 
		
	Else 
		
		OBJECT SET FILTER:C235(*; This:C1470.name; String:C10($filter))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the selection list (to use in the On getting focus event)
Function expand() : cs:C1710.comboBox
	
	var $o : Object
	
	If (This:C1470.automaticExpand)
		
		// Get the current widget window coordinates
		$o:=This:C1470.windowCoordinates
		POST CLICK:C466($o.right-10; $o.top+10; Current process:C322)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the selection list (to use in the On Data change event)
Function automaticInsertion($ordered : Boolean)
	
	var $index : Integer
	var $value
	
	$value:=This:C1470.data.currentValue
	$index:=This:C1470.data.values.indexOf($value)
	
	If ($index=-1)
		
		This:C1470.data.values.push($value)
		
		If ($ordered | This:C1470._ordered)
			
			This:C1470.data.values:=This:C1470.data.values.orderBy()
			$index:=This:C1470.data.values.indexOf($value)
			
		End if 
	End if 
	
	This:C1470.data.index:=$index
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Set On Getting focus event, if any
Function _automaticExpandInit()
	
	This:C1470.addEvent(On Getting Focus:K2:7)
	