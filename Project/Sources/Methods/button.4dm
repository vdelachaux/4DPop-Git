//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : button
  // ID[CD66153575D146F2A622EAE200B9EA5A]
  // Created 14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage buttons
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(button ;$0)
	C_TEXT:C284(button ;$1)
	C_OBJECT:C1216(button ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"button";\
		"name";$1;\
		"action";OBJECT Get action:C1457(*;$t);\
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
		"coordinates";Null:C1517;\
		"windowCoordinates";Null:C1517;\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"bestSize";Formula:C1597(widget ("bestSize";New object:C1471("alignment";$1;"minWidth";$2;"maxWidth";$3)));\
		"title";Formula:C1597(OBJECT Get title:C1068(*;This:C1470.name));\
		"setTitle";Formula:C1597(widget ("setTitle";New object:C1471("title";String:C10($1))));\
		"format";Formula:C1597(OBJECT Get format:C894(*;This:C1470.name));\
		"setFormat";Formula:C1597(OBJECT SET FORMAT:C236(*;This:C1470.name;String:C10($1)));\
		"helpTip";Formula:C1597(OBJECT Get help tip:C1182(*;This:C1470.name));\
		"setHelpTip";Formula:C1597(OBJECT SET HELP TIP:C1181(*;This:C1470.name;String:C10($1)));\
		"setColors";Formula:C1597(OBJECT SET RGB COLORS:C628(*;This:C1470.name;$1;$2));\
		"forceBoolean";Formula:C1597(button ("forceBoolean"))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="forceBoolean")
			
			EXECUTE FORMULA:C63("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;$o.name))->)")
			
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