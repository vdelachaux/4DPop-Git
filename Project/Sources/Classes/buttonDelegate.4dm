Class extends widgetDelegate

Class constructor($name : Text)
	
	Super:C1705($name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	///Tryes to underline the first capital letter or, 
	///if not found the first letter, corresponding to the associated key shortcut
Function highlightShortcut() : cs:C1710.buttonDelegate
	
	var $key; $t : Text
	var $index; $lModifier : Integer
	
	$t:=This:C1470.title
	
	OBJECT GET SHORTCUT:C1186(*; This:C1470.name; $key; $lModifier)
	
	If (Length:C16($key)>0)
		
		$index:=Position:C15(Uppercase:C13($key); $t; *)
		
		If ($index=0)
			
			$index:=Position:C15($key; $t)
			
		End if 
		
		If ($index>0)
			
			This:C1470.title:=Substring:C12($t; 1; $index)+Char:C90(0x0332)+Substring:C12($t; $index+1)
			
		End if 
		
	Else 
		
		// Remove if any
		This:C1470.title:=Replace string:C233($t; Char:C90(0x0332); "")
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setLinkedPopupMenu() : cs:C1710.buttonDelegate
	
	return This:C1470._setPopupMenu("linked")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setSeparatePopupMenu() : cs:C1710.buttonDelegate
	
	return This:C1470._setPopupMenu("separate")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setNoPopupMenu() : cs:C1710.buttonDelegate
	
	return This:C1470._setPopupMenu("none")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Picture linked to a button
Function setPicture($proxy : Text) : cs:C1710.buttonDelegate
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			// Remove picture
			Super:C1706.setPicture()
			
			//______________________________________________________
		: (Position:C15("path:"; $proxy)=1)\
			 || (Position:C15("file:"; $proxy)=1)\
			 || (Position:C15("var:"; $proxy)=1)\
			 || (Position:C15("!"; $proxy)=1)
			
			Super:C1706.setPicture($proxy)
			
			//______________________________________________________
		: (Position:C15("#"; $proxy)=1)  // Shortcut for Resources folder
			
			Super:C1706.setPicture("path:/RESOURCES/"+Delete string:C232($proxy; 1; 1))
			
			//______________________________________________________
		: (Position:C15("/"; $proxy)=1)
			
			Super:C1706.setPicture("path:/RESOURCES"+$proxy)
			
			//______________________________________________________
		Else 
			
			Super:C1706.setPicture("path:/RESOURCES/"+$proxy)
			
			//______________________________________________________
	End case 
	
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
Function set horizontalMargin($pixels : Integer) : cs:C1710.buttonDelegate
	
	If (This:C1470.is3DButton("horizontalMargin is only managed for 3D buttons"))
		
		Super:C1706.setFormat(";;;;;;;"+String:C10($pixels))
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Background picture linked to a button (Custom style)
Function setBackgroundPicture($proxy : Text) : cs:C1710.buttonDelegate
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			// Remove background picture
			This:C1470.setFormat(";;#")
			
			//______________________________________________________
		: (Position:C15("path:"; $proxy)=1)\
			 | (Position:C15("file:"; $proxy)=1)
			
			This:C1470.setFormat(";;"+$proxy)
			
			//______________________________________________________
		: (Position:C15("#"; $proxy)=1)  // Shortcut for Resources folder
			
			This:C1470.setFormat(";;path:/RESOURCES/"+Replace string:C233($proxy; "#"; ""; 1))
			
			//______________________________________________________
		: ($proxy="|@")
			
			This:C1470.setFormat(";;path:/.PRODUCT_RESOURCES/"+Delete string:C232($proxy; 1; 1))
			
			//______________________________________________________
		: (Position:C15("/"; $proxy)=1)
			
			This:C1470.setFormat(";;path:"+$proxy)
			
			//______________________________________________________
		Else 
			
			This:C1470.setFormat(";;path:/RESOURCES/"+$proxy)
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Number of states present in picture used as icon for the 3D button, and which
	// will be used by 4D to represent the standard button states (from 0 to 6)
Function setNumStates($states : Integer) : cs:C1710.buttonDelegate
	
	If (Count parameters:C259>=1)
		
		This:C1470.setFormat(";;;;;;;;;;;;"+String:C10($states))
		
	Else 
		
		// Default is 4
		This:C1470.setFormat(";;;;;;;;;;;;4")
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Button style
Function setStyle($style : Integer) : cs:C1710.buttonDelegate
	
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the current button is a 3D button
Function is3DButton($message : Text) : Boolean
	
	return [Object type 3D button:K79:17; Object type 3D checkbox:K79:27; Object type 3D radio button:K79:24].includes(This:C1470.type)
	
	
	//MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Association of a pop-up menu with a 3D button
Function _setPopupMenu($value : Variant) : cs:C1710.buttonDelegate
	
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
					Else 
						
						// #ERROR
						
						//______________________________________________________
				End case 
				
			Else 
				
				This:C1470.setFormat(";;;;;;;;;;"+String:C10(Num:C11($value)))
				This:C1470[Choose:C955(Num:C11($value)=2; "addEvent"; "removeEvent")](On Alternative Click:K2:36)
				
			End if 
			
		Else 
			
			This:C1470.setFormat(";;;;;;;;;;0")
			This:C1470.removeEvent(On Alternative Click:K2:36)
			
		End if 
		
	Else 
		
		// #ERROR
		
	End if 
	
	return This:C1470
	