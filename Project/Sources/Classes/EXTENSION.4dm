Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.isSubform:=True:C214
	This:C1470.timer:=20
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	var $group : cs:C1710.group
	
	$group:=This:C1470.group("gitItems")
	This:C1470.input("branch").addToGroup($group)
	This:C1470.formObject("localChangesIcon").addToGroup($group)
	This:C1470.input("changes").addToGroup($group)
	This:C1470.input("fetch").addToGroup($group)
	This:C1470.formObject("todo").addToGroup($group)
	This:C1470.input("push").addToGroup($group)
	This:C1470.button("more").addToGroup($group)
	
	This:C1470.button("openGitWindow")
	This:C1470.button("initRepository")
	
	This:C1470.openGitWindow.setHelpTip("Open the main git window…")
	This:C1470.initRepository.setHelpTip("Click to initialize as a git repository")
	This:C1470.fetch.setHelpTip("Number of commits to be pulled")
	This:C1470.push.setHelpTip("Number of commits to be pushed")
	This:C1470.changes.setHelpTip("Number of changes in the local directory")
	
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
		
		var $git : cs:C1710.git
		$git:=This:C1470.gitInstance
		
		Case of 
				
				//==============================================
			: (This:C1470.initRepository.catch($e; On Clicked:K2:4))
				
				This:C1470.gitInstance:=cs:C1710.git.new()
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.more.catch($e; On Clicked:K2:4))
				
				var $menu : cs:C1710.menu
				$menu:=cs:C1710.menu.new()\
					.append("Open in Terminal"; "terminal")\
					.append("Open in Finder"; "show")\
					.line()\
					.append("View on Github"; "github").enable($git.execute("config --get remote.origin.url"))\
					.line()\
					.append("Refresh"; "refresh")
				
				If ($menu.popup(This:C1470.more).selected)
					
					Case of 
							
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
				
				//==============================================
			: (This:C1470.changes.catch($e; On Clicked:K2:4))
				
				var $o : Object
				var $c : Collection
				var $classes; $forms; $menu; $methods; $others : cs:C1710.menu
				
				If ($git.status()>0)
					
					$classes:=cs:C1710.menu.new()
					$forms:=cs:C1710.menu.new()
					$methods:=cs:C1710.menu.new()
					$others:=cs:C1710.menu.new()
					
					For each ($o; $git.changes.orderBy("path"))
						
						$c:=Split string:C1554($o.path; "/")
						
						Case of 
								
								//______________________________________________________
							: ($c.indexOf("Classes")=2)
								
								$classes.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path)
								
								//______________________________________________________
							: ($c.indexOf("Forms")=2)
								
								
								Case of 
										//______________________________________________________
									: ($c[$c.length-1]="form.4DForm")
										
										$forms.append($c[3]; $o.path)
										
										//______________________________________________________
									: ($c.indexOf("ObjectMethods")=4)
										
										$forms.append(Replace string:C233($c.remove(0; 3).remove(1; 1).join("/"); ".4dm"; ""); $o.path)
										
										//______________________________________________________
									Else 
										
										$forms.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dform"; ""); $o.path)
										
										//______________________________________________________
								End case 
								
								//______________________________________________________
							: ($c.indexOf("Methods")=2)
								
								$methods.append(Replace string:C233($c.remove(0; 3).join("/"); ".4dm"; ""); $o.path)
								
								//______________________________________________________
							Else 
								
								$others.append($c.remove(0; 2).join("/"); File:C1566($o.path))
								
								//______________________________________________________
						End case 
					End for each 
					
					$menu:=cs:C1710.menu.new()
					
					$menu.append("Classes"; $classes)
					$menu.append("Methods"; $methods)
					$menu.append("Forms"; $forms)
					$menu.append("Others"; $others)
					
					If ($menu.popup(This:C1470.changes).selected)
						
						var $target
						$target:=GIT Path($menu.choice)
						
						Case of 
								
								//——————————————————————————————————
							: (Value type:C1509($target)=Is text:K8:3)  // Classe, Method
								
								If ($target="@.4DForm")
									
									FORM EDIT:C1749(String:C10(Split string:C1554($target; "/")[0]))
									
								Else 
									
									METHOD OPEN PATH:C1213($target; *)
									
								End if 
								
								//——————————————————————————————————
							: (Value type:C1509($target)=Is object:K8:27)  // File
								
								If (Bool:C1537($target.exists))
									
									If ($target.extension=".4dform")
										
										FORM EDIT:C1749(String:C10($target.parent.fullName))
										
									Else 
										
										OPEN URL:C673($target.platformPath)
										
									End if 
								End if 
								
								//——————————————————————————————————
						End case 
					End if 
				End if 
				
				//==============================================
			: (This:C1470.openGitWindow.catch($e; On Clicked:K2:4))
				
				00_RUN
				
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
		
		Form:C1466.branch:=""
		Form:C1466.changes:=0
		Form:C1466.fetchNumber:=0
		Form:C1466.pushNumber:=0
		
		$c:=Split string:C1554(Application version:C493; "")
		
		Form:C1466.release:=$c[2]#"0"
		Form:C1466.lts:=Not:C34(Form:C1466.release)
		
		Form:C1466.major:=$c[0]+$c[1]
		Form:C1466.minor:=Form:C1466.release ? "R"+$c[2] : "."+$c[3]
		Form:C1466.alpha:=Application version:C493(*)="A@"
		
		Form:C1466.version:=Form:C1466.major+Form:C1466.minor
		
		If (Form:C1466.alpha)
			
			Form:C1466.version:="DEV ("+Form:C1466.version+")"
			
		End if 
		
		var $folder : 4D:C1709.Folder
		$folder:=Folder:C1567(Folder:C1567("/PACKAGE"; *).platformPath; fk platform path:K87:2)
		
		While ($folder#Null:C1517)\
			 && Not:C34($folder.folder(".git").exists)
			
			$folder:=$folder.parent
			
		End while 
		
		If ($folder#Null:C1517) && ($folder.exists)
			
			This:C1470.gitInstance:=cs:C1710.git.new($folder)
			
		Else 
			
			This:C1470.gitInstance:=Null:C1517
			
		End if 
	End if 
	
	$git:=This:C1470.gitInstance
	
	If ($git#Null:C1517)
		
		$branch:=$git.currentBranch
		
		If ($branch#Form:C1466.branch)
			
			Form:C1466.branch:=$branch
			
			If (Form:C1466.alpha)
				
				$success:=(Form:C1466.branch="main")\
					 || (Form:C1466.branch="master")\
					 || (Form:C1466.branch=(Form:C1466.major+Form:C1466.minor+"@"))\
					 || (Split string:C1554(Form:C1466.branch; "/").length>1)
				
			Else 
				
				If (Form:C1466.release)
					
					$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
						 || (Form:C1466.branch=(Form:C1466.major+"RX"))
					
				Else 
					
					$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
						 || (Form:C1466.branch=(Form:C1466.major+".X"))
					
				End if 
			End if 
			
			If ($success)
				
				This:C1470.branch.foregroundColor:=Foreground color:K23:1
				This:C1470.branch.fontStyle:=Plain:K14:1
				This:C1470.branch.setHelpTip("\""+$branch+"\" is the current branch")
				
			Else 
				
				This:C1470.branch.foregroundColor:="red"
				This:C1470.branch.fontStyle:=Bold:K14:2
				This:C1470.branch.setHelpTip("WARNING:\nYou are editing the \""+$branch+"\" branch of \""+Folder:C1567("/PACKAGE"; *).name+"\" \nwith a "+Form:C1466.version+" version of 4D.")
				
			End if 
		End if 
		
		Form:C1466.fetchNumber:=$git.branchFetchNumber($branch)
		Form:C1466.pushNumber:=$git.branchPushNumber($branch)
		Form:C1466.changes:=$git.status()
		
		This:C1470.gitItems.show()
		This:C1470.initRepository.hide()
		
		This:C1470.refresh(60*This:C1470.timer)
		
	Else 
		
		This:C1470.gitItems.hide()
		This:C1470.initRepository.show()
		
	End if 