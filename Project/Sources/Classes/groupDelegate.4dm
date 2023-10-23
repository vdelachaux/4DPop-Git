/*
A group is a collection of static or active objects

You can define it by passing N objects as parameters
--> cs.groupDelegate.new(object1, object2, …, objectN)

or a collection of objects (could be a group)
--> cs.groupDelegate.new(object collection)    

or a comma separated list of object names
--> cs.groupDelegate.new("name1,name2,…,nameN")
in this case, all named objects are initialized with widget class

*/

property members : Collection

Class constructor($members : Variant;  ... )
	
	C_LONGINT:C283($i)
	C_TEXT:C284($t)
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.type:=Object type group:K79:22
	
	Case of 
			
			//___________________________
		: (Count parameters:C259=0)
			
			This:C1470.members:=[]
			
			//___________________________
		: (Value type:C1509($members)=Is collection:K8:32)
			
			This:C1470.members:=$members
			
			//___________________________
		: (Value type:C1509($members)=Is object:K8:27)  // 1 to N objects (could be groups)
			
			This:C1470.members:=[]
			
			For ($i; 1; Count parameters:C259; 1)
				
				This:C1470.add(${$i})
				
			End for 
			
			//___________________________
		: (Value type:C1509($members)=Is text:K8:3)  // Comma separated list of object names
			
			This:C1470.members:=[]
			
			This:C1470.add($members)
			
			//___________________________
		Else 
			
			This:C1470.members:=[]
			
			//___________________________
	End case 
	
/*
The user data can be anything you want to attach to the group.
The .data property is used to get or set this data.
*/
	This:C1470._data:=Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function add($member) : cs:C1710.groupDelegate
	
	var $t : Text
	var $type : Integer
	
	$type:=Value type:C1509($member)
	
	Case of 
			
			//___________________________
		: ($type=Is collection:K8:32)
			
			This:C1470.members:=This:C1470.members.combine($member)
			
			//___________________________
		: ($type=Is object:K8:27)
			
			If (OB Instance of:C1731($member; cs:C1710.groupDelegate))
				
				This:C1470.members:=This:C1470.members.combine($member.members)
				
			Else 
				
				This:C1470.members.push($member)
				
			End if 
			
			//___________________________
		: ($type=Is text:K8:3)  // Comma separated list of object names
			
			For each ($t; Split string:C1554($member; ","))
				
				This:C1470.members.push(cs:C1710.widgetDelegate.new($t))  // Widget by default
				
			End for each 
			
			//___________________________
		Else 
			
			ASSERT:C1129(False:C215; "Bad parameter type")
			
			//___________________________
	End case 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Returns True if the passed object or object name is part of the group
	
.belongsTo(obj) --> bool
	
or
	
.belongsTo("name") --> bool
	
