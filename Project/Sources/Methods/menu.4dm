//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : menu
  // ID[7F62512A7B7C487C97E780DCE95400AB]
  // Created 11-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Manipulate menus as objects to make code more readable
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i;$j;$l)
C_TEXT:C284($Mnu_styles;$t)
C_OBJECT:C1216($o;$o1)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(menu ;$0)
	C_TEXT:C284(menu ;$1)
	C_OBJECT:C1216(menu ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)
	
	$o:=New object:C1471(\
		"";"menu";\
		"ref";Null:C1517;\
		"autoRelease";True:C214;\
		"metacharacters";False:C215;\
		"selected";False:C215;\
		"choice";"";\
		"itemCount";Formula:C1597(Count menu items:C405(This:C1470.ref));\
		"action";Formula:C1597(menu ("action";New object:C1471("action";$1;"item";$2)));\
		"append";Formula:C1597(menu ("append";Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("item";String:C10($1);"menu";$2);New object:C1471("item";String:C10($1);"param";$2;"mark";Bool:C1537($3)))));\
		"cleanup";Formula:C1597(menu ("cleanup"));\
		"edit";Formula:C1597(menu ("edit"));\
		"enable";Formula:C1597(menu ("enable";Choose:C955(Value type:C1509($1)=Is boolean:K8:9;New object:C1471("enabled";$1);New object:C1471("item";$1;"enabled";$2))));\
		"delete";Formula:C1597(menu ("delete";New object:C1471("item";$1)));\
		"disable";Formula:C1597(This:C1470.enable(False:C215));\
		"file";Formula:C1597(menu ("file"));\
		"fonts";Formula:C1597(menu ("fonts";New object:C1471("style";$1)));\
		"icon";Formula:C1597(menu ("icon";New object:C1471("icon";$1;"item";$2)));\
		"insert";Formula:C1597(menu ("insert";Choose:C955(Value type:C1509($3)=Is object:K8:27;New object:C1471("item";String:C10($1);"after";Num:C11($2);"menu";$3);New object:C1471("item";String:C10($1);"after";Num:C11($2);"param";$3;"mark";Bool:C1537($4)))));\
		"line";Formula:C1597(menu ("line"));\
		"loadBar";Formula:C1597(menu ("loadBar";New object:C1471("menu";$1)));\
		"method";Formula:C1597(menu ("method";New object:C1471("method";String:C10($1);"item";$2)));\
		"popup";Formula:C1597(menu ("popup";Choose:C955(Count parameters:C259=1;New object:C1471("default";String:C10($1));Choose:C955(Value type:C1509($2)=Is object:K8:27;New object:C1471("default";String:C10($1);"widget";$2);New object:C1471("default";String:C10($1);"xCoord";$2;"yCoord";$3)))));\
		"release";Formula:C1597(RELEASE MENU:C978(This:C1470.ref));\
		"setBar";Formula:C1597(menu ("setBar"));\
		"shortcut";Formula:C1597(menu ("shortcut";New object:C1471("shortcut";$1;"modifier";Num:C11($2);"item";$3)));\
		"windows";Formula:C1597(menu ("windows"));\
		"items";Formula:C1597(menu ("items").result)\
		)
	
	If (Count parameters:C259>=1)
		
		If (Match regex:C1019("(?m-si)\\|MR\\|\\d{12}";$1;1))
			
			$o.ref:=$1  // Menu reference
			
		Else 
			
			$o.ref:=Create menu:C408
			
			$c:=Split string:C1554(String:C10($1);";")
			$o.autoRelease:=($c.indexOf("keepReference")=-1)
			$o.metacharacters:=($c.indexOf("displayMetacharacters")#-1)
			
		End if 
		
	Else 
		
		$o.ref:=Create menu:C408
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="action")
			
			SET MENU ITEM PROPERTY:C973($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);Associated standard action:K28:8;$2.action)
			
			  //______________________________________________________
		: ($1="append")
			
			$t:=Get localized string:C991($2.item)
			$t:=Choose:C955(Length:C16($t)>0;$t;$2.item)
			
			ASSERT:C1129(Length:C16($t)>0;"An empty item will be ignored")
			
			If ($2.menu#Null:C1517)  // Submenu
				
				If ($o.metacharacters)
					
					APPEND MENU ITEM:C411($o.ref;$t;$2.menu.ref)
					
				Else 
					
					APPEND MENU ITEM:C411($o.ref;$t;$2.menu.ref;*)
					
				End if 
				
				If ($2.menu.autoRelease)
					
					RELEASE MENU:C978($2.menu.ref)
					
				End if 
				
			Else   // Item
				
				If ($o.metacharacters)
					
					APPEND MENU ITEM:C411($o.ref;$t)
					
				Else 
					
					APPEND MENU ITEM:C411($o.ref;$t;*)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004($o.ref;-1;String:C10($2.param))
				SET MENU ITEM MARK:C208($o.ref;-1;Char:C90(18)*Num:C11($2.mark))
				
			End if 
			
			  //______________________________________________________
		: ($1="cleanup")
			
			Repeat   // Remove unnecessary lines at the end
				
				$i:=$o.itemCount()
				
				$t:=Get menu item:C422($o.ref;$i)
				
				If ($t="-")
					
					$o.delete($i)
					
				End if 
			Until ($t#"-")
			
			  // #MARK_TODO
			  // Remove duplicates (lines or items)
			
			  //______________________________________________________
		: ($1="edit")  // Standard Edit menu
			
			$o.append(":xliff:CommonMenuItemUndo").action(ak undo:K76:51).shortcut("Z")
			$o.append(":xliff:CommonMenuRedo").action(ak redo:K76:52).shortcut("Z";512)
			$o.line()
			$o.append(":xliff:CommonMenuItemCut").action(ak cut:K76:53).shortcut("X")
			$o.append(":xliff:CommonMenuItemCopy").action(ak copy:K76:54).shortcut("C")
			$o.append(":xliff:CommonMenuItemPaste").action(ak paste:K76:55).shortcut("V")
			$o.append(":xliff:CommonMenuItemClear").action(ak clear:K76:56)
			$o.append(":xliff:CommonMenuItemSelectAll").action(ak select all:K76:57).shortcut("A")
			$o.line()
			$o.append(":xliff:CommonMenuItemShowClipboard").action(ak show clipboard:K76:58)
			
			  //______________________________________________________
		: ($1="enable")
			
			If ($2.enabled=Null:C1517)
				
				ENABLE MENU ITEM:C149($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
				
			Else 
				
				If (Bool:C1537($2.enabled))
					
					ENABLE MENU ITEM:C149($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
					
				Else 
					
					DISABLE MENU ITEM:C150($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="delete")
			
			DELETE MENU ITEM:C413(This:C1470.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1))
			
			  //______________________________________________________
		: ($1="file")  // Default File menu
			
			$o.append(":xliff:CommonMenuItemQuit").action(ak quit:K76:61).shortcut("Q")
			
			  //______________________________________________________
		: ($1="fonts")  // Fonts menu with or without styles
			
			ARRAY TEXT:C222($tTxt_fontsFamilly;0x0000)
			
			FONT LIST:C460($tTxt_fontsFamilly)
			
			If (Bool:C1537($2.style))
				
				For ($i;1;Size of array:C274($tTxt_fontsFamilly);1)
					
					ARRAY TEXT:C222($tTxt_styles;0x0000)
					ARRAY TEXT:C222($tTxt_names;0x0000)
					
					FONT STYLE LIST:C1362($tTxt_fontsFamilly{$i};$tTxt_styles;$tTxt_names)
					
					If (Size of array:C274($tTxt_styles)>0)
						
						If (Size of array:C274($tTxt_styles)>1)
							
							$Mnu_styles:=Create menu:C408
							
							For ($j;1;Size of array:C274($tTxt_styles);1)
								
								APPEND MENU ITEM:C411($Mnu_styles;$tTxt_styles{$j})  // Localized name
								SET MENU ITEM PARAMETER:C1004($Mnu_styles;-1;$tTxt_names{$j})  // System name
								
							End for 
							
							APPEND MENU ITEM:C411($o.ref;$tTxt_fontsFamilly{$i};$Mnu_styles)  // Familly name
							RELEASE MENU:C978($Mnu_styles)
							
						Else 
							
							APPEND MENU ITEM:C411($o.ref;$tTxt_fontsFamilly{$i})
							SET MENU ITEM PARAMETER:C1004($o.ref;-1;$tTxt_names{1})
							
						End if 
						
					Else 
						
						$o.append($tTxt_fontsFamilly{$i};$tTxt_fontsFamilly{$i})  // Familly name
						
					End if 
				End for 
				
			Else 
				
				For ($i;1;Size of array:C274($tTxt_fontsFamilly);1)
					
					$o.append($tTxt_fontsFamilly{$i};$tTxt_fontsFamilly{$i})  // Familly name
					
				End for 
			End if 
			
			  //______________________________________________________
		: ($1="icon")
			
			SET MENU ITEM ICON:C984($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);"path:"+String:C10($2.icon))
			
			  //______________________________________________________
		: ($1="insert")
			
			ASSERT:C1129(Length:C16($2.item)>0)
			
			If (String:C10($2._is)="menu")  // Submenu
				
				If ($o.metacharacters)
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;$2.menu.ref)
					
				Else 
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;$2.menu.ref;*)
					
				End if 
				
				If ($2.menu.autoRelease)
					
					RELEASE MENU:C978($2.menu.ref)
					
				End if 
				
			Else   // Item
				
				If ($o.metacharacters)
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item)
					
				Else 
					
					INSERT MENU ITEM:C412($o.ref;$2.after;$2.item;*)
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004($o.ref;-1;String:C10($2.param))
				SET MENU ITEM MARK:C208($o.ref;-1;Char:C90(18)*Num:C11($2.mark))
				
			End if 
			
			  //______________________________________________________
		: ($1="items")  // Returns menu items as collection
			
			ARRAY TEXT:C222($aT_item;0x0000)
			ARRAY TEXT:C222($aT_ref;0x0000)
			GET MENU ITEMS:C977($o.ref;$aT_item;$aT_ref)
			
			$o.result:=New collection:C1472
			
			For ($i;1;Size of array:C274($aT_item);1)
				
				$o.result.push(New object:C1471("item";$aT_item{$i};"ref";$aT_ref{$i}))
				
			End for 
			
			  //______________________________________________________
		: ($1="line")
			
			APPEND MENU ITEM:C411($o.ref;"-")
			
			  //______________________________________________________
		: ($1="method")
			
			SET MENU ITEM METHOD:C982($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);$2.method)
			
			  //______________________________________________________
		: ($1="popup")
			
			$o.cleanup()
			
			If ($2.widget#Null:C1517)  // Widget reference
				
				$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default;Num:C11($2.widget.windowCoordinates.left);Num:C11($2.widget.windowCoordinates.bottom))
				
			Else 
				
				If ($2.xCoord#Null:C1517)
					
					$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default;Num:C11($2.xCoord);Num:C11($2.yCoord))
					
				Else 
					
					$o.choice:=Dynamic pop up menu:C1006($o.ref;$2.default)
					
				End if 
			End if 
			
			$o.selected:=(Length:C16(String:C10($o.choice))>0)
			
			If ($o.autoRelease)
				
				$o.release()
				
			End if 
			
			  //______________________________________________________
		: ($1="setBar")
			
			SET MENU BAR:C67($o.ref)
			
			If ($o.autoRelease)
				
				$o.release()
				
			End if 
			
			  //______________________________________________________
		: ($1="shortcut")
			
			SET MENU ITEM SHORTCUT:C423($o.ref;Choose:C955($2.item#Null:C1517;Num:C11($2.item);-1);$2.shortcut;$2.modifier)
			
			  //______________________________________________________
		: ($1="windows")  // Windows menu
			
			ARRAY LONGINT:C221($tLon_ref;0x0000)
			WINDOW LIST:C442($tLon_ref)
			
			$c:=New collection:C1472
			
			For ($i;1;Size of array:C274($tLon_ref);1)
				
				$c.push(New object:C1471(\
					"ref";$tLon_ref{$i};\
					"name";Get window title:C450($tLon_ref{$i});\
					"process";Window process:C446($tLon_ref{$i})))
				
			End for 
			
			$c:=$c.orderBy(New collection:C1472(\
				New object:C1471("propertyPath";"process";"descending";True:C214);\
				New object:C1471("propertyPath";"name")))
			
			If ($c.length>0)
				
				$l:=Frontmost window:C447
				
				$j:=$c[0].process
				$t:=Substring:C12($c[0].name;1;Position:C15(":";$c[0].name))
				
				For each ($o1;$c)
					
					If ($o1.process#$j)\
						 | (Substring:C12($o1.name;1;Position:C15(":";$o1.name))#$t)
						
						$o.line()
						$j:=$o1.process
						$t:=Substring:C12($o1.name;1;Position:C15(":";$o1.name))
						
					End if 
					
					$o.append($o1.name;$o1.ref;$l=$o1.ref)
					
				End for each 
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