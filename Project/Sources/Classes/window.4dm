property ref

property __CLASS__ : Object
property __SUPER__ : Object

Class constructor($param)
	
	Super:C1705()
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.ref:=Current form window:C827
	
	Case of 
			
			//______________________________________________________
		: ($param=Null:C1517)
			
			This:C1470.ref:=Current form window:C827
			
			//______________________________________________________
		: (Value type:C1509($param)=Is longint:K8:6)\
			 | (Value type:C1509($param)=Is real:K8:4)
			
			This:C1470.ref:=$param#0 ? $param : Current form window:C827
			
			//______________________________________________________
		: (Value type:C1509($param)=Is object:K8:27)
			
			This:C1470.__SUPER__:=$param
			
			This:C1470.ref:=$param.ref || Current form window:C827
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "The 'param' parameter must be an integer or an object.")
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get title() : Text
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return Get window title:C450(This:C1470.ref)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set title($title : Text)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	// Try to localize from a resname
	If (Length:C16($title)>0)\
		 && (Length:C16($title)<=255)\
		 && (Position:C15(Char:C90(1); $title)#1)
		
		var $t : Text:=Formula from string:C1601("Localized string:C991($1)"; sk execute in host database:K88:5).call(Null:C1517; $title)\
			 || Localized string:C991($title)
		
		$title:=$t || $title  // Revert if no localization
		
	End if 
	
	SET WINDOW TITLE:C213($title; This:C1470.ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get type() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return Window kind:C445(This:C1470.ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get process() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return Window process:C446(This:C1470.ref)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get next() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return Next window:C448(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFrontmost() : Boolean
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	If (This:C1470.type=Floating window:K27:4)
		
		return Frontmost window:C447(*)=This:C1470.ref
		
	Else 
		
		return Frontmost window:C447=This:C1470.ref
		
	End if 
	
	//MARK:-[COORDINATES & DIMENSIONS]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get coordinates() : cs:C1710.coordinates
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $bottom; $left; $right; $top : Integer
	GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
	
	return cs:C1710.coordinates.new($left; $top; $right; $bottom)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCoordinates($left : Integer; $top : Integer; $right : Integer; $bottom : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get rect() : cs:C1710.rect
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	return cs:C1710.rect.new($width; $height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setRect($width : Integer; $height : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $coordinates.left+$width; $coordinates.top+$height; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get width() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.rect.width
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set width($width : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $coordinates.left+$width; $coordinates.bottom; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get height() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.rect.height
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set height($height : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $coordinates.right; $coordinates.top+$height; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get left() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.coordinates.left
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set left($left : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($left; $coordinates.top; $coordinates.right; $coordinates.bottom; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get top() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.coordinates.top
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set top($top : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $top; $coordinates.right; $coordinates.bottom; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get right() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.coordinates.right
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set right($right : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $right; $coordinates.bottom; This:C1470.ref; *)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get bottom() : Integer
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	return This:C1470.coordinates.bottom
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set bottom($bottom : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	var $coordinates:=This:C1470.coordinates
	SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $coordinates.right; $bottom; This:C1470.ref; *)
	
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
Function drag()
	
	DRAG WINDOW:C452
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function reduce()
	
	REDUCE RESTORE WINDOW:C1829(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restore()
	
	REDUCE RESTORE WINDOW:C1829(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function maximize()
	
	MAXIMIZE WINDOW:C453(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function minimize()
	
	MINIMIZE WINDOW:C454(This:C1470.ref)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adding h & v pixels to the current window size.
Function resize($hOffset : Integer; $vOffset : Integer)
	
	RESIZE FORM WINDOW:C890($hOffset; $vOffset)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adding pixels to the current window width.
Function resizeHorizontally($offset : Integer)
	
	RESIZE FORM WINDOW:C890($offset; 0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adding pixels to the current window height.
Function resizeVertically($offset : Integer)
	
	RESIZE FORM WINDOW:C890(0; $offset)
	
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
	
	If (This:C1470.isFrontmost())
		
		return 
		
	End if 
	
	var $bottom; $left; $right; $top : Integer
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; This:C1470.ref)
	SET WINDOW RECT:C444($left; $top; $right; $bottom; This:C1470.ref)
	This:C1470.show()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a visual effect when an event occurs.
	// This is mandatory for a login window when the action fails, for example, to alert a hearing impaired user
Function vibrate($count : Integer)
	
	If (This:C1470.ref=Null:C1517)
		
		return 
		
	End if 
	
	$count:=$count=0 ? 6 : $count
	
	// Must be an even number
	If (($count%2)#0)
		
		$count:=$count+1
		
	End if 
	
	var $o:=This:C1470.coordinates
	var $i; $shift : Integer
	
	For ($i; 1; $count; 1)
		
		$shift:=($i%2)=0 ? 15 : -15
		SET WINDOW RECT:C444($o.left+$shift; $o.top; $o.right+$shift; $o.bottom; This:C1470.ref; *)
		DELAY PROCESS:C323(Current process:C322; 2)
		
	End for 