Class extends widgetDelegate

Class constructor($name : Text)
	
	Super:C1705($name)
	
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
Function get filter() : Text
	
	return OBJECT Get filter:C1073(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set filter($filter)
	
	This:C1470.setFilter($filter)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get placeholder() : Text
	
	return OBJECT Get placeholder:C1296(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set placeholder($placeholder : Text)
	
	This:C1470.setPlaceholder($placeholder)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Keep current value
Function backup($value) : cs:C1710.inputDelegate
	
	This:C1470.$backup:=$value || This:C1470.getValue()
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get modified() : Boolean
	
	return This:C1470.$backup#This:C1470.getValue()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlight($startSel : Integer; $endSel : Integer) : cs:C1710.inputDelegate
	
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
Function highlightLastToEnd() : cs:C1710.inputDelegate
	
	HIGHLIGHT TEXT:C210(*; This:C1470.name; This:C1470.highlightingStart()+1; MAXLONG:K35:2)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function highlighted() : Object
	
	var $t : Text
	var $end; $start : Integer
	var $o : Object
	
	GET HIGHLIGHT:C209(*; This:C1470.name; $start; $end)
	
	$o:={\
		start: $start; \
		end: $end; \
		length: $end-$start; \
		withSelection: $end#$start; \
		noSelection: $end=$start; \
		selection: ""}
	
	$t:=This:C1470.getValue()
	
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
Function setFilter($filter; $separator : Text) : cs:C1710.inputDelegate
	
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
					
					GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $separator)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";.;-;+\"")
				
				//………………………………………………………………………
			: ($filter=Is time:K8:8)
				
				If (Count parameters:C259<2)
					
					GET SYSTEM FORMAT:C994(Time separator:K60:11; $separator)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";:\"")
				
				//………………………………………………………………………
			: ($filter=Is date:K8:7)
				
				If (Count parameters:C259<2)
					
					GET SYSTEM FORMAT:C994(Date separator:K60:10; $separator)
					
				End if 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "&\"0-9;"+$separator+";/\"")
				
				//………………………………………………………………………
			Else 
				
				OBJECT SET FILTER:C235(*; This:C1470.name; "")  // Text as default
				
				//………………………………………………………………………
		End case 
		
		return This:C1470
		
	End if 
	
	$filter:=String:C10($filter)
	
	Case of 
			
			//______________________________________________________
		: ($filter="email")
			
			OBJECT SET FILTER:C235(*; This:C1470.name; "&\"a-z;0-9;@;.;-;_\"")
			
			//______________________________________________________
		: ($filter="url")
			
			OBJECT SET FILTER:C235(*; This:C1470.name; "&\"a-z;0-9;@;.;-;_;:;#;%;/;?;=\"")
			
			//______________________________________________________
		: ($filter="noSpaceNorCr")
			
			OBJECT SET FILTER:C235(*; This:C1470.name; "&\"!-ÿ\"")
			
			//______________________________________________________
		: ($filter="noCr")
			
			OBJECT SET FILTER:C235(*; This:C1470.name; "&\" -ÿ\"")
			
			//______________________________________________________
		Else 
			
			OBJECT SET FILTER:C235(*; This:C1470.name; $filter)
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getFilter() : Text
	
	return OBJECT Get filter:C1073(*; This:C1470.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setPlaceholder($placeholder : Text) : cs:C1710.inputDelegate
	
	var $t : Text
	
	If (Length:C16($placeholder)>0)\
		 & (Length:C16($placeholder)<=255)
		
		//%W-533.1
		If ($placeholder[[1]]#Char:C90(1))
			
			$t:=Get localized string:C991($placeholder)
			$t:=Length:C16($t)>0 ? $t : $placeholder  // Revert if no localization
			
		End if 
		//%W+533.1
		
	Else 
		
		$t:=$placeholder
		
	End if 
	
	OBJECT SET PLACEHOLDER:C1295(*; This:C1470.name; $t)
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get autoSpellcheck() : Boolean
	
	return OBJECT Get auto spellcheck:C1174(*; This:C1470.name)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set autoSpellcheck($enabled : Boolean)
	
	OBJECT SET AUTO SPELLCHECK:C1173(*; This:C1470.name; $enabled)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dictionary() : Object
	
	This:C1470.$dictionaries:=This:C1470.$dictionaries || This:C1470._getDictionaries()
	
	return This:C1470.$dictionaries.query("id = :1"; SPELL Get current dictionary:C1205).first()
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set dictionary($dictionary)
	
	This:C1470.$dictionaries:=This:C1470.$dictionaries || This:C1470._getDictionaries()
	
	If (This:C1470.$dictionaries.query("id = :1 OR name = :1 OR code = :1"; $dictionary).pop()=Null:C1517)\
		 && (Position:C15("_"; $dictionary)>0)
		
		$dictionary:=Split string:C1554($dictionary; "_")[0]
		
	End if 
	
	If (Asserted:C1132(This:C1470.$dictionaries.query("id = :1 OR name = :1 OR code = :1"; $dictionary).pop()#Null:C1517; \
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