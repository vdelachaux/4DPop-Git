var $choice : Text
var $menu : Object

$menu:=Create menu:C408

APPEND MENU ITEM:C411($menu; "Open in Terminal")
SET MENU ITEM PARAMETER:C1004($menu; -1; "terminal")

APPEND MENU ITEM:C411($menu; "Open in Finder")
SET MENU ITEM PARAMETER:C1004($menu; -1; "show")

APPEND MENU ITEM:C411($menu; "-")

APPEND MENU ITEM:C411($menu; "View on Github")
SET MENU ITEM PARAMETER:C1004($menu; -1; "github")
//.append(""; "github").enable($git.execute("config --get remote.origin.url"))

APPEND MENU ITEM:C411($menu; "-")

APPEND MENU ITEM:C411($menu; "Refresh")
SET MENU ITEM PARAMETER:C1004($menu; -1; "refresh")

$choice:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

Case of 
		
		//______________________________________________________
	: ($choice="terminal")
		
		//$git.open($menu.choice)
		
		//______________________________________________________
	: ($choice="show")
		
		//$git.open($menu.choice)
		
		//______________________________________________________
	: ($choice="github")
		
		//OPEN URL(Replace string($git.result; "\n"; ""))
		
		//______________________________________________________
	: ($choice="refresh")
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
End case 