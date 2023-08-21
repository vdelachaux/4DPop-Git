Class extends scrollableDelegate

Class constructor($name : Text; $itemRef : Integer)
	
	Super:C1705($name)
	
	ASSERT:C1129(This:C1470.type=Object type hierarchical list:K79:7)
	
	This:C1470.ref:=$itemRef
	This:C1470.latest:=Null:C1517
	
	This:C1470.datasource:=OBJECT Get data source:C1265(*; This:C1470.name)
	
	// MARK:-[List]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Creates a new list in memory and returns its unique list reference number.
Function create() : Integer
	
	This:C1470.clear()
	This:C1470.ref:=New list:C375
	
	return This:C1470.ref
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Deletes the current reference list
Function clear($keepSubLists : Boolean)
	
	If (This:C1470.isList)
		
		If ($keepSubLists)
			
			CLEAR LIST:C377(This:C1470.ref)
			
		Else 
			
			CLEAR LIST:C377(This:C1470.ref; *)  // Default is list and sublists
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a copy of the current list
Function copy() : cs:C1710.hListDelegate
	
	If (Asserted:C1132(This:C1470.isList; "No list to duplicate"))
		
		return cs:C1710.hListDelegate.new(Copy list:C626(This:C1470.ref))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Alias of copy()
Function clone() : cs:C1710.hListDelegate
	
	return This:C1470.copy()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Is the current reference a valid list?
