//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : subform
  // ID[AEE640685DEE4A069F99DEB49DDD5AC0]
  // Created 18-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_POINTER:C301($ptr)
C_TEXT:C284($t;$tDetail;$tList)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(subform ;$0)
	C_TEXT:C284(subform ;$1)
	C_OBJECT:C1216(subform ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	ASSERT:C1129(Count parameters:C259>0)
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"";"subform";\
		"name";$t;\
		"type";OBJECT Get type:C1300(*;$t);\
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
		"touch";Formula:C1597(widget ("touch"));\
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
		"forms";New object:C1471;\
		"getSubform";Formula:C1597(subform ("getSubform"));\
		"setSubform";Formula:C1597(subform ("setSubform";New object:C1471("detail";String:C10($1);"list";String:C10($2);"table";$3)))\
		)
	
	$o.getSubform()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"This method must be called from an member method")
			
			  //______________________________________________________
		: ($1="getSubform")
			
			OBJECT GET SUBFORM:C1139(*;$o.name;$ptr;$tDetail;$tList)
			
			$o.forms:=New object:C1471(\
				"table";$ptr;\
				"detail";$tDetail;\
				"list";$tList)
			
			  //______________________________________________________
		: ($1="setSubform")
			
			$o.detail:=String:C10($2.detail)
			
			If ($2.list#Null:C1517)
				
				$o.list:=String:C10($2.list)
				
			End if 
			
			If ($2.table#Null:C1517)
				
				If (Value type:C1509($2.table)=Is pointer:K8:14)
					
					If (Not:C34(Is nil pointer:C315($2.table)))
						
						$o.table:=$2.table
						
					End if 
				End if 
			End if 
			
			If ($2.table=Null:C1517)
				
				If ($2.list#Null:C1517)
					
					$o.list:=String:C10($2.list)
					
					OBJECT SET SUBFORM:C1138(*;String:C10($o.name);String:C10($o.detail);String:C10($o.list))
					
				Else 
					
					OBJECT SET SUBFORM:C1138(*;String:C10($o.name);String:C10($o.detail))
					
				End if 
				
			Else 
				
				$ptr:=$2.table
				
				If ($2.list#Null:C1517)
					
					$o.list:=String:C10($2.list)
					
					OBJECT SET SUBFORM:C1138(*;String:C10($o.name);$ptr->;String:C10($o.detail);String:C10($o.list))
					
				Else 
					
					OBJECT SET SUBFORM:C1138(*;String:C10($o.name);$ptr->;String:C10($o.detail))
					
				End if 
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