//%attributes = {}
#DECLARE($menu : cs:C1710.menu)

var $git:=cs:C1710.Git.me

Case of 
		//———————————————————————————————————————
	: ($menu.choice="tool")
		
		4DPop Git
		
		This:C1470.form.setTimer(100)
		
		//———————————————————————————————————————
	: ($menu.choice="snapshot")
		
		var $t:=Request:C163(Localized string:C991("name(optional)"); ""; Localized string:C991("saveSnapshot"))
		
		If (OK=0)
			
			return 
			
		End if 
		
		$git.stash("snapshot"; $t)
		
		//———————————————————————————————————————
	: ($menu.choice="terminal")\
		 | ($menu.choice="show")
		
		$git.open($menu.choice)
		
		//———————————————————————————————————————
	: ($menu.choice="github")
		
		OPEN URL:C673(Replace string:C233($git.result; "\n"; ""))
		
		//———————————————————————————————————————
	: ($menu.choice="refresh")
		
		This:C1470.form.refresh()
		
		//———————————————————————————————————————
	: ($menu.choice="fork")
		
		If (Is macOS:C1572)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $git.workspace.platformPath)
			LAUNCH EXTERNAL PROCESS:C811("/usr/local/bin/fork open")
			
		Else 
			
			LAUNCH EXTERNAL PROCESS:C811(Folder:C1567(fk home folder:K87:24).file("AppData/Local/Fork/Fork.exe").platformPath+" "+$git.workspace.platformPath)
			
		End if 
		
		//———————————————————————————————————————
	: ($menu.choice="githubDesktop")
		
		If (Is macOS:C1572)
			
			LAUNCH EXTERNAL PROCESS:C811("/usr/local/bin/github \""+$git.workspace.path+"\"")
			
		Else 
			
			LAUNCH EXTERNAL PROCESS:C811("github \""+$git.workspace.platformPath+"\"")
			
		End if 
		
		//———————————————————————————————————————
	: ($menu.choice="sourcetree")
		
		If (Is macOS:C1572)
			
			LAUNCH EXTERNAL PROCESS:C811("/usr/local/bin/stree \""+Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2).path+"\"")
			
		Else 
			
			LAUNCH EXTERNAL PROCESS:C811(Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/Sourcetree.exe").platformPath+" "+$git.workspace.platformPath)
			
		End if 
		
		//———————————————————————————————————————
	: ($menu.choice="github")
		
		OPEN URL:C673(Replace string:C233($git.result; "\n"; ""))
		
		//———————————————————————————————————————
	: ($menu.choice="settings")
		
		GIT SETTINGS
		
		//______________________________________________________
End case 