//%attributes = {}
C_BOOLEAN:C305($bRelative)
C_DATE:C307($dateGMT)
C_LONGINT:C283($lError; $lIAT)
C_TIME:C306($time; $timeGMT)
C_TEXT:C284($t; $tContents; $tPrivate; $tResponse; $tToken; $tURL)

C_OBJECT:C1216($o; $oJWT; $oPayload)

var $git:=cs:C1710.Git.new()
var $gh:=cs:C1710.gh.me

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		$gh.deleteRepo("test-git")
		ASSERT:C1129($gh.success)
		BEEP:C151
		
		//______________________________________________________
	: (True:C214)
		
		var $number:=$git.branchFetchNumber("refactor")
		
		
		//______________________________________________________
	: (True:C214)
		
		
		var $version:=$git.getVersion("short")
		$version:=$git.getVersion()
		
/*
var $path:=Folder(Folder(fk database folder).platformPath; fk platform path).file("Project/Sources/Methods/GIT.4dm").path
$git.diff($path)
//ASSERT($git.error="Git.diff('/Users/vdl/GITHUB/4DPop/4DPop-Family/4DPop-Git/Project/Sources/Methods/GIT.4dm'): File not found")
		
$path:=Folder(Folder(fk database folder).platformPath; fk platform path).file("Project/Sources/Methods/GIT SETTINGS.4dm").path
$git.diff($path)
*/
		
		var $c:=$git.FETCH_HEAD("tag")
		$c:=$git.FETCH_HEAD("branch")
		
		var $config:=$git.getConfig()
		
		
		
		$git.status()
		$git.branch()
		
		$git.execute()
		ASSERT:C1129($git.error#"")
		
		$git.updateRemotes()
		$git.updateTags()
		
		
		
		$git.diffTool("Project/Sources/Methods/GIT.4dm")
		
		//$git.open("disk")
		
		$git.stash()
		
		//______________________________________________________
	: (True:C214)
		
		$t:="ABCDEF"
		$t:=Delete string:C232($t; -1; 2)
		
		$t:="ABCDEF/**"
		$t:=Delete string:C232($t; Length:C16($t)-2; 3)
		
		//______________________________________________________
	: (True:C214)
		
		$t:="doc/frotz/"
		$bRelative:=Choose:C955(Position:C15("/"; $t)=1; True:C214; Split string:C1554($t; "/"; sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc"
		$bRelative:=Choose:C955(Position:C15("/"; $t)=1; True:C214; Split string:C1554($t; "/"; sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/"; $t)=1; True:C214; Split string:C1554($t; "/"; sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/"; $t)=1; True:C214; Split string:C1554($t; "/"; sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="frotz/"
		$bRelative:=Choose:C955(Position:C15("/"; $t)=1; True:C214; Split string:C1554($t; "/"; sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129(Not:C34($bRelative))
		
		//______________________________________________________
	: (False:C215)
		
		$o:=cs:C1710.Git.new()
		
		$o.execute("log --abbrev-commit --oneline")
		$o.execute("log --abbrev-commit --format=%s,%an,%h,%aD")
		
		$c:=Split string:C1554($o.result; "\n")
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		//______________________________________________________
End case 