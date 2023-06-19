/*dependencies
{
  "classes": [
    "_classCore"
  ]
}
*/

Class extends _classCore

Class constructor($param)
	
	Super:C1705()
	
	This:C1470.ref:=Current form window:C827
	
	Case of 
			
			//______________________________________________________
		: ($param=Null:C1517)
			
			//
			
			//______________________________________________________
		: (This:C1470.isNum($param))
			
			This:C1470.ref:=$param#0 ? $param : This:C1470.ref
			
			//______________________________________________________
		: (Value type:C1509($param)=Is object:K8:27)
			
			This:C1470.__SUPER__:=$param
			
			This:C1470.ref:=$param.ref || This:C1470.ref
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The 'param' parameter must be an integer or an object.")
			
			//______________________________________________________
	End case 
	
	This:C1470.ready:=True:C214
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get type() : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		return Window kind:C445(This:C1470.ref)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get process() : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		return Window process:C446(This:C1470.ref)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get next() : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		return Next window:C448(This:C1470.ref)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFrontmost() : Boolean
	
	If (This:C1470.ref#Null:C1517)
		
		If (This:C1470.type=Floating window:K27:4)
			
			return Frontmost window:C447(*)=This:C1470.ref
			
		Else 
			
			return Frontmost window:C447=This:C1470.ref
			
		End if 
	End if 
	
	//MARK:-[COORDINATES]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get width() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.dimensions.width
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set width($width : Integer)
	
	var $bottom; $left; $right; $top : Integer
	
	If (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $left+$width; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get height() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.dimensions.height
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set height($height : Integer)
	
	var $bottom; $left; $right; $top : Integer
	
	If (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $right; $top+$height; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get left() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.coordinates.left
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set left($left : Integer)
	
	var $_; $bottom; $top; $right : Integer
	
	If (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($_; $top; $right; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get top() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.coordinates.top
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set top($top : Integer)
	
	var $_; $bottom; $left; $right : Integer
	
	If (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $_; $right; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get right() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.coordinates.right
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set right($right : Integer)
	
	var $_; $bottom; $left; $top : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $_; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get bottom() : Integer
	
	If (This:C1470.ready)
		
		return This:C1470.coordinates.bottom
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set bottom($bottom : Integer)
	
	var $_; $left; $right; $top : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $right; $_; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get title() : Text
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		return Get window title:C450(This:C1470.ref)
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set title($title : Text)
	
	var $t : Text
	
	$t:=Get localized string:C991($title)
	SET WINDOW TITLE:C213($t ? $t : $title; This:C1470.ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get coordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
		
		return {\
			left: $left; \
			top: $top; \
			right: $right; \
			bottom: $bottom}
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCoordinates($left : Integer; $top : Integer; $right : Integer; $bottom : Integer)
	
	If (This:C1470.ref#Null:C1517)
		
		SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dimensions() : Object
	
	var $height; $width : Integer
	
	If (This:C1470.ready)\
		 && (This:C1470.ref#Null:C1517)
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		
		return {\
			width: $width; \
			height: $height}
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDimensions($width : Integer; $height : Integer)
	
	var $bottom; $left; $right; $top : Integer
	
	If (This:C1470.ref#Null:C1517)
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
		SET WINDOW RECT:C444($left; $top; $left+$width; $top+$height; This:C1470.ref; *)
		
	End if 
	
	//MARK:-[HANDLING]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hide()
	
	HIDE WINDOW:C436(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function show()
	
	SHOW WINDOW:C435(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function close()
	
	CLOSE WINDOW:C154(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function erase()
	
	ERASE WINDOW:C160(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function maximize()
	
	MAXIMIZE WINDOW:C453(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function minimize()
	
	MINIMIZE WINDOW:C454(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function resize($width : Integer; $height : Integer)
	
	RESIZE FORM WINDOW:C890($width; $height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function redraw()
	
	REDRAW WINDOW:C456(This:C1470.ref)
	
	If (Is Windows:C1573)
		
/*
In some cases, on Windows platform, some regions are not invalidated after
resizing or moving subforms. This trick allows you to force the window
to be redrawn without any effect apparent for the user.
*/
		
		RESIZE FORM WINDOW:C890(1; 0)
		RESIZE FORM WINDOW:C890(-1; 0)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function bringToFront()
	
	var $bottom; $left; $right; $top : Integer
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
	SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref)
	This:C1470.show()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a visual effect when an event occurs.
	// This is mandatory for a login window when the action fails, for example, to alert a hearing impaired user
Function vibrate($count : Integer)
	
	var $i; $shift : Integer
	var $o : Object
	
	$count:=$count=0 ? 6 : $count
	
	If (This:C1470.ref#Null:C1517)
		
		$o:=This:C1470.coordinates
		
		For ($i; 1; $count; 1)
			
			$shift:=($i%2)=0 ? 15 : -15
			SET WINDOW RECT:C444($o.left+$shift; $o.top; $o.right+$shift; $o.bottom; This:C1470.ref; *)
			DELAY PROCESS:C323(Current process:C322; 1)
			
		End for 
	End if 