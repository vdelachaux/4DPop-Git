
Class extends scrollable

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text; $datasource)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($name; $datasource)
		
	Else 
		
		Super:C1705($name)
		
	End if 
	
	ASSERT:C1129(This:C1470.type=Object type listbox:K79:8)
	
	This:C1470.isCollection:=Is nil pointer:C315(OBJECT Get data source:C1265(*; This:C1470.name))
	
	If (This:C1470.isCollection)
		
		This:C1470.item:=Null:C1517
		This:C1470.itemPosition:=0
		This:C1470.items:=Null:C1517
		
	End if 
	
	// Backup design properties
	This:C1470.saveProperties()
	
	//mark:-[READ ONLY]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Gives the number of columns
Function get columnsNumber() : Integer
	
	return LISTBOX Get number of columns:C831(*; This:C1470.name)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Gives the number of rows
Function get rowsNumber() : Integer
	
	return LISTBOX Get number of rows:C915(*; This:C1470.name)
	
	//mark:-[READ & WRITE]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get movableLines() : Boolean
	
	return Bool:C1537(LISTBOX Get property:C917(*; This:C1470.name; lk movable rows:K53:76))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set movableLines($on : Boolean)
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk movable rows:K53:76; $on ? lk yes:K53:69 : lk no:K53:68)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get selectable() : Boolean
	
	return Bool:C1537(LISTBOX Get property:C917(*; This:C1470.name; lk selection mode:K53:35))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set selectable($on : Boolean)
	
	If ($on)
		
		// Try to restore design selection mode
		LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk selection mode:K53:35; Num:C11(This:C1470.properties.selectionMode)=0 ? lk yes:K53:69 : This:C1470.properties.selectionMode)
		
	Else 
		
		LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk selection mode:K53:35; lk no:K53:68)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get singleSelection() : Boolean
	
	return LISTBOX Get property:C917(*; This:C1470.name; lk selection mode:K53:35)=lk single:K53:58
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set singleSelection($on : Boolean)
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk selection mode:K53:35; $on ? lk single:K53:58 : lk multiple:K53:59)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get multipleSelection() : Boolean
	
	return LISTBOX Get property:C917(*; This:C1470.name; lk selection mode:K53:35)=lk multiple:K53:59
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set multipleSelection($on : Boolean)
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk selection mode:K53:35; $on ? lk multiple:K53:59 : lk single:K53:58)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get sortable() : Boolean
	
	return Bool:C1537(LISTBOX Get property:C917(*; This:C1470.name; lk sortable:K53:45))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set sortable($on : Boolean)
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk sortable:K53:45; $on ? lk yes:K53:69 : lk no:K53:68)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get selectionHighlight() : Boolean
	
	return Bool:C1537(LISTBOX Get property:C917(*; This:C1470.name; lk hide selection highlight:K53:41))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set selectionHighlight($on : Boolean) : cs:C1710.listbox
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; lk hide selection highlight:K53:41; $on ? lk yes:K53:69 : lk no:K53:68)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get dataSourceType() : Text
	
	var $name : Text
	var $table : Integer
	
	LISTBOX GET TABLE SOURCE:C1014(*; This:C1470.name; $table; $name)
	
	If ($table>0)
		
		return Length:C16($name)=0 ? "Current Selection" : "Named Selection"
		
	Else 
		
		Case of 
				
				//–––––––––––––––––––––––––––––––––
			: (This:C1470._pointer=Null:C1517)
				
				//–––––––––––––––––––––––––––––––––
			: (Type:C295(This:C1470._pointer->)=Is collection:K8:32)
				
				return "Collection"
				
				//–––––––––––––––––––––––––––––––––
			: (Type:C295(This:C1470._pointer->)=Boolean array:K8:21)
				
				return "Array"
				
				//–––––––––––––––––––––––––––––––––
			: (Type:C295(This:C1470._pointer->)=Is longint:K8:6)\
				 | (Type:C295(This:C1470._pointer->)=Is real:K8:4)
				
				return "Entity Selection"
				
				//–––––––––––––––––––––––––––––––––
		End case 
	End if 
	
	//mark:-
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Giving a column, a header or a footer name, returns the corresponding column pointer
	// ⚠️ Could return a nil pointer if the colunmn isn't found or if column data source is an expression
