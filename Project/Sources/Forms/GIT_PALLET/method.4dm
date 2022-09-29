var $head : Text
var $success : Boolean
var $e : Object
var $file : 4D:C1709.File

ARRAY LONGINT:C221($len; 0)
ARRAY LONGINT:C221($pos; 0)

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.branch:=""
		Form:C1466.timer:=30
		Form:C1466.appVersion:=Application version:C493(*)
		Form:C1466.digits:=Split string:C1554(Application version:C493; "")
		Form:C1466.major:=Form:C1466.digits[0]+Form:C1466.digits[1]
		
		If (Form:C1466.appVersion="A@")
			
			Form:C1466.version:="DEV ("+Form:C1466.major+"R"+Form:C1466.digits[2]+")"
			
		Else 
			
			Form:C1466.version:=Form:C1466.major+Choose:C955(Form:C1466.digits[2]="0"; ("."+Form:C1466.digits[3]); ("R"+Form:C1466.digits[2]))
			
			If (Form:C1466.digits[2]#"0")
				
				Form:C1466.version:=Form:C1466.major+"R"+Form:C1466.digits[2]
				
			Else 
				
				Form:C1466.version:=Form:C1466.major+"."+Form:C1466.digits[3]
				
			End if 
		End if 
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$file:=Folder:C1567(fk database folder:K87:14; *).file(".git/HEAD")
		
		If ($file.exists)
			
			$head:=$file.getText()
			
			If (Match regex:C1019("(?m-si)ref: refs/heads/(.*)$"; $head; 1; $pos; $len))
				
				If (Substring:C12($head; $pos{1}; $len{1})#Form:C1466.branch)
					
					Form:C1466.branch:=Substring:C12($head; $pos{1}; $len{1})
					
					If (Form:C1466.appVersion="A@")
						
						$success:=(Form:C1466.branch="main") || (Form:C1466.branch="master") || (Form:C1466.branch=(Form:C1466.major+(Form:C1466.digits[2]="0" ? "."+Form:C1466.digits[3] : "R"+Form:C1466.digits[2])+"@"))
						
					Else 
						
						If (Form:C1466.digits[2]#"0")
							
							$success:=(Form:C1466.branch=(Form:C1466.version)+"@") || (Form:C1466.branch=(Form:C1466.major+"RX"))
							
						Else 
							
							$success:=(Form:C1466.branch=(Form:C1466.version)+"@") || (Form:C1466.branch=(Form:C1466.major+".X"))
							
						End if 
					End if 
					
					If ($success)
						
						OBJECT SET RGB COLORS:C628(*; "branch"; Foreground color:K23:1)
						OBJECT SET FONT STYLE:C166(*; "branch"; Plain:K14:1)
						
					Else 
						
						BEEP:C151
						OBJECT SET RGB COLORS:C628(*; "branch"; "red")
						OBJECT SET FONT STYLE:C166(*; "branch"; Bold:K14:2)
						
					End if 
				End if 
			End if 
			
			SET TIMER:C645(60*Form:C1466.timer)
			
		End if 
		
		//______________________________________________________
		
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 