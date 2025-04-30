//%attributes = {}
var $c:=New collection:C1472
//$c.push("userAlert")

// Mark:-ACI0101062
If ($c.includes("ACI0101062"))\
 | ($c.length=0)
	
	var $o:=New object:C1471(\
		"type"; "confirm"; \
		"main"; "Insert the 4D key disk."; \
		"buttons"; New object:C1471(\
		"cancelTitle"; "This is a bit tight with long text"; \
		"okTitle"; "Yes - that would be nice"))
	
	var $w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Info
If ($c.includes("info"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"main"; "Today is "+String:C10(Current date:C33; Internal date long:K1:5))
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Alert
If ($c.includes("alert"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"type"; "alert"; \
		"main"; "Il n'y a pas de disque dans le lecteur D:\r\rInsérez un disque et essayez à nouveau.")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Confirm
If ($c.includes("confirm"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"type"; "confirm"; \
		"main"; "Insert the 4D key disk.")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-No icon
If ($c.includes("noIcon"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"type"; "noIcon"; \
		"main"; "No icon dialog"; \
		"additional"; "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryLorem ipsum dolor sit amet,"\
		+" consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim ve"\
		+"niam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in"\
		+" reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in cul"\
		+"pa qui officia deserunt mollit anim id est laborum.s standard dummy text ever since the 1500s, when an unknown printer took a galley of type"\
		+" and scrambled it to make a type specimen book.")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-big alert
If ($c.includes("bigMain"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"type"; "alert"; \
		"main"; "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryLorem ipsum dolor sit amet,"\
		+" consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim ve"\
		+"niam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in"\
		+" reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in cul"\
		+"pa qui officia deserunt mollit anim id est laborum.s standard dummy text ever since the 1500s, when an unknown printer took a galley of type"\
		+" and scrambled it to make a type specimen book."; \
		"additional"; "No icon dialog")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Info with window title (title is not displayed for a dialog in macOS Mojave)
If ($c.includes("title"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"main"; "Window title is not displayed for a Movable form dialog in macOS Mojave"; \
		"title"; "My Wyndow")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Info + 3 Texts + 3 buttons : OK et Cancel buttons with default title
If ($c.includes("info+"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"main"; "\"App\" is not optimized for your Mac and needs to be updated."; \
		"additional"; "This app will not work with future versions of macOS and needs to be updated to improve compatibility.\rContact the developer for more informations."; \
		"comment"; "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."; \
		"buttons"; New object:C1471(\
		"cancel"; True:C214; \
		"alternate"; True:C214; \
		"alternateTitle"; "Learn more…"))
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-Alert + 2 texts + 2 buttons - option button (selected)
If ($c.includes("option"))\
 | ($c.length=0)
	
	$o:=New object:C1471(\
		"type"; "alert"; \
		"main"; "Une mise à jour logicielle est requise pour se connecter à l'iPad de Laurent."; \
		"additional"; "Souhaitez-vous télécharger cette mise à jour et l'installer maintenant ?\r\rL'utilisation de ce logiciel est soumise au(x) contrat(s)"\
		+" de licence de logiciel original ou originaux accompagnant le logiciel qui fait l'objet de la mise à jour."; \
		"buttons"; New object:C1471(\
		"cancel"; True:C214; \
		"cancelTitle"; "Décider plus tard"; \
		"okTitle"; "Installer"; \
		"option"; True:C214; \
		"optionTitle"; "Se souvenir de mon choix"; \
		"optionValue"; 1))
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-User icon
If ($c.includes("userIcon"))\
 | ($c.length=0)
	
	var $p : Picture
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/noLayout.png").platformPath; $p)
	
	$o:=New object:C1471(\
		"main"; "User icon"; \
		"icon"; $p)
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 

// Mark:-User icon with alert badge
If ($c.includes("userAlert"))\
 | ($c.length=0)
	
	READ PICTURE FILE:C678(Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("images/4DGeneric.png").platformPath; $p)
	
	$o:=New object:C1471(\
		"main"; "User icon with alert badge"; \
		"icon"; $p; \
		"badge"; "alert")
	
	$w:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8)
	
	If (Is macOS:C1572)
		
		DIALOG:C40("MESSAGE"; $o; *)
		
	Else 
		
		DIALOG:C40("MESSAGE"; $o)
		
	End if 
End if 