Function columnPtr($name : Text) : Pointer
	
	var $indx : Integer
	
	ARRAY BOOLEAN:C223($isVisible; 0)
	ARRAY POINTER:C280($columnsPtr; 0)
	ARRAY POINTER:C280($footersPtr; 0)
	ARRAY POINTER:C280($headersPtr; 0)
	ARRAY POINTER:C280($stylesPtr; 0)
	ARRAY TEXT:C222($columns; 0)
	ARRAY TEXT:C222($footers; 0)
	ARRAY TEXT:C222($headers; 0)
	
	LISTBOX GET ARRAYS:C832(*; This:C1470.name; \
		$columns; $headers; \
		$columnsPtr; $headersPtr; \
		$isVisible; \
		$stylesPtr; \
		$footers; $footersPtr)
	
	$indx:=Find in array:C230($columns; $name)
	
	If ($indx>0)
		
		return $columnsPtr{$indx}
		
	Else 
		
		$indx:=Find in array:C230($headers; $name)
		
		If ($indx>0)
			
			return $columnsPtr{$indx}
			
		Else 
			
			$indx:=Find in array:C230($footers; $name)
			
			If ($indx>0)
				
				return $columnsPtr{$indx}
				
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Giving a column, a header or a footer name, returns the corresponding column number
Function columnNumber($name : Text) : Integer
	
	var $indx : Integer
	
	ARRAY BOOLEAN:C223($isVisible; 0)
	ARRAY POINTER:C280($columnsPtr; 0)
	ARRAY POINTER:C280($footersPtr; 0)
	ARRAY POINTER:C280($headersPtr; 0)
	ARRAY POINTER:C280($stylesPtr; 0)
	ARRAY TEXT:C222($columns; 0)
	ARRAY TEXT:C222($footers; 0)
	ARRAY TEXT:C222($headers; 0)
	
	LISTBOX GET ARRAYS:C832(*; This:C1470.name; \
		$columns; $headers; \
		$columnsPtr; $headersPtr; \
		$isVisible; \
		$stylesPtr; \
		$footers; $footersPtr)
	
	$indx:=Find in array:C230($columns; $name)
	
	If ($indx=-1)
		
		$indx:=Find in array:C230($headers; $name)
		
		If ($indx=-1)
			
			$indx:=Find in array:C230($footers; $name)
			
		End if 
	End if 
	
	return $indx
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Current cell indexes {column,row}
Function cellPosition($e : Object) : Object
	
	var $button; $column; $row; $x; $y : Integer
	
	$e:=$e || FORM Event:C1606
	
	If ($e.code=On Clicked:K2:4)\
		 | ($e.code=On Double Clicked:K2:5)
		
		LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $column; $row)
		
	Else 
		
		GET MOUSE:C468($x; $y; $button)
		LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $x; $y; $column; $row)
		
	End if 
	
	return New object:C1471(\
		"column"; $column; \
		"row"; $row)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ 
Function getCoordinates() : Object
	
	This:C1470.getScrollPosition()
	This:C1470.getScrollbars()
	This:C1470.updateDefinition()
	This:C1470.updateCell()
	
	return Super:C1706.getCoordinates()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a row coordinates
