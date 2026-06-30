Class extends scrollable

property _backup
property _font : Text
property _dictionaries : Collection

Class constructor($name : Text; $parent : Object)
	
	Super:C1705($name; $parent)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get asPassword() : Boolean
	
	return OBJECT Get font:C1069(*; This:C1470.name)="%password"
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set asPassword($password : Boolean)
	
	$password:=($password=Null:C1517) ? True:C214 : $password
	
	If ($password)
		
		// Retain the original font
		This:C1470._font:=This:C1470._font || This:C1470.font
		This:C1470.font:="%password"
		
	Else 
		
		// Restoring the original font
		This:C1470.font:=This:C1470._font
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get autoSpellcheck() : Boolean
	
	return OBJECT Get auto spellcheck:C1174(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set autoSpellcheck($enabled : Boolean)
	
	OBJECT SET AUTO SPELLCHECK:C1173(*; This:C1470.name; $enabled)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dictionary() : Object
	
	This:C1470._dictionaries:=This:C1470._dictionaries || This:C1470._getDictionaries()
	
	return This:C1470._dictionaries.query("id = :1"; SPELL Get current dictionary:C1205).first()
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set dictionary($dictionary)
	
	This:C1470._dictionaries:=This:C1470._dictionaries || This:C1470._getDictionaries()
	
	If (This:C1470._dictionaries.query("id = :1 OR name = :1 OR code = :1"; $dictionary).pop()=Null:C1517)\
		 && (Position:C15("_"; $dictionary)>0)
		
		$dictionary:=Split string:C1554($dictionary; "_")[0]
		
	End if 
	
	If (Asserted:C1132(This:C1470._dictionaries.query("id = :1 OR name = :1 OR code = :1"; $dictionary).pop()#Null:C1517; \
		"The dictionary \""+String:C10($dictionary)+"\" isn't installed"))
		
		SPELL SET CURRENT DICTIONARY:C904($dictionary)
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getDictionaries() : Collection
	
	var $i : Integer
	var $c : Collection
	
	ARRAY TEXT:C222($files; 0)
	ARRAY TEXT:C222($names; 0)
	ARRAY LONGINT:C221($IDs; 0)
	
	SPELL GET DICTIONARY LIST:C1204($IDs; $files; $names)
	
	$c:=[]
	
	For ($i; 1; Size of array:C274($IDs); 1)
		
		$c.push({\
			id: $IDs{$i}; \
			code: $files{$i}; \
			name: $names{$i}\
			})
		
	End for 
	
	return $c
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get filter() : Text
	
	return OBJECT Get filter:C1073(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set filter($filter)
	
	var $sep : Text
	
	If (Value type:C1509($filter)=Is longint:K8:6)\
		 | (Value type:C1509($filter)=Is real:K8:4)  // Predefined formats
		
		Case of 
				
				//………………………………………………………………………
			: ($filter=Is integer:K8:5)\
				 | ($filter=Is longint:K8:6)\
				 | ($filter=Is integer 64 bits:K8:25)
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is real:K8:4)
				
				GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $sep)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";.;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is time:K8:8)
				
				GET SYSTEM FORMAT:C994(Time separator:K60:11; $sep)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";:\"")
				
				//………………………………………………………………………
			: ($filter=Is date:K8:7)
				
				GET SYSTEM FORMAT:C994(Date separator:K60:10; $sep)
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";/\"")
				
				//………………………………………………………………………
			Else 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "")  // Text as default
				
				//………………………………………………………………………
		End case 
		
	Else 
		
		OBJECT SET FILTER:C235(*; This:C1470.name; String:C10($filter))
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get placeholder() : Text
	
	return OBJECT Get placeholder:C1296(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set placeholder($placeholder : Text)
	
	This:C1470.setPlaceholder($placeholder)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Keep current value
Function backup($value) : cs:C1710.input
	
	This:C1470._backup:=$value || This:C1470.getValue()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function restore()
	
	This:C1470.value:=This:C1470._backup
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get modified() : Boolean
	
	return This:C1470._backup#This:C1470.getValue()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlight($startSel : Integer; $endSel : Integer) : cs:C1710.input
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)  // Select all
			
			HIGHLIGHT TEXT:C210(*; This:C1470.name; 1; MAXLONG:K35:2)
			
			//______________________________________________________
		: (Count parameters:C259=1)
			
			If ($startSel=-1)
				
				This:C1470.highlightLastToEnd()
				
			Else   // From $startSel to end
				
				HIGHLIGHT TEXT:C210(*; This:C1470.name; $startSel; MAXLONG:K35:2)
				
			End if 
			
			//______________________________________________________
		Else   // From $startSel to $endSel
			
			HIGHLIGHT TEXT:C210(*; This:C1470.name; $startSel; $endSel)
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// From the last character entered to the end
Function highlightLastToEnd() : cs:C1710.input
	
	HIGHLIGHT TEXT:C210(*; This:C1470.name; This:C1470.highlightingStart(); MAXLONG:K35:2)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlighted() : Object
	
	var $end; $start : Integer
	
	GET HIGHLIGHT:C209(*; This:C1470.name; $start; $end)
	
	var $o:={\
		start: $start; \
		end: $end; \
		length: $end-$start; \
		withSelection: $end#$start; \
		noSelection: $end=$start; \
		selection: ""}
	
	var $t : Text:=This:C1470.getValue()
	
	If (Length:C16($t)>0)
		
		$o.selection:=Substring:C12($t; $start; $o.length)
		
	End if 
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlightingStart() : Integer
	
	var $end; $start : Integer
	GET HIGHLIGHT:C209(*; This:C1470.name; $start; $end)
	
	return $start
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlightingEnd() : Integer
	
	var $end; $start : Integer
	GET HIGHLIGHT:C209(*; This:C1470.name; $start; $end)
	
	return $end
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setFilter($filter; $sep : Text) : cs:C1710.input
	
	If (Value type:C1509($filter)=Is longint:K8:6)\
		 | (Value type:C1509($filter)=Is real:K8:4)  // Predefined formats
		
		Case of 
				
				//………………………………………………………………………
			: ($filter=Is integer:K8:5)\
				 | ($filter=Is longint:K8:6)\
				 | ($filter=Is integer 64 bits:K8:25)
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is real:K8:4)
				
				If (Count parameters:C259<2)
					
					GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $sep)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";.;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is time:K8:8)
				
				If (Count parameters:C259<2)
					
					GET SYSTEM FORMAT:C994(Time separator:K60:11; $sep)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";:\"")
				
				//………………………………………………………………………
			: ($filter=Is date:K8:7)
				
				If (Count parameters:C259<2)
					
					GET SYSTEM FORMAT:C994(Date separator:K60:10; $sep)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$sep+";/\"")
				
				//………………………………………………………………………
			Else 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "")  // Text as default
				
				//………………………………………………………………………
		End case 
		
		return This:C1470
		
	End if 
	
	OBJECT SET FILTER:C235(*; This:C1470.name; String:C10($filter))
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getFilter() : Text
	
	return OBJECT Get filter:C1073(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setPlaceholder($placeholder : Text) : cs:C1710.input
	
	OBJECT SET PLACEHOLDER:C1295(*; This:C1470.name; This:C1470._getLocalizeString($placeholder))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ Override widget function
Function setEnterable($enterable : Boolean; $focusable : Boolean) : cs:C1710.input
	
	$enterable:=Count parameters:C259>=1 ? $enterable : True:C214
	
	If (Count parameters:C259>=2)
		
		If ($enterable)
			
			OBJECT SET ENTERABLE:C238(*; This:C1470.name; obk enterable:K42:45)
			
		Else 
			
			ARRAY TEXT:C222($textArray; 0x0000)
			FORM GET ENTRY ORDER:C1469($textArray; *)
			$focusable:=Find in array:C230($textArray; This:C1470.name)#-1
			
			If ($focusable)
				
				// Non-enterable, and its content can be selected
				OBJECT SET ENTERABLE:C238(*; This:C1470.name; obk not enterable:K42:44)
				
			Else 
				
				// Non-enterable, and its content cannot be selected.
				OBJECT SET ENTERABLE:C238(*; This:C1470.name; obk not enterable not focusable:K42:46)
				
			End if 
		End if 
		
	Else 
		
		OBJECT SET ENTERABLE:C238(*; This:C1470.name; $enterable)
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Replace the point by the decimal parameter in a text box
	// This function must be called during management of the "On Before Keystroke" event.
Function swapDecimalSeparator()
	
	var $sep : Text
	
	If (Keystroke:C390=".")
		
		GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $sep)
		FILTER KEYSTROKE:C389($sep)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Truncate with ellipsis
Function truncateWithEllipsis($where : Integer; $target : Text; $char : Text)
	
	$where:=Count parameters:C259>=1 ? $where : Align center:K42:3
	$target:=$target || This:C1470.value
	$char:=$char || "…"
	
	This:C1470.value:=$target
	
	var $bestHeight; $bestWidth : Integer
	OBJECT GET BEST SIZE:C717(*; This:C1470.name; $bestWidth; $bestHeight)
	
	var $result:=$target
	var $width:=This:C1470.rect.width
	
	While ($bestWidth>$width)
		
		var $pos : Integer:=$where=Align left:K42:2 ? 1\
			 : $where=Align center:K42:3 ? Length:C16($result)\2\
			 : Length:C16($result)-1
		
		$result:=Insert string:C231(Delete string:C232($result; $pos; 2); $char; $pos)
		
		This:C1470.value:=$result
		OBJECT GET BEST SIZE:C717(*; This:C1470.name; $bestWidth; $bestHeight)
		
	End while 