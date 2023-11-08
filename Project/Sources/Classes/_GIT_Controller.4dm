property form : cs:C1710.formDelegate

property fetch; \
pull; \
push; \
open; \
stage; \
stageAll; \
unstage; \
diffTool; \
commit; \
amend : cs:C1710.buttonDelegate

property menu; \
unstaged; \
staged; \
commits; \
detailCommit : cs:C1710.listboxDelegate

property diff; \
subject; \
description : cs:C1710.inputDelegate

property selector : cs:C1710.hListDelegate

property toolbarLeft; \
commitment; \
detail : cs:C1710.groupDelegate

property Git : cs:C1710.Git

property _unstaged; \
_staged; \
_commits; \
_commitDetail; \
STAGED_STATUS; \
UNSTAGED_STATUS : Collection

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.isSubform:=False:C215
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.pages:={changes: 1; commits: 2}
	
	// MARK:-Delegates 📦
	This:C1470.form:=cs:C1710.formDelegate.new(This:C1470)
	This:C1470.Git:=cs:C1710.Git.new()
	
	// Mark:Constants
	// FIXME:Manage all cases 🐞
	This:C1470.UNSTAGED_STATUS:=["??"; " M"; " D"; " R"; " C"]  //; "MD"; "AM"; "AD"]
	This:C1470.STAGED_STATUS:=["A "; "D "; "M "; "R "; "C "]
	
	This:C1470.MOVED_FILE:=Get localized string:C991("fileMoved")
	This:C1470.NEW_FILE:=Get localized string:C991("newFile")
	This:C1470.MODIFIED_FILE:=Get localized string:C991("modifiedFile")
	This:C1470.DELETED_FILE:=Get localized string:C991("fileRemoved")
	This:C1470.BINARY_FILE:=Get localized string:C991("binaryFile")
	
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Menu bar
	var $menuHandle : Text
	$menuHandle:=Formula:C1597(formMenuHandle).source
	
	var $menuFile : cs:C1710.menu
	$menuFile:=cs:C1710.menu.new().file()  // Get a standard file menu
	
	// Insert custom
	$menuFile.append(".Close"; "close"; 0).shortcut("W").method($menuHandle)
	$menuFile.line(1)
	$menuFile.append("Diff"; "diff"; 2).shortcut("D").method($menuHandle)
	$menuFile.line(3)
	$menuFile.append("Settings"; "settings"; 4).method($menuHandle)
	
	var $menuEdit : cs:C1710.menu
	$menuEdit:=cs:C1710.menu.new().edit()  // Get a standard edit menu
	
	This:C1470.menuBar:=cs:C1710.menuBar.new([\
		":xliff:CommonMenuFile"; $menuFile; \
		":xliff:CommonMenuEdit"; $menuEdit]).set()
	
	// Mark:Page 0️⃣ Toolbar
	This:C1470.toolbarLeft:=This:C1470.form.group.new()
	This:C1470.fetch:=This:C1470.form.button.new("fetch").addToGroup(This:C1470.toolbarLeft)
	This:C1470.pull:=This:C1470.form.button.new("pull").addToGroup(This:C1470.toolbarLeft)
	This:C1470.push:=This:C1470.form.button.new("push").addToGroup(This:C1470.toolbarLeft)
	
	This:C1470.changes:=This:C1470.form.button.new("changes")
	This:C1470.history:=This:C1470.form.button.new("history")
	
	This:C1470.open:=This:C1470.form.button.new("open")
	
	// Mark:Page 0️⃣ Left pannel
	This:C1470.selector:=This:C1470.form.hList.new("selector")
	
	// Mark:Page 1️⃣ Changes
	This:C1470.unstaged:=This:C1470.form.listbox.new("unstaged")
	This:C1470.stage:=This:C1470.form.button.new("stage")
	This:C1470.stageAll:=This:C1470.form.button.new("stageAll")
	
	This:C1470.staged:=This:C1470.form.listbox.new("staged")
	This:C1470.unstage:=This:C1470.form.button.new("unstage")
	
	// Mark:Page 1️⃣ Diff pannel
	This:C1470.diff:=This:C1470.form.input.new("diff")
	
	// Mark:Page 1️⃣ Commit panel
	This:C1470.commitment:=This:C1470.form.group.new()
	This:C1470.subject:=This:C1470.form.input.new("subject").addToGroup(This:C1470.commitment)
	This:C1470.description:=This:C1470.form.input.new("description").addToGroup(This:C1470.commitment)
	This:C1470.amend:=This:C1470.form.button.new("amend").addToGroup(This:C1470.commitment)
	This:C1470.commit:=This:C1470.form.button.new("commit").addToGroup(This:C1470.commitment)
	
	// Mark:Page 2️⃣ Commits
	This:C1470.commits:=This:C1470.form.listbox.new("commits")
	
	// Mark:Page 2️⃣ Commit
	This:C1470.detail:=This:C1470.form.group.new()
	This:C1470.detailCommit:=This:C1470.form.listbox.new("detail_list").addToGroup(This:C1470.detail)
	This:C1470.authorLabel:=This:C1470.form.static.new("authorLabel").addToGroup(This:C1470.detail)
	This:C1470.authorAvatar:=This:C1470.form.picture.new("authorAvatar").addToGroup(This:C1470.detail)
	This:C1470.authorName:=This:C1470.form.static.new("authorName").addToGroup(This:C1470.detail)
	This:C1470.authorMail:=This:C1470.form.static.new("authorMail").addToGroup(This:C1470.detail)
	This:C1470.stamp:=This:C1470.form.static.new("stamp").addToGroup(This:C1470.detail)
	This:C1470.shaLabel:=This:C1470.form.static.new("shaLabel").addToGroup(This:C1470.detail)
	This:C1470.sha:=This:C1470.form.static.new("sha").addToGroup(This:C1470.detail)
	This:C1470.parentLabel:=This:C1470.form.static.new("parentLabel").addToGroup(This:C1470.detail)
	This:C1470.parent:=This:C1470.form.input.new("parent").addToGroup(This:C1470.detail)
	This:C1470.titleTop:=This:C1470.form.static.new("titleTop").addToGroup(This:C1470.detail)
	This:C1470.title:=This:C1470.form.static.new("title").addToGroup(This:C1470.detail)
	This:C1470.titleBottom:=This:C1470.form.static.new("titleBottom").addToGroup(This:C1470.detail)
	This:C1470.detailSplitter:=This:C1470.form.static.new("detailSplitter").addToGroup(This:C1470.detail)
	This:C1470.detailSeparator:=This:C1470.form.static.new("detailSeparator").addToGroup(This:C1470.detail)
	This:C1470.detailDiff:=This:C1470.form.input.new("detailDiff").addToGroup(This:C1470.detail)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
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
			: ($e.pageChange)
				
				If (This:C1470.form.page=This:C1470.pages.commits)
					
					This:C1470.updateCommitList()
					
				End if 
				
				//______________________________________________________
			: ($e.activate)
				
				This:C1470.onActivate()
				
				//______________________________________________________
			: ($e.unload)
				
				CLEAR LIST:C377(Form:C1466.selector; *)
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		var $git : cs:C1710.Git
		$git:=This:C1470.Git
		
		Case of 
				
				//==============================================
				//: ($e.doubleClick)
				
				//This._selectorManager($e)
				
				//==============================================
			: (This:C1470.changes.catch($e; On Clicked:K2:4))
				
				This:C1470.goToPage(This:C1470.pages.changes)
				
				//==============================================
			: (This:C1470.history.catch($e; On Clicked:K2:4))
				
				This:C1470.goToPage(This:C1470.pages.commits)
				
				//==============================================
			: (This:C1470.fetch.catch($e; On Clicked:K2:4))
				
				$git.fetch()
				This:C1470.onActivate()
				
				//==============================================
			: (This:C1470.pull.catch($e; On Clicked:K2:4))
				
				$git.pull()
				This:C1470.onActivate()
				
				RELOAD PROJECT:C1739
				
				//==============================================
			: (This:C1470.push.catch($e; On Clicked:K2:4))
				
				If ($git.remotes.length=0)
					
					var $gh : cs:C1710.gh
					$gh:=cs:C1710.gh.new()
					
					If (Not:C34($gh.available))
						
						ALERT:C41($gh.lastError+"\n\nInstallation instructions can be found at:\n\nhttps://github.com/cli/cli#installation")
						return 
						
					End if 
					
					$gh.logIn()
					
					// Create remote
					var $remote : Text
					$remote:=$gh.createRepo($git.cwd.name)
					
					// Add the remote
					$git.execute("remote add -m -t origin "+$remote)
					
					$git.remotes.push({\
						name: "master"; \
						url: $remote\
						})
					
					$git.push("origin"; "refs/heads/master")
					
				Else 
					
					$git.push()
					
				End if 
				
				If (Not:C34($git.success))
					
					ALERT:C41($git.error)
					
				End if 
				
				This:C1470.onActivate()
				
				//==============================================
			: (This:C1470.open.catch($e; On Clicked:K2:4))
				
				This:C1470._openManager()
				
				//==============================================
			: (This:C1470.selector.catch($e))
				
				This:C1470._selectorManager($e)
				
				//==============================================
			: (This:C1470.stage.catch($e; On Clicked:K2:4))
				
				This:C1470.Stage(This:C1470.unstaged.items)
				
				//==============================================
			: (This:C1470.stageAll.catch($e; On Clicked:K2:4))
				
				This:C1470.StageAll()
				
				//==============================================
			: (This:C1470.unstage.catch($e; On Clicked:K2:4))
				
				This:C1470.Unstage(This:C1470.staged.items)
				
				//==============================================
			: (This:C1470.unstaged.catch($e)) | (This:C1470.staged.catch($e))
				
				This:C1470._stageUnstageManager($e)
				
				//==============================================
			: (This:C1470.subject.catch($e; On After Edit:K2:43))
				
				This:C1470.commit.enable(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Get edited text:C655)))
				
				//==============================================
			: (This:C1470.amend.catch($e; On Clicked:K2:4))
				
				This:C1470.commit.enable(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
				
				If (Form:C1466.amend)
					
					$git.execute("log --abbrev-commit --format=%s")
					This:C1470.subject.setValue(String:C10(Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1).shift()))
					This:C1470.description.hide()
					
				Else 
					
					This:C1470.description.show()
					
				End if 
				
				//==============================================
			: (This:C1470.commit.catch($e; On Clicked:K2:4))
				
				$git.commit(This:C1470.subject.getValue(); Form:C1466.amend)
				
				This:C1470.subject.clear()
				This:C1470.description.clear()
				This:C1470.amend.clear()
				
				This:C1470.onActivate()
				
				//==============================================
			: (This:C1470.commits.catch($e; On Selection Change:K2:29))
				
				This:C1470._commitsManager()
				
				//==============================================
			: (This:C1470.parent.catch($e; On Clicked:K2:4))
				
				var $c : Collection
				$c:=Form:C1466.commits.indices("fingerprint.short = :1"; This:C1470.commits.item.parent.short)
				
				If ($c.length>0) && ($c[0]#-1)
					
					This:C1470.commits.reveal($c[0]+1)
					This:C1470.commits.focus()
					
					This:C1470._commitsManager()
					
				End if 
				
				//==============================================
			: (This:C1470.detailCommit.catch($e; On Selection Change:K2:29))
				
				This:C1470.update()
				
				//==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.darkMode:=FORM Get color scheme:C1761="dark"
	
	This:C1470.toolbarLeft.distributeLeftToRight({\
		minWidth: 50; \
		spacing: 10})
	
	This:C1470.changes.show()
	This:C1470.history.show()
	
	// Tricks
	This:C1470.unstaged.setVerticalScrollbar(2)
	This:C1470.staged.setVerticalScrollbar(2)
	This:C1470.commits.setVerticalScrollbar(2)
	This:C1470.detailCommit.setVerticalScrollbar(2)
	
	This:C1470.stage.bestSize(Align right:K42:4).disable()
	This:C1470.unstage.bestSize(Align right:K42:4).disable()
	This:C1470.commit.bestSize(Align right:K42:4).disable()
	This:C1470.open.bestSize(Align right:K42:4)
	
	// TODO:Could be preferences
	This:C1470.diff.font:="Courier"
	This:C1470.diff.fontSize:=14
	
	Form:C1466.project:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
	
	Form:C1466.version:=This:C1470.Git.version
	
	Form:C1466.unstaged:=[]
	Form:C1466.staged:=[]
	Form:C1466.commits:=[]
	Form:C1466.commitDetail:=[]
	
	Form:C1466.icons:={}
	
	// Mark:Selector definition
	Form:C1466.selector:=New list:C375
	APPEND TO LIST:C376(Form:C1466.selector; "Branches"; -21; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "Remotes"; -22; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "Tags"; -23; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "stashes"; -24; New list:C375; True:C214)
	SET LIST PROPERTIES:C387(Form:C1466.selector; 0; 0; 25)
	
	Form:C1466.amend:=False:C215
	Form:C1466.commitSubject:=""
	Form:C1466.commitDescription:=""
	
	Case of 
		: (This:C1470.Git.success)
			
			//all is OK
			
		: (This:C1470.Git.error="Git not installed")
			
			CONFIRM:C162(Get localized string:C991("gitNotInstalled"))
			
			If (Bool:C1537(OK))
				
				OPEN URL:C673("https://git-scm.com/download/win")
				
			End if 
			
			CANCEL:C270
			
	End case 
	
	This:C1470.goToPage(This:C1470.pages.changes)
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $t : Text
	var $indx : Integer
	var $commit; $detail; $o : Object
	var $c : Collection
	var $git : cs:C1710.Git
	
	$git:=This:C1470.Git
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.form.page=This:C1470.pages.changes)
			
			If ($git.status()=0)
				
				Form:C1466.staged.clear()
				This:C1470.stage.disable()
				
				This:C1470.stage.disable()
				This:C1470.unstage.disable()
				
				This:C1470.commitment.disable()
				This:C1470.commit.disable()
				
				return 
				
			End if 
			
			// Mark:Update file lists
			Form:C1466.unstaged:=$git.changes.query("status IN :1"; This:C1470.UNSTAGED_STATUS).orderBy("path")
			
			For each ($o; Form:C1466.unstaged)
				
				$o.added:=$o.status="??"
				$o.modified:=$o.status="@M@"
				$o.deleted:=$o.status="@D@"
				
				$o.icon:=$o.modified ? Form:C1466.iconModified\
					 : $o.deleted ? Form:C1466.iconDeleted\
					 : $o.added ? Form:C1466.iconAdded\
					 : Null:C1517
				
			End for each 
			
			Form:C1466.staged:=$git.changes.query("status IN :1"; This:C1470.STAGED_STATUS).orderBy("path")
			
			For each ($o; Form:C1466.staged)
				
				$o.added:=$o.status="@A@"
				$o.modified:=$o.status="@M@"
				$o.deleted:=$o.status="@D@"
				$o.moved:=$o.status="@R@"
				
				$o.icon:=$o.modified ? Form:C1466.iconModified\
					 : $o.deleted ? Form:C1466.iconDeleted\
					 : $o.moved ? Form:C1466.iconMoved\
					 : $o.added ? Form:C1466.iconAdded\
					 : Null:C1517
				
			End for each 
			
			// Mark:Restore selections
			If (This:C1470.unstaged.item#Null:C1517)\
				 & (Form:C1466.unstaged.length>0)
				
				$indx:=This:C1470.unstaged.item#Null:C1517\
					 ? Form:C1466.unstaged.extract("path").indexOf(This:C1470.unstaged.item.path)\
					 : -1
				
				If ($indx=-1)
					
					This:C1470.unstaged.unselect()
					This:C1470.stage.disable()
					
				Else 
					
					This:C1470.unstaged.reveal($indx+1)
					This:C1470.stage.enable()
					
				End if 
			End if 
			
			If (This:C1470.staged.item#Null:C1517)\
				 & (Form:C1466.staged.length>0)
				
				$indx:=This:C1470.staged.item#Null:C1517\
					 ? Form:C1466.staged.extract("path").indexOf(This:C1470.staged.item.path)\
					 : -1
				
				If ($indx=-1)
					
					This:C1470.staged.unselect()
					This:C1470.unstage.disable()
					
				Else 
					
					This:C1470.staged.reveal($indx+1)
					This:C1470.unstage.enable()
					
				End if 
			End if 
			
			// Mark:Update commit panel
			This:C1470.commitment.enable(Form:C1466.staged.length>0)
			This:C1470.commit.enable(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
			
			//______________________________________________________
		: (This:C1470.form.page=This:C1470.pages.commits)
			
			$commit:=This:C1470.commits.item
			$detail:=This:C1470.detailCommit.item
			
			If ($commit=Null:C1517) || ($detail=Null:C1517)
				
				Form:C1466.diff:=""
				This:C1470.detailDiff.hide()
				
				return 
				
			End if 
			
			This:C1470.detailDiff.show()
			
			$c:=Split string:C1554($detail.label; " -> "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			If ($c.length=2)
				
				Form:C1466.diff:=Replace string:C233(Replace string:C233(This:C1470.MOVED_FILE; "{origin}"; $c[0]); "{dest}"; $c[1])
				return 
				
			End if 
			
			Case of 
					
					//______________________________________________________
				: (Length:C16(String:C10($commit.parent.short))=0)
					
					$git.diff($detail.path; $commit.fingerprint.short)
					
					//______________________________________________________
				Else 
					
					$c:=Split string:C1554($commit.parent.short; " ")
					$git.diff($detail.path; $c.length>1 ? $c[1] : $c[0]+" "+$commit.fingerprint.short)
					
					//______________________________________________________
			End case 
			
			$c:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			For each ($t; $c)
				
				If ($t="Binary file@")
					
					Form:C1466.diff:=$detail.added ? This:C1470.NEW_FILE\
						 : $detail.modified ? This:C1470.MODIFIED_FILE\
						 : $detail.deleted ? This:C1470.DELETED_FILE\
						 : This:C1470.BINARY_FILE
					
					Form:C1466.diff+=": \r  • "+$detail.path
					
					return 
					
				End if 
				
				$indx+=1
				
				If ($indx=10)
					
					break
					
				End if 
			End for each 
			
			Form:C1466.diff:=This:C1470.GetStyledDiffText($detail)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onActivate()
	
	var $git : cs:C1710.Git
	var $list : cs:C1710.Hlist
	
	If (Form:C1466.dark#This:C1470.form.darkScheme)
		
		This:C1470.loadIcons()
		
	End if 
	
	If (This:C1470.form.page=This:C1470.pages.commits)
		
		This:C1470.updateCommitList()
		
	End if 
	
	$git:=This:C1470.Git
	
	// Mark:Update menu label
	If ($git.status()>0)
		
		This:C1470.changes.title:=Get localized string:C991("local")+" ("+String:C10($git.changes.length)+")"
		
	Else 
		
		This:C1470.changes.title:=Get localized string:C991("local")
		
		Form:C1466.unstaged.clear()
		Form:C1466.staged.clear()
		
	End if 
	
	$list:=cs:C1710.Hlist.new(This:C1470.selector.getValue())
	$list.saveSelection()
	
	This:C1470.branchList($list)
	This:C1470.remoteList($list)
	This:C1470.tagList($list)
	This:C1470.stachList($list)
	
	$list.restoreSelection()
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function stachList($list : cs:C1710.Hlist)
	
	var $o : Object
	var $git : cs:C1710.Git
	var $sublist : cs:C1710.Hlist
	
	$git:=This:C1470.Git
	
	$git.stash()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-24).sublist).Empty()
	
	If ($git.stashes.length>0)
		
		For each ($o; $git.stashes)
			
			$o.type:="stash"
			
			$sublist.Append($o.name)\
				.SetParameter({key: "data"; value: JSON Stringify:C1217($o)})\
				.SetIcon({icon: Form:C1466.icons.stash})
			
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function tagList($list : cs:C1710.Hlist)
	
	var $t : Text
	var $git : cs:C1710.Git
	var $sublist : cs:C1710.Hlist
	
	$git:=This:C1470.Git
	
	$git.updateTags()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-23).sublist).Empty()
	
	If ($git.tags.length>0)
		
		For each ($t; $git.tags)
			
			$sublist.Append($t)\
				.SetParameter({key: "tag"; value: $t})\
				.SetIcon({icon: Form:C1466.icons.tag})
			
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function remoteList($list : cs:C1710.Hlist)
	
	var $o : Object
	var $git : cs:C1710.Git
	var $sublist : cs:C1710.Hlist
	
	$git:=This:C1470.Git
	
	$git.updateRemotes()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-22).sublist).Empty()
	
	If ($git.remotes.length>0)
		
		For each ($o; $git.remotes)
			
			$o.type:="remote"
			
			$sublist.Append($o.name)\
				.SetParameter({key: "data"; value: JSON Stringify:C1217($o)})\
				.SetIcon({icon: Form:C1466.icons[(Position:C15("github.com"; $o.url)>0 ? "github" : "gitlab")]})
			
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function branchList($list : cs:C1710.Hlist)
	
	var $notPulled; $notPushed : Integer
	var $o : Object
	var $git : cs:C1710.Git
	var $sublist : cs:C1710.Hlist
	
	$git:=This:C1470.Git
	
	$git.branch()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-21).sublist).Empty()
	
	If ($git.branches.length>0)
		
		For each ($o; $git.branches)
			
			$o.type:="branch"
			
			// TODO: hieararchical branches
			// Var $c : Collection
			// $c:=Split string($o.name; "/")
			
			$sublist.Append($o.name)\
				.SetParameter({key: "data"; value: JSON Stringify:C1217($o)})
			
			If ($o.current)
				
				$sublist.SetIcon({icon: Form:C1466.icons.master})\
					.SetItemStyle(Bold:K14:2)
				
			Else 
				
				$sublist.SetIcon({icon: Form:C1466.icons.branch})
				
			End if 
			
			$notPushed:=$git.branchPushNumber($o.name)
			$notPulled:=$git.branchFetchNumber($o.name)
			
			Case of 
					//______________________________________________________
				: ($notPulled>0) & ($notPushed>0)
					
					$sublist.SetAdditionalText(String:C10($notPushed)+"↑↓"+String:C10($notPulled)+" ")
					
					//______________________________________________________
				: ($notPushed>0)
					
					$sublist.SetAdditionalText(String:C10($notPushed)+"↑ ")
					
					//______________________________________________________
				: ($notPulled>0)
					
					$sublist.SetAdditionalText("↓"+String:C10($notPulled)+" ")
					
					//______________________________________________________
			End case 
		End for each 
	End if 
	
	//Mark:-Managers
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _selectorManager($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	var $list : cs:C1710.Hlist
	$list:=cs:C1710.Hlist.new(This:C1470.selector.getValue())
	
	var $o : Object
	$o:=$list.GetParameter({key: "data"; type: Is object:K8:27})
	
	Case of 
			
			//______________________________________________________
		: ($o=Null:C1517)
			
			return 
			
			//______________________________________________________
		: ($e.doubleClick)
			
			If ($o.ref#Null:C1517) && (Not:C34(Bool:C1537($o.current)))
				
				TRACE:C157  //This.Switch($o)
				
			End if 
			
			//______________________________________________________
		: ($e.click)
			
			If (Contextual click:C713)
				
				// TODO:Contextual menu
				
			End if 
			
			//______________________________________________________
		: ($e.selectionChange)
			
			If (This:C1470.form.page=This:C1470.pages.commits)
				
				This:C1470.commits.unselect()
				
				var $c : Collection
				$c:=Form:C1466.commits.indices("fingerprint.short = :1"; String:C10($o.ref))
				
				If ($c.length>0) && ($c[0]#-1)
					
					This:C1470.commits.reveal($c[0]+1)
					This:C1470.commits.focus()
					
				End if 
				
			Else 
				
				This:C1470.goToPage(This:C1470.pages.commits)
				
			End if 
			
			This:C1470._commitsManager()
			
			//----------------------------------------
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _openManager()
	
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append(":xliff:openInTerminal"; "terminal").icon("/RESOURCES/Images/Menus/terminal.png")\
		.append(":xliff:showOnDisk"; "show").icon("/RESOURCES/Images/Menus/disk.png")\
		.line()\
		.append(":xliff:viewOnGithub"; "github").icon("/RESOURCES/Images/Menus/gitHub.png").enable(This:C1470.Git.execute("config --get remote.origin.url"))
	
	$menu.line()
	
	If (Is macOS:C1572)
		
		If (File:C1566("/usr/local/bin/fork").exists)
			
			$menu.append(Replace string:C233(Get localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png")
			
		End if 
		
		If (File:C1566("/usr/local/bin/github").exists)
			
			$menu.append(Replace string:C233(Get localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png")
			
		End if 
		
	Else 
		
		If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/Fork/Fork.exe").exists)
			
			$menu.append(Replace string:C233(Get localized string:C991("openWith"); "{app}"; "Fork"); "fork").icon("/RESOURCES/Images/Menus/fork.png")
			
		End if 
		
		If (Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/GitHubDesktop.exe").exists)
			
			$menu.append(Replace string:C233(Get localized string:C991("openWith"); "{app}"; "Github Desktop"); "githubDesktop").icon("/RESOURCES/Images/Menus/githubDesktop.png")
			
		End if 
	End if 
	
	Case of 
			
			//———————————————————————————————————————
		: (Not:C34($menu.popup().selected))
			
			// Too bad ;-)
			
			//———————————————————————————————————————
		: ($menu.choice="terminal")
			
			This:C1470.Git.open($menu.choice)
			
			//———————————————————————————————————————
		: ($menu.choice="show")
			
			This:C1470.Git.open($menu.choice)
			
			//———————————————————————————————————————
		: ($menu.choice="github")
			
			OPEN URL:C673(Replace string:C233(This:C1470.Git.result; "\n"; ""))
			
			//———————————————————————————————————————
		: ($menu.choice="fork")
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; This:C1470.Git.cwd.platformPath)
			
			If (Is macOS:C1572)
				
				LAUNCH EXTERNAL PROCESS:C811("/usr/local/bin/fork open")
				
			Else 
				
				LAUNCH EXTERNAL PROCESS:C811(Folder:C1567(fk home folder:K87:24).file("AppData/Local/Fork/Fork.exe").platformPath)
				
			End if 
			
			//———————————————————————————————————————
		: ($menu.choice="githubDesktop")
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; This:C1470.Git.cwd.platformPath)
			
			If (Is macOS:C1572)
				
				LAUNCH EXTERNAL PROCESS:C811("/usr/local/bin/github \""+This:C1470.Git.cwd.path+"\"")
				
			Else 
				
				LAUNCH EXTERNAL PROCESS:C811(Folder:C1567(fk home folder:K87:24).file("AppData/Local/GitHubDesktop/GitHubDesktop.exe").platformPath+" "+This:C1470.Git.cwd.platformPath)
				
			End if 
			
			//———————————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _stageUnstageManager($e : cs:C1710.evt)
	
	var $staged : Boolean
	var $current : Object
	var $sel : Collection
	var $file : 4D:C1709.File
	var $menu : cs:C1710.menu
	
	$e:=$e || cs:C1710.evt.new()
	
	$staged:=$e.objectName="staged"
	$current:=$staged ? This:C1470.staged.item : This:C1470.unstaged.item
	$sel:=$staged ? This:C1470.staged.items : This:C1470.unstaged.items
	
	If ($sel.length<=1)
		
		Form:C1466.current:=$current
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Double Clicked:K2:5)
			
			If ($sel.length#1)
				
				return 
				
			End if 
			
			If ($staged)
				
				This:C1470.Unstage($sel)
				
			Else 
				
				This:C1470.Stage($sel)
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Clicked:K2:4)
			
			This:C1470.DoDiff()
			
			If ($current=Null:C1517)
				
				If ($staged)
					
					This:C1470.unstage.disable()
					
				Else 
					
					This:C1470.stage.disable()
					
				End if 
				
				return 
				
			End if 
			
			If ($staged)
				
				This:C1470.unstage.enable()
				
			Else 
				
				This:C1470.stage.enable()
				
			End if 
			
			This:C1470.DoDiff($current)
			
			If (Not:C34(Contextual click:C713))
				
				return 
				
			End if 
			
			$menu:=cs:C1710.menu.new()
			
			If ($sel.length=1)
				
				$menu.append("Open"; "open")
				
				If (["??"; " D"; "A "].indexOf($current.status)=-1)
					
					$menu.append("externalDiff"; "diffTool").shortcut("D")
					
				End if 
				
				$menu.line()
				
				If ([" D"].indexOf($current.status)=-1)
					
					$menu.append("showInFinder"; "show")
					$menu.append("deleteLocalFile"; "delete")
					
				End if 
				
				$menu.append("copyPath"; "copy")
				
				$menu.line()
				
			End if 
			
			If ($current#Null:C1517)
				
				If ($staged)
					
					$menu.append("unstage"; "unstage").shortcut("S"; 512)
					
				Else 
					
					$menu.append("stage"; "stage").shortcut("S"; 512)
					$menu.append("discardChanges"; "discard")
					
				End if 
				
				$menu.line()
				
			End if 
			
			Case of 
					
					//———————————————————————————————————————
				: ($staged)\
					 & (Form:C1466.staged.length>0)
					
					$menu.append("unstageAll"; "unStageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
				: (Form:C1466.unstaged.length>0)
					
					$menu.append("stageAll"; "stageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
			End case 
			
			If ($current#Null:C1517)
				
				$file:=File:C1566($current.path)
				
				$menu.line()\
					.append("ignore"; cs:C1710.menu.new()\
					.append(Replace string:C233(Get localized string:C991("ignoreFile"); "{file}"; $file.fullName); "ignoreFile")\
					.append(Replace string:C233(Get localized string:C991("ignoreAllExtensionFiles"); "{extension}"; $file.extension); "ignoreExtension")\
					.line()\
					.append("customPattern"; "ignoreCustom"))
				
			End if 
			
			If (Not:C34($menu.popup().selected))
				
				return 
				
			End if 
			
			This:C1470.handleMenus($menu.choice; $current)
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			If ($staged)
				
				This:C1470.unstage.enable()
				
			Else 
				
				This:C1470.stage.enable()
				
			End if 
			
			This:C1470.DoDiff(Form:C1466.current)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _commitsManager()
	
	var $t : Text
	var $p : Picture
	var $x : Blob
	var $commit; $o : Object
	var $c : Collection
	
	This:C1470.detailCommit.unselect()
	Form:C1466.commitDetail.clear()
	This:C1470.selector.unselect()
	Form:C1466.diff:=""
	
	$commit:=This:C1470.commits.item
	
	If ($commit=Null:C1517)
		
		This:C1470.detail.hide()
		
		return 
		
	End if 
	
	This:C1470.detail.show()
	
	$c:=Split string:C1554($commit.parent.short; " ")
	
	If (This:C1470.Git.diffList($c.length=0 ? "" : $c.length>1 ? $c[1] : $c[0]; $commit.fingerprint.short))
		
		For each ($t; Split string:C1554(This:C1470.Git.result; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2))
			
			$c:=Split string:C1554($t; "\t"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			$o:={\
				status: $c[0]; \
				path: $c[1]; \
				label: $c[1]; \
				added: $c[0]="A"; \
				modified: $c[0]="M"; \
				deleted: $c[0]="D"; \
				moved: $c.length>=3\
				}
			
			$o.icon:=$o.modified ? Form:C1466.iconModified\
				 : $o.deleted ? Form:C1466.iconDeleted\
				 : $o.added ? Form:C1466.iconAdded\
				 : $o.moved ? Form:C1466.iconMoved\
				 : Null:C1517
			
			If ($c.length>=3)  // Renamed
				
				$o.label:=$o.label+" -> "+$c[2]
				$o.path:=$c[2]
				
			End if 
			
			Form:C1466.commitDetail.push($o)
			
		End for each 
	End if 
	
	If ($commit.author.avatar=Null:C1517)
		
		$commit.author.avatar:=This:C1470.getAvatar($commit.author.mail)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function DoDiff($item : Object)
	
	var $code; $t : Text
	var $tgt
	
	If ($item=Null:C1517)
		
		This:C1470.diff.hide()
		This:C1470.stage.disable()
		This:C1470.unstage.disable()
		
		return 
		
	End if 
	
	This:C1470.diff.show()
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––
		: ($item.added)
			
			$tgt:=This:C1470.Git.getPath($item.path)
			
			Case of 
					
					//______________________________________________________
				: (Value type:C1509($tgt)=Is object:K8:27)  // File
					
					If (Bool:C1537($tgt.exists))
						
						Case of 
								
								//————————————————————————————————————
							: ($tgt.extension=".svg")  // Treat svg as text file
								
								$code:=$tgt.getText()
								
								//————————————————————————————————————
							: (Is picture file:C1113($tgt.platformPath))
								
								// TODO:Pictures
								
								//————————————————————————————————————
							Else 
								
								$code:=$tgt.getText()
								
								//————————————————————————————————————
						End case 
					End if 
					
					//______________________________________________________
				: (Value type:C1509($tgt)=Is text:K8:3)  // Method
					
					If ($tgt="@form.4dForm")
						
						$code:=File:C1566("/PACKAGE/"+$tgt).getText()
						
					Else 
						
						If ($tgt="[ProjectForm]@")
							
							METHOD GET CODE:C1190($tgt; $code; *)
							
						Else 
							
							ARRAY TEXT:C222($methods; 0x0000)
							METHOD GET PATHS:C1163(Path all objects:K72:16; $methods; *)
							
							If (Find in array:C230($methods; $tgt)>0)
								
								METHOD GET CODE:C1190($tgt; $code; *)
								
							End if 
						End if 
					End if 
					
					//______________________________________________________
				Else 
					
					//
					
					//______________________________________________________
			End case 
			
			If (Length:C16($code)>0)
				
				$code:=Replace string:C233($code; "<"; "&lt;")
				$code:=Replace string:C233($code; ">"; "&gt;")
				
				ST SET TEXT:C1115($t; $code; ST Start text:K78:15; ST End text:K78:16)
				ST SET ATTRIBUTES:C1093($t; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "green")
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			Case of 
					
					//______________________________________________________
				: ($item.modified)
					
					This:C1470.Git.execute("diff HEAD -- "+$item.path)
					
					//______________________________________________________
				: ($item.name="staged")
					
					This:C1470.Git.diff($item.path; "--cached")
					
					//______________________________________________________
				Else 
					
					This:C1470.Git.diff($item.path)
					
					//______________________________________________________
			End case 
			
			$t:=This:C1470.GetStyledDiffText($item)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	Form:C1466.diff:=$t
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetStyledDiffText($item : Object) : Text
	
	var $color; $line; $styled : Text
	var $continue : Boolean
	var $indx; $len; $pos : Integer
	var $o : Object
	var $c : Collection
	var $git : cs:C1710.Git
	
	$git:=This:C1470.Git
	
	If (Not:C34($git.success))
		
		$o:=$git.history.pop()
		ST SET TEXT:C1115($styled; String:C10($o.cmd)+"\r\r"+String:C10($o.error); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "red")
		
		return $styled
		
	End if 
	
	If (Length:C16($git.result)=0)
		
		return 
		
	End if 
	
	$c:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1)
	
	// Delete the initial lines
	While ($c.length>0)
		
		If (Position:C15("@"; String:C10($c[0]))#1)
			
			$c.remove(0; 1)
			
		Else 
			
			break
			
		End if 
	End while 
	
	If ($c.length=0)
		
		return 
		
	End if 
	
	If ($item.added)
		
		ST SET TEXT:C1115($styled; $c.join("\n"); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "green")
		
		return $styled
		
	End if 
	
	If ($item.deleted)
		
		ST SET TEXT:C1115($styled; $c.join("\n"); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "red")
		
		return $styled
		
	End if 
	
	For each ($line; $c)
		
		If (Length:C16($line)>0)
			
			$color:="gray"
			
			Case of 
					
					//…………………………………………………………………………………………………
				: ($line[[1]]="-")
					
					$color:="red"
					
					//…………………………………………………………………………………………………
				: ($line[[1]]="+")
					
					$color:="green"
					
					//…………………………………………………………………………………………………
				: (Character code:C91($line[[1]])=Character code:C91("@"))
					
					$line:="\n"+$line
					
					//…………………………………………………………………………………………………
				: ($line[[1]]="\\")
					
					$line:=Delete string:C232($line; 1; 1)
					
					//…………………………………………………………………………………………………
			End case 
			
			ST SET TEXT:C1115($styled; $line; ST Start text:K78:15; ST End text:K78:16)
			ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; $color)
			
		End if 
		
		$c[$indx]:=$styled
		$indx+=1
		
	End for each 
	
	$styled:=$c.join("\n")
	
	$styled:=Replace string:C233($styled; "<br/>"; "")
	
	// Separate blocks
	$indx:=1
	
	While (Match regex:C1019("(?mi-s)^(<[^>]*>@@[^$]*)$"; $styled; $indx; $pos; $len))
		
		If ($pos>1)
			
			$styled:=Substring:C12($styled; 1; $pos-1)+"\n"+Substring:C12($styled; $pos)
			
		End if 
		
		$indx+=$len
		
	End while 
	
	// Remove unnecessary line breaks
	While (Position:C15("\n\n"; $styled)>0)
		
		$styled:=Replace string:C233($styled; "\n\n"; "\n")
		
	End while 
	
	If (Position:C15("\n"; $styled)=1)
		
		$styled:=Delete string:C232($styled; 1; 1)
		
	End if 
	
	return $styled
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function goToPage($page : Integer)
	
	This:C1470.changes.value:=Num:C11($page=1)
	This:C1470.history.value:=Num:C11($page=2)
	This:C1470.form.goToPage($page)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Stage($items : Collection)
	
	var $o : Object
	
	For each ($o; $items)
		
		This:C1470.Git.add($o.path)
		
	End for each 
	
	This:C1470.DoDiff()
	This:C1470.onActivate()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function StageAll()
	
	This:C1470.Git.add("all")
	
	This:C1470.DoDiff()
	This:C1470.onActivate()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Unstage($items : Collection)
	
	var $o : Object
	
	For each ($o; $items)
		
		This:C1470.Git.unstage($o.path)
		
	End for each 
	
	This:C1470.DoDiff()
	This:C1470.onActivate()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Discard($items : Collection)
	
	var $tgt
	var $o : Object
	var $git : cs:C1710.Git
	
	CONFIRM:C162(Get localized string:C991("doYouWantToDiscardAllChangesInTheSelectedFiles"); Get localized string:C991("discard"))
	
	If (Bool:C1537(OK))
		
		$git:=This:C1470.Git
		
		For each ($o; $items)
			
			If ($o.status="??")
				
				$tgt:=This:C1470.Git.getPath($o.path)
				
				Case of 
						
						//——————————————————————————————————
					: (Value type:C1509($tgt)=Is text:K8:3)  // Method
						
						// Warning: No update if 4D App don't be unactivated/activated
						$tgt:=File:C1566(Form:C1466.project.parent.parent.path+$o.path)
						
						//——————————————————————————————————
					: (Value type:C1509($tgt)=Is object:K8:27)  // File
						
						// <NOTHING MORE TO DO>
						
						//——————————————————————————————————
				End case 
				
				If (Bool:C1537($tgt.exists))
					
					$tgt.delete()
					
				Else 
					
					TRACE:C157
					
				End if 
				
			Else 
				
				$git.checkout($o.path)
				
			End if 
		End for each 
		
		RELOAD PROJECT:C1739
		
		This:C1470.DoDiff()
		This:C1470.onActivate()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Switch($branch : Object)
	
	This:C1470.Git.branch("use"; $branch.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CreateGithubRepository()
	
	var $remote : Text
	var $private : Boolean
	var $file : 4D:C1709.File
	var $gh : cs:C1710.gh
	var $git : cs:C1710.Git
	
	$git:=This:C1470.Git
	$gh:=cs:C1710.gh.new()
	
	If ($gh.authorized)
		
		$private:=True:C214
		$remote:=$gh.createRepo(Form:C1466.project; $private)
		
		If (Length:C16($remote)>0)
			
			// Create the main branch
			If ($git.execute("branch -M main"))
				
				// Add remote url
				If ($git.execute("git remote set-url --add "+$remote))
					
					// Create readme
					$file:=File:C1566("/PACKAGE/README.md"; *)
					
					If (Not:C34($file.exists))
						
						$file.setText("# Welcome to "+Form:C1466.project)
						
					End if 
					
					$git.add("README.md")
					$git.add(".gitignore")
					$git.add(".gitattributes")
					$git.commit()
					
					// Push
					If ($git.execute("push -u origin main"))
						
						//
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function loadIcons()
	
	var $key : Text
	var $icon : Picture
	
	Form:C1466.dark:=This:C1470.form.darkScheme
	
	For each ($key; ["checked"; "github"; "gitLab"; "branch"; "master"; "tag"; "fix"; "remote"; "stash"])
		
		READ PICTURE FILE:C678(File:C1566(This:C1470.form.resourceFromScheme("/RESOURCES/Images/Main/"+$key+".png")).platformPath; $icon)
		CREATE THUMBNAIL:C679($icon; $icon; 20; 20)
		Form:C1466.icons[Lowercase:C14($key)]:=$icon
		
	End for each 
	
	$icon:=Form:C1466.icons.branch
	SET LIST ITEM ICON:C950(Form:C1466.selector; -21; $icon)
	$icon:=Form:C1466.icons.remote
	SET LIST ITEM ICON:C950(Form:C1466.selector; -22; $icon)
	$icon:=Form:C1466.icons.tag
	SET LIST ITEM ICON:C950(Form:C1466.selector; -23; $icon)
	$icon:=Form:C1466.icons.stash
	SET LIST ITEM ICON:C950(Form:C1466.selector; -24; $icon)
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/logo.png").platformPath; $icon)
	Form:C1466.logo:=$icon
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/added.svg").platformPath; $icon)
	Form:C1466.iconAdded:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/deleted.svg").platformPath; $icon)
	Form:C1466.iconDeleted:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/modified.svg").platformPath; $icon)
	Form:C1466.iconModified:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/moved.svg").platformPath; $icon)
	Form:C1466.iconMoved:=$icon
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateCommitList()
	
	var $branch; $line; $main; $meta; $style : Text
	var $empty; $label; $separator : Picture
	var $i; $notPushed : Integer
	var $item
	var $commit : Object
	var $c; $commits; $metas; $tags : Collection
	var $git : cs:C1710.Git
	
	$commit:={}
	$commits:=[]
	
	CREATE THUMBNAIL:C679($separator; $separator; 5)
	CREATE THUMBNAIL:C679($empty; $empty; 5)
	
	
	var $o : Object
	$o:={\
		colors: ["orange"; "green"; "blue"; "red"]; \
		stashes: []; \
		nodes: []; \
		level: 0\
		}
	
	var $graphMain : Picture
	$graphMain:=This:C1470.getLabelTag("graph"; $o.colors[0])
	
	$git:=This:C1470.Git
	
	// $notPushed:=$git.branchPushNumber()
	$notPushed:=$git.branchPushNumber($git.currentBranch)
	
	var $date; $today; $yesterday : Date
	$today:=Current date:C33
	$yesterday:=$today-1
	
	//$git.execute("log --format=%s|%an|%h|%aI|%H|%p|%P|%ae|%gd|%D")
	$git.execute("log --all --format=%s|%an|%h|%aI|%H|%p|%P|%ae|%gd|%D")
	
/*
0 = message
1 = author name
2 = short sha
3 = time stamp
4 = sha
5 = parent short sha
6 = parent sh
7 = author mail
8 = shortened reflog
9 = ref names
*/
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	
	// One commit per line
	For each ($line; Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1))
		
		$c:=Split string:C1554($line; "|")
		
		//ASSERT($c[0]#"wip Windows")
		
		If (Match regex:C1019("index\\son\\s"; $line; 1; *))
			
			var $node : Boolean
			$node:=True:C214
			$o.level-=1
			continue
			
		End if 
		
		CLEAR VARIABLE:C89($style)
		
		$tags:=[Null:C1517; Null:C1517; Null:C1517]
		
		$i+=1
		
		If ($i<=$notPushed)
			
			$tags[0]:=This:C1470.getLabelTag("toPush")
			
		End if 
		
		$metas:=Split string:C1554($c[9]; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		
		If ($metas.length>0)
			
			For each ($meta; $metas)
				
				Case of 
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="HEAD -> @")  // HEAD current branch
						
						$style:="bold"
						
						If ($metas.includes("origin/HEAD"))
							
							$tags[0]:=This:C1470.getLabelTag("origin")
							
						End if 
						
						$tags[1]:=This:C1470.getLabelTag("current branch"; Replace string:C233($meta; "HEAD ->"; ""))
						
						$branch:=$git.workingBranch.name
						$main:=$branch
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="tag: @")  // Tag
						
						$tags[2]:=This:C1470.getLabelTag("tag"; Replace string:C233($meta; "tag: "; ""))
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="origin/HEAD")  // Checked out branch
						
						If ($tags[0]#Null:C1517)\
							 | ($metas.includes("HEAD -> @"))
							
							continue
							
						End if 
						
						$tags[0]:=This:C1470.getLabelTag("origin")
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="refs/stash")\
						 && (Match regex:C1019("(?mi-s)On\\s([^:]*):\\s(.*)"; $c[0]; 1; $pos; $len; *))
						
						var $stash : Object
						$stash:={\
							on: Substring:C12($c[0]; $pos{1}; $len{1}); \
							index: Split string:C1554($c[5]; " ")[1]; \
							ref: "stash@{"+String:C10($o.stashes.length)+"}"\
							}
						
						$tags[0]:=This:C1470.getLabelTag("stash"; $stash.ref)
						
						$o.stashes.push($stash)
						
						$c[0]:=Substring:C12($c[0]; $pos{2}; $len{2})
						
						$branch:=$stash.ref
						
						$o.level+=1
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="origin/@")  // Origin branch
						
						If ($tags[0]#Null:C1517)
							
							continue
							
						End if 
						
						If ($metas.includes(Replace string:C233($meta; "origin/"; "")))
							
							$tags[0]:=This:C1470.getLabelTag("origin")
							
						Else 
							
							$tags[0]:=This:C1470.getLabelTag("origin"; Replace string:C233($meta; "origin/"; ""))
							
						End if 
						
						
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					Else   // Branch
						
						$branch:=$meta
						$tags[1]:=This:C1470.getLabelTag("branch"; $branch)
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
				End case 
			End for each 
			
		Else 
			
			$branch:=$main
			
		End if 
		
		// Mark:Create label
		var $offset; $x : Integer
		$offset:=20
		
		If ($o.level=0)
			
			$label:=$graphMain+$separator
			
		Else 
			
			var $svg : cs:C1710.svg
			$svg:=cs:C1710.svg.new()
			
			$svg.width($offset*($o.level+1)).height(30)
			
			For ($i; 0; $o.level; 1)
				
				$x:=5+($offset*$i)
				$svg.line($x; 0; $x; 24).color($o.colors[$i]).stroke(2)
				
			End for 
			
			$svg.circle(3; $x; 10).color($o.colors[$i-1])
			
			$label:=$svg.picture()+$separator
			
		End if 
		
		$node:=False:C215
		
		For each ($item; $tags)
			
			If ($item=Null:C1517)
				
				continue
				
			End if 
			
			$label+=$item+$separator
			
		End for each 
		
		$label+=This:C1470.getLabelTag("title"; $c[0]; {bold: $style="bold"; main: $branch=$main})
		
		$date:=Date:C102($c[3])
		
		$commit:={\
			label: $label; \
			author: {name: $c[1]; mail: $c[7]; avatar: This:C1470.getAvatar($c[7])}; \
			stamp: ($date=$today ? Get localized string:C991("today") : $date=$yesterday ? Get localized string:C991("yesterday") : String:C10($date; 2))+", "+String:C10(Time:C179($c[3])+?00:00:00?); \
			fingerprint: {short: $c[2]; long: $c[4]}; \
			parent: {short: $c[5]; long: $c[6]}; \
			notPushed: $i<=$notPushed; \
			origin: $i=($notPushed+1); \
			branch: $branch; \
			sort: (Date:C102($c[3])-!1970-01-01!)+Num:C11($c[3])\
			}
		
		$commits.push($commit)
		
	End for each 
	
	Form:C1466.commits:=$commits.orderBy("sort desc")
	
	// Restore selection, if any
	If (This:C1470.commits.item#Null:C1517)
		
		var $indx : Integer
		$indx:=Form:C1466.commits.indices("fingerprint.short = :1 "; This:C1470.commits.item.fingerprint.short)[0]
		This:C1470.commits.select($indx+1)
		
	End if 
	
	This:C1470.form.update()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getLabelTag($what : Text; $text : Text; $style : Object) : Picture
	
	var $icon : Picture
	var $svg : cs:C1710.svg
	$svg:=cs:C1710.svg.new()
	
	Case of 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="graph")
			
			$svg.width(10).height(30).color($text).stroke(2)
			$svg.line(5; 0; 5; 24)
			$svg.circle(3; 5; 10)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="title")
			
			$svg.text($text).position(2; 15)\
				.fontStyle($style.bold ? Bold:K14:2 : Plain:K14:1)\
				.color($style.main ? (Form:C1466.dark ? "white" : "black") : (Form:C1466.dark ? "silver" : "darkgray"))
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="branch")
			
			$svg.rect($svg.getTextWidth($text)*1.2; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("red").fill("lightpink").opacity(0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="current branch")
			
			$text:="🚧 "+$text  //✔️
			
			$svg.rect($svg.getTextWidth($text)+10; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("red").fill("lightpink").opacity(0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="origin")
			
			If (Length:C16($text)>0)
				
				$text:="origin/"+$text
				
				$svg.rect($svg.getTextWidth($text)+28; 20)\
					.radius(4).position(0.5; 0.5)\
					.stroke("limegreen").fill("palegreen").opacity(0.3)
				
				$svg.line(21; 0; 21; 20).stroke("limegreen").opacity(0.3)
				
				$svg.text($text).position(25; 15)
				
			Else 
				
				$svg.rect(21; 20)\
					.radius(4).position(0.5; 0.5)\
					.stroke("limegreen").fill("white").opacity(0.5)
				
			End if 
			
			$svg.image(Form:C1466.icons.github).position(0.6; 0.6)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="tag")
			
			$svg.rect($svg.getTextWidth($text)+28; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("blue").fill("lavender").opacity(0.5)
			
			$svg.image(Form:C1466.icons.tag).position(1; 1)
			
			$svg.line(21; 0; 21; 20).stroke("blue").opacity(0.5)
			
			$svg.text($text).position(25; 15)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="stash")
			
			$svg.rect($svg.getTextWidth($text)+28; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("grey").fill("lightgray").opacity(0.5)
			
			$svg.image(Form:C1466.icons.stash).position(1; 1)
			
			$svg.line(21; 0; 21; 20).stroke("grey").opacity(0.5)
			
			$svg.text($text).position(25; 15)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="toPush")
			
			$svg.circle(3).position(10; 10)\
				.color("orangered")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	$svg.close()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleMenus($what : Text; $current : Object)
	
	var $ignore : Text
	var $tgt
	var $data : Object
	var $file; $gitignore : 4D:C1709.File
	var $git : cs:C1710.Git
	
	$what:=$what || Get selected menu item parameter:C1005
	$git:=This:C1470.Git
	
	Case of 
			
			//______________________________________________________
		: ($what="close")
			
			CANCEL:C270
			
			//______________________________________________________
		: ($what="diff")
			
			If (Form:C1466.current#Null:C1517)
				
				$git.diffTool(Form:C1466.current.path)
				
			End if 
			
			//______________________________________________________
		: ($what="copy")
			
			SET TEXT TO PASTEBOARD:C523($current.path)
			
			//______________________________________________________
		: ($what="discard")
			
			This:C1470.Discard(This:C1470.unstaged.items)
			
			//______________________________________________________
		: ($what="delete")
			
			$file:=File:C1566(Convert path POSIX to system:C1107($current.path); fk platform path:K87:2)
			CONFIRM:C162(Replace string:C233(Get localized string:C991("areYouSureYouWantToDeleteTheFile"); "{name}"; $file.fullName))
			
			If (Bool:C1537(OK))
				
				File:C1566(Form:C1466.project.parent.parent.path+$current.path).delete()
				
				RELOAD PROJECT:C1739
				
				$git.status()
				
				This:C1470.form.refresh()
				
			End if 
			
			//______________________________________________________
		: ($what="open")
			
			$tgt:=This:C1470.Git.getPath($current.path)
			
			Case of 
					
					//——————————————————————————————————
				: (Value type:C1509($tgt)=Is text:K8:3)  // Method
					
					METHOD OPEN PATH:C1213($tgt; *)
					
					//——————————————————————————————————
				: (Value type:C1509($tgt)=Is object:K8:27)  // File
					
					If (Bool:C1537($tgt.exists))
						
						If ($tgt.extension=".4dform")
							
							FORM EDIT:C1749(String:C10($tgt.parent.fullName))
							
						Else 
							
							OPEN URL:C673($tgt.platformPath)
							
						End if 
					End if 
					
					//——————————————————————————————————
			End case 
			
			//______________________________________________________
		: ($what="settings")
			
			GIT SETTINGS(True:C214)
			
			//______________________________________________________
		: ($what="show")
			
			SHOW ON DISK:C922(File:C1566("/PACKAGE/"+$current.path; *).platformPath)
			
			//______________________________________________________
		: ($what="stage")
			
			This:C1470.Stage(This:C1470.unstaged.items)
			
			//______________________________________________________
		: ($what="stageAll")
			
			This:C1470.Stage(Form:C1466.unstaged)
			
			//______________________________________________________
		: ($what="unstage")
			
			This:C1470.Unstage(This:C1470.staged.items)
			
			//______________________________________________________
		: ($what="ignore@")
			
			$file:=File:C1566($current.path)
			
			$gitignore:=$git.cwd.file(".gitignore")
			$ignore:=$gitignore.getText("UTF-8"; Document with CR:K24:21)
			
			Case of 
					
					//____________________________
				: ($what="ignoreFile")
					
					If ($current.status#"??")
						
						$git.untrack($current.path)
						
					End if 
					
					$ignore+="\r"+$current.path
					
					//____________________________
				: ($what="ignoreExtension")
					
					// #TO_DO: Must unstack all indexed files with this extension
					
					$ignore+="\r*"+$file.extension
					
					//____________________________
				: ($what="ignoreCustom")
					
					$data:=New object:C1471(\
						"window"; Open form window:C675("PATTERN"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *); \
						"pattern"; $current.path; \
						"files"; $git.changes)
					
					DIALOG:C40("PATTERN"; $data)
					CLOSE WINDOW:C154
					
					If (Bool:C1537(OK))
						
						$ignore+="\r"+$data.pattern
						
					End if 
					
					//____________________________
				Else 
					
					ALERT:C41("Unmanaged tool: \""+$what+"\"…\r\rWe are going tout doux ;-)")
					
					//____________________________
			End case 
			
			$gitignore.setText($ignore; "UTF-8"; Document with LF:K24:22)
			
			$git.status()
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		Else 
			
			ALERT:C41("Unmanaged tool: \""+$what+"\"…\r\rWe are going tout doux ;-)")
			
			//———————————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getAvatar($mail : Text) : Picture
	
	var $t : Text
	
	$t:=Generate digest:C1147($mail; MD5 digest:K66:1)
	
	If (Form:C1466[$t]=Null:C1517)
		
		var $callback : cs:C1710._gravatarRequest
		$callback:=cs:C1710._gravatarRequest.new({user: $t})
		
		var $request : 4D:C1709.HTTPRequest
		$request:=4D:C1709.HTTPRequest.new("https://www.gravatar.com/avatar/"+$t; $callback)
		$request.wait()
		
	End if 
	
	return Form:C1466[$t]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function metaCommits($item : Object) : Object
	
	return {}
	
	//If ($item.branch=This.Git.workingBranch.name)
	//return {}
	//Else 
	//return {cell: {commitTitle: {fontStyle: "italic"; stroke: "grey"}}}
	//End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function meta($item : Object) : Object
	
	//FIXME: Colors according to scheme
	
	return {}
	
	Case of 
			
			//______________________________________________________
		: ($item.added)  // New (staged or not)
			
			return {fill: "green"}
			
			//______________________________________________________
		: ($item.deleted)  // Deleted (staged or not)
			
			return {fill: "red"}
			
			//______________________________________________________
		: ($item.moved)  // Moved
			
			return {fill: "black"}
			
			//______________________________________________________
		: ($item.modified)  // Modified
			
			return {fill: "orange"}
			
			//______________________________________________________
		Else 
			
			return {}
			
			//______________________________________________________
	End case 