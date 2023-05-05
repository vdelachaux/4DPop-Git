//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : GIT Path
// ID[D8FCE09C5AE341AA9189F5C8DCFFEBCE]
// Created 6-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
#DECLARE($path : Text; $root : 4D:C1709.Folder) : Variant

If (False:C215)
	C_TEXT:C284(GIT Path; $1)
	C_OBJECT:C1216(GIT Path; $2)
	C_VARIANT:C1683(GIT Path; $0)
End if 

$root:=$root || Form:C1466.project.parent.parent
$path:=Replace string:C233($path; "\""; "")

Case of 
		
		//———————————————————————————————————————————
	: (Position:C15(")"; $path)>0)  // Trash
		
		return File:C1566($root.path+$path)
		
		//———————————————————————————————————————————
	: ($path="Documentation/@")  // Documentation
		
		return File:C1566($root.path+$path)
		
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
			: ($path="@.4dm")  // Method
				
				$path:=Replace string:C233($path; ".4dm"; "")
				
				If ($path="@/ObjectMethods/@")  // Object method
					
					$path:=Replace string:C233($path; "Project/Sources/Forms/"; "")
					$path:=Replace string:C233($path; "ObjectMethods"; "")
					return "[projectForm]/"+$path
					
				Else   // Form method
					
					$path:=Replace string:C233($path; "Project/Sources/Forms/"; "")
					$path:=Replace string:C233($path; "method"; "")
					return "[projectForm]/"+$path+"{formMethod}"
					
				End if 
				
				//……………………………………………………………………………………………
			Else 
				
				return $path[[Length:C16($path)]]="/" ? Folder:C1567($root.path+$path) : File:C1566($root.path+$path)
				
				//……………………………………………………………………………………………
		End case 
		
		//———————————————————————————————————————————
	: ($path="/RESOURCES/@")\
		 | ($path="/PACKAGE/@")\
		 | ($path="/SOURCES/@")\
		 | ($path="/PROJECT/@")\
		 | ($path="/DATA/@")\
		 | ($path="/LOGS/@")
		
		$path:=Replace string:C233($path; "/RESOURCES/"; "/RESOURCES/")
		$path:=Replace string:C233($path; "/PACKAGE/"; "/PACKAGE/")
		$path:=Replace string:C233($path; "/SOURCES/"; "/SOURCES/")
		$path:=Replace string:C233($path; "/PROJECT/"; "/PROJECT/")
		$path:=Replace string:C233($path; "/DATA/"; "/DATA/")
		$path:=Replace string:C233($path; "/LOGS/"; "/LOGS/")
		
		return ($path="@/" ? Folder:C1567($path) : File:C1566($path))
		
		//———————————————————————————————————————————
	Else 
		
		return File:C1566($root.path+$path)
		
		//———————————————————————————————————————————
End case 