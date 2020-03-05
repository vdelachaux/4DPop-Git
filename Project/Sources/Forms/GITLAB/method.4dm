  // ----------------------------------------------------
  // Form method : GIT_LAB
  // ID[65871C4C423A4C31913CD88C79275F61]
  // Created 4-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_PICTURE:C286($p)
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		Form:C1466.ƒ:=New object:C1471(\
			"stage";button ("stage");\
			"unstage";button ("unstage");\
			"commit";button ("commit");\
			"switch";listbox ("switch");\
			"toStage";listbox ("unstaged");\
			"toComit";listbox ("staged");\
			"diff";widget ("diff")\
			)
		
		Form:C1466.project:=File:C1566(Structure file:C489(*);fk platform path:K87:2)
		
		Form:C1466.git:=git ()
		
		Form:C1466.redraw:=Formula:C1597(SET TIMER:C645(-1))
		Form:C1466.refresh:=Formula:C1597(UPDATE )
		
		Form:C1466.unstaged:=New collection:C1472
		Form:C1466.staged:=New collection:C1472
		
		Form:C1466.switch:=New collection:C1472(\
			New object:C1471("label";"Changes");\
			New object:C1471("label";"All commits")\
			)
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/changes.png").platformPath;$p)
		TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
		Form:C1466.switch[0].icon:=$p
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/commits.png").platformPath;$p)
		TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
		Form:C1466.switch[1].icon:=$p
		
		Form:C1466.ƒ.toStage.setScrollbar(0;2)
		Form:C1466.ƒ.toComit.setScrollbar(0;2)
		Form:C1466.ƒ.switch.select(1)
		Form:C1466.ƒ.stage.bestSize(Align right:K42:4).disable()
		Form:C1466.ƒ.unstage.bestSize(Align right:K42:4).disable()
		Form:C1466.ƒ.commit.bestSize(Align right:K42:4).disable()
		
		Form:C1466.redraw()
		
		  //______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		Case of 
				
				  //______________________________________________________
			: (FORM Get current page:C276=1)  // Changes
				
				$o:=Form:C1466.git
				
				If ($o.changes.length>0)
					
					Form:C1466.unstaged:=$o.changes.query("status IN :1";New collection:C1472("?@";"@M"))
					Form:C1466.staged:=$o.changes.query("status = :1";"@ ")
					
				Else 
					
					Form:C1466.unstaged.clear()
					Form:C1466.staged.clear()
					
					Form:C1466.ƒ.stage.disable()
					Form:C1466.ƒ.unstage.disable()
					
				End if 
				
				Form:C1466.ƒ.commit.setEnabled(Bool:C1537(Form:C1466.staged.length))
				
				Form:C1466.refresh()
				
				  //______________________________________________________
			: (FORM Get current page:C276=2)  // Commits
				
				  //______________________________________________________
			Else 
				
				  // A "Case of" statement should never omit "Else"
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	: ($event.code=On Page Change:K2:54)
		
		Form:C1466.redraw()
		
		  //______________________________________________________
	: ($event.code=On Activate:K2:9)
		
		$o:=Form:C1466.git.status()
		
		If ($o.changes.length>0)
			
			Form:C1466.switch[0].label:="Changes ("+String:C10($o.changes.length)+")"
			Form:C1466.switch:=Form:C1466.switch
			
		Else 
			
			  // A "If" statement should never omit "Else"
			
		End if 
		
		Form:C1466.refresh()
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 