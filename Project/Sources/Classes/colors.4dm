property _foreground; _background; _altBackground

Class constructor($foreground; $background; $altBackground)
	
	$foreground:=Count parameters:C259>=1 ? $foreground : Foreground color:K23:1
	$background:=Count parameters:C259>=2 ? $background : Background color:K23:2
	$altBackground:=Count parameters:C259>=3 ? $altBackground : Background color:K23:2
	
	This:C1470._setColors($foreground; $background; $altBackground)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get colors() : Object
	
	return {\
		foreground: This:C1470._foreground; \
		background: This:C1470._background; \
		altBackground: This:C1470._altBackground}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set colors($o : Object)
	
	This:C1470._setColors($o.foreground; $o.background; $o.altBackground)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get foreground() : Variant
	
	return This:C1470._foreground
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set foreground($color)
	
	This:C1470._foreground:=Value type:C1509($color)=Is text:K8:3 ? $color : Num:C11($color)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get background() : Variant
	
	return This:C1470._background
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set background($color)
	
	This:C1470._background:=Value type:C1509($color)=Is text:K8:3 ? $color : Num:C11($color)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get altBackground() : Variant
	
	return This:C1470._altBackground
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set altBackground($color)
	
	This:C1470._altBackground:=Value type:C1509($color)=Is text:K8:3 ? $color : Num:C11($color)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function apply($target)
	
	Case of 
			
			// ______________________________________________________
		: (Value type:C1509($target)=Is text:K8:3)
			
			OBJECT SET RGB COLORS:C628(*; $target; This:C1470._foreground; This:C1470._background; This:C1470._altBackground)
			
			// ______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)
			
			var $o : Object:=Try($target.colors)
			
			If ($o#Null:C1517)  // Widget
				
				$o.setColors({\
					foreground: This:C1470._foreground; \
					background: This:C1470._background; \
					altBackground: This:C1470._altBackground})
				
			Else 
				
/*ERROR*/ASSERT:C1129(False:C215; "Target must be a widget object!")
				
			End if 
			
			// ______________________________________________________
		Else 
			
/*ERROR*/ASSERT:C1129(False:C215; "Missing target!")
			
			// ______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function removeAltBackgroundColor() : cs:C1710.colors
	
	This:C1470._altBackground:=Background color none:K23:10
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function removeBackgroundColor() : cs:C1710.colors
	
	This:C1470._background:=Background color none:K23:10
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreForegroundColor() : cs:C1710.colors
	
	This:C1470._foreground:=Foreground color:K23:1
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreBackgroundColor() : cs:C1710.colors
	
	This:C1470._background:=Background color:K23:2
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restoreAltBackgroundColor() : cs:C1710.colors
	
	This:C1470._altBackground:=Background color:K23:2
	return This:C1470
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _setColors($foreground; $background; $altBackground)
	
	This:C1470._foreground:=Value type:C1509($foreground)=Is text:K8:3 ? $foreground : Try(Num:C11($foreground))
	This:C1470._background:=Value type:C1509($background)=Is text:K8:3 ? $background : Try(Num:C11($background))
	This:C1470._altBackground:=Value type:C1509($altBackground)=Is text:K8:3 ? $altBackground : Try(Num:C11($altBackground))