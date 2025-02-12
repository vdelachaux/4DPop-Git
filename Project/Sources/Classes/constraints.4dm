property rules : Collection

property scrollBarWidth; marginV; marginH; labelMargin; offset : Integer
property _matrix : Boolean

Class constructor($metrics : Object)
	
	This:C1470.rules:=[]
	
	This:C1470.scrollBarWidth:=$metrics.scrollBarWidth || Is macOS:C1572 ? 15 : 15
	This:C1470.marginV:=$metrics.marginV || Is macOS:C1572 ? 2 : 2
	This:C1470.marginH:=$metrics.marginH || Is macOS:C1572 ? 20 : 20
	
	This:C1470.labelMargin:=Is macOS:C1572 ? 10 : 10
	This:C1470.offset:=2
	
	This:C1470._matrix:=Not:C34(Is compiled mode:C492)  // True if Dev mode
	
	// MARK:-[KEYWORDS]
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get centerHorizontally() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="horizontal-alignment"
	$rule.alignment:="center"
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function horizontallyCentered() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="horizontal-alignment"
	$rule.alignment:="center"
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get alignLeft() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="horizontal-alignment"
	$rule.alignment:="left"
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get alignRight() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="horizontal-alignment"
	$rule.alignment:="right"
	
	return This:C1470
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set mininimumWidth($value : Integer)
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="minimum-width"
	$rule.value:=$value
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set maximumWidth($value : Integer)
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="maximum-width"
	$rule.value:=$value
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function tile($value : Real) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="tile"
	$rule.value:=$value
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function marginLeft($value : Integer) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="margin"
	$rule.alignment:="left"
	$rule.margin:=$value
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function horizontalLeftOffset($value : Integer) : cs:C1710.constraints
	
	return This:C1470.marginLeft($value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function marginRight($value : Integer) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="margin"
	$rule.alignment:="right"
	$rule.margin:=$value
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function horizontalRightOffset($value : Integer) : cs:C1710.constraints
	
	return This:C1470.marginRight($value)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function autoHorizontalOffset() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="margin"
	$rule.alignment:="auto"
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function anchorLeft($value : Integer) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="left"
	$rule.margin:=$value
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get anchoredOnTheLeft() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="left"
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function anchorRight($value : Integer) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="right"
	$rule.margin:=$value
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get anchoredOnTheRight() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="right"
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function anchorCenter() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="center"
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get anchoredInTheCenter() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="anchor"
	$rule.alignment:="center"
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fitWidth($value : Integer) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="fit-width"
	$rule.margin:=$value
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fullWidth() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.type:="fit-width"
	$rule.margin:=0
	
	return This:C1470
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get inline() : cs:C1710.constraints
	
	This:C1470._latest().type:="inline"
	
	return This:C1470
	
	// MARK:-New rule creation (Alias)
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function new($rule) : cs:C1710.constraints
	
	var $name : Text
	var $o : Object
	
	If (Value type:C1509($rule)=Is object:K8:27)\
		 && ($rule.set#Null:C1517)  // Multi targets
		
		$name:=This:C1470._getName($rule.target)
		
		For each ($o; $rule.set)
			
			$o.target:=$name
			
			If ($o.reference#Null:C1517)
				
				$o.reference:=This:C1470._getName($o.reference)
				
			End if 
			
			This:C1470.rules.push($o)
			
		End for each 
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($rule)=Is text:K8:3)  // Widget name
				
				$rule:={\
					target: $rule; \
					targetIsAGroup: False:C215\
					}
				
				//______________________________________________________
			: (Value type:C1509($rule)=Is object:K8:27)  // Group or Widget
				
				If (OB Instance of:C1731($rule; cs:C1710.group))
					
					$rule:={\
						target: $rule; \
						targetIsAGroup: True:C214\
						}
					
				Else 
					
					$o:=OB Copy:C1225($rule)
					
					$rule:={\
						target: $o.name; \
						targetIsAGroup: False:C215\
						}
					
					var $key : Text
					For each ($key; $o)
						
						$rule[$key]:=$o[$key]
						
					End for each 
					
				End if 
				
				//______________________________________________________
			: (Value type:C1509($rule.target)=Is object:K8:27)\
				 && (OB Instance of:C1731($rule.target; cs:C1710.group))  // Group
				
				$rule.targetIsAGroup:=True:C214
				
				//______________________________________________________
			Else 
				
				$rule.targetIsAGroup:=False:C215
				$rule.target:=This:C1470._getName($rule.target)
				
				//______________________________________________________
		End case 
		
		If ($rule.reference#Null:C1517)
			
			$rule.reference:=This:C1470._target($rule.reference)
			
		End if 
		
		This:C1470.rules.push($rule)
		
	End if 
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function add($rule) : cs:C1710.constraints
	
	return This:C1470.new($rule)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function oneShot($rule) : cs:C1710.constraints
	
	This:C1470.new($rule)
	This:C1470._latest().toDelete:=True:C214
	return This:C1470
	
	// MARK:-Set the reference
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function of($target) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.reference:=This:C1470._target($target)
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function with($target) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.reference:=This:C1470._target($target)
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function on($target) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	
	If ($rule.type="tile")
		
		$rule.parent:=This:C1470._target($target)
		
	Else 
		
		$rule.reference:=This:C1470._target($target)
		
	End if 
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function in($target) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.reference:=This:C1470._target($target)
	
	return This:C1470
	
	// [Alias] === === === === === === === === === === === === === === === === === === === === === === === ===
Function ref($target) : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.reference:=This:C1470._target($target)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onViewport() : cs:C1710.constraints
	
	var $rule : Object:=This:C1470._latest()
	$rule.reference:=Null:C1517
	
	return This:C1470
	
	// MARK:-Processing
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Dealing with constraints
Function apply()
	
	var $offset : Real
	var $alignment; $name : Text
	var $horizontal; $vertical : Boolean
	var $height; $max; $type; $width : Integer
	var $rule : Object
	var $targets : Collection
	var $cur; $ref; $viewport : cs:C1710.coord
	
	If (This:C1470.rules.length=0)
		
		// <NOTHING MORE TO DO>
		return 
		
	End if 
	
	// Get the viewport
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	$viewport:=cs:C1710.coord.new(0; 0; $width; $height)
	
	For each ($rule; This:C1470.rules)
		
		If ($rule.formula#Null:C1517)\
			 && (OB Instance of:C1731($rule.formula; 4D:C1709.Function))
			
			$rule.formula.call(Null:C1517)
			continue
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: ($rule.targetIsAGroup)
				
				$targets:=[""]
				
				//______________________________________________________
			: (Value type:C1509($rule.target)=Is object:K8:27)\
				 && ($rule.target.name#Null:C1517)  // widget
				
				$targets:=[$rule.target.name]
				
				//______________________________________________________
			: (Value type:C1509($rule.target)=Is collection:K8:32)
				
				$targets:=$rule.target
				
				//______________________________________________________
			: (Value type:C1509($rule.target)=Is text:K8:3)
				
				// Can be a comma-separated list of object names
				$targets:=Split string:C1554($rule.target; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(This:C1470._matrix; "rule.target should be a Text or a collection")
				continue
				
				//______________________________________________________
		End case 
		
		If ($targets.length=0)
			
			continue
			
		End if 
		
		For each ($name; $targets)
			
			If ($rule.targetIsAGroup)
				
				// Retrieve the stored coordinates, or calculate them for the first call, from the bounding box...
				$cur:=cs:C1710.coord.new($rule.target.boundingBox || $rule.target.enclosingRect())
				
			Else 
				
				$type:=OBJECT Get type:C1300(*; $name)
				
				If ($type=Object type unknown:K79:1)
					
					ASSERT:C1129(This:C1470._matrix; "Unknown object name:"+$name)
					continue
					
				End if 
				
				$cur:=cs:C1710.coord.new($name)
				
			End if 
			
			// Reference object
			If ($rule.reference#Null:C1517)
				
				$ref:=cs:C1710.coord.new($rule.reference)
				
			Else 
				
				// The reference is the viewport
				$ref:=$viewport
				
				// FIXME:For a sub-form, determine whether there is a vertical scroll bar.
				// This is a property of the container…
				//$ref.right-=This.scrollBarWidth
				
			End if 
			
			Case of 
					
					//______________________________________________________
					// Defines the right edge of an element as a percentage of the reference or the form width
				: ($rule.type="right")  // Set the right edge in percent of the reference
					
					// MARK:right
					$width:=$ref.width*($rule.value<1 ? $rule.value : $rule.value/100)
					$width-=$cur.left
					$cur.right:=$cur.left+$width
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type text input:K79:4)
							
							// The scrollbar is outside
							OBJECT GET SCROLLBAR:C1076(*; $name; $horizontal; $vertical)
							
							If ($vertical)
								
								$cur.right-=This:C1470.scrollBarWidth
								
							End if 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type picture input:K79:5)
							
							$cur.right+=This:C1470.offset
							
							//……………………………………………………………………………………………………………
						: ($type=Object type rectangle:K79:32)
							
							$cur.right+=(This:C1470.offset*2)
							
							//……………………………………………………………………………………………………………
						: ($type=Object type popup dropdown list:K79:13)
							
							$cur.right+=5
							
							//……………………………………………………………………………………………………………
					End case 
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
					// Defines the left edge of an element as a percentage of the reference or the form width
				: ($rule.type="left")  // Set the left edge in percent of the reference
					
					// MARK:left
					$width:=$cur.width
					$cur.left:=$ref.width*($rule.value<1 ? $rule.value : $rule.value/100)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type text input:K79:4)
							
							// The scrollbar is outside
							OBJECT GET SCROLLBAR:C1076(*; $name; $horizontal; $vertical)
							
							If ($vertical)
								
								$cur.left-=This:C1470.scrollBarWidth
								
							End if 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type picture input:K79:5)
							
							$cur.left+=This:C1470.offset
							
							//……………………………………………………………………………………………………………
						: ($type=Object type rectangle:K79:32)
							
							$cur.left+=(This:C1470.offset*2)
							
							//……………………………………………………………………………………………………………
						: ($type=Object type popup dropdown list:K79:13)
							
							$cur.left+=5
							
							//……………………………………………………………………………………………………………
					End case 
					
					$cur.right:=$cur.left+$width
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
				: ($rule.type="minimum-width")  // Minimum object width
					
					// MARK:minimum-width
					$width:=Num:C11($rule.value)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type popup dropdown list:K79:13)
							
							$width+=4
							
							//……………………………………………………………………………………………………………
					End case 
					
					If ($cur.width<$width)
						
						$cur.right:=$cur.left+$width
						$cur.apply()
						
					End if 
					
					//______________________________________________________
				: ($rule.type="maximum-width")  // Maximum object width
					
					// MARK:maximum-width
					$width:=Num:C11($rule.value)
					
					Case of 
							
							//……………………………………………………………………………………………………………
						: ($type=Object type popup dropdown list:K79:13)
							
							$width+=4
							
							//……………………………………………………………………………………………………………
					End case 
					
					If ($cur.width>$width)
						
						$cur.right:=$cur.left+$width
						$cur.apply()
						
					End if 
					
					//______________________________________________________
				: ($rule.type="fit-width")  // Adjust width to reference width minus offset if any
					
					// MARK:fit-width
					$cur.right:=$cur.left+($ref.right-$cur.left)-($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
					$cur.apply()
					
					//______________________________________________________
				: ($rule.type="margin")  // Horizontal offset
					
					// MARK:margin
					$alignment:=String:C10($rule.alignment)
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($alignment="auto")  // Center objects vertically
							
							$offset:=($ref.width-$cur.width)/2
							
							If ($offset>0)
								
								$width:=$cur.width
								$cur.left:=$ref.left+$offset
								$cur.right:=$cur.left+$width
								
							End if 
							
							//……………………………………………………………………………………………
						: ($alignment="left")  // Horizontal offset from left side of reference
							
							$width:=$cur.width
							$cur.left:=$ref.right+($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
							$cur.right:=$cur.left+$width
							
							//……………………………………………………………………………………………
						: ($alignment="right")  // Horizontal offset from right side of reference
							
							$cur.right:=$ref.left-($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
							
							//……………………………………………………………………………………………
					End case 
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
				: ($rule.type="horizontal-alignment")
					
					// MARK:horizontal-alignment
					$alignment:=String:C10($rule.alignment)
					
					If ($rule.targetIsAGroup)
						
						Case of 
								
								//……………………………………………………………………………………………
							: ($alignment="center")  // Center objects vertically
								
								// Getting the middle
								var $middle : Integer
								$middle:=$cur.width\2
								
								// Move the group
								$rule.target.moveHorizontally($ref.left+($ref.width\2)-($cur.left+$middle))
								
								//……………………………………………………………………………………………
							Else 
								
								ASSERT:C1129(False:C215; "TODO: manage "+$alignment+" for a group")
								
								//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
						End case 
						
						// Keep new coordinates of the bounding box
						$rule.target.boundingBox:=$rule.target.enclosingRect()
						
						continue
						
					End if 
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($alignment="center")  // Center objects vertically
							
							$offset:=(($ref.width/2)+$ref.left)-(($cur.width/2)+$cur.left)
							$cur.left+=$offset
							$cur.right+=$offset
							
							//……………………………………………………………………………………………
						: ($alignment="left")  // Keep objects aligned on the left
							
							$width:=$cur.width
							$cur.left:=$ref.left+($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
							$cur.right:=$cur.left+$width
							
							//……………………………………………………………………………………………
						: ($alignment="right")  // Keep objects aligned on the right
							
							$width:=$cur.width
							$cur.right:=$ref.right-($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
							$cur.left:=$cur.right-$width
							
							//……………………………………………………………………………………………
					End case 
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
				: ($rule.type="vertical-alignment")
					
					// TODO:Vertical alignment
					
					//______________________________________________________
				: ($rule.type="anchor")
					
					// MARK:anchor
					$alignment:=String:C10($rule.alignment)
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($alignment="center")  // Center objects vertically
							
							$offset:=(($ref.width/2)+$ref.left)-(($cur.width/2)+$cur.left)
							$cur.left+=$offset
							$cur.right+=$offset
							
							//……………………………………………………………………………………………
						: ($alignment="left")  // Keep objects aligned on the left
							
							$width:=$cur.width
							$cur.left:=$ref.left+Num:C11($rule.margin)
							$cur.right:=$cur.left+$width
							
							//……………………………………………………………………………………………
						: ($alignment="right")  // Keep objects aligned on the right
							
							$width:=$cur.width
							$cur.right:=$ref.right-Num:C11($rule.margin)
							$cur.left:=$cur.right-$width
							
							//……………………………………………………………………………………………
					End case 
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
				: ($rule.type="inline")
					
					// MARK:inline
					If ($rule.reference=Null:C1517)
						
						ASSERT:C1129(This:C1470._matrix; "Do not omit reference!")
						continue
						
					End if 
					
					$width:=$cur.width
					$cur.left:=$ref.left+$ref.width+($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.offset)
					$cur.right:=$cur.left+$width
					$cur.apply()
					
					//______________________________________________________
				: ($rule.type="tile")  // Set width as percent of the reference
					
					// MARK:tile
					// Calculate proportional width
					$width:=Int:C8(($ref.width)*Num:C11($rule.value))
					
					If ($rule.parent#Null:C1517)
						
						// Left is the parent right
						$ref:=cs:C1710.coord.new($rule.parent)
						$cur.left:=$ref.right+Num:C11(OBJECT Get type:C1300(*; $name+".border")#Object type unknown:K79:1)
						
					End if 
					
					$cur.right:=$cur.left+$width
					$cur.apply()
					
					//______________________________________________________
				: ($rule.type="float")
					
					// MARK:float
					$alignment:=String:C10($rule.value)
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($alignment="left")
							
							$width:=$cur.width
							
							$cur.right:=$ref.left-($rule.margin#Null:C1517 ? Num:C11($rule.margin) : This:C1470.marginH)
							$max:=Num:C11($rule.maximum)
							
							If ($max#0)
								
								$cur.right:=$cur.right>$max ? $max : $cur.right
								
							End if 
							
							$cur.left:=$cur.right-$width
							
							//……………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(This:C1470._matrix; "Unmanaged alignment:"+$alignment)
							continue
							
							//……………………………………………………………………………………………
					End case 
					
					$cur.apply()
					
					This:C1470._adjustLabel($name; $rule; $cur)
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(This:C1470._matrix; "Unknown constraint:"+String:C10($rule.type))
					continue
					
					//______________________________________________________
			End case 
			
			// Adjust the border if any
			If (OBJECT Get type:C1300(*; $name+".border")=Object type unknown:K79:1)
				
				continue
				
			End if 
		End for each 
	End for each 
	
	// Delete one-shot rules
	This:C1470.rules:=This:C1470.rules.filter(Formula:C1597($1.result:=Bool:C1537($1.value.toDelete)=False:C215))
	
	// MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _adjustLabel($name : Text; $rule : Object; $cur : cs:C1710.coord)
	
	var $label : cs:C1710.coord
	var $width : Integer
	
	Case of 
			//______________________________________________________
		: ($rule.label#Null:C1517)
			
			$label:=cs:C1710.coord.new($rule.label)
			
			//______________________________________________________
		: (OBJECT Get type:C1300(*; $name+".label")#Object type unknown:K79:1)
			
			$label:=cs:C1710.coord.new($name+".label")
			
			//______________________________________________________
	End case 
	
	If ($label#Null:C1517)
		
		$width:=$label.width
		$label.right:=$cur.left-This:C1470.labelMargin
		$label.left:=$label.right-$width
		$label.apply()
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _latest() : Object
	
	return This:C1470.rules.length>0 ? This:C1470.rules[This:C1470.rules.length-1] : Null:C1517
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _target($target) : Variant
	
	return This:C1470._getName($target)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getName($target) : Text
	
	If (Value type:C1509($target)=Is object:K8:27)\
		 && ($target.name#Null:C1517)  // Widget
		
		return $target.name
		
	Else 
		
		return String:C10($target)
		
	End if 
	