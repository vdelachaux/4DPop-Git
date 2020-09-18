//%attributes = {}
C_BOOLEAN:C305($bRelative)
C_DATE:C307($dateGMT)
C_LONGINT:C283($lError;$lIAT)
C_TIME:C306($time;$timeGMT)
C_TEXT:C284($t;$tContents;$tPrivate;$tResponse;$tToken;$tURL)
C_TEXT:C284($tVersion)
C_OBJECT:C1216($file;$git;$o;$oJWT;$oPayload)
C_COLLECTION:C1488($c)


Case of 
		
		  //______________________________________________________
	: (True:C214)
		
		$git:=cs:C1710.Git.new()
		$tVersion:=$git.version("short")
		
		$git.status()
		$git.branch()
		
		$git.execute()
		ASSERT:C1129($git.error#"")
		
		$git.getRemotes()
		$git.getTags()
		
		$file:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath;fk platform path:K87:2).file("Project/Sources/Methods/GIT.4dm")
		$git.diff($file)
		
		$git.diffTool("Project/Sources/Methods/GIT.4dm")
		
		  //$git.open("disk")
		
		$git.stash()
		
		  //______________________________________________________
	: (True:C214)
		
		$t:="ABCDEF"
		$t:=Delete string:C232($t;-1;2)
		
		$t:="ABCDEF/**"
		$t:=Delete string:C232($t;Length:C16($t)-2;3)
		
		  //______________________________________________________
	: (True:C214)
		
		$t:="doc/frotz/"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="frotz/"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129(Not:C34($bRelative))
		
		  //______________________________________________________
	: (False:C215)
		
		$o:=cs:C1710.Git.new()
		
		$o.execute("log --abbrev-commit --oneline")
		$o.execute("log --abbrev-commit --format=%s,%an,%h,%aD")
		
		$c:=Split string:C1554($o.result;"\n")
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 