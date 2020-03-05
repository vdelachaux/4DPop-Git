//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : thermometer
  // ID[CE6119C95A784B9182E22995CBB3A470]
  // Created 14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage thermometers
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(thermometer ;$0)
	C_TEXT:C284(thermometer ;$1)
	C_OBJECT:C1216(thermometer ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"thermometer";\
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
		"coordinates";Null:C1517;\
		"windowCoordinates";Null:C1517;\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"indicatorType";Formula:C1597(OBJECT Get indicator type:C1247(*;This:C1470.name));\
		"setIndicatorType";Formula:C1597(OBJECT SET INDICATOR TYPE:C1246(*;This:C1470.name;Num:C11($1)));\
		"start";Formula:C1597(thermometer ("start"));\
		"stop";Formula:C1597(thermometer ("stop"))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="start")
			
			If (Asserted:C1132(OBJECT Get indicator type:C1247(*;$o.name)=Asynchronous progress bar:K42:36))
				
				$o.pointer->:=1
				
			End if 
			
			  //______________________________________________________
		: ($1="stop")
			
			If (Asserted:C1132(OBJECT Get indicator type:C1247(*;$o.name)=Asynchronous progress bar:K42:36))
				
				$o.pointer->:=0
				
			End if 
			
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