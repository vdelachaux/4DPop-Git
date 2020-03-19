Class constructor

  // This[""]:=New object(\
"";"git";\
"local";False)

This:C1470.user:=New object:C1471
This:C1470.local:=File:C1566("/usr/local/bin/git").exists
This:C1470.success:=True:C214
This:C1470.error:=""
This:C1470.errors:=New collection:C1472
This:C1470.warning:=""
This:C1470.warnings:=New collection:C1472
This:C1470.changes:=New collection:C1472
This:C1470.history:=New collection:C1472
This:C1470.branches:=New collection:C1472
This:C1470.remotes:=New collection:C1472
This:C1470.tags:=New collection:C1472
This:C1470.workingDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
This:C1470.git:=This:C1470.workingDirectory.folder(".git")
This:C1470.gitignore:=This:C1470.workingDirectory.file(".gitignore")

This:C1470.debug:=True:C214

If (Git EXECUTE ("config --get user.name"))
	
	This:C1470.user.name:=Replace string:C233(This:C1470.result;"\n";"")
	
End if 

If (Git EXECUTE ("config --get user.email"))
	
	This:C1470.user.email:=Replace string:C233(This:C1470.result;"\n";"")
	
End if 

/*————————————————————————————————————————————————————————*/
Function add

C_VARIANT:C1683($1)
C_VARIANT:C1683($v)

Case of 
		
		  //_____________________________
	: (Value type:C1509($1)=Is text:K8:3)
		
		Case of 
				
				  //——————————————————————
			: ($1="all")  // Update the index and adds new files
				
				This:C1470.result:=New collection:C1472
				This:C1470.execute("add -A")
				
				  //——————————————————————
			: ($1="update")  // Update the index, but adds no new files
				
				This:C1470.result:=New collection:C1472
				This:C1470.execute("add -u")
				
				  //——————————————————————
			Else   // Add the given file
				
				This:C1470.execute("add "+Char:C90(Quote:K15:44)+String:C10($1)+Char:C90(Quote:K15:44))
				
				  //——————————————————————
		End case 
		
		  //_____________________________
	: (Value type:C1509($1)=Is collection:K8:32)
		
		For each ($v;$1)
			
			If (Value type:C1509($v)=Is text:K8:3)
				
				This:C1470.execute("add "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
				
			Else 
				
				  // ERROR
				
			End if 
		End for each 
		
		  //_____________________________
	Else 
		
		  // ERROR
		
		  //_____________________________
End case 

/*————————————————————————————————————————————————————————*/
Function getBranches

C_TEXT:C284($t)
C_COLLECTION:C1488($c)

This:C1470.branches:=New collection:C1472

If (Git EXECUTE ("branch --list -v"))
	
	For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
		
		$c:=Split string:C1554($t;" ";sk ignore empty strings:K86:1)
		
		This:C1470.branches.push(New object:C1471(\
			"name";$c[1];\
			"ref";$c[2];\
			"current";Bool:C1537($c[0]="*")))
		
	End for each 
End if 

/*————————————————————————————————————————————————————————*/
Function execute

C_VARIANT:C1683($1)

Git EXECUTE ($1)

/*————————————————————————————————————————————————————————*/
Function checkout

C_VARIANT:C1683($1)
C_VARIANT:C1683($v)

Case of 
		
		  //_____________________________
	: (Value type:C1509($1)=Is text:K8:3)
		
		This:C1470.execute("checkout -- "+Char:C90(Quote:K15:44)+String:C10($1)+Char:C90(Quote:K15:44))
		
		  //_____________________________
	: (Value type:C1509($1)=Is collection:K8:32)
		
		For each ($v;$1)
			
			If (Value type:C1509($v)=Is text:K8:3)
				
				This:C1470.execute("checkout -- "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
				
			Else 
				
				  // ERROR
				
			End if 
		End for each 
		
		  //_____________________________
	Else 
		
		  // ERROR
		
		  //_____________________________
End case 

/*————————————————————————————————————————————————————————*/
Function commit

C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_TEXT:C284($t)

This:C1470.status()

If (This:C1470.changes.length>0)
	
	$t:=Choose:C955(Length:C16($1)=0;"Initial commit";$1)
	
	If ($2)
		
		Git EXECUTE ("commit --amend --no-edit")
		
	Else 
		
		Git EXECUTE ("commit -m "+Char:C90(Quote:K15:44)+$t+Char:C90(Quote:K15:44))
		
	End if 
	
Else 
	
	This:C1470.pushWarning("Nothing to commit")
	
End if 

/*————————————————————————————————————————————————————————*/
Function diff

C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($b)

If (Count parameters:C259>=2)
	
	$b:=Git EXECUTE ("diff "+String:C10($2)+" -- "+$1)
	
Else 
	
	$b:=Git EXECUTE ("diff -- '"+$1+"'")
	
End if 

If ($b)
	
	This:C1470.result:=Replace string:C233(This:C1470.result;"\r\n";"\n")
	This:C1470.result:=Replace string:C233(This:C1470.result;"\r";"\n")
	
End if 

/*————————————————————————————————————————————————————————*/
Function diffTool

C_TEXT:C284($1)

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"false")

Git EXECUTE ("difftool -y '"+$1+"'")

/*————————————————————————————————————————————————————————*/
Function init

If (Git EXECUTE ("init"))
	
	If (Not:C34(This:C1470.gitignore.exists))
		
		  // Create default gitignore
		This:C1470.gitignore.setText(File:C1566("/RESOURCES/gitignore.txt").getText("UTF-8";Document with CR:K24:21);"UTF-8";Document with CRLF:K24:20)
		
	End if 
End if 

/*————————————————————————————————————————————————————————*/
Function open

C_TEXT:C284($1)

C_TEXT:C284($tIN;$tOUT;$tERROR)

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")

Case of 
		
		  //——————————————————————
	: ($1="terminal")  // Open terminal in the working directory
		
		LAUNCH EXTERNAL PROCESS:C811("open -a terminal '"+This:C1470.workingDirectory.path+"'";$tIN;$tOUT;$tERROR)
		
		  //——————————————————————
	: ($1="show")  // Open on disk the current directory
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10(This:C1470.workingDirectory.platformPath))
		LAUNCH EXTERNAL PROCESS:C811("open .";$tIN;$tOUT;$tERROR)
		
		  //——————————————————————
