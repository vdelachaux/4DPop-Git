//=== === === === === === === === === === === === === === === === === === === === === 
Class constructor($method : Text)
	
	Super:C1705()
	
	This:C1470.currentForm:=Current form name:C1298
	This:C1470.window:=Current form window:C827
	
	This:C1470.visible:=True:C214
	
	This:C1470.toBeInitialized:=True:C214
	
	This:C1470._callback:=$method
	This:C1470._worker:=Null:C1517
	
	This:C1470.isSubform:=False:C215
	
	This:C1470.current:=Null:C1517
	
	This:C1470.widgets:=New object:C1471
	
	This:C1470.entryOrder:=New collection:C1472
	
	//MARK:-[COMPUTED ATTRIBUTES]
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get focused() : Text  /// The name of the object that has the focus in the form
	
	return (OBJECT Get name:C1087(Object with focus:K67:3))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get darkScheme() : Boolean
	
	return (FORM Get color scheme:C1761="dark")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get lightScheme() : Boolean
	
	return (FORM Get color scheme:C1761="light")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get windowTitle() : Text
	
	return (Get window title:C450(This:C1470.window))
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function set windowTitle($title : Text)
	
	var $t : Text
	$t:=Get localized string:C991($title)
	SET WINDOW TITLE:C213($t ? $t : $title; This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get frontmost() : Boolean
	
	return (Frontmost window:C447=This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function get worker() : Variant
	
	return (This:C1470._worker)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function set worker($worker)
	
	var $type : Integer
	
	$type:=Value type:C1509($worker)
	
	If (Asserted:C1132(($type=Is text:K8:3)\
		 | ($type=Is real:K8:4)\
		 | ($type=Is longint:K8:6); "The parameter must be a text or a number"))
		
		This:C1470._worker:=$worker
		
	Else 
		
		BEEP:C151
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function get callback() : Text
	
	return (This:C1470._callback)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function set callback($method : Text)
	
	This:C1470._callback:=$method
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function get width() : Integer
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	return ($width)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function get height() : Integer
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	return ($height)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function get dimensions() : Object
	
	var $height; $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return (New object:C1471(\
		"width"; $width; \
		"height"; $height))
	
	
	//MARK:-TO BE OVERWRITTEN IN THE SUBCLASS
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	ASSERT:C1129(False:C215; "👀 init() must be overriden by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function onLoad()
	
	ASSERT:C1129(False:C215; "👀 onLoad() must be overriden by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function saveContext()
	
	ASSERT:C1129(False:C215; "👀 saveContext() must overriden done by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function restoreContext()
	
	ASSERT:C1129(False:C215; "👀 restore() must be overriden by the subclass!")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function handleEvents()
	
	ASSERT:C1129(False:C215; "👀 handleEvents() must be overriden by the subclass!")
	
	//MARK:-[FUNCTIONS] 
	//=== === === === === === === === === === === === === === === === === === === === === 
Function close()
	
	CLOSE WINDOW:C154(This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function hide()
	
	HIDE WINDOW:C436(This:C1470.window)
	This:C1470.visible:=False:C215
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function show()
	
	SHOW WINDOW:C435(This:C1470.window)
	This:C1470.visible:=True:C214
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function bringToFront()
	
	var $bottom; $left; $right; $top : Integer
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.window)
	SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.window)
	This:C1470.show()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function redraw()
	
/*
In some cases, on Windows platform, some regions are not invalidated after 
resizing or moving subforms. This trick allows you to force the window 
to be redrawn without any effect apparent for the user.
*/
	
	RESIZE FORM WINDOW:C890(1; 0)
	RESIZE FORM WINDOW:C890(-1; 0)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function minimize()
	
	MINIMIZE WINDOW:C454(This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function maximize()
	
	MAXIMIZE WINDOW:C453(This:C1470.window)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// 🛠 IN WORKS
Function getWidgets()
	
	var $name : Text
	var $i; $type : Integer
	ARRAY TEXT:C222($objects; 0)
	
	FORM GET OBJECTS:C898($objects; Form all pages:K67:7)
	
	For ($i; 1; Size of array:C274($objects); 1)
		
		$name:=$objects{$i}
		$type:=OBJECT Get type:C1300(*; $name)
		
		Case of 
				//______________________________________________________
			: ($type=Object type push button:K79:16)\
				 | ($type=Object type radio button:K79:23)\
				 | ($type=Object type checkbox:K79:26)\
				 | ($type=Object type 3D button:K79:17)\
				 | ($type=Object type 3D checkbox:K79:27)\
				 | ($type=Object type 3D radio button:K79:24)\
				 | ($type=Object type picture button:K79:20)
				
				This:C1470._instantiate("button"; $name)
				
				//______________________________________________________
			: ($type=Object type static text:K79:2)\
				 | ($type=Object type static picture:K79:3)\
				 | ($type=Object type line:K79:33)\
				 | ($type=Object type rectangle:K79:32)\
				 | ($type=Object type rounded rectangle:K79:34)\
				 | ($type=Object type oval:K79:35)
				
				This:C1470._instantiate("static"; $name)
				
				//______________________________________________________
			: (False:C215)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
	End for 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Add form event(s) for the current form
Function appendEvents($events)
	
	This:C1470._setEvents($events; Enable events others unchanged:K42:38)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Remove form event(s) for the current form
Function removeEvents($events)
	
	This:C1470._setEvents($events; Disable events others unchanged:K42:39)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Define the event(s) for the current form
Function setEvents($events)
	
	This:C1470._setEvents($events; Enable events disable others:K42:37)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Set the entry order of the current form for the current process
Function setEntryOrder($widgetNames : Collection)
	
	ARRAY TEXT:C222($entryOrder; 0x0000)
	COLLECTION TO ARRAY:C1562($widgetNames; $entryOrder)
	FORM SET ENTRY ORDER:C1468($entryOrder)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Start a timer to update the user interface
	// Default delay is ASAP
Function refresh($delay : Integer)
	
	If (Count parameters:C259>=1)
		
		SET TIMER:C645($delay)
		
	Else 
		
		SET TIMER:C645(-1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function stopTimer()
	
	SET TIMER:C645(0)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Creates a CALL FORM of the current form (callback) & with current callback method
	// .callMeBack ()
	// .callMeBack ( param : Collection )
	// .callMeBack ( param1, param2, …, paramN )
Function callMeBack($param; $param1; $paramN)
	
	C_VARIANT:C1683(${1})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Length:C16(String:C10(This:C1470._callback))#0)
		
		If (Count parameters:C259=0)
			
			CALL FORM:C1391(This:C1470.window; This:C1470._callback)
			
		Else 
			
			$code:="CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+This:C1470._callback+"\""
			
			If (Value type:C1509($1)=Is collection:K8:32)
				
				$parameters:=$1
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 1; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-1)+"]"
					
				End for 
			End if 
			
			$code:=$code+")"
			
			Formula from string:C1601($code).call(Null:C1517; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "Callback method is not defined.")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Creates a CALL FORM of the current form (callback) with the passed method
	// .callMe ( method : Text )
	// .callMe ( method : Text ; param : Collection )
	// .callMe ( method : Text ; param1, param2, …, paramN )
Function callMe($method : Text; $param1; $paramN)
	
	C_VARIANT:C1683(${2})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Count parameters:C259=1)
		
		CALL FORM:C1391(This:C1470.window; $method)
		
	Else 
		
		$code:="CALL FORM:C1391("+String:C10(This:C1470.window)+"; \""+$method+"\""
		
		If (Value type:C1509($2)=Is collection:K8:32)
			
			$parameters:=$2
			
			For ($i; 0; $parameters.length-1; 1)
				
				$code:=$code+"; $1["+String:C10($i)+"]"
				
			End for 
			
		Else 
			
			$parameters:=New collection:C1472
			
			For ($i; 2; Count parameters:C259; 1)
				
				$parameters.push(${$i})
				$code:=$code+"; $1["+String:C10($i-2)+"]"
				
			End for 
		End if 
		
		$code:=$code+")"
		
		Formula from string:C1601($code).call(Null:C1517; $parameters)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Assigns a task to the associated worker
	// .callWorker ( method : Text )
	// .callWorker ( method : Text ; param : Collection )
	// .callWorker ( method : Text ; param1, param2, …, paramN )
	// ---------------------------------------------------------------------------------
	//TODO: Accept an integer as first parameter to allow calling a specific worker.
	// .callWorker ( process : Integer ; method : Text )
	// .callWorker ( process : Integer ; method : Text ; param : Collection )
	// .callWorker ( process : Integer ; method : Text ; param1, param2, …, paramN )
	// ---------------------------------------------------------------------------------
Function callWorker($method; $param; $param1; $paramN)
	
	C_VARIANT:C1683(${2})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (This:C1470._worker#Null:C1517)
		
		If (Count parameters:C259=1)
			
			CALL WORKER:C1389(This:C1470._worker; $method)
			
		Else 
			
			$code:="CALL WORKER:C1389(\""+This:C1470._worker+"\"; \""+$method+"\""
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				$parameters:=$2
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 2; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					$code:=$code+"; $1["+String:C10($i-2)+"]"
					
				End for 
			End if 
			
			$code:=$code+")"
			
			Formula from string:C1601($code).call(Null:C1517; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "No associated worker")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Executes a project method in the context of a subform (without returned value)
	// .executeInSubform ( subform : Object | Text ; method : Text )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param : Collection )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param1, param2, …, paramN )
Function callChild($subform; $method : Text; $param; $param1; $paramN)
	
	C_VARIANT:C1683(${3})
	
	var $code; $target : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Value type:C1509($subform)=Is object:K8:27)
		
		// We assume it's a subform object
		ASSERT:C1129($subform.name#Null:C1517)
		$target:=$subform.name
		
	Else 
		
		$target:=String:C10($subform)
		
	End if 
	
	ARRAY TEXT:C222($widgets; 0)
	FORM GET OBJECTS:C898($widgets; Form all pages:K67:7)
	
	If (Find in array:C230($widgets; $target)>0)
		
		If (Count parameters:C259=2)
			
			EXECUTE METHOD IN SUBFORM:C1085($target; $method)
			
		Else 
			
			$code:="EXECUTE METHOD IN SUBFORM:C1085(\""+$target+"\"; \""+$method+"\";*"
			
			If (Value type:C1509($3)=Is collection:K8:32)
				
				$parameters:=$3
				
				For ($i; 0; $parameters.length-1; 1)
					
					$code:=$code+"; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				$parameters:=New collection:C1472
				
				For ($i; 3; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-3)+"]"
					
				End for 
			End if 
			
			$code:=$code+")"
			
			Formula from string:C1601($code).call(Null:C1517; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(Structure file:C489=Structure file:C489(*); "Subform not found: "+$target)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function spreadToChilds($param : Object)
	
	form_spreadToSubforms($param)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Send an event to the subform container
Function callParent($event : Integer)
	
	If (Asserted:C1132(This:C1470.isSubform; "🛑 Only applicable for sub-forms!"))
		
		CALL SUBFORM CONTAINER:C1086($event)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function page($subform : Boolean) : Integer
	
	$subform:=Count parameters:C259>=1 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		return (FORM Get current page:C276(*))
		
	Else 
		
		return (FORM Get current page:C276)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function goToPage($page : Integer; $subform : Boolean)
	
	$subform:=Count parameters:C259>=2 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		FORM GOTO PAGE:C247($page; *)
		
	Else 
		
		FORM GOTO PAGE:C247($page)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function firstPage($subform : Boolean)
	
	$subform:=Count parameters:C259>=1 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		FORM GOTO PAGE:C247(1; *)
		
	Else 
		
		FORM FIRST PAGE:C250
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function lastPage($subform : Boolean)
	
	$subform:=Count parameters:C259>=1 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		var $height; $numPages; $width : Integer
		FORM GET PROPERTIES:C674(String:C10(This:C1470.currentForm); $width; $height; $numPages)
		FORM GOTO PAGE:C247($numPages; *)
		
	Else 
		
		FORM LAST PAGE:C251
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function nextPage($subform : Boolean)
	
	$subform:=Count parameters:C259>=1 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		FORM GOTO PAGE:C247(FORM Get current page:C276(*)+1; *)
		
	Else 
		
		FORM NEXT PAGE:C248
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function previousPage($subform : Boolean)
	
	$subform:=Count parameters:C259>=1 ? $subform : This:C1470.isSubform
	
	If ($subform)
		
		FORM GOTO PAGE:C247(FORM Get current page:C276(*)-1; *)
		
	Else 
		
		FORM PREVIOUS PAGE:C249
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Gives the focus to a widget in the current form
Function goTo($widget : Text)
	
	// TODO: allow a cs.widget
	
	GOTO OBJECT:C206(*; $widget)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Remove any focus in the current form
Function removeFocus()
	
	GOTO OBJECT:C206(*; "")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function postKeyDown($keyCode : Integer; $modifier : Integer)
	
	POST EVENT:C467(Key down event:K17:4; $keyCode; Tickcount:C458; 0; 0; $modifier; Current process:C322)
	
	//MARK:-[WIDGETS CREATION]
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a static object instance
Function formObject($name : Text; $widgetName : Text) : cs:C1710.formObject
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("formObject"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("formObject"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a button object instance
Function button($name : Text; $widgetName : Text) : cs:C1710.button
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("button"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("button"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a widget object instance
Function widget($name : Text; $widgetName : Text) : cs:C1710.widget
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("widget"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("widget"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a input object instance
Function input($name : Text; $widgetName : Text) : cs:C1710.input
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("input"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("input"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a stepper object instance
Function stepper($name : Text; $widgetName : Text) : cs:C1710.stepper
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("stepper"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("stepper"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a thermometer object instance
Function thermometer($name : Text; $widgetName : Text) : cs:C1710.thermometer
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("thermometer"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("thermometer"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a listbox object instance
Function listbox($name : Text; $widgetName : Text) : cs:C1710.listbox
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("listbox"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("listbox"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a picture object instance
Function picture($name : Text; $widgetName : Text) : cs:C1710.picture
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("picture"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("picture"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a subform object instance
Function subform($name : Text; $widgetName : Text) : cs:C1710.subform
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("subform"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("subform"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a selector object instance
Function selector($name : Text; $widgetName : Text) : cs:C1710.selector
	
	If (Count parameters:C259>=2)
		
		This:C1470._instantiate("selector"; $name; $widgetName)
		
	Else 
		
		This:C1470._instantiate("selector"; $name)
		
	End if 
	
	return (This:C1470[$name])
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Create a group instance
Function group($name : Text; $member; $member2; $memberN) : cs:C1710.group
	
	var ${2}
	var $i : Integer
	
	This:C1470[$name]:=cs:C1710.group.new()
	
	For ($i; 2; Count parameters:C259; 1)
		
		This:C1470[$name].addMember(${$i})
		
	End for 
	
	return (This:C1470[$name])
	
	//MARK:-[CURSOR]
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursor($cursor : Integer)
	
	If (Count parameters:C259>=1)
		
		SET CURSOR:C469($cursor)
		
	Else 
		
		SET CURSOR:C469
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function releaseCursor()
	
	SET CURSOR:C469
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorNotAllowed($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9019)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorDragCopy($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9016)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorArrow($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(1303)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorText($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(256)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorCrosshair($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(1382)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorWatch($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(260)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setCursorPointingHand($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9000)
		
	End if 
	
	//MARK:-[DRAGG & DROP]
	//=== === === === === === === === === === === === === === === === === === === === === 
Function beginDrag($uri : Text; $data; $dragIcon : Picture)
	
	var $x : Blob
	
	If (Value type:C1509($data)=Is BLOB:K8:12)
		
		APPEND DATA TO PASTEBOARD:C403($uri; $data)
		
	Else 
		
		VARIABLE TO BLOB:C532($data; $x)
		APPEND DATA TO PASTEBOARD:C403($uri; $x)
		
	End if 
	
	If (Count parameters:C259>=3)
		
		SET DRAG ICON:C1272($dragIcon)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function getPasteboard($uri : Text) : Variant
	
	var $value
	var $data : Blob
	
	GET PASTEBOARD DATA:C401($uri; $data)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($data; $value)
		SET BLOB SIZE:C606($data; 0)
		
		return $value
		
	End if 
	
	//MARK:-[PRIVATE]
Function _instantiate($class : Text; $key : Text; $name : Text)
	
	If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
		
		Case of 
				
				//______________________________________________________
			: (Count parameters:C259=3)
				
				This:C1470[$key]:=cs:C1710[$class].new($name)
				
				//______________________________________________________
			: (Count parameters:C259=2)  // Use key as the widget name
				
				This:C1470[$key]:=cs:C1710[$class].new($key)
				
				//______________________________________________________
			: (Count parameters:C259=1)  // A tool init
				
				This:C1470[$class]:=cs:C1710[$class].new()
				
				//______________________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// [PRIVATE] set form events
Function _setEvents($events; $mode : Integer)
	
	ARRAY LONGINT:C221($codes; 0)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($events)=Is collection:K8:32)
			
			COLLECTION TO ARRAY:C1562($events; $codes)
			
			//______________________________________________________
		: (Value type:C1509($events)=Is integer:K8:5)\
			 | (Value type:C1509($events)=Is longint:K8:6)\
			 | (Value type:C1509($events)=Is real:K8:4)
			
			//ARRAY LONGINT($codes; 1)
			APPEND TO ARRAY:C911($codes; $events)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The event parameter must be an number or a collection")
			
			//______________________________________________________
	End case 
	
	OBJECT SET EVENTS:C1239(*; ""; $codes; $mode)
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	//Function _cursor($id : Integer; $diplay : Boolean)
	//If (Count parameters=0)
	//SET CURSOR
	//Else 
	//If (Count parameters<2 ? True : $display)
	//SET CURSOR($id)
	//End if 
	//End if
	