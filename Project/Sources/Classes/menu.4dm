Class constructor($options)
	
	var $c : Collection
	
	This:C1470.ref:=Null:C1517
	This:C1470.autoRelease:=True:C214
	This:C1470.localize:=True:C214
	This:C1470.metacharacters:=False:C215
	This:C1470.selected:=False:C215
	This:C1470.choice:=""
	This:C1470.submenus:=New collection:C1472
	This:C1470.data:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($options)=Is text:K8:3)
				
				Case of 
						
						//______________________________________________________
					: ($options="menuBar")  // Load the current menu bar
						
						This:C1470.ref:=Get menu bar reference:C979
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)\\|MR\\|\\d{12}"; $options; 1))  // Menu reference
						
						This:C1470.ref:=$options
						
						//______________________________________________________
					Else 
						
						This:C1470.ref:=Create menu:C408
						
						$c:=Split string:C1554(String:C10($options); ";")
						
						Case of 
								
								//-----------------
							: ($c.length>1)
								
								This:C1470.autoRelease:=($c.indexOf("keep-reference")=-1)
								This:C1470.metacharacters:=($c.indexOf("display-metacharacters")#-1)
								This:C1470.localize:=($c.indexOf("no-localization")=-1)
								
								//-----------------
							: ($options="no-localization")
								
								This:C1470.localize:=False:C215
								
								//-----------------
							: ($options="keep-reference")
								
								This:C1470.autoRelease:=False:C215
								
								//-----------------
							: ($options="display-metacharacters")
								
								This:C1470.metacharacters:=True:C214
								
								//-----------------
							Else   // Menu bar name
								
								This:C1470.ref:=Create menu:C408($options)
								
								//-----------------
						End case 
						
						//______________________________________________________
				End case 
				//______________________________________________________
			: (Value type:C1509($options)=Is real:K8:4)\
				 | (Value type:C1509($options)=Is longint:K8:6)  // Menu bar number
				
				This:C1470.ref:=Create menu:C408($options)
				
				//______________________________________________________
			: (Value type:C1509($options)=Is collection:K8:32)  // Create from collection
				
				This:C1470.ref:=Create menu:C408
				This:C1470.append($options)
				
				//______________________________________________________
			Else 
				
				This:C1470.ref:=Create menu:C408  // Just a new menu
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.ref:=Create menu:C408  // Just a new menu
		
	End if 
	
	// ===============================================
	// Removes the menu from memory
Function release()
	
	If (This:C1470._isMenu())
		
		RELEASE MENU:C978(This:C1470.ref)
		This:C1470.ref:=Null:C1517
		
	End if 
	
	// ===============================================
	// Adds a new item to the menu
Function append($item; $param; $mark : Boolean) : cs:C1710.menu
	
	var $t : Text
	var $o : Object
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(This:C1470._isMenu()))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($item)=Is text:K8:3)
			
			Case of 
					//______________________________________________________
				: (Length:C16($item)=0)
					
					ASSERT:C1129(Not:C34(Is compiled mode:C492(*)); "❌ It must be an error, because the line will not be created anyway.")
					
					//______________________________________________________
				: (Position:C15(":xliff:"; $item)=1)
					
					// 👍 let 4D do the work
					
					//______________________________________________________
					//%W-533.1
				: ($item[[1]]=Char:C90(1))
					//%W+533.1
					
					// 🤬 The "Get localized string" command does not like it at all.
					
					//______________________________________________________
				: (Not:C34(This:C1470.localize))
					
					// Don't try to localize
					
					//______________________________________________________
				Else 
					
					$t:=Get localized string:C991($item)
					$t:=Length:C16($t)>0 ? $t : $item  // Revert if no localization
					
					//ASSERT(Length($t)>0; "⚠️ An empty item will not be displayed")
					
					//______________________________________________________
			End case 
			
			$t:=Choose:C955(Length:C16($t)>0; $t; $item)
			
			If (Count parameters:C259>=2)
				
				If (Value type:C1509($param)=Is object:K8:27)  // Submenu
					
					If (Asserted:C1132(OB Instance of:C1731($param; cs:C1710.menu)))
						
						If ($param.itemCount()>0)  // Don't do it if there are no items in the sub-menu
							
							If (This:C1470.metacharacters)
								
								APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref)
								
							Else 
								
								APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref; *)
								
							End if 
							
							// Keep the sub-menu structure
							This:C1470.submenus.push($param)
							
							// Keep datas, if any
							For each ($o; $param.data)
								
								This:C1470.data.push($o)
								
							End for each 
						End if 
						
						If ($param.autoRelease)
							
							RELEASE MENU:C978($param.ref)
							
						End if 
						
					End if 
					
				Else 
					
					If (This:C1470.metacharacters)
						
						APPEND MENU ITEM:C411(This:C1470.ref; $t)
						
					Else 
						
						APPEND MENU ITEM:C411(This:C1470.ref; $t; *)
						
					End if 
					
					If (Count parameters:C259>1)
						
						SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; String:C10($param))
						
						If (Count parameters:C259>2)
							
							SET MENU ITEM MARK:C208(This:C1470.ref; -1; Char:C90(18)*Num:C11($mark))
							
						End if 
						
					Else 
						
						// Set the parameter to the same value as the text of the element
						SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $t)
						
					End if 
				End if 
			Else 
				
				If (This:C1470.metacharacters)
					
					APPEND MENU ITEM:C411(This:C1470.ref; $t)
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref; $t; *)
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($item)=Is collection:K8:32)
			
			For each ($o; $item)
				
				If (This:C1470.metacharacters)
					
					APPEND MENU ITEM:C411(This:C1470.ref; String:C10($o.label))
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref; String:C10($o.label); *)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; String:C10($o.parameter))
				SET MENU ITEM MARK:C208(This:C1470.ref; -1; Char:C90(18)*Num:C11($o.marked))
				
				If ($o.action#Null:C1517)
					
					This:C1470.action($o.action)
					
				End if 
				
				If ($o.enabled#Null:C1517)
					
					This:C1470.enable(Bool:C1537($o.enabled))
					
				End if 
				
				If ($o.icon#Null:C1517)
					
					This:C1470.icon(String:C10($o.icon))
					
				End if 
				
				If ($o.method#Null:C1517)
					
					This:C1470.method(String:C10($o.method))
					
				End if 
				
				If ($o.shortcut#Null:C1517)
					
					This:C1470.shortcut($o.shortcut)
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "❌ The 1st parameter, item, must be a Text or a Collection!")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// ===============================================
Function add($ref : Text; $text : Text; $param : Variant; $mark : Boolean)
	
	// TODO: wip
	
	// ===============================================
	// Adds a line to the menu
Function line() : cs:C1710.menu
	
	APPEND MENU ITEM:C411(This:C1470.ref; "-(")
	
	return This:C1470
	
	// ===============================================
	// Defines the project method associated with a menu item
Function method($method : Text; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM METHOD:C982(This:C1470.ref; $index; $method)
		
	Else 
		
		// Last added item
		SET MENU ITEM METHOD:C982(This:C1470.ref; -1; $method)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Delete an item or the last added item
Function delete($index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		DELETE MENU ITEM:C413(This:C1470.ref; -1)
		
	Else 
		
		DELETE MENU ITEM:C413(This:C1470.ref; $index)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Defines the activated status of a menu item
Function enable($enabled : Boolean; $index : Integer) : cs:C1710.menu
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			ENABLE MENU ITEM:C149(This:C1470.ref; -1)
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			If ($enabled)
				
				ENABLE MENU ITEM:C149(This:C1470.ref; -1)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref; -1)
				
			End if 
			
			//______________________________________________________
		Else 
			
			If ($enabled)
				
				ENABLE MENU ITEM:C149(This:C1470.ref; $index)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref; $index)
				
			End if 
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// ===============================================
	// Disable a menu item
Function disable($index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		DISABLE MENU ITEM:C150(This:C1470.ref; -1)
		
	Else 
		
		DISABLE MENU ITEM:C150(This:C1470.ref; $index)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Associate a standard action with a menu item
Function action($action : Variant; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=1)
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; -1; Associated standard action name:K28:8; $action)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; $index; Associated standard action name:K28:8; $action)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Associates a custom parameter to a menu item
Function parameter($param : Text; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $param)
		
	Else 
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; $index; $param)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Associates a property to a menu item
/*
⚠️ ONE CAN SET A PROPERTY FOR ALL MENU TYPE (MENU BAR OR POPUP)
   BUT  UNIQUELY RETRIEVE IT FOR THE MENU BAR ITEMS
*/
Function property($property : Text; $value : Variant; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259>=3)
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; $index; $property; $value)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; -1; $property; $value)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Returns a property of a menu item
Function getProperty($property : Text; $index : Integer)->$value
	
	GET MENU ITEM PROPERTY:C972(This:C1470.ref; $index; $property; $value)
	
	// ===============================================
	// Associates data to a menu item
