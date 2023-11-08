property success : Boolean

Class constructor($list)
	
	This:C1470[""]:={uid: 0; ref: 0}
	
	This:C1470.SetList($list)
	
	// MARK:-[List]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Creates a new list in memory and returns its unique list reference number.
Function Create() : Integer
	
	This:C1470.Clear()
	
	This:C1470[""].ref:=New list:C375
	
	This:C1470[""].uid:=0
	This:C1470.success:=Is a list:C621(This:C1470[""].ref)
	
	return This:C1470[""].ref
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Populates the current list reference
Function SetList($list) : cs:C1710.Hlist
	
	If (Is a list:C621(This:C1470[""].ref))
		
		CLEAR LIST:C377(This:C1470[""].ref; *)
		
	End if 
	
	Case of 
			
			//—————————————————————————————————
		: (Value type:C1509($list)=Is real:K8:4)\
			 | (Value type:C1509($list)=Is longint:K8:6)
			
			ASSERT:C1129(Is a list:C621($list))
			
			This:C1470[""].ref:=$list
			
			//—————————————————————————————————
		: (Value type:C1509($list)=Is text:K8:3)
			
			// Load a list created in Development mode
			ARRAY LONGINT:C221($nums; 0x0000)
			ARRAY TEXT:C222($names; 0x0000)
			LIST OF CHOICE LISTS:C957($nums; $names)
			ASSERT:C1129(Find in array:C230($names; $list)#-1)
			
			This:C1470[""].ref:=Load list:C383($list)
			
			//—————————————————————————————————
		Else 
			
			This:C1470[""].ref:=New list:C375
			
			//—————————————————————————————————
	End case 
	
	This:C1470[""].uid:=0
	This:C1470.success:=Is a list:C621(This:C1470[""].ref)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a copy of the current list
Function copy() : cs:C1710.Hlist
	
	If (Asserted:C1132(This:C1470.isList; "No list to duplicate"))
		
		return cs:C1710.Hlist.new(Copy list:C626(This:C1470[""].ref))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Clear($keepSubLists : Boolean) : cs:C1710.Hlist
	
	ASSERT:C1129(Is a list:C621(This:C1470[""].ref))
	
	If (This:C1470.isList)
		
		If ($keepSubLists)
			
			CLEAR LIST:C377(This:C1470[""].ref)
			
		Else 
			
			CLEAR LIST:C377(This:C1470[""].ref; *)  // Default is list and sublists
			
		End if 
	End if 
	
	This:C1470[""]:={uid: 0; ref: 0}
	This:C1470.success:=False:C215
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Empty() : cs:C1710.Hlist
	
	var $t : Text
	var $i; $ref; $root : Integer
	
	$root:=This:C1470[""].ref
	
	For ($i; Count list items:C380($root); 1; -1)
		
		GET LIST ITEM:C378($root; $i; $ref; $t)
		DELETE FROM LIST:C624($root; $ref; *)
		
	End for 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Is the current reference a valid list?
Function get isList() : Boolean
	
	return Is a list:C621(This:C1470[""].ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The total number of items present in the list
Function get itemCount() : Integer
	
	return Count list items:C380(This:C1470[""].ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The number of items currently “visible”
Function get visibleItemCount() : Integer
	
	return Count list items:C380(This:C1470[""].ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The properties about the current list
Function get properties() : Object
	
	var $appearance; $doubleClick; $editable; $icon; $lineHeight; $multiSelection : Integer
	
	GET LIST PROPERTIES:C632(This:C1470[""].ref; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
	
	return {\
		lineHeight: $lineHeight; \
		expandCollapseOnDoubleClick: Not:C34(Bool:C1537($doubleClick)); \
		multiSelections: Bool:C1537($multiSelection); \
		editable: Bool:C1537($editable)}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set properties($properties : Object)
	
	var $key : Text
	var $appearance; $doubleClick; $editable; $icon; $lineHeight; $multiSelection : Integer
	
	GET LIST PROPERTIES:C632(This:C1470[""].ref; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
	
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
	
	SET LIST PROPERTIES:C387(This:C1470[""].ref; $appearance; $icon; $lineHeight; $doubleClick; $multiSelection; $editable)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Append($item; $ref : Integer; $sublist : Integer; $expanded : Boolean) : cs:C1710.Hlist
	
	var $label : Text
	
	If (Value type:C1509($item)=Is object:K8:27)
		
		$label:=$item.label || ""
		$ref:=$item.ref || $ref
		
	Else 
		
		$label:=String:C10($item)
		
	End if 
	
	If ($ref=0)
		
		// Set a unique reference
		This:C1470[""].uid+=1
		$ref:=This:C1470[""].uid
		
	End if 
	
	If ($sublist=0)
		
		APPEND TO LIST:C376(This:C1470[""].ref; $label; $ref)
		
	Else 
		
		APPEND TO LIST:C376(This:C1470[""].ref; $label; $ref; $sublist; $expanded)
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastRef() : Integer
	
	return This:C1470[""].uid
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get ref() : Integer
	
	return This:C1470.success ? This:C1470[""].ref : 0
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectedReference() : Integer
	
	return This:C1470.success ? Selected list items:C379(This:C1470[""].ref; *) : 0
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set selectedReference($ref : Integer)
	
	SELECT LIST ITEMS BY REFERENCE:C630(This:C1470[""].ref; $ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectedReferences() : Collection
	
	var $c : Collection
	
	$c:=[]
	
	If (This:C1470.success)
		
		ARRAY LONGINT:C221($references; 0x0000)
		$references{0}:=Selected list items:C379(This:C1470[""].ref; $references; *)
		ARRAY TO COLLECTION:C1563($c; $references)
		
	End if 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function saveSelection()
	
	This:C1470[""].selection:={\
		cur: This:C1470.selectedReference; \
		refs: This:C1470.selectedReferences\
		}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreSelection()
	
	ARRAY LONGINT:C221($references; 0x0000)
	
	If (This:C1470[""].selection.refs#Null:C1517)\
		 && (This:C1470[""].selection.refs.length>0)
		
		COLLECTION TO ARRAY:C1562(This:C1470[""].selection.refs; $references)
		
	End if 
	
	SELECT LIST ITEMS BY REFERENCE:C630(This:C1470[""].ref; Num:C11(This:C1470[""].selection.cur); $references)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectedPosition() : Integer
	
	return This:C1470.success ? Selected list items:C379(This:C1470[""].ref) : 0
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set selectedPosition($pos : Integer)
	
	SELECT LIST ITEMS BY POSITION:C381(This:C1470[""].ref; $pos)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectedPositions() : Collection
	
	var $c : Collection
	
	$c:=[]
	
	If (This:C1470.success)
		
		ARRAY LONGINT:C221($references; 0x0000)
		$references{0}:=Selected list items:C379(This:C1470[""].ref; $references)
		ARRAY TO COLLECTION:C1563($c; $references)
		
	End if 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetPosition($ref : Integer) : Integer
	
	$ref:=Count parameters:C259=0 ? This:C1470.lastRef : $ref
	return List item position:C629(This:C1470[""].ref; $ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetReference($ref : Integer) : Integer
	
	$ref:=Count parameters:C259=0 ? This:C1470.lastRef : $ref
	return List item position:C629(This:C1470[""].ref; $ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetItem($pos : Integer) : Object
	
	var $label : Text
	var $expanded : Boolean
	var $i; $ref; $root; $sublist : Integer
	var $o : Object
	
	$root:=This:C1470[""].ref
	
	GET LIST ITEM:C378($root; $pos; $ref; $label; $sublist; $expanded)
	
	$o:={\
		ref: $ref; \
		label: $label; \
		sublist: $sublist; \
		expanded: $expanded; \
		parameters: Null:C1517\
		}
	
	ARRAY TEXT:C222($names; 0x0000)
	ARRAY TEXT:C222($values; 0x0000)
	GET LIST ITEM PARAMETER ARRAYS:C1195($root; $ref; $names; $values)
	
	If (Size of array:C274($names)>0)
		
		$o.parameters:=[]
		
		For ($i; 1; Size of array:C274($names); 1)
			
			// Todo:Automatic convertion
			$o.parameters.push({\
				name: $names{$i}; \
				value: $values{$i}\
				})
			
		End for 
	End if 
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetItemByReference($ref : Integer) : Object
	
	return This:C1470.GetItem(This:C1470.GetPosition($ref))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function SetItemStyle($style : Integer; $ref : Integer)
	
	var $root : Integer
	var $enterable : Boolean
	
	$root:=This:C1470[""].ref
	
	GET LIST ITEM PROPERTIES:C631($root; $ref; $enterable)
	SET LIST ITEM PROPERTIES:C386($root; $ref; $enterable; $style)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function SetAdditionalText($text : Text; $ref : Integer) : cs:C1710.Hlist
	
	SET LIST ITEM PARAMETER:C986(This:C1470[""].ref; $ref; Additional text:K28:7; $text)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function SetParameter($param : Object; $ref : Integer) : cs:C1710.Hlist
	
	ASSERT:C1129($param.key#Null:C1517)
	
	If (Value type:C1509($param.value)#Is boolean:K8:9)\
		 && (Value type:C1509($param.value)#Is real:K8:4)\
		 && (Value type:C1509($param.value)#Is longint:K8:6)
		
		If (Value type:C1509($param.value)=Is object:K8:27)\
			 | (Value type:C1509($param.value)=Is collection:K8:32)
			
			$param.value:=JSON Stringify:C1217($param.value)
			
		Else 
			
			$param.value:=String:C10($param.value)
			
		End if 
	End if 
	
	SET LIST ITEM PARAMETER:C986(This:C1470[""].ref; $ref; $param.key; $param.value)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetParameter($param : Object) : Variant
	
	var $real : Real
	var $text : Text
	var $boolean : Boolean
	var $ptr : Pointer
	var $o : Object
	
	Case of 
			
			//—————————————————
		: ($param.type=Is boolean:K8:9)
			
			$ptr:=->$boolean
			
			//—————————————————
		: ($param.type=Is real:K8:4)
			
			$ptr:=->$real
			
			//—————————————————
		Else 
			
			$ptr:=->$text
			
			//—————————————————
	End case 
	
	If ($param.ref=Null:C1517)  //selected item
		
		GET LIST ITEM PARAMETER:C985(This:C1470[""].ref; *; $param.key; $ptr->)
		
	Else 
		
		GET LIST ITEM PARAMETER:C985(This:C1470[""].ref; Num:C11($param.ref); $param.key; $ptr->)
		
	End if 
	
	Case of 
			
			//—————————————————
		: ($param.type=Is object:K8:27)
			
			If (Match regex:C1019("(?i-ms)^\\{.*\\}$"; $text; 1))
				
				return JSON Parse:C1218($text)
				
			Else 
				
				return Null:C1517
				
			End if 
			
			//—————————————————
		Else 
			
			return $ptr->
			
			//—————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function SetIcon($param : Object; $ref : Integer) : cs:C1710.Hlist
	
	var $icon : Picture
	$icon:=$param.icon
	
	SET LIST ITEM ICON:C950(This:C1470[""].ref; $ref; $icon)
	
	return This:C1470
	