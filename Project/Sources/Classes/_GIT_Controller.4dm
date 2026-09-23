property _unstaged; _staged; _commits; _commitDetail : Collection

property isSubform:=False:C215
property toBeInitialized:=False:C215

property autostash:=False:C215

property darkMode : Boolean

property pages:={local: 1; history: 2}

property helptip:=cs:C1710.ui.tips.new()

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

// MARK:Delegates 📦
property form : cs:C1710.ui.form
property Git:=cs:C1710.Git.me

// MARK: UI 🖥️
property toolbarButtons; commitment; detail; groupDiff; loading : cs:C1710.ui.group

property pullDialog; pushDialog; checkoutDialog; newBranchDialog; newTagDialog : cs:C1710.ui.onBoard

property changes; history; fetch; pull; push; open; \
stage; unstage; diffTool; commit; amend; fileStage; fileMore : cs:C1710.ui.button

property menu; unstaged; staged; commits; detailCommit : cs:C1710.ui.listbox

property diff; subject; description; parent; detailDiff; currentPath : cs:C1710.ui.input

property authorLabel; authorName; authorMail; stamp; shaLabe; sha; shaLabel; \
parentLabel; titleTop; title; titleBottom; emptyIndex; noCommitSelected; \
historyLoadingLabel; historySpinner : cs:C1710.ui.static

property authorAvatar : cs:C1710.ui.picture

property windowFrame : cs:C1710.ui.subform

property icons : Object

property _commitsVersion : Integer:=0

property _worker:="_gitLogRefresh"

