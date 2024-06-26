property success; local; debug : Boolean
property command; error; HEAD; result; warning : Text
property BrancUnpulledCommit : Integer
property user; workingBranch : Object
property errors; warnings; branches; changes; history; remotes; stashes; tags : Collection
property cwd; root : 4D:C1709.Folder
property gitignore; gitattributes : 4D:C1709.File

property _version : Text

Class constructor($folder : 4D:C1709.Folder)
	
	This:C1470.success:=True:C214
	
	This:C1470.error:=""
	This:C1470.errors:=[]
	
	This:C1470.warning:=""
	This:C1470.warnings:=[]
	
	This:C1470.user:={}
	This:C1470.workingBranch:={}
	This:C1470.branches:=[]
	This:C1470.changes:=[]
	This:C1470.history:=[]
	This:C1470.remotes:=[]
	This:C1470.stashes:=[]
	This:C1470.tags:=[]
	
	This:C1470.HEAD:=""
	
	// Current workspace
	$folder:=$folder || Folder:C1567("/PACKAGE"; *)
	$folder:=Folder:C1567($folder.platformPath; fk platform path:K87:2)  // Unsandboxed
	This:C1470.cwd:=$folder
	
	// Search for .git folder
	While ($folder#Null:C1517)\
		 && (Not:C34($folder.folder(".git").exists))
		
		$folder:=$folder.parent
		
		Case of 
				
				//_________________________________
			: ($folder=Null:C1517)
				
				break
				
				//_________________________________
			: ($folder.folder(".git").exists)
				
				This:C1470.cwd:=$folder
				
				break
				
				//_________________________________
		End case 
	End while 
	
	This:C1470.root:=This:C1470.cwd.folder(".git")
	
	This:C1470.gitignore:=This:C1470.cwd.file(".gitignore")
	This:C1470.gitattributes:=This:C1470.cwd.file(".gitattributes")
	
	This:C1470.local:=Is macOS:C1572 ? File:C1566("/usr/local/bin/git").exists : False:C215
	
	var $exe : 4D:C1709.File
	
	Case of 
			
			//______________________________________________________
		: (Is macOS:C1572 ? File:C1566("/usr/local/bin/git").exists : False:C215)
			
			This:C1470.command:="/usr/local/bin/git "
			
			//______________________________________________________
		: (Is Windows:C1573)
			
			$exe:=Folder:C1567(fk applications folder:K87:20).parent.file("Program Files/Git/bin/git.exe")
			
			If ($exe.exists)
				
				This:C1470.command:=$exe.path+" "
				
			Else 
				
				This:C1470._pushError("Git not installed")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.command:="git "
			
			//______________________________________________________
	End case 
	
	This:C1470.result:=""
	
	This:C1470.debug:=(Structure file:C489=Structure file:C489(*))
	
	If (This:C1470.root#Null:C1517)\
		 & (This:C1470.root.exists)
		
		This:C1470.update()
		
	Else 
		
		This:C1470.init()
		
	End if 
	
	If (This:C1470.execute("version"))
		
		This:C1470._version:=This:C1470.result
		
		var $len; $pos : Integer
		
		If (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; This:C1470.result; 1; $pos; $len))
			
			This:C1470._version:=Substring:C12(This:C1470.result; $pos; $len)
			
		Else 
			
			// Store full result
			This:C1470._version:=This:C1470.result
			
		End if 
	End if 
	
	This:C1470.BrancUnpulledCommit:=0
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function execute($command : Text; $inputStream : Text) : Boolean
	
	var $errorStream; $outputStream : Text
	
	If (This:C1470.command=Null:C1517)  // not ready
		
		return 
		
	End if 
	
	If (Length:C16($command)=0)
		
		This:C1470._pushError("Missing command parameter")
		return 
		
	End if 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	
	If (This:C1470.cwd#Null:C1517)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10(This:C1470.cwd.platformPath))
		
	End if 
	
	$command:=This:C1470.command+$command
	
	LAUNCH EXTERNAL PROCESS:C811($command; $inputStream; $outputStream; $errorStream)
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($errorStream)=0)
	
	This:C1470.history.insert(0; {\
		cmd: "$ "+$command; \
		success: This:C1470.success; \
		out: $outputStream; \
		error: $errorStream\
		})
	
	If (Not:C34(Bool:C1537(This:C1470.debug)))\
		 && (This:C1470.history.length>20)
		
		This:C1470.history.resize(20)
		
	End if 
	
	Case of 
			
			//——————————————————————
		: (This:C1470.success)
			
			This:C1470.error:=""
			This:C1470.warning:=""
			
			// Delete the last line break, if any
			This:C1470.result:=Split string:C1554(This:C1470._normalizeLF($outputStream); "\n"; sk ignore empty strings:K86:1).join("\n")
			
			//——————————————————————
		: (Length:C16($errorStream)>0)
			
			This:C1470._pushError(This:C1470.history[0].cmd+" - "+Split string:C1554($errorStream; "\n"; sk ignore empty strings:K86:1).join("\n"))
			
			//——————————————————————
	End case 
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getConfig($what : Text) : Text
	
/* 
When reading, the values are read from the system, global
and repository local configuration files by default
*/
	This:C1470.execute("config --get "+$what)
	
	If (This:C1470.success)
		
		return This:C1470.history[0].out
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get version() : Text
	
	return This:C1470._version
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get currentBranch() : Text
	
	If (Length:C16(String:C10(This:C1470.HEAD))>0)
		
		return Split string:C1554(Split string:C1554(This:C1470.HEAD; "/").remove(0; 2).join("/"); "\r")[0]
		
	Else 
		
		This:C1470.execute("config --get --default master init.defaultBranch")
		return String:C10(This:C1470.result)
		
	End if 
	
	//mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	//If (This.execute("config --get --default master init.defaultBranch")#"development")
	//This.execute("config --local init.defaultBranch development")
	//End if 
	
	// Creates an empty Git repository
	This:C1470.execute("init")
	
	// Create default gitignore
	If (Not:C34(This:C1470.gitignore.exists))
		
		This:C1470.gitignore.setText(File:C1566("/RESOURCES/gitignore.txt").getText("UTF-8"; Document with CR:K24:21); "UTF-8"; Document with LF:K24:22)
		
	End if 
	
	// Create default gitattributes
	If (Not:C34(This:C1470.gitattributes.exists))
		
		This:C1470.gitattributes.setText(File:C1566("/RESOURCES/gitattributes.txt").getText("UTF-8"; Document with CR:K24:21); "UTF-8"; Document with LF:K24:22)
		
	End if 
	
	// Ignore file permission
	This:C1470.execute("config core.filemode false")
	
	If (This:C1470.execute("config --get user.name"))
		
		This:C1470.user.name:=This:C1470.result
		
	End if 
	
	If (This:C1470.execute("config --get user.email"))
		
		This:C1470.user.email:=This:C1470.result
		
	End if 
	
	If (This:C1470.execute("version"))
		
		This:C1470._version:=This:C1470.result
		
		var $len; $pos : Integer
		
		If (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; This:C1470.result; 1; $pos; $len))
			
			This:C1470._version:=Substring:C12(This:C1470.result; $pos; $len)
			
		Else 
			
			// Store full result
			This:C1470._version:=This:C1470.result
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function installLFS() : Boolean
	
	return This:C1470.execute("lfs install")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lfs() : Boolean
	
	If (This:C1470.root#Null:C1517)\
		 && (This:C1470.root.exists)
		
		return This:C1470.root.folder("lfs").exists
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	This:C1470.HEAD:=Split string:C1554(This:C1470._normalizeLF(This:C1470.root.file("HEAD").getText()); "\n"; sk ignore empty strings:K86:1)[0]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function status($short : Boolean) : Integer
	
	var $cmd; $t : Text
	
	$short:=Count parameters:C259>=1 ? $short : True:C214  // Default is True
	
	This:C1470.changes.clear()
	
	$cmd:="status"+($short ? " -s" : "")+" -uall --porcelain"
	
	If (This:C1470.execute($cmd))
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			This:C1470.changes.push({\
				status: $t[[1]]+$t[[2]]; \
				path: Replace string:C233(Delete string:C232($t; 1; 3); "\""; "")})
			
		End for each 
	End if 
	
	return This:C1470.changes.length
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function add($what)
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($what)=Is text:K8:3)
			
			Case of 
					
					//——————————————————————
				: ($what="all")  // Update the index and adds new files
					
					This:C1470.execute("add -A")
					
					//——————————————————————
				: ($what="update")  // Update the index, but adds no new files
					
					This:C1470.execute("add -u")
					
					//——————————————————————
				Else   // Add the given file
					
					This:C1470.execute("add "+This:C1470._quoted($what))
					
					//——————————————————————
			End case 
			
			//_____________________________
		: (Value type:C1509($what)=Is collection:K8:32)
			
			var $item
			
			For each ($item; $what)
				
				If (Value type:C1509($item)=Is text:K8:3)
					
					This:C1470.execute("add "+This:C1470._quoted($item))
					
				Else 
					
					This:C1470._pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			//_____________________________
		Else 
			
			This:C1470._pushError("Wrong type of argument")
			
			//_____________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function untrack($what)
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($what)=Is text:K8:3)
			
			This:C1470.execute("rm --cached "+This:C1470._quoted($what))
			
			//_____________________________
		: (Value type:C1509($what)=Is collection:K8:32)
			
			var $item
			
			For each ($item; $what)
				
				If (Value type:C1509($item)=Is text:K8:3)
					
					This:C1470.execute("rm --cached "+This:C1470._quoted($item))
					
				Else 
					
					This:C1470._pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			//_____________________________
		Else 
			
			This:C1470._pushError("Wrong type of argument")
			
			//_____________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function unstage($what)
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($what)=Is text:K8:3)
			
			var $c : Collection
			$c:=Split string:C1554($what; " -> ")
			
			If ($c.length>1)  // Moved
				
				This:C1470.execute("reset HEAD "+This:C1470._quoted($c[0]))
				This:C1470.execute("reset HEAD "+This:C1470._quoted($c[1]))
				
			Else 
				
				This:C1470.execute("reset HEAD "+This:C1470._quoted($what))
				
			End if 
			
			//_____________________________
		: (Value type:C1509($what)=Is collection:K8:32)
			
			var $item
			
			For each ($item; $what)
				
				If (Value type:C1509($item)=Is text:K8:3)
					
					This:C1470.execute("reset HEAD "+This:C1470._quoted($item))
					
				Else 
					
					This:C1470._pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			//_____________________________
		Else 
			
			This:C1470._pushError("Wrong type of argument")
			
			//_____________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function commit($message : Text; $amend : Boolean)
	
	This:C1470.status()
	
	If (This:C1470.changes.length>0)
		
		$message:=Length:C16($message)>0 ? $message : "Initial commit"
		
		If ($amend)
			
			This:C1470.execute("commit --amend --no-edit")
			
		Else 
			
			This:C1470.execute("commit -m "+This:C1470._quoted($message))
			
		End if 
		
	Else 
		
		This:C1470._pushWarning("Nothing to commit")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fetch($origin : Boolean) : Boolean
	
	return $origin ? This:C1470.fetchCurrent() : This:C1470.fetchAll()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fetchAll() : Boolean
	
	return This:C1470.execute("fetch --prune --tags --all")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fetchCurrent() : Boolean
	
	return This:C1470.execute("fetch --prune --tags origin")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function pull($rebase : Boolean; $stash : Boolean) : Boolean
	
	var $c : Collection
	
	$c:=["pull"]
	
	If ($rebase)
		
		$c.push("--rebase")
		
	End if 
	
	If ($stash)
		
		$c.push("--autostash")
		
	End if 
	
	$c.push("origin -q")
	
	//return This.execute("pull --rebase --autostash origin -q")
	This:C1470.execute($c.join(" "))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function push($origin : Text; $branch : Text) : Boolean
	
	var $c : Collection
	
	$c:=["push"]
	
	If (Count parameters:C259>=2)
		
		$c.push($origin)
		$c.push($branch)
		
	Else 
		
		// FIXME:What if "master" is not the main branch?
		$c.push("origin master")
		
	End if 
	
	$c.push("--tags")
	$c.push("--quiet")
	
	return This:C1470.execute($c.join(" "))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function forcePush($origin : Text; $branch : Text) : Boolean
	
	var $c : Collection
	
	$c:=["push"]
	
	If (Count parameters:C259>=2)
		
		$c.push($origin)
		$c.push($branch)
		
	Else 
		
		// FIXME:What if "master" is not the main branch?
		$c.push("origin master")
		
	End if 
	
	$c.push("--force-with-lease")
	$c.push("--tags")
	$c.push("--quiet")
	
	return This:C1470.execute($c.join(" "))
	
	//MARK:-branch
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function branch($whatToDo : Text; $name : Text; $newName : Text)
	
	var $t : Text
	var $o : Object
	var $c : Collection
	
	Case of 
			
			//———————————————————————————————————
		: (Length:C16($whatToDo)=0)\
			 | ($whatToDo="list")  // Update branch list
			
			This:C1470.branches:=[]
			
			If (This:C1470.execute("branch --list -v"))
				
				For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t; " "; sk ignore empty strings:K86:1)
					
					If ($c[0]="*")  // Current branch
						
						$o:={\
							name: $c[1]; \
							ref: $c[2]; \
							current: True:C214}
						
						This:C1470.workingBranch:=$o
						
					Else 
						
						$o:={\
							name: $c[0]; \
							ref: $c[1]; \
							current: False:C215}
						
					End if 
					
					This:C1470.branches.push($o)
					
				End for each 
			End if 
			
			//———————————————————————————————————
		: ($whatToDo="master") | ($whatToDo="main")  // Return on the main branch
			
			If (This:C1470.execute("checkout master"))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: (Count parameters:C259<2)\
			 | (Length:C16($name)=0)
			
			This:C1470._pushError("Missing branch name!")
			
			//———————————————————————————————————
		: ($whatToDo="create")  // Create a new branch
			
			If (This:C1470.execute("branch "+$name))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: ($whatToDo="createAndUse")  // Create a new branch and select it
			
			If (This:C1470.execute("checkout -b "+$name))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: ($whatToDo="use")  // Select a branch to use
			
			If (This:C1470.execute("checkout "+$name+" --no-ff -m Merging branch "+$name))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: ($whatToDo="merge")  // Merge a branch to the current branch
			
			If (This:C1470.execute("merge "+$name))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: ($whatToDo="delete@")
			
			If (This:C1470.execute("branch -"+Choose:C955($whatToDo="deleteForce"; "D"; "d")+" "+$name))
				
				This:C1470.branch()
				
			End if 
			
			//———————————————————————————————————
		: (Count parameters:C259<3)\
			 | (Length:C16($newName)=0)
			
			This:C1470._pushError("Missing branch new name!")
			
			//———————————————————————————————————
		: ($whatToDo="rename")  // Rename a branch
			
			If (This:C1470.execute("branch -m "+$name+" "+$newName))
				
				If (This:C1470.execute("push origin :"+$name))
					
					If (This:C1470.execute("push --set-upstream origin "+$newName))
						
						This:C1470.branch()
						
					End if 
				End if 
			End if 
			
			//———————————————————————————————————
			
		Else 
			
			This:C1470._pushError("Unmanaged entrypoint for branch method: "+$whatToDo)
			
			//———————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function checkout($what)
	
	var $item
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($what)=Is text:K8:3)
			
			This:C1470.execute("checkout -- "+This:C1470._quoted($what))
			
			//_____________________________
		: (Value type:C1509($what)=Is collection:K8:32)
			
			For each ($item; $what)
				
				If (Value type:C1509($item)=Is text:K8:3)
					
					This:C1470.execute("checkout -- "+This:C1470._quoted($item))
					
				Else 
					
					This:C1470._pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			//_____________________________
		Else 
			
			This:C1470._pushError("Wrong type of argument")
			
			//_____________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function branchFetchNumber($branch : Text) : Integer
	
	var $local; $remote; $t : Text
	var $i : Integer
	var $file : 4D:C1709.File
	
	If (Length:C16($branch)>0)
		
		$file:=This:C1470.root.folder("refs/heads").file($branch)
		
		If (Not:C34($file.exists))
			
			return 
			
		End if 
		
		$local:=Substring:C12($file.getText(); 1; 7)
		
		$file:=This:C1470.root.folder("refs/remotes/origin").file($branch)
		
		If (Not:C34($file.exists))
			
			return 
			
		End if 
		
		$remote:=Substring:C12($file.getText(); 1; 7)
		
		This:C1470.execute("log "+$local+".."+$remote)
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			$i+=Num:C11(Position:C15("commit "; $t)=1)
			
		End for each 
		
		return $i
		
	End if 
	
	// FIXME:To test
	This:C1470.execute("log origin..")
	
	If (Match regex:C1019("(?m-si)^[[:xdigit:]]{5,}"; This:C1470.result; 1; *))
		
		return Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1).length-1
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function branchPushNumber($branch : Text) : Integer
	
	var $c : Collection
	
	$c:=["rev-list"]
	
	$c.push(Length:C16($branch)>0\
		 ? "origin/"+$branch+".."+$branch\
		 : "origin..HEAD")
	
	$c.push("--single-worktree")
	
	This:C1470.execute($c.join(" "))
	
	return Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1).length
	
	//MARK:-diff
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function diff($pathname : Text; $option : Text)
	
	var $c : Collection
	
	$c:=["diff -w"]
	
	If (Count parameters:C259>=2)
		
		$c.push($option)
		
	End if 
	
	$c.push("-- "+This:C1470._quoted($pathname))
	
	This:C1470.execute($c.join(" "))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function diffList($parent : Text; $current : Text) : Boolean
	
	// Empty tree id
	$parent:=Length:C16($parent)=0 ? "4b825dc642cb6eb9a060e54bf8d69288fbee4904" : $parent
	
	return This:C1470.execute("diff --name-status "+$parent+" "+$current)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function diffTool($pathname : Text)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
	
	This:C1470.execute("difftool -y "+This:C1470._quoted($pathname))
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateRemotes()
	
	var $t : Text
	var $c : Collection
	
	This:C1470.remotes.clear()
	
	If (This:C1470.execute("remote -v"))
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			$c:=Split string:C1554($t; "\t"; sk ignore empty strings:K86:1)
			
			If (This:C1470.remotes.query("name=:1"; $c[0]).length=0)
				
				This:C1470.remotes.push({\
					name: $c[0]; \
					url: Substring:C12($c[1]; 1; Position:C15(" ("; $c[1])-1)\
					})
				
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateTags()
	
	This:C1470.tags.clear()
	
	If (This:C1470.execute("tag"))
		
		var $t : Text
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			This:C1470.tags.push($t)
			
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function open($whatToDo : Text)
	
	var $errorStream; $outputStream; $inputStream : Text
	
	Case of 
			
			//——————————————————————
		: ($whatToDo="terminal")  // Open terminal in the working directory
			
			If (Is macOS:C1572)
				
				LAUNCH EXTERNAL PROCESS:C811("open -a terminal '"+This:C1470.cwd.path+"'"; $inputStream; $outputStream; $errorStream)
				
			Else 
				
				LAUNCH EXTERNAL PROCESS:C811("wt -d \""+String:C10(This:C1470.cwd.path)+"\""; $inputStream; $outputStream; $errorStream)
				
			End if 
			
			//——————————————————————
		: ($whatToDo="show")  // Open on disk the current directory
			
			If (Is macOS:C1572)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10(This:C1470.cwd.platformPath))
				LAUNCH EXTERNAL PROCESS:C811("open ."; $inputStream; $outputStream; $errorStream)
				
			Else 
				
				SHOW ON DISK:C922(This:C1470.cwd.platformPath; *)
				
			End if 
			
			//——————————————————————
	End case 
	
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($errorStream)=0)
	
	Case of 
			
			//——————————————————————
		: (This:C1470.success)
			
			This:C1470.error:=""
			
			//——————————————————————
		: (Length:C16($errorStream)>0)
			
			This:C1470._pushError($errorStream)
			
			//——————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stash($name : Text)
	
	var $line : Text
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	Case of 
			
			//———————————————————————————————————
		: (Length:C16($name)=0)\
			 | ($name="list")  // Update list
			
			This:C1470.stashes:=[]
			
			If (This:C1470.execute("stash list"))
				
				For each ($line; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
					
					If (Match regex:C1019("(?mi-s)^([^:]*):\\s([^:]*)([^$]*)$"; $line; 1; $pos; $len))
						
						// FIXME:regex
						This:C1470.stashes.push({\
							name: Substring:C12($line; $pos{1}; $len{1}); \
							message: Substring:C12($line; $pos{3}; $len{3})\
							})
						
					End if 
				End for each 
			End if 
			
			//________________________________________
		Else 
			
			This:C1470._pushError("Unmanaged entrypoint for stash method: "+$name)
			
			//________________________________________
	End case 
	
	//MARK:-[PRIVATE]
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushError($message : Text)
	
	This:C1470.success:=False:C215
	This:C1470.error:=$message
	This:C1470.errors.push($message)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushWarning($message : Text)
	
	This:C1470.warning:=$message
	This:C1470.warnings.push($message)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _quoted($string : Text) : Text
	
	return Char:C90(Double quote:K15:41)+$string+Char:C90(Double quote:K15:41)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _normalizeLF($text : Text) : Text
	
	$text:=Replace string:C233($text; "\r\n"; "\n")
	$text:=Replace string:C233($text; "\r"; "\n")
	
	return $text
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function getPath($path : Text; $root : 4D:C1709.Folder) : Variant
	
	$root:=$root || Folder:C1567(fk database folder:K87:14; *)
	$path:=Replace string:C233($path; "\""; "")
	
	Case of 
			
			//———————————————————————————————————————————
		: (Position:C15(")"; $path)>0)  // Trash
			
			return File:C1566($root.path+$path; *)
			
			//———————————————————————————————————————————
		: ($path="Documentation/@")  // Documentation
			
			return File:C1566($root.path+$path; *)
			
			//———————————————————————————————————————————
		: ($path="@/Methods/@")  // Project methods
			
			return Replace string:C233(Replace string:C233($path; ".4dm"; ""); "Project/Sources/Methods/"; "")
			
			//———————————————————————————————————————————
		: ($path="@/Classes/@")
			
			return "[class]"+Replace string:C233(Replace string:C233($path; ".4dm"; ""); "Project/Sources/Classes"; "")
			
			//———————————————————————————————————————————
		: ($path="@/Forms/@")
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($path="@.4DForm")  // Form definition
					
					return $root.file($path)
					
					//……………………………………………………………………………………………
				: ($path="@.4dm")  // Method
					
					$path:=Replace string:C233($path; ".4dm"; "")
					
					If ($path="@/ObjectMethods/@")  // Object method
						
						$path:=Replace string:C233($path; "Project/Sources/Forms/"; "")
						$path:=Replace string:C233($path; "ObjectMethods"; "")
						return "[projectForm]/"+$path
						
					Else   // Form method
						
						$path:=Replace string:C233($path; "Project/Sources/Forms/"; "")
						$path:=Replace string:C233($path; "method"; "")
						return "[projectForm]/"+$path+"{formMethod}"
						
					End if 
					
					//……………………………………………………………………………………………
				Else 
					
					return $path[[Length:C16($path)]]="/" ? Folder:C1567($root.path+$path) : File:C1566($root.path+$path)
					
					//……………………………………………………………………………………………
			End case 
			
			//———————————————————————————————————————————
		: ($path="/RESOURCES/@")\
			 | ($path="/PACKAGE/@")\
			 | ($path="/SOURCES/@")\
			 | ($path="/PROJECT/@")\
			 | ($path="/DATA/@")\
			 | ($path="/LOGS/@")
			
			$path:=Replace string:C233($path; "/RESOURCES/"; "/RESOURCES/")
			$path:=Replace string:C233($path; "/PACKAGE/"; "/PACKAGE/")
			$path:=Replace string:C233($path; "/SOURCES/"; "/SOURCES/")
			$path:=Replace string:C233($path; "/PROJECT/"; "/PROJECT/")
			$path:=Replace string:C233($path; "/DATA/"; "/DATA/")
			$path:=Replace string:C233($path; "/LOGS/"; "/LOGS/")
			
			return ($path="@/" ? Folder:C1567($path; *) : File:C1566($path; *))
			
			//———————————————————————————————————————————
		Else 
			
			return File:C1566($root.path+$path; *)
			
			//———————————————————————————————————————————
	End case 
	
	
	