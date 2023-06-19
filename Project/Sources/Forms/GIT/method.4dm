// ----------------------------------------------------
// Form method : GIT_LAB
// ID[65871C4C423A4C31913CD88C79275F61]
// Created 4-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
var $t : Text
var $indx : Integer
var $e; $ƒ; $list; $o : Object
var $git : cs:C1710.Git

Form:C1466.$:=Form:C1466.$ || New object:C1471(\
"stage"; _o_button("stage"); \
"unstage"; _o_button("unstage"); \
"menu"; _o_listbox("menu"); \
"toStage"; _o_listbox("unstaged"); \
"toComit"; _o_listbox("staged"); \
"diff"; _o_widget("diff"); \
"diffTool"; _o_button("diffTool"); \
"stageAll"; _o_button("stageAll"); \
"subject"; _o_widget("commitSubject"); \
"description"; _o_widget("commitDecription"); \
"commit"; _o_button("commit"); \
"amend"; _o_button("comitAmend"); \
"commitment"; _o_widget("commit@"); \
"commits"; _o_listbox("commits"); \
"fetch"; _o_button("fetch"); \
"pull"; _o_button("pull"); \
"push"; _o_button("push"); \
"open"; _o_button("open"); \
"selector"; _o_list(Form:C1466.selector); \
"remote"; _o_group("fetch;pull;push"); \
"detailCommit"; _o_listbox("detail_list")\
)

$ƒ:=Form:C1466.$
$git:=Form:C1466.git
$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
/* Default is  changes page */
		$ƒ.menu.select(1)
		FORM GOTO PAGE:C247(1)
		
		// Trick
		$ƒ.toStage.setScrollbar(0; 2)
		$ƒ.toComit.setScrollbar(0; 2)
		$ƒ.commits.setScrollbar(0; 2)
		$ƒ.detailCommit.setScrollbar(0; 2)
		
		
