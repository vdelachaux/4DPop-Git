//%attributes = {"invisible":true,"shared":true}
C_TEXT:C284($1;$methodPath)
C_OBJECT:C1216($git)
$methodPath:=$1

Case of 
	: (Position:C15("[class]/";$methodPath)=1)
		$methodPath:="Project/Sources/Classes/"+Substring:C12($methodPath;9)+".4dm"
	: (Position:C15("[projectForm]/";$methodPath)=1)
		If ((Position:C15("{formMethod}";$methodPath)>0))
			$methodPath:="Project/Sources/Forms/"+Replace string:C233(Substring:C12($methodPath;15);"{formMethod}";"method.4dm")
		Else 
			$methodPath:="Project/Sources/Forms/"+Replace string:C233(Substring:C12($methodPath;15);"/";"/ObjectMethods/")+".4dm"
		End if 
	Else 
		$methodPath:="Project/Sources/Methods/"+$methodPath+".4dm"
End case 

$git:=cs:C1710.Git.new()
$git.diffTool($methodPath)
