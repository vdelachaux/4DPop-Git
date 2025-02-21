property isSubform:=True:C214
property toBeInitialized:=False:C215
property currentBranch:=""

property release; lts; alpha : Boolean
property major; minor; version : Text

// MARK: Delegates 📦
property form : cs:C1710.form
property Git:=cs:C1710.Git.me

// MARK: Constants 🧰
property PACKAGE:=Folder:C1567(Folder:C1567("/PACKAGE"; *).platformPath; fk platform path:K87:2)  // Unsandboxed
property SOURCES:=Folder:C1567("/SOURCES/"; *)
property timer:=20  // Timer value for refresh

// MARK: UI 🖥️
property icon; \
more; \
branch; \
localChanges; \
initRepository; \
todo; \
fixme : cs:C1710.button

property fetch; \
push : cs:C1710.input

property swap : cs:C1710.static

property gitItems : cs:C1710.group

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	This:C1470.form.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.icon:=This:C1470.form.Button("icon")
	This:C1470.todo:=This:C1470.form.Button("todo")
	This:C1470.fixme:=This:C1470.form.Button("fixme")
	
	This:C1470.gitItems:=This:C1470.form.group.new()
	This:C1470.more:=This:C1470.form.Button("more").addToGroup(This:C1470.gitItems)
	This:C1470.branch:=This:C1470.form.Button("branch").addToGroup(This:C1470.gitItems)
	This:C1470.localChanges:=This:C1470.form.Button("localChanges").addToGroup(This:C1470.gitItems)
	This:C1470.fetch:=This:C1470.form.Input("fetch").addToGroup(This:C1470.gitItems)
	This:C1470.swap:=This:C1470.form.Static("swap").addToGroup(This:C1470.gitItems)
	This:C1470.push:=This:C1470.form.Input("push").addToGroup(This:C1470.gitItems)
	
	This:C1470.initRepository:=This:C1470.form.Button("initRepository").addToGroup(This:C1470.gitItems)
	
	var $c:=Split string:C1554(Application version:C493; "")
	
	This:C1470.release:=$c[2]#"0"
	This:C1470.lts:=Not:C34(This:C1470.release)
	
	This:C1470.major:=$c[0]+$c[1]
	This:C1470.minor:=This:C1470.release ? "R"+$c[2] : "."+$c[3]
	This:C1470.alpha:=Application version:C493(*)="A@"
	
	This:C1470.version:=This:C1470.major+This:C1470.minor
	
	If (This:C1470.alpha)
		
		This:C1470.version:="DEV ("+This:C1470.version+")"
		
	End if 
	
	Form:C1466.fetchNumber:=0
	Form:C1466.pushNumber:=0
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	If ($e.form)  // <== FORM METHOD
		
		Case of 
				
				//______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.timer)
				
				This:C1470.form.update()
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	Case of   // <== WIDGETS METHOD
			
			//==============================================
		: (This:C1470.branch.catch($e; [On Clicked:K2:4; On Long Click:K2:37; On Alternative Click:K2:36]))
			
			This:C1470._doBranchMenu()
			
			//==============================================
		: (This:C1470.initRepository.catch($e; On Clicked:K2:4))
			
			Form:C1466.init:=True:C214
			This:C1470.form.refresh(60)
			
			This:C1470.Git.init()
			
			4DPop Git
			
			//==============================================
		: (This:C1470.more.catch($e; On Clicked:K2:4))
			
			This:C1470._doMoreMenu()
			
			//==============================================
		: (This:C1470.localChanges.catch($e; [On Clicked:K2:4; On Long Click:K2:37; On Alternative Click:K2:36]))
			
			This:C1470._doChangesMenu()
			
			//==============================================
		: (This:C1470.icon.catch($e; On Clicked:K2:4))
			
			If (This:C1470.Git.root=Null:C1517) || Not:C34(This:C1470.Git.root.exists)
				
				Form:C1466.init:=True:C214
				This:C1470.form.refresh(60)
				
			End if 
			
			4DPop Git
			
			//==============================================
		: (This:C1470.todo.catch($e; On Clicked:K2:4))\
			 | (This:C1470.fixme.catch($e; On Clicked:K2:4))
			
			This:C1470._doTagMenu($e.objectName)
			
			//==============================================
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.form.appendEvents([On Clicked:K2:4; On Long Click:K2:37; On Alternative Click:K2:36])
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $git : cs:C1710.Git:=This:C1470.Git
	
	If (Bool:C1537(Form:C1466.init))
		
		$git._updateWorkspace()
		
		If ($git.root#Null:C1517)\
			 && ($git.root.exists)
			
			Form:C1466.init:=False:C215
			
		End if 
	End if 
	
	If ($git.root=Null:C1517) || Not:C34($git.root.exists)
		
		This:C1470.gitItems.hide()
		This:C1470.initRepository.show()
		
		If (Bool:C1537(Form:C1466.init))
			
			This:C1470.form.refresh(60)
			
		End if 
		
		return 
		
	End if 
	
	If ($git.branches.length=0)
		
		$git.branch()
		
	End if 
	
	var $branch : Text:=$git.branches.query("current = true").first().name
	
	If ($branch#This:C1470.currentBranch)
		
		This:C1470.currentBranch:=$branch
		
		If (This:C1470.alpha)
			
			var $success : Boolean:=(This:C1470.currentBranch="main")\
				 || (This:C1470.currentBranch="master")\
				 || (This:C1470.currentBranch=(This:C1470.major+This:C1470.minor+"@"))\
				 || (Split string:C1554(This:C1470.currentBranch; "/").length>1)
			
		Else 
			
			If (This:C1470.release)
				
				$success:=(This:C1470.currentBranch=(This:C1470.version+"@"))\
					 || (This:C1470.currentBranch=(This:C1470.major+"Rx"))
				
			Else 
				
				$success:=(This:C1470.currentBranch=(This:C1470.version+"@"))\
					 || (This:C1470.currentBranch=(This:C1470.major+".x"))
				
			End if 
		End if 
		
		If ($success)
			
			This:C1470.branch.foregroundColor:=Foreground color:K23:1
			This:C1470.branch.fontStyle:=Plain:K14:1
			This:C1470.branch.setHelpTip(Replace string:C233(Localized string:C991("IsTheCurrentBranch"); "{branch}"; $branch))
			
		Else 
			
			This:C1470.branch.foregroundColor:="red"
			This:C1470.branch.fontStyle:=Bold:K14:2
			This:C1470.branch.setHelpTip(Replace string:C233(\
				Replace string:C233(Replace string:C233(\
				Localized string:C991("warningBranch"); "{branch}"; $branch)\
				; "{project}"; This:C1470.PACKAGE.name)\
				; "{version}"; This:C1470.version))
			
		End if 
	End if 
	
	This:C1470.branch.setTitle(This:C1470.currentBranch)
	This:C1470.branch.bestSize(Align center:K42:3; 50; 140)
	
	$git.branch()
	This:C1470.branch.linkedPopupMenu:=$git.branches.length>1
	
	Form:C1466.branch:=This:C1470.currentBranch
	
	Form:C1466.fetchNumber:=$git.branchFetchNumber($branch)
	Form:C1466.pushNumber:=$git.branchPushNumber($branch)
	
	var $changes : Integer:=$git.status()
	
	If ($changes>0)
		
		This:C1470.localChanges.setLinkedPopupMenu().setTitle(String:C10($changes))
		
	Else 
		
		This:C1470.localChanges.setNoPopupMenu().setTitle("0")
		
	End if 
	
	This:C1470.localChanges.bestSize({minWidth: 25})
	
	This:C1470.gitItems.show()
	This:C1470.initRepository.hide()
	
	This:C1470.form.refresh(60*This:C1470.timer)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doChangesMenu()
	
	var $classes; $forms; $menu; $methods; $others : cs:C1710.menu
	var $git : cs:C1710.Git:=This:C1470.Git
	
	If ($git.status()=0)  // No change
		
		return 
		
	End if 
	
	var $o : Object
	For each ($o; $git.changes.orderBy("path"))
		
		var $icon : Text:=$o.status="@M@" ? "#Images/Main/modified.svg"\
			 : $o.status="@D@" ? "#Images/Main/deleted.svg"\
			 : $o.status="??" ? "#Images/Main/added.svg"\
			 : $o.status="@R@" ? "#Images/Main/moved.svg"\
			 : ""
		
		var $c:=Split string:C1554($o.path; "/")
		
		Case of 
				
				//______________________________________________________
			: ($c.indexOf("Classes")=2)
				
				$classes:=$classes || cs:C1710.menu.new({embedded: True:C214})
				$classes.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path).icon($icon)
				
				//______________________________________________________
			: ($c.indexOf("Forms")=2)
				
				$forms:=$forms || cs:C1710.menu.new({embedded: True:C214})
				
				Case of 
						
						//______________________________________________________
					: ($c[$c.length-1]="form.4DForm")
						
						$forms.append($c[3]; $o.path).icon($icon)
						
						//______________________________________________________
					: ($c.indexOf("ObjectMethods")=4)
						
						$forms.append(Replace string:C233($c.remove(0; 3).remove(1; 1).join("/"); ".4dm"; ""); $o.path).icon($icon)
						
						//______________________________________________________
					Else 
						
						$forms.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dform"; ""); $o.path).icon($icon)
						
						//______________________________________________________
				End case 
				
				//______________________________________________________
			: ($c.indexOf("Methods")=2)
				
				$methods:=$methods || cs:C1710.menu.new({embedded: True:C214})
				$methods.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path).icon($icon)
				
				//______________________________________________________
			Else 
				
				$others:=$others || cs:C1710.menu.new({embedded: True:C214})
				$others.append($c.join("/"); $o.path).icon($icon)
				
				//______________________________________________________
		End case 
	End for each 
	
	$menu:=cs:C1710.menu.new({embedded: True:C214})
	
	If ($classes#Null:C1517)
		
		If ($classes.itemCount()>0)
			
			$menu.append(":xliff:classes"; $classes)\
				.icon("|Images/ObjectIcons/Icon_628.png")
			
		Else 
			
			$classes.release()
			
		End if 
	End if 
	
	If ($methods#Null:C1517)
		
		If ($methods.itemCount()>0)
			
			$menu.append(":xliff:methods"; $methods)\
				.icon("|Images/ObjectIcons/Icon_602.png")
			
		Else 
			
			$methods.release()
			
		End if 
	End if 
	
	If ($forms#Null:C1517)
		
		If ($forms.itemCount()>0)
			
			$menu.append(":xliff:forms"; $forms)\
				.icon("|Images/ObjectIcons/Icon_602.png")
			
		Else 
			
			$forms.release()
			
		End if 
	End if 
	
	If ($others#Null:C1517)
		
		If ($others.itemCount()>0)
			
			$menu.append(":xliff:others"; $others)\
				.icon("|Images/ObjectIcons/Icon_459.png")
			
		Else 
			
			$others.release()
			
		End if 
	End if 
	
	If (Not:C34($menu.popup().selected))
		
		return 
		
	End if 
	
	// %W-550.11
	var $tgt:=This:C1470.Git.getTarget($menu.choice; Folder:C1567(fk database folder:K87:14; *))
	//%W+550.11
	
	Case of 
			
			//——————————————————————————————————
		: (Value type:C1509($tgt)=Is text:K8:3)  // Classe, Method,…
			
			$c:=Split string:C1554($tgt; "/")
			
			If ($c.last()="@.4DForm")  // Form
				
				$c.pop()
				FORM EDIT:C1749(String:C10($c.last()))
				
			Else 
				
				// Todo:Diff ?
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
					 || ($tgt.extension=".dmg")\
					 || ($tgt.extension=".dylib")\
					 || ($tgt.extension=".4D@")
					
					SHOW ON DISK:C922($tgt.platformPath)
					
				Else 
					
					OPEN URL:C673($tgt.platformPath)
					
				End if 
				
			Else 
				
				ALERT:C41(Replace string:C233(Localized string:C991("fileDeleted"); "{path}"; $tgt.path))
				
			End if 
			
			//——————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doBranchMenu()
	
	var $git : cs:C1710.Git:=This:C1470.Git
	
	$git.branch()
	
	If ($git.branches.length>0)
		
		var $menu:=cs:C1710.menu.new()
		var $o : Object
		var $noChange : Boolean:=$git.status()=0
		
		For each ($o; $git.branches)
			
			$menu.append($o.name; $o.name).mark($o.current).enable($o.current || $noChange)
			
		End for each 
		
		// TODO: Change branch
		
		If ($menu.popup().selected)
			
			Form:C1466.branch:=$menu.choice
			$git.stash("autostash "+String:C10(Current date:C33; ISO date:K1:8))
			$git.checkout(Form:C1466.branch)
			RELOAD PROJECT:C1739
			This:C1470.form.refresh()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doMoreMenu()
	
	var $git : cs:C1710.Git:=This:C1470.Git.branch()
	var $available : Boolean:=$git.branches.length>0
	
	
	var $menu:=cs:C1710.menu.new({embedded: True:C214})\
		.append(":xliff:repoManager"; "tool").icon("/RESOURCES/Images/Menus/git.png")\
		.line()\
		.append(":xliff:saveSnapshot"; "snapshot").icon("/RESOURCES/Images/Menus/stash.png")\
		.line()\
		.append(":xliff:openInTerminal"; "terminal").icon("/RESOURCES/Images/Menus/terminal.png")\
		.append(":xliff:showOnDisk"; "show").icon("/RESOURCES/Images/Menus/disk.png")\
		.line()\
		.append(":xliff:viewOnGithub"; "github").icon("/RESOURCES/Images/Menus/gitHub.png").enable($available)\
		.line()\
		.append(":xliff:refresh"; "refresh").icon("/RESOURCES/Images/Menus/refresh.png")
	
	$menu.line()\
		.append("Settings"; "settings")
	
	$menu.line()
	
	If (Is macOS:C1572)
		
		If (File:C1566("/usr/local/bin/fork").exists)
			
			$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png").enable($available)
			
		End if 
		
		If (File:C1566("/usr/local/bin/github").exists)
			
			$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png").enable($available)
			
		End if 
		
	Else 
		
		// TODO:On Windows
		
		If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/Fork/Fork.exe").exists)
			
			$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png").enable($available)
			
		End if 
		
		If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/bin/github").exists)
			
			$menu.append(Replace string:C233(Localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png").enable($available)
			
		End if 
	End if 
	
	Case of 
			
			//———————————————————————————————————————
		: (Not:C34($menu.popup(This:C1470.more).selected))
			
			// It's your choice
			
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
		: ($menu.choice="tool")
			
			4DPop Git
			
			This:C1470.form.setTimer(100)
			
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
		: ($menu.choice="snapshot")
			
			var $t : Text
			$t:=Request:C163(Localized string:C991("name(optional)"); ""; Localized string:C991("saveSnapshot"))
			
			If (OK=0)
				
				return 
				
			End if 
			
			$git.stash("snapshot"; $t)
			
			//———————————————————————————————————————
		: ($menu.choice="settings")
			
			GIT SETTINGS
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doTagMenu($tag : Text)
	
	var $todo:=[]
	
	var $file : 4D:C1709.File
	
	For each ($file; This:C1470.SOURCES.files(fk recursive:K87:7).query("extension = .4dm").orderBy("path"))
		
		If (Match regex:C1019("(?mi-s) // \\s*"+$tag+":"; $file.getText(); 1))
			
			$todo.push($file)
			
		End if 
	End for each 
	
	var $menu:=cs:C1710.menu.new({localize: False:C215; embedded: True:C214})
	
	For each ($file; $todo)
		
		$menu.append($file.name; $file.path)
		
		Case of 
				
				// ______________________________________________________
			: (Position:C15("/SOURCES/Classes"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_628.png")
				
				// ______________________________________________________
			: (Position:C15("/SOURCES/Methods"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_602.png")
				
				// ______________________________________________________
			: (Position:C15("/SOURCES/Forms"; $file.path)=1)
				
				If ($file.path="@method.4dm")
					
					$menu.icon("|Images/ObjectIcons/Icon_602.png")
					
				Else 
					
					$menu.icon("|Images/ObjectIcons/Icon_601.png")
					
				End if 
				
				// ______________________________________________________
			: (Position:C15("/SOURCES/DatabaseMethods"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_622.png")
				
				// ______________________________________________________
			: (Position:C15("/SOURCES/Triggers"; $file.path)=1)
				
				$menu.icon("|Images/ObjectIcons/Icon_600.png")
				
				// ______________________________________________________
		End case 
	End for each 
	
	If ($menu.popup().selected)
		
		METHOD OPEN PATH:C1213(This:C1470._resolvePath($menu.choice); *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Transforms the given system path into a 4D path name
Function _resolvePath($path : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: (Position:C15("/SOURCES/Classes"; $path)=1)
			
			$path:="[class]"+Delete string:C232($path; 1; 16)
			
			//______________________________________________________
		: (Position:C15("/SOURCES/Methods"; $path)=1)
			
			$path:=Delete string:C232($path; 1; 17)
			
			//______________________________________________________
		: (Position:C15("/SOURCES/Forms"; $path)=1)
			
			$path:="[projectForm]"+Delete string:C232($path; 1; 14)
			
			If ($path="@method.4dm")
				
				$path:=Replace string:C233($path; "/method.4dm"; "/{formMethod}")
				
			Else 
				
				$path:=Replace string:C233($path; "/ObjectMethods"; "")
				
			End if 
			
			//______________________________________________________
		: (Position:C15("/SOURCES/DatabaseMethods"; $path)=1)
			
			$path:="[databaseMethod]"+Delete string:C232($path; 1; 24)
			
			//______________________________________________________
		: (Position:C15("/SOURCES/Triggers"; $path)=1)
			
			$path:="[trigger]"+Delete string:C232($path; 1; 17)
			
			//______________________________________________________
	End case 
	
	return Replace string:C233($path; ".4dm"; "")