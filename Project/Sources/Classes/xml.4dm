Class constructor($variable)
	
	This:C1470.root:=Null:C1517
	This:C1470.file:=Null:C1517
	This:C1470.xml:=Null:C1517
	
	This:C1470.success:=False:C215
	This:C1470.autoClose:=True:C214
	
	This:C1470.errors:=New collection:C1472
	
	If ($variable#Null:C1517)
		
		This:C1470.load($variable)
		
	Else 
		
		This:C1470.success:=True:C214
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Creates a XML tree in memory
Function newRef($root : Text; $nameSpace : Text;  ...  : Text) : cs:C1710.xml
	
	var $t : Text
	var $countParam; $i : Integer
	
	$countParam:=Count parameters:C259
	
	OK:=0
	
	This:C1470._reset()
	
	Case of 
			
			//______________________________________________________
		: ($countParam=0)
			
			This:C1470.root:=DOM Create XML Ref:C861("root")
			
			//______________________________________________________
		: ($countParam=1)  // -> root
			
			This:C1470.root:=DOM Create XML Ref:C861($root)
			
			//______________________________________________________
		: ($countParam=2)  // -> root + namespace
			
			This:C1470.root:=DOM Create XML Ref:C861($root; $nameSpace)
			
			//______________________________________________________
		: (($countParam%2)=0)  // -> root + namespace's pairs
			
			$t:="DOM Create XML Ref:C861("
			
			For ($i; 1; $countParam; 2)
				
				$t:=$t+(";"*Num:C11($i>1))+"\""+${$i}+"\";\""+${$i+1}+"\""
				
			End for 
			
			$t:=$t+")"
			
			This:C1470.root:=Formula from string:C1601($t).call()
			
			//______________________________________________________
		Else   // -> root + namespace + namespace's pairs
			
			$t:="DOM Create XML Ref:C861("+$root+";"+$nameSpace
			
			For ($i; 2; $countParam; 2)
				
				$t:=$t+";\""+${$i}+"\";\""+${$i+1}+"\""
				
			End for 
			
			$t:=$t+")"
			
			This:C1470.root:=Formula from string:C1601($t).call()
			
			//______________________________________________________
	End case 
	
	This:C1470.success:=Bool:C1537(OK)
	
	return This:C1470
	
	//———————————————————————————————————————————————————————————
	// Defines the options concerning the encoding and the standalone property of the tree
Function setDeclaration($encoding : Text; $standalone : Boolean)
	
	Case of 
			
			//____________________________________________
		: (Count parameters:C259=0)  // Defaults values
			
			DOM SET XML DECLARATION:C859(This:C1470.root; "UTF-8"; False:C215)
			
			//____________________________________________
		: (Count parameters:C259=1)
			
			DOM SET XML DECLARATION:C859(This:C1470.root; $encoding; False:C215)
			
			//____________________________________________
		: (Count parameters:C259=2)
			
			DOM SET XML DECLARATION:C859(This:C1470.root; $encoding; $standalone)
			
			//____________________________________________
	End case 
	
	//———————————————————————————————————————————————————————————
	// Set the value of one option for the structure
Function setOption($selector : Integer; $value : Integer) : cs:C1710.xml
	
	This:C1470.success:=(Count parameters:C259=2)
	
	If (This:C1470.success)
		
		XML SET OPTIONS:C1090(This:C1470.root; $selector; $value)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Unbalanced selector/value pairs")
		
	End if 
	
	return This:C1470
	
	//———————————————————————————————————————————————————————————
	// Set the value of one or more XML options for the structure
Function setOptions($selector : Integer; $value : Integer;  ...  : Integer) : cs:C1710.xml
	
	var $i : Integer
	
	This:C1470.success:=((Count parameters:C259%2)=0)
	
	If (This:C1470.success)
		
		For ($i; 1; Count parameters:C259; 2)
			
			XML SET OPTIONS:C1090(This:C1470.root; ${$i}; ${$i+1})
			
		End for 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Unbalanced selector/value pairs")
		
	End if 
	
	return This:C1470
	
	//———————————————————————————————————————————————————————————
	// Parse a variable (TEXT or BLOB)
Function parse($source : Variant; $validate : Boolean; $schema : Text) : cs:C1710.xml
	
	Case of 
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=3)
			
			return This:C1470.load($source; $validate; $schema)
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=2)
			
			return This:C1470.load($source; $validate)
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=1)
			
			return This:C1470.load($source)
			
			//……………………………………………………………………………………………
		Else 
			
			return This:C1470.load()
			
			//……………………………………………………………………………………………
	End case 
	
	//———————————————————————————————————————————————————————————
	// Open and parse a file
