property name:=""
property left; top; right; bottom : Integer

Class constructor($left; $top : Integer; $right : Integer; $bottom : Integer)
	
	This:C1470.name:=""
	
	Case of 
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is longint:K8:6)\
			 || (Value type:C1509($1)=Is real:K8:4)
			
			// Left
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			var $o : Object
			
			If ($1.getCoordinates#Null:C1517)\
				 && (OB Instance of:C1731($1.getCoordinates; 4D:C1709.Function))
				
				$o:=$1.getCoordinates()
				
			End if 
			
			If ($o#Null:C1517)  // Widget
				
				This:C1470.name:=String:C10($1.name)
				
			Else 
				
				$o:=$1
				
			End if 
			
			$left:=Num:C11($o.left)
			$top:=Num:C11($o.top)
			$right:=Num:C11($o.right)
			$bottom:=Num:C11($o.bottom)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)  // Object name
			
			This:C1470.name:=$1
			OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
			
		Else 
			
			throw:C1805(_error("The first parameter must be an Object or Text"))
			return 
			
			//______________________________________________________
	End case 
	
	This:C1470.left:=$left
	This:C1470.top:=$top
	This:C1470.right:=$right
	This:C1470.bottom:=$bottom
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get windowCoordinates() : Object
	
	var $left : Integer:=This:C1470.left
	var $top : Integer:=This:C1470.top
	var $right : Integer:=This:C1470.right
	var $bottom : Integer:=This:C1470.bottom
	
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
	
	var $left : Integer:=This:C1470.left
	var $top : Integer:=This:C1470.top
	var $right : Integer:=This:C1470.right
	var $bottom : Integer:=This:C1470.bottom
	
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
	
	return Try(This:C1470.right-This:C1470.left)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get height() : Integer
	
	return Try(This:C1470.bottom-This:C1470.top)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get rect() : cs:C1710.rect
	
	return cs:C1710.rect.new(This:C1470.width; This:C1470.height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function apply($name : Text)
	
	$name:=$name || This:C1470.name
	
	If (Length:C16($name)>0)
		
		OBJECT SET COORDINATES:C1248(*; $name; This:C1470.left; This:C1470.top; This:C1470.right; This:C1470.bottom)
		
	Else 
		
		throw:C1805(_error("Missing target name!"))
		
	End if 