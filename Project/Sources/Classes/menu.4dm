Class constructor
	
	C_VARIANT:C1683($1)
	C_COLLECTION:C1488($c)
	
	This:C1470.ref:=Null:C1517
	This:C1470.autoRelease:=True:C214
	This:C1470.metacharacters:=False:C215
	This:C1470.selected:=False:C215
	This:C1470.choice:=""
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($1)=Is text:K8:3)
				
				Case of 
						
						//______________________________________________________
					: ($1="menuBar")
						
						This:C1470.ref:=Get menu bar reference:C979
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)\\|MR\\|\\d{12}"; $1; 1))
						
						// Menu reference
						This:C1470.ref:=$1
						
						//______________________________________________________
					Else 
						
						This:C1470.ref:=Create menu:C408
						
						$c:=Split string:C1554(String:C10($1); ";")
						
						Case of 
								
								//-----------------
							: ($c.length>1)
								
								This:C1470.autoRelease:=($c.indexOf("keepReference")=-1)
								This:C1470.metacharacters:=($c.indexOf("displayMetacharacters")#-1)
								
								//-----------------
							: ($1="keepReference")
								
								This:C1470.autoRelease:=False:C215
								
								//-----------------
							: ($1="displayMetacharacters")
								
								This:C1470.metacharacters:=True:C214
								
								//-----------------
							Else 
								
								// Menu bar name
								This:C1470.ref:=Create menu:C408($1)
								
								//-----------------
						End case 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: (Value type:C1509($1)=Is collection:K8:32)
				
				This:C1470.ref:=Create menu:C408
				This:C1470.append($1)
				
				//______________________________________________________
			: (Value type:C1509($1)=Is real:K8:4)
				
				// Menu bar number
				This:C1470.ref:=Create menu:C408($1)
				
				//______________________________________________________
			Else 
				
				This:C1470.ref:=Create menu:C408
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.ref:=Create menu:C408
		
	End if 
	
	// ===============================================
	// Removes the menu from memory
Function release()
	
	If (This:C1470.__isMenu())
		
		RELEASE MENU:C978(This:C1470.ref)
		This:C1470.ref:=Null:C1517
		
	End if 
	
	// ===============================================
	// Adds a new item to the menu
Function append($item : Variant; $param : Variant; $mark : Boolean)->$this : cs:C1710.menu
	
	var $t : Text
	var $o : Object
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(This:C1470.__isMenu()))
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($item)=Is text:K8:3)
			
			
			If (Length:C16($item)>0)
				//%W-533.1
				If ($item[[1]]#Char:C90(1))
					
					$t:=Get localized string:C991($item)
					
				End if 
				//%W+533.1
			End if 
			
			$t:=Choose:C955(Length:C16($t)>0; $t; $item)
			
			//ASSERT(Length($t)>0; Current method name+": An empty item will not be displayed")
			
			If (Count parameters:C259>=2)
				
				If (Value type:C1509($param)=Is object:K8:27)  // Submenu
					
					If (Asserted:C1132(OB Instance of:C1731($param; cs:C1710.menu)))
						
						If (This:C1470.metacharacters)
							
							APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref)
							
						Else 
							
							APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref; *)
							
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
			
			ASSERT:C1129(False:C215; "The 1st parameter, item, must be a Text or a Collection!")
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	// ===============================================
	// Adds a line to the menu
Function line()->$this : cs:C1710.menu
	
	APPEND MENU ITEM:C411(This:C1470.ref; "-(")
	
	$this:=This:C1470
	
	// ===============================================
	// Defines the project method associated with a menu item
Function method($method : Text; $index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM METHOD:C982(This:C1470.ref; $index; $method)
		
	Else 
		
		// Last added item
		SET MENU ITEM METHOD:C982(This:C1470.ref; -1; $method)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Delete an item or the last added item
Function delete($index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		DELETE MENU ITEM:C413(This:C1470.ref; -1)
		
	Else 
		
		DELETE MENU ITEM:C413(This:C1470.ref; $index)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Defines the activated status of a menu item
Function enable($enabled : Boolean; $index : Integer)->$this : cs:C1710.menu
	
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
	
	$this:=This:C1470
	
	// ===============================================
	// Disable a menu item
Function disable($index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		DISABLE MENU ITEM:C150(This:C1470.ref; -1)
		
	Else 
		
		DISABLE MENU ITEM:C150(This:C1470.ref; $index)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Associate a standard action with a menu item
Function action($action : Variant; $index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259=1)
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; -1; Associated standard action:K28:8; $action)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; $index; Associated standard action:K28:8; $action)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Associates a custom parameter to a menu item
Function parameter($param : Text; $index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $param)
		
	Else 
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; $index; $param)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Associates a property to a menu item
Function property($property : Text; $value : Variant; $index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259>=3)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; $index; $property; $value)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; -1; $property; $value)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Sets the check mark of a menu item
Function mark($checked : Boolean; $index : Integer)->$this : cs:C1710.menu
	
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
	
	$this:=This:C1470
	
	// ===============================================
	// Replaces the shortcut key associated with the menu item