Function open($file : 4D:C1709.File; $validate : Boolean; $schema : Text) : cs:C1710.xml
	
	If ($file=Null:C1517)
		
		This:C1470.success:=False:C215
		This:C1470.errors.push(Current method name:C684+" -  Missing the target to load")
		return 
		
	End if 
	
	return This:C1470.load($file; $validate; $schema)
	
	//———————————————————————————————————————————————————————————
	// Load a variable (TEXT or BLOB) or a file
Function load($source; $validate : Boolean; $schema : Text) : cs:C1710.xml
	
	var $root : Text
	
	This:C1470.close()  // Release memory
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			This:C1470.success:=False:C215
			This:C1470.errors.push(Current method name:C684+" -  Missing the target to load")
			
			//______________________________________________________
		: (Value type:C1509($source)=Is text:K8:3)\
			 | (Value type:C1509($source)=Is BLOB:K8:12)  // Parse a given variable
			
			$root:=DOM Parse XML variable:C720($source; $validate; $schema)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				This:C1470.root:=$root
				
			Else 
				
				This:C1470.errors.push(Current method name:C684+" -  Failed to parse the "+(Value type:C1509($source)=Is text:K8:3 ? "text" : "blob")+" variable")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($source)=Is object:K8:27)  // File to load
			
			This:C1470.success:=OB Instance of:C1731($source; 4D:C1709.File)
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push(Current method name:C684+" -  The parameter is not a File object")
				return This:C1470
				
			End if 
			
			This:C1470.success:=$source.isFile & $source.exists
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push(Current method name:C684+" -  File not found: "+String:C10($source.platformPath))
				return This:C1470
				
			End if 
			
			$root:=DOM Parse XML source:C719($source.platformPath; $validate; $schema)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				This:C1470.root:=$root
				This:C1470.file:=$source
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Unmanaged type: "+String:C10(Value type:C1509($source)))
			
			//________________________________________
	End case 
	
	return This:C1470
	
	//———————————————————————————————————————————————————————————
Function save($file; $keepStructure : Boolean) : cs:C1710.xml
	
	var $t : Text
	
	If (Count parameters:C259>=2)
		
		// <NOTHING MORE TO DO>
		
	Else 
		
		If (Count parameters:C259>=1)
			
			If (Value type:C1509($file)=Is object:K8:27)
				
				// <NOTHING MORE TO DO>
				
			Else 
				
				$file:=This:C1470.file
				$keepStructure:=Bool:C1537($file)
				
			End if 
			
		Else 
			
			$file:=This:C1470.file
			
		End if 
	End if 
	
	This:C1470.success:=OB Instance of:C1731($file; 4D:C1709.File)
	
	If (This:C1470.success)
		
		DOM EXPORT TO VAR:C863(This:C1470.root; $t)
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			This:C1470.xml:=$t
			$file.setText($t)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Failed to export XML")
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  File is not defined")
		
	End if 
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470._close($keepStructure)
			
		Else 
			
			This:C1470._close()
			
		End if 
	End if 
	
	return This:C1470
	
	//———————————————————————————————————————————————————————————
	// Close the XML tree
Function close() : cs:C1710.xml
	
	This:C1470.success:=(This:C1470.root#Null:C1517)
	
	If (This:C1470.success)
		
		DOM CLOSE XML:C722(This:C1470.root)
		This:C1470.success:=Bool:C1537(OK)
		This:C1470.root:=Null:C1517
		
	End if 
	
	return This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function create($target : Text; $XPath; $attributes)->$node : Text
	
	If (Not:C34(This:C1470._requiredParams(Count parameters:C259; 1)))
		
		return 
		
	End if 
	
	If (This:C1470.isReference($target))
		
		$node:=DOM Create XML element:C865($target; $XPath)
		
		If (Count parameters:C259>=3)
			
			This:C1470.setAttributes($node; $attributes)
			
		End if 
		
	Else 
		
		$node:=DOM Create XML element:C865(This:C1470.root; $target)
		
		If (Count parameters:C259>=2)
			
			This:C1470.setAttributes($node; $XPath)
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK)
	
	//———————————————————————————————————————————————————————————
	// Append a source element to the target element
