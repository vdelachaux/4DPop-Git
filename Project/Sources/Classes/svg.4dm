Class extends xml

Class constructor($content)
	
	If (Count parameters:C259>=1)
		
		Super:C1705($content)
		
	Else 
		
		Super:C1705()
		
		// Create an empty canvas
		This:C1470.new()
		
	End if 
	
	This:C1470.latest:=Null:C1517
	This:C1470.graphic:=Null:C1517
	This:C1470.store:=New collection:C1472
	
	This:C1470._notContainer:=New collection:C1472("rect"; "line"; "image"; "circle"; "ellipse"; "path"; "polygon"; "polyline"; "use"; "textArea")
	This:C1470._aspectRatioValues:=New collection:C1472("none"; "xMinYMin"; "xMidYMin"; "xMaxYMin"; "xMinYMid"; "xMidYMid"; "xMaxYMid"; "xMinYMax"; "xMidYMax"; "xMaxYMax")
	This:C1470._textRenderingValue:=New collection:C1472("auto"; "optimizeSpeed"; "optimizeLegibility"; "geometricPrecision"; "inherit")
	
	This:C1470._reservedNames:=New collection:C1472("root"; "latest"; "parent")
	This:C1470._reservedNames:=This:C1470._reservedNames.combine(This:C1470._aspectRatioValues)
	This:C1470._reservedNames:=This:C1470._reservedNames.combine(This:C1470._textRenderingValue)
	
/*================================================================
                  DOCUMENTS & STRUCTURE
================================================================*/
	
	//———————————————————————————————————————————————————————————
	// Close the current tree if any & create a new svg default structure.
	// ⚠️ Overrides the method of the inherited class
