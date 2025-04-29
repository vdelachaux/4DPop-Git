Class extends dropDown

Class constructor($name : Text; $data : Object; $parent : Object)
	
	Super:C1705($name; $data; $parent)
	
	If (Bool:C1537($data.ordered))
		
		This:C1470.order()
		
	End if 
	
	If ($data.automaticExpand)
		
		This:C1470.addEvent(On Getting Focus:K2:7)
		
	End if 
	
	If ($data.automaticInsertion)
		
		This:C1470.addEvent(On Data Change:K2:15)
		
	End if 
	
	This:C1470.filter:=Num:C11(This:C1470.data.type)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get automaticExpand() : Boolean
	
	return Bool:C1537(This:C1470.data.automaticExpand)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set automaticExpand($auto : Boolean)
	
	This:C1470.data.automaticExpand:=$auto
	
	If ($auto)
		
		This:C1470.addEvent(On Getting Focus:K2:7)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get automaticInsertion() : Boolean
	
	return Bool:C1537(This:C1470.data.automaticInsertion)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set automaticInsertion($auto : Boolean)
	
	This:C1470.data.automaticInsertion:=$auto
	
	If ($auto)
		
		This:C1470.addEvent(On Data Change:K2:15)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get ordered() : Boolean
	
	return Bool:C1537(This:C1470.data.ordered)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set ordered($auto : Boolean)
	
	This:C1470.data.ordered:=$auto
	
	If ($auto)
		
		This:C1470.order()
		
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
Function order()
	
	This:C1470.data.values:=This:C1470.data.values.orderBy()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the selection list (to use in the On getting focus event)
Function expand()
	
	GOTO OBJECT:C206(*; This:C1470.name)
	POST KEY:C465(Down arrow key:K12:19; 0 ?+ Command key bit:K16:2)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Insert an item or the current value. 
	// Keep the list ordered if any
Function insert($item; $order : Boolean) : cs:C1710.comboBox
	
	If (Count parameters:C259=0)\
		 || (Value type:C1509($1)=Is boolean:K8:9)
		
		var $value : Variant:=This:C1470.value
		
	Else 
		
		$value:=$item
		
	End if 
	
	If (Length:C16(String:C10($value))=0)
		
		return This:C1470
		
	End if 
	
	var $values:=This:C1470.values
	var $index : Integer:=$values.indexOf($value)
	
	If ($index=-1)
		
		$values.push($value)
		
		If (This:C1470.ordered | $order)
			
			$values:=$values.orderBy()
			$index:=$values.indexOf($value)
			
		End if 
	End if 
	
	This:C1470.data.values:=$values
	This:C1470.data.index:=$index
	
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function listModified() : Boolean
	
	return Not:C34(This:C1470.data.values.equal(This:C1470._backup.values))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function eventHandler() : Object
	
	var $e:=FORM Event:C1606
	
	Case of 
			
			// ______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			If (This:C1470.data.automaticExpand)
				
				This:C1470.expand()
				
			End if 
			
			// ______________________________________________________
		: ($e.code=On Data Change:K2:15)
			
			If (This:C1470.data.automaticInsertion)
				
				This:C1470.insert()
				
			End if 
			
			// ______________________________________________________
	End case 
	
	return $e