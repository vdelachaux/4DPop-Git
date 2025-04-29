property name : Text
property height : Integer
property width : Integer

Class constructor($width; $height : Integer)
	
	Case of 
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is longint:K8:6)\
			 || (Value type:C1509($1)=Is real:K8:4)
			
			// Width
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			var $o : Object
			
			If ($1.getCoordinates#Null:C1517)\
				 && (OB Instance of:C1731($1.getCoordinates; 4D:C1709.Function))
				
				$o:=$1.getCoordinates()
				
			End if 
			
			If ($o#Null:C1517)  // Wwidget
				
				$o:=$o.rect
				
			Else 
				
				$o:=$1
				
			End if 
			
			$width:=Num:C11($o.width)
			$height:=Num:C11($o.height)
			
			// ______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)  // Object name
			
			var $left; $top; $right; $bottom : Integer
			OBJECT GET COORDINATES:C663(*; $1; $left; $top; $right; $bottom)
			
			$width:=$right-$left
			$height:=$bottom-$top
			
			//________________________________________________________________________________
		Else 
			
			throw:C1805(_error("The first parameter must be an Object or Text"))
			return 
			
			// ______________________________________________________
	End case 
	
	This:C1470.width:=$width
	This:C1470.height:=$height