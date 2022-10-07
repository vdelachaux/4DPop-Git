//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : GIT Path
// ID[D8FCE09C5AE341AA9189F5C8DCFFEBCE]
// Created 6-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
#DECLARE($path : Text) : Variant

If (False:C215)
	C_TEXT:C284(GIT Path; $1)
	C_VARIANT:C1683(GIT Path; $0)
End if 

var $t : Text

$path:=Replace string:C233($path; "\""; "")

Case of 
		
		//———————————————————————————————————————————
	: (Position:C15(")"; $path)>0)  // Trash
		
		return File:C1566(Form:C1466.project.parent.parent.path+$path)
		
		//———————————————————————————————————————————
	: ($path="Documentation/@")  // Documentation
		
		return File:C1566(Form:C1466.project.parent.parent.path+$path)
		
		//———————————————————————————————————————————
	: ($path="@/Methods/@")  // Project methods
		
		return Replace string:C233(Replace string:C233($path; ".4dm"; ""); "Project/Sources/Methods/"; "")
		
		//———————————————————————————————————————————
	: ($path="@/Classes/@")
		
		return "[class]"+Replace string:C233(Replace string:C233($path; ".4dm"; ""); "Project/Sources/Classes"; "")
		
		//———————————————————————————————————————————
	: ($path="@/Forms/@")
		
		Case of 
				
				//……………………………………………………………………………………………
			: ($path="@.4DForm")  // Form definition
				
				return Replace string:C233($path; "Project/Sources/Forms/"; "")
				
				//……………………………………………………………………………………………
			: ($path="@.4dm")  // method
				
				$t:=Replace string:C233($path; ".4dm"; "")
				
				If ($t="@/ObjectMethods/@")  // Object method
					
					$t:=Replace string:C233($t; "Project/Sources/Forms/"; "")
					$t:=Replace string:C233($t; "ObjectMethods"; "")
					return "[projectForm]/"+$t
					
				Else   // Form method
					
					$t:=Replace string:C233($t; "Project/Sources/Forms/"; "")
					$t:=Replace string:C233($t; "method"; "")
					return "[projectForm]/"+$t+"{formMethod}"
					
				End if 
				
				//……………………………………………………………………………………………
			Else 
				
				If ($path[[Length:C16($path)]]="/")
					
					// It's a folder
					return Folder:C1567(Form:C1466.project.parent.parent.path+$path)
					
				Else 
					
					return File:C1566(Form:C1466.project.parent.parent.path+$path)
					
				End if 
				
				//……………………………………………………………………………………………
		End case 
		
		//———————————————————————————————————————————
	Else 
		
		return File:C1566(Form:C1466.project.parent.parent.path+$path)
		
		//———————————————————————————————————————————
End case 