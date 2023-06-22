property form : cs:C1710.formDelegate
property icon; more; branch; localChanges; initRepository; todo; fixme : cs:C1710.buttonDelegate
property fetch; push : cs:C1710.inputDelegate
property gitItems : cs:C1710.groupDelegate
property git : cs:C1710.Git

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.isSubform:=True:C214
	This:C1470.toBeInitialized:=False:C215
	
	// MARK:-Delegates 📦
	This:C1470.form:=cs:C1710.formDelegate.new(This:C1470)
	This:C1470.menu:=cs:C1710.menu
	
	// MARK:-
	This:C1470.currentBranch:=""
	
	This:C1470.timer:=20  // Timer value for refresh
	
	This:C1470.PACKAGE:=Folder:C1567("/PACKAGE"; *)
	This:C1470.SOURCES:=Folder:C1567("/SOURCES/"; *)
	
	This:C1470.form.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $c : Collection
	var $folder : 4D:C1709.Folder
	
	This:C1470.icon:=This:C1470.form.button.new("icon")
	This:C1470.todo:=This:C1470.form.button.new("todo")
	This:C1470.fixme:=This:C1470.form.button.new("fixme")
	
	This:C1470.gitItems:=This:C1470.form.group.new()
	This:C1470.more:=This:C1470.form.button.new("more").addToGroup(This:C1470.gitItems)
	This:C1470.branch:=This:C1470.form.button.new("branch").addToGroup(This:C1470.gitItems)
	This:C1470.localChanges:=This:C1470.form.button.new("localChanges").addToGroup(This:C1470.gitItems)
	This:C1470.fetch:=This:C1470.form.input.new("fetch").addToGroup(This:C1470.gitItems)
	This:C1470.swap:=This:C1470.form.static.new("swap").addToGroup(This:C1470.gitItems)
	This:C1470.push:=This:C1470.form.input.new("push").addToGroup(This:C1470.gitItems)
	This:C1470.initRepository:=This:C1470.form.button.new("initRepository").addToGroup(This:C1470.gitItems)
	
	This:C1470.fetch.setHelpTip("numberOfCommitsToBePulled")
	This:C1470.push.setHelpTip("numberOfCommitsToBePushed")
	This:C1470.localChanges.setHelpTip("numberOfChangesInTheLocalDirectory")
	
	This:C1470.initRepository.setHelpTip("clickToInitializeAsAGitRepository")
	
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
	
	$folder:=Folder:C1567(This:C1470.PACKAGE.platformPath; fk platform path:K87:2)  // Unsndboxed
	
	While ($folder#Null:C1517)\
		 && Not:C34($folder.folder(".git").exists)
		
		$folder:=$folder.parent
		
	End while 
	
	If ($folder#Null:C1517)\
		 && ($folder.exists)
		
		This:C1470.git:=cs:C1710.Git.new($folder)
		
	Else 
		
		This:C1470.git:=Null:C1517
		
	End if 
	
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
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.branch.catch($e; On Clicked:K2:4))
				
				This:C1470._doBranchMenu()
				
				//==============================================
			: (This:C1470.initRepository.catch($e; On Clicked:K2:4))
				
				This:C1470.git:=cs:C1710.Git.new()
				This:C1470.form.refresh()
				
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
				
				This:C1470._doTagMenu($e.objectName)
				
				//==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $branch : Text
	var $changes : Integer
	var $success : Boolean
	var $c : Collection
	var $git : cs:C1710.Git
	
	$git:=This:C1470.git
	
	If ($git#Null:C1517)
		
		$branch:=Form:C1466.branch || $git.currentBranch
		
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
				This:C1470.branch.setHelpTip(Replace string:C233(Get localized string:C991("IsTheCurrentBranch"); "{branch}"; $branch))
				
			Else 
				
				This:C1470.branch.foregroundColor:="red"
				This:C1470.branch.fontStyle:=Bold:K14:2
				This:C1470.branch.setHelpTip(Replace string:C233(\
					Replace string:C233(Replace string:C233(\
					Get localized string:C991("warningBranch"); "{branch}"; $branch)\
					; "{project}"; This:C1470.PACKAGE.name)\
					; "{version}"; This:C1470.version))
				
			End if 
			
			Form:C1466.branch:=This:C1470.currentBranch
			
			This:C1470.branch.setTitle(This:C1470.currentBranch)
			This:C1470.branch.bestSize(Align center:K42:3; 50; 140)
			
		End if 
		
		Form:C1466.fetchNumber:=$git.branchFetchNumber($branch)
		Form:C1466.pushNumber:=$git.branchPushNumber($branch)
		
		$changes:=$git.status()
		
		If ($git.status()>0)
			
			This:C1470.localChanges.setLinkedPopupMenu()\
				.setTitle(String:C10($git.status()))\
				.bestSize(Align left:K42:2)
			
		Else 
			
			This:C1470.localChanges.setNoPopupMenu()\
				.setTitle("0")\
				.bestSize(Align left:K42:2)
			
		End if 
		
		This:C1470.gitItems.show()
		This:C1470.initRepository.hide()
		
		This:C1470.form.refresh(60*This:C1470.timer)
		
	Else 
		
		This:C1470.gitItems.hide()
		This:C1470.initRepository.show()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doChangesMenu()
	
	var $tgt
	var $icon : Text
	var $o : Object
	var $c : Collection
	var $git : cs:C1710.Git
	var $classes; $forms; $menu; $methods; $others : cs:C1710.menu
	
	$git:=This:C1470.git
	
	If ($git.status()=0)
		
		// No change
		return 
		
	End if 
	
	For each ($o; $git.changes.orderBy("path"))
		
		$icon:=$o.status="@M@" ? "#Images/Main/modified.png"\
			 : $o.status="@D@" ? "#Images/Main/deleted.png"\
			 : $o.status="??" ? "#Images/Main/added.png"\
			 : $o.status="@R@" ? "#Images/Main/moved.png"\
			 : ""
		
		$c:=Split string:C1554($o.path; "/")
		
		Case of 
				
				//______________________________________________________
			: ($c.indexOf("Classes")=2)
				
				$classes:=$classes || This:C1470.menu.new()
				$classes.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path).icon($icon)
				
				//______________________________________________________
			: ($c.indexOf("Forms")=2)
				
				$forms:=$forms || This:C1470.menu.new()
				
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
				
				$methods:=$methods || This:C1470.menu.new()
				$methods.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path).icon($icon)
				
				//______________________________________________________
			Else 
				
				$others:=$others || This:C1470.menu.new()
				$others.append($c.remove(0; 2).join("/"); $o.path).icon($icon)
				
				//______________________________________________________
		End case 
	End for each 
	
	$menu:=This:C1470.menu.new()
	
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
	
	$tgt:=GIT Path($menu.choice; Folder:C1567(fk database folder:K87:14; *))
	
	Case of 
			
			//——————————————————————————————————
		: (Value type:C1509($tgt)=Is text:K8:3)  // Classe, Method,…
			
			If ($tgt="@.4DForm")
				
				FORM EDIT:C1749(String:C10(Split string:C1554($tgt; "/")[0]))
				
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
	var $git : cs:C1710.Git
	var $menu : cs:C1710.menu
	
	$git:=This:C1470.git
	
	$git.branch()
	
	If ($git.branches.length>0)
		
		$menu:=This:C1470.menu.new()
		
		For each ($o; $git.branches)
			
			$menu.append($o.name; $o.name).mark($o.current)
			
		End for each 
		
		//TODO:Change branch
		If ($menu.popup().selected)
			
			Form:C1466.branch:=$menu.choice
			This:C1470.form.refresh()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doMoreMenu()
	
	var $git : cs:C1710.Git
	var $menu : cs:C1710.menu
	
	$git:=This:C1470.git
	
	$menu:=This:C1470.menu.new()\
		.append("4DPop Git"; "tool").icon("/RESOURCES/Images/Menus/git.png")\
		.line()\
		.append(":xliff:openInTerminal"; "terminal").icon("/RESOURCES/Images/Menus/terminal.png")\
		.append(":xliff:showOnDisk"; "show").icon("/RESOURCES/Images/Menus/disk.png")\
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
				
				This:C1470.form.refresh()
				
				//______________________________________________________
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _doTagMenu($tag : Text)
	
	var $todo : Collection
	var $file : 4D:C1709.File
	var $menu : cs:C1710.menu
	
	$todo:=New collection:C1472
	
	For each ($file; This:C1470.SOURCES.files(fk recursive:K87:7).query("extension = .4dm").orderBy("path"))
		
		If (Match regex:C1019("(?mi-s)//\\s*"+$tag+":"; $file.getText(); 1))
			
			$todo.push($file)
			
		End if 
	End for each 
	
	$menu:=This:C1470.menu.new("no-localization")
	
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
				
				If ($file.path="@method.4dm")
					
					$menu.icon("|Images/ObjectIcons/Icon_602.png")
					
				Else 
					
					$menu.icon("|Images/ObjectIcons/Icon_601.png")
					
				End if 
				
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