Class extends scrollable

property list : cs:C1710.hierList

Class constructor($name : Text; $ref : Integer)
	
	Super:C1705($name)
	
	ASSERT:C1129(This:C1470.type=Object type hierarchical list:K79:7)
	
	This:C1470.list:=cs:C1710.hierList.new($ref)
	
	// MARK:- [Working on the data source]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get ref() : Integer
	
	return This:C1470.list.ref
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set ref($ref : Integer)
	
	This:C1470.list.SetList($ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Creates a new list in memory and returns its unique list reference number.
Function createList() : Integer
	
	return This:C1470.list.Creates()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Load an existing list in memory and returns its unique list reference number.
Function loadList($list) : Integer
	
	return This:C1470.list.Load($list)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Deletes the current reference list
Function clearList($keepSubLists : Boolean)
	
	This:C1470.list.Clears()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a copy of the current list
Function copyList() : Integer
	
	If (Asserted:C1132(This:C1470.isAList; "No list to duplicate"))
		
		return Copy list:C626(This:C1470.ref)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Is the current reference a valid list?
Function get isAList() : Boolean
	
	return This:C1470.list.isList
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Get current list properties
Function get properties() : Object
	
	return This:C1470.list.properties
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Set one or more properties for the current list
Function set properties($properties : Object)
	
	This:C1470.list.properties:=$properties
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The number of elements in the first level
Function get firstLevelItemCount() : Integer
	
	return This:C1470.list.firstLevelItemCount
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Appends a new item to the current list
Function append($item; $ref : Integer; $sublist : Integer; $expanded : Boolean)
	
	This:C1470.list.Append($item; $ref; $sublist; $expanded)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Inserts an item to the current list
Function insert($item; $ref : Integer; $sublist : Integer; $expanded : Boolean; $beforeItemRef : Integer)
	
	This:C1470.list.Insert($item; $ref; $sublist; $expanded; $beforeItemRef)
	
	// MARK:- [Working on the form instance]
	// MARK: ************** List *************
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The total number of items present in the list
Function get itemCount() : Integer
	
	return Count list items:C380(*; This:C1470.name; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The number of items currently “visible”
Function get visibleItemCount() : Integer
	
	return Count list items:C380(*; This:C1470.name)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// True if at least one element could be folded.
Function get collapsable() : Boolean
	
	var $itemText : Text
	var $expanded : Boolean
	var $i; $ref; $sublist : Integer
	
	For ($i; 1; Count list items:C380(*; This:C1470.name); 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $ref; $itemText; $sublist; $expanded)
		
		If ($sublist>0) && ($expanded)
			
			return True:C214
			
		End if 
	End for 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// True if at least one element could be unfolded.
Function get expandable() : Boolean
	
	var $itemText : Text
	var $expanded : Boolean
	var $i; $ref; $sublist : Integer
	
	For ($i; 1; Count list items:C380(*; This:C1470.name); 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $ref; $itemText; $sublist; $expanded)
		
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
	var $i; $ref; $subList : Integer
	
	$keep:=Count parameters:C259=0 ? This:C1470.itemSublist>0 : $keep
	
	// Keep the current item reference to restore if any
	var $current:=This:C1470.itemRef
	var $count:=This:C1470.itemCount
	
	Repeat 
		
		$i+=1
		$expanded:=False:C215
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $ref; $itemText; $subList; $expanded)
		
		If ($subList#0)\
			 & ($expanded)
			
			SET LIST ITEM:C385(*; This:C1470.name; $ref; $itemText; $ref; $subList; False:C215)
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
	var $i; $ref; $subList : Integer
	
	var $count:=This:C1470.itemCount
	
	For ($i; 1; This:C1470.itemCount; 1)
		
		GET LIST ITEM:C378(*; This:C1470.name; $i; $ref; $itemText; $subList; $expanded)
		
		If ($subList#0) && (Not:C34($expanded))
			
			SET LIST ITEM:C385(*; This:C1470.name; $ref; $itemText; $ref; $subList; True:C214)
			$i+=Count list items:C380($subList)
			
		End if 
	End for 
	
	This:C1470.unselect()
	
	// MARK: ************* Item ************** 
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the position of an element from its reference, current element if the reference is omitted
Function itemPosition($ref : Integer) : Integer
	
	$ref:=Count parameters:C259>=1 ? $ref : This:C1470.itemRef
	
	return List item position:C629(*; This:C1470.name; $ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The position of the selected element
Function get itemSelected() : Integer
	
	return Selected list items:C379(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemSelected($pos : Integer)
	
	SELECT LIST ITEMS BY POSITION:C381(*; This:C1470.name; $pos)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The selected item positions
Function get selectedItems() : Collection
	
	ARRAY LONGINT:C221($selected; 0)
	$selected{0}:=Selected list items:C379(*; This:C1470.name; $selected)
	
	var $c:=[]
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The selected item refrerences
Function get selectedItemsReferences() : Collection
	
	ARRAY LONGINT:C221($selected; 0)
	$selected{0}:=Selected list items:C379(*; This:C1470.name; $selected; *)
	
	var $c:=[]
	ARRAY TO COLLECTION:C1563($c; $selected)
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getSublist($pos : Integer) : Integer
	
	return This:C1470._getItem("sublist"; $pos)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getSublistByRef($ref : Integer) : Integer
	
	return This:C1470._getItem("sublist"; This:C1470.itemPosition($ref))
	
	// MARK: ******** Current element ******** 
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The ref of the current element
Function get itemRef() : Integer
	
	return This:C1470._getItem("ref")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemRef($ref : Integer)
	
	This:C1470.setItem("ref"; $ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The value of the current element
Function get itemValue() : Text
	
	return This:C1470._getItem("value")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemValue($value : Text)
	
	This:C1470.setItem("value"; $value)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The sub-list of the current element
Function get itemSublist() : Integer
	
	return This:C1470._getItem("sublist")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemSublist($sublist : Integer)
	
	This:C1470.setItem("sublist"; $sublist)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The expanded state of the sub-list of the current element
Function get itemExpanded() : Boolean
	
	return This:C1470._getItem("expanded")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemExpanded($expanded : Boolean)
	
	This:C1470.setItem("expanded"; $expanded)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	///The icon associated with the current element
Function get itemIcon() : Picture
	
	return This:C1470._getItem("icon")
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set itemIcon($icon : Picture)
	
	This:C1470.setItem("icon"; $icon)
	
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
	
	ARRAY TEXT:C222($names; 0x0000)
	ARRAY TEXT:C222($values; 0x0000)
	GET LIST ITEM PARAMETER ARRAYS:C1195(*; This:C1470.name; *; $names; $values)
	
	var $c:=[]
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
	var $ref; $sublist : Integer
	
	GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $ref; $itemText; $sublist; $isExpanded)
	
	If ($sublist#0)\
		 && ($isExpanded)
		
		SET LIST ITEM:C385(*; This:C1470.name; $ref; $itemText; $ref; $sublist; False:C215)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Expand one item
Function expand($itemPos : Integer)
	
	var $itemText : Text
	var $isExpanded : Boolean
	var $ref; $sublist : Integer
	
	GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $ref; $itemText; $sublist; $isExpanded)
	
	If ($sublist#0)\
		 && (Not:C34($isExpanded))
		
		SET LIST ITEM:C385(*; This:C1470.name; $ref; $itemText; $ref; $sublist; True:C214)
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns information about the element specified by itemPos or the current element if omitted
Function _getItem($request : Text; $itemPos : Integer) : Variant
	
	var $itemText : Text
	var $icon : Picture
	var $expanded : Boolean
	var $ref; $sublist : Integer
	
	If ($request="icon")
		
		If ($itemPos=0)
			
			GET LIST ITEM ICON:C951(*; This:C1470.name; *; $icon)
			
		Else 
			
			GET LIST ITEM ICON:C951(*; This:C1470.name; $itemPos; $icon)
			
		End if 
		
		return $icon
		
	Else 
		
		If ($itemPos=0)
			
			GET LIST ITEM:C378(*; This:C1470.name; *; $ref; $itemText; $sublist; $expanded)
			
		Else 
			
			GET LIST ITEM:C378(*; This:C1470.name; $itemPos; $ref; $itemText; $sublist; $expanded)
			
		End if 
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($request="value")
			
			return $itemText
			
			//______________________________________________________
		: ($request="ref")
			
			return $ref
			
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
Function setItem($request : Text; $value; $item : Integer)
	
	var $itemText : Text
	var $expanded : Boolean
	var $ref; $sublist : Integer
	
	If ($request="icon")
		
		// $item is the item reference
		
		If ($item=0)
			
			SET LIST ITEM ICON:C950(*; This:C1470.name; *; $value)
			
		Else 
			
			SET LIST ITEM ICON:C950(*; This:C1470.name; $item; $value)
			
		End if 
		
		return 
		
	End if 
	
	If ($item=0)
		
		GET LIST ITEM:C378(*; This:C1470.name; *; $ref; $itemText; $sublist; $expanded)
		
	Else 
		
		// $item is the item position
		GET LIST ITEM:C378(*; This:C1470.name; $item; $ref; $itemText; $sublist; $expanded)
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($request="value")
			
			SET LIST ITEM:C385(*; This:C1470.name; *; $value; $ref; $sublist; $expanded)
			
			//______________________________________________________
		: ($request="ref")
			
			SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $value; $sublist; $expanded)
			
			//______________________________________________________
		: ($request="sublist")
			
			SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $ref; $value; $expanded)
			
			//______________________________________________________
		: ($request="expanded")
			
			SET LIST ITEM:C385(*; This:C1470.name; *; $itemText; $ref; $sublist; $value)
			
			//______________________________________________________
	End case 
	
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
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Select all items
Function selectAll()
	
	//This.list.selectAll()
	
	var $current:=OBJECT Get name:C1087(Object with focus:K67:3)
	GOTO OBJECT:C206(*; This:C1470.name)
	INVOKE ACTION:C1439(ak select all:K76:57; ak current form:K76:70)
	GOTO OBJECT:C206(*; $current)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Deselect all items
Function unselect()
	
	This:C1470.list.unselect()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function saveSelection()
	
	This:C1470.list.saveSelection()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreSelection()
	
	This:C1470.list.restoreSelection()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectedItemPosition() : Integer
	
	return This:C1470.list.selectedPosition
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set selectedItemPosition($pos : Integer)
	
	This:C1470.list.selectedPosition:=$pos
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// A collection of indexes of selected items
Function get selectedItemIndexes() : Collection
	
	return This:C1470.list.selectedPositions
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// A collection of refernces of selected items
Function get selectedItemReferences() : Collection
	
	return This:C1470.list.selectedReferences
	
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
Function selectByReference($ref : Integer)
	
	// TODO: Accept a collection of references
	
	// ⚠️ SELECT LIST ITEMS BY REFERENCE doesn't accept object name
	This:C1470.selectByPosition(This:C1470.itemPosition($ref))
	