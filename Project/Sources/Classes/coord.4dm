Class constructor($left : Integer; $top : Integer; $right : Integer; $bottom : Integer)
	
	This:C1470.left:=$left
	This:C1470.top:=$top
	This:C1470.right:=$right
	This:C1470.bottom:=$bottom
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==  
Function get windowCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	var $o : Object
	
	$left:=This:C1470.left
	$top:=This:C1470.top
	$right:=This:C1470.right
	$bottom:=This:C1470.bottom
	
	CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Current window:K27:6)
	CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Current window:K27:6)
	
	$o:={left: $left; top: $top; right: $right; bottom: $bottom}
	return $o
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==  
Function get screenCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	var $o : Object
	
	$left:=This:C1470.left
	$top:=This:C1470.top
	$right:=This:C1470.right
	$bottom:=This:C1470.bottom
	
	CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Screen:K27:7)
	CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Screen:K27:7)
	
	$o:={left: $left; top: $top; right: $right; bottom: $bottom}
	return $o
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==  
Function get width() : Integer
	
	return This:C1470.right-This:C1470.left
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==  
Function get height() : Integer
	
	return This:C1470.bottom-This:C1470.top
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==  
Function get dimensions() : Object
	
	var $o : Object
	
	$o:={width: This:C1470.width; height: This:C1470.height}
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function applyToWindow($winRef : Integer)
	
	SET WINDOW RECT:C444(This:C1470.left; This:C1470.top; This:C1470.right; This:C1470.bottom; $winRef)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function applyToWidget($name : Text)
	
	OBJECT SET COORDINATES:C1248(*; $name; This:C1470.left; This:C1470.top; This:C1470.right; This:C1470.bottom)
	