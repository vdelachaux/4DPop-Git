var $menu : cs:C1710.menu

$menu:=cs:C1710.menu.new()

$menu.append("Refresh"; "refresh")

If ($menu.popup().selected)
	
	Case of 
			
			//______________________________________________________
		: ($menu.choice="refresh")
			
			SET TIMER:C645(-1)
			
			//______________________________________________________
	End case 
End if 