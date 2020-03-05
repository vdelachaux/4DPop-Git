//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : widget
  // ID[1D8DF52FA8C64D7789AF867877A06A13]
  // Created 12-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage widgets
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l;$Lon_bottom;$Lon_height;$Lon_horizontal;$Lon_left;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_type;$Lon_vertical;$Lon_width)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_params)

If (False:C215)
	C_OBJECT:C1216(widget ;$0)
	C_TEXT:C284(widget ;$1)
	C_OBJECT:C1216(widget ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=$1
		
	Else 
		
		  // get the current object
		$t:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	$o:=New object:C1471(\
		"";"widget";\
		"coordinates";Null:C1517;\
		"name";$t;\
		"windowCoordinates";Null:C1517;\
		"action";OBJECT Get action:C1457(*;$t);\
		"type";OBJECT Get type:C1300(*;$t);\
		"bestSize";Formula:C1597(widget ("bestSize";New object:C1471("alignment";$1;"minWidth";$2;"maxWidth";$3)));\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"setColors";Formula:C1597(widget ("setColors";New object:C1471("foreground";$1;"background";$2;"altBackgrnd";$3)));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"setTitle";Formula:C1597(widget ("setTitle";New object:C1471("title";String:C10($1))));\
		"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
		"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
		"title";Formula:C1597(OBJECT Get title:C1068(*;This:C1470.name));\
		"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
		"clear";Formula:C1597(widget ("clear"));\
		"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
		"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
		"enterable";Formula:C1597(OBJECT Get enterable:C1067(*;This:C1470.name));\
		"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
		"distributeHorizontally";Formula:C1597(widget ("distributeHorizontally";$1));\
		"filter";Formula:C1597(OBJECT Get filter:C1073(*;This:C1470.name));\
		"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
		"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
		"forceNumeric";Formula:C1597(widget ("forceNumeric"));\
		"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
		"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
		"setEnterable";Formula:C1597(OBJECT SET ENTERABLE:C238(*;This:C1470.name;Bool:C1537($1)));\
		"setFilter";Formula:C1597(widget ("setFilter";New object:C1471(Choose:C955(Value type:C1509($1)=Is text:K8:3;"value";"format");$1;"separator";$2)));\
		"setValue";Formula:C1597(widget ("setValue";New object:C1471("value";$1)));\
		"touch";Formula:C1597(widget ("touch"));\
		"value";Formula:C1597(widget ("value").value)\
		)
	
	$o.getCoordinates()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="update")  // Update widget definition based on the widget type
			
			$o.getCoordinates()
			
			$Lon_type:=OBJECT Get type:C1300(*;$o.name)
			
			Case of 
					
					  //…………………………………………………………………………………………………
				: ($Lon_type=Object type picture input:K79:5)
					
					$o.getScrollPosition()
					$o.getDimensions()
					
					  //…………………………………………………………………………………………………
				: ($Lon_type=Object type listbox:K79:8)
					
					$o.getDefinition()
					$o.getCell()
					
					  //…………………………………………………………………………………………………
				: ($Lon_type=Object type subform:K79:40)
					
					$o.getSubform()
					
					  //…………………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(False:C215;"Non implemented for: "+String:C10($o._is))
					
					  //…………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($1="distributeHorizontally")  // Distributes widgets, from left to right, to their optimal size
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				$l:=Num:C11($2.start)
				
				For each ($t;$o.name)
					
					  // Get localized width
					OBJECT GET BEST SIZE:C717(*;$t;$Lon_width;$Lon_height)
					
					  // Add 10% for margins
					$Lon_width:=Round:C94($Lon_width*1.1;0)
					
					  // Minimum & maximum width
					$Lon_width:=Choose:C955($Lon_width<Num:C11($2.minWidth);Num:C11($2.minWidth);$Lon_width)
					
					If ($2.maxWidth#Null:C1517)
						
						$Lon_width:=Choose:C955($Lon_width>Num:C11($2.maxWidth);Num:C11($2.maxWidth);$Lon_width)
						
					End if 
					
					  // Get current object coordinates
					OBJECT GET COORDINATES:C663(*;$t;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					
					  // Resize current object
					$Lon_left:=$l
					$Lon_right:=$Lon_left+$Lon_width
					OBJECT SET COORDINATES:C1248(*;$t;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
					
					  // Calculate the cumulative shift
					$l:=$Lon_right+Num:C11($2.gap)
					
				End for each 
				
			Else 
				
				$o.bestSize()
				
			End if 
			
			  //______________________________________________________
		: ($1="getCoordinates")  // Update widget coordinates
			
			OBJECT GET COORDINATES:C663(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			  //______________________________________________________
		: ($1="setCoordinates")
			
			OBJECT GET COORDINATES:C663(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			$Lon_width:=$Lon_right-$Lon_left
			$Lon_height:=$Lon_bottom-$Lon_top
			
			If (Bool:C1537($2.left))
				
				$Lon_left:=Num:C11($2.left)
				
				If (Bool:C1537($2.right))
					
					$Lon_right:=Num:C11($2.right)
					
				Else 
					
					  // Move horizontally
					$Lon_right:=$Lon_left+$Lon_width
					
				End if 
				
			Else 
				
				If (Bool:C1537($2.right))
					
					  // Resize horizontally
					$Lon_right:=Num:C11($2.right)
					
				End if 
			End if 
			
			If (Bool:C1537($2.top))
				
				$Lon_top:=Num:C11($2.top)
				
				If (Bool:C1537($2.bottom))
					
					$Lon_bottom:=Num:C11($2.bottom)
					
				Else 
					
					  // Move vertically
					$Lon_bottom:=$Lon_top+$Lon_height
					
				End if 
				
			Else 
				
				If (Bool:C1537($2.bottom))
					
					  // Resize vertically
					$Lon_bottom:=Num:C11($2.bottom)
					
				End if 
			End if 
			
			OBJECT SET COORDINATES:C1248(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			  //______________________________________________________
		: ($1="getScrollPosition")
			
			OBJECT GET SCROLL POSITION:C1114(*;$o.name;$Lon_vertical;$Lon_horizontal)
			
			$o.scroll:=New object:C1471(\
				"vertical";$Lon_vertical;\
				"horizontal";$Lon_horizontal)
			
			  //______________________________________________________
		: ($1="setScrollPosition")
			
			If ($2.vertical#Null:C1517)
				
				$Lon_vertical:=Num:C11($Obj_params.vertical)
				
			End if 
			
			If ($2.horizontal#Null:C1517)
				
				$Lon_horizontal:=Num:C11($Obj_params.horizontal)
				
			End if 
			
			OBJECT SET SCROLL POSITION:C906(*;$o.name;$Lon_vertical;$Lon_horizontal;*)
			
			$o.scroll:=New object:C1471(\
				"vertical";$Lon_vertical;\
				"horizontal";$Lon_horizontal)
			
			  //______________________________________________________
		: ($1="bestSize")  // Resize the widget to its best size
			
			OBJECT GET COORDINATES:C663(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			If ($2.maxWidth#Null:C1517)
				
				OBJECT GET BEST SIZE:C717(*;$o.name;$Lon_width;$Lon_height;Num:C11($2.maxWidth))
				
			Else 
				
				OBJECT GET BEST SIZE:C717(*;$o.name;$Lon_width;$Lon_height)
				
			End if 
			
			If (Num:C11($2.minWidth)#0)
				
				$Lon_width:=Choose:C955($Lon_width<$2.minWidth;$2.minWidth;$Lon_width)
				
			End if 
			
			If (Num:C11($2.alignment)=Align right:K42:4)
				
				$Lon_left:=$Lon_right-$Lon_width
				
			Else 
				
				  // Default is Align left
				$Lon_right:=$Lon_left+$Lon_width
				
			End if 
			
			OBJECT SET COORDINATES:C1248(*;$o.name;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			  //______________________________________________________
		: ($1="show")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($t;$o.name)
					
					OBJECT SET VISIBLE:C603(*;$t;True:C214)
					
				End for each 
				
			Else 
				
				OBJECT SET VISIBLE:C603(*;$o.name;True:C214)
				
			End if 
			
			  //______________________________________________________
		: ($1="hide")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($t;$o.name)
					
					OBJECT SET VISIBLE:C603(*;$t;False:C215)
					
				End for each 
				
			Else 
				
				OBJECT SET VISIBLE:C603(*;$o.name;False:C215)
				
			End if 
			
			  //______________________________________________________
		: ($1="setVisible")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($t;$o.name)
					
					OBJECT SET VISIBLE:C603(*;$t;Bool:C1537($2.visible))
					
				End for each 
				
			Else 
				
				OBJECT SET VISIBLE:C603(*;$o.name;Bool:C1537($2.visible))
				
			End if 
			
			  //______________________________________________________
		: ($1="enable")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($t;$o.name)
					
					OBJECT SET ENABLED:C1123(*;$t;True:C214)
					
				End for each 
				
			Else 
				
				OBJECT SET ENABLED:C1123(*;$o.name;True:C214)
				
			End if 
			
			  //______________________________________________________
		: ($1="disable")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($o;$o.name)
					
					OBJECT SET ENABLED:C1123(*;$t;False:C215)
					
				End for each 
				
			Else 
				
				OBJECT SET ENABLED:C1123(*;$o.name;False:C215)
				
			End if 
			
			  //______________________________________________________
		: ($1="setEnabled")
			
			If (Value type:C1509($o.name)=Is collection:K8:32)  // Group
				
				For each ($t;$o.name)
					
					OBJECT SET ENABLED:C1123(*;$t;Bool:C1537($2.enabled))
					
				End for each 
				
			Else 
				
				OBJECT SET ENABLED:C1123(*;$o.name;Bool:C1537($2.enabled))
				
			End if 
			
			  //______________________________________________________
		: ($1="setFilter")
			
			If ($2.value#Null:C1517)
				
				  // User format
				OBJECT SET FILTER:C235(*;$o.name;String:C10($2.value))
				
			Else 
				
				  // Predefined formats
				$l:=Num:C11($2.format)
				
				  // tips add the range ";:-<" to allow semicolon characters
				
				Case of 
						
						  //………………………………………………………………………
					: ($l=Is integer:K8:5)\
						 | ($l=Is longint:K8:6)\
						 | ($l=Is integer 64 bits:K8:25)
						
						OBJECT SET FILTER:C235(*;$o.name;"&\"0-9;-;+\"")
						
						  //………………………………………………………………………
					: ($l=Is real:K8:4)\
						 | ($l=_o_Is float:K8:26)
						
						$t:=String:C10($2.separator)
						
						If (Length:C16($t)=0)
							
							GET SYSTEM FORMAT:C994(Decimal separator:K60:1;$t)
							
						End if 
						
						OBJECT SET FILTER:C235(*;$o.name;"&\"0-9;"+$t+";.;-;+\"")
						
						  //………………………………………………………………………
					: ($l=Is time:K8:8)
						
						$t:=String:C10($2.separator)
						
						If (Length:C16($t)=0)
							
							GET SYSTEM FORMAT:C994(Time separator:K60:11;$t)
							
						End if 
						
						OBJECT SET FILTER:C235(*;$o.name;"&\"0-9;"+$t+";:\"")
						
						  //………………………………………………………………………
					: ($l=Is date:K8:7)
						
						$t:=String:C10($2.separator)
						
						If (Length:C16($t)=0)
							
							GET SYSTEM FORMAT:C994(Date separator:K60:10;$t)
							
						End if 
						
						OBJECT SET FILTER:C235(*;$o.name;"&\"0-9;"+$t+";/\"")
						
						  //………………………………………………………………………
					Else 
						
						OBJECT SET FILTER:C235(*;$o.name;"")  // Text as default
						
						  //………………………………………………………………………
				End case 
			End if 
			
			  //______________________________________________________
		: ($1="setColors")
			
			If (Value type:C1509($2.foreground)=Is text:K8:3)
				
				If ($2.altBackgrnd#Null:C1517)
					
					OBJECT SET RGB COLORS:C628(*;$o.name;String:C10($2.foreground);String:C10($2.background);String:C10($2.altBackgrnd))
					
				Else 
					
					If ($2.background#Null:C1517)
						
						OBJECT SET RGB COLORS:C628(*;$o.name;String:C10($2.foreground);String:C10($2.background))
						
					Else 
						
						OBJECT SET RGB COLORS:C628(*;$o.name;String:C10($2.foreground))
						
					End if 
				End if 
				
			Else 
				
				If ($2.altBackgrnd#Null:C1517)
					
					OBJECT SET RGB COLORS:C628(*;$o.name;Num:C11($2.foreground);Num:C11($2.background);Num:C11($2.altBackgrnd))
					
				Else 
					
					If ($2.background#Null:C1517)
						
						OBJECT SET RGB COLORS:C628(*;$o.name;Num:C11($2.foreground);Num:C11($2.background))
						
					Else 
						
						OBJECT SET RGB COLORS:C628(*;$o.name;Num:C11($2.foreground))
						
					End if 
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="setTitle")
			
			$t:=Get localized string:C991($2.title)
			$t:=Choose:C955(OK=1;$t;$2.title)  // Revert if no localization
			
			OBJECT SET TITLE:C194(*;$o.name;$t)
			
			  //______________________________________________________
		: (Is nil pointer:C315($o.pointer()))
			
			  // ========================================================================================
			  // ALL THE METHODS BELOW ARE NOT APPLICABLE TO A STATIC OR WIDGET RELATED TO AN EXPRESSION
			  // ========================================================================================
			
			ASSERT:C1129(False:C215;"member method \""+$1+"()\" can not be used for a widget linked to an expression!")
			
			  //______________________________________________________
		: ($1="forceNumeric")
			
			EXECUTE FORMULA:C63("C_REAL:C285((OBJECT Get pointer:C1124(Object named:K67:5;$o.name))->)")
			
			  //______________________________________________________
		: ($1="value")
			
			$o:=New object:C1471(\
				"value";($o.pointer())->)
			
			  //______________________________________________________
		: ($1="setValue")
			
			($o.pointer())->:=$2.value
			
			  //______________________________________________________
		: ($1="clear")
			
			CLEAR VARIABLE:C89((This:C1470.pointer())->)
			
			  //______________________________________________________
		: ($1="touch")
			
			($o.pointer())->:=($o.pointer())->
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
	
	If ($1="getCoordinates")\
		 | ($1="setCoordinates")\
		 | ($1="bestSize")
		
		  // Update coordinates
		$o.coordinates:=New object:C1471(\
			"left";$Lon_left;\
			"top";$Lon_top;\
			"right";$Lon_right;\
			"bottom";$Lon_bottom;\
			"width";$Lon_right-$Lon_left;\
			"height";$Lon_bottom-$Lon_top)
		
		CONVERT COORDINATES:C1365($Lon_left;$Lon_top;XY Current form:K27:5;XY Current window:K27:6)
		CONVERT COORDINATES:C1365($Lon_right;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
		
		$o.windowCoordinates:=New object:C1471(\
			"left";$Lon_left;\
			"top";$Lon_top;\
			"right";$Lon_right;\
			"bottom";$Lon_bottom)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End