Function new($attributes : Object)->$this : cs:C1710.svg
	
	var $root; $t : Text
	
	This:C1470._reset()
	
	$root:=DOM Create XML Ref:C861("svg"; "http://www.w3.org/2000/svg")
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.root:=$root
		
		DOM SET XML ATTRIBUTE:C866($root; "xmlns:xlink"; "http://www.w3.org/1999/xlink")
		
		DOM SET XML DECLARATION:C859($root; "UTF-8"; True:C214)
		XML SET OPTIONS:C1090($root; XML indentation:K45:34; Choose:C955(Is compiled mode:C492; XML no indentation:K45:36; XML with indentation:K45:35))
		
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			// Default values
			DOM SET XML ATTRIBUTE:C866(This:C1470.root; \
				"viewport-fill"; "none"; \
				"fill"; "none"; \
				"stroke"; "black"; \
				"font-family"; "'lucida grande','segoe UI',sans-serif"; \
				"font-size"; 12; \
				"text-rendering"; "geometricPrecision"; \
				"shape-rendering"; "crispEdges"; \
				"preserveAspectRatio"; "none")
			
		End if 
	End if 
	
	If (Bool:C1537(OK) & (This:C1470.root#Null:C1517))
		
		If (Count parameters:C259>=1)
			
			If ($attributes#Null:C1517)
				
				For each ($t; $attributes)
					
					Case of 
							
							//_______________________
						: ($t="keepReference")
							
							This:C1470.autoClose:=Bool:C1537($attributes[$t])
							
							//_______________________
						Else 
							
							DOM SET XML ATTRIBUTE:C866(This:C1470.root; \
								$t; $attributes[$t])
							
							//______________________
					End case 
				End for each 
				
			Else 
				
				// <NOTHING MORE TO DO>
				
			End if 
			
		Else 
			
			// <NOTHING MORE TO DO>
			
		End if 
		
	Else 
		
		This:C1470._pushError("Failed to create SVG structure.")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Returns the picture described by the SVG structure
Function picture($exportType : Variant; $keepStructure : Boolean)->$picture : Picture
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259>=2)  // $exportType & $keepStructure
			
			SVG EXPORT TO PICTURE:C1017(This:C1470.root; $picture; Num:C11($exportType))
			
			If (This:C1470.autoClose)\
				 & (Not:C34($keepStructure))
				
				This:C1470.close()
				
			End if 
			
			//______________________________________________________
		: (Count parameters:C259>=1)  // $exportType | $keepStructure
			
			If (Value type:C1509($exportType)=Is boolean:K8:9)  // $keepStructure
				
				SVG EXPORT TO PICTURE:C1017(This:C1470.root; $picture; Copy XML data source:K45:17)
				
				If (This:C1470.autoClose)\
					 & (Not:C34($exportType))
					
					This:C1470.close()
					
				End if 
				
			Else   // $exportType
				
				SVG EXPORT TO PICTURE:C1017(This:C1470.root; $picture; Num:C11($exportType))
				
				If (This:C1470.autoClose)
					
					This:C1470.close()
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			SVG EXPORT TO PICTURE:C1017(This:C1470.root; $picture; Copy XML data source:K45:17)
			
			If (This:C1470.autoClose)
				
				This:C1470.close()
				
			End if 
			
			//______________________________________________________
	End case 
	
	If (Picture size:C356($picture)>0)
		
		This:C1470.graphic:=$picture
		
	Else 
		
		This:C1470._pushError("Failed to convert SVG structure as picture.")
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Writes the content of the SVG tree into a disk file
Function exportText($file : 4D:C1709.file; $keepStructure : Boolean)->$this : cs:C1710.xml
	
	If (Count parameters:C259=2)
		
		Super:C1706.save($file; $keepStructure)
		
	Else 
		
		Super:C1706.save($file)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Writes the contents of the SVG tree into a picture file
Function exportPicture($file : 4D:C1709.file; $keepStructure : Boolean)->$this : cs:C1710.xml
	
	var $picture : Picture
	
	If (Count parameters:C259=2)
		
		$picture:=This:C1470.picture($keepStructure)
		
	Else 
		
		// Auto
		$picture:=This:C1470.picture()
		
	End if 
	
	If (This:C1470.success)
		
		WRITE PICTURE FILE:C680($file.platformPath; $picture; $file.extension)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function group($id : Text; $attachTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		This:C1470.latest:=Super:C1706.create(This:C1470._getContainer($attachTo); "g")
		
	Else 
		
		// Auto
		This:C1470.latest:=Super:C1706.create(This:C1470._getContainer(); "g")
		
	End if 
	
	If (Count parameters:C259>=1)
		
		Super:C1706.setAttribute(This:C1470.latest; "id"; $id)
		This:C1470.push($id)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Store the last created element as symbol
Function symbol($name : Text; $applyTo)->$this : cs:C1710.svg
	
	var $defs; $node; $source; $symbol : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$defs:=This:C1470._defs()
		
		If (This:C1470.success)
			
			$symbol:=Super:C1706.create($defs; "symbol")
			
			If (This:C1470.success)
				
				Super:C1706.setAttribute($symbol; "id"; $name)
				
				If (This:C1470.success)
					
					If (Count parameters:C259>=2)
						
						$source:=This:C1470._getTarget($applyTo)
						
					Else 
						
						// Auto
						$source:=This:C1470._getTarget()
						
					End if 
					
					This:C1470.store.push(New object:C1471(\
						"id"; $name; \
						"dom"; $symbol))
					
					Super:C1706.setAttribute($symbol; "preserveAspectRatio"; "xMidYMid")
					
					$node:=Super:C1706.clone($source; $symbol)
					This:C1470.remove($source)
					
				End if 
				
			Else 
				
				This:C1470._pushError("Failed to create the symbol: "+$name)
				
			End if 
			
		Else 
			
			This:C1470._pushError("Failed to locate/create the \"defs\" element")
			
		End if 
	End if 
	
	// Restore the target preceding the creation of the symbol
	This:C1470.latest:=Choose:C955(This:C1470._current=Null:C1517; This:C1470.root; This:C1470._current)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Place an occurence of the symbol
Function use($symbol; $attachTo)->$this : cs:C1710.svg
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (This:C1470.isNotNull(This:C1470.findById($symbol)))
			
			If (Count parameters:C259>=2)
				
				This:C1470.latest:=Super:C1706.create(This:C1470._getContainer($attachTo); "use")
				
			Else 
				
				// Auto
				This:C1470.latest:=Super:C1706.create(This:C1470._getContainer(); "use")
				
			End if 
			
			If (This:C1470.success)
				
				Super:C1706.setAttribute(This:C1470.latest; "xlink:href"; $symbol)
				
			End if 
			
		Else 
			
			This:C1470._pushError("The id \""+$symbol+"\" doesn't exist!")
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Attach a style sheet
Function styleSheet($file : 4D:C1709.File)->$this : cs:C1710.svg
	
	var $t : Text
	
	If (OB Instance of:C1731($file; 4D:C1709.File))
		
		If ($file.exists)
			
			$t:="xml-stylesheet href=\"file:///"+Convert path system to POSIX:C1106($file.platformPath; *)+"\" type=\"text/css\""
			$t:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088(This:C1470.root); XML processing instruction:K45:9; $t)
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470._pushError("File not found: "+$file.path)
			
		End if 
		
	Else 
		
		This:C1470._pushError("$1 must be a 4D File")
		
	End if 
	
	$this:=This:C1470
	
/*================================================================
                       DRAWING
================================================================*/
	
	//———————————————————————————————————————————————————————————
Function rect($height : Real; $width : Variant; $attachTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $breadth : Real
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		$breadth:=$height  // Square by default
		
		Case of 
				
				//…………………………………………………………………………………………
			: ($paramNumber=1)
				
				$node:=This:C1470._getContainer()
				
				//…………………………………………………………………………………………
			: ($paramNumber=2)
				
				If (Value type:C1509($width)=Is real:K8:4)\
					 | (Value type:C1509($width)=Is longint:K8:6)
					
					$breadth:=$width
					$node:=This:C1470._getContainer()
					
				Else 
					
					$node:=This:C1470._getContainer($width)
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=3)
				
				$node:=This:C1470._getContainer($attachTo)
				$breadth:=$width
				
				//…………………………………………………………………………………………
		End case 
		
		This:C1470.latest:=Super:C1706.create($node; "rect"; New object:C1471(\
			"width"; $height; \
			"height"; $breadth))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function square($side : Real; $attachTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259=2)
		
		This:C1470.rect($side; This:C1470._getContainer($attachTo))
		
	Else 
		
		This:C1470.rect($side; This:C1470._getContainer())
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function circle($r : Real; $cx : Real; $cy : Real; $attachTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $x; $y : Real
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		Case of 
				
				//…………………………………………………………………………………………
			: ($paramNumber=1)
				
				$node:=This:C1470._getContainer()
				
				//…………………………………………………………………………………………
			: ($paramNumber=2)
				
				If (Value type:C1509($cx)=Is real:K8:4)\
					 | (Value type:C1509($cx)=Is longint:K8:6)
					
					$node:=This:C1470._getContainer()
					$x:=$cx
					$y:=$x
					
				Else 
					
					$node:=This:C1470._getContainer($cx)
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=3)
				
				$x:=$cx
				
				If (Value type:C1509($cy)=Is real:K8:4)
					
					$node:=This:C1470._getContainer()
					$y:=$cy
					
				Else 
					
					$node:=This:C1470._getContainer($cy)
					$y:=$x
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=4)
				
				$node:=This:C1470._getContainer($attachTo)
				$x:=$cx
				$y:=$cy
				
				//…………………………………………………………………………………………
		End case 
		
		This:C1470.latest:=Super:C1706.create($node; "circle"; New object:C1471(\
			"r"; $r; \
			"cx"; $x; \
			"cy"; $y))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function ellipse($rx : Real; $ry : Real; $cx : Real; $cy : Real; $attachTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $x; $y; $yR : Real
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		$yR:=$rx  // Circle
		
		Case of 
				
				//…………………………………………………………………………………………
			: ($paramNumber=1)
				
				$node:=This:C1470._getContainer()
				
				//…………………………………………………………………………………………
			: ($paramNumber=2)
				
				If (Value type:C1509($ry)=Is real:K8:4)\
					 | (Value type:C1509($ry)=Is longint:K8:6)
					
					$yR:=$ry
					$node:=This:C1470._getContainer()
					
				Else 
					
					$node:=This:C1470._getContainer($ry)
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=3)
				
				$yR:=$ry
				
				If (Value type:C1509($cx)=Is real:K8:4)
					
					$x:=$cx
					$y:=$cx
					$node:=This:C1470._getContainer()
					
				Else 
					
					$node:=This:C1470._getContainer($cy)
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=4)
				
				$yR:=$ry
				$x:=$cx
				$y:=$cx
				
				If (Value type:C1509($cy)=Is real:K8:4)\
					 | (Value type:C1509($cy)=Is longint:K8:6)
					
					$y:=$cy
					$node:=This:C1470._getContainer()
					
				Else 
					
					$node:=This:C1470._getContainer($cy)
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=5)
				
				$yR:=$ry
				$x:=$cx
				$y:=$cy
				
				$node:=This:C1470._getContainer($attachTo)
				
				//…………………………………………………………………………………………
		End case 
		
		This:C1470.latest:=Super:C1706.create($node; "ellipse"; New object:C1471(\
			"cx"; $x; \
			"cy"; $y; \
			"rx"; $rx; \
			"ry"; $yR))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function line($x1 : Real; $y1 : Real; $x2 : Real; $y2 : Real; $attachTo)->$this : cs:C1710.svg
	
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 4))
		
		If ($paramNumber=5)
			
			This:C1470.latest:=Super:C1706.create(This:C1470._getContainer($attachTo); "line"; New object:C1471(\
				"x1"; $x1; \
				"y1"; $y1; \
				"x2"; $x2; \
				"y2"; $y2))
			
		Else 
			
			// Auto
			This:C1470.latest:=Super:C1706.create(This:C1470._getContainer(); "line"; New object:C1471(\
				"x1"; $x1; \
				"y1"; $y1; \
				"x2"; $x2; \
				"y2"; $y2))
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function image($picture : Variant; $attachTo)->$this : cs:C1710.svg
	
	var $node; $t : Text
	var $p : Picture
	var $height; $paramNumber; $width : Integer
	var $x : Blob
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If ($paramNumber=2)
			
			$node:=This:C1470._getContainer($attachTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getContainer()
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($picture)=Is picture:K8:10)  // Embedded
				
				If (Picture size:C356($picture)>0)
					
					// Encode in base64
					PICTURE TO BLOB:C692($picture; $x; ".png")
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						BASE64 ENCODE:C895($x; $t)
						CLEAR VARIABLE:C89($x)
						
						// Put the encoded image
						PICTURE PROPERTIES:C457($picture; $width; $height)
						
						If ($paramNumber=2)
							
							$node:=This:C1470._getContainer($attachTo)
							
						Else 
							
							// Auto
							$node:=This:C1470._getContainer()
							
						End if 
						
						This:C1470.latest:=Super:C1706.create($node; "image"; New object:C1471(\
							"xlink:href"; "data:;base64,"+$t; \
							"x"; 0; \
							"y"; 0; \
							"width"; $width; \
							"height"; $height))
						
					End if 
					
				Else 
					
					This:C1470._pushError("Given picture is empty")
					
				End if 
				
				//______________________________________________________
			: (Value type:C1509($picture)=Is object:K8:27)  // Url
				
				If (OB Instance of:C1731($picture; 4D:C1709.File))
					
					If (Bool:C1537($picture.exists))
						
						// Unsandboxed, if any
						$picture:=File:C1566(File:C1566($picture.path).platformPath; fk platform path:K87:2)
						
						READ PICTURE FILE:C678($picture.platformPath; $p)
						
						If (Bool:C1537(OK))
							
							PICTURE PROPERTIES:C457($p; $width; $height)
							CLEAR VARIABLE:C89($p)
							
							If ($paramNumber=2)
								
								$node:=This:C1470._getContainer($attachTo)
								
							Else 
								
								// Auto
								$node:=This:C1470._getContainer()
								
							End if 
							
							This:C1470.latest:=Super:C1706.create($node; "image"; New object:C1471(\
								"xlink:href"; "file://"+Choose:C955(Is Windows:C1573; "/"; "")+Replace string:C233($picture.path; " "; "%20"); \
								"x"; 0; \
								"y"; 0; \
								"width"; $width; \
								"height"; $height))
							
							If (Not:C34(This:C1470.success))
								
								This:C1470._pushError("Failed to create image \""+String:C10($picture.path)+"\"")
								
							End if 
							
						Else 
							
							This:C1470._pushError("Failed to read image \""+String:C10($picture.path)+"\"")
							
						End if 
						
					Else 
						
						This:C1470._pushError("File not found \""+String:C10($picture.path)+"\"")
						
					End if 
					
				Else 
					
					This:C1470._pushError("Picture must be a picture file.")
					
				End if 
				
				//______________________________________________________
			Else 
				
				This:C1470._pushError("Picture must be a picture variable ou a picture file.")
				
				//______________________________________________________
		End case 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function text($text : Text; $attachTo)->$this : cs:C1710.svg
	
	var $node; $line : Text
	var $o : Object
	var $y : Real
	var $defaultFontSize : Integer
	var $c : Collection
	
	$defaultFontSize:=12
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259=2)
			
			$node:=This:C1470._getContainer($attachTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getContainer()
			
		End if 
		
		$y:=$defaultFontSize
		
		$o:=New object:C1471(\
			"x"; 0; \
			"y"; $y)
		
		This:C1470.latest:=Super:C1706.create($node; "text"; $o)
		
		If (This:C1470.success)\
			 & (Length:C16($text)>0)
			
			$text:=Replace string:C233($text; "\r\n"; "\n")
			$text:=Replace string:C233($text; "\n"; "\r")
			
			$c:=Split string:C1554($text; "\r")
			
			If ($c.length=1)
				
				This:C1470.setValue($text)
				
			Else 
				
				// #WIP
				For each ($line; $c) While (This:C1470.success)
					
					$node:=Super:C1706.create(This:C1470.latest; "tspan"; $o)
					Super:C1706.setValue($node; $line)
					$o.y:=$o.y+$defaultFontSize
					
				End for each 
			End if 
		End if 
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function textArea($text : Text; $attachTo)->$this : cs:C1710.svg
	
	var $node; $line : Text
	var $i : Integer
	var $o : Object
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		$o:=New object:C1471(\
			"x"; 0; \
			"y"; 0; \
			"width"; "auto"; \
			"height"; "auto")
		
		If ($paramNumber=2)
			
			$node:=This:C1470._getContainer($attachTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getContainer()
			
		End if 
		
		This:C1470.latest:=Super:C1706.create($node; "textArea"; $o)
		
		If (This:C1470.success)\
			 & (Length:C16($text)>0)
			
			$text:=Replace string:C233($text; "\r\n"; "\n")
			$text:=Replace string:C233($text; "\n"; "\r")
			
			For each ($line; Split string:C1554($text; "\r")) While (This:C1470.success)
				
				If ($i=0)
					
					This:C1470.setValue($line)
					
				Else 
					
					$node:=DOM Create XML element:C865(This:C1470.latest; "tbreak")
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)\
						 & (Length:C16($line)>0)
						
						$node:=DOM Append XML child node:C1080(This:C1470.latest; XML DATA:K45:12; $line)
						This:C1470.success:=Bool:C1537(OK)
						
					End if 
				End if 
				
				$i:=$i+1
				
			End for each 
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Creates a set of connected straight line segments,
	// generally resulting in an open shape usually without fill
Function polyline($points : Variant; $attachTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If ($paramNumber>=2)
		
		$node:=This:C1470._getContainer($attachTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getContainer()
		
	End if 
	
	This:C1470.latest:=Super:C1706.create($node; "polyline")
	
	If (This:C1470.success)
		
		Super:C1706.setAttribute(This:C1470.latest; "fill"; "none")
		
		If ($paramNumber>=1)
			
			This:C1470.plot($points; This:C1470.latest)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Defines a closed shape consisting of connected lines.
Function polygon($points : Variant; $attachTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If ($paramNumber>=2)
		
		$node:=This:C1470._getContainer($attachTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getContainer()
		
	End if 
	
	This:C1470.latest:=Super:C1706.create($node; "polygon")
	
	If (This:C1470.success)
		
		If ($paramNumber>=1)
			
			This:C1470.plot($points; This:C1470.latest)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Defines a new path element.
Function path($data : Variant; $attachTo)->$this : cs:C1710.svg
	
	//#TO_DO
	
	//———————————————————————————————————————————————————————————
	// Populate the "points" property of a polyline, polygon
Function points($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	var $data; $node; $element : Text
	var $i; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If ($paramNumber>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="polyline")\
			 | ($element="polygon")
			
			Case of 
					//______________________________________________________
				: (Value type:C1509($points)=Is collection:K8:32)
					
					For ($i; 0; $points.length-1; 1)
						
						$points[$i]:=$points[$i].join(",")
						
					End for 
					
					$data:=$points.join(" ")
					
					//______________________________________________________
				: (Value type:C1509($points)=Is text:K8:3)
					
					$data:=$points
					
					//______________________________________________________
				Else 
					
					// #ERROR
					
					//______________________________________________________
			End case 
			
			If (Length:C16($data)>0)
				
				Super:C1706.setAttribute($node; "points"; $data)
				
			Else 
				
				This:C1470._pushError("Points must be passed as string or collection")
				
			End if 
			
			//…………………………………………………………………………………………………
		Else 
			
			This:C1470._pushError("The element \""+$element+"\" is not compatible withe \"points\" property")
			
			//…………………………………………………………………………………………………
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Absolute moveTo
Function M($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	var $data; $element; $node : Text
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If ($paramNumber>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($element="polyline")\
				 | ($element="polygon")
				
				Case of 
						//______________________________________________________
					: (Value type:C1509($points)=Is collection:K8:32)
						
						$data:=String:C10($points[0]; "&xml")+","+String:C10($points[1]; "&xml")
						
						//______________________________________________________
					: (Value type:C1509($points)=Is text:K8:3)
						
						$data:=$points
						
						//______________________________________________________
					Else 
						
						// #ERROR
						
						//______________________________________________________
				End case 
				
				If (Length:C16($data)>0)
					
					Super:C1706.setAttribute($node; "points"; $data)
					
				Else 
					
					This:C1470._pushError("For a "+$element+", points must be passed as string or collection")
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($element="path")
				
				// #TO_DO
				
				//…………………………………………………………………………………………………
			Else 
				
				This:C1470._pushError("The element \""+$element+"\" is not compatible withe \"points\" property")
				
				//…………………………………………………………………………………………………
		End case 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Absolute lineTo
Function L($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	var $data; $name; $node; $element : Text
	var $i; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If ($paramNumber>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($element="polyline")\
				 | ($element="polygon")
				
				Case of 
						//______________________________________________________
					: (Value type:C1509($points)=Is collection:K8:32)
						
						If ($points.length%2=0)
							
							For ($i; 0; $points.length-1; 2)
								
								$data:=$data+String:C10($points[$i]; "&xml")+" "+String:C10($points[$i+1]; "&xml")
								
							End for 
							
							$data:=String:C10(This:C1470.getAttribute($node; "points"))+" "+$data
							
						Else 
							
							// #ERROR
							
						End if 
						
						//______________________________________________________
					: (Value type:C1509($points)=Is text:K8:3)
						
						$data:=String:C10(This:C1470.getAttribute($node; "points"))+" "+$points
						
						//______________________________________________________
					Else 
						
						// #ERROR
						
						//______________________________________________________
				End case 
				
				If (Length:C16($data)>0)
					
					Super:C1706.setAttribute($node; "points"; $data)
					
				Else 
					
					This:C1470._pushError("For a "+$element+", points must be passed as string or collection")
					
				End if 
				
				//…………………………………………………………………………………………………
			: ($element="path")
				
				// #TO_DO
				
				//…………………………………………………………………………………………………
			Else 
				
				This:C1470._pushError("he element \""+$element+"\" is not compatible withe \"points\" property")
				
				//…………………………………………………………………………………………………
		End case 
		
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Relative moveTo
Function m($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	//#TO_DO
	
	//———————————————————————————————————————————————————————————
	// Relative lineTo
Function l($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	//#TO_DO
	
	//———————————————————————————————————————————————————————————
	// Populate the "d" property of a path
Function d($data : Variant; $applyTo)->$this : cs:C1710.svg
	
	//#TO_DO
	
/*================================================================
                        ATTRIBUTES
================================================================*/
	
	//———————————————————————————————————————————————————————————
	// ⚠️ Overrides the method of the inherited class
Function setAttribute($name : Text; $value : Variant; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=3)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); $name; $value)
		
	Else 
		
		// Auto
		Super:C1706.setAttribute(This:C1470._getTarget(); $name; $value)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// ⚠️ Overrides the method of the inherited class
Function setAttributes($attributes : Variant; $value : Variant; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t : Text
	var $o : Object
	var $c : Collection
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			This:C1470._pushError("Missing parameter")
			
			//______________________________________________________
		: (Value type:C1509($attributes)=Is object:K8:27)
			
			If ($attributes#Null:C1517)
				
				If (Count parameters:C259>=2)
					
					Super:C1706.setAttributes(This:C1470._getTarget($value); OB Entries:C1720($attributes))
					
				Else 
					
					// Auto
					Super:C1706.setAttributes(This:C1470._getTarget(); OB Entries:C1720($attributes))
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($attributes)=Is collection:K8:32)
			
			If (Count parameters:C259>=2)
				
				Super:C1706.setAttributes(This:C1470._getTarget($value); $attributes)
				
			Else 
				
				// Auto
				Super:C1706.setAttributes(This:C1470._getTarget(); $attributes)
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($attributes)=Is text:K8:3)
			
			If (Count parameters:C259=3)
				
				Super:C1706.setAttribute(This:C1470._getTarget($applyTo); $attributes; $value)
				
			Else 
				
				If (This:C1470.isReference($attributes))
					
					Super:C1706.setAttributes($attributes; $value)
					
				Else 
					
					Super:C1706.setAttributes(This:C1470._getTarget(); $attributes; $value)
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function id($id : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	$node:=DOM Find XML element by ID:C1010(This:C1470.root; $id)
	
	If (OK=0)
		
		If (This:C1470._reservedNames.indexOf($id)=-1)
			
			If (Count parameters:C259>=2)
				
				$node:=This:C1470._getTarget($applyTo)
				
			Else 
				
				// Auto
				$node:=This:C1470._getTarget()
				
			End if 
			
			Super:C1706.setAttribute($node; "id"; $id)
			This:C1470.push($id)
			
		Else 
			
			This:C1470._pushError("\""+$id+"\" is a reserved name and can't be used as id!")
			
		End if 
		
	Else 
		
		This:C1470._pushError("The id \""+$id+"\" already exist!")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets the x value
Function x($x : Real; $applyTo)->$this : cs:C1710.svg
	
	
	var $node; $element : Text
	var $spans : Collection
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		Case of 
				
				//______________________________________________________
			: ($element="text")
				
				Super:C1706.setAttribute($node; "x"; $x)
				
				// Apply to enclosed spans, if any
				$spans:=This:C1470.find($node; "./tspan")
				
				If ($spans.length>0)
					
					For each ($node; $spans)
						
						Super:C1706.setAttribute($node; "x"; $x)
						
					End for each 
				End if 
				
				//______________________________________________________
			: ($element="rect")\
				 | ($element="image")\
				 | ($element="textArea")
				
				Super:C1706.setAttribute($node; "x"; $x)
				
				//______________________________________________________
			Else 
				
				This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
				
				//______________________________________________________
		End case 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets the y value
Function y($y : Real; $applyTo)->$this : cs:C1710.svg
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "y"; $y)
			
		Else 
			
			Super:C1706.setAttribute(This:C1470._getTarget(); "y"; $y)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets the radius of a circle
Function r($r : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="circle")
			
			Super:C1706.setAttribute($node; "r"; $r)
			
		Else 
			
			This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets the rx of a rect or an ellipse
Function rx($rx : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="rect")\
			 | ($element="ellipse")
			
			Super:C1706.setAttribute($node; "rx"; $rx)
			
		Else 
			
			This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets the ry of an ellipse
Function ry($ry : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="rect")\
			 | ($element="ellipse")
			
			Super:C1706.setAttribute($node; "ry"; $ry)
			
		Else 
			
			This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets the cx of a circle or ellipse
Function cx($cx : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="circle")\
			 | ($element="ellipse")
			
			Super:C1706.setAttribute($node; "cx"; $cx)
			
		Else 
			
			This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets the cy of a circle or ellipse
Function cy($cy : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget($applyTo)
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		If ($element="circle")\
			 | ($element="ellipse")
			
			Super:C1706.setAttribute($node; "cy"; $cy)
			
		Else 
			
			This:C1470._pushError("cannot be fixed for the element \""+$element+"\"")
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
Function width($width : Real; $applyTo)->$this : cs:C1710.svg
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "width"; $width)
			
		Else 
			
			Super:C1706.setAttribute(This:C1470._getTarget(); "width"; $width)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function height($height : Real; $applyTo)->$this : cs:C1710.svg
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		If (Count parameters:C259>=2)
			
			Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "height"; $height)
			
		Else 
			
			Super:C1706.setAttribute(This:C1470._getTarget(); "height"; $height)
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function translate($x : Real; $y : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t; $transform : Text
	var $c : Collection
	var $indx; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 2))
		
		$transform:="translate("+String:C10($x; "&xml")+","+String:C10($y; "&xml")+")"
		
		If ($paramNumber>=3)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		$t:=This:C1470.getAttribute($node; "transform")
		
		If (Length:C16($t)>0)
			
			$c:=Split string:C1554($t; " ")
			$indx:=$c.indexOf("translate(@")
			
			If ($indx#-1)
				
				$c[$indx]:=$transform
				
			Else 
				
				$c.push($transform)
				
			End if 
			
			$transform:=$c.join(" ")
			
		Else 
			
			This:C1470.errors.remove(This:C1470.errors.length-1)
			
		End if 
		
		Super:C1706.setAttribute($node; "transform"; $transform)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function rotate($angle : Integer; $cx : Variant; $cy : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t; $transform : Text
	var $c : Collection
	var $indx; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		Case of 
				
				//…………………………………………………………………………………………
			: ($paramNumber=1)  // Angle
				
				$node:=This:C1470._getTarget()
				$transform:="rotate("+String:C10($angle)+")"
				
				//…………………………………………………………………………………………
			: ($paramNumber=2)  // Angle + cx | ref
				
				If (Value type:C1509($cx)=Is real:K8:4)\
					 | (Value type:C1509($cx)=Is longint:K8:6)
					
					$node:=This:C1470._getTarget()
					$transform:="rotate("+String:C10($angle)+" "+String:C10($cx; "&xml")+" "+String:C10($cx; "&xml")+")"
					
				Else 
					
					$node:=This:C1470._getTarget($cx)
					$transform:="rotate("+String:C10($angle)+")"
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=3)  // Angle + cx + cy | ref
				
				If (Value type:C1509($cy)=Is real:K8:4)\
					 | (Value type:C1509($cy)=Is longint:K8:6)
					
					$node:=This:C1470._getTarget()
					$transform:="rotate("+String:C10($angle)+" "+String:C10($cx; "&xml")+" "+String:C10($cy; "&xml")+")"
					
				Else 
					
					$node:=This:C1470._getTarget($cy)
					$transform:="rotate("+String:C10($angle)+" "+String:C10($cx; "&xml")+" "+String:C10($cx; "&xml")+")"
					
				End if 
				
				//…………………………………………………………………………………………
			: ($paramNumber=4)  // Angle + cx + cy + ref
				
				$node:=This:C1470._getTarget($applyTo)
				$transform:="rotate("+String:C10($angle)+" "+String:C10($cx; "&xml")+" "+String:C10($cy; "&xml")+")"
				
				//…………………………………………………………………………………………
		End case 
		
		$t:=This:C1470.getAttribute($node; "transform")
		
		If (Length:C16($t)>0)
			
			$c:=Split string:C1554($t; " ")
			$indx:=$c.indexOf("rotate(@")
			
			If ($indx#-1)
				
				$c[$indx]:=$transform
				
			Else 
				
				$c.push($transform)
				
			End if 
			
			$transform:=$c.join(" ")
			
		Else 
			
			This:C1470.errors.remove(This:C1470.errors.length-1)
			
		End if 
		
		Super:C1706.setAttribute($node; "transform"; $transform)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function scale($x : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t; $transform : Text
	var $c : Collection
	var $indx; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		$transform:="scale("+String:C10($x; "&xml")+")"
		
		If ($paramNumber>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		$t:=This:C1470.getAttribute($node; "transform")
		
		If (Length:C16($t)>0)
			
			$c:=Split string:C1554($t; " ")
			$indx:=$c.indexOf("scale(@")
			
			If ($indx#-1)
				
				$c[$indx]:=$transform
				
			Else 
				
				$c.push($transform)
				
			End if 
			
			$transform:=$c.join(" ")
			
		Else 
			
			This:C1470.errors.remove(This:C1470.errors.length-1)
			
		End if 
		
		Super:C1706.setAttribute($node; "transform"; $transform)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function fillColor($color : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	If ($node=This:C1470.root)
		
		Super:C1706.setAttribute($node; "viewport-fill"; $color)
		
	Else 
		
		Super:C1706.setAttribute($node; "fill"; $color)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function fillOpacity($opacity : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	If ($node=This:C1470.root)
		
		Super:C1706.setAttribute($node; "viewport-fill-opacity"; $opacity)
		
	Else 
		
		Super:C1706.setAttribute($node; "fill-opacity"; $opacity)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function strokeColor($color : Text; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "stroke"; $color)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "stroke"; $color)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function strokeWidth($width : Real; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "stroke-width"; $width)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "stroke-width"; $width)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function strokeOpacity($opacity : Real; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "stroke-opacity"; $opacity)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "stroke-opacity"; $opacity)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function fontFamily($fonts : Text; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "font-family"; $fonts)
		
	Else 
		
		// Auto
		Super:C1706.setAttribute(This:C1470._getTarget(); "font-family"; $fonts)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function fontSize($size : Integer; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "font-size"; $size)
		
	Else 
		
		// Auto
		Super:C1706.setAttribute(This:C1470._getTarget(); "font-size"; $size)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function fontStyle($style : Integer; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	If ($style=Normal:K14:15)
		
		Super:C1706.setAttributes($node; New object:C1471(\
			"text-decoration"; "none"; \
			"font-style"; "normal"; \
			"font-weight"; "normal"))
		
	Else 
		
		If ($style>=8)  // Line-through
			
			Super:C1706.setAttribute($node; "text-decoration"; "line-through")
			$style:=$style-8
			
		End if 
		
		If (This:C1470.success)\
			 & ($style>=Underline:K14:4)
			
			Super:C1706.setAttribute($node; "text-decoration"; "underline")
			$style:=$style-Underline:K14:4
			
		End if 
		
		If (This:C1470.success)\
			 & ($style>=Italic:K14:3)
			
			Super:C1706.setAttribute($node; "font-style"; "italic")
			$style:=$style-Italic:K14:3
			
		End if 
		
		If (This:C1470.success)\
			 & ($style=Bold:K14:2)
			
			Super:C1706.setAttribute($node; "font-weight"; "bold")
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function alignment($alignment : Integer; $applyTo)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	DOM GET XML ELEMENT NAME:C730($node; $element)
	
	Case of 
			
			//…………………………………………………………………………………………
		: ($alignment=Align center:K42:3)
			
			If ($element="textArea")
				
				Super:C1706.setAttribute($node; "text-align"; "center")
				
			Else 
				
				Super:C1706.setAttribute($node; "text-anchor"; "middle")
				
			End if 
			
			//…………………………………………………………………………………………
		: ($alignment=Align right:K42:4)
			
			Super:C1706.setAttribute($node; Choose:C955($element="textArea"; "text-align"; "text-anchor"); "end")
			
			//…………………………………………………………………………………………
		: ($alignment=Align left:K42:2)\
			 | ($alignment=Align default:K42:1)
			
			Super:C1706.setAttribute($node; Choose:C955($element="textArea"; "text-align"; "text-anchor"); "start")
			
			//…………………………………………………………………………………………
		: ($alignment=5)\
			 & ($element="textArea")
			
			Super:C1706.setAttribute($node; "text-align"; "justify")
			
			//…………………………………………………………………………………………
		Else 
			
			Super:C1706.setAttribute($node; Choose:C955($element="textArea"; "text-align"; "text-anchor"); "inherit")
			
			//…………………………………………………………………………………………
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function textRendering($rendering : Text; $applyTo)->$this : cs:C1710.svg
	
	If (This:C1470._textRenderingValue.indexOf($rendering)#-1)
		
		If (Count parameters:C259>=2)
			
			Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "text-rendering"; $rendering)
			
		Else 
			
			// Auto
			Super:C1706.setAttribute(This:C1470._getTarget(); "text-rendering"; $rendering)
			
		End if 
		
	Else 
		
		This:C1470._pushError("Unknown value ("+$rendering+") for text-rendering.")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function visible($visible : Boolean; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "visibility"; Choose:C955($visible; "visible"; "hidden"))
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "visibility"; Choose:C955($visible; "visible"; "hidden"))
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Assigns a class name, or a set of class names, to an element
Function class($class : Text; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "class"; $class)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "class"; $class)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Assigns an embedded style to an element
Function style($tyle : Text; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259=2)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "style"; $tyle)
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "style"; $tyle)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
Function preserveAspectRatio($value : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	var $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If (Count parameters:C259>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		If (This:C1470._aspectRatioValues.indexOf($value)#-1)
			
			Super:C1706.setAttribute($node; "preserveAspectRatio"; $value)
			
		Else 
			
			Super:C1706.setAttribute($node; "preserveAspectRatio"; "xMidYMid")  // Set to default
			
		End if 
	End if 
	
/*================================================================
                     SHORTCUTS & UTILITIES
================================================================*/
	
	//———————————————————————————————————————————————————————————
	// Adds item to parent item
Function attachTo($parent)->$this : cs:C1710.svg
	
	var $t; $source : Text
	
	$source:=This:C1470.latest
	
	// Keeps id and removes it, if any, to avoid duplicate one
	$t:=String:C10(This:C1470.attributePop($source; "id"))
	
	If (Count parameters:C259>=1)
		
		This:C1470.latest:=Super:C1706.clone($source; This:C1470._getContainer($parent))
		
	Else 
		
		// Auto
		This:C1470.latest:=Super:C1706.clone($source; This:C1470._getContainer())
		
	End if 
	
	This:C1470.remove($source)
	
	// Restore id, if any
	If (Length:C16($t)>0)
		
		This:C1470.id($t)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// ⚠️ Overrides the method of the inherited class
Function clone($source : Text; $attachTo)->$this : cs:C1710.svg
	
	var $target : Text
	
	If (This:C1470._requiredParams(Count parameters:C259; 1))
		
		$target:=This:C1470._getTarget($source)
		
		If (This:C1470.getAttributes($target).id#Null:C1517)
			
			This:C1470.errors.push(Current method name:C684+" - As the id must be unique, it has been removed.")
			
		End if 
		
		If (Count parameters:C259>=2)
			
			This:C1470.latest:=Super:C1706.clone($target; This:C1470._getContainer($attachTo))
			
		Else 
			
			// Auto
			This:C1470.latest:=Super:C1706.clone($target; This:C1470._getContainer())
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Create one or more layer at the root of the SVG structure
Function layer($name : Text)->$this : cs:C1710.svg
	var ${2} : Text
	
	var $i : Integer
	
	For ($i; 1; Count parameters:C259; 1)
		
		This:C1470.latest:=Super:C1706.create(This:C1470.root; "g")
		Super:C1706.setAttribute(This:C1470.latest; "id"; ${$i})
		This:C1470.push(${$i})
		
	End for 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	//  Define an element for the next operations
Function useOf($name : Text)->$ok : Boolean
	
	var $o : Object
	
	$o:=This:C1470.store.query("id=:1"; $name).pop()
	$ok:=$o#Null:C1517
	
	If ($ok)
		
		This:C1470.latest:=$o.dom
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Keep the dom reference for future use
Function push($name : Text)->$this : cs:C1710.svg
	
	var $id : Text
	
	If (Count parameters:C259>=1)
		
		If (This:C1470.store.query("id=:1"; $name).pop()=Null:C1517)
			
			This:C1470.store.push(New object:C1471(\
				"id"; $name; \
				"dom"; This:C1470.latest))
			
		Else 
			
			This:C1470._pushError("The element \""+$name+"\" already exists")
			
		End if 
		
	Else 
		
		// Use the id, if available
		$id:=String:C10(This:C1470.getAttribute(This:C1470.latest; "id"))
		
		If (Length:C16($id)>0)
			
			var $o : Object
			$o:=This:C1470.store.query("id = :1"; $id).pop()
			
			If ($o=Null:C1517)
				
				// Create
				This:C1470.store.push(New object:C1471(\
					"id"; $id; \
					"dom"; This:C1470.latest))
				
			Else 
				
				// Update
				$o.dom:=This:C1470.latest
				
			End if 
			
		Else 
			
			This:C1470.store.push(New object:C1471(\
				"id"; Generate UUID:C1066; \
				"dom"; This:C1470.latest))
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Retrieve a stored dom reference
Function fetch($name : Text)->$dom : Text
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$o:=This:C1470.store.query("id = :1"; $name).pop()
		
	Else 
		
		// Auto
		$o:=New object:C1471(\
			"dom"; This:C1470.latest)
		
	End if 
	
	If ($o#Null:C1517)
		
		$dom:=$o.dom
		
	Else 
		
		This:C1470._pushError("The element \""+$name+"\" doesn't exists")
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Sets shape color (stroke and fill)
Function color($color : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	Super:C1706.setAttribute($node; "fill"; $color)
	Super:C1706.setAttribute($node; "stroke"; $color)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets opacity of stroke and fill.
Function opacity($opacity : Real; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	This:C1470.fillOpacity($opacity; $node)
	This:C1470.strokeOpacity($opacity; $node)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets one or more stroke attributes
Function stroke($value; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is real:K8:4)\
			 | (Value type:C1509($value)=Is longint:K8:6)  // Set width
			
			Super:C1706.setAttribute($node; "stroke-width"; $value)
			
			//______________________________________________________
		: (Value type:C1509($value)=Is text:K8:3)  // Set color
			
			Super:C1706.setAttribute($node; "stroke"; $value)
			
			//______________________________________________________
		: (Value type:C1509($value)=Is boolean:K8:9)  // Set visibility
			
			If ($value)
				
				If (String:C10(This:C1470.getAttribute($node; "stroke"))="none")
					
					This:C1470.removeAttribute($node; "stroke")
					
				End if 
				
				If (Num:C11(This:C1470.getAttribute($node; "stroke-width"))=0)
					
					This:C1470.removeAttribute($node; "stroke-width")
					
				End if 
				
			Else 
				
				Super:C1706.setAttribute($node; "stroke"; "none")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is object:K8:27)  // Multiple attributes
			
			If ($value.color#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke"; $value.color)
				
			End if 
			
			If ($value.width#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke-width"; $value.width)
				
			End if 
			
			If ($value.opacity#Null:C1517)
				
				Super:C1706.setAttribute($node; "stroke-opacity"; $value.opacity)
				
			End if 
			
			//______________________________________________________
		Else 
			
			ALERT:C41(String:C10(Value type:C1509($value)))
			This:C1470._pushError("Bad parameter type")
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Sets one or more fill attributes
Function fill($value; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is text:K8:3)  // Set color
			
			If ($node=This:C1470.root)
				
				Super:C1706.setAttribute($node; "viewport-fill"; $value)
				
			Else 
				
				Super:C1706.setAttribute($node; "fill"; $value)
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is boolean:K8:9)  // Set visibility
			
			If ($node=This:C1470.root)
				
				If ($value)
					
					If (String:C10(This:C1470.getAttribute($node; "viewport-fill"))="none")
						
						This:C1470.removeAttribute($node; "viewport-fill")
						
					End if 
					
				Else 
					
					Super:C1706.setAttribute($node; "viewport-fill"; "none")
					
				End if 
				
			Else 
				
				If ($value)
					
					If (String:C10(This:C1470.getAttribute($node; "fill"))="none")
						
						This:C1470.removeAttribute($node; "fill")
						
					End if 
					
				Else 
					
					Super:C1706.setAttribute($node; "fill"; "none")
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($value)=Is object:K8:27)  // Multiple attributes
			
			If ($value.color#Null:C1517)
				
				If ($node=This:C1470.root)
					
					Super:C1706.setAttribute($node; "viewport-fill"; $value.color)
					
				Else 
					
					Super:C1706.setAttribute($node; "fill"; $value.color)
					
				End if 
			End if 
			
			If ($value.opacity#Null:C1517)
				
				If ($node=This:C1470.root)
					
					Super:C1706.setAttribute($node; "viewport-fill-opacity"; $value.opacity)
					
				Else 
					
					Super:C1706.setAttribute($node; "fill-opacity"; $value.opacity)
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Bad parameter type")
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Define font properties
Function font($attributes : Object; $applyTo)->$this : cs:C1710.svg
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	If ($attributes.font#Null:C1517)
		
		Super:C1706.setAttribute($node; "font-family"; $attributes.font)
		
	End if 
	
	If ($attributes.size#Null:C1517)
		
		Super:C1706.setAttribute($node; "font-size"; $attributes.size)
		
	End if 
	
	If ($attributes.color#Null:C1517)
		
		This:C1470.fill($attributes.color; $node)
		
	End if 
	
	If ($attributes.style#Null:C1517)
		
		This:C1470.fontStyle($attributes.style; $node)
		
	End if 
	
	If ($attributes.alignment#Null:C1517)
		
		This:C1470.alignment($attributes.alignment; $node)
		
	End if 
	
	If ($attributes.rendering#Null:C1517)
		
		This:C1470.textRendering($attributes.rendering; $node)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Set the position of an object
Function position($x : Real; $y : Variant; $unit : Text)->$this : cs:C1710.svg
	
	var $element; $node : Text
	
	$node:=This:C1470._getTarget()
	DOM GET XML ELEMENT NAME:C730($node; $element)
	
	Case of 
			
			//______________________________________________________
		: ($element="svg")\
			 | ($element="g")
			
			This:C1470._pushError("You can't set position for the element"+$element+"!")
			
			//______________________________________________________
		: ($element="circle")\
			 | ($element="ellipse")
			
			Case of 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=3)
					
					If (Value type:C1509($y)=Is real:K8:4)\
						 | (Value type:C1509($y)=Is longint:K8:6)
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"cx"; String:C10($x; "&xml")+$unit; \
							"cy"; String:C10($y; "&xml")+$unit))
						
					Else 
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"cx"; String:C10($x; "&xml")+$unit; \
							"cy"; String:C10(Num:C11($y); "&xml")+$unit))
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=2)
					
					If (Value type:C1509($y)=Is real:K8:4)\
						 | (Value type:C1509($y)=Is longint:K8:6)
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"cx"; $x; \
							"cy"; $y))
						
					Else 
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"cx"; String:C10($x; "&xml")+String:C10($y); \
							"cy"; String:C10($x; "&xml")+String:C10($y)))
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=1)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"cx"; $x; \
						"cy"; $x))
					
					//…………………………………………………………………………………………………
				Else 
					
					This:C1470._pushError("Missing parameter")
					
					//…………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
		: ($element="line")
			
			Case of 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=3)
					
					If (Value type:C1509($y)=Is real:K8:4)\
						 | (Value type:C1509($y)=Is longint:K8:6)
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x1"; String:C10($x; "&xml")+$unit; \
							"y1"; String:C10($y; "&xml")+$unit))
						
					Else 
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x1"; String:C10($x; "&xml")+$unit; \
							"y1"; String:C10(Num:C11($y); "&xml")+$unit))
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=2)
					
					If (Value type:C1509($y)=Is real:K8:4)\
						 | (Value type:C1509($y)=Is longint:K8:6)
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x1"; $x; \
							"y1"; $y))
						
					Else 
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x1"; String:C10($x; "&xml")+String:C10($y); \
							"y1"; String:C10($x; "&xml")+String:C10($y)))
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=1)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"x1"; $x; \
						"y1"; $x))
					
					//…………………………………………………………………………………………………
				Else 
					
					This:C1470._pushError("Missing parameter")
					
					//…………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
		Else 
			
			Case of 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=3)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"x"; String:C10($x; "&xml")+$unit; \
						"y"; String:C10(Num:C11($y); "&xml")+$unit))
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=2)
					
					If (Value type:C1509($y)=Is text:K8:3)
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x"; String:C10($x; "&xml")+String:C10($y); \
							"y"; String:C10($x; "&xml")+String:C10($y)))
						
					Else 
						
						Super:C1706.setAttributes($node; New object:C1471(\
							"x"; $x; \
							"y"; Num:C11($y)))
						
					End if 
					
					//…………………………………………………………………………………………………
				: (Count parameters:C259=1)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"x"; $x; \
						"y"; $x))
					
					//…………………………………………………………………………………………………
				Else 
					
					This:C1470._pushError("Missing parameter")
					
					//…………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Set the dimensions of an object
