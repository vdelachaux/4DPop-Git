//%attributes = {}
#DECLARE($menu : cs:C1710.menu)

If (Is macOS:C1572)
	
	If (File:C1566("/usr/local/bin/fork").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png")
		
	End if 
	
	If (File:C1566("/usr/local/bin/github").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png")
		
	End if 
	
	If (File:C1566("/usr/local/bin/stree").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Sourcetree"); "sourcetree").icon("/RESOURCES/Images/Menus/stree.png")
		
	End if 
	
Else 
	
	If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/Fork/Fork.exe").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png")
		
	End if 
	
	If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/GitHubDesktop.exe").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png")
		
	End if 
	
	If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/Sourcetree.exe").exists)
		
		$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Sourcetree"); "sourcetree").icon("/RESOURCES/Images/Menus/stree.png")
		
	End if 
End if 