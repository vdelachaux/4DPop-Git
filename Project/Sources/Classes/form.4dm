// MARK: Default values ⚙️
property isSubform:=False:C215
property toBeInitialized:=True:C214
property pageNumber : Integer:=0
property entryOrder:=[]
property colorScheme:=FORM Get color scheme:C1761

property name : Text:=Current form name:C1298
property isMatrix : Boolean:=Structure file:C489=Structure file:C489(*)

// MARK: Delegates 📦
property window : cs:C1710.window
property constraints:=cs:C1710.constraints.new()

// MARK: Other 💾
property context : Collection
property current
property pages : Object

property _darkExtension:="_dark"
property _callback : Text
property _definition; _cursorsHash : Object
property _worker : Text
property _timerID : Integer

property _instantiableWidgets:=[\
cs:C1710.button; \
cs:C1710.comboBox; \
cs:C1710.dropDown; \
cs:C1710.hList; \
cs:C1710.input; \
cs:C1710.listbox; \
cs:C1710.picture; \
cs:C1710.selector; \
cs:C1710.static; \
cs:C1710.stepper; \
cs:C1710.subform; \
cs:C1710.tabControl; \
cs:C1710.thermometer; \
cs:C1710.webArea; \
cs:C1710.widget]

// Maps between event names and their value
property _mapEvents:=[\
{e: "onLoad"; k: On Load:K2:1}; \
{e: "onUnload"; k: On Unload:K2:2}; \
{e: "onValidate"; k: On Validate:K2:3}; \
{e: "onClick"; k: On Clicked:K2:4}; \
{e: "onDoubleClick"; k: On Double Clicked:K2:5}; \
{e: "onAlternateClick"; k: On Alternative Click:K2:36}; \
{e: "onLongClick"; k: On Long Click:K2:37}; \
{e: "onBeforeKeystroke"; k: On Before Keystroke:K2:6}; \
{e: "onAfterKeystroke"; k: On After Keystroke:K2:26}; \
{e: "onAfterEdit"; k: On After Edit:K2:43}; \
{e: "onGettingFocus"; k: On Getting Focus:K2:7}; \
{e: "onLosingFocus"; k: On Losing Focus:K2:8}; \
{e: "onActivate"; k: On Activate:K2:9}; \
{e: "onDeactivate"; k: On Deactivate:K2:10}; \
{e: "onOutsideCall"; k: On Outside Call:K2:11}; \
{e: "onPageChange"; k: On Page Change:K2:54}; \
{e: "onBeginDragOver"; k: On Begin Drag Over:K2:44}; \
{e: "onDrop"; k: On Drop:K2:12}; \
{e: "onDragOver"; k: On Drag Over:K2:13}; \
{e: "onMouseEnter"; k: On Mouse Enter:K2:33}; \
{e: "onMouseMove"; k: On Mouse Move:K2:35}; \
{e: "onMouseLeave"; k: On Mouse Leave:K2:34}; \
{e: "onMouseUp"; k: On Mouse Up:K2:58}; \
{e: "onMenuSelect"; k: On Menu Selected:K2:14}; \
{e: "onBoundVariableChange"; k: On Bound Variable Change:K2:52}; \
{e: "onDataChange"; k: On Data Change:K2:15}; \
{e: "onPluginArea"; k: On Plug in Area:K2:16}; \
{e: "onHeader"; k: On Header:K2:17}; \
{e: "onPrintingDetail"; k: On Printing Detail:K2:18}; \
{e: "onPrintingBreak"; k: On Printing Break:K2:19}; \
{e: "onPrintingFooter"; k: On Printing Footer:K2:20}; \
{e: "onCloseBox"; k: On Close Box:K2:21}; \
{e: "onDisplayDetail"; k: On Display Detail:K2:22}; \
{e: "onOpenDetail"; k: On Open Detail:K2:23}; \
{e: "onCloseDetail"; k: On Close Detail:K2:24}; \
{e: "onResize"; k: On Resize:K2:27}; \
{e: "onSelectionChange"; k: On Selection Change:K2:29}; \
{e: "onLoadecord"; k: On Load Record:K2:38}; \
{e: "onTimer"; k: On Timer:K2:25}; \
{e: "onScroll"; k: On Scroll:K2:57}; \
{e: "onBeforeDataEntry"; k: On Before Data Entry:K2:39}; \
{e: "onColumnMoved"; k: On Column Moved:K2:30}; \
{e: "onRowMoved"; k: On Row Moved:K2:32}; \
{e: "onColumnResize"; k: On Column Resize:K2:31}; \
{e: "onHeaderClick"; k: On Header Click:K2:40}; \
{e: "onFooterClick"; k: On Footer Click:K2:55}; \
{e: "onAfterSort"; k: On After Sort:K2:28}; \
{e: "onExpand"; k: On Expand:K2:41}; \
{e: "onCollapse"; k: On Collapse:K2:42}; \
{e: "onDeleteAction"; k: On Delete Action:K2:56}; \
{e: "onURLResourceLoading"; k: On URL Resource Loading:K2:46}; \
{e: "onBeginURLLoading"; k: On Begin URL Loading:K2:45}; \
{e: "onEndURLLoading"; k: On End URL Loading:K2:47}; \
{e: "onURLFiltering"; k: On URL Filtering:K2:49}; \
{e: "onURLLoadingError"; k: On URL Loading Error:K2:48}; \
{e: "onOpenExternalLink"; k: On Open External Link:K2:50}; \
{e: "onWindowOpeningDenied"; k: On Window Opening Denied:K2:51}; \
{e: "onVPReady"; k: On VP Ready:K2:59}; \
{e: "onRowResize"; k: On Row Resize:K2:60}]