Function append($target : Text; $source : Text)->$node : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		$node:=DOM Append XML element:C1082($target; $source)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Append a comment to the target element
Function comment($target : Text; $comment : Text)->$node : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$node:=DOM Append XML child node:C1080($target; XML comment:K45:8; $comment)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Insert a XML element among the child elements of the $target element
Function insert($target : Text; $source : Text; $index : Integer)->$node : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		$node:=DOM Insert XML element:C1083($target; $source; $index)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Makes a copy of the given object
Function clone($source : Text; $target : Text)->$node : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		$node:=DOM Append XML element:C1082($target; $source)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	//———————————————————————————————————————————————————————————/
	// Returns the XML tree as text
Function getText($keepStructure : Boolean)->$xml : Text
	
	DOM EXPORT TO VAR:C863(This:C1470.root; $xml)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.xml:=$xml
		
		If (Count parameters:C259>=1)
			
			This:C1470._close($keepStructure)
			
		Else 
			
			This:C1470._close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Failed to export XML to text.")
		
	End if 
	
	//———————————————————————————————————————————————————————————/
	// Return the  XML tree as BLOB
Function getContent($keepStructure : Boolean)->$content : Blob
	
	DOM EXPORT TO VAR:C863(This:C1470.root; $content)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470._close($keepStructure)
			
		Else 
			
			This:C1470._close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Failed to export XML to BLOB.")
		
	End if 
	
	//———————————————————————————————————————————————————————————/
	// 
Function toObject($withAdresses : Boolean) : Object
	
	return This:C1470._elementToObject(This:C1470.root; $withAdresses)
	
	//———————————————————————————————————————————————————————————/
	// 
