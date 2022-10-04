Class constructor
	
	This:C1470.success:=True:C214
	
	This:C1470.error:=""
	This:C1470.errors:=New collection:C1472
	
	This:C1470.warning:=""
	This:C1470.warnings:=New collection:C1472
	
	This:C1470.user:=New object:C1471
	This:C1470.workingBranch:=New object:C1471
	This:C1470.branches:=New collection:C1472
	This:C1470.changes:=New collection:C1472
	This:C1470.history:=New collection:C1472
	This:C1470.remotes:=New collection:C1472
	This:C1470.stashes:=New collection:C1472
	This:C1470.tags:=New collection:C1472
	
	This:C1470.workingDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
	
	This:C1470.git:=This:C1470.workingDirectory.folder(".git")
	This:C1470.gitignore:=This:C1470.workingDirectory.file(".gitignore")
	This:C1470.gitattributes:=This:C1470.workingDirectory.file(".gitattributes")
	
	This:C1470.local:=Is macOS:C1572 ? File:C1566("/usr/local/bin/git").exists : False:C215
	
	This:C1470.version:=""
	This:C1470.result:=""
	
	This:C1470.debug:=(Structure file:C489=Structure file:C489(*))
	
	This:C1470._init()
	
/*————————————————————————————————————————————————————————*/
Function execute($command : Text; $inputStream : Text) : Boolean
	
	var $errorStream; $outputStream : Text
	
	This:C1470.success:=(Length:C16($command)>0)
	
	If (This:C1470.success)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		
		If (This:C1470.workingDirectory#Null:C1517)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10(This:C1470.workingDirectory.platformPath))
			
		End if 
		
		Case of 
				
				//———————————————————————————————
			: (This:C1470.local)
				
				$command:="/usr/local/bin/git "+$command
				
				//———————————————————————————————
			: (Is Windows:C1573)
				
				$command:="Resources/git/git "+$command
				
				//———————————————————————————————
			Else 
				
				$command:="git "+$command
				
				//———————————————————————————————
		End case 
		
		LAUNCH EXTERNAL PROCESS:C811($command; $inputStream; $outputStream; $errorStream)
		This:C1470.success:=Bool:C1537(OK) & (Length:C16($errorStream)=0)
		
		This:C1470.history.insert(0; New object:C1471(\
			"cmd"; "$ "+$command; \
			"success"; This:C1470.success; \
			"out"; $outputStream; \
			"error"; $errorStream))
		
		If (Not:C34(Bool:C1537(This:C1470.debug)))
			
			If (This:C1470.history.length>20)
				
				This:C1470.history.resize(20)
				
			End if 
		End if 
		
		Case of 
				
				//——————————————————————
			: (This:C1470.success)
				
				This:C1470.error:=""
				This:C1470.warning:=""
				
				This:C1470.result:=$outputStream
				
				//——————————————————————
			: (Length:C16($errorStream)>0)
				
				This:C1470._pushError(This:C1470.history[0].cmd+" - "+$errorStream)
				
				//——————————————————————
		End case 
		
	Else 
		
		This:C1470._pushError("Missing command parameter")
		
	End if 
	
	return This:C1470.success
	
/*————————————————————————————————————————————————————————*/
Function status() : Integer
	
	var $t : Text
	
	This:C1470.changes.clear()
	
	If (This:C1470.execute("status -s -uall"))
		
		If (Position:C15("\n"; String:C10(This:C1470.result))>0)
			
			For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
				
				This:C1470.changes.push(New object:C1471(\
					"status"; $t[[1]]+$t[[2]]; \
					"path"; Replace string:C233(Delete string:C232($t; 1; 3); "\""; "")))
				
			End for each 
		End if 
	End if 
	
	return This:C1470.changes.length
	
/*————————————————————————————————————————————————————————*/
Function add($something)
	
	var $item
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($something)=Is text:K8:3)
			
			Case of 
					
					//——————————————————————
				: ($something="all")  // Update the index and adds new files
					
					This:C1470.result:=New collection:C1472
					This:C1470.execute("add -A")
					
					//——————————————————————
				: ($something="update")  // Update the index, but adds no new files
					
					This:C1470.result:=New collection:C1472
					This:C1470.execute("add -u")
					
					//——————————————————————
				Else   // Add the given file
					
					This:C1470.execute("add "+Char:C90(Quote:K15:44)+$something+Char:C90(Quote:K15:44))
					
					//——————————————————————
			End case 
			
			//_____________________________
		: (Value type:C1509($something)=Is collection:K8:32)
			
			For each ($item; $something)
				
				If (Value type:C1509($item)=Is text:K8:3)
					
					This:C1470.execute("add "+Char:C90(Quote:K15:44)+$item+Char:C90(Quote:K15:44))
					
				Else 
					
					This:C1470._pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			//_____________________________
		Else 
			
			This:C1470._pushError("Wrong type of argument")
			
			//_____________________________
	End case 
	
