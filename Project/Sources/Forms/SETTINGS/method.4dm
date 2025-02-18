// ----------------------------------------------------
// Form method : SETTINGS
// ID[23198BF4E9724DBD8142187751E18A42]
// Created 19-3-2020 by Vincent de Lachaux
// ----------------------------------------------------
var $e:=cs:C1710.evt.new()

Case of 
		
		//______________________________________________________
	: ($e.load)
		
		Form:C1466.git:=cs:C1710.Git.new()
		
		OBJECT SET ENTERABLE:C238(*; "ghAvailable"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "ghAuthorized"; False:C215)
		
		Form:C1466.user:={\
			name: Form:C1466.git.userName(); \
			email: Form:C1466.git.userMail()}
		
		var $t:=Generate digest:C1147(Form:C1466.user.email; MD5 digest:K66:1)
		var $callback:=cs:C1710._gravatarRequest.new({user: $t})
		var $request : 4D:C1709.HTTPRequest
		$request:=4D:C1709.HTTPRequest.new("https://www.gravatar.com/avatar/"+$t; $callback)
		$request.wait()
		Form:C1466.avatar:=Form:C1466[$t]
		
		var $name : Text:=Process info:C1843(Current process:C322).name
		OBJECT SET VISIBLE:C603(*; "close"; $name#Formula:C1597(GIT SETTINGS).source)
		
		Form:C1466.gh:=cs:C1710.gh.me
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.timer)
		
		SET TIMER:C645(0)
		
		Case of 
				
				//______________________________________________________
			: (FORM Get current page:C276=1)
				
				If (Form:C1466.instances#Null:C1517)
					
					return 
					
				End if 
				
				Form:C1466.instances:={\
					values: []; \
					currentValue: ""; \
					index: 0\
					}
				
				ARRAY LONGINT:C221($len; 0x0000)
				ARRAY LONGINT:C221($pos; 0x0000)
				
				var $exe : Text
				For each ($exe; ["/usr/local/bin/git"; "/usr/bin/git"; "4DPop Git"])
					
					//var $file : 4D.File:=$exe="4DPop Git" ? File(File("/RESOURCES/bin/git").platformPath; fk platform path) : File($exe)
					
					If ($exe="4DPop Git")
						
						If (Is macOS:C1572)
							
							var $file:=File:C1566("/RESOURCES/bin/git")
							$exe:=$file.path
							
						Else 
							
							$file:=Folder:C1567(fk applications folder:K87:20).parent.file("Program Files/Git/bin/git.exe")
							$exe:=$file.path
							
						End if 
						
					Else 
						
						$file:=File:C1566($exe)
						
					End if 
					
					If ($file.exists)
						
						var $cmd:=$exe="4DPop Git" ? "git version" : $exe+" version"
						
						var $ERROR; $IN; $OUT : Text
						SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
						LAUNCH EXTERNAL PROCESS:C811($cmd; $IN; $OUT; $ERROR)
						
						If (Bool:C1537(OK))
							
							Case of 
									
									//______________________________________________________
								: ($exe="4DPop Git")\
									 && (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?"; $OUT; 1; $pos; $len))
									
									$OUT:=Substring:C12($OUT; $pos{0}; $len{0})
									
									//______________________________________________________
								: (Match regex:C1019("git version (.*)"; $OUT; 1; $pos; $len))
									
									$OUT:=Substring:C12($OUT; $pos{1}; $len{1})
									
									//______________________________________________________
							End case 
						End if 
						
						Form:C1466.instances.values.push($OUT+" "+$exe)
						
						If ($exe="/usr/local/bin/git")\
							 && (Form:C1466.git.local)
							
							Form:C1466.instances.index:=Form:C1466.instances.values.length-1
							Form:C1466.instances.currentValue:=Form:C1466.instances.values[Form:C1466.instances.index]
							
						End if 
					End if 
				End for each 
				
				If (Form:C1466.user.avatar_url#Null:C1517)
					
					If (HTTP Get:C1157(Form:C1466.user.avatar_url; $x)=200)
						
						var $p : Picture
						var $x : Blob
						
						BLOB TO PICTURE:C682($x; $p)
						Form:C1466.avatar:=$p
						
					End if 
				End if 
				
				//______________________________________________________
			: (FORM Get current page:C276=2)
				
				OBJECT SET TITLE:C194(*; "log"; Form:C1466.gh.authorized ? "Logout" : "Login…")
				OBJECT SET VISIBLE:C603(*; "log"; True:C214)
				OBJECT SET VISIBLE:C603(*; "ghScope"; Form:C1466.gh.authorized)
				OBJECT SET VALUE:C1742("ghAvailable"; Form:C1466.gh.available)
				OBJECT SET VALUE:C1742("ghAuthorized"; Form:C1466.gh.authorized)
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 