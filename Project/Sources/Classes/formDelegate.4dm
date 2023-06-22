property currentForm : Text
property isSubform; toBeInitialized; visible : Boolean
property pageNumber : Integer
property definition; pages : Object
property entryOrder; instantiableWidgets; mapEvents : Collection

property __CLASS__ : Object
property __DELEGATES__ : Collection

//property static : cs.staticDelegate
//property button : cs.buttonDelegate
//property comboBox : cs.comboBoxDelegate
//property dropDown : cs.dropDownDelegate
//property group : cs.groupDelegate
//property hList : cs.hListDelegate
//property input : cs.inputDelegate
//property listbox : cs.listboxDelegate
//property picture : cs.pictureDelegate
//property selector : cs.selectorDelegate
//property stepper : cs.stepperDelegate
//property subform : cs.subformDelegate
//property thermometer : cs.thermometerDelegate
//property widget : cs.widgetDelegate
//property window : cs.windowDelegate

Class constructor($param)
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.currentForm:=Current form name:C1298
	This:C1470.visible:=True:C214
	
	// MARK: Default values ⚙️
	This:C1470.isSubform:=False:C215
	This:C1470.toBeInitialized:=True:C214
	
	var $height; $numPages; $width : Integer
	FORM GET PROPERTIES:C674(String:C10(This:C1470.currentForm); $width; $height; $numPages)
	This:C1470.pageNumber:=$numPages
	
	This:C1470.pages:={}
	
	var $i : Integer
	For ($i; 1; $numPages; 1)
		
		This:C1470.pages["page_"+String:C10($i)]:=$i
		
	End for 
	
	This:C1470._worker:=Null:C1517
	This:C1470._callback:=Null:C1517
	This:C1470._darkExtension:="_dark"
	This:C1470.entryOrder:=[]
	
	This:C1470.current:=Null:C1517
	
	Case of 
			
			//______________________________________________________
		: ($param=Null:C1517)
			
			//
			
			//______________________________________________________
		: (Value type:C1509($param)=Is text:K8:3)  // Callback method's name
			
			This:C1470._callback:=$param
			
			//______________________________________________________
		: (Value type:C1509($param)=Is object:K8:27)
			
			This:C1470.__SUPER__:=$param
			
			This:C1470._worker:=String:C10($param.worker) || This:C1470._worker
			This:C1470._callback:=String:C10($param.callback) || This:C1470._callback
			This:C1470.isSubform:=$param.isSubform#Null:C1517 ? Bool:C1537($param.isSubform) : This:C1470.isSubform
			This:C1470.toBeInitialized:=$param.toBeInitialized#Null:C1517 ? Bool:C1537($param.toBeInitialized) : This:C1470.toBeInitialized
			This:C1470._darkExtension:=String:C10($param.darkExtension) || This:C1470._darkExtension
			This:C1470.entryOrder:=$param.entryOrder || This:C1470.entryOrder
			This:C1470.pages:=$param.pages || This:C1470.pages
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The 'param' parameter must be a text or an object.")
			
			//______________________________________________________
	End case 
	
	// MARK:Delegates 📦
	This:C1470.__DELEGATES__:=[]
	
	This:C1470.button:=cs:C1710.buttonDelegate
	This:C1470.__DELEGATES__.push(This:C1470.button)
	
	This:C1470.comboBox:=cs:C1710.comboBoxDelegate
	This:C1470.__DELEGATES__.push(This:C1470.comboBox)
	
	This:C1470.dropDown:=cs:C1710.dropDownDelegate
	This:C1470.__DELEGATES__.push(This:C1470.dropDown)
	
	This:C1470.group:=cs:C1710.groupDelegate
	This:C1470.__DELEGATES__.push(This:C1470.group)
	
	This:C1470.hList:=cs:C1710.hListDelegate
	This:C1470.__DELEGATES__.push(This:C1470.hList)
	
	This:C1470.input:=cs:C1710.inputDelegate
	This:C1470.__DELEGATES__.push(This:C1470.input)
	
	This:C1470.listbox:=cs:C1710.listboxDelegate
	This:C1470.__DELEGATES__.push(This:C1470.listbox)
	
	This:C1470.picture:=cs:C1710.pictureDelegate
	This:C1470.__DELEGATES__.push(This:C1470.picture)
	
	This:C1470.selector:=cs:C1710.selectorDelegate
	This:C1470.__DELEGATES__.push(This:C1470.selector)
	
	This:C1470.static:=cs:C1710.staticDelegate
	This:C1470.__DELEGATES__.push(This:C1470.static)
	
	This:C1470.stepper:=cs:C1710.stepperDelegate
	This:C1470.__DELEGATES__.push(This:C1470.stepper)
	
	This:C1470.subform:=cs:C1710.subformDelegate
	This:C1470.__DELEGATES__.push(This:C1470.subform)
	
	This:C1470.thermometer:=cs:C1710.thermometerDelegate
	This:C1470.__DELEGATES__.push(This:C1470.thermometer)
	
	This:C1470.widget:=cs:C1710.widgetDelegate
	This:C1470.__DELEGATES__.push(This:C1470.widget)
	
	This:C1470.window:=cs:C1710.windowDelegate.new(This:C1470)
	This:C1470.__DELEGATES__.push(This:C1470.window)
	
	This:C1470.instantiableWidgets:=[\
		This:C1470.static; \
		This:C1470.button; \
		This:C1470.comboBox; \
		This:C1470.dropDown; \
		This:C1470.hList; \
		This:C1470.input; \
		This:C1470.listbox; \
		This:C1470.picture; \
		This:C1470.selector; \
		This:C1470.stepper; \
		This:C1470.subform; \
		This:C1470.thermometer; \
		This:C1470.widget]
	
	// MARK:Dev 🚧
	This:C1470.isMatrix:=Structure file:C489=Structure file:C489(*)
	
	// Keep the form definition
	var $file : 4D:C1709.File
	
	// Component forms have priority
	ARRAY TEXT:C222($forms; 0x0000)
	FORM GET NAMES:C1167($forms)
	
	If (Find in array:C230($forms; This:C1470.currentForm)#-1)
		
		$file:=File:C1566("/SOURCES/Forms/"+This:C1470.currentForm+"/form.4DForm")
		
	Else 
		
		$file:=File:C1566("/SOURCES/Forms/"+This:C1470.currentForm+"/form.4DForm"; *)
		
	End if 
	
	If ($file.exists)
		
		This:C1470.definition:=JSON Parse:C1218($file.getText())
		
	End if 
	
	This:C1470.mapEvents:=This:C1470._mapEventsDefinition()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470._standardSuite("init")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents()
	
	This:C1470._standardSuite("handleEvents")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	var $event; $key : Text
	var $o; $page; $widget : Object
	var $events; $widgets : Collection
	
	// Defines the container reference in subform instances
	For each ($o; This:C1470.instantiatedSubforms)
		
		$o._execute(Formula:C1597(Form:C1466.__DIALOG__.__CONTAINER__:=$o))
		
	End for each 
	
	// Add the widgets events that we cannot select in the form properties 😇
	// ⚠️ OBJECT GET EVENTS return an empty array if no object method
	
	$widgets:=This:C1470._getInstantiated()
	
	If ($widgets.length>0)
		
		$events:=[]
		
		For each ($page; This:C1470.definition.pages)
			
			If ($page#Null:C1517)
				
				For each ($key; $page.objects)
					
					$widget:=$widgets.query("name = :1"; $key).pop()
					
					If ($widget#Null:C1517)\
						 && ($page.objects[$key].events#Null:C1517)
						
						For each ($event; $page.objects[$key].events)
							
							$o:=This:C1470.mapEvents.query("e = :1"; $event).pop()
							
							If (Asserted:C1132($o#Null:C1517; "FIXME:Add missing event map for "+$event))
								
								// Update the widget
								$widget.events:=$widget.events || []
								$widget.events.push($o.k)
								
								// Keep the event
								$events.push($o.k)
								
							End if 
						End for each 
					End if 
				End for each 
			End if 
		End for each 
		
		If ($events.length>0)
			
			This:C1470.appendEvents($events.distinct())
			
		End if 
	End if 
	
	This:C1470._standardSuite("onLoad")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update($stopTimer : Boolean)
	
	$stopTimer:=Count parameters:C259=0 ? True:C214 : $stopTimer
	
	If ($stopTimer)
		
		SET TIMER:C645(0)
		
	End if 
	
	This:C1470._standardSuite("update")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onBoundVariableChange()
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		This:C1470._standardSuite("onBoundVariableChange")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function saveContext()
	
	// TODO:Generic?
	This:C1470._standardSuite("saveContext")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	// TODO:Generic?
	This:C1470._standardSuite("restoreContext")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onOutsideCall()
	
	This:C1470._standardSuite("onOutsideCall")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _standardSuite($name : Text)
	
	If (This:C1470.__SUPER__#Null:C1517)
		
		If (Asserted:C1132(OB Instance of:C1731(This:C1470.__SUPER__[$name]; 4D:C1709.Function); "The function "+$name+"() is not define into the class "+This:C1470.__SUPER__.__CLASS__.name))
			
			This:C1470.__SUPER__[$name]()
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; "👀 "+$name+"() must be overriden by the subclass!")
		
	End if 
	
	// MARK:-[Focus]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// The name of the object that has the focus in the form
Function get focused() : Text
	
	return OBJECT Get name:C1087(Object with focus:K67:3)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Gives the focus to a widget in the current form
Function focus($widget)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($widget)=Is text:K8:3)
			
			GOTO OBJECT:C206(*; $widget)
			
			//______________________________________________________
		: (Value type:C1509($widget)=Is object:K8:27) && (OB Instance of:C1731($widget; cs:C1710.widgetDelegate))
			
			GOTO OBJECT:C206(*; $widget.name)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Widget must be a widget object or a name!")
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Remove any focus in the current form
Function removeFocus()
	
	GOTO OBJECT:C206(*; "")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the text currently selected
Function get highlight() : Text
	
	var $widget : Text
	var $begin; $end : Integer
	var $ptr : Pointer
	
	$widget:=OBJECT Get name:C1087(Object with focus:K67:3)
	$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $widget)
	
	If (Length:C16($widget)=0)\
		 | (Is nil pointer:C315($ptr))
		
		return ""
		
	End if 
	
	GET HIGHLIGHT:C209(*; $widget; $begin; $end)
	
	If ($end>$begin)
		
		return Substring:C12($ptr->; $begin; $end-$begin)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets the entry order of the current form for the current process
Function setEntryOrder($widgetNames : Collection)
	
	ARRAY TEXT:C222($entryOrder; 0x0000)
	
	If (Value type:C1509($widgetNames[0])=Is object:K8:27)
		
		$widgetNames:=$widgetNames.extract("name")
		
	End if 
	
	ARRAY TEXT:C222($entryOrder; 0x0000)
	COLLECTION TO ARRAY:C1562($widgetNames; $entryOrder)
	FORM SET ENTRY ORDER:C1468($entryOrder)
	
	// MARK:-[Color Scheme]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns True if the current color scheme is dark.
Function get darkScheme() : Boolean
	
	return FORM Get color scheme:C1761="dark"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns True if the current color scheme is light.
Function get lightScheme() : Boolean
	
	return FORM Get color scheme:C1761="light"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns a resource name with the current "dark" suffix if the color scheme is dark.
Function get resourceScheme() : Text
	
	return This:C1470.darkScheme ? This:C1470._darkExtension : ""
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Return the given resource path with scheme suffix if any
Function resourceFromScheme($path : Text) : Text
	
	var $t : Text
	var $c : Collection
	var $file : 4D:C1709.File
	
	If (This:C1470.darkScheme)
		
		$file:=File:C1566($path)
		
		$c:=Split string:C1554($file.fullName; ".")
		$c[0]:=$c[0]+This:C1470._darkExtension
		
		$t:=Replace string:C233($path; $file.fullName; $c.join("."))
		
		If (File:C1566($t).exists)
			
			$path:=$t
			
		End if 
	End if 
	
	return $path
	
	// MARK:-[Timer]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Starts a timer and sets its delay, ASAP if omitted.
Function setTimer($tickCount : Integer)
	
	SET TIMER:C645($tickCount)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Starts a timer and sets its delay, ASAP if omitted.
Function refresh($tickCount : Integer)
	
	$tickCount:=Count parameters:C259=0 ? -1 : $tickCount
	SET TIMER:C645($tickCount)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Disables the timer
Function stopTimer()
	
	SET TIMER:C645(0)
	
	// MARK:-[Associated Worker]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Gets the associated worker
Function get worker() : Variant
	
	return String:C10(This:C1470._worker)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Sets the associated worker
Function set worker($worker)
	
	var $type : Integer
	
	$type:=Value type:C1509($worker)
	
	If (Asserted:C1132(($type=Is text:K8:3)\
		 | ($type=Is real:K8:4)\
		 | ($type=Is longint:K8:6); "The parameter must be a text or a number"))
		
		This:C1470._worker:=$worker
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Assigns a task to the associated worker
Function callWorker($method; $param; $param1; $paramN)
	
/**
.callWorker ( method : Text )
.callWorker ( method : Text ; param : Collection )
.callWorker ( method : Text ; param1, param2, …, paramN )
**/
	
	// ---------------------------------------------------------------------------------
	//TODO: Accept an integer as first parameter to allow calling a specific worker.
	// .callWorker ( process : Integer ; method : Text )
	// .callWorker ( process : Integer ; method : Text ; param : Collection )
	// .callWorker ( process : Integer ; method : Text ; param1, param2, …, paramN )
	// ---------------------------------------------------------------------------------
	
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
				
				$parameters:=[]
				
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
	
	// MARK:-[Subform]
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get containerName() : Text
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		return This:C1470.__SUPER__.__CONTAINER__.parent.container
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get container() : Object
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		return This:C1470.__SUPER__.__CONTAINER__.__SUPER__
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get containerInstance() : Object
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		return This:C1470.container[This:C1470.containerName]
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets the container value
Function setValue($value)
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		OBJECT SET SUBFORM CONTAINER VALUE:C1784($value)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the container value
Function getValue() : Variant
	
	If (Asserted:C1132(This:C1470.isSubform; "Warning: This form is not declared as a subform"))
		
		return OBJECT Get subform container value:C1785
		
	End if 
	
	// MARK:-[Events]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get events() : Collection
	
	var $c : Collection
	
	ARRAY LONGINT:C221($codes; 0)
	
	OBJECT GET EVENTS:C1238(*; ""; $codes)
	$c:=[]
	ARRAY TO COLLECTION:C1563($c; $codes)
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Define the event(s) for the current form
Function setEvents($events)
	
	This:C1470._setEvents($events; Enable events disable others:K42:37)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Add form event(s) for the current form
Function appendEvents($events)
	
	This:C1470._setEvents($events; Enable events others unchanged:K42:38)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Remove form event(s) for the current form
Function removeEvents($events)
	
	This:C1470._setEvents($events; Disable events others unchanged:K42:39)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
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
			
			APPEND TO ARRAY:C911($codes; $events)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The event parameter must be an number or a collection")
			
			//______________________________________________________
	End case 
	
	OBJECT SET EVENTS:C1239(*; ""; $codes; $mode)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Posts a keyboard event
Function postKeyDown($keyCode : Integer; $modifier : Integer)
	
	POST EVENT:C467(Key down event:K17:4; $keyCode; Tickcount:C458; 0; 0; $modifier; Current process:C322)
	
	// MARK:-[Calls]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Gets the current callback method's name
Function get callback() : Text
	
	return String:C10(This:C1470._callback)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Sets the current callback method's name
Function set callback($method : Text)
	
	This:C1470._callback:=$method
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Generates a callback of the current form with the current callback method
Function callMeBack($param; $param1; $paramN)
	
/**
.callMeBack ()
.callMeBack ( param : Collection )
.callMeBack ( param1, param2, …, paramN )
**/
	
	This:C1470.callMe(This:C1470._callback; Copy parameters:C1790)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Generates a callback of the current form with the given method
Function callMe($method : Text; $param1; $paramN)
	
/*
.callMe ( method : Text )
.callMe ( method : Text ; param : Collection )
.callMe ( method : Text ; param1, param2, …, paramN )
*/
	
	C_VARIANT:C1683(${2})
	
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (Count parameters:C259=1)
		
		CALL FORM:C1391(This:C1470.window.ref; $method)
		
	Else 
		
		$code:="CALL FORM:C1391("+String:C10(This:C1470.window.ref)+"; \""+$method+"\""
		
		If (Value type:C1509($2)=Is collection:K8:32)
			
			$parameters:=$2
			
			For ($i; 0; $parameters.length-1; 1)
				
				$code:=$code+"; $1["+String:C10($i)+"]"
				
			End for 
			
		Else 
			
			$parameters:=[]
			
			For ($i; 2; Count parameters:C259; 1)
				
				$parameters.push(${$i})
				$code:=$code+"; $1["+String:C10($i-2)+"]"
				
			End for 
		End if 
		
		$code:=$code+")"
		
		Formula from string:C1601($code).call(Null:C1517; $parameters)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Executes a project method in the context of a subform (without returned value)
Function callChild($subform; $method : Text; $param; $param1; $paramN)
	
	// .executeInSubform ( subform : Object | Text ; method : Text )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param : Collection )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param1, param2, …, paramN )
	
	// TODO:Returned value
	
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
				
				$parameters:=[]
				
				For ($i; 3; Count parameters:C259; 1)
					
					$parameters.push(${$i})
					
					$code:=$code+"; $1["+String:C10($i-3)+"]"
					
				End for 
			End if 
			
			$code:=$code+")"
			
			Formula from string:C1601($code).call(Null:C1517; $parameters)
			
		End if 
		
	Else 
		
		ASSERT:C1129(This:C1470.isMatrix; "Subform not found: "+$target)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function spreadToChilds($message : Object)
	
	form_spreadToSubforms($message)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Send an event to a subform container
Function callParent($eventCode : Integer)
	
	If (Asserted:C1132(This:C1470.isSubform; "🛑 Only applicable for sub-forms!"))
		
		CALL SUBFORM CONTAINER:C1086($eventCode)
		
	End if 
	
	// MARK:-[Pages]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the current page number 
Function get page() : Integer
	
	If (This:C1470.isSubform)
		
		return FORM Get current page:C276(*)
		
	Else 
		
		return FORM Get current page:C276
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays a given page
Function goToPage($page)
	
	ASSERT:C1129((Value type:C1509($page)=Is text:K8:3) || (Value type:C1509($page)=Is real:K8:4) || (Value type:C1509($page)=Is integer:K8:5); "page parameter must be a text or a number")
	
	If (Value type:C1509($page)=Is text:K8:3)
		
		$page:=Num:C11(This:C1470.pages[$page])
		
	End if 
	
	If (Asserted:C1132(($page>0) & ($page<=This:C1470.pageNumber); "The page "+String:C10($page)+" doesn't exists"))
		
		If (This:C1470.isSubform)
			
			FORM GOTO PAGE:C247($page; *)
			
		Else 
			
			FORM GOTO PAGE:C247($page)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the first page
Function firstPage()
	
	If (This:C1470.isSubform)
		
		FORM GOTO PAGE:C247(1; *)
		
	Else 
		
		FORM FIRST PAGE:C250
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the last page
Function lastPage()
	
	If (This:C1470.isSubform)
		
		FORM GOTO PAGE:C247(This:C1470.pageNumber; *)
		
	Else 
		
		FORM LAST PAGE:C251
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the next page
Function nextPage()
	
	If (This:C1470.isSubform)
		
		var $page : Integer
		$page:=FORM Get current page:C276(*)+1
		
		If (Asserted:C1132($page<=This:C1470.pageNumber; "There is no more page to display"))
			
			FORM GOTO PAGE:C247($page; *)
			
		End if 
		
	Else 
		
		If (Asserted:C1132(This:C1470.page<=This:C1470.pageNumber; "There is no more page to display"))
			
			FORM NEXT PAGE:C248
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the next page
Function previousPage()
	
	If (This:C1470.isSubform)
		
		var $page : Integer
		$page:=FORM Get current page:C276(*)-1
		
		If (Asserted:C1132($page>0; "You're already on the first page"))
			
			FORM GOTO PAGE:C247($page; *)
			
		End if 
		
	Else 
		
		If (Asserted:C1132(This:C1470.page>0; "You're already on the first page"))
			
			FORM PREVIOUS PAGE:C249
			
		End if 
	End if 
	
	// MARK:-[Cursor]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets the mouse cursor
Function setCursor($cursor : Integer)
	
	If (Count parameters:C259>=1)
		
		SET CURSOR:C469($cursor)
		
	Else 
		
		SET CURSOR:C469
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Restores the standard cursor
Function releaseCursor()
	
	SET CURSOR:C469
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "not allowed" cursor
Function setCursorNotAllowed($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9019)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "allowed drag" cursor
Function setCursorDragCopy($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9016)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "arrow" cursor
Function setCursorArrow($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(1303)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "text" cursor
Function setCursorText($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(256)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "crosshair" cursor
Function setCursorCrosshair($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(1382)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "watch" cursor
Function setCursorWatch($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(260)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets "pointing hand" cursor
Function setCursorPointingHand($display : Boolean)
	
	If (Count parameters:C259=0 ? True:C214 : $display)
		
		SET CURSOR:C469(9000)
		
	End if 
	
	// MARK:-[Drag & Drop]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	///
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// 
Function getPasteboard($uri : Text) : Variant
	
	var $value
	var $data : Blob
	
	GET PASTEBOARD DATA:C401($uri; $data)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($data; $value)
		SET BLOB SIZE:C606($data; 0)
		
		return $value
		
	End if 
	
	// MARK:-[FORM DEFINITION ACCESS]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All form object of the form.
Function get formObjects() : Collection
	
	return This:C1470._getformObjects()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All static text form object names of the form.
Function get staticTexts() : Collection
	
	return This:C1470._getformObjects(Object type static text:K79:2)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All static pictures form object names of the form.
Function get staticPictures() : Collection
	
	return This:C1470._getformObjects(Object type static picture:K79:3)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All static form object names of the form.
Function get statics() : Collection
	
	return This:C1470._getformObjects(Object type static text:K79:2).combine(This:C1470._getformObjects(Object type static picture:K79:3))
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All subform form object names of the form.
Function get subforms() : Collection
	
	return This:C1470._getformObjects(Object type subform:K79:40)
	
	// TODO:Others form object types 🚧 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All instantiated widgets of the form. 
Function get instantiatedWidgets() : Collection
	
	return This:C1470._getInstantiated()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// All instantiated subforms.
Function get instantiatedSubforms() : Collection
	
	return This:C1470._getInstantiated(cs:C1710.subformDelegate)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// An instantiated subform by its instance name.
Function getSubformInstance($name : Text) : Object
	
	return This:C1470._getInstantiated(cs:C1710.subformDelegate; $name)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns a collection of form object names possibly filtered by their type.
Function _getformObjects($type : Integer) : Collection
	
	var $i : Integer
	var $c : Collection
	
	ARRAY TEXT:C222($objects; 0)
	
	$c:=[]
	
	FORM GET OBJECTS:C898($objects)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // All form objects
			
			ARRAY TO COLLECTION:C1563($c; $objects)
			
			//______________________________________________________
		: (Count parameters:C259=1)  // All form objects of this type
			
			For ($i; 1; Size of array:C274($objects); 1)
				
				If (OBJECT Get type:C1300(*; $objects{$i})=$type)
					
					$c.push($objects{$i})
					
				End if 
			End for 
			
			//______________________________________________________
	End case 
	
	return $c
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns one or more instanciated widgets, possibly filtered by their class & instance name.
Function _getInstantiated($class : Object; $instanceName : Text) : Variant
	
	var $key : Text
	var $c : Collection
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // All instantiated widgets
			
			$c:=[]
			
			For each ($key; This:C1470.__SUPER__)
				
				If (Value type:C1509(This:C1470.__SUPER__[$key])=Is object:K8:27)\
					 && (This:C1470.instantiableWidgets.indexOf(OB Class:C1730(This:C1470.__SUPER__[$key]))#-1)
					
					$c.push(This:C1470.__SUPER__[$key])
					
				End if 
			End for each 
			
			return $c
			
			//______________________________________________________
		: (Count parameters:C259=1)\
			 || (Length:C16($instanceName)=0)  // The widgets of this class
			
			$c:=[]
			
			For each ($key; This:C1470.__SUPER__)
				
				If (Value type:C1509(This:C1470.__SUPER__[$key])=Is object:K8:27)\
					 && (OB Instance of:C1731(This:C1470.__SUPER__[$key]; $class))
					
					$c.push(This:C1470.__SUPER__[$key])
					
				End if 
			End for each 
			
			return $c
			
			//______________________________________________________
		: (Count parameters:C259=2)  // The widget of this class & name
			
			For each ($key; This:C1470.__SUPER__)
				
				If (Value type:C1509(This:C1470.__SUPER__[$key])=Is object:K8:27)\
					 && (OB Instance of:C1731(This:C1470.__SUPER__[$key]; $class))\
					 && ($key=$instanceName)
					
					return This:C1470.__SUPER__[$key]
					
				End if 
			End for each 
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Maps between event names and their value
Function _mapEventsDefinition() : Collection
	
	var $c : Collection
	$c:=[]
	
	$c.push({e: "onLoad"; k: On Load:K2:1})
	$c.push({e: "onUnload"; k: On Unload:K2:2})
	$c.push({e: "onValidate"; k: On Validate:K2:3})
	$c.push({e: "onClick"; k: On Clicked:K2:4})
	$c.push({e: "onDoubleClick"; k: On Double Clicked:K2:5})
	$c.push({e: "onAlternateClick"; k: On Alternative Click:K2:36})
	$c.push({e: "onLongClick"; k: On Long Click:K2:37})
	$c.push({e: "onBeforeKeystroke"; k: On Before Keystroke:K2:6})
	$c.push({e: "onAfterKeystroke"; k: On After Keystroke:K2:26})
	$c.push({e: "onAfterEdit"; k: On After Edit:K2:43})
	$c.push({e: "onGettingFocus"; k: On Getting Focus:K2:7})
	$c.push({e: "onLosingFocus"; k: On Losing Focus:K2:8})
	$c.push({e: "onActivate"; k: On Activate:K2:9})
	$c.push({e: "onDeactivate"; k: On Deactivate:K2:10})
	$c.push({e: "onOutsideCall"; k: On Outside Call:K2:11})
	$c.push({e: "onPageChange"; k: On Page Change:K2:54})
	$c.push({e: "onBeginDragOver"; k: On Begin Drag Over:K2:44})
	$c.push({e: "onDrop"; k: On Drop:K2:12})
	$c.push({e: "onDragOver"; k: On Drag Over:K2:13})
	$c.push({e: "onMouseEnter"; k: On Mouse Enter:K2:33})
	$c.push({e: "onMouseMove"; k: On Mouse Move:K2:35})
	$c.push({e: "onMouseLeave"; k: On Mouse Leave:K2:34})
	$c.push({e: "onMouseUp"; k: On Mouse Up:K2:58})
	$c.push({e: "onMenuSelect"; k: On Menu Selected:K2:14})
	$c.push({e: "onBoundVariableChange"; k: On Bound Variable Change:K2:52})
	$c.push({e: "onDataChange"; k: On Data Change:K2:15})
	$c.push({e: "onPluginArea"; k: On Plug in Area:K2:16})
	$c.push({e: "onHeader"; k: On Header:K2:17})
	$c.push({e: "onPrintingDetail"; k: On Printing Detail:K2:18})
	$c.push({e: "onPrintingBreak"; k: On Printing Break:K2:19})
	$c.push({e: "onPrintingFooter"; k: On Printing Footer:K2:20})
	$c.push({e: "onCloseBox"; k: On Close Box:K2:21})
	$c.push({e: "onDisplayDetail"; k: On Display Detail:K2:22})
	$c.push({e: "onOpenDetail"; k: On Open Detail:K2:23})
	$c.push({e: "onCloseDetail"; k: On Close Detail:K2:24})
	$c.push({e: "onResize"; k: On Resize:K2:27})
	$c.push({e: "onSelectionChange"; k: On Selection Change:K2:29})
	$c.push({e: "onLoadecord"; k: On Load Record:K2:38})
	$c.push({e: "onTimer"; k: On Timer:K2:25})
	$c.push({e: "onScroll"; k: On Scroll:K2:57})
	$c.push({e: "onBeforeDataEntry"; k: On Before Data Entry:K2:39})
	$c.push({e: "onColumnMoved"; k: On Column Moved:K2:30})
	$c.push({e: "onRowMoved"; k: On Row Moved:K2:32})
	$c.push({e: "onColumnResize"; k: On Column Resize:K2:31})
	$c.push({e: "onHeaderClick"; k: On Header Click:K2:40})
	$c.push({e: "onFooterClick"; k: On Footer Click:K2:55})
	$c.push({e: "onAfterSort"; k: On After Sort:K2:28})
	$c.push({e: "onExpand"; k: On Expand:K2:41})
	$c.push({e: "onCollapse"; k: On Collapse:K2:42})
	$c.push({e: "onDeleteAction"; k: On Delete Action:K2:56})
	$c.push({e: "onURLResourceLoading"; k: On URL Resource Loading:K2:46})
	$c.push({e: "onBeginURLLoading"; k: On Begin URL Loading:K2:45})
	$c.push({e: "onEndURLLoading"; k: On End URL Loading:K2:47})
	$c.push({e: "onURLFiltering"; k: On URL Filtering:K2:49})
	$c.push({e: "onURLLoadingError"; k: On URL Loading Error:K2:48})
	$c.push({e: "onOpenExternalLink"; k: On Open External Link:K2:50})
	$c.push({e: "onWindowOpeningDenied"; k: On Window Opening Denied:K2:51})
	$c.push({e: "onVPReady"; k: On VP Ready:K2:59})
	$c.push({e: "onRowResize"; k: On Row Resize:K2:60})
	
	return $c
	
	//MARK:-[RESIZING]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHorizontalResising($resize : Boolean; $min : Integer; $max : Integer)
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259<=1)
			
			FORM SET HORIZONTAL RESIZING:C892($resize)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET HORIZONTAL RESIZING:C892($resize; $min)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET HORIZONTAL RESIZING:C892($resize; $min; $max)
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get horizontallyResizable() : Boolean
	
	var $resize : Boolean
	
	FORM GET HORIZONTAL RESIZING:C1077($resize)
	return $resize
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set horizontallyResizable($resize : Boolean)
	
	FORM SET HORIZONTAL RESIZING:C892($resize)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get minWidth() : Integer
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET HORIZONTAL RESIZING:C1077($resize; $min)
	return $min
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set minWidth($width : Integer)
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET HORIZONTAL RESIZING:C1077($resize; $min)
	FORM SET HORIZONTAL RESIZING:C892($resize; $width)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get maxWidth() : Integer
	
	var $resize : Boolean
	var $min; $max : Integer
	
	FORM GET HORIZONTAL RESIZING:C1077($resize; $min; $max)
	return $max
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set maxWidth($width : Integer)
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET HORIZONTAL RESIZING:C1077($resize; $min)
	FORM SET HORIZONTAL RESIZING:C892($resize; $min; $width)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setVerticalResising($resize : Boolean; $min : Integer; $max : Integer)
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259<=1)
			
			FORM SET VERTICAL RESIZING:C893($resize)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET VERTICAL RESIZING:C893($resize; $min)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET VERTICAL RESIZING:C893($resize; $min; $max)
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get verticallyResizable() : Boolean
	
	var $resize : Boolean
	
	FORM GET VERTICAL RESIZING:C1078($resize)
	return $resize
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set verticallyResizable($resize : Boolean)
	
	FORM SET VERTICAL RESIZING:C893($resize)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get minHeight() : Integer
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET VERTICAL RESIZING:C1078($resize; $min)
	return $min
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set minHeight($height : Integer)
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET VERTICAL RESIZING:C1078($resize; $min)
	FORM SET VERTICAL RESIZING:C893($resize; $height)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get maxHeight() : Integer
	
	var $resize : Boolean
	var $min; $max : Integer
	
	FORM GET VERTICAL RESIZING:C1078($resize; $min; $max)
	return $max
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set maxHeight($height : Integer)
	
	var $resize : Boolean
	var $min : Integer
	
	FORM GET VERTICAL RESIZING:C1078($resize; $min)
	FORM SET VERTICAL RESIZING:C893($resize; $min; $height)