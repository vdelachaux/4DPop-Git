//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : group
  // ID[06338504CDA64E6CB0202CAA502897EC]
  // Created 12-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Part of the UI classes to manage objects groups
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(group ;$0)
	C_TEXT:C284(group ;$1)
	C_OBJECT:C1216(group ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	If (Asserted:C1132(Count parameters:C259>=1;"Missing parameters"))
		
		$c:=Split string:C1554(String:C10($1);";")
		
	End if 
	
	$o:=New object:C1471(\
		"";"group";\
		"name";$c;\
		"visible";Formula:C1597(OBJECT Get visible:C1075(*;This:C1470.name[0]));\
		"hide";Formula:C1597(widget ("hide"));\
		"show";Formula:C1597(widget ("show"));\
		"setVisible";Formula:C1597(widget ("setVisible";New object:C1471("visible";Bool:C1537($1))));\
		"enable";Formula:C1597(widget ("enable"));\
		"disable";Formula:C1597(widget ("disable"));\
		"setEnabled";Formula:C1597(widget ("setEnabled";New object:C1471("visible";Bool:C1537($1))));\
		"include";Formula:C1597(This:C1470.name.indexOf(String:C10($1))#-1);\
		"distributeHorizontally";Formula:C1597(widget ("distributeHorizontally";$1))\
		)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="xxxxx")
			
			  //
			
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