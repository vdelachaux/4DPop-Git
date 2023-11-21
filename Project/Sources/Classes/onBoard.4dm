property form : Text
property instances : Collection

Class constructor($widget : Text; $form : Text)
	
	This:C1470.form:=$form  // The form to use as a sub-form
	
	This:C1470.instances:=[{\
		name: $widget; \
		data: {}\
		}]
	
	// Make sure the widget is invisible
	OBJECT SET VISIBLE:C603(*; $widget; False:C215)
	
	// Make sure the widget is vertically and horizontally expandable
	OBJECT SET RESIZING OPTIONS:C1175(*; $widget; Resize horizontal grow:K42:8; Resize vertical grow:K42:11)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set me($me : cs:C1710.onBoard)
	
	This:C1470.instances[0].data.me:=$me
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// Returns the name of the widget on the current page
Function get name() : Text
	
	If (This:C1470.instances#Null:C1517)\
		 && (This:C1470.instances.length>0)
		
		return This:C1470.instances[0].name+"_"+String:C10(FORM Get current page:C276)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === ===
	// Displays widget
Function show($data : Object)
	
	var $widget : Text
	$widget:=This:C1470.name
	
	var $instance : Object
	$instance:=This:C1470.instances.query("name = :1"; $widget).first()
	
	If ($instance=Null:C1517)
		
		// Create the widget above all objects
		ARRAY TEXT:C222($names; 0)
		FORM GET OBJECTS:C898($names; Form current page:K67:6)
		
		var $ptr : Pointer
		OBJECT DUPLICATE:C1111(*; This:C1470.instances[0].name; $widget; $ptr; $names{Size of array:C274($names)})
		
		var $page : Integer
		$page:=FORM Get current page:C276
		This:C1470.instances[$page]:={name: $widget; data: This:C1470.instances[0].data}
		$instance:=This:C1470.instances[$page]
		
	End if 
	
	// Reset
	For each ($key; $instance.data)
		
		If ($key="parent")\
			 | ($key="me")
			
			continue
			
		End if 
		
		OB REMOVE:C1226($instance.data; $key)
		
	End for each 
	
	// Populate data if any
	If ($data#Null:C1517)
		
		var $key : Text
		
		For each ($key; $data)
			
			$instance.data[$key]:=$data[$key]
			
		End for each 
	End if 
	
	OBJECT SET VALUE:C1742($widget; $instance.data)
	
	// Set the widget associated subform
	OBJECT SET SUBFORM:C1138(*; $widget; String:C10(This:C1470.form))
	
	// Place
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	OBJECT SET COORDINATES:C1248(*; $widget; 0; 0; $width; $height)
	
	// Show
	OBJECT SET VISIBLE:C603(*; $widget; True:C214)
	
	// === === === === === === === === === === === === === === === === === ===
Function close()
	
	Form:C1466.close:=True:C214
	CALL SUBFORM CONTAINER:C1086(-1)
	
	// === === === === === === === === === === === === === === === === === ===
Function accept()
	
	Form:C1466.ok:=True:C214
	Form:C1466.close:=True:C214
	CALL SUBFORM CONTAINER:C1086(-1)
	
	// === === === === === === === === === === === === === === === === === ===
Function cancel()
	
	Form:C1466.cancel:=True:C214
	Form:C1466.close:=True:C214
	CALL SUBFORM CONTAINER:C1086(-1)
	
	// === === === === === === === === === === === === === === === === === ===
	// Hides widget
Function hide($widget : Text)
	
	$widget:=$widget || This:C1470.name
	OBJECT SET VISIBLE:C603(*; $widget; False:C215)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// Returns the data of the widget on the current page
Function get data() : Object
	
	var $widget : Text
	$widget:=This:C1470.name
	
	If (OBJECT Get type:C1300(*; $widget)#Object type unknown:K79:1)
		
		return OBJECT Get value:C1743($widget)
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	// Sets the data of the widget on the current page
Function set data($data : Object)
	
	var $widget : Text
	$widget:=This:C1470.name
	
	If (OBJECT Get type:C1300(*; $widget)#Object type unknown:K79:1)
		
		OBJECT SET VALUE:C1742(This:C1470.name; $data)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === ===
Function setProgress($progress : Integer; $message : Text)
	
	var $o : Object
	$o:=OB Copy:C1225(This:C1470)
	EXECUTE METHOD IN SUBFORM:C1085(This:C1470.name; Formula:C1597($o._setProgress($progress; $message)))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _setProgress($value : Integer; $message : Text)
	
	var $c : Collection
	
	// "min;max;unit;step;flags;format;display"
	$c:=Split string:C1554(OBJECT Get format:C894(*; "progress"); ";")
	
	If ($value<0)
		
		// Enables & starts the Barber shop
		If ($c[4]#"128")
			
			OBJECT SET VALUE:C1742("progress"; 1)
			
		End if 
		
		If ($value=-2)\
			 & (Is macOS:C1572)  // Stepper
			
			OBJECT SET FORMAT:C236(*; "progress"; ";;;;128;;1")
			
		Else 
			
			OBJECT SET FORMAT:C236(*; "progress"; ";;;;128")
			
		End if 
		
		return 
		
	End if 
	
	// Disables the Barber shop
	If ($c[4]="128")
		
		OBJECT SET FORMAT:C236(*; "progress"; "0;100;1;1;0")
		
	End if 
	
	// Set the value
	OBJECT SET VALUE:C1742("progress"; $value)
	
	If (Length:C16($message)>0)
		
		OBJECT SET TITLE:C194(*; "additional"; $message)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === ===
	
	// Generic asignment management when loading the sub-form
Function onLoad()
	
	var $key : Text
	
	For each ($key; Form:C1466)
		
		Case of 
				
				//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
			: ($key="title")\
				 || ($key="additional")\
				 || ($key="ok")\
				 || ($key="cancel")
				
				OBJECT SET TITLE:C194(*; $key; Form:C1466[$key])
				
				//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
			: ($key="progress")
				
				This:C1470._setProgress(Form:C1466[$key])
				
				//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
			Else 
				
				// A "Case of" statement should never omit "Else"
				//╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
		End case 
	End for each 
	
	// === === === === === === === === === === === === === === === === === ===
	// Generic widget position management when resizing the host form
Function onResize()
	
	var $hOffset; $vOffset : Real
	var $bottom; $height; $i; $left; $right; $top : Integer
	var $width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	OBJECT GET COORDINATES:C663(*; "main"; $left; $top; $right; $bottom)
	
	// The default constraints are: vertical centering and top at 1/4 height
	$hOffset:=($width/2)-($left+(($right-$left)/2))
	$vOffset:=($height/4)-$top
	
	ARRAY TEXT:C222($widgets; 0)
	FORM GET OBJECTS:C898($widgets)
	
	For ($i; 1; Size of array:C274($widgets); 1)
		
		If ($widgets{$i}="back@")
			
			// Background objects must be resized to the size of the container
			OBJECT SET COORDINATES:C1248(*; $widgets{$i}; 0; 0; $width; $height)
			
		Else 
			
			// The others are moved
			OBJECT MOVE:C664(*; $widgets{$i}; $hOffset; $vOffset)
			
		End if 
	End for 