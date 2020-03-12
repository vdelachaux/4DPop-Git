//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GITLAB_EXECUTE
  // ID[DBC17A31DBA047DEBC0BEA1F2BADF817]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_VARIANT:C1683($1)

C_TEXT:C284($t_action)
C_OBJECT:C1216($o;$o_IN)

If (False:C215)
	C_VARIANT:C1683(GITLAB_EXECUTE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // <NO PARAMETERS REQUIRED>

If (Value type:C1509($1)=Is object:K8:27)
	
	$o_IN:=$1
	$t_action:=String:C10($o_IN.action)
	
Else 
	
	$t_action:=String:C10($1)
	
End if 

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($t_action="stage")
		
		For each ($o;Form:C1466.selectedUnstaged)
			
			Form:C1466.git.add($o.path)
			
		End for each 
		
		  //______________________________________________________
	: ($t_action="stageAll")
		
		Form:C1466.git.stageAll()
		
		  //______________________________________________________
	: ($t_action="unstage")
		
		For each ($o;Form:C1466.selectedStaged)
			
			Form:C1466.git.unstage($o.path)
			
		End for each 
		
		  //______________________________________________________
	: ($t_action="discard")
		
		CONFIRM:C162(Get localized string:C991("doYouWantToDiscardAllChangesInTheSelectedFiles");Get localized string:C991("discard"))
		
		If (Bool:C1537(OK))
			
			For each ($o;Form:C1466.selectedUnstaged)
				
				Form:C1466.git.checkout($o.path)
				
			End for each 
			
		End if 
		
		  //______________________________________________________
	: ($t_action="commit")
		
		Form:C1466.git.commit($o_IN.message;Form:C1466.amend)
		
		  //______________________________________________________
	: ($t_action="fetch")
		
		Form:C1466.git.execute("fetch --verbose --tags")
		
		
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 

  // Get status
$o:=Form:C1466.git.status()

  // Update UI
Form:C1466.ƒ.update()

  // Update menu label
If ($o.changes.length>0)
	
	Form:C1466.menu[0].label:=Get localized string:C991("changes")+" ("+String:C10($o.changes.length)+")"
	
Else 
	
	Form:C1466.menu[0].label:=Get localized string:C991("changes")
	
	Form:C1466.unstaged.clear()
	Form:C1466.staged.clear()
	
End if 

  // Touch
Form:C1466.menu:=Form:C1466.menu

Form:C1466.ƒ.refresh()

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End