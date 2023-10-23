property _menus : Collection

Class extends menu

Class constructor($menus : Collection)
	
	var $parameter : Text
	var $i; $itemIndex; $j; $menuIndex : Integer
	
	Super:C1705()
	
	// A collection of menu items that allows to extract one based on the value of its parameter
	This:C1470._menus:=[]
	
	This:C1470.populate($menus)
	
	// MARK:-[Definition]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a menu bar from a collection of menus
Function populate($menus : Collection) : cs:C1710.menuBar
	
	var $parameter : Text
	var $i; $itemIndex; $j; $menuIndex : Integer
	
	// TODO:Accept object instead of collection ?
	
	For ($i; 0; $menus.length-1; 2)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($menus[$i+1])=Is collection:K8:32)
				
				This:C1470.setHelpMenu($menus[$i+1])
				
				//______________________________________________________
			: (Value type:C1509($menus[$i+1])=Is object:K8:27)\
				 && (OB Instance of:C1731($menus[$i+1]; cs:C1710.menu))
				
				$menuIndex+=1
				$itemIndex:=0
				
				This:C1470.append($menus[$i]; $menus[$i+1])
				
				For ($j; 1; $menus[$i+1].itemCount(); 1)
					
					$itemIndex+=1
					$parameter:=Get menu item parameter:C1003($menus[$i+1].ref; $j)
					
					If (Length:C16($parameter)>0)
						
						This:C1470._menus.push({\
							ref: $parameter; \
							menu: $menuIndex; \
							item: $itemIndex})
						
					End if 
				End for 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Neither a cs.menu nor a Help menu definition")
				
				//______________________________________________________
		End case 
	End for 
	
	return This:C1470
	
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
	// Set the Help menu of the application mode
Function setHelpMenu($items : Collection)
	
	SET HELP MENU:C1801($items)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replace a menu with a new one
Function update($index : Integer; $menu : cs:C1710.menu) : cs:C1710.menuBar
	
	var $parameter; $title : Text
	var $i; $item : Integer
	
	ASSERT:C1129($index<=This:C1470.submenus.length; "Unavailabale menu index")
	
	// Retain menu title
	$title:=Get menu item:C422(String:C10(This:C1470.ref); $index)
	
	// Delete the menu
	DELETE MENU ITEM:C413(This:C1470.ref; $index)
	
	If ($index=(This:C1470.itemCount()+1))
		
		This:C1470.append($title; $menu)
		
	Else 
		
		This:C1470.append($title; $menu; $index-1)
		
	End if 
	
	// Update the collection item references
	This:C1470._menus:=This:C1470._menus.query("menu != :1 "; $index)
	
	For ($i; 1; $menu.itemCount(); 1)
		
		$item+=1
		$parameter:=Get menu item parameter:C1003($menu.ref; $i)
		
		If (Length:C16($parameter)>0)
			
			This:C1470._menus.push({\
				ref: $parameter; \
				menu: $index; \
				item: $item})
			
		End if 
	End for 
	
	return This:C1470
	
	// MARK:-[Properties]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function enableItem($item : Text; $enabled : Boolean)
	
	var $o : Object
	
	$o:=This:C1470._menus.query("ref = :1"; $item).pop()
	
	If (Asserted:C1132($o#Null:C1517; "Item \""+$item+"\" not found"))
		
		$enabled:=Count parameters:C259>=2 ? $enabled : True:C214
		
		If ($enabled)
			
			ENABLE MENU ITEM:C149($o.menu; $o.item)
			
		Else 
			
			DISABLE MENU ITEM:C150($o.menu; $o.item)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function disableItem($item : Text)
	
	var $o : Object
	
	$o:=This:C1470._menus.query("ref = :1"; $item).pop()
	
	If (Asserted:C1132($o#Null:C1517; "Item \""+$item+"\" not found"))
		
		DISABLE MENU ITEM:C150($o.menu; $o.item)
		
	End if 
	
	// MARK:-[Informations]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function menuSelected() : Object
	
	var $menuSelected : Integer
	var $menuRef : Text
	
	$menuSelected:=Menu selected:C152($menuRef)
	
	return {\
		ref: $menuRef; \
		menu: $menuSelected\65536; \
		item: $menuSelected%65536\
		}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getMenuItemParameter($type : Integer) : Variant
	
	var $o : Object
	$o:=This:C1470.menuSelected()
	
	return $type=Is longint:K8:6\
		 ? Num:C11(This:C1470._menus.query("menu = :1 & item = :2"; $o.menu; $o.item).pop().ref)\
		 : This:C1470._menus.query("menu = :1 & item = :2"; $o.menu; $o.item).pop().ref
	
	// MARK:-[Tools]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a default minimal menu bar
Function defaultMinimalMenuBar() : cs:C1710.menuBar
	
	This:C1470.append(":xliff:CommonMenuFile"; cs:C1710.menu.new().file())
	This:C1470.append(":xliff:CommonMenuEdit"; cs:C1710.menu.new().edit())
	
	return This:C1470