/*————————————————————————————————————————————————————————*/
Function untrack($something)
	
	var $item
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($something)=Is text:K8:3)
			
			This:C1470.execute("rm --cached "+This:C1470._quoted($something))
			
			//_____________________________
		: (Value type:C1509($something)=Is collection:K8:32)
			
			For each ($item; $something)
				
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
	
/*————————————————————————————————————————————————————————*/
Function unstage($something)
	
	var $item
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($something)=Is text:K8:3)
			
			This:C1470.execute("reset HEAD "+This:C1470._quoted($something))
			
			//_____________________________
		: (Value type:C1509($something)=Is collection:K8:32)
			
			For each ($item; $something)
				
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
	
/*————————————————————————————————————————————————————————*/
Function commit($message : Text; $amend : Boolean)
	
	This:C1470.status()
	
	If (This:C1470.changes.length>0)
		
		$message:=Length:C16($message)=0 ? "Initial commit" : $message
		
		If ($amend)
			
			This:C1470.execute("commit --amend --no-edit")
			
		Else 
			
			This:C1470.execute("commit -m "+This:C1470._quoted($message))
			
		End if 
		
	Else 
		
		This:C1470._pushWarning("Nothing to commit")
		
	End if 
	
/*————————————————————————————————————————————————————————*/
Function fetch($origin : Boolean) : Boolean
	
	return $origin ? This:C1470._fetchCurrent() : This:C1470._fetchAll()
	
/*————————————————————————————————————————————————————————*/
Function pull() : Boolean
	
	return This:C1470.execute("pull --rebase --autostash origin -q")
	
/*————————————————————————————————————————————————————————*/
Function push($origin : Text; $branch : Text) : Boolean
	
	If (Count parameters:C259>=2)
		
		return This:C1470.execute("push "+$origin+" "+$branch+" -q")
		
	Else 
		
		return This:C1470.execute("push origin master -q")
		
	End if 
	
	//MARK:-branch
/*————————————————————————————————————————————————————————*/
Function currentBranch() : Text
	
	This:C1470.execute("rev-parse --abbrev-ref HEAD")
	
	If (This:C1470.success)
		
		return Delete string:C232(This:C1470.result; Length:C16(This:C1470.result); 1)
		
	End if 
	
/*————————————————————————————————————————————————————————*/
Function branch($whatToDo : Text; $name : Text; $newName : Text)
	
	var $t : Text
	var $o : Object
	var $c : Collection
	
	Case of 
			
			//———————————————————————————————————
		: (Length:C16($whatToDo)=0)\
			 | ($whatToDo="list")  // Update branch list
			
			This:C1470.branches:=New collection:C1472
			
			If (This:C1470.execute("branch --list -v"))
				
				For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t; " "; sk ignore empty strings:K86:1)
					
					If ($c[0]="*")  // Current branch
						
						$o:=New object:C1471(\
							"name"; $c[1]; \
							"ref"; $c[2]; \
							"current"; True:C214)
						
						This:C1470.workingBranch:=$o
						
					Else 
						
						$o:=New object:C1471(\
							"name"; $c[0]; \
							"ref"; $c[1]; \
							"current"; False:C215)
						
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
	