Function setData($name : Text; $value : Variant; $index : Integer) : cs:C1710.menu
	
	var $ref : Text
	var $o : Object
	
	Case of 
			
			//_____________________________
		: (Count parameters:C259=3)
			
			$ref:=Get menu item parameter:C1003(This:C1470.ref; $index)
			
			//_____________________________
		: (Count parameters:C259=2)
			
			$ref:=Get menu item parameter:C1003(This:C1470.ref; -1)
			
			//_____________________________
		Else 
			
			ASSERT:C1129(False:C215; "Missing parameter")
			
			//_____________________________
	End case 
	
	$o:=This:C1470.data.query("ref = :1 & name = :2"; $ref; $name).pop()
	
	If ($o=Null:C1517)
		
		This:C1470.data.push(New object:C1471(\
			"ref"; $ref; \
			"name"; $name; \
			"value"; $value))
		
	Else 
		
		// Change the current data value
		$o.value:=$value
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Retrieve data associated to selected menu item
Function getData($name : Text; $ref : Text)->$value
	
	var $o : Object
	
	If (Asserted:C1132(This:C1470.selected))
		
		If (Count parameters:C259>=2)
			
			$o:=This:C1470.data.query("name = :1 & ref = :2"; $name; $ref).pop()
			
		Else 
			
			$o:=This:C1470.data.query("name = :1"; $name).pop()
			
		End if 
		
		If ($o#Null:C1517)
			
			$value:=$o.value
			
		End if 
	End if 
	
	// ===============================================
	// Sets the check mark of a menu item
Function mark($checked : Boolean; $index : Integer) : cs:C1710.menu
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			SET MENU ITEM MARK:C208(This:C1470.ref; -1; Char:C90(18))
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			SET MENU ITEM MARK:C208(This:C1470.ref; -1; Char:C90(18)*Num:C11($checked))
			
			//______________________________________________________
		Else 
			
			SET MENU ITEM MARK:C208(This:C1470.ref; $index; Char:C90(18)*Num:C11($checked))
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// ===============================================
	// Replaces the shortcut key associated with the menu item
Function shortcut($key; $modifier : Integer; $index : Integer) : cs:C1710.menu
	
	$index:=($index=0) ? -1 : $index
	
	If (Count parameters:C259>=2)
		
		If (Value type:C1509($key)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; $index; String:C10($key.key); Num:C11($key.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; $index; String:C10($key); $modifier)
			
		End if 
		
	Else 
		
		If (Value type:C1509($key)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; -1; String:C10($key.key); Num:C11($key.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; -1; String:C10($key); 0)
			
		End if 
	End if 
	
	return This:C1470
	
	// ===============================================
	// Modifies the icon associated with a menu item
Function icon($icon : Text; $index : Integer) : cs:C1710.menu
	
	var $path : Text
	
	Case of 
			//______________________________________________________
		: ($icon="path:@")
			
			$path:=$icon
			
			//______________________________________________________
		: ($icon="/RESOURCES/@")
			
			$path:="path:"+$icon
			
			//______________________________________________________
		Else 
			
			$path:="path:/RESOURCES/"+$icon
			
			//______________________________________________________
	End case 
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM ICON:C984(This:C1470.ref; $index; $path)
		
	Else 
		
		SET MENU ITEM ICON:C984(This:C1470.ref; -1; $path)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Changes the font style of the menu item
Function setStyle($tyle : Integer; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM STYLE:C425(This:C1470.ref; $index; $tyle)
		
	Else 
		
		SET MENU ITEM STYLE:C425(This:C1470.ref; -1; $tyle)
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Replaces the current menu bar with the current menu
Function setBar()
	
	This:C1470._cleanup()
	
	SET MENU BAR:C67(This:C1470.ref)
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	// ===============================================
	// Display the current menu as a pop-up menu
Function popup($where : Variant; $x : Variant; $y : Integer) : cs:C1710.menu
	
	This:C1470._cleanup()
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // At the current location of the mouse
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref)
			
			//______________________________________________________
		: (Value type:C1509($where)=Is object:K8:27)  // Widget reference {; default}
			
			If (Count parameters:C259>1)
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref; String:C10($x); Num:C11($where.windowCoordinates.left); Num:C11($where.windowCoordinates.bottom))
				
			Else 
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref; ""; Num:C11($where.windowCoordinates.left); Num:C11($where.windowCoordinates.bottom))
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($where)=Is text:K8:3)  //  default {; x ; y }
			
			If (Count parameters:C259>2)
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref; $where; Num:C11($x); $y)
				
			Else 
				
				This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref; $where)
				
			End if 
			
			//______________________________________________________
		: (Count parameters:C259<2)
			
			ASSERT:C1129(False:C215; "Missing x & y parameters")
			
			//______________________________________________________
		Else   // x ; y  (no item selected)
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref; ""; Num:C11($where); Num:C11($x))
			
			//______________________________________________________
	End case 
	
	This:C1470.selected:=(Length:C16(This:C1470.choice)>0)
	
	If (This:C1470.selected)
		
		// Get associated data if any
		//This.data:=This.data.query("ref=:1"; This.choice)
		
	End if 
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	return This:C1470
	
	// ===============================================
	// Returns the number of menu items present in the menu
