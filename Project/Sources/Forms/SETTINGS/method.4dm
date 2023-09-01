// ----------------------------------------------------
// Form method : SETTINGS
// ID[23198BF4E9724DBD8142187751E18A42]
// Created 19-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
var $cmd; $ERROR; $IN; $OUT; $instance : Text
var $p : Picture
var $x : Blob
var $file : 4D:C1709.File
var $e : cs:C1710.evt

$e:=cs:C1710.evt.new()

Case of 
		
		//______________________________________________________
	: ($e.load)
		
		Form:C1466.avatar:=Null:C1517
		Form:C1466.git:=cs:C1710.Git.new()
		
		Form:C1466.user:=cs:C1710.GithubAPI.new().getUser()
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.timer)
		
		SET TIMER:C645(0)
		
		Form:C1466.instances:={\
			values: []; \
			currentValue: ""; \
			index: 0\
			}
		
		ARRAY LONGINT:C221($len; 0x0000)
		ARRAY LONGINT:C221($pos; 0x0000)
		
		For each ($instance; ["/usr/local/bin/git"; "/usr/bin/git"; "4DPop Git"])
			
			$file:=$instance="4DPop Git" ? File:C1566(File:C1566("/RESOURCES/git/git").platformPath; fk platform path:K87:2) : File:C1566($instance)
			
			If ($file.exists)
				
				$cmd:=$instance="4DPop Git" ? "git version" : $instance+" version"
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
				LAUNCH EXTERNAL PROCESS:C811($cmd; $IN; $OUT; $ERROR)
				
				If (Bool:C1537(OK))
					
					Case of 
							
							//______________________________________________________
						: ($instance="4DPop Git")\
							 && (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; $OUT; 1; $pos; $len))
							
							$OUT:=Substring:C12($OUT; $pos{0}; $len{0})
							
							//______________________________________________________
						: (Match regex:C1019("git version (.*)"; $OUT; 1; $pos; $len))
							
							$OUT:=Substring:C12($OUT; $pos{1}; $len{1})
							
							//______________________________________________________
					End case 
				End if 
				
				Form:C1466.instances.values.push($OUT+" "+$instance)
				
				If ($instance="/usr/local/bin/git")\
					 && (Form:C1466.git.local)
					
					Form:C1466.instances.index:=Form:C1466.instances.values.length-1
					Form:C1466.instances.currentValue:=Form:C1466.instances.values[Form:C1466.instances.index]
					
				End if 
			End if 
		End for each 
		
		If (Form:C1466.user.avatar_url#Null:C1517)
			
			If (HTTP Get:C1157(Form:C1466.user.avatar_url; $x)=200)
				
				BLOB TO PICTURE:C682($x; $p)
				Form:C1466.avatar:=$p
				
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 