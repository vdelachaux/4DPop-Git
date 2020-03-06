//%attributes = {"invisible":true}
C_VARIANT:C1683($0)
C_TEXT:C284($1)

If (False:C215)
	C_VARIANT:C1683(convertPath ;$0)
	C_TEXT:C284(convertPath ;$1)
End if 

Case of 
		
		  //———————————————————————————————————————————
	: (Position:C15(")";$1)>0)  // Trash
		
		$0:=File:C1566(Form:C1466.project.parent.parent.path+$1)
		
		  //———————————————————————————————————————————
	: ($1="Documentation/@")  // Documentation
		
		$0:=File:C1566(Form:C1466.project.parent.parent.path+$1)
		
		  //———————————————————————————————————————————
	: ($1="@/Methods/@")  // Project methods
		
		$0:=Replace string:C233(Replace string:C233($1;".4dm";"");"Project/Sources/Methods/";"")
		
		  //———————————————————————————————————————————
	: ($1="@/Forms/@")
		
		Case of 
				
				  //……………………………………………………………………………………………
			: ($1="@.4DForm")  // Form definition
				
				$0:=File:C1566(Form:C1466.project.parent.parent.path+$1)
				
				  //……………………………………………………………………………………………
			: ($1="@.4dm")  // method
				
				$0:=Replace string:C233($1;".4dm";"")
				
				If ($0="@/ObjectMethods/@")  // Object method
					
					$0:=Replace string:C233($0;"Project/Sources/Forms/";"")
					$0:=Replace string:C233($0;"ObjectMethods";"")
					$0:="[projectForm]/"+$0
					
				Else   // Form method
					
					$0:=Replace string:C233($0;"Project/Sources/Forms/";"")
					$0:=Replace string:C233($0;"method";"")
					$0:="[projectForm]/"+$0+"{formMethod}"
					
				End if 
				
				  //……………………………………………………………………………………………
			Else 
				
				$0:=File:C1566(Form:C1466.project.parent.parent.path+$1)
				
				  //……………………………………………………………………………………………
		End case 
		
		  //———————————————————————————————————————————
	Else 
		
		$0:=File:C1566(Form:C1466.project.parent.parent.path+$1)
		
		  //———————————————————————————————————————————
End case 