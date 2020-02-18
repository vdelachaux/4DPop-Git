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

C_BLOB:C604($x)
C_LONGINT:C283($end;$start)
C_TEXT:C284($t;$tCMD;$tERROR;$tIN;$tMessage;$tOUT)
C_OBJECT:C1216($file;$o)

If (False:C215)
	C_OBJECT:C1216(git ;$0)
	C_VARIANT:C1683(git ;$1)
	C_VARIANT:C1683(git ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"git";\
		"chnges";New collection:C1472;\
		"success";True:C214;\
		"error";"";\
		"errors";New collection:C1472;\
		"warning";"";\
		"warnings";New collection:C1472;\
		"workingDirectory";Null:C1517;\
		"git";Null:C1517;\
		"init";Formula:C1597(git ("init"));\
		"status";Formula:C1597(git ("status"));\
		"add";Formula:C1597(git ("add";$1));\
		"stage";Formula:C1597(git ("stage"));\
		"commit";Formula:C1597(git ("commit";$1));\
		"version";Formula:C1597(git ("version").result);\
		"execute";Formula:C1597(git ("execute";$1).result)\
		)
	
	$o.workingDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
	$o.git:=$o.workingDirectory.folder(".git")
	
Else 
	
	$o:=This:C1470
	
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
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
			
			If ($o.workingDirectory#Null:C1517)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10($o.workingDirectory.platformPath))
				
			End if 
			
			LAUNCH EXTERNAL PROCESS:C811("git "+$tCMD;$tIN;$tOUT;$tERROR)
			$o.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)
			
			Case of 
					
					  //______________________________________________________
				: ($o.success)
					
					$o.result:=$tOUT
					
					  //______________________________________________________
				: (Length:C16($tERROR)>0)
					
					$o.error:=$tERROR
					$o.errors.push($o.error)
					
					  //______________________________________________________
			End case 
			
			  //______________________________________________________
		: ($1="init")
			
			$o.execute("init")
			
			If ($o.success)
				
				$file:=$o.workingDirectory.file(".gitignore")
				
				If (Not:C34($file.exists))
					
					  // Create default gitignore
					$t:=File:C1566("/RESOURCES/gitignore").getText()
					TEXT TO BLOB:C554($t;$x;UTF8 text without length:K22:17)
					$file.setContent($x)
					
					$o.add(".gitignore")
					
					If ($o.success)
						
						
						$o.commit()
						
					End if 
					
				End if 
				
			End if 
			
			  //______________________________________________________
		: ($1="status")
			
			If (Not:C34(Bool:C1537($o.git.exists)))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				$o.execute("status -s")
				
			End if 
			
			  //______________________________________________________
		: ($1="stage")
			
			If (Not:C34(Bool:C1537($o.git.exists)))
				
				$o.init()
				
			End if 
			
			If ($o.success)
				
				$o.result:=New collection:C1472
				
				$o.execute("add -A")
				
			End if 
			
			  //______________________________________________________
		: ($1="add")
			
			If (Value type:C1509($2)=Is collection:K8:32)
				
				
				
			Else 
				
				$o.execute("add "+Char:C90(Quote:K15:44)+String:C10($2)+Char:C90(Quote:K15:44))
				
			End if 
			
			  //______________________________________________________
		: ($1="commit")
			
			If (Not:C34(Bool:C1537($o.git.exists)))
				
				$o.init()
				
			End if 
			
			$o.status()
			
			If ($o.changes.length>0)
				
				$o.stage()
				
				If ($o.success)
					
					$tMessage:=Choose:C955($2=Null:C1517;"Initial commit";String:C10($2))
					
					$o.execute("commit -m "+Char:C90(Quote:K15:44)+$tMessage+Char:C90(Quote:K15:44))
					
				End if 
				
			Else 
				
				$o.warning:="Nothing to commit"
				$o.warnings.push($o.warning)
				
			End if 
			
			  //______________________________________________________
		: ($1="version")
			
			$o.execute("version")
			
			If ($o.success)
				
				$o.success:=Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?";$o.result;1;$start;$end)
				
				If ($o.success)
					
					$o.result:=Substring:C12($o.result;$start;$end)
					
				Else 
					
					  // Error
					$o.error:="Failed to get version in "+$o.result
					$o.errors.push($o.error)
					
				End if 
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
	
	If ($o.success)
		
		If (Position:C15("\n";String:C10($o.result))>0)
			
			  // As list
			$o.changes:=Split string:C1554($o.result;"\n";sk ignore empty strings:K86:1)
			
		Else 
			
			$o.changes:=New collection:C1472
			
		End if 
		
		  //
		
	End if 
End if 

  // ----------------------------------------------------
  // Return

$0:=$o

  // ----------------------------------------------------
  // End