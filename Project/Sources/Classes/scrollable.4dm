Class extends widget

//=== === === === === === === === === === === === === === === === === === === === === 
Class constructor($name : Text; $datasource)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($name; $datasource)
		
	Else 
		
		Super:C1705($name)
		
	End if 
	
	ASSERT:C1129(New collection:C1472(\
		Object type subform:K79:40; \
		Object type listbox:K79:8; \
		Object type picture input:K79:5; \
		Object type hierarchical list:K79:7; \
		Object type text input:K79:4).indexOf(This:C1470.type)#-1)
	
	This:C1470.getScrollbars()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function getScrollPosition() : Variant
	
	var $h; $v : Integer
	
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $v; $h)
	
	If (This:C1470.type=Object type picture input:K79:5)\
		 | (This:C1470.type=Object type listbox:K79:8)\
		 | (This:C1470.type=Object type subform:K79:40)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical"; $v; \
			"horizontal"; $h)
		
	Else 
		
		This:C1470.scroll:=$v
		
	End if 
	
	return (This:C1470.scroll)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setScrollPosition($vertical; $horizontal) : cs:C1710.scrollable
	
	var $h; $v : Integer
	
	OBJECT GET SCROLL POSITION:C1114(*; This:C1470.name; $v; $h)
	
	$v:=Num:C11($vertical)
	
	If (Count parameters:C259>=2)\
		 & ((This:C1470.type=Object type picture input:K79:5) | (This:C1470.type=Object type listbox:K79:8))
		
		$h:=Num:C11($horizontal)
		
		OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $v; $h; *)
		
		This:C1470.scroll:=New object:C1471(\
			"vertical"; $v; \
			"horizontal"; $h)
		
	Else 
		
		OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $v; *)
		
		This:C1470.scroll:=$v
		
	End if 
	
	return (This:C1470)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function getScrollbars
	
	var $horizontal; $vertical : Integer
	
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	
	This:C1470.scrollbars:=New object:C1471(\
		"vertical"; $vertical; \
		"horizontal"; $horizontal)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setScrollbars($horizontal; $vertical) : cs:C1710.scrollable
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11($horizontal); Num:C11($vertical))
	
	return (This:C1470)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setHorizontalScrollbar($display) : cs:C1710.scrollable
	
	This:C1470.getScrollbars()
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11($display); Num:C11(This:C1470.scrollbar.vertical))
	
	return (This:C1470)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setVerticalScrollbar($display) : cs:C1710.scrollable
	
	This:C1470.getScrollbars()
	
	OBJECT SET SCROLLBAR:C843(*; This:C1470.name; Num:C11(This:C1470.scrollbar.horizontal); Num:C11($display))
	
	return (This:C1470)
	