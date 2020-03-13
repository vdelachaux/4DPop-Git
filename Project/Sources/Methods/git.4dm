//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : git
  // ID[A996E74534274CD6A4F342792642B84E]
  // Created 18-2-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_VARIANT:C1683($1)
C_VARIANT:C1683($2)

C_LONGINT:C283($end;$start)
C_TEXT:C284($t;$tCMD;$tERROR;$tIN;$tOUT)
C_OBJECT:C1216($file;$o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(git ;$0)
	C_VARIANT:C1683(git ;$1)
	C_VARIANT:C1683(git ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";New object:C1471("";"git";"local";False:C215);\
		"changes";New collection:C1472;\
		"success";True:C214;\
		"history";New collection:C1472;\
		"error";"";\
		"errors";New collection:C1472;\
		"warning";"";\
		"warnings";New collection:C1472;\
		"workingDirectory";Null:C1517;\
		"git";Null:C1517;\
		"branches";New collection:C1472;\
		"remotes";New collection:C1472;\
		"tags";New collection:C1472;\
		"init";Formula:C1597(git ("init"));\
		"add";Formula:C1597(git ("add";$1));\
		"branch";Formula:C1597(git ("branch"));\
		"checkout";Formula:C1597(git ("checkout";$1));\
		"commit";Formula:C1597(git ("commit";New object:C1471("message";$1;"amend";Bool:C1537($2))));\
		"diff";Formula:C1597(git ("diff";New object:C1471("path";String:C10($1);"options";String:C10($2))).result);\
		"diffTool";Formula:C1597(git ("diffTool";$1).result);\
		"execute";Formula:C1597(git ("execute";$1).result);\
		"fetch";Formula:C1597(git ("fetch"));\
		"remote";Formula:C1597(git ("remote"));\
		"revert";Formula:C1597(git ("revert";$1).result);\
		"stage";Formula:C1597(git ("stage"));\
		"stageAll";Formula:C1597(git ("stageAll"));\
		"status";Formula:C1597(git ("status"));\
		"tag";Formula:C1597(git ("tag"));\
		"unstage";Formula:C1597(git ("unstage";$1));\
		"untrack";Formula:C1597(git ("untrack";$1));\
		"terminal";Formula:C1597(git ("open";"terminal"));\
		"show";Formula:C1597(git ("open";"finder"))\
		)
	
	$o[""].local:=File:C1566("/usr/local/bin/git").exists
	
	$o.workingDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
	$o.git:=$o.workingDirectory.folder(".git")
	
	$o.execute("version")
	
	If ($o.success)
		
		$o.success:=Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?";$o.result;1;$start;$end)
		
		If ($o.success)
			
			$o.version:=Substring:C12($o.result;$start;$end)
			
		Else 
			
			  // Error
			$o.error:="Failed to get version in "+$o.result
			$o.errors.push($o.error)
			
		End if 
	End if 
	
Else 
	
	$o:=This:C1470
	$o.success:=Bool:C1537($o.git.exists)
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="execute")
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				ASSERT:C1129($2.cmd#Null:C1517)
				
				$tCMD:=String:C10($2.cmd)
				$tIN:=String:C10($2.in)
				
			Else 
				
				$tCMD:=String:C10($2)
				
			End if 
			
			  //$tCMD:=$tCMD+" -q"
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
			
			If ($o.workingDirectory#Null:C1517)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10($o.workingDirectory.platformPath))
				
			End if 
			
			Case of 
					
					  //———————————————————————————————
				: ($o[""].local)
					
					$tCMD:="/usr/local/bin/git "+$tCMD
					
					  //———————————————————————————————
				: (Is Windows:C1573)
					
					$tCMD:="Resources/git/git "+$tCMD
					
					  //———————————————————————————————
				Else 
					
					$tCMD:="git "+$tCMD
					
					  //———————————————————————————————
			End case 
			
			
			LAUNCH EXTERNAL PROCESS:C811($tCMD;$tIN;$tOUT;$tERROR)
			$o.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)
			
			$o.history.insert(0;New object:C1471(\
				"cmd";"$ "+$tCMD;\
				"success";$o.success;\
				"out";$tOUT;\
				"error";$tERROR))
			
			Case of 
					
					  //——————————————————————
				: ($o.success)
					
					$o.result:=$tOUT
					
					  //——————————————————————
				: (Length:C16($tERROR)>0)
					
					$o.error:=$tERROR
					$o.errors.push($o.error)
					
					  //——————————————————————
			End case 
			
			  //______________________________________________________
		: ($1="open")
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
			
			Case of 
					
					  //——————————————————————
				: ($2="terminal")
					
					LAUNCH EXTERNAL PROCESS:C811("open -a terminal '"+$o.workingDirectory.path+"'";$tIN;$tOUT;$tERROR)
					
					  //——————————————————————
				: ($2="finder")
					
					SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10($o.workingDirectory.platformPath))
					LAUNCH EXTERNAL PROCESS:C811("open .";$tIN;$tOUT;$tERROR)
					
					  //——————————————————————
				Else 
					
					  // A "Case of" statement should never omit "Else"
					  //——————————————————————
			End case 
			
			$o.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)
			
			Case of 
					
					  //——————————————————————
				: ($o.success)
					
					  //$o.result:=$tOUT
					
					  //——————————————————————
				: (Length:C16($tERROR)>0)
					
					$o.error:=$tERROR
					$o.errors.push($o.error)
					
					  //——————————————————————
			End case 
			
			  //______________________________________________________
		: ($1="init")
			
			$o.execute("init")
			
			If ($o.success)
				
				$file:=$o.workingDirectory.file(".gitignore")
				
				If (Not:C34($file.exists))
					
					  // Create default gitignore
					$file.setText(File:C1566("/RESOURCES/gitignore.txt").getText("UTF-8";Document with CR:K24:21);"UTF-8";Document with CRLF:K24:20)
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="diff")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				If ($2.option#Null:C1517)
					
					$o.execute("diff "+$2.option+" -- "+$2.path)
					
				Else 
					
					$o.execute("diff -- "+$2.path)
					
				End if 
				
				If ($o.success)
					
					$o.result:=Replace string:C233($o.result;"\r\n";"\n")
					$o.result:=Replace string:C233($o.result;"\r";"\n")
					
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="diffTool")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"false")
				
				$o.execute("difftool -y '"+$2+"'")
				
			End if 
			
			  //______________________________________________________
		: ($1="status")
			
			$o.changes.clear()
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				$o.execute("status -s -uall")
				
				If ($o.success)
					
					If (Position:C15("\n";String:C10($o.result))>0)
						
						For each ($t;Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1))
							
							$o.changes.push(New object:C1471(\
								"status";$t[[1]]+$t[[2]];\
								"path";Delete string:C232($t;1;3)))
							
						End for each 
					End if 
				End if 
			End if 
			
			  //______________________________________________________
		: ($1="stageAll")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				$o.result:=New collection:C1472
				
				$o.execute("add -A")
				
			End if 
			
			  //______________________________________________________
		: ($1="tag")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			$o.tags:=New collection:C1472
			
			$o.execute("tag")
			
			If ($o.success)
				
				For each ($t;Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1))
					
					$o.tags.push($t)
					
				End for each 
			End if 
			
			  //______________________________________________________
		: ($1="add")
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				  //
				
			Else 
				
				$o.execute("add "+Char:C90(Quote:K15:44)+String:C10($2)+Char:C90(Quote:K15:44))
				
			End if 
			
			  //______________________________________________________
		: ($1="unstage")
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				  //
				
			Else 
				
				$o.execute("reset HEAD "+Char:C90(Quote:K15:44)+String:C10($2)+Char:C90(Quote:K15:44))
				
			End if 
			
			  //______________________________________________________
		: ($1="untrack")
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				  //
				
			Else 
				
				$o.execute("rm --cached "+Char:C90(Quote:K15:44)+String:C10($2)+Char:C90(Quote:K15:44))
				
			End if 
			
			  //______________________________________________________
		: ($1="checkout")
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				  //
				
			Else 
				
				$o.execute("checkout -- "+Char:C90(Quote:K15:44)+String:C10($2)+Char:C90(Quote:K15:44))
				
			End if 
			
			  //______________________________________________________
		: ($1="commit")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			$o.status()
			
			If ($o.changes.length>0)
				
				$t:=Choose:C955(Length:C16($2.message)=0;"Initial commit";$2.message)
				
				If ($2.amend)
					
					$o.execute("commit --amend --no-edit")
					
				Else 
					
					$o.execute("commit -m "+Char:C90(Quote:K15:44)+$t+Char:C90(Quote:K15:44))
					
				End if 
				
			Else 
				
				$o.warning:="Nothing to commit"
				$o.warnings.push($o.warning)
				
			End if 
			
			  //______________________________________________________
		: ($1="branch")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			$o.branches:=New collection:C1472
			
			$o.execute("branch --list -v")
			
			If ($o.success)
				
				For each ($t;Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t;" ";sk ignore empty strings:K86:1)
					
					$o.branches.push(New object:C1471(\
						"name";$c[1];\
						"ref";$c[2];\
						"current";Bool:C1537($c[0]="*")))
					
				End for each 
			End if 
			
			  //______________________________________________________
		: ($1="remote")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			$o.remotes:=New collection:C1472
			
			$o.execute("remote -v")
			
			If ($o.success)
				
				For each ($t;Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t;"\t";sk ignore empty strings:K86:1)
					
					If ($o.remotes.query("name=:1";$c[0]).length=0)
						
						$o.remotes.push(New object:C1471(\
							"name";$c[0];\
							"url";Substring:C12($c[1];1;Position:C15(" (";$c[1])-1)))
						
					End if 
				End for each 
			End if 
			
			  //______________________________________________________
		: ($1="fetch")
			
			If (Not:C34($o.success))
				
				$o.init()
				
			End if 
			
			$o.execute("fetch --verbose --tags")
			
			  // Result is on the error part!
			$o.success:=(OK=1)
			
			If ($o.success)
				
				$o.error:=""
				
				  // Parse result
				$t:=$o.errors.pop()
				
			End if 
			
			  //______________________________________________________
		Else 
			
			$o.success:=False:C215
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End