Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.isSubform:=True:C214
	
	This:C1470.currentBranch:=""
	
	This:C1470.timer:=20  // Timer value for refresh
	
	// 📌 The initialization is deferred to the first update
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $c : Collection
	var $folder : 4D:C1709.Folder
	var $group : cs:C1710.group
	
	$group:=This:C1470.group("gitItems")
	
	This:C1470.button("icon")
	
	This:C1470.button("more").addToGroup($group)
	
	This:C1470.button("branch").addToGroup($group)
	
	This:C1470.button("localChanges").addToGroup($group)
	
	This:C1470.input("fetch").addToGroup($group)
	This:C1470.formObject("swap").addToGroup($group)
	This:C1470.input("push").addToGroup($group)
	
	This:C1470.button("initRepository")
	
	This:C1470.button("todo")
	This:C1470.button("fixme")
	
	This:C1470.initRepository.setHelpTip(Get localized string:C991("clickToInitializeAsAGitRepository"))
	This:C1470.fetch.setHelpTip(Get localized string:C991("numberOfCommitsToBePulled"))
	This:C1470.push.setHelpTip(Get localized string:C991("numberOfCommitsToBePushed"))
	This:C1470.localChanges.setHelpTip(Get localized string:C991("numberOfChangesInTheLocalDirectory"))
	
	Form:C1466.fetchNumber:=0
	Form:C1466.pushNumber:=0
	
	$c:=Split string:C1554(Application version:C493; "")
	
	This:C1470.release:=$c[2]#"0"
	This:C1470.lts:=Not:C34(This:C1470.release)
	
	This:C1470.major:=$c[0]+$c[1]
	This:C1470.minor:=This:C1470.release ? "R"+$c[2] : "."+$c[3]
	This:C1470.alpha:=Application version:C493(*)="A@"
	
	This:C1470.version:=This:C1470.major+This:C1470.minor
	
	If (This:C1470.alpha)
		
		This:C1470.version:="DEV ("+This:C1470.version+")"
		
	End if 
	
	$folder:=Folder:C1567(Folder:C1567("/PACKAGE"; *).platformPath; fk platform path:K87:2)
	
	While ($folder#Null:C1517)\
		 && Not:C34($folder.folder(".git").exists)
		
		$folder:=$folder.parent
		
	End while 
	
	If ($folder#Null:C1517)\
		 && ($folder.exists)
		
		This:C1470.gitInstance:=cs:C1710.git.new($folder)
		
	Else 
		
		This:C1470.gitInstance:=Null:C1517
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : Object)
	
	$e:=$e || FORM Event:C1606
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.branch.catch($e; On Clicked:K2:4))
				
				This:C1470._doBranchMenu()
				
				//==============================================
			: (This:C1470.initRepository.catch($e; On Clicked:K2:4))
				
				This:C1470.gitInstance:=cs:C1710.git.new()
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.more.catch($e; On Clicked:K2:4))
				
				This:C1470._doMoreMenu()
				
				//==============================================
			: (This:C1470.localChanges.catch($e; On Clicked:K2:4))
				
				This:C1470._doChangesMenu()
				
				//==============================================
			: (This:C1470.icon.catch($e; On Clicked:K2:4))
				
				GIT OPEN
				
				//==============================================
			: (This:C1470.todo.catch($e; On Clicked:K2:4))\
				 | (This:C1470.fixme.catch($e; On Clicked:K2:4))
				
				This:C1470._doTag($e.objectName)
				
				//==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $branch : Text
	var $success : Boolean
	var $c : Collection
	var $git : cs:C1710.git
	
	This:C1470.stopTimer()
	
	If (This:C1470.toBeInitialized)
		
		This:C1470.toBeInitialized:=True:C214
		
		This:C1470.init()
		
	End if 
	
	$git:=This:C1470.gitInstance
	
	If ($git#Null:C1517)
		
		$branch:=$git.currentBranch
		
		If ($branch#This:C1470.currentBranch)
			
			This:C1470.currentBranch:=$branch
			
			If (This:C1470.alpha)
				
				$success:=(This:C1470.currentBranch="main")\
					 || (This:C1470.currentBranch="master")\
					 || (This:C1470.currentBranch=(This:C1470.major+This:C1470.minor+"@"))\
					 || (Split string:C1554(This:C1470.currentBranch; "/").length>1)
				
			Else 
				
				If (This:C1470.release)
					
					$success:=(This:C1470.currentBranch=(This:C1470.version)+"@")\
						 || (This:C1470.currentBranch=(This:C1470.major+"RX"))
					
				Else 
					
					$success:=(This:C1470.currentBranch=(This:C1470.version)+"@")\
						 || (This:C1470.currentBranch=(This:C1470.major+".X"))
					
				End if 
			End if 
			
			If ($success)
				
				This:C1470.branch.foregroundColor:=Foreground color:K23:1
				This:C1470.branch.fontStyle:=Plain:K14:1
				This:C1470.branch.setPicture("/Images/widget/branch_mini.png")
				This:C1470.branch.setHelpTip(Replace string:C233(Get localized string:C991("IsTheCurrentBranch"); "{$branch}"; $branch))
				
			Else 
				
				This:C1470.branch.setPicture("/Images/widget/branch_mini_warning.png")
				This:C1470.branch.foregroundColor:="red"
				This:C1470.branch.fontStyle:=Bold:K14:2
				This:C1470.branch.setHelpTip(Replace string:C233(\
					Replace string:C233(Replace string:C233(\
					Get localized string:C991("warningBranch"); "{branch}"; $branch)\
					; "{project}"; Folder:C1567("/PACKAGE"; *).name)\
					; "{version}\" de 4D.\"}"; This:C1470.version))
				
			End if 
		End if 
		
		Form:C1466.fetchNumber:=$git.branchFetchNumber($branch)
		Form:C1466.pushNumber:=$git.branchPushNumber($branch)
		
		This:C1470.localChanges.setTitle(String:C10($git.status()))
		
		This:C1470.gitItems.show()
		This:C1470.initRepository.hide()
		
		This:C1470.refresh(60*This:C1470.timer)
		
	Else 
		
		This:C1470.gitItems.hide()
		This:C1470.initRepository.show()
		
	End if 
	
	This:C1470.branch.setTitle(This:C1470.currentBranch)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doChangesMenu()
	
	var $tgt
	var $icon : Text
	var $o : Object
	var $c : Collection
	var $git : cs:C1710.git
	var $classes; $forms; $menu; $methods; $others : cs:C1710.menu
	
	$git:=This:C1470.gitInstance
	
	If ($git.status()=0)
		
		// No change
		return 
		
	End if 
	
	For each ($o; $git.changes.orderBy("path"))
		
		$icon:=$o.status="@M@" ? "🟡 "\
			 : $o.status="@D@" ? "🔴 "\
			 : $o.status="??" ? "🟢 "\
			 : "⚫️ "
		
		$c:=Split string:C1554($o.path; "/")
		
		Case of 
				
				//______________________________________________________
			: ($c.indexOf("Classes")=2)
				
				$classes:=$classes || cs:C1710.menu.new()
				$classes.append($icon+Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path)
				
				//______________________________________________________
			: ($c.indexOf("Forms")=2)
				
				$forms:=$forms || cs:C1710.menu.new()
				
				Case of 
						
						//______________________________________________________
					: ($c[$c.length-1]="form.4DForm")
						
						$forms.append($icon+$c[3]; $o.path)
						
						//______________________________________________________
					: ($c.indexOf("ObjectMethods")=4)
						
						$forms.append($icon+Replace string:C233($c.remove(0; 3).remove(1; 1).join("/"); ".4dm"; ""); $o.path)
						
						//______________________________________________________
					Else 
						
						$forms.append($icon+Replace string:C233($c.remove(0; 3).join("/"); ".4dform"; ""); $o.path)
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: ($c.indexOf("Methods")=2)
				
				$methods:=$methods || cs:C1710.menu.new()
				$methods.append($icon+Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path)
				
				//______________________________________________________
			Else 
				
				$others:=$others || cs:C1710.menu.new()
				$others.append($icon+$c.remove(0; 2).join("/"); $o.path)
				
				//______________________________________________________
		End case 
	End for each 
	
	$menu:=cs:C1710.menu.new()\
		.append(":xliff:classes"; $classes)\
		.append(":xliff:methods"; $methods)\
		.append(":xliff:forms"; $forms)\
		.append(":xliff:others"; $others)
	
	If (Not:C34($menu.popup().selected))
		
		return 
		
	End if 
	
	$tgt:=GIT Path($menu.choice; Folder:C1567(fk database folder:K87:14; *))
	
	Case of 
			
			//——————————————————————————————————
		: (Value type:C1509($tgt)=Is text:K8:3)  // Classe, Method,…
			
			If ($tgt="@.4DForm")
				
				FORM EDIT:C1749(String:C10(Split string:C1554($tgt; "/")[0]))
				
			Else 
				
				METHOD OPEN PATH:C1213($tgt; *)
				
			End if 
			
			//——————————————————————————————————
		: (Value type:C1509($tgt)=Is object:K8:27)\
			 && (OB Instance of:C1731($tgt; 4D:C1709.Folder))  // Folder
			
			SHOW ON DISK:C922($tgt.platformPath)
			
			//——————————————————————————————————
		: (Value type:C1509($tgt)=Is object:K8:27)\
			 && (OB Instance of:C1731($tgt; 4D:C1709.File))  // File
			
			If (Bool:C1537($tgt.exists))
				
				If ($tgt.extension=".zip")\
					 | ($tgt.extension=".dmg")\
					 | ($tgt.extension=".dylib")\
					 | ($tgt.extension=".4D@")
					
					SHOW ON DISK:C922($tgt.platformPath)
					
				Else 
					
					OPEN URL:C673($tgt.platformPath)
					
				End if 
				
			Else 
				
				ALERT:C41(Replace string:C233(Get localized string:C991("fileDeleted"); "{path}"; $tgt.path))
				
			End if 
			
			//——————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doBranchMenu()
	
	var $o : Object
	var $git : cs:C1710.git
	var $menu : cs:C1710.menu
	
	$git:=This:C1470.gitInstance
	
	$git.branch()
	
	If ($git.branches.length>0)
		
		$menu:=cs:C1710.menu.new()
		
		For each ($o; $git.branches)
			
			$menu.append($o.name).mark($o.current)
			
		End for each 
		
		If (Not:C34($menu.popup().selected))
			
			return 
			
		End if 
		
		//TODO:Change branch
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doMoreMenu()
	
	var $git : cs:C1710.git
	var $menu : cs:C1710.menu
	
	$git:=This:C1470.gitInstance
	
	$menu:=cs:C1710.menu.new()\
		.append("4DPop Git"; "tool").icon("/RESOURCES/Images/Common/git.png")\
		.line()\
		.append(":xliff:openInTerminal"; "terminal").icon("/RESOURCES/Images/Menus/terminal.png")\
		.append(":xliff:showOnDisk"; "show").icon("/RESOURCES/Images/Menus/show.png")\
		.line()\
		.append(":xliff:viewOnGithub"; "github").icon("/RESOURCES/Images/Menus/gitHub.png").enable($git.execute("config --get remote.origin.url"))\
		.line()\
		.append(":xliff:refresh"; "refresh").icon("/RESOURCES/Images/Menus/refresh.png")
	
	If ($menu.popup(This:C1470.more).selected)
		
		Case of 
				
				//———————————————————————————————————————
			: ($menu.choice="tool")
				
				GIT OPEN
				
				//———————————————————————————————————————
			: ($menu.choice="terminal")\
				 | ($menu.choice="show")
				
				$git.open($menu.choice)
				
				//———————————————————————————————————————
			: ($menu.choice="github")
				
				OPEN URL:C673(Replace string:C233($git.result; "\n"; ""))
				
				//———————————————————————————————————————
			: ($menu.choice="refresh")
				
				This:C1470.refresh()
				
				//______________________________________________________
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doTag($tag : Text)
	
	var $t : Text
	var $todo : Collection
	var $file : 4D:C1709.File
	var $menu : cs:C1710.menu
	
	$todo:=New collection:C1472
	
	For each ($file; Folder:C1567("/SOURCES/"; *).files(fk recursive:K87:7).query("extension = .4dm"))
		
		$t:=$file.getText()
		
		If (Match regex:C1019("(?mi-s)//\\s*"+$tag+":"; $t; 1))
			
			$todo.push($file)
			
		End if 
	End for each 
	
	$menu:=cs:C1710.menu.new("no-localization")
	
	For each ($file; $todo)
		
		$menu.append($file.name; $file.path)
		
		Case of 
				
				//______________________________________________________
			: (Position:C15("/SOURCES/Classes"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_628.png")
				
				//______________________________________________________
			: (Position:C15("/SOURCES/Methods"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_602.png")
				
				//______________________________________________________
			: (Position:C15("/SOURCES/Forms"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_601.png")
				
				//______________________________________________________
			: (Position:C15("/SOURCES/DatabaseMethods"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_622.png")
				
				//______________________________________________________
			: (Position:C15("/SOURCES/Triggers"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_600.png")
				
				//______________________________________________________
		End case 
		
	End for each 
	
	If ($menu.popup().selected)
		
		METHOD OPEN PATH:C1213(This:C1470._resolvePath($menu.choice); *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Transforms the given system path into a 4D path name
Function _resolvePath($path : Text) : Text
	
	$path:=Replace string:C233($path; "/SOURCES/Classes"; "[class]")
	$path:=Replace string:C233($path; "/SOURCES/Methods/"; "")
	$path:=Replace string:C233($path; "/SOURCES/DatabaseMethods"; "[databaseMethod]")
	$path:=Replace string:C233($path; "/SOURCES/Triggers"; "[trigger]")
	$path:=Replace string:C233($path; "/SOURCES/Forms"; "[projectForm]")
	$path:=Replace string:C233($path; "/ObjectMethods"; "")
	
	return Replace string:C233($path; ".4dm"; "")