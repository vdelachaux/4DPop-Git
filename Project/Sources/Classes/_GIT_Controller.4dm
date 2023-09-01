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
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
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
	
	var $menuEdit : cs:C1710.menu
	$menuEdit:=cs:C1710.menu.new().edit()  // Get a standard edit menu
	
	This:C1470.menuBar:=cs:C1710.menuBar.new([\
		":xliff:CommonMenuFile"; $menuFile; \
		":xliff:CommonMenuEdit"; $menuEdit]).set()
	
	// Mark:0️⃣ Toolbar
	This:C1470.toolbarLeft:=This:C1470.form.group.new()
	This:C1470.fetch:=This:C1470.form.button.new("fetch").addToGroup(This:C1470.toolbarLeft)
	This:C1470.pull:=This:C1470.form.button.new("pull").addToGroup(This:C1470.toolbarLeft)
	This:C1470.push:=This:C1470.form.button.new("push").addToGroup(This:C1470.toolbarLeft)
	
	This:C1470.open:=This:C1470.form.button.new("open")
	
	// Mark:0️⃣ Left pannel
	This:C1470.view:=This:C1470.form.listbox.new("menu")
	This:C1470.selector:=This:C1470.form.hList.new("selector")
	
	// Mark:1️⃣ Changes
	This:C1470.unstaged:=This:C1470.form.listbox.new("unstaged")
	This:C1470.stage:=This:C1470.form.button.new("stage")
	This:C1470.stageAll:=This:C1470.form.button.new("stageAll")
	
	This:C1470.staged:=This:C1470.form.listbox.new("staged")
	This:C1470.unstage:=This:C1470.form.button.new("unstage")
	
	// Mark:1️⃣ Diff pannel
	This:C1470.diff:=This:C1470.form.input.new("diff")
	
	// Mark:1️⃣ Commit panel
	This:C1470.commitment:=This:C1470.form.group.new()
	This:C1470.subject:=This:C1470.form.input.new("subject").addToGroup(This:C1470.commitment)
	This:C1470.description:=This:C1470.form.input.new("description").addToGroup(This:C1470.commitment)
	This:C1470.amend:=This:C1470.form.button.new("amend").addToGroup(This:C1470.commitment)
	This:C1470.commit:=This:C1470.form.button.new("commit").addToGroup(This:C1470.commitment)
	
	// Mark:2️⃣ Commits
	This:C1470.commits:=This:C1470.form.listbox.new("commits")
	
	// Mark:2️⃣ Commit
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
			: (This:C1470.fetch.catch($e; On Clicked:K2:4))
				
				$git.fetch()
				
				If ($git.fetch())\
					 & (This:C1470.form.page=This:C1470.pages.commits)
					
					This:C1470.updateCommitList()
					
				End if 
				
				//==============================================
			: (This:C1470.pull.catch($e; On Clicked:K2:4))
				
				$git.pull()
				
				RELOAD PROJECT:C1739
				
				If (This:C1470.form.page=This:C1470.pages.commits)
					
					This:C1470.updateCommitList()
					
				End if 
				
				//==============================================
			: (This:C1470.push.catch($e; On Clicked:K2:4))
				
				If (Not:C34($git.push()))
					
					ALERT:C41($git.error)
					
				End if 
				
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
				
				If ($git.success)
					
					This:C1470.subject.clear()
					This:C1470.description.clear()
					This:C1470.amend.clear()
					
					This:C1470.onActivate()
					
				End if 
				
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
	
	This:C1470.toolbarLeft.distributeLeftToRight({\
		start: 10; \
		minWidth: 50; \
		spacing: 10})
	
	// Tricks
	This:C1470.unstaged.setVerticalScrollbar(2)
	This:C1470.staged.setVerticalScrollbar(2)
	This:C1470.commits.setVerticalScrollbar(2)
	This:C1470.detailCommit.setVerticalScrollbar(0; 2)
	
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
	
	// Mark:Page menu definition
	Form:C1466.menu:=[\
		{label: Get localized string:C991("changes")}; \
		{label: Get localized string:C991("allCommits")}\
		]
	
	// Mark:Selector definition
	Form:C1466.selector:=New list:C375
	APPEND TO LIST:C376(Form:C1466.selector; "Branches"; -21; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "Remotes"; -22; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "Tags"; -23; New list:C375; True:C214)
	APPEND TO LIST:C376(Form:C1466.selector; "Staches"; -24; New list:C375; True:C214)
	SET LIST PROPERTIES:C387(Form:C1466.selector; 0; 0; 25)
	
	Form:C1466.amend:=False:C215
	Form:C1466.commitSubject:=""
	Form:C1466.commitDescription:=""
	
	This:C1470.form.goToPage("changes")
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $t : Text
	var $indx : Integer
	var $commit; $detail; $o : Object
	var $c : Collection
	var $git : cs:C1710.Git
	
	$git:=This:C1470.Git
	
	If (This:C1470.view.item=Null:C1517)
		
		This:C1470.view.selectFirstRow()
		
	End if 
	
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
					
					$git.diff($detail.path; $commit.parent.short+" "+$commit.fingerprint.short)
					
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
	
	var $t : Text
	var $notPushed; $ref : Integer
	var $o : Object
	var $git : cs:C1710.Git
	var $list; $sublist : cs:C1710.Hlist
	
	If (Form:C1466.dark#This:C1470.form.darkScheme)
		
		This:C1470.loadIcons()
		
	End if 
	
	$git:=This:C1470.Git
	
	// Mark:Update menu label
	If ($git.status()>0)
		
		Form:C1466.menu[0].label:="Changes ("+String:C10($git.changes.length)+")"
		
	Else 
		
		Form:C1466.menu[0].label:="Changes"
		
		Form:C1466.unstaged.clear()
		Form:C1466.staged.clear()
		
	End if 
	
	$notPushed:=$git.notPushedNumber
	Form:C1466.menu[1].comment:=$notPushed=0 ? "" : String:C10($notPushed)+"↑"
	
	Form:C1466.menu:=Form:C1466.menu  // Redraw
	
	// Mark:Branch list
	$list:=cs:C1710.Hlist.new(This:C1470.selector.getValue())
	$ref:=$list.selectedReference
	
	$git.branch()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-21).sublist).Empty()
	
	If ($git.branches.length>0)
		
		For each ($o; $git.branches)
			
			$o.type:="branch"
			
			$sublist.Append($o.name)\
				.SetParameter({key: "data"; value: JSON Stringify:C1217($o)})
			
			If ($o.current)
				
				$sublist.SetIcon({icon: Form:C1466.icons.master})\
					.SetItemStyle(Bold:K14:2)
				
			Else 
				
				$sublist.SetIcon({icon: Form:C1466.icons.branch})
				
			End if 
		End for each 
	End if 
	
	// Mark:Remote list
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
	
	// Mark:tag list
	$git.updateTags()
	
	$sublist:=cs:C1710.Hlist.new($list.GetItemByReference(-23).sublist).Empty()
	
	If ($git.tags.length>0)
		
		For each ($t; $git.tags)
			
			$o.type:="tag"
			
			$sublist.Append($t)\
				.SetParameter({key: "tag"; value: $t})\
				.SetIcon({icon: Form:C1466.icons.tag})
			
		End for each 
	End if 
	
	// Mark:staches list
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
	
	$list.selectedReference:=$ref
	
	This:C1470.form.refresh()
	
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
				
				This:C1470.form.goToPage(This:C1470.pages.commits)
				
			End if 
			
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
	
	If ($menu.popup().selected)
		
		Case of 
				
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
		End case 
	End if 
	
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
	
	If (This:C1470.Git.diffList($commit.parent.short; $commit.fingerprint.short))
		
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
			
			$tgt:=GIT Path($item.path)
			
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
					
					This:C1470.Git.execute("diff HEAD^ -- "+$item.path)
					
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
				
				$tgt:=GIT Path($o.path)
				
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
Function CreateGithubRepository($token : Text)
	
	//var $file : 4D.File
	//var $request : 4D.HTTPRequest
	//var $git : cs.Git
	//var $GithubAPI : cs.GithubAPI
	
	//$GithubAPI:=cs.GithubAPI.new().authToken($token)
	
	//// Check token validity
	//$request:=4D.HTTPRequest.new($GithubAPI.URL+"/octocat"; $GithubAPI)
	//$request.wait()
	
	//If ($request.response.status#200)
	
	//ALERT($request.response.body.message)
	//return 
	
	//End if 
	
	//// Try creating the repository
	//$GithubAPI.method:="POST"
	
	//$GithubAPI.body:={\
				accept: "application/vnd.github+json"; \
				name: $GithubAPI.CommpliantRepositoryName(Form.project); \
				private: True\
				}
	
	//$request:=4D.HTTPRequest.new($GithubAPI.URL+"/user/repos"; $GithubAPI)
	//$request.wait()
	
	//If ($request.response.status#201)
	
	//ALERT($request.response.body.errors.extract("message").join("\n"))
	//return 
	
	//End if 
	
	//$git:=This.Git
	
	//// Create readme
	//$file:=File("/PACKAGE/README.md"; *)
	
	//If (Not($file.exists))
	
	//File("/PACKAGE/README.md"; *).setText("# "+Form.project)
	
	//End if 
	
	//$git.add("README.md")
	////$git.commit("first commit")
	
	//// Add the origin to to the repository
	//If ($git.execute("remote add origin "+$request.response.body.clone_url))
	
	//// Create the main branch
	//If ($git.execute("branch -M main"))
	
	//// Push
	//If ($git.execute("push -u origin main"))
	
	////
	
	//End if 
	//End if 
	//End if 
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function loadIcons()
	
	var $key : Text
	var $icon : Picture
	
	Form:C1466.dark:=This:C1470.form.darkScheme
	
	READ PICTURE FILE:C678(File:C1566(This:C1470.form.resourceFromScheme("/RESOURCES/Images/Main/changes.png")).platformPath; $icon)
	CREATE THUMBNAIL:C679($icon; $icon; 20; 20)
	Form:C1466.menu[0].icon:=$icon
	READ PICTURE FILE:C678(File:C1566(This:C1470.form.resourceFromScheme("/RESOURCES/Images/Main/commits.png")).platformPath; $icon)
	CREATE THUMBNAIL:C679($icon; $icon; 20; 20)
	Form:C1466.menu[1].icon:=$icon
	
	Form:C1466.menu:=Form:C1466.menu  // Force redraw
	
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
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/added.png").platformPath; $icon)
	Form:C1466.iconAdded:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/deleted.png").platformPath; $icon)
	Form:C1466.iconDeleted:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/modified.png").platformPath; $icon)
	Form:C1466.iconModified:=$icon
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Main/moved.png").platformPath; $icon)
	Form:C1466.iconMoved:=$icon
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateCommitList()
	
	var $line : Text
	var $i; $notPushed : Integer
	var $c : Collection
	var $git : cs:C1710.Git
	
	$git:=This:C1470.Git
	
	Form:C1466.commits:=[]
	
	$notPushed:=$git.notPushedNumber
	
	$git.execute("log --abbrev-commit --format=%s|%an|%h|%aI|%H|%p|%P|%ae")
	
