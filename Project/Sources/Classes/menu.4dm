property __CLASS__ : Object
property data; submenus : Collection
property choice; ref : Text
property autoRelease; released; localize; metacharacters; selected : Boolean
property _iconAccessor : 4D:C1709.Function

Class constructor($data)
	
	var $c : Collection
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.ref:=""
	This:C1470.autoRelease:=True:C214
	This:C1470.released:=False:C215
	This:C1470.localize:=True:C214
	This:C1470.metacharacters:=False:C215
	This:C1470.selected:=False:C215
	This:C1470.choice:=""
	This:C1470.submenus:=[]
	This:C1470.data:=[]
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($data)=Is text:K8:3)
				
				Case of 
						
						//______________________________________________________
					: ($data="menuBar")  // Load the current menu bar
						
						This:C1470.ref:=Get menu bar reference:C979
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)\\|MR\\|\\d{12}"; $data; 1))  // Menu reference
						
						This:C1470.ref:=$data
						
						//______________________________________________________
					Else 
						
						This:C1470.ref:=Create menu:C408
						
						$c:=Split string:C1554(String:C10($data); ";")
						
						Case of 
								
								//-----------------
							: ($c.length>1)
								
								This:C1470.autoRelease:=($c.indexOf("keep-reference")=-1)
								This:C1470.metacharacters:=($c.includes("display-metacharacters"))
								This:C1470.localize:=($c.indexOf("no-localization")=-1)
								
								//-----------------
							: ($data="no-localization")
								
								This:C1470.localize:=False:C215
								
								//-----------------
							: ($data="keep-reference")
								
								This:C1470.autoRelease:=False:C215
								
								//-----------------
							: ($data="display-metacharacters")
								
								This:C1470.metacharacters:=True:C214
								
								//-----------------
							Else   // Menu bar name 
								
								This:C1470.ref:=Try(Create menu:C408($data))
								
								//-----------------
						End case 
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: (Value type:C1509($data)=Is real:K8:4)\
				 | (Value type:C1509($data)=Is longint:K8:6)  // Menu bar number
				
				This:C1470.ref:=Create menu:C408($data)
				
				//______________________________________________________
			: (Value type:C1509($data)=Is collection:K8:32)  // Create from collection
				
				This:C1470.ref:=Create menu:C408
				This:C1470.append($data)
				
				//______________________________________________________
			: (Value type:C1509($data)=Is object:K8:27)
				
				If ($data.localize#Null:C1517)
					
					This:C1470.localize:=$data.localize
					
				End if 
				
				If ($data.autoRelease#Null:C1517)
					
					This:C1470.autoRelease:=$data.autoRelease
					
				End if 
				
				If ($data.metacharacters#Null:C1517)
					
					This:C1470.metacharacters:=$data.metacharacters
					
				End if 
				
				If ($data.iconAccessor#Null:C1517)\
					 && (OB Instance of:C1731($data.iconAccessor; 4D:C1709.Function))
					
					This:C1470._iconAccessor:=$data.iconAccessor
					
				End if 
				
				This:C1470.ref:=Create menu:C408
				
				//______________________________________________________
			Else 
				
				This:C1470.ref:=Create menu:C408  // Just a new menu
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.ref:=Create menu:C408  // Just a new menu
		
	End if 
	
	// MARK:-[DEFINITION]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adds/insert an item
	// If afterItem < 0, it is considered as the offset from the item count of the menu
Function append($item; $param; $mark; $afterItem : Integer) : cs:C1710.menu
	
	var $t : Text
	var $o : Object
	
	If (Value type:C1509($mark)=Is longint:K8:6)\
		 | (Value type:C1509($mark)=Is real:K8:4)
		
		$afterItem:=$mark
		$mark:=False:C215
		
	Else 
		
		$afterItem:=Count parameters:C259>=4 ? $afterItem : MAXLONG:K35:2
		
	End if 
	
	$afterItem:=$afterItem<0 ? This:C1470.itemCount()+$afterItem-1 : $afterItem
	
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
				: (Position:C15(Char:C90(1); $item)=1)
					
					// 😱 The "Get localized string" command does not like it at all.
					
					//______________________________________________________
				: (Not:C34(This:C1470.localize))  // Don't try to localize
					
					If ($item#"-@")\
						 && ($item#"(-@")
						
						// Replace the hyphen by the unicode 2013 (better UI)
						$item:=Replace string:C233($item; "-"; "–")
						
					End if 
					
					//______________________________________________________
				Else 
					
					$t:=Formula from string:C1601("Get localized string:C991($1)"; sk execute in host database:K88:5).call(Null:C1517; $item)
					
					//______________________________________________________
			End case 
			
			$t:=$t || $item
			
			If ($param#Null:C1517)
				
				If (Value type:C1509($param)=Is object:K8:27)  // Submenu
					
					If (Asserted:C1132(OB Instance of:C1731($param; cs:C1710.menu)))
						
						// FIXME:Remove empty submenu in the cleanup phase
						// If ($param.itemCount()>0) // Don't do it if there are no items in the sub-menu
						
						If (This:C1470.metacharacters)
							
							If ($afterItem#MAXLONG:K35:2)
								
								INSERT MENU ITEM:C412(This:C1470.ref; $afterItem; $t; $param.ref)
								
							Else 
								
								APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref)
								
							End if 
							
						Else 
							
							If ($afterItem#MAXLONG:K35:2)
								
								INSERT MENU ITEM:C412(This:C1470.ref; $afterItem; $t; $param.ref; *)
								
							Else 
								
								APPEND MENU ITEM:C411(This:C1470.ref; $t; $param.ref; *)
								
							End if 
						End if 
						
						// Keep the sub-menu structure
						This:C1470.submenus.push($param)
						
						// Keep datas, if any
						For each ($o; $param.data)
							
							This:C1470.data.push($o)
							
						End for each 
						
						// End if
						
						If ($param.autoRelease)
							
							RELEASE MENU:C978($param.ref)
							$param.released:=True:C214
							
						End if 
						
					End if 
					
				Else 
					
					If (This:C1470.metacharacters)
						
						If ($afterItem#MAXLONG:K35:2)
							
							INSERT MENU ITEM:C412(This:C1470.ref; $afterItem; $t)
							
						Else 
							
							APPEND MENU ITEM:C411(This:C1470.ref; $t)
							
						End if 
						
					Else 
						
						If ($afterItem#MAXLONG:K35:2)
							
							INSERT MENU ITEM:C412(This:C1470.ref; $afterItem; $t; *)
							
						Else 
							
							APPEND MENU ITEM:C411(This:C1470.ref; $t; *)
							
						End if 
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
					
					This:C1470.shortcut($o.shortcut; Num:C11($o.modifier))
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "❌ The 1st parameter, item, must be a Text or a Collection!")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function add($ref : Text; $text : Text; $param : Variant; $mark : Boolean)
	
	// TODO: wip - But I don't remember what the purpose was :-(
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adds/insert a line
	// If afterItem < 0, it is considered as the offset from the item count of the menu
Function line($afterItem : Integer) : cs:C1710.menu
	
	If (Count parameters:C259>=1)
		
		$afterItem:=$afterItem<0 ? This:C1470.itemCount()+$afterItem-1 : $afterItem
		INSERT MENU ITEM:C412(This:C1470.ref; $afterItem; "-(")
		
	Else 
		
		APPEND MENU ITEM:C411(This:C1470.ref; "-(")
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete an item or the last added item
Function delete($index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		DELETE MENU ITEM:C413(This:C1470.ref; -1)
		
	Else 
		
		DELETE MENU ITEM:C413(This:C1470.ref; $index)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Removes the menu from memory
Function release()
	
	If (This:C1470._isMenu())
		
		RELEASE MENU:C978(This:C1470.ref)
		This:C1470.released:=True:C214
		
	End if 
	
	// MARK:-[PROPERTIES]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Modifies the icon associated with a menu item
Function icon($proxy : Text; $index : Integer) : cs:C1710.menu
	
	$index:=Count parameters:C259>=2 ? $index : -1
	
	If (This:C1470._iconAccessor#Null:C1517)
		
		This:C1470._iconAccessor.call(Null:C1517; This:C1470.ref; $index; This:C1470._proxy($proxy))
		
	Else 
		
		Formula from string:C1601("SET MENU ITEM ICON:C984($1; $2; $3)"; sk execute in host database:K88:5).call(Null:C1517; This:C1470.ref; $index; This:C1470._proxy($proxy))
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Associates a custom parameter to a menu item
Function parameter($param : Text; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=0)
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $param)
		
	Else 
		
		SET MENU ITEM PARAMETER:C1004(This:C1470.ref; $index; $param)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Associate a standard action with a menu item
Function action($action : Variant; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259=1)
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; -1; Associated standard action name:K28:8; $action)
		
	Else 
		
		SET MENU ITEM PROPERTY:C973(This:C1470.ref; $index; Associated standard action name:K28:8; $action)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Defines the project method associated with a menu item
Function method($method : Text; $index : Integer) : cs:C1710.menu
	
	If (Count parameters:C259>1)
		
		SET MENU ITEM METHOD:C982(This:C1470.ref; $index; $method)
		
	Else 
		
		// Last added item
		SET MENU ITEM METHOD:C982(This:C1470.ref; -1; $method)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Changes the font style of the menu item
Function setStyle($tyle : Integer; $index : Integer) : cs:C1710.menu
	
	$index:=Count parameters:C259>=2 ? $index : -1
	SET MENU ITEM STYLE:C425(This:C1470.ref; $index; $tyle)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function indent($index : Integer; $number : Integer) : cs:C1710.menu
	
	$number:=$number>0 ? $number : 1
	$index:=Count parameters:C259>=1 ? $index : -1
	
	// Special tag for indent on windows
	SET MENU ITEM PROPERTY:C973(This:C1470.ref; $index; "_4D_PictureForIndent"; $number)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Defines the activated status of a menu item
Function enable($enabled : Boolean; $index : Integer) : cs:C1710.menu
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // Enable last added
			
			ENABLE MENU ITEM:C149(This:C1470.ref; -1)
			
			//______________________________________________________
		: (Count parameters:C259=1)  // Enable/disable Last added
			
			If ($enabled)
				
				ENABLE MENU ITEM:C149(This:C1470.ref; -1)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref; -1)
				
			End if 
			
			//______________________________________________________
		Else   // Enable/disable item
			
			If ($enabled)
				
				ENABLE MENU ITEM:C149(This:C1470.ref; $index)
				
			Else 
				
				DISABLE MENU ITEM:C150(This:C1470.ref; $index)
				
			End if 
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Disable a menu item
Function disable($index : Integer) : cs:C1710.menu
	
	$index:=Count parameters:C259>=1 ? $index : -1
	DISABLE MENU ITEM:C150(This:C1470.ref; $index)
	
	return This:C1470
	
	// MARK:-[DATA]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Associates data to a menu item
Function setData($name : Text; $value : Variant; $index : Integer) : cs:C1710.menu
	
	var $ref : Text
	var $o : Object
	
	$index:=Count parameters:C259>=3 ? $index : -1
	$ref:=Get menu item parameter:C1003(This:C1470.ref; $index)
	
	$o:=This:C1470.data.query("ref = :1 & name = :2"; $ref; $name).first()
	
	If ($o=Null:C1517)
		
		This:C1470.data.push({\
			ref: $ref; \
			name: $name; \
			value: $value\
			})
		
	Else 
		
		// Change the current data value
		$o.value:=$value
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Retrieve data associated to selected menu item
Function getData($name : Text; $ref : Text) : Variant
	
	var $o : Object
	
	$o:=Count parameters:C259>=2\
		 ? This:C1470.data.query("name = :1 & ref = :2"; $name; $ref).first()\
		 : This:C1470.data.query("name = :1"; $name).first()
	
	If ($o#Null:C1517)
		
		return $o.value
		
	End if 
	
	// MARK:-[INFORMATIONS]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the number of menu items present in the menu
Function itemCount() : Integer
	
	return Count menu items:C405(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a menu item from its title or index
Function item($item; $ref : Text) : Object
	
	var $menuItem : Object
	var $indx : Integer
	var $value
	
	$ref:=Count parameters:C259>=2 ? $ref : This:C1470.ref
	
	ARRAY TEXT:C222($titles; 0x0000)
	ARRAY TEXT:C222($references; 0x0000)
	GET MENU ITEMS:C977($ref; $titles; $references)
	
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
	
	return $menuItem
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of the first level menu items
Function items() : Collection
	
	var $i : Integer
	var $items : Collection
	
	$items:=[]
	
	For ($i; 1; This:C1470.itemCount(); 1)
		
		$items.push(This:C1470.item($i))
		
	End for 
	
	return $items
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isSeparatorItem($item : Integer; $ref : Text) : Boolean
	
	var $value
	
	$ref:=Count parameters:C259>=2 ? $ref : This:C1470.ref
	
	Case of 
			
			//________________________________________
		: (Get menu item:C422($ref; $item)="(-@")
			
			return True:C214
			
			//________________________________________
		: (Get menu item:C422($ref; $item)="-@")
			
			return True:C214
			
			//________________________________________
		Else 
			
			GET MENU ITEM PROPERTY:C972($ref; $item; "4D_separator"; $value)
			
			return $value#0
			
			//________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function itemSubMenuRef($withTitle : Text) : Text
	
	var $indx : Integer
	
	ARRAY TEXT:C222($titles; 0x0000)
	ARRAY TEXT:C222($references; 0x0000)
	GET MENU ITEMS:C977(This:C1470.ref; $titles; $references)
	
	$indx:=Find in array:C230($titles; $withTitle)
	
	If ($indx#-1)
		
		return $references{$indx}
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a property of a menu item
Function getProperty($property : Text; $index : Integer) : Variant
	
	var $value : Text
	
	GET MENU ITEM PROPERTY:C972(This:C1470.ref; $index; $property; $value)
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$"; $value; 1; *))
			
			return $value="true"
			
		: (Match regex:C1019("(?m-si)^(?:\\+|-)?\\d*\\.*\\d+$"; $value; 1; *))
			
			return Num:C11($value)
			
			//______________________________________________________
		Else 
			
			return $value
			
			//______________________________________________________
	End case 
	
	// MARK:-[TOOLS]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the current menu as a pop-up menu
Function popup($where : Variant; $x : Variant; $y : Integer) : cs:C1710.menu
	
	This:C1470._cleanup()
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)\
			 || ($where=Null:C1517)  // At the current location of the mouse
			
			This:C1470.choice:=Dynamic pop up menu:C1006(This:C1470.ref)
			
			//______________________________________________________
		: (Value type:C1509($where)=Is object:K8:27)  // Widget reference {; default}
			
			Try($where.updateCoordinates())
			
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Standard Edit menu
Function edit() : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonMenuItemUndo").action(ak undo:K76:51).shortcut("Z")
	This:C1470.append(":xliff:CommonMenuRedo").action(ak redo:K76:52).shortcut("Z"; Shift key mask:K16:3)
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
	This:C1470.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
	This:C1470.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
	This:C1470.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
	This:C1470.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemShowClipboard").action(ak show clipboard:K76:58)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Default File menu
Function file() : cs:C1710.menu
	
	This:C1470.append(":xliff:CommonClose").shortcut("W").action(ak cancel:K76:36)
	This:C1470.line()
	This:C1470.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Fonts menu with or without styles
Function fonts($withStyle; $callback : Text) : cs:C1710.menu
	
	var $menuStyles : Text
	var $i; $j : Integer
	
	If (Value type:C1509($withStyle)=Is text:K8:3)
		
		$callback:=$withStyle
		$withStyle:=False:C215
		
	End if 
	
	ARRAY TEXT:C222($fontsFamilly; 0x0000)
	FONT LIST:C460($fontsFamilly)
	
	If ($withStyle)
		
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
						SET MENU ITEM METHOD:C982($menuStyles; -1; $callback)
						
					End for 
					
					APPEND MENU ITEM:C411(This:C1470.ref; $fontsFamilly{$i}; $menuStyles)  // Familly name
					RELEASE MENU:C978($menuStyles)
					
				Else 
					
					APPEND MENU ITEM:C411(This:C1470.ref; $fontsFamilly{$i})
					SET MENU ITEM PARAMETER:C1004(This:C1470.ref; -1; $names{1})
					SET MENU ITEM METHOD:C982(This:C1470.ref; -1; $callback)
					
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Windows menu
Function windows($callback : Text) : cs:C1710.menu
	
	var $name : Text
	var $current; $frontmostWindow; $i : Integer
	var $o : Object
	var $c : Collection
	
	ARRAY LONGINT:C221($windows; 0x0000)
	WINDOW LIST:C442($windows)
	
	$c:=[]
	
	For ($i; 1; Size of array:C274($windows); 1)
		
		$c.push({\
			ref: $windows{$i}; \
			name: Get window title:C450($windows{$i}); \
			process: Window process:C446($windows{$i})\
			})
		
	End for 
	
	$c:=$c.orderBy([\
		{propertyPath: "process"; descending: True:C214}; \
		{propertyPath: "name"}\
		])
	
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
			
			If ($callback#"")
				
				This:C1470.method($callback)
				
			End if 
			
		End for each 
	End if 
	
	return This:C1470
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _isMenu() : Boolean
	
	If (Asserted:C1132(Length:C16(This:C1470.ref)>0; Current method name:C684+": The menu reference is null"))
		
		return True:C214
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _proxy($proxy : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: (Position:C15("path:"; $proxy)=1)\
			 || (Position:C15("file:"; $proxy)=1)\
			 || (Position:C15("var:"; $proxy)=1)\
			 || (Position:C15("!"; $proxy)=1)
			
			return $proxy
			
			//______________________________________________________
		: (Position:C15("#"; $proxy)=1)  // Shortcut for Resources folder
			
			return "path:/RESOURCES/"+Delete string:C232($proxy; 1; 1)
			
			//______________________________________________________
		: (Position:C15("§"; $proxy)=1)  // Shortcut for current form folder
			
			return "path:/FORM/"+Delete string:C232($proxy; 1; 1)
			
			//______________________________________________________
		: ($proxy="|@")
			
			return "path:/.PRODUCT_RESOURCES/"+Delete string:C232($proxy; 1; 1)
			
			//______________________________________________________
		: (Position:C15("/"; $proxy)=1)
			
			return "path:"+$proxy
			
			//______________________________________________________
		Else 
			
			return "path:/RESOURCES/"+$proxy
			
			//______________________________________________________
	End case 
	