Function toList($refPtr : Pointer; $xpath : Text; $root : Text) : Integer
	
	var $name; $node; $value; $current : Text
	var $count; $i; $ref; $list; $sublist : Integer
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259<2)
			
			This:C1470._pushError("Missing parameter")
			return 
			
			//______________________________________________________
		: (Length:C16($xpath)=0)
			
			This:C1470._pushError("xpath parameter couldn't be an empty string")
			return 
			
			//______________________________________________________
		: ($xpath="/")
			
			This:C1470._pushError("You must provide the root name of the XML tree in the xpath parameter")
			return 
			
			//______________________________________________________
		Else 
			
			If (Count parameters:C259<3)
				
				If (This:C1470.isReference($xpath))
					
					$root:=$xpath
					$xpath:=""
					
				Else 
					
					$root:=This:C1470.root
					
				End if 
			End if 
			
			// Ensure to work with an absolute path
			$xpath:=$xpath[[1]]="/" ? $xpath : "/"+$xpath
			
			DOM GET XML ELEMENT NAME:C730($root; $name)
			DOM GET XML ELEMENT VALUE:C731($root; $value)
			
			$list:=New list:C375
			
			Repeat 
				
				$current:=$xpath+"/"+$name
				$refPtr->+=1
				$ref:=$refPtr->
				
				$count:=DOM Count XML attributes:C727($root)
				ARRAY TEXT:C222($names; $count)
				ARRAY TEXT:C222($values; $count)
				
				If ($count>0)
					
					For ($i; 1; $count; 1)
						
						DOM GET XML ATTRIBUTE BY INDEX:C729($root; $i; $names{$i}; $values{$i})
						
					End for 
				End if 
				
				$node:=DOM Get first child XML element:C723($root)
				
				If (Bool:C1537(OK))
					
					$sublist:=This:C1470.toList($refPtr; $current; $node)  // <==== RECURSIVE
					
					APPEND TO LIST:C376($list; $name; $ref; $sublist; True:C214)
					SET LIST ITEM PROPERTIES:C386($list; 0; False:C215; Bold:K14:2; 0)
					
				Else 
					
					If ($name#"")
						
						APPEND TO LIST:C376($list; $name; $ref)
						SET LIST ITEM PARAMETER:C986($list; 0; "value"; This:C1470._convert($value))
						SET LIST ITEM PARAMETER:C986($list; 0; "dom"; $root)
						
						For ($i; 1; $count; 1)
							
							SET LIST ITEM PARAMETER:C986($list; 0; $names{$i}; $values{$i})
							
						End for 
					End if 
				End if 
				
				SET LIST ITEM PARAMETER:C986($list; 0; "xpath"; $current)
				
				$root:=DOM Get next sibling XML element:C724($root; $name; $value)
				
			Until (OK=0)
			
			//______________________________________________________
	End case 
	
	return $list
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Search for an element by its id
Function findById($id : Text)->$reference : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$reference:=DOM Find XML element by ID:C1010(This:C1470.root; $id)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" - Missing id parameter")
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Looks  for the 1st element corresponding to an XPath & returns its reference if success.
Function findByXPath($xpath : Text; $node : Text)->$reference : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$reference:=DOM Find XML element:C864($node; $xpath)
			
		Else 
			
			// Search from the root
			$reference:=DOM Find XML element:C864(This:C1470.root; $xpath)
			
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Searches for one or more elements corresponding to an XPath & returns a references collection if success.
Function find($node : Text; $xpath : Text)->$references : Collection
	
	$references:=New collection:C1472
	ARRAY TEXT:C222($nodes; 0)
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470.isReference($node))\
			 & (Count parameters:C259>=2)
			
			$nodes{0}:=DOM Find XML element:C864($node; $xpath; $nodes)
			
		Else 
			
			// Start at the root, query string is the 1st parameter
			$nodes{0}:=DOM Find XML element:C864(This:C1470.root; $node; $nodes)
			
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			ARRAY TO COLLECTION:C1563($references; $nodes)
			
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Search for elements by there name & returns a references collection if success.
Function findByName($target : Text; $name : Text)->$references : Collection
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		ARRAY TEXT:C222($nodes; 0)
		
		If (Count parameters:C259>=2)
			
			If (This:C1470.isReference($target))
				
				If (This:C1470._requiredParams(Count parameters:C259; 2))
					
					$nodes{0}:=DOM Find XML element:C864($target; $name; $nodes)
					This:C1470.success:=Bool:C1537(OK)
					
				Else 
					
					This:C1470.success:=False:C215
					This:C1470.errors.push(Current method name:C684+" - Missing name parameter")
					
				End if 
				
			Else 
				
				$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$target; $nodes)
				This:C1470.success:=Bool:C1537(OK)
				
			End if 
			
		Else 
			
			$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$target; $nodes)
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
		
		If (This:C1470.success)
			
			$references:=New collection:C1472
			ARRAY TO COLLECTION:C1563($references; $nodes)
			
		End if 
		
	Else 
		
		This:C1470.success:=False:C215
		This:C1470.errors.push(Current method name:C684+" - Missing name parameter")
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Search for elements by there attribute
Function findByAttribute($target : Text; $name : Text; $value : Text; $valor)->$references : Collection
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		ARRAY TEXT:C222($nodes; 0)
		
		If (This:C1470.isReference($1))
			
			Case of 
					
					//______________________________________________________
				: (Count parameters:C259=2)  // Elements with the attribute $name
					
					$nodes{0}:=DOM Find XML element:C864($target; "//@"+$name; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259=3)  // Elements with the attribute $name equal to $value
					
					$nodes{0}:=DOM Find XML element:C864($target; "//[@"+$name+"=\""+$value+"\"]"; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259>=4)  // Elements $name with the attribute $value equal to $valor
					
					$nodes{0}:=DOM Find XML element:C864($target; "//"+$name+"[@"+$value+"=\""+$valor+"\"]"; $nodes)
					
					//______________________________________________________
				Else 
					
					OK:=0
					
					//______________________________________________________
			End case 
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Count parameters:C259=1)  // Elements with the attribute $1
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//@"+$target; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259=2)  // Elements with the attribute $target equal to $name
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//*[@"+$target+"=\""+$name+"\"]"; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259>=3)  // Elements $name with the attribute $name equal to $value
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$target+"[@"+$name+"=\""+$value+"\"]"; $nodes)
					
					//______________________________________________________
				Else 
					
					OK:=0
					
					//______________________________________________________
			End case 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			$references:=New collection:C1472
			ARRAY TO COLLECTION:C1563($references; $nodes)
			
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Search for an element by its name and create it if it is not found
Function findOrCreate($target : Text; $value : Text)->$reference : Text
	
	var $c : Collection
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470.isReference($target))
			
			If (This:C1470._requiredParams(Count parameters:C259; 2))
				
				$c:=This:C1470.findByName($target; $value)
				
				If (This:C1470.success)
					
					$reference:=$c[0]
					
				Else 
					
					// Create
					$reference:=DOM Create XML element:C865($target; $value)
					
				End if 
			End if 
			
		Else 
			
			$c:=This:C1470.findByName($target)
			
			If (This:C1470.success)
				
				$reference:=$c[0]
				
			Else 
				
				// Create
				$reference:=DOM Create XML element:C865(This:C1470.root; $target)
				
			End if 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a reference to the parent of a node
	// If a name is passed, goes up in the hierarchy to find the named element
