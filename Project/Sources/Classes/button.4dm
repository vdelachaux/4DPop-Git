Class extends widget

Class constructor($name : Text; $parent : Object)
	
	Super:C1705($name; $parent)
	
	This:C1470[""]:={}
	
	This:C1470[""].styleNames:=[\
		/*00*/"None"; \
		/*01*/"Background offset"; \
		/*02*/"Push button"; \
		/*03*/"Toolbar button"; \
		/*04*/"Custom"; \
		/*05*/"Circle"; \
		/*06*/"Small system square"; \
		/*07*/"Office XP"; \
		/*08*/"Bevel"; \
		/*09*/"Rounded bevel"; \
		/*10*/"Collapse/Expand"; \
		/*11*/"Help"; \
		/*12*/"OS X Textured"; \
		/*13*/"OS X Gradient"\
		]
	
	// Adjust height to suit system
	var $height:=This:C1470.height
	
	If ([0; 2].includes(This:C1470.style))
		
		Case of 
				
				// __________________________________________________
			: (This:C1470.type=Object type 3D button:K79:17)  // Push buttons
				
				If (Is Windows:C1573)
					
					This:C1470.height:=$height>18 ? 23 : 19
					
				Else 
					
					This:C1470.height:=$height>18 ? \
						/*Regular*/21 : $height>=16 ? \
						/*Small*/17 : \
						/*Mini*/16
					
				End if 
				
				// __________________________________________________
			: (This:C1470.type=Object type 3D checkbox:K79:27)\
				 || (This:C1470.type=Object type 3D radio button:K79:24)
				
				If (Is Windows:C1573)
					
					This:C1470.height:=13
					
				Else 
					
					This:C1470.height:=$height>17 ? \
						/*Regular*/17 : $height>=16 ? \
						/*Small*/16 : \
						/*Mini*/15
					
				End if 
				
				This:C1470.bestSize()
				
				// __________________________________________________
		End case 
	End if 
	
	//MARK:-[Text & Picture]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get linkedPopupMenu() : Boolean
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return Bool:C1537(($c.length>10) && ($c[11]="1"))
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set linkedPopupMenu($menuOn : Boolean)
	
	This:C1470._setPopupMenu($menuOn ? "linked" : "none")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setLinkedPopupMenu() : cs:C1710.button
	
	return This:C1470._setPopupMenu("linked")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get separatePopupMenu() : Boolean
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return Bool:C1537(($c.length>10) && ($c[11]="2"))
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set separatePopupMenu($menuOn : Boolean)
	
	This:C1470._setPopupMenu($menuOn ? "separate" : "none")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSeparatePopupMenu() : cs:C1710.button
	
	return This:C1470._setPopupMenu("separate")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNoPopupMenu() : cs:C1710.button
	
	return This:C1470._setPopupMenu("none")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Association of a pop-up menu with a 3D button
Function _setPopupMenu($value : Variant) : cs:C1710.button
	
/**
If no parameter is passed the pop menu is removed, if any.
Otherwise, the possible values are :
- 0 or "none": No pop-up menu
- 1 or "linked": With linked pop-up menu
- 2 or "separate": With separate pop-up menu
**/
	
	If (This:C1470.type=Object type 3D button:K79:17)
		
		If (Count parameters:C259>=1)
			
			If (Value type:C1509($value)=Is text:K8:3)
				
				Case of 
						
						//______________________________________________________
					: ($value="none")
						
						This:C1470.setFormat(";;;;;;;;;;0")
						This:C1470.removeEvent(On Alternative Click:K2:36)
						
						//______________________________________________________
					: ($value="linked")
						
						This:C1470.setFormat(";;;;;;;;;;1")
						This:C1470.removeEvent(On Alternative Click:K2:36)
						
						//______________________________________________________
					: ($value="separate")
						
						This:C1470.setFormat(";;;;;;;;;;2")
						This:C1470.addEvent(On Alternative Click:K2:36)
						
						//______________________________________________________
				End case 
				
			Else 
				
				This:C1470.setFormat(";;;;;;;;;;"+String:C10(Num:C11($value)))
				This:C1470[Num:C11($value)=2 ? "addEvent" : "removeEvent"](On Alternative Click:K2:36)
				
			End if 
			
		Else 
			
			This:C1470.setFormat(";;;;;;;;;;0")
			This:C1470.removeEvent(On Alternative Click:K2:36)
			
		End if 
		
	Else 
		
		// #ERROR
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get picture() : Text
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return $c.length>=2 ? $c[1] : ""
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set picture($proxy : Text)
	
	This:C1470.setPicture($proxy)
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Picture linked to a button
Function setPicture($proxy : Text) : cs:C1710.button
	
	If (Count parameters:C259=0)
		
		// Remove picture
		Super:C1706.setPicture()
		
	Else 
		
		Super:C1706.setPicture(This:C1470._proxy($proxy))
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get backgroundPicture() : Text
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return $c.length>=3 ? $c[2] : ""
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set backgroundPicture($proxy : Text)
	
	This:C1470.setBackgroundPicture($proxy)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Background picture linked to a button (Custom style)
