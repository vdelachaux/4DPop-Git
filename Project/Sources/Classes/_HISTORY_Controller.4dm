property isSubform:=False:C215
property toBeInitialized:=False:C215

// MARK:Delegate 📦
property Git:=cs:C1710.Git.me

// MARK:Widgets 📦
property form : cs:C1710.ui.form
property commits : cs:C1710.ui.listbox
property diff : cs:C1710.ui.input

// MARK:Properties
property relativePath : Text:=""

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.form:=cs:C1710.ui.form.new(This:C1470)
	This:C1470.form.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.commits:=This:C1470.form.Listbox("commits")
	This:C1470.diff:=This:C1470.form.Input("diff")
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	If ($e.form)  // <== FORM METHOD
		
		Case of 
				
				// ______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				// ______________________________________________________
			: ($e.timer)  // Poll for a close request left by the method editor's on_close macro
				
				This:C1470._checkPendingClose()
				
				// ______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				// ==============================================
			: (This:C1470.commits.catch($e; On Clicked:K2:4))
				
				If (Contextual click:C713)
					
					This:C1470._commitMenu()
					
				End if 
				
				// ==============================================
			: (This:C1470.commits.catch($e; On Selection Change:K2:29))
				
				This:C1470._showDiffFor(This:C1470.commits.item)
				
				// ==============================================
		End case 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	Form:C1466.darkScheme:=This:C1470.form.darkScheme
	
	// Use the File object passed through the form data directly (no string→File
	// reconversion, which would mangle the path)
	var $file : 4D:C1709.File:=Form:C1466.file
	var $ws:=This:C1470.Git.workspace
	
	This:C1470.relativePath:=$file.path
	
	If ($ws#Null:C1517) && (Position:C15($ws.path; $file.path)=1)
		
		This:C1470.relativePath:=Substring:C12($file.path; Length:C16($ws.path)+1)
		
	End if 
	
	Form:C1466.relativePath:=This:C1470.relativePath
	This:C1470.form.window.title:=Localized string:C991("methodHistory")+" - "+$file.name
	
	// Monospaced diff
	This:C1470.diff.font:="Courier"
	This:C1470.diff.fontSize:=13
	
	This:C1470._load()
	
	This:C1470.form.refresh()
	
	// Poll (every 0.5 s) for a close request posted by the method editor's on_close macro
	SET TIMER:C645(30)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Closes the window when the source method editor was closed (a close request was posted
	// to Storage more than ~0.4 s ago and not cancelled by an immediate re-open)
Function _checkPendingClose()
	
	If (Storage:C1525.gitHistoryClose=Null:C1517)
		
		return 
		
	End if 
	
	var $key : Text:="$githist:"+String:C10(Form:C1466.file.path)
	var $t : Real:=0
	
	Use (Storage:C1525.gitHistoryClose)
		$t:=Num:C11(Storage:C1525.gitHistoryClose[$key])
	End use 
	
	If ($t>0) && ((Milliseconds:C459-$t)>=400)
		
		Use (Storage:C1525.gitHistoryClose)
			OB REMOVE:C1226(Storage:C1525.gitHistoryClose; $key)
		End use 
		
		CANCEL:C270
		
	End if 
	// === === === === === === === === === === === === === === === === === === === === ===
	// Loads the commits that touched the target file
Function _load()
	
	var $git:=This:C1470.Git
	
	Form:C1466.commits:=[]
	Form:C1466.diff:=""
	
	// %aI = author date in strict ISO 8601 (no space) → avoids quoting a `--date="format:…"`
	// option through LAUNCH EXTERNAL PROCESS (embedded quotes + space break the arg tokenizer).
	// Each commit line is prefixed with the "###" marker (a numstat line always starts with a digit
	// or "-", never "###"). The marker must NOT contain "@": in a 4D `=` comparison "@" is a wildcard,
	// so "@C@" would spuriously match any text containing a "c". --numstat adds, per commit,
	// "<added>\t<deleted>\t<path>" for the followed file (path may carry a rename with " => ").
	// Fields separated by a TAB (%x09): 4D strips control chars < 0x20 from the captured output.
	var $format:="--format=###%x09%H%x09%an%x09%aI%x09%s"
	var $path : Text:=Form:C1466.file.path
	
	If (Not:C34($git.execute("log --follow --numstat "+$format+" -- "+This:C1470._quoted($path))))
		
		return 
		
	End if 
	
	var $list : Collection:=[]
	var $commit : Object:=Null:C1517
	var $line : Text
	
	For each ($line; Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1))
		
		var $f:=Split string:C1554($line; Char:C90(9))
		
		Case of 
				
				//______________________________________________________
			: ($f[0]="###") && ($f.length>=4)  // Commit metadata line
				
				$commit:={\
					sha: $f[1]; \
					short: Substring:C12($f[1]; 1; 8); \
					author: $f[2]; \
					stamp: Replace string:C233(Substring:C12($f[3]; 1; 16); "T"; " "); \
					subject: $f.slice(4).join(Char:C90(9)); \
					added: 0; \
					deleted: 0; \
					stat: ""; \
					renamedFrom: ""}
				
				$list.push($commit)
				
				//______________________________________________________
			: ($commit#Null:C1517) && ($f.length>=3)  // numstat line for the current commit
				
				$commit.added:=$commit.added+Num:C11($f[0])
				$commit.deleted:=$commit.deleted+Num:C11($f[1])
				
				var $rename:=This:C1470._expandRename($f[2])
				
				If ($rename.old#"")
					
					$commit.renamedFrom:=$rename.old
					$commit.subject:=$commit.subject+"   ↻ "+This:C1470._baseName($rename.old)+" → "+This:C1470._baseName($rename.new)
					
				End if 
				
				//______________________________________________________
		End case 
	End for each 
	
	// Prepend a synthetic entry for the file's uncommitted state (modified vs HEAD, or new/untracked)
	If ($git.execute("status --porcelain -- "+This:C1470._quoted($path))) && (Length:C16($git.result)>0)
		
		var $untracked : Boolean:=Substring:C12($git.result; 1; 2)="??"
		var $added; $deleted : Integer
		
		If ($untracked)  // brand new file, not yet tracked
			
			$added:=Split string:C1554(Form:C1466.file.getText(); "\n").length
			
		Else   // tracked file with local changes
			
			$git.execute("diff -w --numstat HEAD -- "+This:C1470._quoted($path))
			var $lines : Collection:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1)
			
			If ($lines.length>0)
				
				var $n : Collection:=Split string:C1554($lines[0]; Char:C90(9))
				$added:=Num:C11($n[0])
				$deleted:=Num:C11($n[1])
				
			End if 
		End if 
		
		$list.insert(0; {\
			sha: ""; \
			short: ""; \
			uncommitted: True:C214; \
			untracked: $untracked; \
			author: $git.userName(); \
			stamp: ""; \
			subject: Localized string:C991($untracked ? "newFile" : "uncommittedChanges"); \
			added: $added; \
			deleted: $deleted; \
			stat: ""})
		
	End if 
	
	// Build the "+A −D" stat string
	var $o : Object
	For each ($o; $list)
		
		$o.stat:="+"+String:C10($o.added)+" −"+String:C10($o.deleted)
		
	End for each 
	
	Form:C1466.commits:=$list
	This:C1470.commits.touch()
	
	If (Form:C1466.commits.length>0)
		
		This:C1470.commits.reveal(1)
		This:C1470._showDiffFor(Form:C1466.commits[0])
		
	Else   // No commit history and no local changes
		
		Form:C1466.diff:=This:C1470._styledText(Localized string:C991("noHistoryYet"); "gray")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Displays the diff of the target file between the given commit and its parent
Function _showDiffFor($commit : Object)
	
	If ($commit=Null:C1517)
		
		Form:C1466.diff:=""
		return 
		
	End if 
	
	If (Bool:C1537($commit.uncommitted))  // Working tree vs HEAD
		
		If (Bool:C1537($commit.untracked))  // New file not yet tracked → show its full content as added
			
			Form:C1466.diff:=This:C1470._styledText(cs:C1710.rgx.regex.new(Form:C1466.file.getText(); "(?m-si):[CK]:?\\d+(?::\\d+)?").substitute(""); Form:C1466.darkScheme ? "lawngreen" : "green")
			return 
			
		End if 
		
		This:C1470.Git.execute("diff -w HEAD -- "+This:C1470._quoted(This:C1470.relativePath))
		
	Else 
		
		This:C1470.Git.execute("show -w "+$commit.sha+" -- "+This:C1470._quoted(This:C1470.relativePath))
		
	End if 
	
	Form:C1466.diff:=This:C1470._styledDiff()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Builds a styled representation of the current git diff (in `Git.result`)
Function _styledDiff() : Text
	
	var $git:=This:C1470.Git
	var $dark : Boolean:=Bool:C1537(Form:C1466.darkScheme)
	var $styled; $line : Text
	
	If (Not:C34($git.success))
		
		ST SET TEXT:C1115($styled; String:C10($git.error); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "red")
		
		return $styled
		
	End if 
	
	If (Length:C16($git.result)=0)
		
		return ""
		
	End if 
	
	// Remove 4D tokens
	var $code:=cs:C1710.rgx.regex.new($git.result; "(?m-si):[CK]:?\\d+(?::\\d+)?").substitute("")
	
	var $c:=Split string:C1554($code; "\n"; sk ignore empty strings:K86:1)
	
	// Delete the header lines up to the first hunk
	While ($c.length>0) && (Substring:C12(String:C10($c[0]); 1; 2)#"@@")
		
		$c.remove(0; 1)
		
	End while 
	
	If ($c.length=0)
		
		return ""
		
	End if 
	
	var $indx:=0
	
	For each ($line; $c)
		
		If (Length:C16($line)>0)
			
			var $color:=$dark ? "gold" : "gray"
			
			Case of 
					
					//…………………………………………………………………………………………………
				: ($line[[1]]="-")
					
					$color:=$dark ? "fuchsia" : "red"
					
					//…………………………………………………………………………………………………
				: ($line[[1]]="+")
					
					$color:=$dark ? "lawngreen" : "green"
					
					//…………………………………………………………………………………………………
				: (Character code:C91($line[[1]])=Character code:C91("@"))
					
					$line:="\n"+$line
					
					//…………………………………………………………………………………………………
			End case 
			
			ST SET TEXT:C1115($styled; $line; ST Start text:K78:15; ST End text:K78:16)
			ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; $color)
			
		End if 
		
		$c[$indx]:=$styled
		$indx+=1
		
	End for each 
	
	$styled:=$c.join("\n")
	
	// Remove unnecessary line breaks
	While (Position:C15("\n\n"; $styled)>0)
		
		$styled:=Replace string:C233($styled; "\n\n"; "\n")
		
	End while 
	
	If (Position:C15("\n"; $styled)=1)
		
		$styled:=Delete string:C232($styled; 1; 1)
		
	End if 
	
	return $styled
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Wraps a path in double quotes for the command line
Function _quoted($path : Text) : Text
	
	return "\""+$path+"\""
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Returns $text as styled text rendered in a single colour
Function _styledText($text : Text; $color : Text) : Text
	
	var $styled : Text
	
	ST SET TEXT:C1115($styled; $text; ST Start text:K78:15; ST End text:K78:16)
	ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; $color)
	
	return $styled
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Contextual menu on the selected commit: copy its SHA, or create a patch file
Function _commitMenu()
	
	var $commit:=This:C1470.commits.item
	
	If ($commit=Null:C1517)
		
		return 
		
	End if 
	
	var $menu:=cs:C1710.ui.menu.new()
	
	$menu.append(Localized string:C991("copySha"); "copySha").enable(String:C10($commit.sha)#"")
	$menu.append(Localized string:C991("createPatch"); "createPatch").enable(Not:C34(Bool:C1537($commit.untracked)))
	
	If (Not:C34($menu.popup().selected))
		
		return 
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($menu.choice="copySha")
			
			SET TEXT TO PASTEBOARD:C523(String:C10($commit.short))
			
			//______________________________________________________
		: ($menu.choice="createPatch")
			
			This:C1470._createPatch($commit)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Prompts for a destination file (with a default name built from the commit) and writes the patch.
	// Commit  -> `git format-patch --stdout` via SystemWorker: its .response is the RAW output, unlike
	//            Git.execute which normalises and would drop the blank lines a mbox patch needs.
	// Changes -> `git diff HEAD` (a plain diff is safe to capture: blank lines keep a leading space).
Function _createPatch($commit : Object)
	
	var $git:=This:C1470.Git
	var $cmd : Text
	
	If (String:C10($commit.sha)#"")  // Commit
		
		$cmd:=$git.command+"format-patch -1 --stdout "+$commit.sha+" -- "+This:C1470._quoted(This:C1470.relativePath)
		
	Else   // Local (uncommitted) changes
		
		$cmd:=$git.command+"diff HEAD -- "+This:C1470._quoted(This:C1470.relativePath)
		
	End if 
	
	var $worker:=4D:C1709.SystemWorker.new($cmd; {currentDirectory: $git.workspace; dataType: "text"})
	
	If ($worker=Null:C1517)
		
		return 
		
	End if 
	
	$worker.wait()
	
	var $patch : Text:=String:C10($worker.response)
	
	If (Length:C16($patch)=0)
		
		return 
		
	End if 
	
	// Default folder: reuse the last one chosen this session, else the Documents folder
	var $dir : Text:=String:C10(Storage:C1525.gitPatchFolder.directory)
	
	If (Length:C16($dir)=0)
		
		$dir:=Folder:C1567(fk documents folder:K87:21).platformPath
		
	End if 
	
	// Save dialog, proposing a name derived from the commit
	var $name : Text:=Select document:C905($dir+This:C1470._patchName($commit); "save patch as:"; ".patch"; File name entry:K24:17)
	
	If (OK=0)
		
		return 
		
	End if 
	
	var $file : 4D:C1709.File:=File:C1566(DOCUMENT; fk platform path:K87:2)
	
	// Remember the chosen folder for the next patch creation
	Use (Storage:C1525)
		
		Storage:C1525.gitPatchFolder:=Storage:C1525.gitPatchFolder || New shared object:C1526
		
	End use 
	
	Use (Storage:C1525.gitPatchFolder)
		
		Storage:C1525.gitPatchFolder.directory:=$file.parent.platformPath
		
	End use 
	
	$file.setText($patch)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Builds a filesystem-friendly default patch file name from the commit
Function _patchName($commit : Object) : Text
	
	var $base : Text:=(String:C10($commit.sha)#"") ? ($commit.short+"-"+$commit.subject) : (Form:C1466.file.name+"-uncommitted")
	
	// Collapse any run of non-word characters into a single dash
	$base:=cs:C1710.rgx.regex.new($base; "[^\\w.-]+").substitute("-")
	
	// Trim leading dashes/dots and cap the length
	While (($base#"") && (($base[[1]]="-") | ($base[[1]]=".")))
		
		$base:=Delete string:C232($base; 1; 1)
		
	End while 
	
	If (Length:C16($base)>60)
		
		$base:=Substring:C12($base; 1; 60)
		
	End if 
	
	return $base+".patch"
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Expands a git --numstat rename path ("a/{old => new}/b" or "old => new") into {old; new}.
	// Returns {old:""; new:""} when the path carries no rename.
Function _expandRename($path : Text) : Object
	
	If (Position:C15(" => "; $path)=0)
		
		return {old: ""; new: ""}
		
	End if 
	
	var $open : Integer:=Position:C15("{"; $path)
	
	If ($open>0)  // Brace form: prefix{old => new}suffix
		
		var $close : Integer:=Position:C15("}"; $path)
		var $pre : Text:=Substring:C12($path; 1; $open-1)
		var $inside : Text:=Substring:C12($path; $open+1; ($close-$open)-1)
		var $post : Text:=Substring:C12($path; $close+1)
		var $parts : Collection:=Split string:C1554($inside; " => ")
		
		return {old: $pre+$parts[0]+$post; new: $pre+$parts[1]+$post}
		
	End if 
	
	// Full form: old => new
	var $c : Collection:=Split string:C1554($path; " => ")
	
	return {old: $c[0]; new: $c[1]}
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Last path segment (file name) of a "/"-separated path
Function _baseName($path : Text) : Text
	
	return String:C10(Split string:C1554($path; "/").pop())