Function rowCoordinates($row : Integer) : Object
	
	var $l; $bottom; $left; $right; $top; $width : Integer
	var $horizontal; $vertical : Boolean
	
	This:C1470.getCoordinates()
	
	LISTBOX GET CELL COORDINATES:C1330(*; This:C1470.name; 1; $row; $left; $top; $l; $l)
	LISTBOX GET CELL COORDINATES:C1330(*; This:C1470.name; This:C1470.columnsNumber; $row; $l; $l; $right; $bottom)
	
	// Adjust according to the visible part
	$left:=($left<This:C1470.coordinates.left) ? This:C1470.coordinates.left : $left
	$top:=($top<This:C1470.coordinates.top) ? This:C1470.coordinates.top : $top
	
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	$width:=$vertical ? LISTBOX Get property:C917(*; This:C1470.name; lk ver scrollbar width:K53:9) : 0
	
	$right:=($right>(This:C1470.coordinates.right-$width)) ? This:C1470.coordinates.right-$width : $right
	
	$bottom:=($bottom>This:C1470.coordinates.bottom) ? This:C1470.coordinates.bottom : $bottom
	
	return New object:C1471(\
		"left"; $left; \
		"top"; $top; \
		"right"; $right; \
		"bottom"; $bottom)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function cellCoordinates($column : Integer; $row : Integer) : Object
	
	var $bottom; $left; $right; $top : Integer
	var $e : Object
	
	If (Count parameters:C259=0)
		
		$e:=FORM Event:C1606
		
		If ($e.column#Null:C1517)
			
			$column:=$e.column
			$row:=$e.row
			
		End if 
	End if 
	
	// Mark: TURNAROUND
	If ($row<=0)
		
		LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $column; $row)
		
	End if 
	
	LISTBOX GET CELL COORDINATES:C1330(*; This:C1470.name; $column; $row; $left; $top; $right; $bottom)
	
	This:C1470.cellBox:=This:C1470.cellBox || New object:C1471
	
	This:C1470.cellBox.left:=$left
	This:C1470.cellBox.top:=$top
	This:C1470.cellBox.right:=$right
	This:C1470.cellBox.bottom:=$bottom
	
	return This:C1470.cellBox
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Gives the number of selected rows
Function selected() : Integer
	
	return Count in array:C907((This:C1470.pointer)->; True:C214)
	
	// MARK: - [SELECTION]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Select row(s)
Function select($row : Integer) : cs:C1710.listbox
	
	If (Count parameters:C259=0)
		
		// Select all rows
		LISTBOX SELECT ROW:C912(*; This:C1470.name; 0; lk replace selection:K53:1)
		
	Else 
		
		// #TO_DO: use a collection for multiple selection
		LISTBOX SELECT ROW:C912(*; This:C1470.name; $row; lk replace selection:K53:1)
		
	End if 
	
	OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $row)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Unselect row(s)
Function unselect($row : Integer) : cs:C1710.listbox
	
	If (Count parameters:C259=0)
		
		// Unselect all rows
		LISTBOX SELECT ROW:C912(*; This:C1470.name; 0; lk remove from selection:K53:3)
		
	Else 
		
		// #TO_DO: use a collection for multiple selection
		LISTBOX SELECT ROW:C912(*; This:C1470.name; $row; lk remove from selection:K53:3)
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Select the last row
Function selectFirstRow() : cs:C1710.listbox
	
	If (LISTBOX Get number of rows:C915(*; This:C1470.name)>0)
		
		This:C1470.select(1)
		
	Else 
		
		This:C1470.unselect()
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Select the last row
Function selectLastRow() : cs:C1710.listbox
	
	This:C1470.select(This:C1470.rowsNumber)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Select the last touched row (last mouse click, last selection made via the keyboard or last drop)
Function autoSelect()
	
	This:C1470.select(This:C1470.cellPosition().row)
	This:C1470.touch()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Selects the given row if possible, else the most appropiate one
	// Useful to maintain a selection after a deletion
