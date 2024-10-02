property name : Text
property left; top; right; bottom : Integer

Class constructor($left; $top : Integer; $right : Integer; $bottom : Integer)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($left)=Is object:K8:27)\
			 && ($left.coordinates#Null:C1517)  // Widget
			
			This:C1470.name:=$left.name
			
			var $o : Object
			$o:=$left.getCoordinates()
			
			$left:=$o.left
			$top:=$o.top
			$right:=$o.right
			$bottom:=$o.bottom
			
			//______________________________________________________
		: (Value type:C1509($left)=Is text:K8:3)  // Object name
			
			This:C1470.name:=$left
			
			OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
			
			//______________________________________________________
	End case 
	
	This:C1470.left:=$left
	This:C1470.top:=$top
	This:C1470.right:=$right
	This:C1470.bottom:=$bottom
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get windowCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	
	$left:=This:C1470.left
	$top:=This:C1470.top
	$right:=This:C1470.right
	$bottom:=This:C1470.bottom
	
	CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Current window:K27:6)
	CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Current window:K27:6)
	
	return {\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom\
		}
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get screenCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	
	$left:=This:C1470.left
	$top:=This:C1470.top
	$right:=This:C1470.right
	$bottom:=This:C1470.bottom
	
	CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Screen:K27:7)
	CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Screen:K27:7)
	
	return {\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom\
		}
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get width() : Integer
	
	return This:C1470.right-This:C1470.left
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get height() : Integer
	
	return This:C1470.bottom-This:C1470.top
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dimensions() : Object
	
	return {\
		width: This:C1470.width; \
		height: This:C1470.height\
		}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function apply($name : Text)
	
	$name:=$name || This:C1470.name
	ASSERT:C1129($name#Null:C1517; "Missing target name!")
	
	OBJECT SET COORDINATES:C1248(*; $name; This:C1470.left; This:C1470.top; This:C1470.right; This:C1470.bottom)