// Commit-list auto-refresh interval while on the history page, in seconds
// (0 = disabled). Meant to become a per-repo setting later.
property _delay : Integer:=30

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.form:=cs:C1710.ui.form.new(This:C1470; Try(JSON Parse:C1218(File:C1566("/SOURCES/Forms/"+Current form name:C1298+"/form.4DForm").getText())))
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Menu bar
	var $menuHandle:=Formula:C1597(formMenuHandle).source
	
	// Get a standard file menu
	var $menuFile:=cs:C1710.ui.menu.new().file()
	
	// Enrich with custom items
	$menuFile.line(1)
	$menuFile.append("Diff"; "diff"; 2).shortcut("D").method($menuHandle)
	$menuFile.line(3)
	$menuFile.append(Localized string:C991("settings"); "settings"; 4).method($menuHandle)
	
	cs:C1710.ui.menuBar.new([\
		":xliff:CommonMenuFile"; $menuFile; \
		":xliff:CommonMenuEdit"; cs:C1710.ui.menu.new().edit()]).set()
	
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
	
	This:C1470.loading:=This:C1470.form.Group()
	This:C1470.historySpinner:=This:C1470.form.Static("historySpinner").addToGroup(This:C1470.loading)
	This:C1470.historyLoadingLabel:=This:C1470.form.Static("historyLoadingLabel").addToGroup(This:C1470.loading)
	
	// MARK:- [Constraints]
	This:C1470.form.constraints.new(This:C1470.historySpinner).centerHorizontally.with("commits")
	This:C1470.form.constraints.new(This:C1470.historyLoadingLabel).centerHorizontally.with("commits")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	// MARK: Form method
	If ($e.form)
		
		Case of 
				
				//______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				This:C1470.form.constraints.apply()
				
				//______________________________________________________
			: ($e.timer)
				
				This:C1470.form.update()
				This:C1470.updateCommits()
				
				If (This:C1470.form.page=This:C1470.pages.history)
					
					This:C1470._kickCommitsRefresh()
					This:C1470._scheduleCommitsRefresh()
					
				End if 
				
				//______________________________________________________
			: ($e.pageChange)
				
				If (This:C1470.form.page=This:C1470.pages.history)
					
					If (Form:C1466.page2Inited=Null:C1517)
						
						// FIXME: TURN AROUND - Force 4D to compute column widths
						LISTBOX SET COLUMN WIDTH:C833(*; This:C1470.commits.getColumnName(1); This:C1470.form.window.width-550)
						Form:C1466.page2Inited:=True:C214
						
					End if 
					
					This:C1470._updateHistoryLoadingIndicator()
					This:C1470.updateCommits()
					This:C1470._scheduleCommitsRefresh()
					
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
			
			var $menu:=cs:C1710.ui.menu.new()
			
			$menu.append(Localized string:C991("edit"); "open")
			$menu.append(Localized string:C991("showInFinder"); "show")
			
			If (Not:C34(This:C1470.isInIndex))
				
				$menu.line()\
					.append(Localized string:C991("discardChanges"); "discard")\
					.append(Localized string:C991("deleteLocalFile"); "delete")
				
			End if 
			
			If (Not:C34($menu.popup().selected))
				
				return 
				
			End if 
			
			This:C1470._handleMenus($menu.choice; This:C1470.isInIndex ? This:C1470.staged.item : This:C1470.unstaged.item)
			
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
			
			$git.execute("config --get remote.origin.url")
			
			If (Length:C16(String:C10($git.result))=0)  // No remote yet → offer to publish on GitHub
				
				This:C1470.CreateGithubRepository()
				
			Else 
				
				If ($git.branchPushNumber($git.workingBranch.name)=0)
					
					This:C1470.onDialogAlert({\
						main: Localized string:C991("nothingToCommit")})
					
				Else 
					
					$git.execute("config push.followTags")
					
					This:C1470.pushDialog.show({\
						tags: $git.result#"false"; \
						force: False:C215; \
						branch: $git.workingBranch.name\
						})
					
				End if 
				
			End if 
			
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
		: (This:C1470.commits.catch($e))
			
			This:C1470._commitsManager($e)
			//Case of 
			////______________________________________________________
			//: ($e.code=On Clicked)
			
			//  //If (Contextual click)
			
			//  //This._commitMenu()
			
			//  //End if 
			//  ////______________________________________________________
			//  //: ($e.code=On Selection Change)
			
			
			//  ////______________________________________________________
			//  //Else 
			
			//  //// A "Case of" statement should never omit "Else"
			
			//  ////______________________________________________________
			//  //            End case
			//  //If (Contextual click)
			
			//  //This._commitMenu()
			
			//  //End if 
			
			//  ////==============================================
			//  //: (This.commits.catch($e; On Selection Change))
			
			//  //This._commitsManager()
			
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
	
	This:C1470.pullDialog:=cs:C1710.ui.onBoard.new("embeddedDialogs"; "PULL")
	This:C1470.pullDialog.me:=This:C1470.pullDialog
	
	This:C1470.pushDialog:=cs:C1710.ui.onBoard.new("embeddedDialogs"; "PUSH")
	This:C1470.pushDialog.me:=This:C1470.pushDialog
	
	This:C1470.checkoutDialog:=cs:C1710.ui.onBoard.new("embeddedDialogs"; "CHECKOUT")
	This:C1470.checkoutDialog.me:=This:C1470.pushDialog
	
	This:C1470.newBranchDialog:=cs:C1710.ui.onBoard.new("embeddedDialogs"; "NEW BRANCH")
	This:C1470.newBranchDialog.me:=This:C1470.newBranchDialog
	This:C1470.newTagDialog:=cs:C1710.ui.onBoard.new("embeddedDialogs"; "NEW TAG")
	This:C1470.newTagDialog.me:=This:C1470.newTagDialog
	
	This:C1470._loadScheme()
	
	// Deferred to On Timer: building the commit list (graph/SVG/avatars) can block,
	// and must not delay this page's (local changes) first paint
	This:C1470.form.setTimer(-1)
	
	This:C1470.GoToPage(This:C1470.pages.local)
	This:C1470.update()
	
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
	This:C1470.fetch.title:=Localized string:C991("fetch")
	
	var $number:=$git.branchFetchNumber($git.workingBranch.name)
	If ($number>0)
		
		This:C1470.fetch.title+=" ("+String:C10($number)+")"
		
	End if 
	
	This:C1470.push.title:=Localized string:C991("push")
	
	$number:=$git.branchPushNumber($git.workingBranch.name)
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
			
			This:C1470.amend.bestSize()
			
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
	
	//If (This.form.page=This.pages.history)
	
	This:C1470.updateCommits()
	This:C1470._scheduleCommitsRefresh()
	
	//End if 
	
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
Function _pageManager($e : cs:C1710.ui.evt; $page : Integer)
	
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
	
	// iconAccessor: resolve "/RESOURCES/" against THIS component's own bundle,
	// not the host database (the default when embedded, breaks icons once installed)
	var $menu:=cs:C1710.ui.menu.new({embedded: True:C214; iconAccessor: Formula:C1597(SET MENU ITEM ICON:C984($1; $2; $3))})
	
	$menu.append(Localized string:C991("openInTerminal"); "terminal").icon("/RESOURCES/Images/Menus/terminal.svg")\
		.append(Localized string:C991("showOnDisk"); "show").icon("/RESOURCES/Images/Menus/disk.svg")\
		.line()\
		.append(Localized string:C991("viewOnGithub"); "github").icon("/RESOURCES/Images/Menus/gitHub.svg").enable($hasRemote)\
		.line()
	
	openWith($menu)
	
	If ($menu.popup(This:C1470.open).selected)
		
		GIT MENU($menu)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _stageUnstageManager($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
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
			
			var $menu:=cs:C1710.ui.menu.new()
			
			If ($sel.length=1)
				
				$menu.append(Localized string:C991("edit"); "open")
				
				If (["??"; " D"; "A "].indexOf($current.status)=-1)
					
					$menu.append(Localized string:C991("externalDiff"); "diffTool").shortcut("D")
					
				End if 
				
				$menu.line()
				
				If ([" D"].indexOf($current.status)=-1)
					
					$menu.append(Localized string:C991("showInFinder"); "show")
					$menu.append(Localized string:C991("deleteLocalFile"); "delete")
					
				End if 
				
				$menu.append(Localized string:C991("copyPath"); "copy")
				
				$menu.line()
				
			End if 
			
			If ($current#Null:C1517)
				
				If ($staged)
					
					$menu.append(Localized string:C991("unstage"); "unstage").shortcut("S"; 512)
					
				Else 
					
					$menu.append(Localized string:C991("stage"); "stage").shortcut("S"; 512)
					$menu.append(Localized string:C991("discardChanges"); "discard")
					
				End if 
				
				$menu.line()
				
			End if 
			
			Case of 
					
					//———————————————————————————————————————
				: ($staged)\
					 & (Form:C1466.staged.length>0)
					
					$menu.append(Localized string:C991("unstageAll"); "unStageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
				: (Form:C1466.unstaged.length>0)
					
					$menu.append(Localized string:C991("stageAll"); "stageAll").shortcut("S"; 512+2048)
					
					//———————————————————————————————————————
			End case 
			
			If ($current#Null:C1517)
				
				var $file : 4D:C1709.File:=This:C1470.Git.workspace.file($current.path)
				
				$menu.line()\
					.append(Localized string:C991("ignore"); cs:C1710.ui.menu.new()\
					.append(Replace string:C233(Localized string:C991("ignoreFile"); "{file}"; $file.fullName); "ignoreFile")\
					.append(Replace string:C233(Localized string:C991("ignoreAllExtensionFiles"); "{extension}"; $file.extension); "ignoreExtension")\
					.line()\
					.append(Localized string:C991("customPattern"); "ignoreCustom"))
				
			End if 
			
			If (Not:C34($menu.popup().selected))
				
				return 
				
			End if 
			
			This:C1470._handleMenus($menu.choice; $current)
			
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
	
	This:C1470.stage.setShortcut("s"; (0 ?+ Command key bit:K16:2)).enable((Form:C1466.unstaged#Null:C1517) && (Form:C1466.unstaged.length>0))
	
	If (This:C1470.staged.items=Null:C1517) || (This:C1470.staged.items.length=0)
		
		This:C1470.unstage.title:=Localized string:C991("unstageAll")
		
	Else 
		
		This:C1470.unstage.title:=Localized string:C991("unstage")
		
	End if 
	
	This:C1470.unstage.setShortcut("u"; (0 ?+ Command key bit:K16:2)).enable((Form:C1466.staged#Null:C1517) && (Form:C1466.staged.length>0))
	
	This:C1470.emptyIndex.show((Form:C1466.staged=Null:C1517) || (Form:C1466.staged.length=0))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Contextual menu on the selected commit.
Function _commitMenu()
	
	var $commit:=This:C1470.commits.item
	
	If ($commit=Null:C1517)
		
		return 
		
	End if 
	
	var $sha:=String:C10($commit.fingerprint.long)
	var $menu:=cs:C1710.ui.menu.new()\
		.append(Localized string:C991("newBranch"); "createBranch")\
		.append(Localized string:C991("newTag"); "createTag")\
		.append(Localized string:C991("createPatch"); "createPatch")\
		.line()\
		.append(Localized string:C991("copySha"); "copySha")
	
	If (Not:C34($menu.popup().selected))
		
		return 
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($menu.choice="createBranch")
			
			This:C1470.newBranchDialog.show({\
				at: $sha; \
				label: $commit.title; \
				branch: ""; \
				checkout: True:C214; \
				stash: This:C1470.checkout.stash; \
				noChange: This:C1470.checkout.noChange; \
				discard: This:C1470.checkout.discard\
				})
			
			//______________________________________________________
		: ($menu.choice="createTag")
			
			This:C1470.newTagDialog.show({at: $sha; tag: ""})
			
			//______________________________________________________
		: ($menu.choice="createPatch")
			
			This:C1470._createPatch($commit)
			
			//______________________________________________________
		: ($menu.choice="copySha")
			
			SET TEXT TO PASTEBOARD:C523($sha)
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Saves the selected commit as an mbox patch.
Function _createPatch($commit : Object)
	
	var $git:=This:C1470.Git
	var $sha : Text:=String:C10($commit.fingerprint.long)
	var $worker:=4D:C1709.SystemWorker.new($git.command+"format-patch -1 --stdout "+$sha; {currentDirectory: $git.workspace; dataType: "text"})
	
	If ($worker=Null:C1517)
		
		return 
		
	End if 
	
	$worker.wait()
	
	var $patch : Text:=String:C10($worker.response)
	
	If (Length:C16($patch)=0)
		
		return 
		
	End if 
	
	var $dir : Text:=String:C10(Storage:C1525.gitPatchFolder.directory)
	
	If (Length:C16($dir)=0)
		
		$dir:=Folder:C1567(fk documents folder:K87:21).platformPath
		
	End if 
	
	var $name : Text:=$commit.fingerprint.short+"-"+cs:C1710.rgx.regex.new($commit.title; "[^\\w.-]+").substitute("-")
	$name:=Substring:C12($name; 1; 60)+".patch"
	$name:=Select document:C905($dir+$name; "save patch as:"; ".patch"; File name entry:K24:17)
	
	If (OK=0)
		
		return 
		
	End if 
	
	var $file : 4D:C1709.File:=File:C1566(DOCUMENT; fk platform path:K87:2)
	
	Use (Storage:C1525)
		
		Storage:C1525.gitPatchFolder:=Storage:C1525.gitPatchFolder || New shared object:C1526
		
	End use 
	
	Use (Storage:C1525.gitPatchFolder)
		
		Storage:C1525.gitPatchFolder.directory:=$file.parent.platformPath
		
	End use 
	
	$file.setText($patch)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _commitsManager($e : cs:C1710.ui.evt)
	
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
		
	Else 
		
		If (Contextual click:C713)
			
			This:C1470._commitMenu()
			
		End if 
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
								
								$code:=Try($tgt.getText())
								
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
	
	// Defensive: the regex component crashes ("Object or Collection Expected") if
	// its target isn't Text/File/BLOB — bail out rather than propagate a crash
	If (Value type:C1509($git.result)#Is text:K8:3)
		
		return 
		
	End if 
	
	// MARK: Remove tokens
	var $code:=cs:C1710.rgx.regex.new($git.result; "(?m-si):[CK]:?\\d+(?::\\d+)?").substitute("")
	
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
	
	// The GitHub CLI (embedded) is required to create the repository
	If (Not:C34($gh.available))
		
		This:C1470.onDialogAlert({main: Localized string:C991("githubCliNotAvailable")})
		return 
		
	End if 
	
	var $name : Text:=$git.workspace.name
	
	// Ask the user before creating anything on their GitHub account
	var $confirm:={main: Replace string:C233(Localized string:C991("createGithubRepoConfirm"); "{name}"; $name)}
	This:C1470.onDialogConfirm($confirm)
	
	If (Not:C34(Bool:C1537($confirm.action)))
		
		return 
		
	End if 
	
	// Request access (device-flow login) then create the private repository
	If (Not:C34($gh.login()))
		
		This:C1470.onDialogAlert({main: $gh.lastError || Localized string:C991("githubAuthorizationFailed")})
		return 
		
	End if 
	
	var $remote : Text:=$gh.createRepo($name; True:C214)  // private
	
	If (Length:C16($remote)=0)
		
		This:C1470.onDialogAlert({main: $gh.lastError || Localized string:C991("githubRepoCreationFailed")})
		return 
		
	End if 
	
	// Make sure we are on a "main" branch and wire the created remote
	$git.execute("branch -M main")
	$git.execute("remote add origin "+$remote)
	
	// Ensure at least a README so the first push isn't empty
	var $file:=File:C1566("/PACKAGE/README.md"; *)
	
	If (Not:C34($file.exists))
		
		$file.setText("# Welcome to "+$name)
		
	End if 
	
	$git.add("README.md")
	$git.add(".gitignore")
	$git.add(".gitattributes")
	$git.commit()
	
	// Push and set the upstream
	If ($git.execute("push -u origin main"))
		
		This:C1470.onActivate()
		
	Else 
		
		This:C1470.onDialogAlert({main: $git.error || Localized string:C991("pushFailed")})
		
	End if 
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Show the cached commit list instantly, then refresh it in the background
	// (git log runs in a worker, so the UI never freezes). See _gitLogRefresh.
Function updateCommits()
	
	var $cache:=cs:C1710._commitsCache.me
	
	// Rebuild only when the cached log is newer than the one already displayed
	If ($cache.version>This:C1470._commitsVersion)
		
		This:C1470._buildCommits($cache.builtCommits)
		This:C1470._commitsVersion:=$cache.version
		
	End if 
	
	This:C1470._kickCommitsRefresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Show a spinner + message on the history page while the FIRST commit list build
	// hasn't completed yet (avoids the "nothing is happening" impression on click)
Function _updateHistoryLoadingIndicator()
	
	This:C1470.loading.show(This:C1470._commitsVersion=0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Launch the background git log worker (unless one is already running)
Function _kickCommitsRefresh()
	
	var $cache:=cs:C1710._commitsCache.me
	
	// A "loading" flag stuck for too long (e.g. the dialog that kicked it was
	// closed before the worker finished) must not block refreshes forever
	If ($cache.loading) && (Not:C34($cache.isLoadingStale()))
		
		return 
		
	End if 
	
	$cache.setLoading()
	CALL WORKER:C1389(This:C1470._worker; Formula:C1597(_gitLogRefresh); {caller: Current form window:C827; darkScheme: This:C1470.form.darkScheme})
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// (Re)arm the periodic auto-refresh while on the history page (self-re-arming
	// one-shot timer; _delay is in seconds, 0 disables it)
Function _scheduleCommitsRefresh()
	
	If (This:C1470._delay>0)
		
		This:C1470.form.setTimer(-(This:C1470._delay*60))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Called (via CALL FORM) once the background git log has refreshed the cache
Function onCommitsRefreshed()
	
	var $cache:=cs:C1710._commitsCache.me
	
	If ($cache.version>This:C1470._commitsVersion)
		
		This:C1470._buildCommits($cache.builtCommits)
		This:C1470._commitsVersion:=$cache.version
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the pre-built commit list (graph/labels already rendered off-process
	// in the worker; see _gitLogRefresh / _commitsBuilder) and update the UI
Function _buildCommits($commits : Collection)
	
	This:C1470.loading.hide()
	
	// Deep-copy out of the cache's SHARED collection: the UI freely mutates
	// individual commit properties (label swap on selection, etc.), which a
	// shared object only allows inside a "Use" block
	Form:C1466.commits:=$commits.copy()
	
	// Restore selection, if any
	If (This:C1470.commits.item#Null:C1517)
		
		var $c : Collection:=Form:C1466.commits.indices("fingerprint.short = :1 "; This:C1470.commits.item.fingerprint.short)
		
		If ($c.length>0)
			
			This:C1470.commits.select($c[0]+1)
			
		End if 
	End if 
	
	This:C1470.form.update()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _handleMenus($what : Text; $data : Object)
	
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
	
	return cs:C1710._gravatars.me.avatar($mail)
	
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
	var $file : 4D:C1709.File
	var $dark:=This:C1470.form.darkScheme ? This:C1470.form._darkExtension : ""
	
	// tag/stash/github icons moved to _commitsBuilder (commit-graph labels, built off-process)
	For each ($key; ["Add"; "Remove"; "Edit"; "Rename"])
		
		$file:=File:C1566("/RESOURCES/Images/Status/"+$key+$dark+".svg")
		READ PICTURE FILE:C678($file.platformPath; $icon)
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
	