Function doSafeSelect($row : Integer) : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; 0; lk remove from selection:K53:3)
	
	Case of 
			
			//______________________________
		: ($row<=This:C1470.rowsNumber)
			
			return This:C1470.select($row)
			
			//______________________________
		: (This:C1470.rowsNumber>0)
			
			return This:C1470.select(This:C1470.rowsNumber)
			
			//______________________________
		Else 
			
			return This:C1470.unselect()
			
			//______________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function selectAll() : cs:C1710.listbox
	
	return This:C1470.select()
	
	// MARK: - 
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function edit($target; $item : Integer)
	
	If (Value type:C1509($target)=Is object:K8:27)  // ⚠️ Should be an event object
		
		ASSERT:C1129($target.columnName#Null:C1517)
		
		If ($target.row#Null:C1517)
			
			EDIT ITEM:C870(*; String:C10($target.columnName); Num:C11($target.row))
			
		Else 
			
			If (Count parameters:C259=1)  // Current item
				
				EDIT ITEM:C870(*; String:C10($target.columnName))
				
			Else 
				
				EDIT ITEM:C870(*; String:C10($target.columnName); $item)
				
			End if 
			
		End if 
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: (Count parameters:C259=0)  // First editable column of the current row
				
				ARRAY BOOLEAN:C223($isVisible; 0)
				ARRAY POINTER:C280($columnsPtr; 0)
				ARRAY POINTER:C280($footersPtr; 0)
				ARRAY POINTER:C280($headersPtr; 0)
				ARRAY POINTER:C280($stylesPtr; 0)
				ARRAY TEXT:C222($columns; 0)
				
				LISTBOX GET ARRAYS:C832(*; This:C1470.name; \
					$columns; $headers; \
					$columnsPtr; $headersPtr; \
					$isVisible; \
					$stylesPtr)
				
				var $i : Integer
				For ($i; 1; Size of array:C274($columns); 1)
					
					If (OBJECT Get enterable:C1067(*; $columns{$i})) & (OBJECT Get visible:C1075(*; $columns{$i}))
						
						EDIT ITEM:C870(*; $columns{$i})
						break
						
					End if 
				End for 
				
				//______________________________________________________
			: (Count parameters:C259=1)  // Current item
				
				EDIT ITEM:C870(*; String:C10($target))
				
				//______________________________________________________
			Else 
				
				EDIT ITEM:C870(*; String:C10($target); $item)
				
				//______________________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Reveal the row
Function reveal($row : Integer) : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; $row; lk replace selection:K53:1)
	OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $row)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update the listbox columns/rows definition
Function updateDefinition() : cs:C1710.listbox
	
	var $key : Text
	var $i : Integer
	var $o : Object
	
	ARRAY TEXT:C222($columns; 0)
	ARRAY TEXT:C222($footers; 0)
	ARRAY TEXT:C222($headers; 0)
	ARRAY BOOLEAN:C223($isVisible; 0)
	ARRAY POINTER:C280($columnsPtr; 0)
	ARRAY POINTER:C280($footersPtr; 0)
	ARRAY POINTER:C280($headersPtr; 0)
	ARRAY POINTER:C280($stylesPtr; 0)
	
	LISTBOX GET ARRAYS:C832(*; This:C1470.name; \
		$columns; $headers; \
		$columnsPtr; $headersPtr; \
		$isVisible; \
		$stylesPtr; \
		$footers; $footersPtr)
	
	This:C1470.definition:=New collection:C1472
	
	ARRAY TO COLLECTION:C1563(This:C1470.definition; \
		$columns; "name"; \
		$headers; "header"; \
		$footers; "footer")
	
	This:C1470.columns:=New object:C1471
	
	$o:=This:C1470._columnProperties()
	
	For ($i; 1; Size of array:C274($columns); 1)
		
		This:C1470.columns[$columns{$i}]:=New object:C1471(\
			"number"; $i; \
			"visible"; $isVisible{$i}; \
			"enterable"; OBJECT Get enterable:C1067(*; $columns{$i}); \
			"height"; LISTBOX Get row height:C1408(*; This:C1470.name; $i); \
			"pointer"; $columnsPtr{$i})
		
		For each ($key; $o)
			
			This:C1470.columns[$columns{$i}][$key]:=LISTBOX Get property:C917(*; $columns{$i}; $o[$key].k)
			
		End for each 
	End for 
	
	This:C1470.getScrollbars()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update the current cell indexes and coordinates
Function updateCell() : cs:C1710.listbox
	
	This:C1470.cellCoordinates()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Displays a cs.menu at the bottom left of the current cell