Function setBackgroundPicture($proxy : Text) : cs:C1710.button
	
	If (Count parameters:C259=0)
		
		// Remove background picture
		This:C1470.setFormat(";;#")
		
	Else 
		
		This:C1470.setFormat(";;"+This:C1470._proxy($proxy))
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get numStates() : Integer
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return $c.length>=13 ? Num:C11($c[12]) : /*DEFAULT*/4
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set numStates($states : Integer)
	
	This:C1470.setNumStates($states)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Number of states present in picture used as icon for the 3D button, and which
	// will be used by 4D to represent the standard button states (from 0 to 6)
Function setNumStates($states : Integer) : cs:C1710.button
	
	If (Count parameters:C259>=1)
		
		This:C1470.setFormat(";;;;;;;;;;;;"+String:C10($states))
		
	Else 
		
		// Default is 4
		This:C1470.setFormat(";;;;;;;;;;;;4")
		
	End if 
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get style() : Integer
	
	var $c:=Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")
	return $c.length>=7 ? Num:C11($c[6]) : 0/*default*/
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set style($style : Integer)
	
	This:C1470.setStyle($style)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get styleName() : Text
	
	return This:C1470[""].styleNames[This:C1470.style]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Button style
Function setStyle($style : Integer) : cs:C1710.button
	
/**
style = 0: None (default)
style = 1: Background offset
style = 2: Push button
style = 3: Toolbar button
style = 4: Custom
style = 5: Circle
style = 6: Small system square
style = 7: Office XP
style = 8: Bevel
style = 9: Rounded bevel
style = 10: Collapse/Expand
style = 11: Help
style = 12: OS X Textured
style = 13: OS X Gradient
**/
	
	This:C1470.setFormat(";;;;;;"+String:C10($style))
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the number of pixels delimiting the inside left and right margins of the button
	/// (areas that the icon and the text must not encroach upon).
Function get horizontalMargin() : Integer
	
	If (This:C1470.is3DButton("horizontalMargin is only managed for 3D buttons"))
		
		return Num:C11(Split string:C1554(OBJECT Get format:C894(*; This:C1470.name); ";")[7])
		
	End if 
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
	/// Sets the number of pixels delimiting the inside left and right margins of the button
	/// (areas that the icon and the text must not encroach upon).
Function set horizontalMargin($pixels : Integer) : cs:C1710.button
	
	If (This:C1470.is3DButton("horizontalMargin is only managed for 3D buttons"))
		
		Super:C1706.setFormat(";;;;;;;"+String:C10($pixels))
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the current button is a 3D button
Function is3DButton($message : Text) : Boolean
	
	return [Object type 3D button:K79:17; Object type 3D checkbox:K79:27; Object type 3D radio button:K79:24].includes(This:C1470.type)
	
	// MARK:-[Miscellaneous]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Tryes to underline the first capital letter or,
	/// if not found the first letter, corresponding to the associated key shortcut
Function highlightShortcut() : cs:C1710.button
	
	var $UNDERLINED:=Char:C90(0x0332)
	
	var $key : Text
	var $modifier : Integer
	OBJECT GET SHORTCUT:C1186(*; This:C1470.name; $key; $modifier)
	
	var $t:=This:C1470.title
	
	If (Length:C16($key)>0)
		
		var $indx:=Position:C15(Uppercase:C13($key); $t; *)
		
		If ($indx=0)
			
			$indx:=Position:C15($key; $t)
			
		End if 
		
		If ($indx>0)
			
			This:C1470.title:=Substring:C12($t; 1; $indx)+$UNDERLINED+Substring:C12($t; $indx+1)
			
		End if 
		
	Else 
		
		// Remove if any
		This:C1470.title:=Replace string:C233($t; $UNDERLINED; "")
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ Overloading the parent
Function setShortcut($key : Text; $modifier : Integer) : cs:C1710.widget
	
	Super:C1706.setShortcut($key; $modifier)
	
	return This:C1470.highlightShortcut()
	