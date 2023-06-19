Class extends menu

Class constructor($menus : Collection)
	
	var $parameter : Text
	var $i; $itemIndex; $j; $menuIndex : Integer
	
	Super:C1705()
	
	// Build a collection item references, if any
	This:C1470.parameters:=[]
	
	For ($i; 0; $menus.length-1; 2)
		
		$menuIndex+=1
		$itemIndex:=0
		
		This:C1470.append($menus[$i]; $menus[$i+1])
		
		For ($j; 1; $menus[$i+1].itemCount(); 1)
			
			$itemIndex+=1
			$parameter:=Get menu item parameter:C1003($menus[$i+1].ref; $j)
			
			If (Length:C16($parameter)>0)
				
				This:C1470.parameters.push({\
					ref: $parameter; \
					menu: $menuIndex; \
					item: $itemIndex})
				
			End if 
		End for 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replaces the current menu bar with the current one
Function set() : cs:C1710.menuBar
	
	This:C1470._cleanup()
	
	SET MENU BAR:C67(This:C1470.ref)
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function enableItem($item : Text; $enabled : Boolean)
	
	var $o : Object
	
	$o:=This:C1470.parameters.query("ref = :1"; $item).pop()
	
	If (Asserted:C1132($o#Null:C1517; "Item \""+$item+"\" not found"))
		
		If ($enabled)
			
			ENABLE MENU ITEM:C149($o.menu; $o.item)
			
		Else 
			
			DISABLE MENU ITEM:C150($o.menu; $o.item)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function disableItem($item : Text)
	
	var $o : Object
	
	$o:=This:C1470.parameters.query("ref = :1"; $item).pop()
	
	If (Asserted:C1132($o#Null:C1517; "Item \""+$item+"\" not found"))
		
		DISABLE MENU ITEM:C150($o.menu; $o.item)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a default minimal menu bar
Function defaultMinimalMenuBar() : cs:C1710.menuBar
	
	This:C1470.append(":xliff:CommonMenuFile"; cs:C1710.menu.new().file())
	This:C1470.append(":xliff:CommonMenuEdit"; cs:C1710.menu.new().edit())
	
	return This:C1470
	