property __CLASS__ : 4D:C1709.Class
property __SUPER__ : Object
property __CONTAINER__ : Object
property __DIALOG__ : 4D:C1709.Class

// FIXME: USEFUL?
/*
property __DELEGATES__:=[\
cs.button; \
cs.comboBox; \
cs.dropDown; \
cs.group; \
cs.hList; \
cs.input; \
cs.listbox; \
cs.picture; \
cs.selector; \
cs.static; \
cs.stepper; \
cs.subform; \
cs.tabControl; \
cs.thermometer; \
cs.webArea; \
cs.widget; \
cs.window; \
cs.constraints\
]
*/

Class constructor($param; $me : Object)
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	// TODO:Test if  OBJECT Get subform container value could be usable to make it automatic
	
	This:C1470._callback:=Formula:C1597(formCallBack).source
	
	Case of 
			
			//______________________________________________________
		: ($1=Null:C1517)
			
			//
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)  // Callback method's name
			
			This:C1470._callback:=$1
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)\
			 && (OB Instance of:C1731(OB Class:C1730($1); 4D:C1709.Class))
			
			This:C1470.__SUPER__:=$1
			$1.__CLASS__:=OB Class:C1730($1)
			
			This:C1470._worker:=String:C10($1.worker) || This:C1470._worker
			This:C1470._callback:=String:C10($1.callback) || This:C1470._callback
			This:C1470.isSubform:=$1.isSubform || This:C1470.isSubform
			This:C1470.toBeInitialized:=$1.toBeInitialized || This:C1470.toBeInitialized
			This:C1470._darkExtension:=String:C10($1.darkExtension) || This:C1470._darkExtension
			This:C1470.entryOrder:=$1.entryOrder || This:C1470.entryOrder
			This:C1470.pages:=$1.pages || This:C1470.pages
			
			//______________________________________________________
		Else 
			
			throw:C1805(_error("The first parameter must be an Object or Text"))
			return 
			
			//______________________________________________________
	End case 
	
	// MARK:Delegates 📦
	This:C1470.window:=cs:C1710.window.new(This:C1470)
	
	This:C1470.me($me)
	
	This:C1470.setPageNames()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function me($formDefinition : Object)
	
	If (This:C1470._definition#Null:C1517)
		
		return 
		
	End if 
	
	If ($formDefinition=Null:C1517)\
		 && (This:C1470.isMatrix)
		
		// Component forms have priority
		ARRAY TEXT:C222($forms; 0x0000)
		FORM GET NAMES:C1167($forms; This:C1470.name)
		
		var $file : 4D:C1709.File
		$file:=Size of array:C274($forms)>0\
			 ? File:C1566("/SOURCES/Forms/"+This:C1470.name+"/form.4DForm")\
			 : Null:C1517
		
		If ($file#Null:C1517)\
			 && ($file.exists)
			
			$formDefinition:=Try(JSON Parse:C1218($file.getText()))
			
		End if 
	End if 
	
	If ($formDefinition#Null:C1517)\
		 && ($formDefinition.$4d#Null:C1517)
		
		This:C1470._definition:=$formDefinition
		This:C1470.pageNumber:=$formDefinition.pages.length-1
		
		// Preparing the contexts container
		This:C1470.context:=[].resize(This:C1470.pageNumber+1)
		
	End if 
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470._standardSuite(Current method name:C684)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	This:C1470._standardSuite(Current method name:C684; $e)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// Defines the container reference in subform instances
	var $o : Object
	For each ($o; This:C1470._getInstantiated(cs:C1710.subform))
		
		$o._execute(Formula:C1597(Form:C1466.__DIALOG__.__CONTAINER__:=$o))
		
	End for each 
	
	// Add the widgets events that we cannot select in the form properties 😇
	// ⚠️ OBJECT GET EVENTS return an empty array if no object method, so we analyze the json form
	
	var $widgets : Collection:=This:C1470._getInstantiated()
	
	If ($widgets.length>0)
		
		var $events:=[]
		
		If (This:C1470._definition#Null:C1517)
			
			var $page : Object
			For each ($page; This:C1470._definition.pages)
				
				If ($page#Null:C1517)
					
					var $key : Text
					var $widget : cs:C1710.widget
					For each ($key; $page.objects)
						
						$widget:=$widgets.query("name = :1"; $key).first()
						
						If ($widget=Null:C1517)\
							 || ($page.objects[$key].events=Null:C1517)
							
							continue
							
						End if 
						
						var $event : Text
						For each ($event; $page.objects[$key].events)
							
							$o:=This:C1470._mapEvents.query("e = :1"; $event).first()
							
							If (Asserted:C1132($o#Null:C1517; "FIXME: Add missing event map for "+$event))
								
								// Update the widget
								$widget.addEvent($o.k)
								
								// Keep the event
								$events.push($o.k)
								
							End if 
						End for each 
					End for each 
				End if 
			End for each 
		End if 
		
		If ($events.length>0)
			
			This:C1470.appendEvents($events.distinct())
			
		End if 
	End if 
	
	This:C1470._standardSuite(Current method name:C684)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update($stopTimer : Boolean)
	
	If (Count parameters:C259>=1 ? $stopTimer : True:C214)
		
		SET TIMER:C645(0)
		
	End if 
	
	This:C1470._standardSuite(Current method name:C684)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onBoundVariableChange()
	
	If (Asserted:C1132(This:C1470.isSubform; "⚠️ This form is not declared as a sub-form."))
		
		This:C1470._standardSuite(Current method name:C684)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function saveContext()
	
	// TODO:Generic?
	This:C1470._standardSuite(Current method name:C684)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreContext()
	
	// TODO:Generic?
	This:C1470._standardSuite(Current method name:C684)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onOutsideCall()
	
	This:C1470._standardSuite(Current method name:C684)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _standardSuite($name : Text; $e : cs:C1710.evt)
	
	$name:=Split string:C1554($name; ".").last()
	
	If (Asserted:C1132(This:C1470.__SUPER__#Null:C1517; "👀 "+$name+"() must be overriden by the class "+This:C1470.__SUPER__.__CLASS__.name))\
		 && (Asserted:C1132(OB Instance of:C1731(This:C1470.__SUPER__[$name]; 4D:C1709.Function); "The function "+$name+"() is not define into the class "+This:C1470.__SUPER__.__CLASS__.name))
		
		If ($name="handleEvents")
			
			This:C1470.__SUPER__[$name]($e)
			
		Else 
			
			This:C1470.__SUPER__[$name]()
			
		End if 
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
		: ($1=Null:C1517)
			
			GOTO OBJECT:C206(*; "")
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			GOTO OBJECT:C206(*; $1)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)\
			 && (OB Instance of:C1731($1; cs:C1710.widget))
			
			GOTO OBJECT:C206(*; $1.name)
			
			//______________________________________________________
		Else 
			
			throw:C1805(_error("The parameter must be a Widget or an Form Object Name"))
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Remove any focus in the current form
Function removeFocus()
	
	GOTO OBJECT:C206(*; "")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Go to next focusable widget
Function focusNext()
	
	POST EVENT:C467(Key down event:K17:4; Tab:K15:37; Tickcount:C458; 0; 0; 0; Current process:C322)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Go to previous focusable widget
Function focusPrevious()
	
	POST EVENT:C467(Key down event:K17:4; Tab:K15:37; Tickcount:C458; 0; 0; Command key mask:K16:1; Current process:C322)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the text currently selected
Function get highlight() : Text
	
	var $widget:=OBJECT Get name:C1087(Object with focus:K67:3)
	var $ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $widget)
	
	If (Length:C16($widget)=0)\
		 | (Is nil pointer:C315($ptr))
		
		return ""
		
	End if 
	
	var $begin; $end : Integer
	GET HIGHLIGHT:C209(*; $widget; $begin; $end)
	
	If ($end>$begin)
		
		return Substring:C12($ptr->; $begin; $end-$begin)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets the entry order of the current form for the current process
Function setEntryOrder($widgetNames : Collection)
	
	If (Value type:C1509($widgetNames[0])=Is object:K8:27)
		
		$widgetNames:=$widgetNames.extract("name")
		
	End if 
	
	ARRAY TEXT:C222($entryOrder; 0x0000)
	COLLECTION TO ARRAY:C1562($widgetNames; $entryOrder)
	FORM SET ENTRY ORDER:C1468($entryOrder)
	
	// MARK:-[COLOR SCHEME]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isSchemeModified() : Boolean
	
	If (FORM Get color scheme:C1761#This:C1470.colorScheme)
		
		This:C1470.colorScheme:=FORM Get color scheme:C1761
		return True:C214
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns True if the current color scheme is dark.
Function get darkScheme() : Boolean
	
	return FORM Get color scheme:C1761="dark"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns True if the current color scheme is light.
Function get lightScheme() : Boolean
	
	return FORM Get color scheme:C1761="light"
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the current scheme suffix
Function get resourceScheme() : Text
	
	return This:C1470.darkScheme ? This:C1470._darkExtension : ""
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the current dark suffix.
Function get darkSuffix() : Text
	
	return This:C1470._darkExtension
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Sers the dark suffix.
Function set darkSuffix($suffix : Text)
	
	This:C1470._darkExtension:=$suffix
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Return the given resource path with scheme suffix if any
Function resourceFromScheme($path : Text) : Text
	
	$path:=This:C1470._proxy($path)
	$path:=Replace string:C233($path; "path:"; "")
	
	If (This:C1470.darkScheme)
		
		var $file:=File:C1566($path)
		
		var $c:=Split string:C1554($file.fullName; ".")
		$c[0]+=This:C1470._darkExtension
		
		var $t:=Replace string:C233($path; $file.fullName; $c.join("."))
		$path:=File:C1566($t).exists ? $t : $path
		
	End if 
	
	return $path
	
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
		: (Position:C15("|"; $proxy)=1)
			
			return "path:/.PRODUCT_RESOURCES/"+Delete string:C232($proxy; 1; 1)
			
			//______________________________________________________
		: (Position:C15("4d:"; $proxy)=1)
			
			return "path:/.PRODUCT_RESOURCES/"+Delete string:C232($proxy; 1; 3)
			
			//______________________________________________________
		: (Position:C15("/"; $proxy)=1)
			
			return "path:"+$proxy
			
			//______________________________________________________
		Else 
			
			// Relative to the form.4DForm
			return "path:/FORM/"+$proxy
			
			//______________________________________________________
	End case 
	
	// MARK:-[TIMER]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Starts a timer and sets its delay, ASAP if omitted.
Function setTimer($tickCount : Integer)
	
	SET TIMER:C645($tickCount)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Starts a timer to be exuted ASAP
Function refresh($tickCount : Integer)
	
	$tickCount:=Count parameters:C259=0 ? -1 : $tickCount
	SET TIMER:C645($tickCount)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Disables the timer
Function stopTimer()
	
	SET TIMER:C645(0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function deferTimer($id : Integer; $tickCount : Integer)
	
	SET TIMER:C645(0)
	This:C1470._timerID:=$id
	
	If ($id#0)
		
		SET TIMER:C645($tickCount=0 ? -1 : $tickCount)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get deferedTimer() : Integer
	
	var $id:=This:C1470._timerID
	This:C1470._timerID:=0
	
	return $id
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set deferedTimer($id : Integer) : Integer
	
	This:C1470.deferTimer($id)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clearDeferedTimer()
	
	SET TIMER:C645(0)
	This:C1470._timerID:=0
	
	// MARK:-[ASSOCIATED WORKER]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Gets the associated worker
Function get worker() : Variant
	
	return String:C10(This:C1470._worker)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Sets the associated worker
Function set worker($worker)
	
	If (Not:C34([Is longint:K8:6; Is real:K8:4; Is text:K8:3].includes(Value type:C1509($worker))))
		
		throw:C1805(_error("The 'worker' parameter must be an number or a name"))
		return 
		
	End if 
	
	This:C1470._worker:=$worker
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Assigns a task to the associated worker
Function callWorker($method;  ...  : Variant)
	
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
	var $code : Text
	var $i : Integer
	var $parameters : Collection
	
	If (This:C1470._worker=Null:C1517)
		
		throw:C1805(_error("No associated worker"))
		return 
		
	End if 
	
	If (Count parameters:C259=1)
		
		CALL WORKER:C1389(This:C1470._worker; $method)
		
	Else 
		
		$code:="CALL WORKER:C1389(\""+String:C10(This:C1470._worker)+"\"; \""+$method+"\""
		
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
	
	// MARK:-[SUBFORM]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get containerName() : Text
	
	If (This:C1470._isDebugWindow())
		
		return This:C1470.__SUPER__.__CONTAINER__ ? This:C1470.__SUPER__.__CONTAINER__.parent.container : ""
		
	Else 
		
		If (Asserted:C1132(Bool:C1537(This:C1470.isSubform); "⚠️ This form is not declared as a sub-form."))
			
			return This:C1470.__SUPER__.__CONTAINER__.parent.container
			
		End if 
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get container() : Object
	
	If (This:C1470._isDebugWindow())
		
		return This:C1470.__SUPER__.__CONTAINER__ ? This:C1470.__SUPER__.__CONTAINER__ : Null:C1517
		
	Else 
		
		If (Asserted:C1132(Bool:C1537(This:C1470.isSubform); "⚠️ This form is not declared as a sub-form."))
			
			return This:C1470.__SUPER__.__CONTAINER__
			
		End if 
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get containerInstance() : Object
	
	If (This:C1470._isDebugWindow())
		
		return This:C1470.__SUPER__.__CONTAINER__ ? This:C1470.container[This:C1470.containerName] : Null:C1517
		
	Else 
		
		If (Asserted:C1132(Bool:C1537(This:C1470.isSubform); "⚠️ This form is not declared as a sub-form."))
			
			return Try(This:C1470.container[This:C1470.containerName])
			
		End if 
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get containerValue() : Variant
	
	return This:C1470.getContainerValue()
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set containerValue($value)
	
	This:C1470.setContainerValue($value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets the container value
Function setContainerValue($value)
	
	If (Asserted:C1132(This:C1470.isSubform; "⚠️ This form is not declared as a sub-form."))
		
		OBJECT SET SUBFORM CONTAINER VALUE:C1784($value)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getContainerValue() : Variant
	
	If (This:C1470._isDebugWindow())
		
		return OBJECT Get subform container value:C1785
		
	Else 
		
		If (Asserted:C1132(This:C1470.isSubform; "⚠️ This form is not declared as a sub-form."))
			
			return OBJECT Get subform container value:C1785
			
		End if 
	End if 
	
	// MARK:-[EVENTS]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get events() : Collection
	
	ARRAY LONGINT:C221($codes; 0)
	OBJECT GET EVENTS:C1238(*; ""; $codes)
	var $c:=[]
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
	
	var $type:=Value type:C1509($events)
	
	Case of 
			
			//______________________________________________________
		: ($type=Is collection:K8:32)
			
			COLLECTION TO ARRAY:C1562($events; $codes)
			
			//______________________________________________________
		: ($type=Is longint:K8:6)\
			 | ($type=Is real:K8:4)
			
			APPEND TO ARRAY:C911($codes; $events)
			
			//______________________________________________________
		Else 
			
			throw:C1805(_error("The event parameter must be an number or a collection"))
			return 
			
			//______________________________________________________
	End case 
	
	OBJECT SET EVENTS:C1239(*; ""; $codes; $mode)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Posts a keyboard event
Function postKeyDown($keyCode : Integer; $modifier : Integer)
	
	POST EVENT:C467(Key down event:K17:4; $keyCode; Tickcount:C458; 0; 0; $modifier; Current process:C322)
	
	// MARK:-[CALLS]
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
Function callMe($method : Text;  ...  : Variant)
	
/*
.callMe ( method : Text )
.callMe ( method : Text ; param : Collection )
.callMe ( method : Text ; param1, param2, …, paramN )
*/
	
	If (Count parameters:C259=1)
		
		CALL FORM:C1391(This:C1470.window.ref; $method)
		
	Else 
		
		var $code:="CALL FORM:C1391("+String:C10(This:C1470.window.ref)+"; \""+$method+"\""
		
		If (Value type:C1509($2)=Is collection:K8:32)
			
			$param:=$2
			
			var $i : Integer
			For ($i; 0; $param.length-1; 1)
				
				$code+="; $1["+String:C10($i)+"]"
				
			End for 
			
		Else 
			
			var $param:=[]
			
			For ($i; 2; Count parameters:C259; 1)
				
				$param.push(${$i})
				$code+="; $1["+String:C10($i-2)+"]"
				
			End for 
		End if 
		
		$code+=")"
		
		Formula from string:C1601($code).call(Null:C1517; $param)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Executes a project method in the context of a subform (without returned value)
Function callChild($subform; $method : Variant;  ...  : Variant)
	
	// .executeInSubform ( subform : Object | Text ; method : Text )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param : Collection )
	// .executeInSubform ( subform : Object | Text ; method : Text ; param1, param2, …, paramN )
	
	// TODO:Returned value
	
	var $target : Text
	
	Case of 
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)\
			 && (OB Instance of:C1731($1.setPrivateEvents; 4D:C1709.Function))
			
			$target:=$1.name
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$target:=$1
			
			// ______________________________________________________
		Else 
			
			throw:C1805(_error("The 'subform' parameter must be a Widget or a Form Object Name"))
			
			return 
			
			// ______________________________________________________
	End case 
	
	ARRAY TEXT:C222($widgets; 0)
	FORM GET OBJECTS:C898($widgets; Form all pages:K67:7)
	
	If (Find in array:C230($widgets; $target)>0)
		
		If (Count parameters:C259=2)
			
			EXECUTE METHOD IN SUBFORM:C1085($target; $method)
			
		Else 
			
			var $code:="EXECUTE METHOD IN SUBFORM:C1085(\""+$target+"\"; \""+$method+"\";*"
			
			If (Value type:C1509($3)=Is collection:K8:32)
				
				$param:=$3
				
				var $i : Integer
				For ($i; 0; $param.length-1; 1)
					
					$code+="; $1["+String:C10($i)+"]"
					
				End for 
				
			Else 
				
				var $param:=[]
				
				For ($i; 3; Count parameters:C259; 1)
					
					$param.push(${$i})
					
					$code+="; $1["+String:C10($i-3)+"]"
					
				End for 
			End if 
			
			$code+=")"
			
			Formula from string:C1601($code).call(Null:C1517; $param)
			
		End if 
		
	Else 
		
		ASSERT:C1129(This:C1470.isMatrix; "Subform not found: "+$target)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function spreadToChilds($message : Object)
	
	// TODO: TO TEST
	//form_spreadToSubforms($message)
	
	// First execute at this level
	EXECUTE METHOD:C1007($message.method)
	
	// Then in call all subforms if any
	var $name : Text
	For each ($name; This:C1470.subforms)
		
		If (Position:C15($message.target; $name)=1)
			
			EXECUTE METHOD IN SUBFORM:C1085($name; $message.method)
			
		End if 
		
		// Finally go down a level
		var $this:=This:C1470
		EXECUTE METHOD IN SUBFORM:C1085($name; Formula:C1597($this.spreadToChilds($message)))
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Send an event to a subform container
Function callParent($eventCode : Integer)
	
	If (Asserted:C1132(This:C1470.isSubform; "🛑 Only applicable for sub-forms!"))
		
		CALL SUBFORM CONTAINER:C1086($eventCode)
		
	End if 
	
	// MARK:-[PAGES]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the current page number 
Function get page() : Integer
	
	return This:C1470.isSubform ? FORM Get current page:C276(*) : FORM Get current page:C276
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Defines the pages hashmap table from the collection of names passed
Function setPageNames($names : Collection)
	
	This:C1470.pages:={}
	
	If ($names=Null:C1517)
		
		var $i : Integer
		For ($i; 1; This:C1470.pageNumber; 1)
			
			This:C1470.pages["page_"+String:C10($i)]:=$i
			
		End for 
		
	Else 
		
		For ($i; 0; $names.length-1; 1)
			
			This:C1470.pages[$names[$i]]:=$i+1
			
		End for 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the page number from its name
Function pageFromName($name : Text) : Integer
	
	return Num:C11(This:C1470.pages[$name])
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays a given page
Function goToPage($page; $parent : Boolean)
	
	var $type:=Value type:C1509($page)
	
	If (Not:C34([Is longint:K8:6; Is real:K8:4; Is text:K8:3].includes($type)))
		
		throw:C1805(_error("The 'page' parameter must be an number or a name"))
		return 
		
	End if 
	
	If ($type=Is text:K8:3)
		
		$page:=This:C1470.pageFromName($page)
		
	End if 
	
	If (Asserted:C1132(($page>0)\
		 & ($page<=This:C1470.pageNumber); "The page "+String:C10($page)+" doesn't exists"))
		
		If (This:C1470.isSubform)\
			 && Not:C34($parent)
			
			FORM GOTO PAGE:C247($page; *)
			
		Else 
			
			FORM GOTO PAGE:C247($page)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the first page
Function firstPage($parent : Boolean)
	
	If (This:C1470.isSubform)\
		 && Not:C34($parent)
		
		FORM GOTO PAGE:C247(1; *)
		
	Else 
		
		FORM FIRST PAGE:C250
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the last page
Function lastPage($parent : Boolean)
	
	If (This:C1470.isSubform)\
		 && Not:C34($parent)
		
		FORM GOTO PAGE:C247(This:C1470.pageNumber; *)
		
	Else 
		
		FORM LAST PAGE:C251
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Displays the next page
Function nextPage($parent : Boolean)
	
	If (This:C1470.isSubform)\
		 && Not:C34($parent)
		
		var $page : Integer:=FORM Get current page:C276(*)+1
		
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
Function previousPage($parent : Boolean)
	
	If (This:C1470.isSubform)\
		 && Not:C34($parent)
		
		var $page : Integer:=FORM Get current page:C276(*)-1
		
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
Function setCursor($cursor)
	
	If ($cursor=Null:C1517)
		
		SET CURSOR:C469
		
		return 
		
	End if 
	
	If (Value type:C1509($cursor)=Is text:K8:3)
		
		This:C1470._cursorsHash:=This:C1470._cursorsHash || This:C1470._cursors()
		$cursor:=Num:C11(This:C1470._cursorsHash[$cursor])
		
	End if 
	
	SET CURSOR:C469(Num:C11($cursor))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Restores the standard cursor
Function releaseCursor()
	
	SET CURSOR:C469
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _cursors() : Object
	
	return {\
		pointingHandCursor: 9000; \
		openHandCursor: 9013; \
		closedHandCursor: 9014; \
		contextualMenuCursor: 9015; \
		dragCopyCursor: 9015; \
		notAllowedCursor: 9019; \
		IBeamCursor: 1; \
		pointerCursor: 355; \
		pointerToRightCursor: 355; \
		crosshairCursor: 2; \
		dragLinkCursor: 9017; \
		helpCursor: 9018; \
		zoomOutCursor: 559; \
		zoomInCursor: 560; \
		moveCursor: 9001; \
		horizontalResizeCursor: 9003; \
		verticalResizeCursor: 9004; \
		resizeNorthWestSouthEastCursor: 9005; \
		resizeNorthEastSouthWestCursor: 90900613; \
		resizeleftrightCursor: 9021; \
		resizeUpDownCursor: 9009; \
		verticalSplitCursor: 9010; \
		horizontalSplitCursor: 9011\
		}
	
	// MARK:-[DRAG & DROP]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Appends data to the pasteboard under the data type specified in uri. Also sets the drag icon if passed
Function beginDrag($uri : Text; $data; $dragIcon : Picture)
	
	If (Value type:C1509($data)=Is BLOB:K8:12)
		
		APPEND DATA TO PASTEBOARD:C403($uri; $data)
		
	Else 
		
		var $x : Blob
		VARIABLE TO BLOB:C532($data; $x)
		APPEND DATA TO PASTEBOARD:C403($uri; $x)
		
	End if 
	
	If (Count parameters:C259>=3)
		
		SET DRAG ICON:C1272($dragIcon)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the data from the pasteboard whose type you pass in uri
Function getPasteboard($uri : Text) : Variant
	
	var $x : Blob
	GET PASTEBOARD DATA:C401($uri; $x)
	
	If (Bool:C1537(OK))
		
		var $value
		BLOB TO VARIABLE:C533($x; $value)
		SET BLOB SIZE:C606($x; 0)
		
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
	
	return This:C1470._getInstantiated(cs:C1710.subform)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// An instantiated subform by its instance name.
Function getSubformInstance($name : Text) : Object
	
	return This:C1470._getInstantiated(cs:C1710.subform; $name)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns a collection of form object names possibly filtered by their type.
Function _getformObjects($type : Integer) : Collection
	
	var $c:=[]
	
	ARRAY TEXT:C222($objects; 0)
	FORM GET OBJECTS:C898($objects)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // All form objects
			
			ARRAY TO COLLECTION:C1563($c; $objects)
			
			//______________________________________________________
		: (Count parameters:C259=1)  // All form objects of this type
			
			var $i : Integer
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
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // All instantiated widgets
			
			var $c:=[]
			var $key : Text
			For each ($key; This:C1470.__SUPER__)
				
				If (Value type:C1509(This:C1470.__SUPER__[$key])=Is object:K8:27)\
					 && (This:C1470._instantiableWidgets.includes(OB Class:C1730(This:C1470.__SUPER__[$key])))
					
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
	
	//MARK:-[DIMENSIONS & RESIZING]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get rect() : Object
	
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return {\
		width: $width; \
		height: $height\
		}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHorizontalResising($resize : Boolean; $min : Integer; $max : Integer)
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259<=1)
			
			FORM SET HORIZONTAL RESIZING:C892($resize)  // Default is False
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET HORIZONTAL RESIZING:C892($resize; $min)
			
			//______________________________________________________
		: (Count parameters:C259=3)
			
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSize($widget; $hMargin : Integer; $vMargin : Integer)
	
	If (Value type:C1509($1)=Is text:K8:3)
		
		$vMargin:=Count parameters:C259>=3 ? $3 : $hMargin
		FORM SET SIZE:C891($1; $hMargin; $vMargin)
		
	Else 
		
		$hMargin:=Num:C11($1)
		$vMargin:=Count parameters:C259>=2 ? $2 : $hMargin
		
		FORM SET SIZE:C891($hMargin; $vMargin; *)
		
	End if 
	
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
			
			FORM SET VERTICAL RESIZING:C893($resize)  // Default is False
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			FORM SET VERTICAL RESIZING:C893($resize; $min)
			
			//______________________________________________________
		: (Count parameters:C259=3)
			
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
	
	// MARK:-[CASTING]
	// -------------------------------------------------------------------------------------------------------
Function Button($name : Text) : cs:C1710.button
	
	return cs:C1710.button.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function ComboBox($name : Text; $data : Object) : cs:C1710.comboBox
	
	return cs:C1710.comboBox.new($name; $data; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function DropDown($name : Text; $data : Object) : cs:C1710.dropDown
	
	return cs:C1710.dropDown.new($name; $data; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Group($members : Variant;  ... ) : cs:C1710.group
	
	If (Count parameters:C259=1)
		
		return cs:C1710.group.new($members)
		
	Else 
		
		// TODO:Manage non widget collections
		return cs:C1710.group.new(Copy parameters:C1790)
		
	End if 
	
	// -------------------------------------------------------------------------------------------------------
Function HList($name : Text; $itemRef : Integer) : cs:C1710.hList
	
	return cs:C1710.hList.new($name; $itemRef; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Input($name : Text) : cs:C1710.input
	
	return cs:C1710.input.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Listbox($name : Text) : cs:C1710.listbox
	
	return cs:C1710.listbox.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Picture($name : Text; $data) : cs:C1710.picture
	
	return cs:C1710.picture.new($name; $data; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Scrollable($name : Text; $values : Collection) : cs:C1710.scrollable
	
	return cs:C1710.scrollable.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Selector($name : Text; $values : Collection) : cs:C1710.selector
	
	return cs:C1710.selector.new($name; $values; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Static($name : Text) : cs:C1710.static
	
	return cs:C1710.static.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Stepper($name : Text) : cs:C1710.stepper
	
	return cs:C1710.stepper.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Subform($name : Text; $events : Object; $super : Object; $form : Object) : cs:C1710.subform
	
	return cs:C1710.subform.new($name; $events; $super; $form; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function TabControl($name : Text; $data; $page : Integer) : cs:C1710.tabControl
	
	return cs:C1710.tabControl.new($name; $data; $page; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Thermometer($name : Text) : cs:C1710.thermometer
	
	return cs:C1710.thermometer.new($name; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function WebArea($name : Text; $data) : cs:C1710.webArea
	
	return cs:C1710.webArea.new($name; $data; This:C1470)
	
	// -------------------------------------------------------------------------------------------------------
Function Widget($name : Text) : cs:C1710.widget
	
	return cs:C1710.widget.new($name; This:C1470)
	
	// MARK:-[MISCELLANEOUS]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getScreenshot($page : Integer) : Picture
	
	var $picture : Picture
	
	If (Count parameters:C259>=1)
		
		FORM SCREENSHOT:C940(This:C1470.name; $picture; $page)
		
	Else 
		
		FORM SCREENSHOT:C940(This:C1470.name; $picture)
		
	End if 
	
	return $picture
	
	// MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isSubform() : Boolean
	
	return Value type:C1509(OBJECT Get subform container value:C1785)#Is undefined:K8:13
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isDebugWindow() : Boolean
	
	return Position:C15(Formula from string:C1601(":C1578(\"common_STR#1029:6\")").call(); Get window title:C450(Frontmost window:C447))=1
	