Class extends scrollable

// === === === === === === === === === === === === === === === === === === ===
Class constructor($objectName : Text; $datasource)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($objectName; $datasource)
		
	Else 
		
		Super:C1705($objectName)
		
	End if 
	
	This:C1470.parent:=This:C1470.getParent()
	This:C1470.events:=Null:C1517
	
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === ===
	// ⚠️
Function getCoordinates() : Object
	
	This:C1470.getSubforms()
	
	return Super:C1706.getCoordinates()
	
	// === === === === === === === === === === === === === === === === === === ===
Function getParent() : Object
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return New object:C1471(\
		"name"; Current form name:C1298; \
		"dimensions"; New object:C1471(\
		"width"; $width; \
		"height"; $height))
	
	// === === === === === === === === === === === === === === === === === === ===
Function getParentDimensions() : Object
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return New object:C1471(\
		"width"; $width; \
		"height"; $height)
	
	// === === === === === === === === === === === === === === === === === === ===
Function callParent($eventCode : Integer)
	
	CALL SUBFORM CONTAINER:C1086($eventCode)
	
	// === === === === === === === === === === === === === === === === === === ===
Function alignHorizontally($alignment : Integer; $reference)
	
	var $middle : Integer
	var $coordinates; $parent : Object
	
	$coordinates:=This:C1470.getCoordinates()
	
	If (Count parameters:C259=1)
		
		$parent:=This:C1470.getParentDimensions()
		
	Else 
		
		ASSERT:C1129(False:C215; "#TO_DO")
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($alignment=Align center:K42:3)
			
			$middle:=$parent.width\2
			$coordinates.left:=$middle-(This:C1470.dimensions.width\2)
			$coordinates.right:=$coordinates.left+This:C1470.dimensions.width
			
			This:C1470.setCoordinates($coordinates)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "#TO_DO")
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === ===
Function getSubforms()
	
	var $detail; $list : Text
	var $ptr : Pointer
	
	OBJECT GET SUBFORM:C1139(*; This:C1470.name; $ptr; $detail; $list)
	
	This:C1470.forms:=New object:C1471(\
		"table"; $ptr; \
		"detail"; $detail; \
		"list"; $list)
	
	// === === === === === === === === === === === === === === === === === === ===
Function setSubform($detail : Text; $list : Text; $table : Pointer) : cs:C1710.subform
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $detail)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $detail; $list)
			
			//______________________________________________________
		: (Count parameters:C259=3)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $table->; $detail; $list)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Missing parameter")
			
			//______________________________________________________
	End case 
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === ===
Function currentPage() : Integer
	
	return (FORM Get current page:C276(*))
	
	// === === === === === === === === === === === === === === === === === === ===
Function goToPage($page : Integer)
	
	FORM GOTO PAGE:C247($page; *)
	
	// === === === === === === === === === === === === === === === === === === ===
	// The event codes triggered in the container method
Function setEvents($events : Object)
	
	This:C1470.events:=$events || New object:C1471