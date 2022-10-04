// ----------------------------------------------------
// Form method : GIT_SETTINGS
// ID[23198BF4E9724DBD8142187751E18A42]
// Created 19-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
C_LONGINT:C283($end; $index; $start)
C_TEXT:C284($t; $tCMD; $tERROR; $tIN; $tOUT)
C_OBJECT:C1216($event; $file)

// ----------------------------------------------------
// Initialisations
$event:=FORM Event:C1606

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($event.code=On Load:K2:1)
		
		Form:C1466.gitInstances:=New collection:C1472
		
		For each ($t; New collection:C1472("/usr/local/bin/git"; "/usr/bin/git"; "Component"))
			
			$file:=Choose:C955($t="Component"; File:C1566(File:C1566("/RESOURCES/git/git").platformPath; fk platform path:K87:2); File:C1566($t))
			
			If ($file.exists)
				
				//SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY";String($file.parent.platformPath))
				
				If ($t="Component")
					
					$tCMD:="git version"
					
				Else 
					
					$tCMD:=$t+" version"
					
				End if 
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
				LAUNCH EXTERNAL PROCESS:C811($tCMD; $tIN; $tOUT; $tERROR)
				
				If (OK=1)
					
					If (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; $tOUT; 1; $start; $end))
						
						$tOUT:=Substring:C12($tOUT; $start; $end)
						
					End if 
				End if 
				
				$t:=Replace string:C233($tOUT; "\n"; "")+" ("+$t+")"
				
				Form:C1466.gitInstances.push($t)
				
			End if 
		End for each 
		
		COLLECTION TO ARRAY:C1562(Form:C1466.gitInstances; (OBJECT Get pointer:C1124(Object named:K67:5; "instances"))->)
		
		If (cs:C1710.git.new().local)
			
			$index:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; "instances"))->; "@/usr/local/bin/git@")
			(OBJECT Get pointer:C1124(Object named:K67:5; "instances"))->:=$index
			
		Else 
			
			// A "If" statement should never omit "Else"
			
		End if 
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($event.code=On Unload:K2:2)
		
		//______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
		
		//______________________________________________________
End case 