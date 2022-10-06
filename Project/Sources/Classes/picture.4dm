Class extends scrollable

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text; $picture)
	
	Super:C1705($name)
	
	Case of 
			
			//______________________________________
		: (Value type:C1509($picture)=Is picture:K8:10)
			
			This:C1470.value:=$picture
			This:C1470.fileName:=Get picture file name:C1171($picture)
			This:C1470.size:=Picture size:C356($picture)
			
			//______________________________________
		: (Value type:C1509($picture)=Is object:K8:27)  // 4D.File
			
			This:C1470.read($picture)
			
			//______________________________________
		Else 
			
			This:C1470.value:=$picture
			This:C1470.fileName:=""
			This:C1470.size:=0
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function findByCoordinates() : Text
	
	return SVG Find element ID by coordinates:C1054(*; This:C1470.name; MOUSEX; MOUSEY)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getAttribute($id : Text; $attribute : Text; $type : Integer) : Variant
	
	var $value : Text
	SVG GET ATTRIBUTE:C1056(*; This:C1470.name; $id; $attribute; $value)
	
	Case of 
			
			//______________________________________
		: ($type=Is text:K8:3)
			
			return $value
			
			//______________________________________
		: ($type=Is BLOB:K8:12)
			
			var $x : Blob
			BASE64 DECODE:C896($value; $x)
			return $x
			
			//______________________________________
		Else 
			
			return JSON Parse:C1218($value; Is longint:K8:6)
			
			//______________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setAttributes($id : Text; $attributes : Collection)
	
	var $o : Object
	
	For each ($o; $attributes)
		
		This:C1470.setAttribute($id; $o.name; $o.value)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setAttribute($id : Text; $name : Text; $value)
	
	var $t : Text
	var $type : Integer
	
	$type:=Value type:C1509($value)
	
	Case of 
			
			//______________________________________
		: ($type=Is BLOB:K8:12)
			
			BASE64 ENCODE:C895($value; $t)
			$value:=$t
			
			//______________________________________
		: ($type=Is text:K8:3)\
			 | ($type=Is longint:K8:6)\
			 | ($type=Is integer:K8:5)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________
		Else 
			
			$value:=String:C10($value)
			
			//______________________________________
	End case 
	
	SVG SET ATTRIBUTE:C1055(*; This:C1470.name; $id; $name; $value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️
Function getCoordinates()->$coordinates : Object
	
	$coordinates:=Super:C1706.getCoordinates()
	
	This:C1470.getScrollbars()
	This:C1470.getScrollPosition()
	This:C1470.getDimensions()
	
Function getDimensions() : Object
	
	var $p : Picture
	var $height; $width : Integer
	
	$p:=This:C1470.getValue()
	
	PICTURE PROPERTIES:C457($p; $width; $height)
	
	return New object:C1471(\
		"width"; $width; \
		"height"; $height)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function read($file : 4D:C1709.File) : cs:C1710.picture
	
	var $p : Picture
	
	If (Asserted:C1132(Count parameters:C259>=1; Current method name:C684+".read(): Missing File parameter"))
		
		If (Asserted:C1132(OB Instance of:C1731($file; 4D:C1709.File); Current method name:C684+".read(): The passed parameter is not a File object"))
			
			If (Asserted:C1132($file.exists; Current method name:C684+".read(): File not found"))
				
				READ PICTURE FILE:C678($file.platformPath; $p)
				
				If (Bool:C1537(OK))
					
					This:C1470.setValue($p)
					This:C1470.fileName:=Get picture file name:C1171($p)
					This:C1470.size:=Picture size:C356($p)
					
				End if 
			End if 
		End if 
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function thumbnail($width : Integer; $height : Integer; $mode : Integer) : cs:C1710.picture
	
	If (Count parameters:C259>=3)
		
		This:C1470.setValue(This:C1470.getThumbnail($width; $height; $mode))
		
	Else 
		
		If (Count parameters:C259>=2)
			
			This:C1470.setValue(This:C1470.getThumbnail($width; $height))
			
		Else 
			
			If (Count parameters:C259>=1)
				
				This:C1470.setValue(This:C1470.getThumbnail($width))
				
			Else 
				
				This:C1470.setValue(This:C1470.getThumbnail())
				
			End if 
		End if 
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getThumbnail($width : Integer; $height : Integer; $mode : Integer) : Picture
	
	var $p : Picture
	
	$p:=This:C1470.getValue()
	
	$width:=$width=0 ? 48 : $width  // Default 48x48 px
	$height:=$height=0 ? $width : $height  // Square if no height
	$mode:=$mode=0 ? Scaled to fit prop centered:K6:6 : $mode
	
	CREATE THUMBNAIL:C679($p; $p; $width; $height; $mode)
	
	return $p
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function horizontalConcatenation($file : 4D:C1709.File) : cs:C1710.picture
	
	This:C1470.setValue(This:C1470.__combine($file; Horizontal concatenation:K61:8))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function verticalConcatenation($file : 4D:C1709.File) : cs:C1710.picture
	
	This:C1470.setValue(This:C1470.__combine($file; Vertical concatenation:K61:9))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function superImposition($file : 4D:C1709.File; $horOffset : Integer; $vertOffset : Integer) : cs:C1710.picture
	
	This:C1470.setValue(This:C1470.__combine($file; Superimposition:K61:10; $horOffset; $vertOffset))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function __combine($file : 4D:C1709.File; $operator : Integer; $horOffset : Integer; $vertOffset : Integer) : Picture
	
	var $image; $picture : Picture
	
	If (Asserted:C1132(Count parameters:C259>=1; Current method name:C684+".horizontalConcatenation(): Missing File parameter"))
		
		If (Asserted:C1132(OB Instance of:C1731($file; 4D:C1709.File); Current method name:C684+".horizontalConcatenation(): The passed parameter is not a File object"))
			
			If (Asserted:C1132($file.exists; Current method name:C684+".horizontalConcatenation(): File not found"))
				
				READ PICTURE FILE:C678($file.platformPath; $image)
				
				If (Bool:C1537(OK))
					
					$picture:=This:C1470.getValue()
					
					COMBINE PICTURES:C987($image; $picture; $operator; $image; $horOffset; $vertOffset)
					
					return $image
					
				End if 
			End if 
		End if 
	End if 