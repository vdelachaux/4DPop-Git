//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : picture
  // ID[A5B8514D9DB54C3EA3C6BA61D269FE67]
  // Created 14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage picture widget
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_height;$Lon_width)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(picture ;$0)
	C_TEXT:C284(picture ;$1)
	C_OBJECT:C1216(picture ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"picture";\
		"name";$1;\
		"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name));\
		"hide";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215));\
		"show";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214));\
		"setVisible";Formula:C1597(OBJECT SET VISIBLE:C603(*;This:C1470.name;Bool:C1537($1)));\
		"enabled";Formula:C1597(OBJECT Get enabled:C1079(*;This:C1470.name));\
		"enable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;True:C214));\
		"disable";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;False:C215));\
		"setEnabled";Formula:C1597(OBJECT SET ENABLED:C1123(*;This:C1470.name;Bool:C1537($1)));\
		"focused";Formula:C1597(This:C1470.name=OBJECT Get name:C1087(Object with focus:K67:3));\
		"focus";Formula:C1597(GOTO OBJECT:C206(*;This:C1470.name));\
		"pointer";Formula:C1597(OBJECT Get pointer:C1124(Object named:K67:5;This:C1470.name));\
		"value";Formula:C1597(widget ("value").value);\
		"setValue";Formula:C1597(widget ("setValue";New object:C1471("value";$1)));\
		"clear";Formula:C1597(widget ("clear"));\
		"enterable";Formula:C1597(OBJECT Get enterable:C1067(*;This:C1470.name));\
		"setEnterable";Formula:C1597(OBJECT SET ENTERABLE:C238(*;This:C1470.name;Bool:C1537($1)));\
		"update";Formula:C1597(widget ("update"));\
		"coordinates";Null:C1517;\
		"windowCoordinates";Null:C1517;\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"scroll";Null:C1517;\
		"getScrollPosition";Formula:C1597(widget ("getScrollPosition"));\
		"setScrollPosition";Formula:C1597(widget ("setScrollPosition";New object:C1471("horizontal";$1;"vertical";$2)));\
		"dimensions";Null:C1517;\
		"getDimensions";Formula:C1597(picture ("getDimensions"));\
		"getAttribute";Formula:C1597(picture ("getAttribute";New object:C1471("id";$1;"attribute";$2)))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="getAttribute")
			
			SVG GET ATTRIBUTE:C1056(*;$o.name;$2.id;$2.attribute;$t)
			$o[$2.attribute]:=$t
			
			  //______________________________________________________
		: (Is nil pointer:C315($o.pointer()))
			
			  // =============================================================================
			  // ALL THE METHODS BELOW ARE NOT APPLICABLE TO A WIDGET RELATED TO AN EXPRESSION
			  // =============================================================================
			
			ASSERT:C1129(False:C215;"member method \""+$1+"()\" can not be used for a widget linked to an expression!")
			
			  //______________________________________________________
		: ($1="getDimensions")
			
			PICTURE PROPERTIES:C457(($o.pointer())->;$Lon_width;$Lon_height)
			
			$o.dimensions:=New object:C1471(\
				"width";$Lon_width;\
				"height";$Lon_height)
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End