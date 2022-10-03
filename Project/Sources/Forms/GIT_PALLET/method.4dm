var $branch : Text
var $success : Boolean
var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.branch:=""
		Form:C1466.changes:=0
		Form:C1466.fetch:=0
		Form:C1466.push:=0
		
		Form:C1466.timer:=20
		
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
		
		Form:C1466.git:=cs:C1710.Git.new()
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$branch:=Form:C1466.git.currentBranch()
		
		If ($branch#Form:C1466.branch)
			
			Form:C1466.branch:=$branch
			
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
		
		Form:C1466.changes:=Form:C1466.git.status()
		
		//Form.git.execute("log origin/master..master --format=%H")
		Form:C1466.git.execute("log origin/"+Form:C1466.branch+".."+Form:C1466.branch+" --format=%H")
		Form:C1466.push:=Split string:C1554(Form:C1466.git.result; "\n"; sk ignore empty strings:K86:1).length
		
		Form:C1466.git.execute("rev-list origin...HEAD --single-worktree")
		var $count : Integer
		$count:=Split string:C1554(Form:C1466.git.result; "\n"; sk ignore empty strings:K86:1).length-Form:C1466.push
		Form:C1466.fetch:=$count<0 ? 0 : $count
		
		SET TIMER:C645(60*Form:C1466.timer)
		
		//______________________________________________________
End case 