/*_______Adapt UI to localization______*/
		$ƒ.remote.distributeHorizontally(New object:C1471(\
			"start"; 10; \
			"gap"; 10; \
			"minWidth"; 50))
		
		$ƒ.stage.bestSize(Align right:K42:4).disable()
		$ƒ.unstage.bestSize(Align right:K42:4).disable()
		$ƒ.commit.bestSize(Align right:K42:4).disable()
		$ƒ.open.bestSize(Align right:K42:4)
		
		// Update UI
		Form:C1466.ƒ.refresh()
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		//
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Case of 
				
				//______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				// Update file lists
				If ($git.changes.length>0)
					
					Form:C1466.unstaged:=$git.changes.query("status IN :1"; New collection:C1472("?@"; "@M"; "@D"))
					Form:C1466.staged:=$git.changes.query("status = :1"; "@ ")
					
					// Restore selection
					Case of 
							
							//———————————————————————————————
						: (Form:C1466.currentUnstaged#Null:C1517)\
							 & (Form:C1466.unstaged.length>0)
							
							$indx:=Form:C1466.unstaged.extract("path").indexOf(Form:C1466.currentUnstaged.path)
							
							If ($indx=-1)
								
								$ƒ.toStage.deselect()
								
							Else 
								
								$ƒ.toStage.reveal($indx+1)
								
							End if 
							
							//———————————————————————————————
						: (Form:C1466.currentStaged#Null:C1517)\
							 & (Form:C1466.staged.length>0)
							
							// Restore selection
							$indx:=Form:C1466.staged.extract("path").indexOf(Form:C1466.currentStaged.path)
							
							If ($indx=-1)
								
								$ƒ.toComit.deselect()
								
							Else 
								
								$ƒ.toComit.reveal($indx+1)
								
							End if 
							
							//———————————————————————————————
						Else 
							
							$ƒ.toStage.deselect()
							$ƒ.toComit.deselect()
							
							//———————————————————————————————
					End case 
					
				Else 
					
					Form:C1466.staged.clear()
					$ƒ.unstage.disable()
					
				End if 
				
				// Update commit panel
				If (Form:C1466.staged.length>0)
					
					$ƒ.commitment.enable()
					$ƒ.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
					
				Else 
					
					Form:C1466.amend:=False:C215
					$ƒ.commitment.disable()
					Form:C1466.commitSubject:=""
					
				End if 
				
				//———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				$o:=Form:C1466.$.selector.getParameter("data"; Null:C1517; Is object:K8:27)
				
				If ($o#Null:C1517)
					
					$indx:=Form:C1466.commits.extract("fingerprint.short").indexOf(String:C10($o.ref))
					
					If ($indx#-1)
						
						Form:C1466.$.commits.reveal($indx+1)
						Form:C1466.$.commits.focus()
						
					Else 
						
						$indx:=Form:C1466.commits.indexOf(Form:C1466.commitsCurrent)
						
						If ($indx#-1)
							
							Form:C1466.$.commits.reveal($indx+1)
							Form:C1466.$.commits.focus()
							
						End if 
					End if 
					
				Else 
					
					$indx:=Form:C1466.commits.indexOf(Form:C1466.commitsCurrent)
					
					If ($indx#-1)
						
						Form:C1466.$.commits.reveal($indx+1)
						Form:C1466.$.commits.focus()
						
					End if 
				End if 
				
				GIT DISPLAY COMMIT
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		Case of 
				
				//______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				//
				
				//———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				GIT COMMIT LIST
				
				//----------------------------------------
		End case 
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		// Get status
		$git.status()
		
		// Update UI
		Form:C1466.ƒ.refresh()
		
		// Update menu label
		If ($git.changes.length>0)
			
			Form:C1466.menu[0].label:="Changes ("+String:C10($git.changes.length)+")"
			
		Else 
			
			Form:C1466.menu[0].label:="Changes"
			
			Form:C1466.unstaged.clear()
			Form:C1466.staged.clear()
			
		End if 
		
		// Touch
		Form:C1466.menu:=Form:C1466.menu
		
/*_______________________Branch list_______________________*/
		$list:=_o_list($ƒ.selector.getByReference(-21).list).empty()
		
		$git.branch()
		
		If ($git.branches.length>0)
			
			For each ($o; $git.branches)
				
				$list.append($o.name).parameter("data"; JSON Stringify:C1217($o))
				
				If ($o.current)
					
					$list.icon(Form:C1466.icons.checked)
					
				Else 
					
					$list.icon(Choose:C955($o.name="master"; Form:C1466.icons.master; Form:C1466.icons.branch))
					
				End if 
			End for each 
		End if 
		
/*_______________________Remote list_______________________*/
		$list:=$list.setList($ƒ.selector.getByReference(-22).list).empty()
		
		$git.updateRemotes()
		
		If ($git.remotes.length>0)
			
			For each ($o; $git.remotes)
				
				$list.append($o.name).parameter("data"; JSON Stringify:C1217($o)).icon(Form:C1466.icons[Choose:C955(Position:C15("github.com"; $o.url)>0; "github"; "gitlab")])
				
			End for each 
		End if 
		
/*_______________________tag list_______________________*/
		$list:=$list.setList($ƒ.selector.getByReference(-23).list).empty()
		
		$git.updateTags()
		
		If ($git.tags.length>0)
			
			For each ($t; $git.tags)
				
				$list.append($t).parameter("tag"; $t).icon(Form:C1466.icons.tag)
				
			End for each 
		End if 
		
/*_______________________staches list_______________________*/
		$list:=$list.setList($ƒ.selector.getByReference(-24).list).empty()
		
		$git.stash()
		
		If ($git.stashes.length>0)
			
			For each ($o; $git.stashes)
				
				$list.append($o.message).parameter("data"; JSON Stringify:C1217($o)).icon(Form:C1466.icons.stash)
				
			End for each 
		End if 
		
		Form:C1466.ƒ.updateUI()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 