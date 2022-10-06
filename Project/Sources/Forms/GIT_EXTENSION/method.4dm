var $branch : Text
var $success : Boolean
var $e : Object
var $c : Collection
var $git : cs:C1710.git

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (Form:C1466=Null:C1517) || (OB Is empty:C1297(Form:C1466))
			
			Form:C1466.branch:=""
			Form:C1466.changes:=0
			Form:C1466.fetchNumber:=0
			Form:C1466.pushNumber:=0
			
			Form:C1466.timer:=20
			
			$c:=Split string:C1554(Application version:C493; "")
			
			Form:C1466.release:=$c[2]#"0"
			Form:C1466.lts:=Not:C34(Form:C1466.release)
			
			Form:C1466.major:=$c[0]+$c[1]
			Form:C1466.minor:=Form:C1466.release ? "R"+$c[2] : "."+$c[3]
			Form:C1466.alpha:=Application version:C493(*)="A@"
			
			Form:C1466.version:=Form:C1466.major+Form:C1466.minor
			
			If (Form:C1466.alpha)
				
				Form:C1466.version:="DEV ("+Form:C1466.version+")"
				
			End if 
			
			Form:C1466.isRepository:=Folder:C1567("/PACKAGE/.git"; *).exists
			
			If (Form:C1466.isRepository)
				
				Form:C1466.git:=cs:C1710.git.new()
				
			Else 
				
				Form:C1466.git:=Null:C1517
				
			End if 
		End if 
		
		If (Form:C1466.isRepository)
			
			$git:=Form:C1466.git
			
			$branch:=$git.currentBranch()
			
			If ($branch#Form:C1466.branch)
				
				Form:C1466.branch:=$branch
				
				If (Form:C1466.alpha)
					
					$success:=(Form:C1466.branch="main")\
						 || (Form:C1466.branch="master")\
						 || (Form:C1466.branch=(Form:C1466.major+Form:C1466.minor+"@"))
					
				Else 
					
					If (Form:C1466.release)
						
						$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
							 || (Form:C1466.branch=(Form:C1466.major+"RX"))
						
					Else 
						
						$success:=(Form:C1466.branch=(Form:C1466.version)+"@")\
							 || (Form:C1466.branch=(Form:C1466.major+".X"))
						
					End if 
				End if 
				
				If ($success)
					
					OBJECT SET RGB COLORS:C628(*; "git.branch"; Foreground color:K23:1)
					OBJECT SET FONT STYLE:C166(*; "git.branch"; Plain:K14:1)
					OBJECT SET HELP TIP:C1181(*; "git.branch"; Form:C1466.branch)
					
				Else 
					
					OBJECT SET RGB COLORS:C628(*; "git.branch"; "red")
					OBJECT SET FONT STYLE:C166(*; "git.branch"; Bold:K14:2)
					OBJECT SET HELP TIP:C1181(*; "git.branch"; "WARNING:\n\nYou are editing the \""+$branch+"\" branch of \""+File:C1566("/PACKAGE/.git/HEAD"; *).parent.parent.name+"\" with a "+Form:C1466.version+" version of 4D.")
					
				End if 
			End if 
			
			Form:C1466.fetchNumber:=$git.branchFetchNumber()
			Form:C1466.pushNumber:=$git.branchPushNumber()
			Form:C1466.changes:=$git.status()
			
			OBJECT SET VISIBLE:C603(*; "git.@"; True:C214)
			OBJECT SET VISIBLE:C603(*; "git.init"; False:C215)
			
			SET TIMER:C645(60*Form:C1466.timer)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "git.@"; False:C215)
			OBJECT SET VISIBLE:C603(*; "git.init"; True:C214)
			
		End if 
		
		//______________________________________________________
End case 