**/
Function belongsTo($widget) : Boolean
	
	var $type : Integer
	
	$type:=Value type:C1509($widget)
	
	Case of 
			
			//______________________________________________________
		: ($type=Is object:K8:27)
			
			return This:C1470.members.includes($widget)
			
			//______________________________________________________
		: ($type=Is text:K8:3)
			
			return This:C1470.members.query("name=:1"; $widget).pop()#Null:C1517
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unmanaged parameter type")
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Returns the user data attached to the group
Function get data() : Variant
	
	return This:C1470._data
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	/// Defines the user data attached to the group
Function set data($data)
	
	This:C1470._data:=$data
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the coordinates of the rectangle enclosing the group.
Function enclosingRect($gap : Integer) : cs:C1710.coord
	
	var $left; $top; $right; $bottom : Integer
	var $o : cs:C1710.staticDelegate
	var $coordinates : Object
	
	For each ($o; This:C1470.members)
		
		OBJECT GET COORDINATES:C663(*; $o.name; $left; $top; $right; $bottom)
		
		If ($coordinates=Null:C1517)
			
			$coordinates:={\
				left: $left; \
				top: $top; \
				right: $right; \
				bottom: $bottom}
			
		Else 
			
			$coordinates.left:=Choose:C955($left<$coordinates.left; $left; $coordinates.left)
			$coordinates.top:=Choose:C955($top<$coordinates.top; $top; $coordinates.top)
			$coordinates.right:=Choose:C955($right>$coordinates.right; $right; $coordinates.right)
			$coordinates.bottom:=Choose:C955($bottom>$coordinates.bottom; $bottom; $coordinates.bottom)
			
		End if 
	End for each 
	
	If ($coordinates#Null:C1517) & (Count parameters:C259>=1)
		
		$coordinates.left:=$coordinates.left-$gap
		$coordinates.top:=$coordinates.top-$gap
		$coordinates.right:=$coordinates.right+$gap
		$coordinates.bottom:=$coordinates.bottom+$gap
		
	End if 
	
	return $coordinates
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveVertically($offset : Integer)
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.moveVertically($offset)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hiddenFromView()
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.hiddenFromView()
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveHorizontally($offset : Integer)
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.moveHorizontally($offset)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Performs a horizontal distribution, from left to right,
of the elements according to their best size
	
.distributeLeftToRight({obj})
	
The optional object type parameter allow to specify:
- The starting point x in pixels in the form (start)
- The spacing in pixels to respect between the elements (spacing)
- The minimum width to respect in pixels (minWidth)
- The maximum width to respect in pixels (maxWidth)
	
**/
Function distributeLeftToRight($params : Object) : cs:C1710.groupDelegate
	
	var $e; $o : Object
	var $key : Text
	
	$e:={\
		start: 0; \
		spacing: 0; \
		minWidth: 0; \
		maxWidth: 0; \
		alignment: Align left:K42:2}
	
	If (Count parameters:C259>=1)
		
		For each ($key; $params)
			
			If ($params[$key]#Null:C1517)
				
				$e[$key]:=$params[$key]
				
			End if 
		End for each 
		
		$e.alignment:=Align left:K42:2
		
	End if 
	
	For each ($o; This:C1470.members)
		
		$o.bestSize($e)
		
		If ($e.start#0)
			
			$o.moveHorizontally($e.start-$o.coordinates.left)
			
		End if 
		
		// Calculate the cumulative shift
		If ($e.spacing=0)
			
			Case of 
					
					//_______________________________
				: ($o.type=Object type push button:K79:16)\
					 || ($o.type=Object type 3D button:K79:17)
					
					$e.start:=$o.coordinates.right+(Is macOS:C1572 ? 20 : 20)
					
					//_______________________________
				Else 
					
					$e.start:=$o.coordinates.right
					
					//_______________________________
			End case 
			
		Else 
			
			$e.start:=$o.coordinates.right+$e.spacing
			
		End if 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Performs a horizontal distribution, from right to left,
of the elements according to their best size
	
.distributeRigthToLeft({obj})
	
The optional object type parameter allow to specify:
- The starting point x in pixels in the form (start)
- The spacing in pixels to respect between the elements (spacing)
- The minimum width to respect in pixels (minWidth)
- The maximum width to respect in pixels (maxWidth)
	
**/
Function distributeRigthToLeft($params : Object) : cs:C1710.groupDelegate
	
	var $e; $o : Object
	var $key : Text
	
	$e:={\
		start: 0; \
		spacing: 0; \
		minWidth: 0; \
		maxWidth: 0; \
		alignment: Align right:K42:4}
	
	If (Count parameters:C259>=1)
		
		For each ($key; $params)
			
			If ($params[$key]#Null:C1517)
				
				$e[$key]:=$params[$key]
				
			End if 
		End for each 
		
		$e.alignment:=Align right:K42:4
		
	End if 
	
	For each ($o; This:C1470.members)
		
		$o.bestSize($e)
		
		If ($e.start#0)
			
			$o.moveHorizontally($e.start-$o.coordinates.right)
			
		End if 
		
		// Calculate the cumulative shift
		If ($e.spacing=0)
			
			Case of 
					
					//_______________________________
				: ($o.type=Object type push button:K79:16)\
					 || ($o.type=Object type 3D button:K79:17)
					
					$e.start:=$o.coordinates.left-(Is macOS:C1572 ? 20 : 20)
					
					//_______________________________
				Else 
					
					$e.start:=$o.coordinates.left
					
					//_______________________________
			End case 
			
		Else 
			
			$e.start:=$o.coordinates.left-$e.spacing
			
		End if 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Center all members on the first
Function center($horizontally : Boolean; $vertically : Boolean)
	
	var $middle : Integer
	var $member : Object
	var $members : Collection
	var $coordinates : cs:C1710.coord
	var $dimensions : cs:C1710.dim
	
	// The reference is the first member of the group
	// So we remove it and get its median position.
	$members:=This:C1470.members.copy()
	$member:=$members.shift()
	$middle:=$member.coordinates.left+($member.dimensions.width\2)
	
	If ($horizontally)
		
		For each ($member; $members)
			
			$coordinates:=$member.coordinates
			$dimensions:=$member.dimensions
			
			$coordinates.left:=$middle-($dimensions.width\2)
			$coordinates.right:=$coordinates.left+$dimensions.width
			
			$member.setCoordinates($coordinates)
			
		End for each 
	End if 
	
	If ($vertically)
		
		// TODO: Vertical if I need it ;-)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Performs a centered alignment of the elements according to their best size
	
.centerVertically({obj})
	
The optional widget name parameter allow to specify the reference
If ommited, the distribution is relative to the form
**/
Function centerVertically($reference : Text) : cs:C1710.groupDelegate
	
	var $bottom; $height; $left; $middle; $right; $top; $width : Integer
	var $o : cs:C1710.staticDelegate
	
	If (Count parameters:C259>=1)
		
		OBJECT GET COORDINATES:C663(*; $reference; $left; $top; $right; $bottom)
		$middle:=($right-$left)\2
		
	Else 
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		$middle:=$width\2
		
	End if 
	
	For each ($o; This:C1470.members)
		
		OBJECT GET COORDINATES:C663(*; $o.name; $left; $top; $right; $bottom)
		$width:=$right-$left
		$left:=$middle-($width\2)
		$right:=$left+$width
		OBJECT SET COORDINATES:C1248(*; $o.name; $left; $top; $right; $bottom)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignLeft($reference) : cs:C1710.groupDelegate
	
	var $left : Integer
	var $o : cs:C1710.staticDelegate
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is object:K8:27)
				
				// We assume it is from the static class (or extend)
				// #TO_DO: test the class
				$left:=$reference.updateCoordinates().coordinates.left
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is integer:K8:5)\
				 | (Value type:C1509($reference)=Is real:K8:4)
				
				$left:=$reference
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is text:K8:3)
				
				$left:=cs:C1710.staticDelegate.new($reference).coordinates.left
				
				//______________________________________________________
			Else 
				
				// #ERROR
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Default reference is the first member of the group
		$left:=This:C1470.members[0].updateCoordinates().coordinates.left
		
	End if 
	
	For each ($o; This:C1470.members)
		
		$o.moveHorizontally($left-$o.coordinates.left)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignRight($reference) : cs:C1710.groupDelegate
	
	var $right : Integer
	var $o : cs:C1710.staticDelegate
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is object:K8:27)
				
				// We assume it is from the static class (or extend)
				// #TO_DO: test the class
				$right:=$reference.updateCoordinates().coordinates.right
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is integer:K8:5)\
				 | (Value type:C1509($reference)=Is real:K8:4)
				
				$right:=$reference
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is text:K8:3)
				
				$right:=cs:C1710.staticDelegate.new($reference).coordinates.right
				
				//______________________________________________________
			Else 
				
				// #ERROR
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Default reference is the first member of the group
		$right:=This:C1470.members[0].updateCoordinates().coordinates.right
		
	End if 
	
	For each ($o; This:C1470.members)
		
		$o.moveHorizontally($right-$o.coordinates.right)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function show($visible : Boolean) : cs:C1710.groupDelegate
	
	var $o : cs:C1710.staticDelegate
	
	$visible:=Count parameters:C259=0 ? True:C214 : $visible
	
	For each ($o; This:C1470.members)
		
		$o.show($visible)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hide() : cs:C1710.groupDelegate
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.hide()
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function enable($enabled : Boolean) : cs:C1710.groupDelegate
	
	var $o : cs:C1710.staticDelegate
	
	$enabled:=Count parameters:C259=0 ? True:C214 : $enabled
	
	For each ($o; This:C1470.members)
		
		If ($o.type=Object type subform:K79:40)
			
			If ($enabled)
				
				$o.enable()
				
			Else 
				
				$o.disable()
				
			End if 
			
		Else 
			
			$o.enable($enabled)
			
		End if 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function disable() : cs:C1710.groupDelegate
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.disable()
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setFontStyle($style : Integer) : cs:C1710.groupDelegate
	
	var $o : cs:C1710.staticDelegate
	
	For each ($o; This:C1470.members)
		
		$o.setFontStyle()
		
	End for each 
	
	return This:C1470