//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : list
  // ID[9A49B3FD015E40228E17D6FB5DC8D2F2]
  // Created 12-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_VARIANT:C1683($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$index;$list;$listItem)
C_PICTURE:C286($p)
C_TEXT:C284($text;$textItem)
C_OBJECT:C1216($o)

ARRAY LONGINT:C221($aL_buffer;0)

If (False:C215)
	C_OBJECT:C1216(list ;$0)
	C_VARIANT:C1683(list ;$1)
	C_OBJECT:C1216(list ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";New object:C1471("";"list";"uid";0);\
		"ref";0;\
		"success";False:C215;\
		"append";Formula:C1597(list ("append";New object:C1471("label";String:C10($1);"ref";$2)));\
		"parameter";Formula:C1597(list ("parameter";New object:C1471("key";String:C10($1);"value";String:C10($2);"target";$3)));\
		"icon";Formula:C1597(list ("icon";New object:C1471("icon";$1;"target";$2)));\
		"empty";Formula:C1597(list ("empty"));\
		"setList";Formula:C1597(list ("setList";New object:C1471("ref";Num:C11($1);"clear";Bool:C1537($2))));\
		"index";Formula:C1597(list ("index").value);\
		"reference";Formula:C1597(list ("reference").value);\
		"indexes";Formula:C1597(list ("indexes").value);\
		"references";Formula:C1597(list ("references").value);\
		"getByIndex";Formula:C1597(list ("getByIndex";New object:C1471("ref";Num:C11($1))).value);\
		"getByReference";Formula:C1597(list ("getByReference";New object:C1471("ref";$1)).value)\
		)
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				  //—————————————————————————————————
			: (Value type:C1509($1)=Is real:K8:4)\
				 | (Value type:C1509($1)=Is longint:K8:6)
				
				$o.ref:=$1
				
				  //—————————————————————————————————
			: (Value type:C1509($1)=Is text:K8:3)
				
				  // Create a hierarchical list whose content is copied from the list created in Development mode
				$o.ref:=Load list:C383($1)
				
				  //—————————————————————————————————
			Else 
				
				  //
				
				  //—————————————————————————————————
		End case 
		
		If ($o.ref=0)
			
			$o.ref:=New list:C375
			
		End if 
	End if 
	
	$o.success:=Is a list:C621($o.ref)
	
Else 
	
	$o:=This:C1470
	$o.success:=Is a list:C621($o.ref)
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
			  //: (Not($o.success))
			
			  // #TO_DO
			
			  //______________________________________________________
		: ($1="append")
			
			If ($2.ref=Null:C1517)
				
				$2.ref:=Num:C11($o[""].uid)+1
				$o[""].uid:=$2.ref
				
			End if 
			
			APPEND TO LIST:C376($o.ref;$2.label;$2.ref)
			
			  //______________________________________________________
		: ($1="parameter")
			
			If ($2.target=Null:C1517)
				
				$2.target:=0
				
			End if 
			
			SET LIST ITEM PARAMETER:C986($o.ref;Num:C11($2.target);$2.key;$2.value)
			
			  //______________________________________________________
		: ($1="icon")
			
			If ($2.target=Null:C1517)
				
				$2.target:=0
				
			End if 
			
			$p:=$2.icon
			SET LIST ITEM ICON:C950($o.ref;0;$p)
			
			  //______________________________________________________
		: ($1="empty")
			
			For ($i;Count list items:C380($o.ref);1;-1)
				
				GET LIST ITEM:C378($o.ref;$i;$listItem;$textItem)
				DELETE FROM LIST:C624($o.ref;$listItem;*)
				
			End for 
			
			  //______________________________________________________
		: ($1="reference")
			
			$o.value:=Selected list items:C379($o.ref;*)
			
			  //______________________________________________________
		: ($1="index")
			
			$o.value:=Selected list items:C379($o.ref)
			
			  //______________________________________________________
		: ($1="references")
			
			$aL_buffer{0}:=Selected list items:C379($o.ref;$aL_buffer;*)
			$o.value:=New collection:C1472
			ARRAY TO COLLECTION:C1563($o.value;$aL_buffer)
			
			  //______________________________________________________
		: ($1="indexes")
			
			$aL_buffer{0}:=Selected list items:C379($o.ref;$aL_buffer)
			$o.value:=New collection:C1472
			ARRAY TO COLLECTION:C1563($o.value;$aL_buffer)
			
			  //______________________________________________________
		: ($1="getByIndex")
			
			GET LIST ITEM:C378($o.ref;$2.ref;$index;$text;$list;$b)
			
			$o.value:=New object:C1471(\
				"ref";$index;\
				"label";$text;\
				"sublist";$list;\
				"expanded";$b)
			
			  //______________________________________________________
		: ($1="getByReference")
			
			GET LIST ITEM:C378($o.ref;List item position:C629($o.ref;Num:C11($2.ref));$index;$text;$list;$b)
			
			$o.value:=New object:C1471(\
				"ref";$index;\
				"label";$text;\
				"list";$list;\
				"expanded";$b)
			
			  //______________________________________________________
		: ($1="setList")
			
			If ($o.success)
				
				If ($2.clear)
					
					CLEAR LIST:C377($o.ref;*)
					
				End if 
			End if 
			
			$o[""].uid:=0
			
			$o.ref:=$2.ref
			$o.success:=Is a list:C621($o.ref)
			
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