Function itemCount()->$number : Integer
	
	$number:=Count menu items:C405(This:C1470.ref)
	
	// ===============================================
Function menuSelected()->$selected : Object
	
	var $menuSelected : Integer
	var $menuRef : Text
	
	$menuSelected:=Menu selected:C152($menuRef)
	
	$selected:=New object:C1471(\
		"ref"; $menuRef; \
		"menu"; $menuSelected\65536; \
		"item"; $menuSelected%65536)
	
	// ===============================================
	// Default File menu
Function file() : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
	
	return This:C1470
	
	// ===============================================
	// Standard Edit menu
Function edit() : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonMenuItemUndo").action(ak undo:K76:51).shortcut("Z")
	This:C1470.append(":xliff:CommonMenuRedo").action(ak redo:K76:52).shortcut("Z"; 512)
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
	This:C1470.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
	This:C1470.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
	This:C1470.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
	This:C1470.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemShowClipboard").action(ak show clipboard:K76:58)
	
	return This:C1470
	
	// ===============================================
	// Fonts menu with or without styles
Function fonts($withStyle : Boolean) : cs:C1710.menu
	
	var $menuStyles : Text
	var $styled : Boolean
	var $i; $j : Integer
	
	If (Count parameters:C259>0)
		
		$styled:=$withStyle
		
	End if 
	
	ARRAY TEXT:C222($fontsFamilly; 0x0000)
	FONT LIST:C460($fontsFamilly)
	
	If ($styled)
		
		For ($i; 1; Size of array:C274($fontsFamilly); 1)
			
			ARRAY TEXT:C222($styles; 0x0000)
			ARRAY TEXT:C222($names; 0x0000)
			
			FONT STYLE LIST:C1362($fontsFamilly{$i}; $styles; $names)
			
			If (Size of array:C274($styles)>0)
				
				If (Size of array:C274($styles)>1)
					
					$menuStyles:=Create menu:C408
					
					For ($j; 1; Size of array:C274($styles); 1)
						
						APPEND MENU ITEM:C411($menuStyles; $styles{$j})  // Localized name
						SET MENU ITEM PARAMETER:C1004($menuStyles; -1; $names{$j})  // System name
						
					End for 
					
					APPEND MENU ITEM:C411(This:C1470.ref; $fontsFamilly{$i}; $menuStyles)  // Familly name
					RELEASE MENU:C978($menuStyles)
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref; $fontsFamilly{$i})
					SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $names{1})
					
				End if 
				
			Else 
				
				This:C1470.append($fontsFamilly{$i}; $fontsFamilly{$i})  // Familly name
				
			End if 
		End for 
		
	Else 
		
		For ($i; 1; Size of array:C274($fontsFamilly); 1)
			
			This:C1470.append($fontsFamilly{$i}; $fontsFamilly{$i})  // Familly name
			
		End for 
	End if 
	
	return This:C1470
	
	// ===============================================
	// Windows menu
