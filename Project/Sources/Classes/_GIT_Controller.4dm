property _unstaged; _staged; _commits; _commitDetail : Collection

property isSubform:=False:C215
property toBeInitialized:=False:C215

property autostash:=False:C215

property darkMode : Boolean

property pages:={local: 1; history: 2}

property helptip:=cs:C1710.tips.new()

property checkout:={\
stash: True:C214; \
noChange: False:C215; \
discard: False:C215}

// MARK: Constants 🧰
// FIXME:Manage all cases 🐞
property UNSTAGED_STATUS:=["??"; " M"; " D"; " R"; " C"]  //; "MD"; "AM"; "AD"]
property STAGED_STATUS:=["A "; "D "; "M "; "MM"; "R "; "C "]

property MOVED_FILE:=Localized string:C991("fileMoved")
property NEW_FILE:=Localized string:C991("newFile")
property MODIFIED_FILE:=Localized string:C991("modifiedFile")
property DELETED_FILE:=Localized string:C991("fileRemoved")
property BINARY_FILE:=Localized string:C991("binaryFile")

// MARK: FEATURES
property _FEATURES:={\
displayStashInCommitList: True:C214\
}

// MARK:Delegates 📦
property form : cs:C1710.form
property Git:=cs:C1710.Git.me

// MARK: UI 🖥️
property toolbarButtons; commitment; detail; groupDiff : cs:C1710.group

property pullDialog; pushDialog; checkoutDialog; newBranchDialog : cs:C1710.onBoard

property changes; history; fetch; pull; push; open; \
stage; unstage; diffTool; commit; amend; fileStage; fileMore : cs:C1710.button

property menu; unstaged; staged; commits; detailCommit : cs:C1710.listbox

property diff; subject; description; parent; detailDiff; currentPath : cs:C1710.input

property authorLabel; authorName; authorMail; stamp; shaLabe; sha; shaLabel; \
parentLabel; titleTop; title; titleBottom; emptyIndex; noCommitSelected : cs:C1710.static

property authorAvatar : cs:C1710.picture

property windowFrame : cs:C1710.subform

