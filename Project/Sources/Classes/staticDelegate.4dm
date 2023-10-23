/*
This class is the parent class of all form objects classes
*/

property name : Text
property type : Integer
property _coordinates : cs:C1710.coord

Class constructor($name : Text)
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.name:=Length:C16($name)>0 ? $name : OBJECT Get name:C1087(Object current:K67:2)
	This:C1470.type:=OBJECT Get type:C1300(*; This:C1470.name)
	
	If (Asserted:C1132(This:C1470.type#0; Current method name:C684+": No objects found named \""+This:C1470.name+"\""))
		
		This:C1470.updateCoordinates()
		
	End if 
	
	//MARK:-[Object]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get title() : Text
	
	return OBJECT Get title:C1068(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set title($title : Text)
	
	This:C1470.setTitle($title)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setTitle($title : Text) : cs:C1710.staticDelegate
	
	var $t : Text
	
	If (Length:C16($title)>0)\
		 & (Length:C16($title)<=255)
		
		//%W-533.1
		If ($title[[1]]#Char:C90(1))
			
			$t:=Get localized string:C991($title)
			$t:=Length:C16($t)>0 ? $t : $title  // Revert if no localization
			
		End if 
		//%W+533.1
		
	Else 
		
		$t:=$title
		
	End if 
	
	OBJECT SET TITLE:C194(*; This:C1470.name; $t)
	
	return This:C1470
	
	//MARK:-[Coordinates & Sizing]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get width() : Integer
	
	return cs:C1710.coord.new(This:C1470.name).width
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set width($width : Integer)
	
	This:C1470.setWidth($width)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setWidth($width : Integer) : cs:C1710.staticDelegate
	
	var $o : Object
	
	$o:=This:C1470.getCoordinates()
	$o.right:=$o.left+$width
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
	This:C1470.updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get height() : Integer
	
	return cs:C1710.coord.new(This:C1470.name).height
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set height($height : Integer)
	
	This:C1470.setHeight($height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setHeight($height : Integer) : cs:C1710.staticDelegate
	
	var $o : Object
	
	$o:=This:C1470.getCoordinates()
	$o.bottom:=$o.top+$height
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
	This:C1470.updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dimensions() : Object
	
	var $o : Object
	$o:=This:C1470.getCoordinates()
	
	return {\
		width: $o.right-$o.left; \
		height: $o.bottom-$o.top}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set dimensions($dimensions : Object)
	
	var $o : Object
	$o:=This:C1470.getCoordinates()
	
	If ($dimensions.width#Null:C1517)
		
		$o.right:=$o.left+Num:C11($dimensions.width)
		
	End if 
	
	If ($dimensions.height#Null:C1517)
		
		$o.bottom:=$o.top+Num:C11($dimensions.height)
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
	This:C1470.updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDimensions($width : Integer; $height : Integer) : cs:C1710.staticDelegate
	
	var $o : Object
	
	$o:=This:C1470.getCoordinates()
	$o.right:=$o.left+$width
	
	If (Count parameters:C259>=2)
		
		$o.bottom:=$o.top+$height
		
	End if 
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
	This:C1470.updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get coordinates() : Object
	
	This:C1470.getCoordinates()
	return This:C1470._coordinates
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	This:C1470.updateCoordinates($left; $top; $right; $bottom)
	
	return This:C1470._coordinates
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCoordinates($left; $top : Integer; $right : Integer; $bottom : Integer) : cs:C1710.staticDelegate
	
	var $o : Object
	
	If (Value type:C1509($left)=Is object:K8:27)
		
		$o:={\
			left: Num:C11($left.left); \
			top: Num:C11($left.top)}
		
		If ($left.right#Null:C1517)
			
			$o.right:=Num:C11($left.right)
			
		End if 
		
		If ($left.bottom#Null:C1517)
			
			$o.bottom:=Num:C11($left.bottom)
			
		End if 
		
	Else 
		
		$o:={\
			left: Num:C11($left); \
			top: Num:C11($top)}
		
		If (Count parameters:C259>=3)
			
			$o.right:=Num:C11($right)
			$o.bottom:=Num:C11($bottom)
			
		End if 
	End if 
	
	If ($o.right#Null:C1517)
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top; $o.right; $o.bottom)
		
	Else 
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $o.left; $o.top)
		
	End if 
	
	This:C1470.updateCoordinates($o.left; $o.top; $o.right; $o.bottom)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get windowCoordinates() : Object
	
	var $bottom; $left; $right; $top : Integer
	
	$left:=This:C1470._coordinates.left
	$top:=This:C1470._coordinates.top
	$right:=This:C1470._coordinates.right
	$bottom:=This:C1470._coordinates.bottom
	
	CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Current window:K27:6)
	CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Current window:K27:6)
	
	return {\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom}
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function bestSize($alignment; $minWidth : Integer; $maxWidth : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		If (Value type:C1509($alignment)=Is object:K8:27)
			
			$o:=$alignment
			$o.alignment:=$o.alignment ? $o.alignment : Align left:K42:2
			
		Else 
			
			$o:={alignment: Num:C11($alignment)}
			
			If (Count parameters:C259>=2)
				
				$o.minWidth:=$minWidth
				
				If (Count parameters:C259>=3)
					
					$o.maxWidth:=$maxWidth
					
				End if 
			End if 
		End if 
		
	Else 
		
		$o:={alignment: Align left:K42:2}  // Default is Align left
		
	End if 
	
	// Automatic adjustments according to the type of widget, if any
	Case of 
			
			//______________________________________________________
		: (Num:C11($o.minWidth)#0)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (This:C1470.type=Object type push button:K79:16)\
			 || (This:C1470.type=Object type 3D button:K79:17)
			
			$o.minWidth:=60
			
			//______________________________________________________
	End case 
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	If ([\
		Object type 3D button:K79:17; \
		Object type 3D checkbox:K79:27; \
		Object type 3D radio button:K79:24; \
		Object type checkbox:K79:26; \
		Object type listbox column:K79:10; \
		Object type picture button:K79:20; \
		Object type picture radio button:K79:25; \
		Object type push button:K79:16; \
		Object type radio button:K79:23; \
		Object type static picture:K79:3; \
		Object type static text:K79:2; \
		Object type listbox:K79:8; \
		Object type text input:K79:4].includes(This:C1470.type))
		
		If ($o.maxWidth#Null:C1517)
			
			OBJECT GET BEST SIZE:C717(*; This:C1470.name; $width; $height; $o.maxWidth)
			
		Else 
			
			OBJECT GET BEST SIZE:C717(*; This:C1470.name; $width; $height)
			
		End if 
		
		Case of 
				
				//______________________________
			: (This:C1470.type=Object type static text:K79:2)\
				 | (This:C1470.type=Object type checkbox:K79:26)
				
				If (Num:C11($o.alignment)=Align left:K42:2)
					
					// Add 10 pixels
					//$width:=$width+10
					
				End if 
				
				//______________________________
			: (This:C1470.type=Object type push button:K79:16)\
				 || (This:C1470.type=Object type 3D button:K79:17)
				
				// Add 10% for margins
				$width:=Round:C94($width*1.1; 0)
				
				//______________________________
			Else 
				
				// Add 10 pixels
				$width:=$width+10
				
				//______________________________
		End case 
		
		If ($o.minWidth#Null:C1517)
			
			$width:=$width<$o.minWidth ? $o.minWidth : $width
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: ($o.alignment=Align right:K42:4)
				
				$left:=$right-$width
				
				//______________________________________________________
			: ($o.alignment=Align center:K42:3)
				
				var $offset : Integer
				$offset:=($width\2)-(This:C1470.width\2)
				$left:=$left-$offset
				$right:=$right+$offset
				
				//______________________________________________________
			: ($o.alignment=Align left:K42:2)
				
				$right:=$left+$width
				
				//______________________________________________________
			Else 
				
				TRACE:C157
				
				//______________________________________________________
		End case 
		
		OBJECT SET COORDINATES:C1248(*; This:C1470.name; $left; $top; $right; $bottom)
		This:C1470.updateCoordinates($left; $top; $right; $bottom)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveHorizontally($offset : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$left:=$left+$offset
	$right:=$right+$offset
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveVertically($offset : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$top:=$top+$offset
	$bottom:=$bottom+$offset
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function resizeHorizontally($offset : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$right:=$right+$offset
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function resizeVertically($offset : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$bottom:=$bottom+$offset
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveAndResizeHorizontally($offset : Integer; $resize : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$left+=$offset
	
	If (Count parameters:C259>=2)
		
		$right+=$resize
		
	Else 
		
		//$right+=$offset
		
	End if 
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveAndResizeVertically($offset : Integer; $resize : Integer) : cs:C1710.staticDelegate
	
	var $bottom; $left; $right; $top : Integer
	
	OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
	
	$top:=$top+$offset
	
	If (Count parameters:C259>=2)
		
		$bottom:=$bottom+$resize
		
	End if 
	
	This:C1470.setCoordinates({\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom})
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateCoordinates($left : Integer; $top : Integer; $right : Integer; $bottom : Integer) : cs:C1710.staticDelegate
	
	If (Count parameters:C259<4)
		
		OBJECT GET COORDINATES:C663(*; This:C1470.name; $left; $top; $right; $bottom)
		
	End if 
	
	//This._coordinates:={\
				left: $left; \
				top: $top; \
				right: $right; \
				bottom: $bottom}
	
	This:C1470._coordinates:=cs:C1710.coord.new($left; $top; $right; $bottom)
	
	// Keep the position defined in structure
	This:C1470.initialPosition:=This:C1470.initialPosition || This:C1470._coordinates
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function backupCoordinates() : cs:C1710.staticDelegate
	
	This:C1470.initialPosition:=Null:C1517
	return This:C1470.updateCoordinates()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restorePosition()
	
	This:C1470.setCoordinates(This:C1470.initialPosition)
	
	//MARK:-[Entry]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get enabled() : Boolean
	
	return OBJECT Get enabled:C1079(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set enabled($enabled : Boolean)
	
	OBJECT SET ENABLED:C1123(*; This:C1470.name; $enabled)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function enable($state : Boolean) : cs:C1710.staticDelegate
	
	OBJECT SET ENABLED:C1123(*; This:C1470.name; Count parameters:C259=0 ? True:C214 : $state)
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get disabled() : Boolean
	
	return Not:C34(OBJECT Get enabled:C1079(*; This:C1470.name))
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set disabled($disabled : Boolean)
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; Not:C34($disabled))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function disable() : cs:C1710.staticDelegate
	
	OBJECT SET ENABLED:C1123(*; This:C1470.name; False:C215)
	
	return This:C1470
	
	//MARK:-[Display]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get visible() : Boolean
	
	return OBJECT Get visible:C1075(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set visible($visible : Boolean)
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; $visible)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function show($state : Boolean) : cs:C1710.staticDelegate
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; Count parameters:C259=0 ? True:C214 : $state)
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get hidden() : Boolean
	
	return Not:C34(OBJECT Get visible:C1075(*; This:C1470.name))
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set hidden($hidden : Boolean)
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; Not:C34($hidden))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hide() : cs:C1710.staticDelegate
	
	OBJECT SET VISIBLE:C603(*; This:C1470.name; False:C215)
	
	return This:C1470
	
	// MARK:-[Colors]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get colors() : cs:C1710.colour
	
	var $altBackground; $background; $foreground : Text
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground; $background; $altBackground)
	return {\
		foreground: $foreground; \
		background: $background; \
		altBackground: $altBackground}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set colors($colors : Object)
	
	This:C1470.setColors($colors)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get backgroundColor() : Variant
	
	var $foreground; $background
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground; $background)
	return $background
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set backgroundColor($color)
	
	var $foreground; $background; $altBackground
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground; $background)
	OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $color)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get altBackgroundColor() : Variant
	
	var $foreground; $background; $altBackground
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground; $background; $altBackground)
	return $altBackground
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set altBackgroundColor($color)
	
	var $foreground; $background; $altBackground
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground; $background; $altBackground)
	OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background; $color)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get foregroundColor() : Variant
	
	var $foreground
	
	OBJECT GET RGB COLORS:C1074(*; This:C1470.name; $foreground)
	return $foreground
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set foregroundColor($color)
	
	OBJECT SET RGB COLORS:C628(*; This:C1470.name; $color)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setColors($foreground : Variant; $background : Variant; $altBackground : Variant) : cs:C1710.staticDelegate
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($foreground)=Is object:K8:27)
			
			$altBackground:=$foreground.altBackground ? $foreground.altBackground : Null:C1517
			$background:=$foreground.background ? $foreground.background : Null:C1517
			$foreground:=$foreground.foreground ? $foreground.foreground : Null:C1517
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: ($altBackground#Null:C1517)
					
					$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
					$background:=Value type:C1509($background)=Is text:K8:3 ? $background : Num:C11($background)
					$altBackground:=Value type:C1509($altBackground)=Is text:K8:3 ? $altBackground : Num:C11($altBackground)
					OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background; $altBackground)
					
					//…………………………………………………………………………………………………………………………
				: ($background#Null:C1517)
					
					$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
					$background:=Value type:C1509($background)=Is text:K8:3 ? $background : Num:C11($background)
					OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background)
					
					//…………………………………………………………………………………………………………………………
				: ($foreground#Null:C1517)
					
					$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
					OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground)
					
					//…………………………………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
		: (Count parameters:C259>=3)
			
			$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
			$background:=Value type:C1509($background)=Is text:K8:3 ? $background : Num:C11($background)
			$altBackground:=Value type:C1509($altBackground)=Is text:K8:3 ? $altBackground : Num:C11($altBackground)
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background; $altBackground)
			
			//______________________________________________________
		: (Count parameters:C259>=2)
			
			$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
			$background:=Value type:C1509($background)=Is text:K8:3 ? $background : Num:C11($background)
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground; $background)
			
			//______________________________________________________
		: (Count parameters:C259>=1)
			
			$foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Num:C11($foreground)
			OBJECT SET RGB COLORS:C628(*; This:C1470.name; $foreground)
			
			//______________________________________________________
		Else 
			
			// #ERROR
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	//MARK:-[Text]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get horizontalAlignment() : Integer
	
	return OBJECT Get horizontal alignment:C707(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set horizontalAlignment($alignment : Integer)
	
	OBJECT SET HORIZONTAL ALIGNMENT:C706(*; This:C1470.name; $alignment+Num:C11($alignment=0))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignLeft() : cs:C1710.staticDelegate
	
	OBJECT SET HORIZONTAL ALIGNMENT:C706(*; This:C1470.name; Align left:K42:2)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignRight() : cs:C1710.staticDelegate
	
	OBJECT SET HORIZONTAL ALIGNMENT:C706(*; This:C1470.name; Align right:K42:4)
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get verticalAlignment() : Integer
	
	return OBJECT Get vertical alignment:C1188(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set verticalAlignment($alignment : Integer)
	
	OBJECT SET VERTICAL ALIGNMENT:C1187(*; This:C1470.name; $alignment+Num:C11($alignment=0))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignTop() : cs:C1710.staticDelegate
	
	OBJECT SET VERTICAL ALIGNMENT:C1187(*; This:C1470.name; Align top:K42:5)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignBottom() : cs:C1710.staticDelegate
	
	OBJECT SET VERTICAL ALIGNMENT:C1187(*; This:C1470.name; Align bottom:K42:6)
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignCenter($vertical : Boolean) : cs:C1710.staticDelegate
	
	If ($vertical)
		
		OBJECT SET VERTICAL ALIGNMENT:C1187(*; This:C1470.name; Align center:K42:3)
		
	Else 
		
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; This:C1470.name; Align center:K42:3)
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get font() : Text
	
	return OBJECT Get font:C1069(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set font($font : Text)
	
	This:C1470.setFont($font)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setFont($font : Text) : cs:C1710.staticDelegate
	
	Case of 
			
			//______________________________________________________
		: ($font="")\
			 | ($font="default")\
			 | ($font="system")  // Default font
			
			OBJECT SET FONT:C164(*; This:C1470.name; OBJECT Get font:C1069(*; ""))
			
			//______________________________________________________
		: ($font="emoji")  // Compatible emoji font for Windows
			
			If (Is Windows:C1573)
				
				var $desiredFonts : Collection
				$desiredFonts:=[\
					"Segoe UI Emoji"; \
					"Segoe UI Symbol"; \
					"Yu Mincho"; \
					"Yu Gothic"]
				
				For each ($font; $desiredFonts)
					
					If (This:C1470._fontList().includes($font))
						
						OBJECT SET FONT:C164(*; This:C1470.name; $font)
						break
						
					End if 
					
				End for each 
			End if 
			
			//______________________________________________________
		Else 
			
			OBJECT SET FONT:C164(*; This:C1470.name; $font)
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _fontList() : Collection
	
	If (This:C1470._fonts=Null:C1517)
		
		ARRAY TEXT:C222($fonts; 0)
		FONT LIST:C460($fonts)
		This:C1470._fonts:=[]
		ARRAY TO COLLECTION:C1563(This:C1470._fonts; $fonts)
		
	End if 
	
	return This:C1470._fonts
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get fontStyle() : Integer
	
	return OBJECT Get font style:C1071(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set fontStyle($tyle : Integer)
	
	This:C1470.setFontStyle($tyle)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setFontStyle($style : Integer) : cs:C1710.staticDelegate
	
	OBJECT SET FONT STYLE:C166(*; This:C1470.name; $style)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get fontSize() : Integer
	
	return OBJECT Get font size:C1070(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set fontSize($size : Integer)
	
	OBJECT SET FONT SIZE:C165(*; This:C1470.name; $size)
	
	// MARK:-[Miscellaneous]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Adds this widget to a group
Function addToGroup($group : cs:C1710.groupDelegate) : cs:C1710.staticDelegate
	
	If (Asserted:C1132(OB Instance of:C1731($group; cs:C1710.groupDelegate); "The parameter isn't a group"))
		
		$group.add(This:C1470)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hiddenFromView() : cs:C1710.staticDelegate
	
	OBJECT SET COORDINATES:C1248(*; This:C1470.name; -100; -100; -100; -100)
	
	return This:C1470
	