Function dimensions($width : Real; $height : Real; $unit : Text)->$this : cs:C1710.svg
	
	var $node; $element : Text
	
	$node:=This:C1470._getTarget()
	DOM GET XML ELEMENT NAME:C730($node; $element)
	
	Case of 
			
			//______________________________________________________
		: ($element="g")\
			 | ($element="use")
			
			This:C1470._pushError("You can't set dimensions for the element"+$element+"!")
			
			//______________________________________________________
		: ($element="textArea")
			
			Case of 
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259=0)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"width"; "auto"; \
						"height"; "auto"))
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=3)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"width"; Choose:C955($width=0; "auto"; String:C10($width; "&xml")+String:C10($unit)); \
						"height"; Choose:C955($height=0; "auto"; String:C10($height; "&xml")+String:C10($unit))))
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=2)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"width"; Choose:C955($width=0; "auto"; String:C10($width; "&xml")); \
						"height"; Choose:C955($height=0; "auto"; String:C10($height; "&xml"))))
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=1)
					
					Super:C1706.setAttribute($node; "width"; Choose:C955($width=0; "auto"; String:C10($width; "&xml")))
					
					//……………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
		: ($element="line")\
			 | ($element="circle")\
			 | ($element="ellipse")
			
			// #TO_DO
			
			//______________________________________________________
		Else 
			
			Case of 
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=3)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"width"; String:C10($width; "&xml")+String:C10($unit); \
						"height"; String:C10($height; "&xml")+String:C10($unit)))
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=2)
					
					Super:C1706.setAttributes($node; New object:C1471(\
						"width"; String:C10($width; "&xml"); \
						"height"; String:C10($height; "&xml")))
					
					//……………………………………………………………………………………………………
				: (Count parameters:C259>=1)
					
					Super:C1706.setAttribute($node; "width"; String:C10($width; "&xml"))
					
					//……………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Horizontal shift