Function parent($node : Text; $name : Text)->$reference : Text
	
	var $elementName : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			$reference:=DOM Get parent XML element:C923($node; $elementName)
			
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Count parameters:C259>=2)
					
					If ($elementName#$name)
						
						Repeat 
							
							$reference:=DOM Get parent XML element:C923($reference; $elementName)
							
						Until (OK=0)\
							 | ($elementName=$name)
						
						This:C1470.success:=($elementName=$name)
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a reference to the first “child”
	// If the node's reference isn't passed, return the first child of the root
	// If a name is passed, looks for the first child with that name
Function firstChild($node : Text; $name : Text)->$reference : Text
	
	var $elementName : Text
	
	If (Count parameters:C259>=1)
		
		If (This:C1470._requiredRef($node))
			
			$reference:=DOM Get first child XML element:C723($node; $elementName)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Count parameters:C259>=2)
					
					If ($elementName#$name)
						
						Repeat 
							
							$reference:=DOM Get next sibling XML element:C724($reference; $elementName)
							
						Until (OK=0)\
							 | ($elementName=$name)
						
						This:C1470.success:=($elementName=$name)
						
					End if 
				End if 
			End if 
		End if 
		
	Else 
		
		$reference:=DOM Get first child XML element:C723(This:C1470.root)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a reference to the last “child”
	// If the node's reference isn't passed, return the last child of the root
	// If a name is passed, looks for the last child with that name
Function lastChild($node : Text; $name : Text)->$reference : Text
	
	var $elementName : Text
	
	If (Count parameters:C259>=1)
		
		If (This:C1470._requiredRef($node))
			
			$reference:=DOM Get last child XML element:C925($node; $elementName)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Count parameters:C259>=2)
					
					If ($elementName#$name)
						
						Repeat 
							
							$reference:=DOM Get previous sibling XML element:C924($reference; $elementName)
							
						Until (OK=0)\
							 | ($elementName=$name)
						
						This:C1470.success:=($elementName=$name)
						
					End if 
				End if 
			End if 
		End if 
		
	Else 
		
		$reference:=DOM Get last child XML element:C925(This:C1470.root)
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns the list of the childs' references of a node or root if ref is omitted
Function childrens($node : Text)->$childs : Collection
	
	ARRAY TEXT:C222($nodes; 0)
	
	If (Count parameters:C259>=1)
		
		If (This:C1470._requiredRef($node))
			
			$nodes{0}:=$node
			
		End if 
	End if 
	
	If (Length:C16($nodes{0})=0)
		
		$nodes{0}:=This:C1470.root
		
	End if 
	
	$nodes{0}:=DOM Find XML element:C864($nodes{0}; "*"; $nodes)
	
	$childs:=New collection:C1472
	ARRAY TO COLLECTION:C1563($childs; $nodes)
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns the list of the descendant' references of a node or root if ref is omitted
Function descendants($node : Text)->$descendants : Collection
	
	var $i : Integer
	
	$descendants:=New collection:C1472
	
	ARRAY LONGINT:C221($types; 0)
	ARRAY TEXT:C222($nodes; 0)
	
	If (Count parameters:C259>=1)
		
		If (This:C1470._requiredRef($node))
			
			DOM GET XML CHILD NODES:C1081($node; $types; $nodes)
			
		End if 
		
	Else 
		
		DOM GET XML CHILD NODES:C1081(This:C1470.root; $types; $nodes)
		
	End if 
	
	For ($i; 1; Size of array:C274($types); 1)
		
		If ($types{$i}=XML ELEMENT:K45:20)
			
			$descendants.push($nodes{$i})
			$descendants.combine(This:C1470.descendants($nodes{$i}))
			
		End if 
	End for 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a reference to the next “sibling”
	// If a name is passed, looks for the first sibling with that name
Function nextSibling($node : Text; $name : Text)->$reference : Text
	
	var $elementName : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			$reference:=DOM Get next sibling XML element:C724($node; $elementName)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Count parameters:C259>=2)
					
					If ($elementName#$name)
						
						Repeat 
							
							$reference:=DOM Get next sibling XML element:C724($reference; $elementName)
							
						Until (OK=0)\
							 | ($elementName=$name)
						
						This:C1470.success:=($elementName=$name)
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a reference to the previous “sibling”
	// If a name is passed, looks for the first sibling with that name
Function previousSibling($node : Text; $name : Text)->$reference : Text
	
	var $elementName : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			$reference:=DOM Get previous sibling XML element:C924($node; $elementName)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Count parameters:C259>=2)
					
					If ($elementName#$name)
						
						Repeat 
							
							$reference:=DOM Get previous sibling XML element:C924($reference; $elementName)
							
						Until (OK=0)\
							 | ($elementName=$name)
						
						This:C1470.success:=($elementName=$name)
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns the name of the element set by $node
Function getName($node : Text)->$name : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			DOM GET XML ELEMENT NAME:C730($node; $name)
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Modifies the name of the element set by $node
Function setName($node : Text; $name : Text) : cs:C1710.xml
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		If (This:C1470._requiredRef($node))
			
			DOM SET XML ELEMENT NAME:C867($node; $name)
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
	End if 
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Removes the element set by $node
Function remove($node : Text) : cs:C1710.xml
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			DOM REMOVE XML ELEMENT:C869($node)
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
	End if 
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns the value of the XML element designated by $node
Function getValue($node : Text)->$value
	
	var $CDATA; $elementValue : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470._requiredRef($node))
			
			DOM GET XML ELEMENT VALUE:C731($node; $elementValue; $CDATA)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Length:C16($elementValue)=0)
					
					// Try CDATA
					$value:=This:C1470._convert($CDATA)
					
				Else 
					
					$value:=This:C1470._convert($elementValue)
					
				End if 
			End if 
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns one node attribute value if exists
Function getAttribute($node : Text; $attribute : Text)->$value
	
	var $o : Object
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		$o:=OB Entries:C1720(This:C1470.getAttributes($node)).query("key = :1"; $attribute).pop()
		This:C1470.success:=($o#Null:C1517)
		
		If (This:C1470.success)
			
			$value:=$o.value
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Attribute \""+$attribute+"\" not found")
			
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// If exists, returns an attribute value & remove it
Function popAttribute($node : Text; $attribute : Text)->$value
	
	var $o : Object
	
	If (This:C1470._requiredParams(Count parameters:C259; 2))
		
		$o:=OB Entries:C1720(This:C1470.getAttributes($node)).query("key = :1"; $attribute).pop()
		This:C1470.success:=($o#Null:C1517)
		
		If (This:C1470.success)
			
			$value:=$o.value
			
			DOM REMOVE XML ATTRIBUTE:C1084($node; $attribute)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Attribute \""+$attribute+"\" not found")
			
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a node attributes as object
Function getAttributes($node : Text)->$attributes : Object
	
	var $key; $nodeƒ; $value : Text
	var $i : Integer
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470.isReference($node))
			
			$nodeƒ:=$node
			
		Else 
			
			// It is assumed to be an XPath
			$nodeƒ:=This:C1470.findByXPath($node)
			
		End if 
		
		If (This:C1470._requiredRef($nodeƒ))
			
			$attributes:=New object:C1471
			
			For ($i; 1; DOM Count XML attributes:C727($nodeƒ); 1)
				
				DOM GET XML ATTRIBUTE BY INDEX:C729($nodeƒ; $i; $key; $value)
				
				$attributes[$key]:=This:C1470._convert($value)
				
			End for 
		End if 
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Returns a node attributes as collection
Function getAttributesCollection($node : Text)->$attributes : Collection
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$attributes:=OB Entries:C1720(This:C1470.getAttributes($node))
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Set a node attribute
Function setAttribute($node : Text; $name : Text; $value) : cs:C1710.xml
	
	If (This:C1470._requiredParams(Count parameters:C259; 3))
		
		If (This:C1470._requiredRef($node))
			
			Case of 
					//______________________________________________________
				: (Value type:C1509($value)=Is collection:K8:32)\
					 | (Value type:C1509($value)=Is object:K8:27)
					
					DOM SET XML ATTRIBUTE:C866($node; $name; JSON Stringify:C1217($value))
					
					//______________________________________________________
				Else 
					
					DOM SET XML ATTRIBUTE:C866($node; $name; $value)
					
					//______________________________________________________
			End case 
			
			
			This:C1470.success:=Bool:C1537(OK)
			
		End if 
	End if 
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Set a node attributes from an object or a collection (key/value pairs)
Function setAttributes($node : Text; $attributes; $value) : cs:C1710.xml
	
	var $t : Text
	var $o : Object
	var $val
	
	If (This:C1470._requiredParams(Count parameters:C259; 2)) && (This:C1470._requiredRef($node))
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($attributes)=Is text:K8:3)
				
				If (This:C1470._requiredParams(Count parameters:C259; 3))
					
					This:C1470.setAttribute($node; $attributes; $value)
					
				End if 
				
				//______________________________________________________
			: (Value type:C1509($attributes)=Is object:K8:27)
				
				For each ($t; $attributes) While (This:C1470.success)
					
					$val:=$attributes[$t]
					DOM SET XML ATTRIBUTE:C866($node; $t; $val)
					
					This:C1470.success:=Bool:C1537(OK)
					
					If (Not:C34(This:C1470.success))
						
						This:C1470.errors.push(Current method name:C684+" -  Failed to set attribute \""+$t+"\"")
						break
						
					End if 
				End for each 
				
				//______________________________________________________
			: (Value type:C1509($attributes)=Is collection:K8:32)
				
				For each ($o; $attributes) While (This:C1470.success)
					
					If (Value type:C1509($o.value)=Is object:K8:27)\
						 | (Value type:C1509($o.value)=Is collection:K8:32)
						
						DOM SET XML ATTRIBUTE:C866($node; String:C10($o.key); JSON Stringify:C1217($o.value))
						
					Else 
						
						$val:=$o.value
						DOM SET XML ATTRIBUTE:C866($node; String:C10($o.key); $val)
						
					End if 
					
					This:C1470.success:=Bool:C1537(OK)
					
					If (Not:C34(This:C1470.success))
						
						This:C1470.errors.push(Current method name:C684+" -  Failed to set attribute \""+String:C10($o.key)+"\"")
						break
						
					End if 
				End for each 
				
				//______________________________________________________
			Else 
				
				This:C1470.success:=False:C215
				This:C1470.errors.push(Current method name:C684+" -  Unmanaged type: "+String:C10(Value type:C1509($node)))
				
				//______________________________________________________
		End case 
	End if 
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Removes, if it exists, the attribute designated by $name from the XML $node
Function removeAttribute($node : Text; $attribute : Text) : cs:C1710.xml
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			If (OB Entries:C1720(This:C1470.getAttributes($node)).query("key=:1"; $attribute).pop()#Null:C1517)
				
				DOM REMOVE XML ATTRIBUTE:C1084($node; $attribute)
				
			End if 
			
		Else 
			
			If (OB Entries:C1720(This:C1470.getAttributes(This:C1470.root)).query("key=:1"; $attribute).pop()#Null:C1517)
				
				DOM REMOVE XML ATTRIBUTE:C1084($node; $attribute)
				
			End if 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Modifies the value of the element set by $node
Function setValue($node : Text; $value : Variant; $inCDATA : Boolean) : cs:C1710.xml
	
	If (Count parameters:C259=3)
		
		If ($inCDATA)
			
			DOM SET XML ELEMENT VALUE:C868($node; $value; *)
			
		Else 
			
			DOM SET XML ELEMENT VALUE:C868($node; $value)
			
		End if 
		
	Else 
		
		DOM SET XML ELEMENT VALUE:C868($node; $value)
		
	End if 
	
	This:C1470.success:=Bool:C1537(OK)
	
	return This:C1470
	
	// —————————————————————————————————————————————————————————————————————————————————
Function isNull($reference : Text) : Boolean
	
	return Match regex:C1019("0{32}"; $reference; 1)
	
	// —————————————————————————————————————————————————————————————————————————————————
Function isNotNull($reference : Text) : Boolean
	
	return Not:C34(This:C1470.isNull($reference))
	
	// —————————————————————————————————————————————————————————————————————————————————
	// Tests if the passed text is compliant with a XML reference
Function isReference($text : Text) : Boolean
	
	return Match regex:C1019("[[:xdigit:]]{32}"; $text; 1)
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _requiredRef($reference : Text) : Boolean
	
	This:C1470.success:=Match regex:C1019("[[:xdigit:]]{32}"; $reference; 1)
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid XML element reference")
		return 
		
	End if 
	
	return This:C1470.success
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _requiredParams($count; $number) : Boolean
	
	This:C1470.success:=$count>=$number
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Missing one or more parameters")
		
	End if 
	
	return This:C1470.success
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _convert($textValue : Text)->$value
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^\\[.*\\]$"; $textValue; 1; *))
			
			$value:=JSON Parse:C1218($textValue)
			
			//______________________________________________________
		: (Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$"; $textValue; 1; *))
			
			$value:=($textValue="true")
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.\\d+)?$"; $textValue; 1; *))
			
			$value:=Num:C11($textValue; ".")
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)^\\d+-\\d+-\\d+$"; $textValue; 1; *))
			
			$value:=Date:C102($textValue+"T00:00:00")
			
			//______________________________________________________
		Else 
			
			$value:=$textValue
			
			//______________________________________________________
	End case 
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _close($keepOpened : Boolean)
	
	If (This:C1470.autoClose)
		
		If (Count parameters:C259>=1)
			
			If (Not:C34($keepOpened))
				
				This:C1470.close()
				
			Else 
				
				// ⚠️ XML tree is not closed
				
			End if 
			
		Else 
			
			This:C1470.close()
			
		End if 
		
	Else 
		
		// ⚠️ XML tree is not closed
		
	End if 
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _pushError($description : Text)
	
	This:C1470.success:=False:C215
	This:C1470.errors.push(Get call chain:C1662[1].name+" - "+$description)
	
	//———————————————————————————————————————————————————————————
Function _reset
	
	This:C1470.close()
	
	This:C1470.file:=Null:C1517
	This:C1470.xml:=Null:C1517
	
	This:C1470.autoClose:=True:C214
	
	This:C1470.errors:=New collection:C1472
	
	// —————————————————————————————————————————————————————————————————————————————————
Function _elementToObject($ref : Text; $withAdresses : Boolean)->$object : Object
	
	var $node; $key; $name; $tValue : Text
	var $count; $i : Integer
	
	$object:=New object:C1471
	
	// DOM reference
	If ($withAdresses)
		
		$object["@"]:=$ref
		
	End if 
	
	// Attributes
	For ($i; 1; DOM Count XML attributes:C727($ref); 1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($ref; $i; $key; $tValue)
		
		Case of   // Value types
				
				//______________________________________________________
			: (Length:C16($key)=0)
				
				// Skip malformed node
				
				//______________________________________________________
			: (Match regex:C1019("(?m-si)^\\d+\\.*\\d*$"; $tValue; 1))  // Numeric
				
				$object[$key]:=Num:C11($tValue; ".")
				
				//______________________________________________________
			: (Match regex:C1019("(?mi-s)^true|false$"; $tValue; 1))  // Boolean
				
				$object[$key]:=($tValue="true")
				
				//______________________________________________________
			Else   // Text
				
				$object[$key]:=$tValue
				
				//______________________________________________________
		End case 
	End for 
	
	// Value
	DOM GET XML ELEMENT VALUE:C731($ref; $tValue)
	
	If (Match regex:C1019("[^\\s]+"; $tValue; 1))
		
		$object["$"]:=$tValue
		
	End if 
	
	// Childs
	$node:=DOM Get first child XML element:C723($ref; $name)
	
	If (OK=1)
		
		// Many one?
		$count:=DOM Count XML elements:C726($ref; $name)
		
		If ($count>1)
			
			$object[$name]:=New collection:C1472
			
			For ($i; 1; $count; 1)
				
				$object[$name].push(This:C1470._elementToObject(DOM Get XML element:C725($ref; $name; $i); $withAdresses))
				
			End for 
			
		Else 
			
			$object[$name]:=This:C1470._elementToObject($node; $withAdresses)
			
		End if 
		
		// Next one
		$node:=DOM Get next sibling XML element:C724($node; $name)
		
		While (OK=1)
			
			// Already treated?
			If ($object[$name]=Null:C1517)
				
				// Many one?
				$count:=DOM Count XML elements:C726($ref; $name)
				
				If ($count>1)
					
					$object[$name]:=New collection:C1472
					
					For ($i; 1; $count; 1)
						
						$object[$name].push(This:C1470._elementToObject(DOM Get XML element:C725($ref; $name; $i); $withAdresses))
						
					End for 
					
				Else 
					
					$object[$name]:=This:C1470._elementToObject($node; $withAdresses)
					
				End if 
			End if 
			
			// Next one
			$node:=DOM Get next sibling XML element:C724($node; $name)
			
		End while 
	End if 
	