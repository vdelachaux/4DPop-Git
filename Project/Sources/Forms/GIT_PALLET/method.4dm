var $branch; $head; $major; $version : Text
var $success : Boolean
var $c : Collection
var $file : 4D:C1709.File

ARRAY LONGINT:C221($len; 0)
ARRAY LONGINT:C221($pos; 0)

$file:=Folder:C1567(fk database folder:K87:14; *).file(".git/HEAD")

If ($file.exists)
	
	$head:=$file.getText()
	
	If (Match regex:C1019("(?m-si)ref: refs/heads/(.*)$"; $head; 1; $pos; $len))
		
		Form:C1466.branch:=Substring:C12($head; $pos{1}; $len{1})
		
		$c:=Split string:C1554(Application version:C493; "")
		$major:=$c[0]+$c[1]
		
		If (Application version:C493(*)="A@")
			
			Form:C1466.version:="DEV ("+$major+"R"+$c[2]+")"
			$success:=(Form:C1466.branch="main") || (Form:C1466.branch="master") || (Form:C1466.branch=($major+Choose:C955($c[2]="0"; "."+$c[3]; "R"+$c[2])))
			
		Else 
			
			Form:C1466.version:=$major+Choose:C955($c[2]="0"; ("."+$c[3]); ("R"+$c[2]))
			
			If ($c[2]#"0")
				
				Form:C1466.version:=$major+"R"+$c[2]
				$success:=(Form:C1466.branch=(Form:C1466.version)) | (Form:C1466.branch=($major+"RX"))
				
			Else 
				
				Form:C1466.version:=$major+"."+$c[3]
				$success:=(Form:C1466.branch=(Form:C1466.version)) | (Form:C1466.branch=($major+".X"))
				
			End if 
		End if 
		
		If ($success)
			
			OBJECT SET RGB COLORS:C628(*; "branch@"; Foreground color:K23:1)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; "branch@"; "red")
			
		End if 
		
	End if 
End if 