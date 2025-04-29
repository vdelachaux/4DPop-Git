Class extends widget

property scroll
property scrollbars : Object

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text; $parent : Object)
	
	Super:C1705($name; $parent)
	
	ASSERT:C1129([\
		Object type subform:K79:40; \
		Object type listbox:K79:8; \
		Object type picture input:K79:5; \
		Object type hierarchical list:K79:7; \
		Object type text input:K79:4].includes(This:C1470.type))
	
	This:C1470.getScrollbars()
	
	// MARK:-[SCROOLBARS]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get horizontalScrollbar() : Boolean
	
	var $horizontal; $vertical : Integer
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	
	return Bool:C1537($horizontal)  // True if always or auto
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set horizontalScrollbar($on : Boolean)
	
	This:C1470.setVerticalScrollbar(True:C214)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get horizontalScrollbarAuto() : Boolean
	
	If (This:C1470._automaticModeAvailable())
		
		var $horizontal; $vertical : Integer
		OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
		
		return $horizontal=2
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set horizontalScrollbarAuto($on : Boolean)
	
	If (This:C1470._automaticModeAvailable())
		
		This:C1470.setHorizontalScrollbar(2)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get verticalScrollbar() : Boolean
	
	var $horizontal; $vertical : Integer
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	
	return Bool:C1537($vertical)  // True if always or auto
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set verticalScrollbar($on : Boolean)
	
	This:C1470.setVerticalScrollbar(True:C214)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get verticalScrollbarAuto() : Boolean
	
	If (This:C1470._automaticModeAvailable())
		
		var $horizontal; $vertical : Integer
		OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
		
		return $vertical=2
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set verticalScrollbarAuto($on : Boolean)
	
	If (This:C1470._automaticModeAvailable())
		
		This:C1470.setVerticalScrollbar(2)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getScrollbars() : Object
	
	// Upadate status
	var $horizontal; $vertical : Integer
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	
	This:C1470.scrollbars:={\
		vertical: $vertical; \
		horizontal: $horizontal}
	
	This:C1470.scrollbars.horizontalAuto:=$horizontal=2
	This:C1470.scrollbars.verticalAuto:=$vertical=2
	
	return This:C1470.scrollbars
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setScrollbars($horizontal; $vertical) : cs:C1710.scrollable
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11($horizontal); Num:C11($vertical))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHorizontalScrollbar($display) : cs:C1710.scrollable
	
	This:C1470.getScrollbars()
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11($display); Num:C11(This:C1470.scrollbars.vertical))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setVerticalScrollbar($display) : cs:C1710.scrollable
	
	This:C1470.getScrollbars()
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11(This:C1470.scrollbars.horizontal); Num:C11($display))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function noScrollbar() : cs:C1710.scrollable
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; False:C215; False:C215)
	
	return This:C1470
	
	// MARK:-[SCROOL POSITION]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get horizontalPosition() : Integer
	
	If (This:C1470._horizontallyScrollable())
		
		var $hPosition; $vPosition : Integer
		OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
		
		return $hPosition
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function set horizontalPosition($pos : Integer)
	
	If (This:C1470._horizontallyScrollable())
		
		var $hPosition; $vPosition : Integer
		OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
		OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $vPosition; $pos)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get verticalPosition() : Integer
	
	var $hPosition; $vPosition : Integer
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
	
	return $vPosition
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function set verticalPosition($pos : Integer)
	
	var $hPosition; $vPosition : Integer
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
	OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $pos; $hPosition)
	
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getScrollPosition() : Variant
	
	var $hPosition; $vPosition : Integer
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
	
	If (This:C1470.type=Object type picture input:K79:5)\
		 || (This:C1470.type=Object type listbox:K79:8)\
		 || (This:C1470.type=Object type subform:K79:40)
		
		This:C1470.scroll:={\
			vertical: $vPosition; \
			horizontal: $hPosition}
		
	Else 
		
		This:C1470.scroll:=$vPosition
		
	End if 
	
	return This:C1470.scroll
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setScrollPosition($vertical : Integer; $horizontal; $firstPosition : Boolean) : cs:C1710.scrollable
	
	// Keep current state
	var $hPosition; $vPosition : Integer
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $vPosition; $hPosition)
	
	// Allow 3rd parameter to be passed as 2nd parameter when `horizontal` is not relevant
	If (Value type:C1509($2)=Is boolean:K8:9)
		
		$firstPosition:=$horizontal
		$horizontal:=$hPosition
		
	Else 
		
		$horizontal:=Num:C11($horizontal)
		
		If (Count parameters:C259=1)
			
			$horizontal:=$hPosition
			
		End if 
	End if 
	
	// The hPosition parameter can be used in the context of a list box or a picture
	If (This:C1470.type=Object type picture input:K79:5)\
		 || (This:C1470.type=Object type listbox:K79:8)
		
		If ($firstPosition)
			
			OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $vertical; $horizontal; *)
			
		Else 
			
			OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $vertical; $horizontal)
			
		End if 
		
		This:C1470.scroll:={\
			vertical: $vertical; \
			horizontal: $horizontal}
		
	Else 
		
		If ($firstPosition)
			
			OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $vertical; *)
			
		Else 
			
			OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $vertical)
			
		End if 
		
		This:C1470.scroll:=$vertical
		
	End if 
	
	return This:C1470
	
	// MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _automaticModeAvailable() : Boolean
	
	// The automatic mode can only be used in the context of a list box, a hierarchical list or a picture
	return Asserted:C1132((This:C1470.type=Object type picture input:K79:5) || (This:C1470.type=Object type listbox:K79:8) || (This:C1470.type=Object type hierarchical list:K79:7); \
		Current method name:C684+" is only available for Picture, Hierarchical list or Listbox!")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _horizontallyScrollable() : Boolean
	
	// The hPosition parameter can only be used in the context of a list box or a picture
	return Asserted:C1132((This:C1470.type=Object type picture input:K79:5) || (This:C1470.type=Object type listbox:K79:8); \
		Current method name:C684+" is only available for Picture or Listbox!")
	