Function windows() : cs:C1710.menu
	
	var $name : Text
	var $current; $frontmostWindow; $i : Integer
	var $o : Object
	var $c : Collection
	
	ARRAY LONGINT:C221($windows; 0x0000)
	WINDOW LIST:C442($windows)
	
	$c:=New collection:C1472
	
	For ($i; 1; Size of array:C274($windows); 1)
		
		$c.push(New object:C1471(\
			"ref"; $windows{$i}; \
			"name"; Get window title:C450($windows{$i}); \
			"process"; Window process:C446($windows{$i})))
		
	End for 
	
	$c:=$c.orderBy(New collection:C1472(\
		New object:C1471("propertyPath"; "process"; "descending"; True:C214); \
		New object:C1471("propertyPath"; "name")))
	
	If ($c.length>0)
		
		$frontmostWindow:=Frontmost window:C447
		
		$current:=$c[0].process
		$name:=Substring:C12($c[0].name; 1; Position:C15(":"; $c[0].name))
		
		For each ($o; $c)
			
			If ($o.process#$current)\
				 | (Substring:C12($o.name; 1; Position:C15(":"; $o.name))#$name)
				
				This:C1470.line()
				$current:=$o.process
				$name:=Substring:C12($o.name; 1; Position:C15(":"; $o.name))
				
			End if 
			
			This:C1470.append($o.name; $o.ref; $frontmostWindow=$o.ref)
			
		End for each 
	End if 
	
	return This:C1470
	
	// ===============================================
	// Create a default minimal menu bar
Function defaultMinimalMenuBar() : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonMenuFile"; cs:C1710.menu.new().file())
	This:C1470.append(":xliff:CommonMenuEdit"; cs:C1710.menu.new().edit())
	
	return This:C1470
	
	// ===============================================
	// Returns a menu item from its title or index
Function item($item; $ref : Text)->$menuItem : Object
	
	var $indx : Integer
	var $value
	
	ARRAY TEXT:C222($titles; 0)
	ARRAY TEXT:C222($references; 0)
	
	If (Count parameters:C259>=2)
		
		GET MENU ITEMS:C977($ref; $titles; $references)
		
	Else 
		
		GET MENU ITEMS:C977(This:C1470.ref; $titles; $references)
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($item)=Is text:K8:3)  // -> withTitle
			
			$indx:=Find in array:C230($titles; $item)
			
			//______________________________________________________
		: (Value type:C1509($item)=Is longint:K8:6)\
			 | (Value type:C1509($item)=Is real:K8:4)  // -> at
			
			$indx:=$item
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; Current method name:C684+": invalid type")
			
			//______________________________________________________
	End case 
	
	If (Asserted:C1132($indx>0; "Item \""+String:C10($item)+"\" not found"))
		
		$menuItem:=New object:C1471(\
			"title"; Get menu item:C422(This:C1470.ref; $indx); \
			"key"; Get menu item key:C424(This:C1470.ref; $indx); \
			"mark"; Get menu item mark:C428(This:C1470.ref; $indx); \
			"method"; Get menu item method:C981(This:C1470.ref; $indx); \
			"modifiers"; Get menu item modifiers:C980(This:C1470.ref; $indx); \
			"parameter"; Get menu item parameter:C1003(This:C1470.ref; $indx); \
			"style"; Get menu item style:C426(This:C1470.ref; $indx); \
			"withSubMenu"; Length:C16($references{$indx})>0; \
			"subMenuReference"; $references{$indx}; \
			"isSeparator"; This:C1470.isSeparatorItem($indx)\
			)
		
		$menuItem.data:=This:C1470.data.query("ref = :1"; $menuItem.parameter)
		
		GET MENU ITEM PROPERTY:C972(This:C1470.ref; $indx; Associated standard action:K56:1; $value)
		$menuItem.standardAction:=$value
		
		GET MENU ITEM PROPERTY:C972(This:C1470.ref; $indx; Access privileges:K56:3; $value)
		$menuItem.accessPrivileges:=$value
		
	End if 
	
	// ===============================================
	// Returns a collection of the first level menu items