Function shortcut($key : Variant; $index : Integer)->$this : cs:C1710.menu
	
	If (Count parameters:C259>=2)
		
		If (Value type:C1509($key)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; $index; String:C10($key.key); Num:C11($key.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; $index; String:C10($key); 0)
			
		End if 
		
	Else 
		
		If (Value type:C1509($key)=Is object:K8:27)
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; -1; String:C10($key.key); Num:C11($key.modifier))
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423(This:C1470.ref; -1; String:C10($key); 0)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Modifies the icon associated with a menu item
Function icon($icon : Text; $index : Integer)->$this : cs:C1710.menu
	
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
		
		SET MENU ITEM ICON:C984(This:C1470.ref; $2; $path)
		
	Else 
		
		SET MENU ITEM ICON:C984(This:C1470.ref; -1; $path)
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Replaces the current menu bar with the current menu
Function setBar()
	
	This:C1470.__cleanup()
	
	SET MENU BAR:C67(This:C1470.ref)
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	// ===============================================
	// Display the current menu as a pop-up menu
Function popup($where : Variant; $x : Variant; $y : Integer)->$this : cs:C1710.menu
	
	C_VARIANT:C1683($1)
	C_VARIANT:C1683($2)
	C_LONGINT:C283($3)
	
	This:C1470.__cleanup()
	
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
	
	If (This:C1470.autoRelease)
		
		This:C1470.release()
		
	End if 
	
	$this:=This:C1470
	
	// ===============================================
	// Returns the number of menu items present in the menu
Function itemCount()->$number : Integer
	
	$number:=Count menu items:C405(This:C1470.ref)
	
	// ===============================================
	// Default File menu
Function file()->$this : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
	
	$this:=This:C1470
	
	// ===============================================
	// Standard Edit menu
Function edit()->$this : cs:C1710.menu
	
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
	
	$this:=This:C1470
	
	// ===============================================
	// Fonts menu with or without styles
Function fonts($withStyle : Boolean)->$this : cs:C1710.menu
	
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
	
	$this:=This:C1470
	
	// ===============================================
	// Windows menu
Function windows()->$this : cs:C1710.menu
	
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
	
	$this:=This:C1470
	
	// ===============================================
	// Returns menu items as collection
Function items()->$items : Collection
	
	C_LONGINT:C283($i)
	
	ARRAY TEXT:C222($labels; 0x0000)
	ARRAY TEXT:C222($references; 0x0000)
	GET MENU ITEMS:C977(This:C1470.ref; $labels; $references)
	
	$items:=New collection:C1472
	
	For ($i; 1; Size of array:C274($labels); 1)
		
		$items.push(New object:C1471(\
			"item"; $labels{$i}; \
			"ref"; $references{$i}))
		
	End for 
	
/*===============================================*/
Function getReference
	
	C_TEXT:C284($0)
	C_VARIANT:C1683($1)
	
	C_LONGINT:C283($indx)
	
	ARRAY TEXT:C222($aT_titles; 0)
	ARRAY TEXT:C222($aT_refs; 0)
	GET MENU ITEMS:C977(This:C1470.ref; $aT_titles; $aT_refs)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$indx:=Find in array:C230($aT_titles; $1)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is real:K8:4)
			
			$indx:=$1
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; Current method name:C684+": invalid type")
			
			//______________________________________________________
	End case 
	
	If (Asserted:C1132($indx>0; "Item \""+String:C10($1)+"\" not found"))
		
		$0:=$aT_refs{$indx}
		
	End if 
	
	// ===============================================
	// Remove duplicates (lines or items)
Function __cleanup()
	
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
Function __isMenu()->$isMenu : Boolean
	
	If (Asserted:C1132(This:C1470.ref#Null:C1517; Current method name:C684+": The menu reference is null"))
		
		$isMenu:=True:C214
		
	End if 