Function moveH($x : Real; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		This:C1470.translate($x; 0; This:C1470._getTarget($applyTo))
		
	Else 
		
		// Auto
		This:C1470.translate($x; 0; This:C1470._getTarget())
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Vertical shift
Function moveV($y : Real; $applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=2)
		
		This:C1470.translate(0; $y; This:C1470._getTarget($applyTo))
		
	Else 
		
		// Auto
		This:C1470.translate($0; $y; This:C1470._getTarget())
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Populate the "points" property of a polyline, polygon
	// or the "data" proprety of a path
Function plot($points : Variant; $applyTo)->$this : cs:C1710.svg
	
	var $data; $node; $element : Text
	var $i; $paramNumber : Integer
	
	$paramNumber:=Count parameters:C259
	
	If (This:C1470._requiredParams($paramNumber; 1))
		
		If ($paramNumber>=2)
			
			$node:=This:C1470._getTarget($applyTo)
			
		Else 
			
			// Auto
			$node:=This:C1470._getTarget()
			
		End if 
		
		DOM GET XML ELEMENT NAME:C730($node; $element)
		
		Case of 
				
				//…………………………………………………………………………………………………
			: ($element="polyline")\
				 | ($element="polygon")
				
				This:C1470.points($points; $node)
				
				//…………………………………………………………………………………………………
			: ($element="path")
				
				This:C1470.d($points; $node)
				
				//…………………………………………………………………………………………………
			Else 
				
				This:C1470._pushError("The element \""+$element+"\" is not compatible withe \"plot\" property")
				
				//…………………………………………………………………………………………………
		End case 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Fix the radius of a circle or a rounded rectangle
Function radius($radius : Integer; $applyTo)->$this : cs:C1710.svg
	
	var $element; $node : Text
	
	If (Count parameters:C259=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	DOM GET XML ELEMENT NAME:C730($node; $element)
	
	Case of 
			
			//______________________________________________________
		: ($element="rect")\
			 | ($element="g")
			
			Super:C1706.setAttribute($node; "rx"; $radius)
			
			//______________________________________________________
		: ($element="circle")
			
			Super:C1706.setAttribute($node; "r"; $radius)
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Cant set radius for an object "+$element)
			
			//______________________________________________________
	End case 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Make visible
Function show($applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=1)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "visibility"; "visible")
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "visibility"; "visible")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Make invisible
Function hide($applyTo)->$this : cs:C1710.svg
	
	If (Count parameters:C259>=1)
		
		Super:C1706.setAttribute(This:C1470._getTarget($applyTo); "visibility"; "hidden")
		
	Else 
		
		Super:C1706.setAttribute(This:C1470._getTarget(); "visibility"; "hidden")
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Add a class name to an element
Function addClass($class : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t : Text
	
	If (Count parameters:C259=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	$t:=String:C10(This:C1470.getAttribute($node; "class"))
	
	If (Length:C16($t)>0)
		
		If (Split string:C1554($t; " ").indexOf($class)=-1)
			
			$t:=$t+" "+$class
			
		End if 
		
	Else 
		
		$t:=$class
		
	End if 
	
	Super:C1706.setAttribute($node; "class"; $t)
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Remove a class name from an element
Function removeClass($class : Text; $applyTo)->$this : cs:C1710.svg
	
	var $node; $t : Text
	var $indx : Integer
	var $c : Collection
	
	If (Count parameters:C259=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	$t:=String:C10(This:C1470.getAttribute($node; "class"))
	
	If (Length:C16($t)>0)
		
		$c:=Split string:C1554($t; " ")
		
		$indx:=$c.indexOf($class)
		
		If ($indx#-1)
			
			$c.remove($indx)
			Super:C1706.setAttribute($node; "class"; $c.join(" "))
			
		End if 
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Tests if the node belongs to a class
Function isOfClass($class : Text; $applyTo)->$isOfclass : Boolean
	
	var $node : Text
	
	If (Count parameters:C259>=2)
		
		$node:=This:C1470._getTarget($applyTo)
		
	Else 
		
		// Auto
		$node:=This:C1470._getTarget()
		
	End if 
	
	$isOfclass:=(Position:C15($class; String:C10(This:C1470.getAttribute($node; "class")))#0)
	
	//———————————————————————————————————————————————————————————
	// ⚠️ Overrides the method of the inherited class
Function setValue($value : Text; $applyTo; $CDATA : Boolean)->$this : cs:C1710.svg
	
	var $node : Text
	var $isCDATA : Boolean
	
	If (Count parameters:C259>=2)
		
		If (Count parameters:C259>=3)
			
			$isCDATA:=$CDATA
			$node:=This:C1470._getTarget(String:C10($applyTo))
			
		Else 
			
			If (Value type:C1509($applyTo)=Is text:K8:3)
				
				$node:=This:C1470._getTarget($applyTo)
				
			Else 
				
				$node:=This:C1470._getTarget()
				$isCDATA:=Bool:C1537($applyTo)
				
			End if 
		End if 
		
	Else 
		
		$node:=This:C1470._getTarget()
		
	End if 
	
	If ($isCDATA)
		
		Super:C1706.setValue($node; $value; True:C214)
		
	Else 
		
		Super:C1706.setValue($node; $value)
		
	End if 
	
	$this:=This:C1470
	
	//———————————————————————————————————————————————————————————
	// Display the SVG image & tree into the SVG Viewer
Function preview($keepStructure : Boolean)
	
	// #TO_DO: Should test if the component is available
	EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER"; *; This:C1470.root)
	
	If (Count parameters:C259>=1)
		
		If (This:C1470.autoClose)\
			 & (Not:C34($keepStructure))
			
			This:C1470.close()
			
		End if 
		
	Else 
		
		If (This:C1470.autoClose)
			
			This:C1470.close()
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Returns text width
Function getTextWidth($string : Text; $fontAttributes : Object)->$width : Integer
	
	var $picture : Picture
	var $height : Integer
	var $o : Object
	
	$o:=cs:C1710.svg.new().textArea($string)
	
	If (Count parameters:C259>=2)
		
		$o.font($fontAttributes)
		
		//Else : Keep the default font that should be: Times New Roman 12 pts.
		
	End if 
	
	$picture:=$o.picture()
	PICTURE PROPERTIES:C457($picture; $width; $height)
	
	//———————————————————————————————————————————————————————————
	// Returns text height #WIP
Function getTextHeight($string : Text; $fontAttributes : Object)->$height : Integer
	
	var $picture : Picture
	var $width : Integer
	var $o : Object
	var $line : Text
	
	// 1] Calculate the height of the last line
	$line:=$string
	
	// Keep only the last line
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	If (Match regex:C1019("(?i-ms).*$"; $string; 1; $pos; $len))
		
		$line:=Substring:C12($string; $pos{0}; $len{0})
		
	End if 
	
	$o:=cs:C1710.svg.new().text($line)
	
	If (Count parameters:C259>=2)
		
		$o.font($fontAttributes)
		
	End if 
	
	If (Count parameters:C259>=2)
		
		$o.font($fontAttributes)
		
		//Else : Keep the default font that should be: Times New Roman 12 pts.
		
	End if 
	
	$picture:=$o.picture()
	PICTURE PROPERTIES:C457($picture; $width; $height)
	
	// 2] Measure the width and height of the text itself.
	$o.fillOpacity(0)
	
	$o.textArea()
	
	If (Count parameters:C259>=2)
		
		$o.font($fontAttributes)
		
	End if 
	
	
/*================================================================
                         PRIVATES
================================================================*/
	
	//———————————————————————————————————————————————————————————
	// ⚠️ Overrides the method of the inherited class
Function _reset
	
	Super:C1706._reset()
	
	This:C1470.latest:=Null:C1517
	This:C1470.graphic:=Null:C1517
	This:C1470.store:=New collection:C1472
	
	//———————————————————————————————————————————————————————————
	// Get an available container
Function _getContainer($param)->$container : Text
	
	// Keep a backup of the current item reference.
	// We might need it, if the created element is assigned to a symbol
	This:C1470._current:=This:C1470.latest
	
	If (Count parameters:C259>=1)
		
		$container:=This:C1470._getTarget($param)
		
	Else 
		
		// Current
		$container:=This:C1470._getTarget()
		
	End if 
	
	If ($container#This:C1470.root)
		
		If (This:C1470._notContainer.indexOf(This:C1470.getName($container))#-1)
			
			$container:=This:C1470.parent($container)
			
		End if 
	End if 
	
	//———————————————————————————————————————————————————————————
	// Returns the target of the function call
Function _getTarget($param)->$target : Text
	
	var $tryToBeSmart : Boolean
	var $o : Object
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$tryToBeSmart:=True:C214
			
			//_______________________________
		: (Value type:C1509($param)#Is text:K8:3)
			
			$tryToBeSmart:=True:C214
			
			//_______________________________
		: ($param="root")
			
			$target:=This:C1470.root
			
			//_______________________________
		: ($param="latest")
			
			$tryToBeSmart:=True:C214
			
			//_______________________________
		: ($param="parent")
			
			If (This:C1470.latest=Null:C1517)
				
				$target:=This:C1470.root
				
			Else 
				
				// Get the parent
				$target:=This:C1470.parent(This:C1470.latest)
				
			End if 
			
			//_______________________________
		: (This:C1470._reservedNames.indexOf($param)#-1)
			
			$tryToBeSmart:=True:C214
			
			//_______________________________
		: (This:C1470.isReference($param))
			
			$target:=$param  // The given reference
			
			//_______________________________
		Else 
			
			// Find a memorized targets
			$o:=This:C1470.store.query("id=:1"; $param).pop()
			
			If ($o#Null:C1517)
				
				$target:=$o.dom
				
			Else 
				
				$tryToBeSmart:=True:C214
				
			End if 
			
			//_______________________________
	End case 
	
	If ($tryToBeSmart)
		
		$target:=Choose:C955(This:C1470.latest#Null:C1517; This:C1470.latest; This:C1470.root)
		
	End if 
	
	//———————————————————————————————————————————————————————————
	// Looks for element "defs", create if not exists
Function _defs()->$reference
	
	var $node; $root : Text
	var $c : Collection
	
	$c:=This:C1470.findByName("defs")
	
	If (This:C1470.success)
		
		$reference:=$c[0]
		
	Else 
		
		$root:=DOM Create XML Ref:C861("root")
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			$node:=Super:C1706.create($root; "defs")
			
			If (This:C1470.success)
				
				$reference:=Super:C1706.insert(This:C1470.root; $node)
				
			End if 
			
			DOM CLOSE XML:C722($root)
			
		End if 
	End if 
	