/*————————————————————————————————————————————————————————*/
Function checkout($something)
	
	var $item
	
	Case of 
			
			//_____________________________
		: (Value type:C1509($something)=Is text:K8:3)
			
			This:C1470.execute("checkout -- "+This:C1470._quoted($something))
			
			//_____________________________
		: (Value type:C1509($something)=Is collection:K8:32)
			
			For each ($item; $something)
				
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
	
/*————————————————————————————————————————————————————————*/
Function branchFetchNumber() : Integer
	
	This:C1470._fetchCurrent()
	
	return Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1).length
	
/*————————————————————————————————————————————————————————*/
Function branchPushNumber() : Integer
	
	This:C1470.execute("rev-list origin/"+Form:C1466.branch+"...HEAD --single-worktree")
	
	return Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1).length
	
	//MARK:-dif
/*————————————————————————————————————————————————————————*/
Function diff($pathname : Text; $option : Text)
	
	var $success : Boolean
	
	If (Count parameters:C259>=2)
		
		$success:=This:C1470.execute("diff -w "+String:C10($option)+" -- "+This:C1470._quoted($pathname))
		
	Else 
		
		$success:=This:C1470.execute("diff -w -- "+This:C1470._quoted($pathname))
		
	End if 
	
	If ($success)
		
		This:C1470.result:=Replace string:C233(This:C1470.result; "\r\n"; "\n")
		This:C1470.result:=Replace string:C233(This:C1470.result; "\r"; "\n")
		
	End if 
	
/*————————————————————————————————————————————————————————*/
Function diffList($parent : Text; $current : Text) : Boolean
	
	// empty tree id
	$parent:=Length:C16($parent)=0 ? "4b825dc642cb6eb9a060e54bf8d69288fbee4904" : $parent
	
	return This:C1470.execute("diff --name-status "+$parent+" "+$current)
	
/*————————————————————————————————————————————————————————*/
Function diffTool($pathname : Text)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
	
	This:C1470.execute("difftool -y "+This:C1470._quoted($pathname))
	
	//MARK:-
/*————————————————————————————————————————————————————————*/
Function updateRemotes()
	
	var $t : Text
	var $c : Collection
	
	This:C1470.remotes.clear()
	
	If (This:C1470.execute("remote -v"))
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			$c:=Split string:C1554($t; "\t"; sk ignore empty strings:K86:1)
			
			If (This:C1470.remotes.query("name=:1"; $c[0]).length=0)
				
				This:C1470.remotes.push(New object:C1471(\
					"name"; $c[0]; \
					"url"; Substring:C12($c[1]; 1; Position:C15(" ("; $c[1])-1)))
				
			End if 
		End for each 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function updateTags()
	
	var $t : Text
	
	This:C1470.tags.clear()
	
	If (This:C1470.execute("tag"))
		
		For each ($t; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
			
			This:C1470.tags.push($t)
			
		End for each 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function open($whatToDo : Text)
	
	var $errorStream; $outputStream; $inputStream : Text
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	
	Case of 
			
			//——————————————————————
		: ($whatToDo="terminal")  // Open terminal in the working directory
			
			LAUNCH EXTERNAL PROCESS:C811("open -a terminal '"+This:C1470.workingDirectory.path+"'"; $inputStream; $outputStream; $errorStream)
			
			//——————————————————————
		: ($whatToDo="show")  // Open on disk the current directory
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10(This:C1470.workingDirectory.platformPath))
			LAUNCH EXTERNAL PROCESS:C811("open ."; $inputStream; $outputStream; $errorStream)
			
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
	
