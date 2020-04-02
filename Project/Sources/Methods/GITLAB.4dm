//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GITLAB
  // ID[DBC17A31DBA047DEBC0BEA1F2BADF817]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_VARIANT:C1683($1)

C_TEXT:C284($t;$t_action)
C_OBJECT:C1216($git;$o;$o_IN)
C_COLLECTION:C1488($c)
C_VARIANT:C1683($v)

If (False:C215)
	C_VARIANT:C1683(GITLAB ;$1)
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
		End if 
		
		  //______________________________________________________
	: ($t_action="commit")
		
		$git.commit($o_IN.message;Form:C1466.amend)
		
		  //______________________________________________________
	: ($t_action="fetch")
		
		$git.execute("fetch --verbose --tags origin")
		
		  //______________________________________________________
	: ($t_action="pull")
		
		$git.execute()
		
		If ($git.success)
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"toolbarMessage"))->:=$git.history[0].out
			
		Else 
			
			  // A "If" statement should never omit "Else"
			
		End if 
		
		  //______________________________________________________
	: ($t_action="push")
		
		$git.push()
		
		
		If (Not:C34($git.success))
			
			ALERT:C41($git.error)
			
		End if 
		
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