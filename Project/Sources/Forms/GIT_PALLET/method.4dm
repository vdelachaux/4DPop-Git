var $branch : Text
var $success : Boolean
var $count : Integer
var $e : Object
var $git : cs:C1710.Git

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
		
		$git:=Form:C1466.git
		
		$branch:=$git.currentBranch()
		
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
		
		Form:C1466.changes:=$git.status()
		
		//$git.execute("log origin/"+Form.branch+"..."+Form.branch+" --format=%H")
		//Form.fetch:=Split string($git.result; "\n"; sk ignore empty strings).length
		$git.fetch(True:C214)
		Form:C1466.fetch:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1).length
		
		//$git.execute("rev-list origin...HEAD --single-worktree")
		
		$git.execute("rev-list origin/"+Form:C1466.branch+"...HEAD --single-worktree")
		Form:C1466.push:=Split string:C1554($git.result; "\n"; sk ignore empty strings:K86:1).length
		
		SET TIMER:C645(60*Form:C1466.timer)
		
		//______________________________________________________
End case 