Function items()->$items : Collection
	
	var $i : Integer
	
	$items:=New collection:C1472
	
	For ($i; 1; This:C1470.itemCount(); 1)
		
		$items.push(This:C1470.item($i))
		
	End for 
	
	// ===============================================
Function itemSubMenuRef($withTitle : Text)->$reference : Text
	
	var $indx : Integer
	
	ARRAY TEXT:C222($titles; 0x0000)
	ARRAY TEXT:C222($references; 0x0000)
	GET MENU ITEMS:C977(This:C1470.ref; $titles; $references)
	
	$indx:=Find in array:C230($titles; $withTitle)
	
	If ($indx#-1)
		
		$reference:=$references{$indx}
		
	End if 
	
	// ===============================================
Function isSeparatorItem($item : Integer)->$isSeparator : Boolean
	
	var $value
	
	Case of 
			
			//________________________________________
		: (Get menu item:C422(This:C1470.ref; $item)="(-@")
			
			$isSeparator:=True:C214
			
			//________________________________________
		: (Get menu item:C422(This:C1470.ref; $item)="-@")
			
			$isSeparator:=True:C214
			
			//________________________________________
		Else 
			
			GET MENU ITEM PROPERTY:C972(This:C1470.ref; $item; "4D_separator"; $value)
			$isSeparator:=($value#0)
			
			//________________________________________
	End case 
	
	// ===============================================
	// Remove duplicates (lines or items)
Function _cleanup()
	
	var $t : Text
	var $b : Boolean
	var $count; $i : Integer
	
	Repeat   // Remove unwanted lines at the top
		
		$count:=Count menu items:C405(This:C1470.ref)
		$b:=($count>0)
		
		If ($b)
			
			$t:=Get menu item:C422(This:C1470.ref; 1)
			$b:=(Length:C16($t)>0)
			
			If ($b)
				
				$b:=($t[[1]]="-")
				
				If ($b)
					
					This:C1470.delete(1)
					
				End if 
			End if 
		End if 
	Until (Not:C34($b))
	
	If ($count>0)
		
		Repeat   // Remove unnecessary lines at the end
			
			$count:=Count menu items:C405(This:C1470.ref)
			$t:=Get menu item:C422(This:C1470.ref; $count)
			$b:=(Length:C16($t)>0)
			
			If ($b)
				
				$b:=($t[[1]]="-")
				
				If ($b)
					
					This:C1470.delete($count)
					
				End if 
			End if 
		Until (Not:C34($b))
	End if 
	
	// Remove duplicates (lines or items)
	For ($i; Count menu items:C405(This:C1470.ref); 2; -1)
		
		If (Get menu item:C422(This:C1470.ref; $i)=Get menu item:C422(This:C1470.ref; $i-1))
			
			This:C1470.delete($i)
			
		End if 
	End for 
	
	// ===============================================
Function _isMenu()->$isMenu : Boolean
	
	If (Asserted:C1132(This:C1470.ref#Null:C1517; Current method name:C684+": The menu reference is null"))
		
		$isMenu:=True:C214
		
	End if 