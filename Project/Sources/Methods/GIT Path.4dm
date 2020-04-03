//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : GIT Path
  // ID[D8FCE09C5AE341AA9189F5C8DCFFEBCE]
  // Created 6-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_VARIANT:C1683($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t_path)
C_VARIANT:C1683($v_resolved)

If (False:C215)
	C_VARIANT:C1683(GIT Path ;$0)
	C_TEXT:C284(GIT Path ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$t_path:=$1
	
	  // Default values
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$t_path:=Replace string:C233($t_path;"\"";"")

Case of 
		
		  //———————————————————————————————————————————
	: (Position:C15(")";$t_path)>0)  // Trash
		
		$v_resolved:=File:C1566(Form:C1466.project.parent.parent.path+$t_path)
		
		  //———————————————————————————————————————————
	: ($t_path="Documentation/@")  // Documentation
		
		$v_resolved:=File:C1566(Form:C1466.project.parent.parent.path+$t_path)
		
		  //———————————————————————————————————————————
	: ($t_path="@/Methods/@")  // Project methods
		
		$v_resolved:=Replace string:C233(Replace string:C233($t_path;".4dm";"");"Project/Sources/Methods/";"")
		
		  //———————————————————————————————————————————
	: ($t_path="@/Forms/@")
		
		Case of 
				
				  //……………………………………………………………………………………………
			: ($t_path="@.4DForm")  // Form definition
				
				$v_resolved:=File:C1566(Form:C1466.project.parent.parent.path+$t_path)
				
				  //……………………………………………………………………………………………
			: ($t_path="@.4dm")  // method
				
				$v_resolved:=Replace string:C233($t_path;".4dm";"")
				
				If ($v_resolved="@/ObjectMethods/@")  // Object method
					
					$v_resolved:=Replace string:C233($v_resolved;"Project/Sources/Forms/";"")
					$v_resolved:=Replace string:C233($v_resolved;"ObjectMethods";"")
					$v_resolved:="[projectForm]/"+$v_resolved
					
				Else   // Form method
					
					$v_resolved:=Replace string:C233($v_resolved;"Project/Sources/Forms/";"")
					$v_resolved:=Replace string:C233($v_resolved;"method";"")
					$v_resolved:="[projectForm]/"+$v_resolved+"{formMethod}"
					
				End if 
				
				  //……………………………………………………………………………………………
			Else 
				
				$v_resolved:=File:C1566(Form:C1466.project.parent.parent.path+$t_path)
				
				  //……………………………………………………………………………………………
		End case 
		
		  //———————————————————————————————————————————
	Else 
		
		$v_resolved:=File:C1566(Form:C1466.project.parent.parent.path+$t_path)
		
		  //———————————————————————————————————————————
End case 

  // ----------------------------------------------------
  // Return
$0:=$v_resolved  //4D path or file

  // ----------------------------------------------------
  // End