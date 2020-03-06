  // ----------------------------------------------------
  // Form method : GIT_LAB
  // ID[65871C4C423A4C31913CD88C79275F61]
  // Created 4-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		  // Widgets definition
		Form:C1466.$:=New object:C1471(\
			"stage";button ("stage");\
			"unstage";button ("unstage");\
			"commit";button ("commit");\
			"menu";listbox ("menu");\
			"toStage";listbox ("unstaged");\
			"toComit";listbox ("staged");\
			"diff";widget ("diff");\
			"subject";widget ("commitSubject");\
			"description";widget ("commitDecription");\
			"commitment";widget ("commit@")\
			)
		
		Form:C1466.$.menu.select(1)
		
		Form:C1466.$.toStage.setScrollbar(0;2)
		Form:C1466.$.toComit.setScrollbar(0;2)
		
		Form:C1466.$.stage.bestSize(Align right:K42:4).disable()
		Form:C1466.$.unstage.bestSize(Align right:K42:4).disable()
		Form:C1466.$.commit.bestSize(Align right:K42:4).disable()
		
		Form:C1466.ƒ.update()
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Case of 
				
				  //———————————————————————————————————
			: (FORM Get current page:C276=1)  // Changes
				
				$o:=Form:C1466.git
				
				  // Update file lists
				If ($o.changes.length>0)
					
					Form:C1466.unstaged:=$o.changes.query("status IN :1";New collection:C1472("?@";"@M";"@D")).orderBy("path")
					Form:C1466.staged:=$o.changes.query("status = :1";"@ ").orderBy("path")
					
				Else 
					
					Form:C1466.unstaged.clear()
					Form:C1466.$.stage.disable()
					
					Form:C1466.staged.clear()
					Form:C1466.$.unstage.disable()
					
				End if 
				
				  // Update commit panel
				If (Form:C1466.staged.length>0)
					
					Form:C1466.$.commitment.enable()
					Form:C1466.$.commit.setEnabled(Bool:C1537(Form:C1466.amend) | Bool:C1537(Length:C16(Form:C1466.commitSubject)))
					
				Else 
					
					Form:C1466.amend:=False:C215
					Form:C1466.$.commitment.disable()
					Form:C1466.commitSubject:=""
					
				End if 
				
				Form:C1466.ƒ.refresh()
				
				  //———————————————————————————————————
			: (FORM Get current page:C276=2)  // Commits
				
				  //
				
				  //———————————————————————————————————
		End case 
		
		  //______________________________________________________
	: ($event.code=On Page Change:K2:54)
		
		Form:C1466.ƒ.update()
		
		  //______________________________________________________
	: ($event.code=On Activate:K2:9)
		
		  // Get status
		$o:=Form:C1466.git.status()
		
		  // Update menu label
		Form:C1466.menu[0].label:=Choose:C955($o.changes.length>0;"Changes ("+String:C10($o.changes.length)+")";"Changes")
		Form:C1466.menu:=Form:C1466.menu
		
		  // Update UI
		Form:C1466.ƒ.update()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 