Function get isList() : Boolean
	
	return Is a list:C621(This:C1470.ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The total number of items present in the list
Function get itemCount() : Integer
	
	return Count list items:C380(*; This:C1470.name; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The number of items currently “visible”
Function get visibleItemCount() : Integer
	
	return Count list items:C380(*; This:C1470.name)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The properties about the current list [⚠️ only work with datasource]
Function get properties() : Object
	
	var $appearance; $doubleClick; $editable; $icon; $lineHeight; $multiSelection : Integer
	
	If (Asserted:C1132(Not:C34(Is nil pointer:C315(This:C1470.datasource)); Current method name:C684+" works only with a datatsource :-(("))
		
		GET LIST PROPERTIES:C632((This:C1470.datasource)->; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
		
		return {\
			lineHeight: $lineHeight; \
			expandCollapseOnDoubleClick: Not:C34(Bool:C1537($doubleClick)); \
			multiSelections: Bool:C1537($multiSelection); \
			editable: Bool:C1537($editable)}
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set properties($properties : Object)
	
	var $key : Text
	var $appearance; $doubleClick; $editable; $icon; $lineHeight; $multiSelection : Integer
	
	If (Asserted:C1132(Not:C34(Is nil pointer:C315(This:C1470.datasource)); Current method name:C684+" works only with a datatsource :-(("))
		
		GET LIST PROPERTIES:C632((This:C1470.datasource)->; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
		
		For each ($key; $properties)
			
			Case of 
					
					//______________________________________________________
				: ($key="lineHeight")
					
					$lineHeight:=Num:C11($properties[$key])
					
					//______________________________________________________
				: ($key="expandCollapseOnDoubleClick")
					
					$doubleClick:=Num:C11(Not:C34(Bool:C1537($properties[$key])))
					
					//______________________________________________________
				: ($key="multiSelections")
					
					$multiSelection:=Num:C11(Bool:C1537($properties[$key]))
					
					//______________________________________________________
				: ($key="editable")
					
					$editable:=Num:C11(Bool:C1537($properties[$key]))
					
					//______________________________________________________
			End case 
			
		End for each 
		
		SET LIST PROPERTIES:C387((This:C1470.datasource)->; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The selected item positions [⛔️ READ ONLY]
Function get selected() : Collection
	
	var $c : Collection
	
	ARRAY LONGINT:C221($selected; 0x0000)
	$selected{0}:=Selected list items:C379(*; This:C1470.name; $selected)
	
	$c:=[]
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The selected item refrernces [⛔️ READ ONLY]
Function get selectedReferences() : Collection
	
	var $c : Collection
	
	ARRAY LONGINT:C221($selected; 0x0000)
	$selected{0}:=Selected list items:C379(*; This:C1470.name; $selected; *)
	
	$c:=[]
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Appends a new item to the current list
Function append($itemText : Text; $itemRef : Integer; $sublist : Integer; $expanded : Boolean)
	
	// ⚠️ APPEND TO LIST doesn't accept object name
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Count parameters:C259=2) || ($sublist=0)
			
			INSERT IN LIST:C625(*; This:C1470.name; 0; $itemText; $itemRef)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Count parameters:C259=4)
			
			INSERT IN LIST:C625(*; This:C1470.name; 0; $itemText; $itemRef; $sublist; $expanded)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	This:C1470.latest:=$itemRef
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Inserts an item to the current list
Function insert($itemText : Text; $itemRef : Integer; $sublist : Integer; $expanded : Boolean; $beforeItemRef : Integer)
	
	If ($beforeItemRef#0)
		
		If ($sublist=0)
			
			INSERT IN LIST:C625(*; This:C1470.name; $beforeItemRef; $itemText; $itemRef)
			
		Else 
			
			INSERT IN LIST:C625(*; This:C1470.name; $beforeItemRef; $itemText; $itemRef; $sublist; $expanded)
			
		End if 
		
	Else 
		
		INSERT IN LIST:C625(*; This:C1470.name; *; $itemText; $itemRef; $sublist; $expanded)
		
	End if 
	
	This:C1470.latest:=$itemRef
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// True if at least one element could be folded.
Function get collapsable() : Boolean
	
	var $itemText : Text
	var $expanded : Boolean
	var $i; $itemRef; $sublist : Integer
	
	For ($i; 1; Count list items:C380(*; This:C1470.name); 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $itemRef; $itemText; $sublist; $expanded)
		
		If ($sublist>0) && ($expanded)
			
			return True:C214
			
		End if 
	End for 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// True if at least one element could be unfolded.
Function get expandable() : Boolean
	
	var $itemText : Text
	var $expanded : Boolean
	var $i; $itemRef; $sublist : Integer
	
	For ($i; 1; Count list items:C380(*; This:C1470.name); 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $itemRef; $itemText; $sublist; $expanded)
		
		If ($sublist>0)
			
			If (Not:C34($expanded))
				
				return True:C214
				
			Else 
				
				$i+=Count list items:C380($sublist)
				
			End if 
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Collapse all items
Function collapseAll($keep : Boolean)
	
	var $itemText : Text
	var $expanded : Boolean
	var $count; $current; $i; $itemRef; $subList : Integer
	
	$keep:=Count parameters:C259=0 ? This:C1470.itemSublist>0 : $keep
	
	// Keep the current item reference to restore if any
	$current:=This:C1470.itemRef
	
	$count:=This:C1470.itemCount
	
	Repeat 
		
		$i+=1
		$expanded:=False:C215
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $itemRef; $itemText; $subList; $expanded)
		
		If ($subList#0)\
			 & ($expanded)
			
			SET LIST ITEM:C385(*; This:C1470.name; $itemRef; $itemText; $itemRef; $subList; False:C215)
			$count-=Count list items:C380($subList; *)
			
		Else 
			
			$count-=1
			
		End if 
	Until ($count<=0)
	
	If ($keep)
		
		// Restore the selected item
		This:C1470.selectByReference($current)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Expand all items
Function expandAll()
	
	var $itemText : Text
	var $expanded : Boolean
	var $count; $i; $itemRef; $subList : Integer
	
	$count:=This:C1470.itemCount
	
	For ($i; 1; This:C1470.itemCount; 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $itemRef; $itemText; $subList; $expanded)
		
		If ($subList#0) && (Not:C34($expanded))
			
			SET LIST ITEM:C385(*; This:C1470.name; $itemRef; $itemText; $itemRef; $subList; True:C214)
			$i+=Count list items:C380($subList)
			
		End if 
	End for 
	
	This:C1470.unselect()
	
	// MARK:-[Item]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The value of the current element
Function get itemValue() : Text
	
	return This:C1470._getItem("value")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemValue($value : Text)
	
	This:C1470._setItem("value"; $value)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The ref of the current element
Function get itemRef() : Integer
	
	return This:C1470._getItem("ref")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemRef($îtemRef : Integer)
	
	This:C1470._setItem("ref"; $îtemRef)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The sub-list of the current element
Function get itemSublist() : Integer
	
	return This:C1470._getItem("sublist")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemSublist($sublist : Integer)
	
	This:C1470._setItem("sublist"; $sublist)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getSublist($pos : Integer) : Integer
	
	return This:C1470._getItem("sublist"; $pos)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getSublistByRef($ref : Integer) : Integer
	
	return This:C1470._getItem("sublist"; This:C1470.getItemPositionByRef($ref))
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The expanded state of the sub-list of the current element
Function get itemExpanded() : Boolean
	
	return This:C1470._getItem("expanded")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemExpanded($expanded : Boolean)
	
	This:C1470._setItem("expanded"; $expanded)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	///The icon associated with the current element
Function get itemIcon() : Picture
	
	return This:C1470._getItem("icon")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemIcon($icon : Picture)
	
	This:C1470._setItem("icon"; $icon)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The current element position
Function get itemPosition() : Integer
	
	return List item position:C629(*; This:C1470.name; This:C1470.itemRef)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All the parameters names & values of the current item
Function get parameters() : Collection
	
	var $dateSep; $decimalSep; $timeSep : Text
	var $date : Date
	var $bool : Boolean
	var $time : Time
	var $o : Object
	var $c : Collection
	
	ARRAY TEXT:C222($names; 0x0000)
	ARRAY TEXT:C222($values; 0x0000)
	GET LIST ITEM PARAMETER ARRAYS:C1195(*; This:C1470.name; *; $names; $values)
	
	$c:=[]
	ARRAY TO COLLECTION:C1563($c; $names; "name"; $values; "value")
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $decimalSep)
	GET SYSTEM FORMAT:C994(Date separator:K60:10; $dateSep)
	GET SYSTEM FORMAT:C994(Time separator:K60:11; $timeSep)
	
	For each ($o; $c)
		
		Case of 
				
				//______________________________________________________
			: ($o.value="0")\
				 | ($o.value="1")  // ⚠️ Boolean are stored as 0 or 1
				
				GET LIST ITEM PARAMETER:C985(*; This:C1470.name; *; $o.name; $bool)
				$o.value:=$bool
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$decimalSep+"\\d+)?$"; $o.value; 1))
				
				$o.value:=Num:C11($o.value)
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\d+"+$timeSep+"\\d+(?:"+$timeSep+"\\d+)?$"; $o.value; 1))
				
				GET LIST ITEM PARAMETER:C985(*; This:C1470.name; *; $o.name; $time)
				$o.value:=$time
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\d+"+$dateSep+"\\d+(?:"+$dateSep+"\\d+)?$"; $o.value; 1))
				
				GET LIST ITEM PARAMETER:C985(*; This:C1470.name; *; $o.name; $date)
				$o.value:=$date
				
				//______________________________________________________
			: (Match regex:C1019("(?msi)^(?:\\{.*\\})|(?:\\[.*\\])$"; $o.value; 1))
				
				$o.value:=JSON Parse:C1218($o.value)
				
				//______________________________________________________
		End case 
	End for each 
	
	return $c
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The parent item reference [⛔️ READ ONLY]
Function get parent() : Integer
	
	return List item parent:C633(*; This:C1470.name; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Expand one item
Function collapse($itemPos : Integer)
	
	var $itemText : Text
	var $isExpanded : Boolean
	var $itemRef; $sublist : Integer
	
	GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $itemRef; $itemText; $sublist; $isExpanded)
	
	If ($sublist#0)\
		 && ($isExpanded)
		
		SET LIST ITEM:C385(*; This:C1470.name; $itemRef; $itemText; $itemRef; $sublist; False:C215)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Expand one item
Function expand($itemPos : Integer)
	
	var $itemText : Text
	var $isExpanded : Boolean
	var $itemRef; $sublist : Integer
	
	GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $itemRef; $itemText; $sublist; $isExpanded)
	
	If ($sublist#0)\
		 && (Not:C34($isExpanded))
		
		SET LIST ITEM:C385(*; This:C1470.name; $itemRef; $itemText; $itemRef; $sublist; True:C214)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the itemRef position
Function getItemPositionByRef($itemRef : Integer) : Integer
	
	return List item position:C629(*; This:C1470.name; $itemRef)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns information about the element specified by itemPos or the current element if omitted
Function _getItem($request : Text; $itemPos : Integer) : Variant
	
	var $itemText : Text
	var $icon : Picture
	var $expanded : Boolean
	var $itemRef; $sublist : Integer
	
	If ($request="icon")
		
		If ($itemPos=0)
			
			GET LIST ITEM ICON:C951(*; This:C1470.name; *; $icon)
			
		Else 
			
			GET LIST ITEM ICON:C951(*; This:C1470.name; $itemPos; $icon)
			
		End if 
		
		return $icon
		
	Else 
		
		If ($itemPos=0)
			
			GET LIST ITEM:C378(*; This:C1470.name; *; $itemRef; $itemText; $sublist; $expanded)
			
		Else 
			
			GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $itemRef; $itemText; $sublist; $expanded)
			
		End if 
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($request="value")
			
			return $itemText
			
			//______________________________________________________
		: ($request="ref")
			
			return $itemRef
			
			//______________________________________________________
		: ($request="sublist")
			
			return $sublist
			
			//______________________________________________________
		: ($request="expanded")
			
			return $expanded
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Sets information of the element itemPos or the current element if omitted
Function _setItem($request : Text; $value; $itemPos : Integer)
	
	var $icon : Picture
	
	If ($request="icon")
		
		If ($itemPos=0)
			
			SET LIST ITEM ICON:C950(*; This:C1470.name; *; $icon)
			
		Else 
			
			SET LIST ITEM ICON:C950(*; This:C1470.name; $itemPos; $icon)
			
		End if 
		
	Else 
		
		If ($itemPos=0)
			
			GET LIST ITEM:C378(*; This:C1470.name; *; $itemRef; $itemText; $sublist; $expanded)
			
		Else 
			
			GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $itemRef; $itemText; $sublist; $expanded)
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: ($request="value")
				
				SET LIST ITEM:C385(*; This:C1470.name; *; $value; $itemRef; $sublist; $expanded)
				
				//______________________________________________________
			: ($request="ref")
				
				SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $value; $sublist; $expanded)
				
				//______________________________________________________
			: ($request="sublist")
				
				SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $itemRef; $value; $expanded)
				
				//______________________________________________________
			: ($request="expanded")
				
				SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $itemRef; $sublist; $value)
				
				//______________________________________________________
		End case 
	End if 
	
	// MARK:-[Find]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the position of the first item value