/*
0 = message
1 = author name
2 = short sha
3 = time stamp
4 = sha
5 = parent short sha
6 = parent sh
7 = author mail
*/
	
	// One commit per line
	For each ($line; Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1))
		
		$c:=Split string:C1554($line; "|")
		
		If ($c.length>=8)
			
			$i+=1
			
			If ($i<=$notPushed)
				
				$c[0]:="↑ "+$c[0]
				
			End if 
			
			Form:C1466.commits.push({\
				title: $c[0]; \
				author: {name: $c[1]; mail: $c[7]; avatar: This:C1470.getAvatar($c[7])}; \
				stamp: String:C10(Date:C102($c[3]))+" at "+String:C10(Time:C179($c[3])+?00:00:00?); \
				fingerprint: {short: $c[2]; long: $c[4]}; \
				parent: {short: $c[5]; long: $c[6]}; \
				notPushed: $i<=$notPushed; \
				origin: $i=($notPushed+1)\
				})
			
		End if 
	End for each 
	
	Form:C1466.commits:=Form:C1466.commits
	
	This:C1470.form.update()
	
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
			
			$tgt:=GIT Path($current.path)
			
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
		: ($what="show")
			
			SHOW ON DISK:C922(File:C1566("/PACKAGE/"+$current.path).platformPath)
			
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
			
			$gitignore:=$git.workingDirectory.file(".gitignore")
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