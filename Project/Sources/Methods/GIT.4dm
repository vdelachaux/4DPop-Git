//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GIT
  // ID[DBC17A31DBA047DEBC0BEA1F2BADF817]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_VARIANT:C1683($1)

C_TEXT:C284($t_action)
C_OBJECT:C1216($git;$o;$o_IN;$oForm)
C_VARIANT:C1683($v)

If (False:C215)
	C_VARIANT:C1683(GIT ;$1)
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

$git:=Form:C1466.git

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($t_action="switch")
		
		$o:=Form:C1466.$.selector.getParameter("data";Null:C1517;Is object:K8:27)
		
		If (Not:C34($o.current))
			
			$git.branch()
			
		End if 
		
		  //______________________________________________________
	: ($t_action="stage")
		
		For each ($o;Form:C1466.selectedUnstaged)
			
			$git.add($o.path)
			
		End for each 
		
		  //______________________________________________________
	: ($t_action="stageAll")
		
		$git.add("all")
		
		  //______________________________________________________
	: ($t_action="unstage")
		
		For each ($o;Form:C1466.selectedStaged)
			
			$git.unstage($o.path)
			
		End for each 
		
		  //______________________________________________________
	: ($t_action="discard")
		
		CONFIRM:C162(Get localized string:C991("doYouWantToDiscardAllChangesInTheSelectedFiles");Get localized string:C991("discard"))
		
		If (Bool:C1537(OK))
			
			For each ($o;Form:C1466.selectedUnstaged)
				
				If ($o.status="??")
					
					$v:=Form:C1466.ƒ.path($o.path)
					
					Case of 
							
							  //——————————————————————————————————
						: (Value type:C1509($v)=Is text:K8:3)  // Method
							
							  // Warning: No update if 4D App don't be unactivated/activated
							$v:=File:C1566(Form:C1466.project.parent.parent.path+$o.path)
							
							  //——————————————————————————————————
						: (Value type:C1509($v)=Is object:K8:27)  // File
							
							  // <NOTHING MORE TO DO>
							
							  //——————————————————————————————————
					End case 
					
					If (Bool:C1537($v.exists))
						
						$v.delete()
						
					Else 
						
						TRACE:C157
						
					End if 
					
				Else 
					
					$git.checkout($o.path)
					
				End if 
			End for each 
			
			RELOAD PROJECT:C1739
			
		End if 
		
		  //______________________________________________________
	: ($t_action="commit")
		
		$git.commit($o_IN.message;Form:C1466.amend)
		
		  //______________________________________________________
	: ($t_action="fetch")
		
		$o:=progress ("Fetching data").setIcon($oForm.log).setProgress(-1)
		
		If ($git.fetch())
			
			GIT COMMIT LIST 
			
		End if 
		
		$o.close()
		
		  //______________________________________________________
	: ($t_action="pull")
		
		$o:=progress ("Pulling data").setIcon($oForm.log).setProgress(-1)
		
		If ($git.pull())
			
			GIT COMMIT LIST 
			
			If (Num:C11(Application version:C493)>=1840)  //#18R4+
				
				EXECUTE FORMULA:C63("RELOAD PROJECT:C1739")
				
			End if 
		End if 
		
		$o.close()
		
		  //______________________________________________________
	: ($t_action="push")
		
		$o:=progress ("Pushing data").setIcon($oForm.log).setProgress(-1)
		
		If (Not:C34($git.push()))
			
			ALERT:C41($git.error)
			
		End if 
		
		$o.close()
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 

  // Get status
$git.status()

Form:C1466.menu[0].label:=Choose:C955($git.changes.length>0;Get localized string:C991("changes")+" ("+String:C10($git.changes.length)+")";Get localized string:C991("changes"))

  // Touch
Form:C1466.menu:=Form:C1466.menu

Form:C1466.ƒ.updateUI()

  // Update UI
Form:C1466.ƒ.refresh()

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End