property icons : Object

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Menu bar
	var $menuHandle : Text
	$menuHandle:=Formula:C1597(formMenuHandle).source
	
	var $menuFile:=cs:C1710.menu.new().file()  // Get a standard file menu
	
	// Enrich with custom items
	$menuFile.line(1)
	$menuFile.append("Diff"; "diff"; 2).shortcut("D").method($menuHandle)
	$menuFile.line(3)
	$menuFile.append(":xliff:settings"; "settings"; 4).method($menuHandle)
	
	var $menuEdit:=cs:C1710.menu.new().edit()  // Get a standard edit menu
	
	cs:C1710.menuBar.new([\
		":xliff:CommonMenuFile"; $menuFile; \
		":xliff:CommonMenuEdit"; $menuEdit]).set()
	
	// Mark:Page 0️⃣ Toolbar
	This:C1470.windowFrame:=This:C1470.form.Subform("windowFrame")
	
	This:C1470.changes:=This:C1470.form.Button("changes")
	This:C1470.history:=This:C1470.form.Button("history")
	
	This:C1470.toolbarButtons:=This:C1470.form.Group()
	This:C1470.open:=This:C1470.form.Button("open").addToGroup(This:C1470.toolbarButtons)
	This:C1470.push:=This:C1470.form.Button("push").addToGroup(This:C1470.toolbarButtons)
	This:C1470.pull:=This:C1470.form.Button("pull").addToGroup(This:C1470.toolbarButtons)
	This:C1470.fetch:=This:C1470.form.Button("fetch").addToGroup(This:C1470.toolbarButtons)
	
	// Mark:Page 1️⃣ Changes
	This:C1470.unstaged:=This:C1470.form.Listbox("unstaged")
	This:C1470.stage:=This:C1470.form.Button("stage")
	
	This:C1470.staged:=This:C1470.form.Listbox("staged")
	This:C1470.unstage:=This:C1470.form.Button("unstage")
	This:C1470.emptyIndex:=This:C1470.form.Static("noChangesInIndex")
	
	// Mark:Page 1️⃣ Diff pannel
	This:C1470.groupDiff:=This:C1470.form.Group()
	This:C1470.currentPath:=This:C1470.form.Input("currentPath").addToGroup(This:C1470.groupDiff)
	This:C1470.fileStage:=This:C1470.form.Button("stageFile").addToGroup(This:C1470.groupDiff)
	This:C1470.fileMore:=This:C1470.form.Button("moreFile").addToGroup(This:C1470.groupDiff)
	This:C1470.diff:=This:C1470.form.Input("diff").addToGroup(This:C1470.groupDiff)
	
	// Mark:Page 1️⃣ Commit panel
	This:C1470.commitment:=This:C1470.form.Group()
	This:C1470.subject:=This:C1470.form.Input("subject").addToGroup(This:C1470.commitment)
	This:C1470.description:=This:C1470.form.Input("description").addToGroup(This:C1470.commitment)
	This:C1470.amend:=This:C1470.form.Button("amend").addToGroup(This:C1470.commitment)
	This:C1470.commit:=This:C1470.form.Button("commit").addToGroup(This:C1470.commitment)
	
	// Mark:Page 2️⃣ Commits
	This:C1470.commits:=This:C1470.form.Listbox("commits")
	
	// Mark:Page 2️⃣ Commit
	This:C1470.detail:=This:C1470.form.Group()
	This:C1470.detailCommit:=This:C1470.form.Listbox("detail_list").addToGroup(This:C1470.detail)
	This:C1470.authorLabel:=This:C1470.form.Static("authorLabel").addToGroup(This:C1470.detail)
	This:C1470.authorAvatar:=This:C1470.form.Picture("authorAvatar").addToGroup(This:C1470.detail)
	This:C1470.authorName:=This:C1470.form.Static("authorName").addToGroup(This:C1470.detail)
	This:C1470.authorMail:=This:C1470.form.Static("authorMail").addToGroup(This:C1470.detail)
	This:C1470.stamp:=This:C1470.form.Static("stamp").addToGroup(This:C1470.detail)
	This:C1470.shaLabel:=This:C1470.form.Static("shaLabel").addToGroup(This:C1470.detail)
	This:C1470.sha:=This:C1470.form.Static("sha").addToGroup(This:C1470.detail)
	This:C1470.parentLabel:=This:C1470.form.Static("parentLabel").addToGroup(This:C1470.detail)
	This:C1470.parent:=This:C1470.form.Input("parent").addToGroup(This:C1470.detail)
	This:C1470.titleTop:=This:C1470.form.Static("titleTop").addToGroup(This:C1470.detail)
	This:C1470.title:=This:C1470.form.Static("title").addToGroup(This:C1470.detail)
	This:C1470.titleBottom:=This:C1470.form.Static("titleBottom").addToGroup(This:C1470.detail)
	This:C1470.detailDiff:=This:C1470.form.Input("detailDiff").addToGroup(This:C1470.detail)
	
	This:C1470.noCommitSelected:=This:C1470.form.Static("noCommitSelected")
	
	// MARK:- [Constraints]
	// -> The fetch/pull/push buttons must remain centred on the background.
	//This.form.constraints.new(This.toolbarButtons).centerHorizontally.with("_background")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	// MARK: Form method
	If ($e.form)
		
		Case of 
				
				//______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.timer)
				
				This:C1470.form.update()
				
				//______________________________________________________
			: ($e.pageChange)
				
				If (This:C1470.form.page=This:C1470.pages.history)
					
					If (Form:C1466.page2Inited=Null:C1517)
						
						// FIXME: TURN AROUND - Force 4D to compute column widths
						LISTBOX SET COLUMN WIDTH:C833(*; This:C1470.commits.getColumnName(1); This:C1470.form.window.width-550)
						Form:C1466.page2Inited:=True:C214
						
					End if 
					
					This:C1470.updateCommits()
					
				End if 
				
				//______________________________________________________
			: ($e.activate)
				
				This:C1470.onActivate()
				
				//______________________________________________________
			: ($e.deactivate)
				
				This:C1470.windowFrame.refresh()
				
				//______________________________________________________
			: ($e.resize)
				
				This:C1470.form.constraints.apply()
				
				//______________________________________________________
			: ($e.unload)
				
				//This.selector.clear()
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	// MARK: Widgets method
	var $git:=This:C1470.Git
	
	Case of 
			
			//==============================================
		: (This:C1470.changes.catch($e))
			
			This:C1470._pageManager($e; This:C1470.pages.local)
			
			//==============================================
		: (This:C1470.history.catch($e))
			
			This:C1470._pageManager($e; This:C1470.pages.history)
			
			//==============================================
		: (This:C1470.unstaged.catch($e))\
			 || (This:C1470.staged.catch($e))
			
			This:C1470._stageUnstageManager($e)
			
			//==============================================
		: (This:C1470.stage.catch($e; On Clicked:K2:4))
			
			If (This:C1470.unstaged.items.length>0)
				
				This:C1470.Stage(This:C1470.unstaged.items)
				
			Else 
				
				This:C1470.StageAll()
				
			End if 
			
			//==============================================
		: (This:C1470.unstage.catch($e; On Clicked:K2:4))
			
			If (This:C1470.staged.items.length>0)
				
				This:C1470.Unstage(This:C1470.staged.items)
				
			Else 
				
				This:C1470.UnstageAll()
				
			End if 
			
			//==============================================
		: (This:C1470.fileStage.catch($e; On Clicked:K2:4))
			
			If (This:C1470.isInIndex)
				
				This:C1470.Unstage(This:C1470.staged.items)
				
			Else 
				
				This:C1470.Stage(This:C1470.unstaged.items)
				
			End if 
			
			//==============================================
		: (This:C1470.fileMore.catch($e; On Clicked:K2:4))
			
			var $menu:=cs:C1710.menu.new()
			
			$menu.append(":xliff:edit"; "open")
			$menu.append(":xliff:showInFinder"; "show")
			
			If (Not:C34(This:C1470.isInIndex))
				
				$menu.line()\
					.append(":xliff:discardChanges"; "discard")\
					.append(":xliff:deleteLocalFile"; "delete")
				
			End if 
			
			If (Not:C34($menu.popup().selected))
				
				return 
				
			End if 
			
			This:C1470.handleMenus($menu.choice; This:C1470.isInIndex ? This:C1470.staged.item : This:C1470.unstaged.item)
			
			//==============================================
		: (This:C1470.fetch.catch($e; On Clicked:K2:4))
			
			$git.fetch()
			This:C1470.onActivate()
			
			//==============================================
		: (This:C1470.pull.catch($e; On Clicked:K2:4))
			
			If (Not:C34(This:C1470.autostash))
				
				$git.execute("config rebase.autoStash")
				This:C1470.autostash:=$git.success
				
			End if 
			
			$git.execute("config pull.rebase")
			This:C1470.pullDialog.show({\
				rebase: $git.success; \
				stash: This:C1470.autostash\
				})
			
			//==============================================
		: (This:C1470.push.catch($e; On Clicked:K2:4))
			
			$git.execute("config push.followTags")
			
			This:C1470.pushDialog.show({\
				tags: $git.result#"false"; \
				force: False:C215\
				})
			
			//==============================================
		: (This:C1470.open.catch($e; On Clicked:K2:4))
			
			This:C1470._openManager()
			
			//==============================================
		: (This:C1470.subject.catch($e; On After Edit:K2:43))
			
			//TODO: Use value length
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
			
			var $message : Text:=This:C1470.subject.getValue()
			
			If (Length:C16(This:C1470.description.value)>0)
				
				$message+="\n"+This:C1470.description.value
				
			End if 
			
			$git.commit($message; Form:C1466.amend)
			
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// The title bar fills the entire width of the window
	This:C1470.windowFrame.left:=0
	This:C1470.windowFrame.width:=This:C1470.form.rect.width
	
	This:C1470.form.window.title:=File:C1566(Structure file:C489; fk platform path:K87:2).name+" - "+File:C1566(Structure file:C489(*); fk platform path:K87:2).name
	
	This:C1470.changes.show()
	This:C1470.history.show()
	
	// Tricks
	This:C1470.unstaged.setVerticalScrollbar(2)
	This:C1470.staged.setVerticalScrollbar(2)
	This:C1470.commits.setVerticalScrollbar(2)
	This:C1470.detailCommit.setVerticalScrollbar(2)
	
	This:C1470.stage.bestSize().disable()
	This:C1470.unstage.bestSize().disable()
	This:C1470.commit.bestSize(Align right:K42:4).disable()
	This:C1470.open.bestSize(Align right:K42:4)
	
	// Applying constraints
	This:C1470.form.constraints.apply()
	
	// TODO: Could be preferences
	This:C1470.diff.font:="Courier"
	This:C1470.diff.fontSize:=14
	
	This:C1470.form.appendEvents(On Alternative Click:K2:36)
	
	// May have been hidden when the dialog geometry was saved
	This:C1470.emptyIndex.show()
	This:C1470.noCommitSelected.show()
	
	// Form values
	Form:C1466.project:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
	Form:C1466.windowTitle:=This:C1470.form.window.title
	
	Form:C1466.version:=This:C1470.Git.getVersion("short")
	
	Form:C1466.unstaged:=[]
	Form:C1466.staged:=[]
	Form:C1466.commits:=[]
	Form:C1466.commitDetail:=[]
	
	Form:C1466.amend:=False:C215
	Form:C1466.commitSubject:=""
	Form:C1466.commitDescription:=""
	
	Form:C1466.darkScheme:=This:C1470.form.darkScheme
	
	Case of 
			
			//________________________________________________________________________________
		: (This:C1470.Git.success)
			
			// All is OK
			
			//________________________________________________________________________________
		: (This:C1470.Git.error="Git not installed")
			
			var $data:={main: Localized string:C991("gitNotInstalled")}
			This:C1470.onDialogConfirm($data)
			
			If (Bool:C1537($data.action))
				
				OPEN URL:C673("https://git-scm.com/download/win")
				
			End if 
			
			CANCEL:C270
			
			//________________________________________________________________________________
	End case 
	
	This:C1470.pullDialog:=cs:C1710.onBoard.new("embeddedDialogs"; "PULL")
	This:C1470.pullDialog.me:=This:C1470.pullDialog
	
	This:C1470.pushDialog:=cs:C1710.onBoard.new("embeddedDialogs"; "PUSH")
	This:C1470.pushDialog.me:=This:C1470.pushDialog
	
	This:C1470.checkoutDialog:=cs:C1710.onBoard.new("embeddedDialogs"; "CHECKOUT")
	This:C1470.checkoutDialog.me:=This:C1470.pushDialog
	
	This:C1470.newBranchDialog:=cs:C1710.onBoard.new("embeddedDialogs"; "NEW BRANCH")
	This:C1470.newBranchDialog.me:=This:C1470.newBranchDialog
	
	This:C1470._loadScheme()
	
	This:C1470.GoToPage(This:C1470.pages.local)
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $git:=This:C1470.Git
	var $indx : Integer
	
	If ($git.branches.length=0)
		
		$git.branch()
		
	End if 
	
	This:C1470._updateScheme()
	
	// MARK: Toolbar buttons
	var $branch : Text:=$git.branches.query("current = true").first().name
	
	This:C1470.fetch.title:=Localized string:C991("fetch")
	
	var $number:=$git.branchFetchNumber($branch)
	If ($number>0)
		
		This:C1470.fetch.title+=" ("+String:C10($number)+")"
		
	End if 
	
	This:C1470.push.title:=Localized string:C991("push")
	
	$number:=$git.branchPushNumber($branch)
	If ($number>0)
		
		This:C1470.push.title+=" ("+String:C10($number)+")"
		
	End if 
	
	This:C1470.toolbarButtons.distributeRigthToLeft({\
		minWidth: 60; \
		spacing: 5})
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.form.page=This:C1470.pages.local)
			
			If ($git.status()=0)
				
				Form:C1466.staged.clear()
				
				This:C1470.commitment.disable()
				This:C1470.commit.disable()
				
				This:C1470._stageUnstageButtonUpdate()
				
				return 
				
			End if 
			
			// Mark:Update file lists
			Form:C1466.unstaged:=$git.changes.query("status IN :1"; This:C1470.UNSTAGED_STATUS).orderBy("path")
			
			var $o : Object
			For each ($o; Form:C1466.unstaged)
				
				Use ($o)
					
					$o.added:=$o.status="??"
					$o.modified:=$o.status="@M@"
					$o.deleted:=$o.status="@D@"
					
					$o.icon:=$o.modified ? This:C1470.icons.edit\
						 : $o.deleted ? This:C1470.icons.remove\
						 : $o.added ? This:C1470.icons.add\
						 : Null:C1517
					
				End use 
			End for each 
			
			Form:C1466.staged:=$git.changes.query("status IN :1"; This:C1470.STAGED_STATUS).orderBy("path")
			
			For each ($o; Form:C1466.staged)
				
				Use ($o)
					
					$o.added:=$o.status="@A@"
					$o.modified:=$o.status="@M@"
					$o.deleted:=$o.status="@D@"
					$o.moved:=$o.status="@R@"
					
					$o.icon:=$o.modified ? This:C1470.icons.edit\
						 : $o.deleted ? This:C1470.icons.remove\
						 : $o.moved ? This:C1470.icons.rename\
						 : $o.added ? This:C1470.icons.add\
						 : Null:C1517
					
				End use 
			End for each 
			
			// Mark:Restore selections
			If (This:C1470.unstaged.item#Null:C1517)\
				 & (Form:C1466.unstaged.length>0)
				
				$indx:=This:C1470.unstaged.item#Null:C1517\
					 ? Form:C1466.unstaged.extract("path").indexOf(This:C1470.unstaged.item.path)\
					 : -1
				
				If ($indx=-1)
					
					This:C1470.unstaged.unselect()
					
				Else 
					
					This:C1470.unstaged.reveal($indx+1)
					
				End if 
			End if 
			
			If (This:C1470.staged.item#Null:C1517)\
				 & (Form:C1466.staged.length>0)
				
				$indx:=This:C1470.staged.item#Null:C1517\
					 ? Form:C1466.staged.extract("path").indexOf(This:C1470.staged.item.path)\
					 : -1
				
				If ($indx=-1)
					
					This:C1470.staged.unselect()
					
				Else 
					
					This:C1470.staged.reveal($indx+1)
					
				End if 
			End if 
			
			// Mark:Update commit panel
			This:C1470.commitment.enable(Form:C1466.staged.length>0)
			This:C1470.commit.enable(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
			
			This:C1470._stageUnstageButtonUpdate()
			
			//______________________________________________________
		: (This:C1470.form.page=This:C1470.pages.history)
			
			var $commit:=This:C1470.commits.item
			var $detail:=This:C1470.detailCommit.item
			
			If ($commit=Null:C1517) || ($detail=Null:C1517)
				
				Form:C1466.diff:=""
				This:C1470.detailDiff.hide()
				
				return 
				
			End if 
			
			This:C1470.detailDiff.show()
			
			var $c:=Split string:C1554($detail.label; " -> "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
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
					$git.diff(This:C1470.Git.workspace.file($detail.path).path; $c.length>1 ? $c[1] : $c[0]+" "+$commit.fingerprint.short)
					
					//______________________________________________________
			End case 
			
			$c:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			var $t : Text
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
	
	var $git:=This:C1470.Git
	
	// Toolbar
	This:C1470.windowFrame.refresh()
	Form:C1466.commiter:=Replace string:C233(Localized string:C991("commitingAs"); "{name}"; $git.userName())
	Form:C1466.windowTitle:=This:C1470.form.window.title+" on branch "+$git.currentBranch
	
	This:C1470._updateScheme()
	
	If (This:C1470.form.page=This:C1470.pages.history)
		
		This:C1470.updateCommits()
		
	End if 
	
	If ($git.status()>0)
		
		This:C1470.changes.helpTip:=Localized string:C991("changesView")+" ("+String:C10($git.changes.length)+")"
		
	Else 
		
		This:C1470.changes.helpTip:=Localized string:C991("changesView")
		
		Form:C1466.unstaged.clear()
		Form:C1466.staged.clear()
		
	End if 
	
	This:C1470.form.refresh()
	
	//
	//Mark:-Managers
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pageManager($e : cs:C1710.evt; $page : Integer)
	
	Case of 
			
			// ______________________________________________________
		: ($e.mouseEnter)
			
			This:C1470.helptip.instantly()
			This:C1470.helptip.duration:=720*2
			
			// ______________________________________________________
		: ($e.mouseLeave)
			
			This:C1470.helptip.restore()
			
			// ______________________________________________________
		: ($e.click)
			
			This:C1470.GoToPage($page)
			
			// ______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _openManager()
	
	var $git:=This:C1470.Git
	var $hasRemote:=$git.execute("config --get remote.origin.url")
	$hasRemote:=$hasRemote ? Position:C15("github.com"; String:C10($git.result))>0 : $hasRemote
	
	var $menu:=cs:C1710.menu.new({embedded: True:C214})
	
	$menu.append(":xliff:openInTerminal"; "terminal").icon("/RESOURCES/Images/Menus/terminal.png")\
		.append(":xliff:showOnDisk"; "show").icon("/RESOURCES/Images/Menus/disk.png")\
		.line()\
		.append(":xliff:viewOnGithub"; "github").icon("/RESOURCES/Images/Menus/gitHub.png").enable($hasRemote)\
		.line()
	
	openWith($menu)
	
	If ($menu.popup(This:C1470.open).selected)
		
		GIT MENU($menu)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _stageUnstageManager($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	var $staged:=This:C1470.isInIndex
	var $current:=$staged ? This:C1470.staged.item : This:C1470.unstaged.item
	var $sel:=$staged ? This:C1470.staged.items : This:C1470.unstaged.items
	
	Form:C1466.current:=$current
	
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
			
			var $menu:=cs:C1710.menu.new()
			
			If ($sel.length=1)
				
				$menu.append(":xliff:edit"; "open")
				
				If (["??"; " D"; "A "].indexOf($current.status)=-1)
					
					$menu.append(":xliff:externalDiff"; "diffTool").shortcut("D")
					
				End if 
				
				$menu.line()
				
				If ([" D"].indexOf($current.status)=-1)
					
					$menu.append(":xliff:showInFinder"; "show")
					$menu.append(":xliff:deleteLocalFile"; "delete")
					
				End if 
				
				$menu.append(":xliff:copyPath"; "copy")
				
				$menu.line()
				
			End if 
			
			If ($current#Null:C1517)
				
				If ($staged)
					
					$menu.append(":xliff:unstage"; "unstage").shortcut("S"; 512)
					
				Else 
					
					$menu.append(":xliff:stage"; "stage").shortcut("S"; 512)
					$menu.append(":xliff:discardChanges"; "discard")
					
				End if 
				
				$menu.line()
				
			End if 
			
			Case of 
					
					//———————————————————————————————————————
				: ($staged)\
					 & (Form:C1466.staged.length>0)
					
					$menu.append(":xliff:unstageAll"; "unStageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
				: (Form:C1466.unstaged.length>0)
					
					$menu.append(":xliff:stageAll"; "stageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
			End case 
			
			If ($current#Null:C1517)
				
				var $file : 4D:C1709.File:=This:C1470.Git.workspace.file($current.path)
				
				$menu.line()\
					.append(":xliff:ignore"; cs:C1710.menu.new()\
					.append(Replace string:C233(Localized string:C991("ignoreFile"); "{file}"; $file.fullName); "ignoreFile")\
					.append(Replace string:C233(Localized string:C991("ignoreAllExtensionFiles"); "{extension}"; $file.extension); "ignoreExtension")\
					.line()\
					.append(":xliff:customPattern"; "ignoreCustom"))
				
			End if 
			
			If (Not:C34($menu.popup().selected))
				
				return 
				
			End if 
			
			This:C1470.handleMenus($menu.choice; $current)
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			This:C1470.DoDiff(Form:C1466.current)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _stageUnstageButtonUpdate()
	
	If (This:C1470.unstaged.item=Null:C1517) || (This:C1470.unstaged.item.length=0)
		
		This:C1470.stage.title:=Localized string:C991("stageAll")
		
	Else 
		
		This:C1470.stage.title:=Localized string:C991("stage")
		
	End if 
	
	This:C1470.stage.enable((Form:C1466.unstaged#Null:C1517) && (Form:C1466.unstaged.length>0))
	
	If (This:C1470.staged.items=Null:C1517) || (This:C1470.staged.items.length=0)
		
		This:C1470.unstage.title:=Localized string:C991("unstageAll")
		
	Else 
		
		This:C1470.unstage.title:=Localized string:C991("unstage")
		
	End if 
	
	This:C1470.unstage.enable((Form:C1466.staged#Null:C1517) && (Form:C1466.staged.length>0))
	
	This:C1470.emptyIndex.show((Form:C1466.staged=Null:C1517) || (Form:C1466.staged.length=0))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _commitsManager()
	
	var $t : Text
	
	This:C1470.detailCommit.unselect()
	
	Form:C1466.commitDetail.clear()
	Form:C1466.diff:=""
	
	If (Form:C1466.currentCommit#Null:C1517)
		
		Form:C1466.currentCommit.label:=Form:C1466.currentCommit._.normal
		
	End if 
	
	var $commit:=This:C1470.commits.item
	Form:C1466.currentCommit:=$commit
	
	If ($commit=Null:C1517)
		
		This:C1470.noCommitSelected.show()
		This:C1470.detail.hide()
		
		return 
		
	End if 
	
	$commit.label:=$commit._.selected
	
	This:C1470.noCommitSelected.hide()
	This:C1470.detail.show()
	
	var $c:=Split string:C1554($commit.parent.short; " ")
	
	If (This:C1470.Git.diffList($c.length=0 ? "" : $c.length>1 ? $c[1] : $c[0]; $commit.fingerprint.short))
		
		For each ($t; Split string:C1554(This:C1470.Git.result; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2))
			
			$c:=Split string:C1554($t; "\t"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			var $o:={\
				status: $c[0]; \
				path: $c[1]; \
				label: $c[1]; \
				added: $c[0]="A"; \
				modified: $c[0]="M"; \
				deleted: $c[0]="D"; \
				moved: $c.length>=3\
				}
			
			$o.icon:=$o.modified ? This:C1470.icons.edit\
				 : $o.deleted ? This:C1470.icons.remove\
				 : $o.moved ? This:C1470.icons.rename\
				 : $o.added ? This:C1470.icons.add\
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
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== 
Function get isInIndex() : Boolean
	
	return This:C1470.form.focused=This:C1470.staged.name
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function DoDiff($item : Object)
	
	This:C1470._stageUnstageButtonUpdate()
	
	If ($item=Null:C1517)
		
		This:C1470.groupDiff.hide()
		
		return 
		
	End if 
	
	var $diff : Text
	
	This:C1470.groupDiff.show()
	
	This:C1470.fileStage.title:=Localized string:C991(This:C1470.isInIndex ? "unstage" : "stage")
	This:C1470.fileStage.bestSize(Align right:K42:4)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––
		: ($item.added)
			
			var $tgt : Variant:=This:C1470.Git.getTarget($item.path)
			
			Case of 
					
					//______________________________________________________
				: (Value type:C1509($tgt)=Is object:K8:27)\
					 && (OB Instance of:C1731($tgt; 4D:C1709.File))
					
					If (Bool:C1537($tgt.exists))
						
						Case of 
								
								//————————————————————————————————————
							: ($tgt.extension=".svg")  // Treat svg as text file
								
								var $code : Text:=$tgt.getText()
								
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
			End case 
			
			If (Length:C16($code)>0)
				
				
				
				$code:=Replace string:C233($code; "<"; "&lt;")
				$code:=Replace string:C233($code; ">"; "&gt;")
				
				ST SET TEXT:C1115($diff; $code; ST Start text:K78:15; ST End text:K78:16)
				ST SET ATTRIBUTES:C1093($diff; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; Form:C1466.darkScheme ? "lawngreen" : "green")
				
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
			
			$diff:=This:C1470.GetStyledDiffText($item)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	Form:C1466.diff:=$diff
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function GetStyledDiffText($item : Object) : Text
	
	var $dark : Boolean:=Form:C1466.darkScheme
	var $line; $styled : Text
	var $len; $pos : Integer
	
	var $git:=This:C1470.Git
	
	If (Not:C34($git.success))
		
		var $o : Object:=$git.history.pop()
		ST SET TEXT:C1115($styled; String:C10($o.cmd)+"\r\r"+String:C10($o.error); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; "red")
		
		return $styled
		
	End if 
	
	If (Length:C16($git.result)=0)
		
		return 
		
	End if 
	
	// MARK: Remove tokens
	var $code:=cs:C1710.regex.new($git.result; "(?m-si):[CK]:?\\d+(?::\\d+)?").substitute("")
	
	var $c:=Split string:C1554($code; "\n"; sk ignore empty strings:K86:1)
	
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
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; $dark ? "lawngreen" : "green")
		
		return $styled
		
	End if 
	
	If ($item.deleted)
		
		ST SET TEXT:C1115($styled; $c.join("\n"); ST Start text:K78:15; ST End text:K78:16)
		ST SET ATTRIBUTES:C1093($styled; ST Start text:K78:15; ST End text:K78:16; Attribute text color:K65:7; $dark ? "fuchsia" : "red")
		
		return $styled
		
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
	var $start:=1
	
	While (Match regex:C1019("(?mi-s)^(<[^>]*>@@[^$]*)$"; $styled; $start; $pos; $len))
		
		If ($pos>1)
			
			$styled:=Substring:C12($styled; 1; $pos-1)+"\n"+Substring:C12($styled; $pos)
			
		End if 
		
		$start+=$len
		
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
Function GoToPage($page : Integer)
	
	This:C1470.changes.value:=Num:C11($page=1)
	This:C1470.history.value:=Num:C11($page=2)
	This:C1470.form.goToPage($page)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Stage($items : Collection)
	
	var $o : Object
	
	For each ($o; $items)
		
		This:C1470.Git.add($o.path)
		
	End for each 
	
	This:C1470.unstaged.unselect()
	Form:C1466.current:=Null:C1517
	
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
	
	This:C1470.staged.unselect()
	Form:C1466.current:=Null:C1517
	
	This:C1470.DoDiff()
	This:C1470.onActivate()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function UnstageAll()
	
	This:C1470.Git.unstage("all")
	
	This:C1470.DoDiff()
	This:C1470.onActivate()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Discard($items : Collection)
	
	var $o:={\
		main: Localized string:C991("doYouWantToDiscardAllChangesInTheSelectedFiles"); \
		buttons: {okTitle: Localized string:C991("discard")}}
	
	This:C1470.onDialogConfirm($o)
	
	If (Not:C34(Bool:C1537($o.action)))
		
		return 
		
	End if 
	
	var $git:=This:C1470.Git
	
	For each ($o; $items)
		
		If ($o.status="??")
			
			var $tgt:=This:C1470.Git.getTarget($o.path)
			
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Checkout($branch : Object)
	
	This:C1470.Git.branch("use"; $branch.name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CreateGithubRepository()
	
	var $git:=This:C1470.Git
	var $gh:=cs:C1710.gh.me
	
	If ($gh.authorized)
		
		var $private:=True:C214
		var $remote:=$gh.createRepo(Form:C1466.project; $private)
		
		If (Length:C16($remote)>0)
			
			// Create the main branch
			If ($git.execute("branch -M main"))
				
				// Add remote url
				If ($git.execute("git remote set-url --add "+$remote))
					
					// Create readme
					var $file:=File:C1566("/PACKAGE/README.md"; *)
					
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
Function updateCommits()
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	var $empty; $separator : Picture
	CREATE THUMBNAIL:C679($separator; $separator; 5)
	CREATE THUMBNAIL:C679($empty; $empty; 5)
	
	var $o:={\
		colors: ["orange"; "green"; "blue"; "red"]; \
		stashes: []\
		}
	
	var $git:=This:C1470.Git
	var $notPushed : Integer:=$git.branchPushNumber($git.currentBranch)
	
	var $today:=Current date:C33
	var $yesterday : Date:=$today-1
	
	$git.execute("log --all --format=%s|%an|%h|%aI|%H|%p|%P|%ae|%gd|%D")
	
/*
0 = message
1 = author name
2 = short sha
3 = time stamp
4 = sha
5 = parent short sha
6 = parent sha
7 = author mail
8 = shortened reflog
9 = ref names
*/
	
	// One commit per line
	var $commits:=[]
	var $line; $style : Text
	var $i : Integer
	
	For each ($line; Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1))
		
		var $c:=Split string:C1554($line; "|")
		
		If (Match regex:C1019("index\\son\\s"; $line; 1; *))
			
			continue
			
		End if 
		
		If (Match regex:C1019("^untracked files"; $line; 1; *))
			
			continue
			
		End if 
		
		CLEAR VARIABLE:C89($style)
		
		var $tags:=[Null:C1517; Null:C1517; Null:C1517]
		
		$i+=1
		
		If ($i<=$notPushed)
			
			$tags[0]:=This:C1470.getLabelTag("toPush")
			
		End if 
		
		var $metas:=$c.length>=10 ? Split string:C1554($c[9]; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2) : []
		
		If ($metas.length>0)
			
			var $meta : Text
			For each ($meta; $metas)
				
				Case of 
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="HEAD -> @")  // HEAD current branch
						
						$style:="bold"
						
						If ($metas.includes("origin/HEAD"))
							
							$tags[0]:=This:C1470.getLabelTag("origin")
							
						End if 
						
						$tags[1]:=This:C1470.getLabelTag("current branch"; Replace string:C233($meta; "HEAD ->"; ""))
						
						var $branch : Text:=$git.workingBranch.name
						var $main:=$branch
						
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
						
						If (Not:C34(Bool:C1537(This:C1470._FEATURES.displayStashInCommitList)))
							
							continue
							
						End if 
						
						var $stash:={\
							on: Substring:C12($c[0]; $pos{1}; $len{1}); \
							index: Split string:C1554($c[5]; " ")[1]; \
							ref: "stash@{"+String:C10($o.stashes.length)+"}"\
							}
						
						$tags[0]:=This:C1470.getLabelTag("stash"; $stash.ref)
						
						$o.stashes.push($stash)
						
						$c[0]:=Substring:C12($c[0]; $pos{2}; $len{2})
						
						$branch:=$stash.ref
						
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
		var $label:=$empty
		var $item
		
		For each ($item; $tags)
			
			If ($item=Null:C1517)
				
				continue
				
			End if 
			
			$label+=$item+$separator
			
		End for each 
		
		var $normal:=$label+This:C1470.getLabelTag("title"; $c[0]; {bold: $style="bold"; main: $branch=$main})
		var $selected:=$label+This:C1470.getLabelTag("title"; $c[0]; {bold: $style="bold"; selected: True:C214})
		
		var $date:=Date:C102($c[3])
		
		$commits.push({\
			title: $c[0]; \
			label: $normal; \
			author: {name: $c[1]; mail: $c[7]; avatar: This:C1470.getAvatar($c[7])}; \
			stamp: ($date=$today ? Localized string:C991("today") : $date=$yesterday ? Localized string:C991("yesterday") : String:C10($date; 2))+", "+String:C10(Time:C179($c[3])+?00:00:00?); \
			fingerprint: {short: $c[2]; long: $c[4]}; \
			parent: {short: $c[5]; long: $c[6]}; \
			notPushed: $i<=$notPushed; \
			origin: $i=($notPushed+1); \
			branch: $branch; \
			sort: (Date:C102($c[3])-!1970-01-01!)+Num:C11($c[3]); \
			_: {normal: $normal; selected: $selected}\
			})
		
	End for each 
	
	Form:C1466.commits:=$commits.orderBy("sort desc")
	
	// Restore selection, if any
	If (This:C1470.commits.item#Null:C1517)
		
		$c:=Form:C1466.commits.indices("fingerprint.short = :1 "; This:C1470.commits.item.fingerprint.short)
		
		If ($c.length>0)
			
			This:C1470.commits.select($c[0]+1)
			
		End if 
	End if 
	
	This:C1470.form.update()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getLabelTag($what : Text; $text : Text; $style : Object) : Picture
	
	var $dark : Boolean:=Form:C1466.darkScheme
	var $svg:=cs:C1710.svg.new()
	
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
				.fontStyle($style.bold ? Bold:K14:2 : Plain:K14:1)
			
			If (Bool:C1537($style.selected))
				
				$svg.color("white")
				
			Else 
				
				$svg.color($style.main ? ($dark ? "white" : "black") : ($dark ? "silver" : "darkgray"))
				
			End if 
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="branch")
			
			$svg.rect($svg.getTextWidth($text)*1.2; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke($dark ? "lightpink" : "red").fill($dark ? "deeppink" : "lightpink").opacity($dark ? 0.8 : 0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="current branch")
			
			$text:="🚧 "+$text  //✔️
			
			$svg.rect($svg.getTextWidth($text)+10; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke($dark ? "lightpink" : "red").fill($dark ? "deeppink" : "lightpink").opacity($dark ? 0.8 : 0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="origin")
			
			If (Length:C16($text)>0)
				
				$text:="origin/"+$text
				
				$svg.rect($svg.getTextWidth($text)+28; 20)\
					.radius(4).position(0.5; 0.5)\
					.stroke("limegreen").fill($dark ? "seagreen" : "limegreen").opacity($dark ? 0.8 : 0.3)
				
				$svg.line(21; 0; 21; 20).stroke("limegreen").opacity(0.3)
				
				$svg.text($text).position(25; 15).color($dark ? "white" : "black")
				
			Else 
				
				$svg.rect(21; 20)\
					.radius(4).position(0.5; 0.5)\
					.stroke("limegreen").fill("white").opacity(0.5)
				
			End if 
			
			$svg.image(This:C1470.icons.github)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="tag")
			
			$svg.rect($svg.getTextWidth($text)+28; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("blue").fill($dark ? "fuchsia" : "lavender").opacity($dark ? 0.8 : 0.3)
			
			$svg.image(This:C1470.icons.tag)
			
			$svg.line(21; 0; 21; 20).stroke("blue").opacity(0.5)
			
			$svg.text($text).position(25; 15).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="stash")
			
			$svg.rect($svg.getTextWidth($text)+28; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("grey").fill($dark ? "darkgray" : "lightgray").opacity($dark ? 0.8 : 0.3)
			
			$svg.image(This:C1470.icons.stash)
			
			$svg.line(21; 0; 21; 20).stroke("grey").opacity(0.5)
			
			$svg.text($text).position(25; 15).color($dark ? "white" : "black")
			
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
Function handleMenus($what : Text; $data : Object)
	
	$what:=$what || Get selected menu item parameter:C1005
	var $git:=This:C1470.Git
	
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
			
			SET TEXT TO PASTEBOARD:C523($data.path)
			
			//______________________________________________________
		: ($what="copyName")
			
			SET TEXT TO PASTEBOARD:C523($data.name || $data.tag)
			
			//______________________________________________________
		: ($what="discard")
			
			This:C1470.Discard(This:C1470.unstaged.items)
			
			//______________________________________________________
		: ($what="delete")
			
			var $file:=File:C1566(Convert path POSIX to system:C1107($data.path); fk platform path:K87:2)
			var $o:={main: Replace string:C233(Localized string:C991("areYouSureYouWantToDeleteTheFile"); "{name}"; $file.fullName)}
			
			This:C1470.onDialogConfirm($o)
			
			If (Bool:C1537($o.action))
				
				File:C1566(Form:C1466.project.parent.parent.path+$data.path).delete()
				
				RELOAD PROJECT:C1739
				
				$git.status()
				
				This:C1470.form.refresh()
				
			End if 
			
			//______________________________________________________
		: ($what="open")
			
			var $tgt : Variant:=This:C1470.Git.getTarget($data.path)
			
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
			
			SHOW ON DISK:C922(File:C1566("/PACKAGE/"+$data.path; *).platformPath)
			
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
			
			$file:=This:C1470.Git.workspace.file($data.path)
			
			var $ignore : Text:=$git.gitignore.getText("UTF-8"; Document with CR:K24:21)
			
			Case of 
					
					//____________________________
				: ($what="ignoreFile")
					
					If ($data.status#"??")
						
						$git.untrack($data.path)
						
					End if 
					
					$ignore+="\r"+$data.path
					
					//____________________________
				: ($what="ignoreExtension")
					
					// TODO: Must unstack all indexed files with this extension
					
					$ignore+="\r*"+$file.extension
					
					//____________________________
				: ($what="ignoreCustom")
					
					$data:={\
						window: Open form window:C675("PATTERN"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *); \
						pattern: $data.path; \
						files: $git.changes}
					
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
			
			$git.gitignore.setText($ignore; "UTF-8"; Document with LF:K24:22)
			
			$git.status()
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($what="checkout")
			
			If ($data.name#Form:C1466.currentBranch)
				
				Form:C1466.currentBranch:=$data.name
				
				If ($git.status()>0)
					
					This:C1470.checkoutDialog.show({\
						branch: $data.name; \
						stash: This:C1470.checkout.stash; \
						noChange: This:C1470.checkout.noChange; \
						discard: This:C1470.checkout.discard\
						})
					
					return 
					
				End if 
				
				This:C1470.Git.checkout($data.name)
				
				RELOAD PROJECT:C1739
				
				This:C1470.form.refresh()
				
			End if 
			//______________________________________________________
		: ($what="newBranch")
			
			This:C1470.newBranchDialog.show({\
				at: $data.ref; \
				label: $data.name; \
				branch: ""; \
				checkout: True:C214; \
				stash: This:C1470.checkout.stash; \
				noChange: This:C1470.checkout.noChange; \
				discard: This:C1470.checkout.discard\
				})
			
			//______________________________________________________
		Else 
			
			ALERT:C41("Unmanaged tool: \""+$what+"\"…\r\rWe are going tout doux 🤒")
			
			//———————————————————————————————————————
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getAvatar($mail : Text) : Picture
	
	var $t:=Generate digest:C1147($mail; MD5 digest:K66:1)
	
	If (Form:C1466[$t]=Null:C1517)
		
		var $callback:=cs:C1710._gravatarRequest.new({user: $t})
		
		var $request : 4D:C1709.HTTPRequest
		$request:=4D:C1709.HTTPRequest.new("https://www.gravatar.com/avatar/"+$t; $callback)
		$request.wait()
		
	End if 
	
	return Form:C1466[$t]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function metaCommits($item : Object) : Object
	
	If ($item=This:C1470.commits.item)  // Selected
		
		If (This:C1470.form.window.isFrontmost())
			
			return This:C1470.form.lightScheme ? {fill: "#0064E1"; stroke: "white"} : Null:C1517
			
		Else 
			
			return This:C1470.form.lightScheme ? {fill: "#DCDCDC"; stroke: "white"} : {fill: "#464646"; stroke: "white"}
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _updateScheme()
	
	If (This:C1470.form.isSchemeModified() || Shift down:C543)
		
		Form:C1466.darkScheme:=This:C1470.form.darkScheme
		
		This:C1470._loadScheme()
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _loadScheme()
	
	This:C1470.commits.selectionHighlight:=This:C1470.form.lightScheme
	
	This:C1470.icons:={}
	
	var $key : Text
	var $icon : Picture
	For each ($key; ["checked"; "github"; "gitLab"; "branch"; "master"; "tag"; "fix"; "remote"; "stash"])
		
		READ PICTURE FILE:C678(File:C1566(This:C1470.form.resourceFromScheme("/RESOURCES/Images/Main/"+$key+".png")).platformPath; $icon)
		CREATE THUMBNAIL:C679($icon; $icon; 22; 22)
		This:C1470.icons[Lowercase:C14($key)]:=$icon
		
	End for each 
	
	For each ($key; ["Add"; "Remove"; "Edit"; "Rename"])
		
		READ PICTURE FILE:C678(File:C1566(This:C1470.form.resourceFromScheme("/RESOURCES/Images/Status/"+$key+".png")).platformPath; $icon)
		This:C1470.icons[Lowercase:C14($key)]:=$icon
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Display an alert dialog horizontally centered & at the top 1/3
Function onDialogAlert($data : Object)
	
	$data.type:="alert"
	This:C1470._onDialogMessage($data)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Display a confirmation dialog horizontally centered & at the top 1/3
Function onDialogConfirm($data : Object)
	
	$data.type:="confirm"
	$data.buttons:=$data.buttons || {}
	$data.buttons.cancel:=True:C214
	This:C1470._onDialogMessage($data)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Position the window horizontally centered & at the top 1/3
Function _onDialogMessage($data : Object)
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	
	FORM GET PROPERTIES:C674("MESSAGE"; $width; $height)
	GET WINDOW RECT:C443($left; $top; $right; $bottom)
	
	$left+=((($right-$left)-$width)\2)
	$top+=(($bottom-$top)\3)
	
	$data:=$data || {}
	$data._winRef:=Open form window:C675("MESSAGE"; Movable form dialog box:K39:8+0x00080000; $left; $top)
	
	DIALOG:C40("MESSAGE"; $data)
	CLOSE WINDOW:C154($data._winRef)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Display a request dialog horizontally centered & at the top 1/3
Function onDialogRequest($data : Object)
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	
	FORM GET PROPERTIES:C674("REQUEST"; $width; $height)
	GET WINDOW RECT:C443($left; $top; $right; $bottom)
	
	$left+=((($right-$left)-$width)\2)
	$top+=(($bottom-$top)\3)
	
	$data:=$data || {}
	$data._winRef:=Open form window:C675("REQUEST"; Movable form dialog box:K39:8+0x00080000; $left; $top)
	
	DIALOG:C40("REQUEST"; $data)
	CLOSE WINDOW:C154($data._winRef)
	