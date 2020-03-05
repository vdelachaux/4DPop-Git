//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : listbox
  // ID[A1E9ABBDE36648929AAA54FCE6CD1B6A]
  // Created 14-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage listboxes
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($Boo_horizontal;$Boo_vertical)
C_LONGINT:C283($i;$Lon_;$Lon_bottom;$Lon_column;$Lon_left;$Lon_right)
C_LONGINT:C283($Lon_row;$Lon_top;$Lon_x;$Lon_y)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$oo)

If (False:C215)
	C_OBJECT:C1216(listbox ;$0)
	C_TEXT:C284(listbox ;$1)
	C_OBJECT:C1216(listbox ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"";"listbox";\
		"name";$t;\
		"column";Null:C1517;\
		"row";Null:C1517;\
		"cellBox";Null:C1517;\
		"definition";Null:C1517;\
		"columns";Null:C1517;\
		"scrollbar";Null:C1517;\
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
		"update";Formula:C1597(widget ("update"));\
		"coordinates";Null:C1517;\
		"windowCoordinates";Null:C1517;\
		"getCoordinates";Formula:C1597(widget ("getCoordinates"));\
		"setCoordinates";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1;"top";$2;"right";$3;"bottom";$4)));\
		"moveHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("left";$1)));\
		"resizeHorizontally";Formula:C1597(widget ("setCoordinates";New object:C1471("right";$1)));\
		"moveVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("top";$1)));\
		"resizeVertically";Formula:C1597(widget ("setCoordinates";New object:C1471("bottom";$1)));\
		"setColors";Formula:C1597(widget ("setColors";New object:C1471("foreground";$1;"background";$2;"altBackgrnd";$3)));\
		"getDefinition";Formula:C1597(listbox ("getDefinition"));\
		"getCell";Formula:C1597(listbox ("getCell"));\
		"cellPosition";Formula:C1597(listbox ("cellPosition"));\
		"cellCoordinates";Formula:C1597(listbox ("cellCoordinates";New object:C1471("column";$1;"row";$2)));\
		"getScrollbar";Formula:C1597(listbox ("getScrollbar"));\
		"setScrollbar";Formula:C1597(OBJECT SET SCROLLBAR:C843(*;This:C1470.name;Num:C11($1);Num:C11($2)));\
		"getProperty";Formula:C1597(listbox ("getProperty";New object:C1471("property";$1)));\
		"setProperty";Formula:C1597(LISTBOX SET PROPERTY:C1440(*;This:C1470.name;$1;$2));\
		"rowsNumber";Formula:C1597(LISTBOX Get number of rows:C915(*;This:C1470.name));\
		"deleteRow";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;$1;1));\
		"deleteRows";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;$1;$2));\
		"deleteAllRows";Formula:C1597(LISTBOX DELETE ROWS:C914(*;This:C1470.name;1;This:C1470.rowsNumber()));\
		"selected";Formula:C1597(Count in array:C907((This:C1470.pointer())->;True:C214));\
		"select";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;Num:C11($1);lk replace selection:K53:1));\
		"selectAll";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;0;lk replace selection:K53:1));\
		"deselect";Formula:C1597(LISTBOX SELECT ROW:C912(*;This:C1470.name;0;lk remove from selection:K53:3));\
		"reveal";Formula:C1597(listbox ("reveal";New object:C1471("row";Num:C11($1))));\
		"popup";Formula:C1597(listbox ("popup";$1));\
		"clear";Formula:C1597(listbox ("clear"))\
		)
	
	$o.getCoordinates()
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: (OBJECT Get type:C1300(*;String:C10($o.name))#Object type listbox:K79:8)
			
			ASSERT:C1129(False:C215;"The widget \""+String:C10($o.name)+"\" is not a listbox!")
			
			  //______________________________________________________
		: ($1="getDefinition")  // Listbox structure
			
			ARRAY BOOLEAN:C223($tBoo_ColsVisible;0x0000)
			ARRAY POINTER:C280($tPtr_ColVars;0x0000)
			ARRAY POINTER:C280($tPtr_FooterVars;0x0000)
			ARRAY POINTER:C280($tPtr_HeaderVars;0x0000)
			ARRAY POINTER:C280($tPtr_Styles;0x0000)
			ARRAY TEXT:C222($tTxt_ColNames;0x0000)
			ARRAY TEXT:C222($tTxt_FooterNames;0x0000)
			ARRAY TEXT:C222($tTxt_HeaderNames;0x0000)
			
			LISTBOX GET ARRAYS:C832(*;$o.name;\
				$tTxt_ColNames;$tTxt_HeaderNames;\
				$tPtr_ColVars;$tPtr_HeaderVars;\
				$tBoo_ColsVisible;\
				$tPtr_Styles;\
				$tTxt_FooterNames;$tPtr_FooterVars)
			
			$o.definition:=New collection:C1472
			
			ARRAY TO COLLECTION:C1563($o.definition;\
				$tTxt_ColNames;"names";\
				$tTxt_HeaderNames;"headers";\
				$tTxt_FooterNames;"footers")
			
			$o.columns:=New object:C1471
			
			For ($i;1;Size of array:C274($tTxt_ColNames);1)
				
				$o.columns[$tTxt_ColNames{$i}]:=New object:C1471(\
					"number";$i;\
					"pointer";$tPtr_ColVars{$i})
				
			End for 
			
			$o.getScrollbar()
			
			  //______________________________________________________
		: ($1="clear")
			
			$o.getDefinition()
			
			For each ($oo;$o.definition)
				
				CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5;$oo.names)->)
				
			End for each 
			
			For each ($oo;$o.definition)
				
				CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5;$oo.names)->)
				
			End for each 
			
			  //______________________________________________________
		: ($1="getScrollbar")  // Scroolbar status
			
			OBJECT GET SCROLLBAR:C1076(*;$o.name;$Boo_horizontal;$Boo_vertical)
			
			$o.scrollbar:=New object:C1471(\
				"vertical";$Boo_vertical;\
				"horizontal";$Boo_horizontal)
			
			  //______________________________________________________
		: ($1="getCell")  // Current cell
			
			$o.cellPosition()
			$o.cellCoordinates()
			
			  //______________________________________________________
		: ($1="cellPosition")  // Current cell indexes
			
			If (Form event code:C388=On Clicked:K2:4)
				
				LISTBOX GET CELL POSITION:C971(*;$o.name;$Lon_column;$Lon_row)
				
			Else 
				
				GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
				LISTBOX GET CELL POSITION:C971(*;$o.name;$Lon_x;$Lon_y;$Lon_column;$Lon_row)
				
			End if 
			
			$o.column:=$Lon_column
			$o.row:=$Lon_row
			
			  //______________________________________________________
		: ($1="cellCoordinates")  // Current or given cell coordinates
			
			$Lon_column:=Num:C11(Choose:C955($2.column#Null:C1517;$2.column;$o.column))
			$Lon_row:=Num:C11(Choose:C955($2.row#Null:C1517;$2.row;$o.row))
			
			LISTBOX GET CELL COORDINATES:C1330(*;$o.name;$Lon_column;$Lon_row;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			If ($o.cellBox=Null:C1517)
				
				$o.cellBox:=New object:C1471
				
			End if 
			
			$o.cellBox.left:=$Lon_left
			$o.cellBox.top:=$Lon_top
			$o.cellBox.right:=$Lon_right
			$o.cellBox.bottom:=$Lon_bottom
			
			  //______________________________________________________
		: ($1="getProperty")  // Returns a property value from the list
			
			$o:=New object:C1471(\
				"value";LISTBOX Get property:C917(*;\
				$o.name;Num:C11($2.property)))
			
			  //______________________________________________________
		: ($1="popup")  // Display a pop-up menu at the right place based on the current cell
			
			$o.cellCoordinates()
			
			$Lon_left:=$o.cellBox.left
			$Lon_bottom:=$o.cellBox.bottom
			
			CONVERT COORDINATES:C1365($Lon_left;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
			
			If ($2.menu#Null:C1517)
				
				$o:=New object:C1471(\
					"choice";Dynamic pop up menu:C1006($2.menu;\
					"";$Lon_left;\
					$Lon_bottom))
				
				If (Not:C34(Bool:C1537($2.keep)))
					
					RELEASE MENU:C978($2.menu)
					
				End if 
				
			Else 
				
				  // Object menu
				$o:=$2.popup("";$Lon_left;$Lon_bottom)
				
			End if 
			
			  //______________________________________________________
		: ($1="reveal")  // Reveal the current row
			
			LISTBOX SELECT ROW:C912(*;$o.name;Num:C11($2.row);lk replace selection:K53:1)
			OBJECT SET SCROLL POSITION:C906(*;$o.name;Num:C11($2.row))
			
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