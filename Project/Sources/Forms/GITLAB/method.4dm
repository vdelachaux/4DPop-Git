  // ----------------------------------------------------
  // Form method : GIT_LAB
  // ID[65871C4C423A4C31913CD88C79275F61]
  // Created 4-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_BOOLEAN:C305($b)
C_LONGINT:C283($index;$list)
C_TEXT:C284($t;$tLabel)
C_OBJECT:C1216($event;$form;$o;$oList)
C_COLLECTION:C1488($c)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

If (($event.code=On Load:K2:1))
	
	  // Widgets definition
	$form:=New object:C1471(\
		"stage";button ("stage");\
		"unstage";button ("unstage");\
		"menu";listbox ("menu");\
		"toStage";listbox ("unstaged");\
		"toComit";listbox ("staged");\
		"diff";widget ("diff");\
		"diffTool";button ("diffTool");\
		"stageAll";button ("stageAll");\
		"subject";widget ("commitSubject");\
		"description";widget ("commitDecription");\
		"commit";button ("commit");\
		"amend";button ("comitAmend");\
		"commitment";widget ("commit@");\
		"commits";listbox ("commits");\
		"fetch";button ("fetch");\
		"pull";button ("pull");\
		"push";button ("push");\
		"open";button ("open");\
		"selector";list (Form:C1466.selector)\
		)
	
	Form:C1466.$:=$form
	
Else 
	
	$form:=Form:C1466.$
	
End if 

$oGit:=Form:C1466.git

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
/* Default is  changes page */
		$form.menu.select(1)
		FORM GOTO PAGE:C247(1)
		
		  // Trick
		$form.toStage.setScrollbar(0;2)
		$form.toComit.setScrollbar(0;2)
		$form.commits.setScrollbar(0;2)
		
/* Apply template */
		For each ($t;New collection:C1472("fetch";"pull";"push";"open";"stageAll"))
			
			$form[$t].setFormat(";file:Images/"+Form:C1466.template+$t+".png")
			
		End for each 
		
/* Adapt UI to localization */
		group ("fetch;pull;push").distributeHorizontally(New object:C1471(\
			"start";10;\
			"gap";10;\
			"minWidth";50))
		
		$form.stage.bestSize(Align right:K42:4).disable()
		$form.unstage.bestSize(Align right:K42:4).disable()
		$form.commit.bestSize(Align right:K42:4).disable()
		$form.open.bestSize(Align right:K42:4)
		
		Form:C1466.ƒ.update()
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
/* Branch list */
		$oGit.branch()
		$oList:=list ($form.selector.getByReference(-21).list).empty()
		
		If ($oGit.branches.length>0)
			
			For each ($o;$oGit.branches)
				
				$oList.append($o.name).parameter("ref";$o.ref)
				If ($o.current)
					
					$oList.icon(Form:C1466.icons.checked)
					
				End if 
				
			End for each 
			
		Else 
			
			  // ??
			
		End if 
		
/* Remote list */
		$oGit.remote()
		$oList:=$oList.setList($form.selector.getByReference(-22).list).empty()
		
		If ($oGit.remotes.length>0)
			
			For each ($o;$oGit.remotes)
				
				$oList.append($o.name).parameter("url";$o.url).icon(Form:C1466.icons[Choose:C955(Position:C15("github.com";$o.url)>0;"github";"gitlab")])
				
			End for each 
			
		Else 
			
			  // #TO_DO
			
		End if 
		
/* tag list */
		$oGit.tag()
		$oList:=$oList.setList($form.selector.getByReference(-23).list).empty()
		
		If ($oGit.tags.length>0)
			
			For each ($t;$oGit.tags)
				
				$oList.append($t).parameter("tag";$t).icon(Form:C1466.icons.tag)
				
			End for each 
			
		Else 
			
			  // #TO_DO
			
		End if 
		
		
		Case of 
				
				  //______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				  // Update file lists
				If ($oGit.changes.length>0)
					
					Form:C1466.unstaged:=$oGit.changes.query("status IN :1";New collection:C1472("?@";"@M";"@D"))
					Form:C1466.staged:=$oGit.changes.query("status = :1";"@ ")
					
				Else 
					
					Form:C1466.staged.clear()
					$form.unstage.disable()
					
				End if 
				
				  // Update commit panel
				If (Form:C1466.staged.length>0)
					
					$form.commitment.enable()
					$form.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
					
				Else 
					
					Form:C1466.amend:=False:C215
					$form.commitment.disable()
					Form:C1466.commitSubject:=""
					
				End if 
				
				$form.toStage.deselect()
				$form.toComit.deselect()
				
				$form.diff.hide()
				
				Form:C1466.ƒ.refresh()
				
				  //———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				  // Update commit list
				Form:C1466.commits:=New collection:C1472
				
				$oGit.execute("log --abbrev-commit --format=%s,%an,%h,%aI")  // Message, author, ref, time
				
				  // One commit per line
				For each ($t;Split string:C1554($oGit.result;"\n";sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t;",")
					
					If ($c.length>=4)
						
						Form:C1466.commits.push(New object:C1471(\
							"title";$c[0];\
							"author";$c[1];\
							"ref";$c[2];\
							"stamp";String:C10(Date:C102($c[3]))+" at "+String:C10(Time:C179($c[3])+?00:00:00?)))
						
					End if 
				End for each 
				
				  //______________________________________________________
			Else 
				
				  // A "Case of" statement should never omit "Else"
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($event.code=On Page Change:K2:54)
		
		Form:C1466.ƒ.update()
		
		  //______________________________________________________
	: ($event.code=On Activate:K2:9)
		
		  // Get status
		$oGit.status()
		
		  // Update UI
		Form:C1466.ƒ.update()
		
		  // Update menu label
		If ($oGit.changes.length>0)
			
			Form:C1466.menu[0].label:="Changes ("+String:C10($oGit.changes.length)+")"
			
		Else 
			
			Form:C1466.menu[0].label:="Changes"
			
			Form:C1466.unstaged.clear()
			Form:C1466.staged.clear()
			
		End if 
		
		  // Touch
		Form:C1466.menu:=Form:C1466.menu
		
		  // GITLAB_EXECUTE(new object("action";"fetch"))
		
		Form:C1466.ƒ.refresh()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 