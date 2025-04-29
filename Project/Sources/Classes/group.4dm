/*
A group is a collection of static or active objects

You can define it by passing N objects as parameters
--> cs.group.new(object1, object2, …, objectN)

or a collection of objects (could be a group)
--> cs.group.new(object collection)    

or a comma separated list of object names
--> cs.group.new("name1,name2,…,nameN")
in this case, all named objects are initialized with widget class

*/

property type : Integer:=Object type group:K79:22
property members:=[]

/*
The user data can be anything you want to attach to the group.
The .data property is used to get or set this data.
*/
property _data

property __CLASS__ : 4D:C1709.Class

Class constructor($member : Variant;  ... )
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	var $countParameters:=Count parameters:C259
	
	Case of 
			
			// ___________________________
		: ($countParameters=0)
			
			// <NOTHING MORE TO DO>
			
			// ___________________________
		: (Value type:C1509($member)=Is collection:K8:32)
			
			// TODO: Manage non widget collections
			This:C1470.members:=$member
			
			// ___________________________
		: (Value type:C1509($member)=Is object:K8:27)  // 1 to N objects (could be groups)
			
			var $i : Integer
			For ($i; 1; $countParameters; 1)
				
				This:C1470.add(${$i})
				
			End for 
			
			// ___________________________
		: (Value type:C1509($member)=Is text:K8:3)
			
			var $lastParam : Text:=Try(String:C10(${$countParameters}))
			
			Case of 
					//______________________________________________________
				: ($countParameters=2)\
					 && (Split string:C1554($member; ",").length>1)  // Comma separated list with type
					
					This:C1470.add($member; String:C10($2))
					
					//______________________________________________________
				: ($countParameters=2)\
					 && (Match regex:C1019("(?m-si)^@|@$"; $member; 1))  // Name motif
					
					If (Length:C16($lastParam)>0)\
						 && (Try(OB Class:C1730(cs:C1710[$lastParam])#Null:C1517))
						
						This:C1470.add($member; $lastParam)
						
					End if 
					
					//______________________________________________________
				: ($countParameters>=2)
					
					If (Length:C16($lastParam)>0)\
						 && (Try(OB Class:C1730(cs:C1710[$lastParam])#Null:C1517))  // The last parameter is the type
						
						For ($i; 1; $countParameters-1; 1)
							
							This:C1470.add(${$i}; $lastParam)
							
						End for 
						
					Else 
						
						For ($i; 1; $countParameters; 1)
							
							This:C1470.add(${$i})
							
						End for 
					End if 
					
					//______________________________________________________
				Else 
					
					This:C1470.add($member)
					
					//______________________________________________________
			End case 
			
			// ___________________________
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
/** 
Add one or more members to a group
	
.add([widget collection])
	
or
	
.add([group])
	
or
	
.add([widget)
	
or
	
.add("Comma separated list of object names" {; widget_type})
	
or
	
.add("prefix@" {; widget_type})
	
or
	
.add("@suffix" {; widget_type})
	
*/
Function add($member; $as : Text) : cs:C1710.group
	
	$as:=$as || "static"  // Default is widget
	var $type:=Value type:C1509($member)
	
	Case of 
			
			// ___________________________
		: ($type=Is collection:K8:32)
			
			This:C1470.members:=This:C1470.members.combine($member)
			
			// ___________________________
		: ($type=Is object:K8:27)
			
			If (OB Instance of:C1731($member; cs:C1710.group))
				
				This:C1470.members:=This:C1470.members.combine($member.members)
				
			Else 
				
				This:C1470.members.push($member)
				
			End if 
			
			// ___________________________
		: ($type=Is text:K8:3)
			
			If (Match regex:C1019("(?m-si)^@|@$"; $member; 1))
				
				ARRAY TEXT:C222($_widgets; 0x0000)
				FORM GET OBJECTS:C898($_widgets)
				SORT ARRAY:C229($_widgets)  // ⚠️ Members will be added in alphabetical order
				
				var $i : Integer
				For ($i; 1; Size of array:C274($_widgets); 1)
					
					If ($_widgets{$i}=$member)
						
						This:C1470.members.push(cs:C1710[$as].new($_widgets{$i}))
						
					End if 
				End for 
				
			Else 
				
				// Comma separated list of object names
				var $c:=Split string:C1554($member; ",")
				
				If ($c.length>1)
					
					var $t : Text
					For each ($t; $c)
						
						This:C1470.members.push(cs:C1710[$as].new($t))
						
					End for each 
					
				Else 
					
					This:C1470.members.push(cs:C1710[$as].new($member))  // Widget by default
					
				End if 
			End if 
			
			// ___________________________
		Else 
			
			ASSERT:C1129(False:C215; "Bad parameter type")
			
			// ___________________________
	End case 
	
	// Avoid Null members
	This:C1470.members:=This:C1470.members.filter(Formula:C1597($1.value#Null:C1517))
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Returns True if the passed object or object name is part of the group
	
.belongsTo(obj) --> bool
	
or
	
.belongsTo("name") --> bool
	
*/
Function belongsTo($widget) : Boolean
	
	var $type:=Value type:C1509($widget)
	
	Case of 
			
			// ______________________________________________________
		: ($type=Is object:K8:27)
			
			return This:C1470.members.includes($widget)
			
			// ______________________________________________________
		: ($type=Is text:K8:3)
			
			return This:C1470.members.query("name=:1"; $widget).pop()#Null:C1517
			
			// ______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unmanaged parameter type")
			
			// ______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
Returns the coordinates of the rectangle surrounding the group,
with optional horizontal and vertical space.
*/
Function enclosingRect($gap : Integer) : Object
	
	var $bottom; $left; $right; $top : Integer
	var $coordinates : Object
	var $member : cs:C1710.static
	
	If (This:C1470.members.length=0)
		
		return {left: 0; top: 0; right: 0; bottom: $bottom}
		
	End if 
	
	For each ($member; This:C1470.members)
		
		OBJECT GET COORDINATES:C663(*; $member.name; $left; $top; $right; $bottom)
		
		If ($coordinates=Null:C1517)
			
			$coordinates:={\
				left: $left; \
				top: $top; \
				right: $right; \
				bottom: $bottom; \
				width: 0; \
				height: 0}
			
		Else 
			
			$coordinates.left:=$left<$coordinates.left ? $left : $coordinates.left
			$coordinates.top:=$top<$coordinates.top ? $top : $coordinates.top
			$coordinates.right:=$right>$coordinates.right ? $right : $coordinates.right
			$coordinates.bottom:=$bottom>$coordinates.bottom ? $bottom : $coordinates.bottom
			
		End if 
	End for each 
	
	If ($coordinates#Null:C1517)
		
		$coordinates.left-=$gap
		$coordinates.top-=$gap
		$coordinates.right+=$gap
		$coordinates.bottom+=$gap
		
		$coordinates.width:=$coordinates.right-$coordinates.left
		$coordinates.height:=$coordinates.bottom-$coordinates.top
		
	End if 
	
	return $coordinates
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveVertically($offset : Integer)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveVertically($offset)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveUp($offset : Integer)
	
	This:C1470.moveVertically(-Abs:C99($offset))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveDown($offset : Integer)
	
	This:C1470.moveVertically(Abs:C99($offset))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hiddenFromView()
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.hiddenFromView()
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function move($moveH : Integer; $moveV : Integer)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveHorizontally($moveH)
		$member.moveVertically($moveV)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveHorizontally($offset : Integer)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveHorizontally($offset)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveLeft($offset : Integer)
	
	This:C1470.moveHorizontally(-Abs:C99($offset))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveRight($offset : Integer)
	
	This:C1470.moveHorizontally(Abs:C99($offset))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function moveAndResizeHorizontally($offset : Integer; $resize : Integer)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveHorizontally($offset)
		$member.resizeHorizontally($resize)
		
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
	
*/
Function distributeLeftToRight($params : Object) : cs:C1710.group
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0; minWidth: 0; maxWidth: 0}; $params)
	$e.alignment:=Align left:K42:2
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.bestSize($e)
		
		If ($e.start#0)
			
			$member.moveHorizontally($e.start-$member._coordinates.left)
			
		End if 
		
		// Calculate the cumulative shift
		$e.start:=$member._coordinates.right
		
		If ($e.spacing=0)
			
			Case of 
					
					// _______________________________
				: ($member.type=Object type push button:K79:16)\
					 || ($member.type=Object type 3D button:K79:17)
					
					$e.start+=(Is macOS:C1572 ? 20 : 20)
					
					// _______________________________
				: ($member.type=Object type line:K79:33)
					
					$e.start+=(Is macOS:C1572 ? 40 : 20)
					
					// _______________________________
			End case 
			
		Else 
			
			Case of 
					
					// _______________________________
				: ($member.type=Object type line:K79:33)
					
					$e.start+=(Is macOS:C1572 ? 10 : 10)
					
					// _______________________________
				Else 
					
					$e.start+=$e.spacing
					
					// _______________________________
			End case 
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
	
*/
Function distributeRigthToLeft($params : Object) : cs:C1710.group
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0; minWidth: 0; maxWidth: 0}; $params)
	$e.alignment:=Align right:K42:4
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.bestSize($e)
		
		If ($e.start#0)
			
			$member.moveHorizontally($e.start-$member._coordinates.right)
			
		End if 
		
		// Calculate the cumulative shift
		$e.start:=$member._coordinates.left
		
		If ($e.spacing=0)
			
			Case of 
					
					// _______________________________
				: ($member.type=Object type push button:K79:16)\
					 || ($member.type=Object type 3D button:K79:17)
					
					$e.start-=(Is macOS:C1572 ? 20 : 20)
					
					// _______________________________
			End case 
			
		Else 
			
			$e.start-=$e.spacing
			
		End if 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function distributeAroundCenter($params : Object) : cs:C1710.group
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0}; $params)
	var $currentWidth : Integer:=This:C1470.enclosingRect().width
	
	This:C1470.distributeLeftToRight($e)
	
	var $newWidth : Integer:=This:C1470.enclosingRect().width
	var $offset:=Round:C94(($currentWidth-$newWidth)/2; 0)
	
	This:C1470.moveHorizontally($offset)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function distributeVertically($params : Object) : cs:C1710.group
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0}; $params)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		If ($e.start#0)
			
			$member.moveVertically($e.start-$member._coordinates.top)
			
		End if 
		
		$e.start:=$member._coordinates.bottom
		$e.start+=$e.spacing
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function distributeHorizontally($params : Object) : cs:C1710.group
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0}; $params)
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.bestSize()
		
		If ($e.start#0)
			
			$member.moveHorizontally($e.start-$member._coordinates.left)
			
		End if 
		
		$e.start:=$member._coordinates.right
		$e.start+=$e.spacing
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function verticallyCentered($params : Object; $reference : Text) : cs:C1710.group
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0}; $params)
	
	This:C1470.distributeVertically($params)
	
	$reference:=$reference || String:C10($params.to)
	
	If (Length:C16($reference)>0)
		
		OBJECT GET COORDINATES:C663(*; $reference; $left; $top; $right; $bottom)
		$height:=$bottom-$top
		
	Else 
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		
	End if 
	
	This:C1470.moveVertically(($height-This:C1470.enclosingRect().height)\2)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function horizontallyCentered($params : Object; $reference : Text) : cs:C1710.group
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	
	var $e:=This:C1470._userOptions({start: 0; spacing: 0}; $params)
	
	This:C1470.distributeHorizontally($params)
	
	$reference:=$reference || String:C10($params.to)
	
	If (Length:C16($reference)>0)
		
		OBJECT GET COORDINATES:C663(*; $reference; $left; $top; $right; $bottom)
		$width:=$right-$left
		
	Else 
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		
	End if 
	
	This:C1470.moveHorizontally(($width-This:C1470.enclosingRect().width)\2)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
