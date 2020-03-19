//%attributes = {"invisible":true}
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_TEXT:C284($tCMD;$tERROR;$tIN;$tOUT)

If (False:C215)
	C_BOOLEAN:C305(Git EXECUTE ;$0)
	C_TEXT:C284(Git EXECUTE ;$1)
	C_TEXT:C284(Git EXECUTE ;$2)
End if 

If (Count parameters:C259>=2)
	
	$tIN:=$2
	
End if 

If (Count parameters:C259>=1)
	
	$tCMD:=$1
	
End if 

This:C1470.success:=(Length:C16($tCMD)>0)

If (This:C1470.success)
	
	  //$tCMD:=$tCMD+" -q"
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
	
	If (This:C1470.workingDirectory#Null:C1517)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10(This:C1470.workingDirectory.platformPath))
		
	End if 
	
	Case of 
			
			  //———————————————————————————————
		: (This:C1470.local)
			
			$tCMD:="/usr/local/bin/git "+$tCMD
			
			  //———————————————————————————————
		: (Is Windows:C1573)
			
			$tCMD:="Resources/git/git "+$tCMD
			
			  //———————————————————————————————
		Else 
			
			$tCMD:="git "+$tCMD
			
			  //———————————————————————————————
	End case 
	
	LAUNCH EXTERNAL PROCESS:C811($tCMD;$tIN;$tOUT;$tERROR)
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)
	
	If (Bool:C1537(This:C1470.debug))
		
		This:C1470.history.insert(0;New object:C1471(\
			"cmd";"$ "+$tCMD;\
			"success";This:C1470.success;\
			"out";$tOUT;\
			"error";$tERROR))
		
	End if 
	
	Case of 
			
			  //——————————————————————
		: (This:C1470.success)
			
			This:C1470.error:=""
			This:C1470.warning:=""
			
			This:C1470.result:=$tOUT
			
			  //——————————————————————
		: (Length:C16($tERROR)>0)
			
			This:C1470.pushError(Current method name:C684+" - "+$tERROR)
			
			  //——————————————————————
	End case 
	
Else 
	
	This:C1470.pushError("Missing command parameter")
	
End if 

$0:=This:C1470.success