/*————————————————————————————————————————————————————————*/
Function stash($name : Text)
	
	var $line : Text
	var $o : Object
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	Case of 
			
			//———————————————————————————————————
		: (Length:C16($name)=0)\
			 | ($name="list")  // Update list
			
			This:C1470.stashes:=New collection:C1472
			
			If (This:C1470.execute("stash list"))
				
				For each ($line; Split string:C1554(This:C1470.result; "\n"; sk ignore empty strings:K86:1))
					
					If (Match regex:C1019("(?mi-s)^([^:]*):\\s([^:]*)(?::\\s([[:alnum:]]{7})\\s([^$]*))?$"; $line; 1; $pos; $len))
						
						If ($pos{3}#-1)
							
							$o:=New object:C1471(\
								"name"; Substring:C12($line; $pos{1}; $len{1}); \
								"message"; Substring:C12($line; $pos{2}; $len{2}); \
								"ref"; Substring:C12($line; $pos{3}; $len{3}); \
								"refMessage"; Substring:C12($line; $pos{4}; $len{4})\
								)
							
						Else 
							
							$o:=New object:C1471(\
								"name"; Substring:C12($line; $pos{1}; $len{1}); \
								"message"; Substring:C12($line; $pos{2}; $len{2})\
								)
							
						End if 
						
						This:C1470.stashes.push($o)
						
					End if 
				End for each 
			End if 
			
			//________________________________________
		Else 
			
			This:C1470._pushError("Unmanaged entrypoint for stash method: "+$name)
			
			//________________________________________
	End case 
	
	//MARK:-[PRIVATE]
/*—————————————————————————————————————————————————————-——*/
Function _init()
	
	var $len; $pos : Integer
	
	If (This:C1470.execute("init"))
		
		If (Not:C34(This:C1470.gitignore.exists))
			
			// Create default gitignore
			This:C1470.gitignore.setText(File:C1566("/RESOURCES/gitignore.txt").getText("UTF-8"; Document with CR:K24:21); "UTF-8"; Document with LF:K24:22)
			
		End if 
		
		If (Not:C34(This:C1470.gitattributes.exists))
			
			// Create default gitignore
			This:C1470.gitattributes.setText(File:C1566("/RESOURCES/gitattributes.txt").getText("UTF-8"; Document with CR:K24:21); "UTF-8"; Document with LF:K24:22)
			
		End if 
		
		// Ignore file permission
		This:C1470.execute("config core.filemode false")
		
		If (This:C1470.execute("config --get user.name"))
			
			This:C1470.user.name:=Replace string:C233(This:C1470.result; "\n"; "")
			
		End if 
		
		If (This:C1470.execute("config --get user.email"))
			
			This:C1470.user.email:=Replace string:C233(This:C1470.result; "\n"; "")
			
		End if 
		
		If (This:C1470.execute("version"))
			
			This:C1470.version:=Replace string:C233(This:C1470.result; "\n"; "")
			
			If (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; This:C1470.result; 1; $pos; $len))
				
				This:C1470.version:=Substring:C12(This:C1470.result; $pos; $len)
				
			Else 
				
				// Store full result
				This:C1470.version:=Replace string:C233(This:C1470.result; "\n"; "")
				
			End if 
		End if 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function _fetchAll() : Boolean
	
	return This:C1470.execute("fetch --prune --tags --all")
	
/*————————————————————————————————————————————————————————*/
Function _fetchCurrent() : Boolean
	
	return This:C1470.execute("fetch --prune --tags origin")
	
/*————————————————————————————————————————————————————————*/
Function _pushError($message : Text)
	
	This:C1470.error:=$message
	This:C1470.errors.push($message)
	
/*————————————————————————————————————————————————————————*/
Function _pushWarning($message : Text)
	
	This:C1470.warning:=$message
	This:C1470.warnings.push($message)
	
/*————————————————————————————————————————————————————————*/
Function _quoted($string : Text) : Text
	
	return Char:C90(Quote:K15:44)+$string+Char:C90(Quote:K15:44)
	
	