/**
This function reverses the horizontal order of the members
useful, for example, for reversing the OK and Cancel buttons depending on the platform
*/
Function switch($updateEntryOrder : Boolean) : cs:C1710.group
	
	var $c : Collection:=This:C1470.members.orderBy("left")
	
	// TODO: Manage more than 2 widgets
	ASSERT:C1129(This:C1470.members.length=2; Current method name:C684+": Available only for a group of 2 widgets")
	
	// TODO: Check if they are buttons
	
	// 1st get spacing
	var $left; $right : Integer
	var $member : cs:C1710.static
	For each ($member; $c)
		
		If ($left=0)
			
			$left:=$member.left
			$right:=$member.right
			
			continue
			
		End if 
		
		var $spacing : Integer:=$member.left-$right
		
		break
		
	End for each 
	
	For each ($member; $c.reverse())
		
		var $width:=$member.width
		$member.left:=$left
		$member.width:=$width
		$left+=$width+$spacing
		
	End for each 
	
	If ($updateEntryOrder)
		
		ARRAY TEXT:C222($widgets; 0x0000)
		FORM GET OBJECTS:C898($widgets)
		
		ARRAY TEXT:C222($entryOrders; 0x0000)
		FORM GET ENTRY ORDER:C1469($entryOrders; *)
		
		var $indx:=Find in array:C230($entryOrders; This:C1470.members[1].name)
		
		If ($indx>0)
			
			DELETE FROM ARRAY:C228($entryOrders; $indx)
			APPEND TO ARRAY:C911($entryOrders; This:C1470.members[1].name)
			
		End if 
		
		$indx:=Find in array:C230($entryOrders; This:C1470.members[0].name)
		DELETE FROM ARRAY:C228($entryOrders; $indx)
		INSERT IN ARRAY:C227($entryOrders; 1)
		$entryOrders{1}:=This:C1470.members[0].name
		
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Center all members on the first
Function center($horizontally : Boolean; $vertically : Boolean)
	
	var $coordinates : cs:C1710.coordinates
	var $rect : cs:C1710.rect
	
	// The reference is the first member of the group
	// So we remove it and get its median position.
	var $members:=This:C1470.members.copy()
	var $member : cs:C1710.static:=$members.shift()
	
	var $middle : Integer:=$member.coordinates.left+($member.rect.width\2)
	
	If ($horizontally)
		
		For each ($member; $members)
			
			$coordinates:=$member.coordinates
			$rect:=$member.rect
			
			$coordinates.left:=$middle-($rect.width\2)
			$coordinates.right:=$coordinates.left+$rect.width
			
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
*/
Function centerVertically($reference : Text) : cs:C1710.group
	
	var $bottom; $left; $right; $top : Integer
	var $height; $middle; $width : Integer
	
	If (Count parameters:C259>=1)
		
		OBJECT GET COORDINATES:C663(*; $reference; $left; $top; $right; $bottom)
		$middle:=($right-$left)\2
		
	Else 
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
		$middle:=$width\2
		
	End if 
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		OBJECT GET COORDINATES:C663(*; $member.name; $left; $top; $right; $bottom)
		$width:=$right-$left
		$left:=$middle-($width\2)
		$right:=$left+$width
		OBJECT SET COORDINATES:C1248(*; $member.name; $left; $top; $right; $bottom)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignLeft($reference) : cs:C1710.group
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is object:K8:27)
				
				// We assume it is from the static class (or extend)
				// TODO: test the class
				$left:=$reference.updateCoordinates().coordinates.left
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is integer:K8:5)\
				 | (Value type:C1509($reference)=Is real:K8:4)  // The left position to use
				
				$left:=$reference
				
				//______________________________________________________
			: (Value type:C1509($reference)=Is text:K8:3)  // The name of  widget
				
				$left:=cs:C1710.static.new($reference).coordinates.left
				
				//______________________________________________________
			Else 
				
				var $left : Integer  // #ERROR
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Default reference is the first member of the group
		$left:=This:C1470.members[0].updateCoordinates().coordinates.left
		
	End if 
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveHorizontally($left-$member.coordinates.left)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function alignRight($reference) : cs:C1710.group
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				// ______________________________________________________
			: (Value type:C1509($reference)=Is object:K8:27)
				
				// We assume it is from the static class (or extend)
				// #TO_DO: test the class
				$right:=$reference.updateCoordinates().coordinates.right
				
				// ______________________________________________________
			: (Value type:C1509($reference)=Is integer:K8:5)\
				 | (Value type:C1509($reference)=Is real:K8:4)
				
				$right:=$reference
				
				// ______________________________________________________
			: (Value type:C1509($reference)=Is text:K8:3)
				
				$right:=cs:C1710.static.new($reference).coordinates.right
				
				// ______________________________________________________
			Else 
				
				var $right : Integer  // #ERROR
				
				// ______________________________________________________
		End case 
		
	Else 
		
		// Default reference is the first member of the group
		$right:=This:C1470.members[0].updateCoordinates().coordinates.right
		
	End if 
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.moveHorizontally($right-$member.coordinates.right)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function show($visible : Boolean) : cs:C1710.group
	
	$visible:=Count parameters:C259=0 ? True:C214 : $visible
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.show($visible)
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hide() : cs:C1710.group
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.hide()
		
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function enable($enabled : Boolean) : cs:C1710.group
	
	$enabled:=Count parameters:C259=0 ? True:C214 : $enabled
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		Case of 
				
				// ______________________________________________________
			: ($member.type=Object type static text:K79:2)
				
				$member.restoreForegroundColor()
				
				// ______________________________________________________
			: ($member.type=Object type subform:K79:40)
				
				If ($enabled)
					
					$member.enable()
					
				Else 
					
					$member.disable()
					
				End if 
				
				// ______________________________________________________
			Else 
				
				$member.enable($enabled)
				
				// ______________________________________________________
		End case 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function disable() : cs:C1710.group
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		If ($member.type=Object type static text:K79:2)
			
			$member.foregroundColor:=Dark shadow color:K23:3
			
		Else 
			
			$member.disable()
			
		End if 
	End for each 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setFontStyle($style : Integer) : cs:C1710.group
	
	var $member : cs:C1710.static
	For each ($member; This:C1470.members)
		
		$member.setFontStyle()
		
	End for each 
	
	return This:C1470
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _userOptions($e : Object; $user : Object) : Object
	
	If ($user=Null:C1517)
		
		return $e
		
	End if 
	
	var $key : Text
	For each ($key; $user)
		
		If ($user[$key]#Null:C1517)
			
			$e[$key]:=Num:C11($user[$key])
			
		End if 
	End for each 
	
	return $e