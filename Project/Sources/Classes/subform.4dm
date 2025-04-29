Class extends scrollable

// MARK: Default values ⚙️
property isSubform : Boolean:=True:C214

// MARK: Delegates 📦
property form : cs:C1710.form

// MARK: Other 💾
property privateEvents; parent : Object

// MARK: Constants 🔐
property __SUPER__ : Object

Class constructor($name : Text; $events : Object; $super : Object; $form : Object; $parent : Object)
	
	Super:C1705($name; $parent)
	
	Case of 
			
			//______________________________________________________
		: ($events#Null:C1517)\
			 && ($events.$4d#Null:C1517)
			
			$form:=OB Copy:C1225($events)
			$events:=Null:C1517
			
			//______________________________________________________
		: ($super#Null:C1517)\
			 && ($super.$4d#Null:C1517)
			
			$form:=OB Copy:C1225($super)
			$super:=Null:C1517
			
			//______________________________________________________
	End case 
	
	This:C1470.__SUPER__:=$super
	
	This:C1470.setPrivateEvents($events)
	
	This:C1470.parent:=This:C1470._getParent($name)
	
	// MARK:Delegates 📦
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	
	If ($form#Null:C1517)
		
		This:C1470.form.me($form)
		
	Else 
		
		var $detailForm:=String:C10(This:C1470.detailForm)
		
		If (Length:C16($detailForm)>0)
			
			This:C1470.form.me(Try(JSON Parse:C1218(File:C1566("/SOURCES/Forms/"+$detailForm+"/form.4DForm").getText())))
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets the events codes triggered in the container method
	// The events will be available in the subform in the __CONTAINER__ property.
Function setPrivateEvents($events : Object)
	
	This:C1470.privateEvents:=$events || {}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	// ⚠️ Overloading the parent
	///Defines the user data attached to the widget
Function set data($data)
	
	This:C1470._data:=$data
	
	// Force an update to take account of changes 
	This:C1470.refresh()
	
Function execute($formula : 4D:C1709.Function)
	
	This:C1470._execute($formula)
	
	// MARK:-[Timer]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Launch the timer in the sub-form.
Function refresh($delay : Integer)
	
	$delay:=Count parameters:C259=0 ? -1 : $delay
	This:C1470._execute(Formula:C1597(SET TIMER:C645($delay)))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Disables the timer
Function stopTimer()
	
	This:C1470._execute(Formula:C1597(SET TIMER:C645(0)))
	
	// MARK:-[Widgets]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Gives the focus to a widget of the subform.
Function focus($widget : Text)
	
	$widget:=This:C1470._getWidget($widget)
	This:C1470._execute(Formula:C1597(GOTO OBJECT:C206(*; $widget)))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Removes any focus in the subform
Function removeFocus()
	
	This:C1470._execute(Formula:C1597(GOTO OBJECT:C206(*; "")))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Enables a widget (or all widgets if no parameter) in the subform.
Function enable($widget : Text)
	
	$widget:=Count parameters:C259=0 ? "@" : This:C1470._getWidget($widget)
	This:C1470._execute(Formula:C1597(OBJECT SET ENABLED:C1123(*; $widget; True:C214)))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Disables a widget (or all widgets if no parameter) in the subform.
Function disable($widget : Text)
	
	$widget:=Count parameters:C259=0 ? "@" : This:C1470._getWidget($widget)
	This:C1470._execute(Formula:C1597(OBJECT SET ENABLED:C1123(*; $widget; False:C215)))
	
	// MARK:-[Definition]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the width and height of the container.
Function getParentRect() : cs:C1710.rect
	
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return cs:C1710.rect.new($width; $height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns  the names of the forms associated with the subform.
Function getSubforms() : Object
	
	var $detail; $list : Text
	var $ptr : Pointer
	
	OBJECT GET SUBFORM:C1139(*; This:C1470.name; $ptr; $detail; $list)
	
	return {\
		detail: $detail; \
		list: $list}
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get detailForm() : Text
	
	var $detail; $list : Text
	var $ptr : Pointer
	
	OBJECT GET SUBFORM:C1139(*; This:C1470.name; $ptr; $detail; $list)
	
	return $detail
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get listForm() : Text
	
	var $detail; $list : Text
	var $ptr : Pointer
	
	OBJECT GET SUBFORM:C1139(*; This:C1470.name; $ptr; $detail; $list)
	
	return $list
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets  the names of the forms associated with the subform.
Function setSubform($detail : Text; $list : Text; $table : Pointer) : cs:C1710.subform
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $detail)
			
			//______________________________________________________
		: (Count parameters:C259=2)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $detail; $list)
			
			//______________________________________________________
		: (Count parameters:C259=3)
			
			OBJECT SET SUBFORM:C1138(*; This:C1470.name; $table->; $detail; $list)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Missing parameter")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignHorizontally($alignment : Integer; $reference)
	
	
	var $coordinates:=This:C1470.getCoordinates()
	
	If (Count parameters:C259=1)
		
		var $parent:=This:C1470.getParentRect()
		
	Else 
		
		// TODO: Work with reference
		ASSERT:C1129(False:C215; "#TO_DO")
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($alignment=Align center:K42:3)
			
			var $width:=This:C1470.rect.width
			var $middle : Integer:=$parent.width\2
			$coordinates.left:=$middle-($width\2)
			$coordinates.right:=$coordinates.left+$width
			
			This:C1470.setCoordinates($coordinates)
			
			//______________________________________________________
		Else 
			
			// TODO:Others alignment
			ASSERT:C1129(False:C215; "#TO_DO")
			
			//______________________________________________________
	End case 
	
	// MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getParent($name : Text) : Object
	
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return {\
		name: This:C1470.form.name; \
		rect: {\
		width: $width; \
		height: $height}; \
		container: $name}
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Executes a formula in the current subform
Function _execute($formula : 4D:C1709.Function)
	
	EXECUTE METHOD IN SUBFORM:C1085(This:C1470.name; $formula)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getWidget($widget : Text) : Text
	
	// Deal with the name of the form object or the name of an instance
	return This:C1470.form[$widget].name || $widget
	