Function popup($menu : cs:C1710.menu; $default : Text) : cs:C1710.menu
	
	var $bottom; $left : Integer
	var $coordinates : Object
	
	$coordinates:=This:C1470.cellCoordinates()
	
	$left:=$coordinates.left
	$bottom:=$coordinates.bottom
	
	CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Current window:K27:6)
	
	If (Count parameters:C259=1)
		
		$menu.popup(""; $left; $bottom)
		
	Else 
		
		$menu.popup($default; $left; $bottom)
		
	End if 
	
	return $menu
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showColumn($column; $visible : Boolean) : cs:C1710.listbox
	
	var $o : Object
	
	$visible:=Count parameters:C259>=2 ? $visible : True:C214
	
	This:C1470.updateDefinition()
	
	If (Value type:C1509($column)=Is real:K8:4) | (Value type:C1509($column)=Is longint:K8:6)
		
		If (Asserted:C1132($column<=This:C1470.definition.length; "Index out of range"))
			
			OBJECT SET VISIBLE:C603(*; This:C1470.definition[$column].name; $visible)
			
		End if 
		
	Else 
		
		$o:=This:C1470.definition.query("name = "; String:C10($column)).pop()
		
		If (Asserted:C1132($o#Null:C1517; "Unknown column name"))
			
			OBJECT SET VISIBLE:C603(*; $o.name; $visible)
			
		End if 
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hideColumn($column) : cs:C1710.listbox
	
	return This:C1470.showColumn($column; False:C215)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clear() : cs:C1710.listbox
	
	var $o : Object
	
	This:C1470.updateDefinition()
	
	For each ($o; This:C1470.definition)
		
		CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5; $o.name)->)
		
	End for each 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deleteRows($row : Integer) : cs:C1710.listbox
	
	If (Count parameters:C259=0)
		
		// Delete all rows
		LISTBOX DELETE ROWS:C914(*; This:C1470.name; 1; This:C1470.rowsNumber)
		
	Else 
		
		// #TO_DO: use a collection for multiple deletion
		LISTBOX DELETE ROWS:C914(*; This:C1470.name; $row; 1)
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns all properties of a column or the listbox
Function getProperties($column : Text) : Object
	
	var $key; $target : Text
	var $o; $properties : Object
	
	If (Count parameters:C259>=1)
		
		$target:=$column
		$o:=This:C1470._columnProperties()
		
	Else 
		
		$target:=This:C1470.name
		$o:=This:C1470._listboxProperties()
		
	End if 
	
	$properties:=New object:C1471
	
	For each ($key; $o)
		
		$properties[$key]:=LISTBOX Get property:C917(*; $target; $o[$key].k)
		
	End for each 
	
	return $properties
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getProperty($property : Integer; $column : Text) : Variant
	
	If (Count parameters:C259=0)
		
		return LISTBOX Get property:C917(*; This:C1470.name; $property)
		
	Else 
		
		return LISTBOX Get property:C917(*; $column; $property)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function withSelectionHighlight($enabled : Boolean) : cs:C1710.listbox
	
	return This:C1470.setProperty(lk hide selection highlight:K53:41; $enabled ? lk yes:K53:69 : lk no:K53:68)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function withoutSelectionHighlight() : cs:C1710.listbox
	
	return This:C1470.withSelectionHighlight(False:C215)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setMovableLines($enabled : Boolean) : cs:C1710.listbox
	
	$enabled:=Count parameters:C259>=1 ? $enabled : True:C214
	
	This:C1470.setProperty(lk movable rows:K53:76; $enabled ? lk yes:K53:69 : lk no:K53:68)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNotMovableLines() : cs:C1710.listbox
	
	return This:C1470.setMovableLines(False:C215)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSelectable($enabled : Boolean; $mode : Integer) : cs:C1710.listbox
	
	If (Count parameters:C259=0)
		
		// Restore design mode definition
		return This:C1470.setProperty(lk selection mode:K53:35; This:C1470.properties.selectionMode)
		
	Else 
		
		$enabled:=Count parameters:C259>=1 ? $enabled : True:C214
		return $enabled ? This:C1470.setProperty(lk selection mode:K53:35; $mode) : This:C1470.setProperty(lk selection mode:K53:35; lk none:K53:57)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNotSelectable() : cs:C1710.listbox
	
	return This:C1470.setSelectable(False:C215)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSingleSelectable() : cs:C1710.listbox
	
	return This:C1470.setProperty(lk selection mode:K53:35; lk single:K53:58)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setMultipleSelectable() : cs:C1710.listbox
	
	return This:C1470.setProperty(lk selection mode:K53:35; lk multiple:K53:59)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSortable($enabled : Boolean) : cs:C1710.listbox
	
	$enabled:=Count parameters:C259>=1 ? $enabled : True:C214
	return This:C1470.setProperty(lk sortable:K53:45; $enabled ? lk yes:K53:69 : lk no:K53:68)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNotSortable() : cs:C1710.listbox
	
	return This:C1470.setSortable(False:C215)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setProperty($property : Integer; $value) : cs:C1710.listbox
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; $property; $value)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setRowsHeight($height : Integer; $unit : Integer) : cs:C1710.listbox
	
	LISTBOX SET ROWS HEIGHT:C835(*; This:C1470.name; $height; $unit)
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function saveProperties()
	
	var $key : Text
	var $unit : Integer
	var $o; $properties : Object
	
	$properties:=New object:C1471
	
	$o:=This:C1470._listboxProperties()
	
	For each ($key; $o)
		
		$properties[$key]:=LISTBOX Get property:C917(*; This:C1470.name; $o[$key].k)
		
	End for each 
	
	$properties.headerHeight:=LISTBOX Get headers height:C1144(*; This:C1470.name)
	$properties.footerHeight:=LISTBOX Get footers height:C1146(*; This:C1470.name)
	
	If (Bool:C1537($properties.autoRowHeight))
		
		$properties.rowMaxHeight:=LISTBOX Get auto row height:C1502(*; This:C1470.name; lk row max height:K53:74)
		$properties.rowMinHeight:=LISTBOX Get auto row height:C1502(*; This:C1470.name; lk row min height:K53:73)
		
	Else 
		
		$properties.rowsHeight:=LISTBOX Get rows height:C836(*; This:C1470.name)
		
	End if 
	
	var $horizontal; $vertical : Integer
	OBJECT GET SCROLLBAR:C1076(*; This:C1470.name; $horizontal; $vertical)
	$properties.horScrollbar:=$horizontal
	$properties.verScrollbar:=$vertical
	
	$o:=This:C1470.colors
	$properties.foreground:=$o.foreground
	$properties.background:=$o.background
	$properties.altBackground:=$o.altBackground
	
	This:C1470.properties:=$properties
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreProperties()
	
	var $key : Text
	var $o; $properties : Object
	
	$properties:=This:C1470.properties
	$o:=This:C1470._listboxProperties()
	
	For each ($key; $o)
		
		LISTBOX SET PROPERTY:C1440(*; This:C1470.name; $o[$key].k; $properties[$key])
		
	End for each 
	
	LISTBOX SET FOOTERS HEIGHT:C1145(*; This:C1470.name; $properties.footerHeight)
	LISTBOX SET HEADERS HEIGHT:C1143(*; This:C1470.name; $properties.headerHeight)
	
	If (Bool:C1537($properties.autoRowHeight))
		
		LISTBOX SET AUTO ROW HEIGHT:C1501(*; This:C1470.name; lk row max height:K53:74; $properties.rowMaxHeight; lk pixels:K53:22)
		LISTBOX SET AUTO ROW HEIGHT:C1501(*; This:C1470.name; lk row min height:K53:73; $properties.rowMinHeight; lk pixels:K53:22)
		
	Else 
		
		LISTBOX SET ROWS HEIGHT:C835(*; This:C1470.name; $properties.rowsHeight)
		
	End if 
	
	This:C1470.setScrollbars($properties.horScrollbar; $properties.verScrollbar)
	
	OBJECT SET RGB COLORS:C628(*; This:C1470.name; $properties.foreground; $properties.background; $properties.altBackground)
	
	//mark:-[PRIVATE]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _listboxProperties() : Object
	
	var $o : Object
	
	$o:=This:C1470._commonProperties()
	
	$o.detailFormName:=New object:C1471("k"; lk detail form name:K53:44)
	$o.displayFooter:=New object:C1471("k"; lk display footer:K53:20)
	$o.displayHeader:=New object:C1471("k"; lk display header:K53:4)
	$o.doubleClickOnRow:=New object:C1471("k"; lk double click on row:K53:43)
	$o.extraRows:=New object:C1471("k"; lk extra rows:K53:38)
	$o.hideSelectionHighlight:=New object:C1471("k"; lk hide selection highlight:K53:41)
	$o.highlightSet:=New object:C1471("k"; lk highlight set:K53:66)
	$o.horScrollbarHeight:=New object:C1471("k"; lk hor scrollbar height:K53:7)
	$o.movableRows:=New object:C1471("k"; lk movable rows:K53:76)
	$o.namedSelection:=New object:C1471("k"; lk named selection:K53:67)
	$o.resizingMode:=New object:C1471("k"; lk resizing mode:K53:36)
	$o.rowHeightUnit:=New object:C1471("k"; lk row height unit:K53:42)
	$o.selectionMode:=New object:C1471("k"; lk selection mode:K53:35)
	$o.singleClickEdit:=New object:C1471("k"; lk single click edit:K53:70)
	$o.sortable:=New object:C1471("k"; lk sortable:K53:45)
	$o.verScrollbarWidth:=New object:C1471("k"; lk ver scrollbar width:K53:9)
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.isCollection)
			
			$o.metaExpression:=New object:C1471("k"; lk meta expression:K53:75)
			
			//______________________________________________________
	End case 
	
	return $o
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _columnProperties() : Object
	
	var $o : Object
	
	$o:=This:C1470._commonProperties()
	
	$o.allowWordwrap:=New object:C1471("k"; lk allow wordwrap:K53:39)
	$o.columnMaxWidth:=New object:C1471("k"; lk column max width:K53:51)
	$o.columnMinWidth:=New object:C1471("k"; lk column min width:K53:50)
	$o.columnResizable:=New object:C1471("k"; lk column resizable:K53:40)
	$o.displayType:=New object:C1471("k"; lk display type:K53:46)
	$o.multiStyle:=New object:C1471("k"; lk multi style:K53:71)
	
	return $o
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _commonProperties() : Object
	
	var $o : Object
	$o:=New object:C1471
	
	$o.autoRowHeight:=New object:C1471("k"; lk auto row height:K53:72)
	$o.backgroundColorExpression:=New object:C1471("k"; lk background color expression:K53:47)
	$o.cellHorizontalPadding:=New object:C1471("k"; lk cell horizontal padding:K53:77)
	$o.cellVerticalPadding:=New object:C1471("k"; lk cell vertical padding:K53:78)
	$o.fontColorExpression:=New object:C1471("k"; lk font color expression:K53:48)
	$o.fontStyleExpression:=New object:C1471("k"; lk font style expression:K53:49)
	$o.truncate:=New object:C1471("k"; lk truncate:K53:37)
	
	return $o
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ ONLY WORKS WITH ARRAY TYPE LIST BOXES
Function setRowFontStyle($row : Integer; $tyle : Integer)
	
	If (Asserted:C1132(This:C1470.dataSourceType="Array"; "setRowFontStyle() only works with array type list boxes!"))
		
		// Default is plain
		$tyle:=Count parameters:C259>=2 ? $tyle : Plain:K14:1
		LISTBOX SET ROW FONT STYLE:C1268(*; This:C1470.name; $row; $tyle)
		
	End if 
	