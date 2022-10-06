//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : GIT
// ID[DBC17A31DBA047DEBC0BEA1F2BADF817]
// Created 6-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($in)

If (False:C215)
	C_VARIANT:C1683(GIT; $1)
End if 

var $action : Text
var $v
var $o : Object
var $git : cs:C1710.git

$action:=Value type:C1509($in)=Is object:K8:27 ? String:C10($in.action) : String:C10($in)
$git:=Form:C1466.git

Case of 
		
		//______________________________________________________
	: ($action="switch")
		
		$o:=Form:C1466.$.selector.getParameter("data"; Null:C1517; Is object:K8:27)
		
		If (Not:C34(Bool:C1537($o.current)))
			
			$git.branch()
			
		End if 
		
		//______________________________________________________
	: ($action="stage")
		
		For each ($o; Form:C1466.selectedUnstaged)
			
			$git.add($o.path)
			
		End for each 
		
		//______________________________________________________
	: ($action="stageAll")
		
		$git.add("all")
		
		//______________________________________________________
	: ($action="unstage")
		
		For each ($o; Form:C1466.selectedStaged)
			
			$git.unstage($o.path)
			
		End for each 
		
		//______________________________________________________
	: ($action="discard")
		
		CONFIRM:C162(Get localized string:C991("doYouWantToDiscardAllChangesInTheSelectedFiles"); Get localized string:C991("discard"))
		
		If (Bool:C1537(OK))
			
			For each ($o; Form:C1466.selectedUnstaged)
				
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
	: ($action="commit")
		
		$git.commit($in.message; Form:C1466.amend)
		
		//______________________________________________________
	: ($action="fetch")
		
		$o:=_o_progress("Fetching data").setIcon(Form:C1466.logo).setProgress(-1)
		
		If ($git.fetch())
			
			GIT COMMIT LIST
			
		End if 
		
		$o.close()
		
		//______________________________________________________
	: ($action="pull")
		
		$o:=_o_progress("Pulling data").setIcon(Form:C1466.logo).setProgress(-1)
		
		If ($git.pull())
			
			GIT COMMIT LIST
			
			RELOAD PROJECT:C1739
			
		End if 
		
		$o.close()
		
		//______________________________________________________
	: ($action="push")
		
		$o:=_o_progress("Pushing data").setIcon(Form:C1466.logo).setProgress(-1)
		
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

Form:C1466.menu[0].label:=Choose:C955($git.changes.length>0; Get localized string:C991("changes")+" ("+String:C10($git.changes.length)+")"; Get localized string:C991("changes"))

// Touch
Form:C1466.menu:=Form:C1466.menu

Form:C1466.ƒ.updateUI()

// Update UI
Form:C1466.ƒ.refresh()