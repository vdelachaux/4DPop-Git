Class extends static

property name; action; _uri : Text

property _events : Collection
property _data; dataSource
property _callback : 4D:C1709.Function

Class constructor($name : Text)
	
	Super:C1705($name)
	
	This:C1470.action:=OBJECT Get action:C1457(*; This:C1470.name)
	
/*
The user data can be anything you want to attach to the widget.
The .data property is used to get or set this data.
*/
	This:C1470._data:=Null:C1517
	
	// The uri associated with the widget (D&D management)
	This:C1470._uri:=""
	
	// Get the events handled for this widget
	This:C1470._setEvents()
	
	//MARK:-[Object]
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set datasource($datasource)
	
	This:C1470.setDatasource($datasource)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDatasource($datasource) : cs:C1710.widget
	
	This:C1470.dataSource:=$datasource
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($datasource)=Is object:K8:27)
			
			If (Asserted:C1132(OB Instance of:C1731($datasource; 4D:C1709.Function); "datasource object is not a formula"))
				
				// Formula
				This:C1470.setValue(This:C1470.dataSource.call())
				
			End if 
			
			//______________________________________________ wi ________
		: (Value type:C1509($datasource)=Is text:K8:3)
			
			This:C1470.setValue(Formula from string:C1601($datasource).call())
			
			//______________________________________________________
		Else 
			
			//ASSERT(False; "datasource must be a formula or a text formula")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	//mark:-[Value]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get value() : Variant
	
	return This:C1470.getValue()
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set value($value)
	
	This:C1470.setValue($value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getValue() : Variant
	
	If (This:C1470.type=Object type text input:K79:4)\
		 && (This:C1470.isFocused())
		
		return Get edited text:C655
		
	Else 
		
		return OBJECT Get value:C1743(This:C1470.name)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setValue($value) : cs:C1710.widget
	
	If (Not:C34(Undefined:C82($value)))
		
		OBJECT SET VALUE:C1742(This:C1470.name; $value)
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get isEmpty() : Boolean
	
	var $type : Integer
	var $value
	
	$value:=This:C1470.getValue()
	$type:=Value type:C1509($value)
	
	Case of 
			
			//______________________________________________________
		: ($value=Null:C1517)\
			 | ($type=Is undefined:K8:13)
			
			return True:C214
			
			//______________________________________________________
		: ($type=Is longint:K8:6)\
			 | ($type=Is real:K8:4)
			
			return $value=0
			
			//______________________________________________________
		: ($type=Is date:K8:7)
			
			return $value=!00-00-00!
			
			//______________________________________________________
		: ($type=Is time:K8:8)
			
			return $value=?00:00:00?
			
			//______________________________________________________
		: ($type=Is picture:K8:10)
			
			return Picture size:C356($value)=0
			
			//______________________________________________________
		: ($type=Is object:K8:27)
			
			return OB Is empty:C1297($value)
			
			//______________________________________________________
		: ($type=Is collection:K8:32)
			
			return $value.length=0
			
			//______________________________________________________
		Else 
			
			return Length:C16(String:C10($value))=0
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get isNotEmpty() : Boolean
	
	return Not:C34(This:C1470.isEmpty)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clear : cs:C1710.widget
	
	var $type : Integer
	$type:=Value type:C1509(OBJECT Get value:C1743(This:C1470.name))
	
	Case of 
			
			//______________________________________________________
		: ($type=Is text:K8:3)
			
			OBJECT SET VALUE:C1742(This:C1470.name; "")
			
			//______________________________________________________
		: ($type=Is real:K8:4)\
			 | ($type=Is longint:K8:6)
			
			OBJECT SET VALUE:C1742(This:C1470.name; 0)
			
			//______________________________________________________
		: ($type=Is boolean:K8:9)
			
			OBJECT SET VALUE:C1742(This:C1470.name; False:C215)
			
			//______________________________________________________
		: ($type=Is date:K8:7)
			
			OBJECT SET VALUE:C1742(This:C1470.name; !00-00-00!)
			
			//______________________________________________________
		: ($type=Is time:K8:8)
			
			OBJECT SET VALUE:C1742(This:C1470.name; ?00:00:00?)
			
			//______________________________________________________
		: ($type=Is object:K8:27) | ($type=Is collection:K8:32)
			
			OBJECT SET VALUE:C1742(This:C1470.name; Null:C1517)
			
			//______________________________________________________
		: ($type=Is picture:K8:10)
			
			OBJECT SET VALUE:C1742(This:C1470.name; OBJECT Get value:C1743(This:C1470.name)*0)
			
			//______________________________________________________
		Else 
			
			OBJECT SET VALUE:C1742(This:C1470.name; Null:C1517)
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function touch() : cs:C1710.widget
	
	var $value
	$value:=OBJECT Get value:C1743(This:C1470.name)
	
	If (Value type:C1509($value)#Is undefined:K8:13)
		
		OBJECT SET VALUE:C1742(This:C1470.name; $value)
		
	End if 
	
	return This:C1470
	
	//MARK:-[Entry]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// Returns a pointer to the widget
	// ⚠️ Could return a nil pointer if data source is an expression
Function get pointer() : Pointer
	
	return OBJECT Get pointer:C1124(Object named:K67:5; This:C1470.name)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get enterable() : Boolean
	
	return OBJECT Get enterable:C1067(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set enterable($enterable : Boolean)
	
	OBJECT SET ENTERABLE:C238(*; This:C1470.name; $enterable)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setEnterable($enterable : Boolean) : cs:C1710.widget
	
	$enterable:=Count parameters:C259>=1 ? $enterable : True:C214
	OBJECT SET ENTERABLE:C238(*; This:C1470.name; $enterable)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function notEnterable() : cs:C1710.widget
	
	OBJECT SET ENTERABLE:C238(*; This:C1470.name; False:C215)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getShortcut : Object
	
	var $t : Text
	var $l : Integer
	
	OBJECT GET SHORTCUT:C1186(*; This:C1470.name; $t; $l)
	
	return {\
		key: $t; \
		modifier: $l}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setShortcut($key : Text; $modifier : Integer) : cs:C1710.widget
	
	OBJECT SET SHORTCUT:C1185(*; This:C1470.name; $key; $modifier)
	
	return This:C1470
	
	//MARK:-[Help]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get helpTip() : Text
	
	return OBJECT Get help tip:C1182(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set helpTip($helpTip : Text)
	
	This:C1470.setHelpTip($helpTip)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getHelpTip() : Text
	
	return OBJECT Get help tip:C1182(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHelpTip($helpTip : Text) : cs:C1710.widget
	
	OBJECT SET HELP TIP:C1181(*; This:C1470.name; This:C1470._getLocalizeString($helpTip))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function removeHelpTip() : cs:C1710.widget
	
	OBJECT SET HELP TIP:C1181(*; This:C1470.name; "")
	
	return This:C1470
	
	//MARK:-[Events]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get events() : Collection
	
	return This:C1470._events#Null:C1517 ? This:C1470._events : []
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set events($events)
	
	This:C1470._setEvents($events; Enable events disable others:K42:37)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function addEvent($events) : cs:C1710.widget
	
	This:C1470._setEvents($events; Enable events others unchanged:K42:38)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function removeEvent($events) : cs:C1710.widget
	
	This:C1470._setEvents($events; Disable events others unchanged:K42:39)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setEvents($events) : cs:C1710.widget
	
	This:C1470._setEvents($events; Enable events disable others:K42:37)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function catch($e; $events) : Boolean
	
	var $catch : Boolean
	
	If (Asserted:C1132(This:C1470.type#-1; Current method name:C684+" does not apply to a group"))
		
		$e:=(($e=Null:C1517) || (Value type:C1509($e)#Is object:K8:27)) ? FORM Event:C1606 : $e
		
		$catch:=(This:C1470.name=$e.objectName)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($catch))
				
				//______________________________________________________
			: (This:C1470._events.length>0)
				
				$catch:=(This:C1470._events.includes($e.code))
				
				//______________________________________________________
			: (Count parameters:C259>=2) && (Value type:C1509($events)=Is collection:K8:32)  // Old mechanism [COMPATIBILITY]
				
				$catch:=($events.includes($e.code))
				
				//______________________________________________________
			: (Count parameters:C259>=2) && (Value type:C1509($events)=Is integer:K8:5)  // Old mechanism [COMPATIBILITY]
				
				$catch:=($e.code=Num:C11($events))
				
				//______________________________________________________
			: (Count parameters:C259=1) && (Value type:C1509($e)=Is text:K8:3)  // Old mechanism [COMPATIBILITY]
				
				$catch:=(This:C1470.name=String:C10($e))
				
				//______________________________________________________
		End case 
	End if 
	
	If ($catch)
		
		If (This:C1470._callback#Null:C1517)
			
			This:C1470._callback.call()
			
		End if 
	End if 
	
	return $catch
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _setEvents($events; $mode : Integer)
	
	ARRAY LONGINT:C221($eventCodes; 0x0000)
	
	This:C1470._events:=This:C1470._events || []
	
	Case of 
			
			//______________________________________________________
		: ($events=Null:C1517)
			
			return 
			
			//______________________________________________________
		: (Value type:C1509($events)=Is collection:K8:32)
			
			COLLECTION TO ARRAY:C1562($events; $eventCodes)
			OBJECT SET EVENTS:C1239(*; This:C1470.name; $eventCodes; $mode)
			This:C1470._events.combine($events)
			
			//______________________________________________________
		: (Value type:C1509($events)=Is integer:K8:5)\
			 | (Value type:C1509($events)=Is longint:K8:6)\
			 | (Value type:C1509($events)=Is real:K8:4)
			
			APPEND TO ARRAY:C911($eventCodes; $events)
			OBJECT SET EVENTS:C1239(*; This:C1470.name; $eventCodes; $mode)
			This:C1470._events.combine([$events])
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The event parameter must be an number or a collection")
			
			//______________________________________________________
	End case 
	
/* 📌 Update widget events
The arrEvents array is returned empty if no object method is associated with the object
or if no form method is associated with the form.
*/
	OBJECT GET EVENTS:C1238(*; This:C1470.name; $eventCodes)
	var $c : Collection
	$c:=[]
	ARRAY TO COLLECTION:C1563($c; $eventCodes)
	This:C1470._events.combine($c)
	
	//mark:-[Attached data]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the user data attached to the widget
Function get data() : Variant
	
	return This:C1470._data
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Defines the user data attached to the widget
Function set data($data)
	
	This:C1470._data:=$data
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setData($o : Object)
	
	var $t : Text
	
	This:C1470._data:=This:C1470._data || {}
	
	For each ($t; $o)
		
		This:C1470._data[$t]:=$o[$t]
		
	End for each 
	//mark:-[Drag & drop]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// Defines the uri associated with the widget
Function get uri() : Text
	
	return This:C1470._uri
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	// Returns the uri associated with the widget
Function set uri($uri : Text)
	
	This:C1470._uri:=$uri
	
	//mark:-[Actions]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get draggable() : Boolean
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	return $draggable
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set draggable($on : Boolean)
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; $on; $automaticDrag; $droppable; $automaticDrop)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get droppable() : Boolean
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	return $droppable
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set droppable($on : Boolean)
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; $draggable; $automaticDrag; $on; $automaticDrop)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDraggable($enabled : Boolean; $automatic : Boolean) : cs:C1710.widget
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259>=2)
			
			$draggable:=$enabled
			$automaticDrag:=$automatic
			
			//______________________________________________________
		: (Count parameters:C259>=1)
			
			$draggable:=$enabled
			$automaticDrag:=False:C215
			
			//______________________________________________________
		Else 
			
			$draggable:=True:C214
			$automaticDrag:=False:C215
			
			//______________________________________________________
	End case 
	
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNotDraggable() : cs:C1710.widget
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; False:C215; False:C215; $droppable; $automaticDrop)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDroppable($enabled : Boolean; $automatic : Boolean) : cs:C1710.widget
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259>=2)
			
			$droppable:=$enabled
			$automaticDrop:=$automatic
			
			//______________________________________________________
		: (Count parameters:C259>=1)
			
			$droppable:=$enabled
			$automaticDrop:=False:C215
			
			//______________________________________________________
		Else 
			
			$droppable:=True:C214
			$automaticDrop:=False:C215
			
			//______________________________________________________
	End case 
	
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNotDroppable() : cs:C1710.widget
	
	var $automaticDrag; $automaticDrop; $draggable; $droppable : Boolean
	
	OBJECT GET DRAG AND DROP OPTIONS:C1184(*; This:C1470.name; $draggable; $automaticDrag; $droppable; $automaticDrop)
	OBJECT SET DRAG AND DROP OPTIONS:C1183(*; This:C1470.name; $draggable; $automaticDrag; False:C215; False:C215)
	
	return This:C1470
	
	// MARK:-[Callback]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCallback($formula) : cs:C1710.widget
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($formula)=Is object:K8:27)
			
			If (Asserted:C1132(OB Instance of:C1731($formula; 4D:C1709.Function); "The formula parameter must be a 4D.Function"))
				
				This:C1470._callback:=$formula
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($formula)=Is text:K8:3)
			
			// Remaps, if necessary, into the class of the current form
			// If formula string is "This.xxx" or ".xxx"
			
			$formula:=Position:C15("this"; $formula)=1 ? Delete string:C232($formula; 1; 4) : $formula
			
			If (Position:C15("."; $formula)=1)
				
				This:C1470._callback:=Formula from string:C1601("Form:C1466.__DIALOG__"+String:C10($formula))
				
			Else 
				
				This:C1470._callback:=Formula from string:C1601(String:C10($formula))
				
			End if 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The formula parameter must be a 4D.Function or a Text formula")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function execute()
	
	If (Asserted:C1132(This:C1470._callback#Null:C1517; "No callback method define"))
		
		This:C1470._callback.call()
		
	End if 
	
	// MARK:-[Miscellaneous]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function focus() : cs:C1710.widget
	
	GOTO OBJECT:C206(*; This:C1470.name)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFocused() : Boolean
	
	return OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470.name
	