End case 

This:C1470.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)

Case of 
		
		  //——————————————————————
	: (This:C1470.success)
		
		This:C1470.error:=""
		
		  //——————————————————————
	: (Length:C16($tERROR)>0)
		
		This:C1470.pushError($tERROR)
		
		  //——————————————————————
End case 

/*————————————————————————————————————————————————————————*/
Function pushError

C_TEXT:C284($1)

This:C1470.error:=$1
This:C1470.errors.push($1)

/*————————————————————————————————————————————————————————*/
Function pushWarning

C_TEXT:C284($1)

This:C1470.warning:=$1
This:C1470.warnings.push($1)

/*————————————————————————————————————————————————————————*/
Function getRemotes

C_TEXT:C284($t)
C_COLLECTION:C1488($c)

This:C1470.remotes.clear()

If (Git EXECUTE ("remote -v"))
	
	For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
		
		$c:=Split string:C1554($t;"\t";sk ignore empty strings:K86:1)
		
		If (This:C1470.remotes.query("name=:1";$c[0]).length=0)
			
			This:C1470.remotes.push(New object:C1471(\
				"name";$c[0];\
				"url";Substring:C12($c[1];1;Position:C15(" (";$c[1])-1)))
			
		End if 
	End for each 
End if 

/*————————————————————————————————————————————————————————*/
Function status

C_TEXT:C284($t)

This:C1470.changes.clear()

If (Git EXECUTE ("status -s -uall"))
	
	If (Position:C15("\n";String:C10(This:C1470.result))>0)
		
		For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
			
			This:C1470.changes.push(New object:C1471(\
				"status";$t[[1]]+$t[[2]];\
				"path";Delete string:C232($t;1;3)))
			
		End for each 
	End if 
End if 

/*————————————————————————————————————————————————————————*/
Function getTags

C_TEXT:C284($t)

This:C1470.tags.clear()

If (Git EXECUTE ("tag"))
	
	For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
		
		This:C1470.tags.push($t)
		
	End for each 
End if 

/*————————————————————————————————————————————————————————*/
Function unstage

C_VARIANT:C1683($1)

C_VARIANT:C1683($v)

Case of 
		
		  //_____________________________
	: (Value type:C1509($1)=Is text:K8:3)
		
		Git EXECUTE ("reset HEAD "+Char:C90(Quote:K15:44)+$1+Char:C90(Quote:K15:44))
		
		  //_____________________________
	: (Value type:C1509($1)=Is collection:K8:32)
		
		For each ($v;$1)
			
			If (Value type:C1509($v)=Is text:K8:3)
				
				Git EXECUTE ("reset HEAD "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
				
			Else 
				
				  // ERROR
				
			End if 
		End for each 
		
		  //_____________________________
	Else 
		
		  // ERROR
		
		  //_____________________________
End case 

/*————————————————————————————————————————————————————————*/
Function untrack

C_VARIANT:C1683($1)

C_VARIANT:C1683($v)

Case of 
		
		  //_____________________________
	: (Value type:C1509($1)=Is text:K8:3)
		
		Git EXECUTE ("rm --cached "+Char:C90(Quote:K15:44)+$1+Char:C90(Quote:K15:44))
		
		  //_____________________________
	: (Value type:C1509($1)=Is collection:K8:32)
		
		For each ($v;$1)
			
			If (Value type:C1509($v)=Is text:K8:3)
				
				Git EXECUTE ("rm --cached "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
				
			Else 
				
				  // ERROR
				
			End if 
		End for each 
		
		  //_____________________________
	Else 
		
		  // ERROR
		
		  //_____________________________
End case 

/*————————————————————————————————————————————————————————*/
Function version

C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($end;$start)

If (Git EXECUTE ("version"))
	
	If (String:C10($1)="short")\
		 & (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?";This:C1470.result;1;$start;$end))
		
		$0:=Substring:C12(This:C1470.result;$start;$end)
		
	Else 
		
		  // Return full result
		$0:=Replace string:C233(This:C1470.result;"\n";"")
		
	End if 
End if 