Function findPosition($itemText : Text; $scope : Integer) : Integer
	
	return Find in list:C952(*; This:C1470.name; $itemText; $scope)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the reference of the first item value
Function findReference($itemText : Text; $scope : Integer) : Integer
	
	return Find in list:C952(*; This:C1470.name; $itemText; $scope; *)
	
	// MARK:-[Selection]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// A collection of indexes of selected items
Function get selectedItemIndexes() : Collection
	
	var $dummy : Integer
	var $c : Collection
	$c:=[]
	
	ARRAY LONGINT:C221($selected; 0)
	$dummy:=Selected list items:C379(*; This:C1470.name; $selected)
	
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// A collection of refernces of selected items
Function get selectedItemReferences() : Collection
	
	var $dummy : Integer
	var $c : Collection
	$c:=[]
	
	ARRAY LONGINT:C221($selected; 0)
	$dummy:=Selected list items:C379(*; This:C1470.name; $selected; *)
	
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Selects the item whose item position is passed
Function selectByPosition($itemPos : Integer)
	
	// TODO: Accept a collection of positions
	
	If ($itemPos>0)
		
		SELECT LIST ITEMS BY POSITION:C381(*; This:C1470.name; $itemPos)
		OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $itemPos)
		
	Else 
		
		This:C1470.unselect()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Selects the item whose item reference is passed
Function selectByReference($itemRef : Integer)
	
	// TODO: Accept a collection of references
	
	// ⚠️ SELECT LIST ITEMS BY REFERENCE doesn't accept object name
	This:C1470.selectByPosition(This:C1470.getItemPositionByRef($itemRef))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Deselect all items
Function selectAll()
	
	var $focused : Text
	$focused:=OBJECT Get name:C1087(Object with focus:K67:3)
	GOTO OBJECT:C206(*; This:C1470.name)
	INVOKE ACTION:C1439(ak select all:K76:57; ak current form:K76:70)
	GOTO OBJECT:C206(*; $focused)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Deselect all items
Function unselect()
	
	SELECT LIST ITEMS BY POSITION:C381(*; This:C1470.name; This:C1470.itemCount+1)
	