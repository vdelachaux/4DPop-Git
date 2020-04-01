  // ----------------------------------------------------
  // Form method : GIT_LAB
  // ID[65871C4C423A4C31913CD88C79275F61]
  // Created 4-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_BLOB:C604($x)
C_LONGINT:C283($indx)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($event;$form;$git;$o;$oList)
C_COLLECTION:C1488($c)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

If (Form:C1466.$=Null:C1517)
	
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
		"selector";list (Form:C1466.selector);\
		"remote";group ("fetch;pull;push")\
		)
	
	Form:C1466.$:=$form
	
Else 
	
	$form:=Form:C1466.$
	
End if 

$git:=Form:C1466.git

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
		
		  // Apply template
		For each ($t;New collection:C1472("fetch";"pull";"push";"open";"stageAll"))
			
			$form[$t].setFormat(";file:Images/"+Form:C1466.template+$t+".png")
			
		End for each 
		
/*_______Adapt UI to localization______*/
		$form.remote.distributeHorizontally(New object:C1471(\
			"start";10;\
			"gap";10;\
			"minWidth";50))
		
		$form.stage.bestSize(Align right:K42:4).disable()
		$form.unstage.bestSize(Align right:K42:4).disable()
		$form.commit.bestSize(Align right:K42:4).disable()
		$form.open.bestSize(Align right:K42:4)
		
/*_________________WIP_________________*/
		$form.remote.setVisible($git.debug)
		
		  // Update UI
		Form:C1466.ƒ.refresh()
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Case of 
				
				  //______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				  // Update file lists
				If ($git.changes.length>0)
					
					Form:C1466.unstaged:=$git.changes.query("status IN :1";New collection:C1472("?@";"@M";"@D"))
					Form:C1466.staged:=$git.changes.query("status = :1";"@ ")
					
					  // Restore selection
					Case of 
							
							  //———————————————————————————————
						: (Form:C1466.currentUnstaged#Null:C1517)\
							 & (Form:C1466.unstaged.length>0)
							
							$indx:=Form:C1466.unstaged.extract("path").indexOf(Form:C1466.currentUnstaged.path)
							
							If ($indx=-1)
								
								$form.toStage.deselect()
								
							Else 
								
								$form.toStage.reveal($indx+1)
								
							End if 
							
							  //———————————————————————————————
						: (Form:C1466.currentStaged#Null:C1517)\
							 & (Form:C1466.staged.length>0)
							
							  // Restore selection
							$indx:=Form:C1466.staged.extract("path").indexOf(Form:C1466.currentStaged.path)
							
							If ($indx=-1)
								
								$form.toComit.deselect()
								
							Else 
								
								$form.toComit.reveal($indx+1)
								
							End if 
							
							  //———————————————————————————————
						Else 
							
							$form.toStage.deselect()
							$form.toComit.deselect()
							
							  //———————————————————————————————
					End case 
					
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
				
				  //———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				$o:=Form:C1466.$.selector.getParameter("data";Null:C1517;Is object:K8:27)
				
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
				
				GITLAB ("commitDetail")
				
				  //______________________________________________________
			Else 
				
				  // A "Case of" statement should never omit "Else"
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($event.code=On Page Change:K2:54)
		
		Case of 
				
				  //______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				  //———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				OBJECT SET VISIBLE:C603(*;"detail_@";False:C215)
				
				  // Update commit list
				Form:C1466.commits.clear()
				
				$git.execute("log --abbrev-commit --format=%s,%an,%h,%aI,%H,%p,%P,%ae")
				
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
				For each ($t;Split string:C1554($git.result;"\n";sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t;",")
					
					If ($c.length>=8)
						
						$o:=New object:C1471(\
							"title";$c[0];\
							"author";New object:C1471("name";$c[1];"mail";$c[7]);\
							"stamp";String:C10(Date:C102($c[3]))+" at "+String:C10(Time:C179($c[3])+?00:00:00?);\
							"fingerprint";New object:C1471("short";$c[2];"long";$c[4]);\
							"parent";New object:C1471("short";$c[5];"long";$c[6]))
						
						Form:C1466.commits.push($o)
						
					End if 
				End for each 
		End case 
		
		  // Update UI
		Form:C1466.ƒ.refresh()
		
		  //______________________________________________________
	: ($event.code=On Activate:K2:9)
		
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
		$oList:=list ($form.selector.getByReference(-21).list).empty()
		
		$git.branch()
		
		If ($git.branches.length>0)
			
			For each ($o;$git.branches)
				
				$oList.append($o.name).parameter("data";JSON Stringify:C1217($o))
				
				If ($o.current)
					
					$oList.icon(Form:C1466.icons.checked)
					
				Else 
					
					$oList.icon(Choose:C955($o.name="master";Form:C1466.icons.master;Form:C1466.icons.branching))
					
				End if 
			End for each 
		End if 
		
/*_______________________Remote list_______________________*/
		$oList:=$oList.setList($form.selector.getByReference(-22).list).empty()
		
		$git.getRemotes()
		
		If ($git.remotes.length>0)
			
			For each ($o;$git.remotes)
				
				$oList.append($o.name).parameter("data";JSON Stringify:C1217($o)).icon(Form:C1466.icons[Choose:C955(Position:C15("github.com";$o.url)>0;"github";"gitlab")])
				
			End for each 
		End if 
		
/*_______________________tag list_______________________*/
		$oList:=$oList.setList($form.selector.getByReference(-23).list).empty()
		
		$git.getTags()
		
		If ($git.tags.length>0)
			
			For each ($t;$git.tags)
				
				$oList.append($t).parameter("tag";$t).icon(Form:C1466.icons.tag)
				
			End for each 
		End if 
		
/*_______________________staches list_______________________*/
		$oList:=$oList.setList($form.selector.getByReference(-24).list).empty()
		
		$git.stash()
		
		If ($git.stashes.length>0)
			
			For each ($o;$git.stashes)
				
				$oList.append($o.message).parameter("data";JSON Stringify:C1217($o)).icon(Form:C1466.icons.stash)
				
			End for each 
		End if 
		
		Form:C1466.ƒ.updateUI()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 