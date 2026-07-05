//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method: GIT BLAME
// From the method editor's "Last commit for selection…" macro: reports the most
// recent commit that modified the selected line(s) of the edited method/class.
// Called as GIT BLAME("<method_path/>"); reads the selection via GET MACRO PARAMETER.
// ----------------------------------------------------
#DECLARE($path : Text)

var $git:=cs:C1710.Git.me

If ($git.root=Null:C1517) || (Not:C34($git.root.exists))
	
	ALERT:C41(Localized string:C991("thisDatabaseIsNotUnderGitControl"))
	return 
	
End if 

var $file:=$git.sourceFile($path)

If ($file=Null:C1517) || (Not:C34($file.exists))
	
	ALERT:C41(Localized string:C991("methodFileNotFound"))
	return 
	
End if 

// The selected text (editor form, i.e. de-tokenized)
var $selection : Text
GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $selection)
$selection:=Replace string:C233(Replace string:C233($selection; "\r\n"; "\n"); "\r"; "\n")

If (Length:C16($selection)=0)
	
	ALERT:C41(Localized string:C991("selectLinesFirst"))
	return 
	
End if 

// De-tokenise the file (this keeps the same number of lines) and locate the selection
// to derive its line range, which matches the on-disk .4dm line numbers used by git blame.
var $code : Text:=cs:C1710.rgx.regex.new($file.getText(); "(?m-si):[CK]:?\\d+(?::\\d+)?").substitute("")
$code:=Replace string:C233(Replace string:C233($code; "\r\n"; "\n"); "\r"; "\n")

// Normalise indentation: strip leading/trailing whitespace on EVERY line (the editor selection
// and the file rarely share the exact same leading tabs). This keeps the line structure intact,
// so line numbers still map to the file. Then trim the selection's outer blank lines.
var $codeNorm : Text:=cs:C1710.rgx.regex.new($code; "(?m)^[ \\t]+").substitute("")
$codeNorm:=cs:C1710.rgx.regex.new($codeNorm; "(?m)[ \\t]+$").substitute("")

var $selNorm : Text:=cs:C1710.rgx.regex.new($selection; "(?m)^[ \\t]+").substitute("")
$selNorm:=cs:C1710.rgx.regex.new($selNorm; "(?m)[ \\t]+$").substitute("")
$selNorm:=cs:C1710.rgx.regex.new($selNorm; "^\\s+|\\s+$").substitute("")

If (Length:C16($selNorm)=0)
	
	ALERT:C41(Localized string:C991("selectLinesFirst"))
	return 
	
End if 

var $pos : Integer:=Position:C15($selNorm; $codeNorm)

If ($pos=0)
	
	ALERT:C41(Localized string:C991("selectionNotFound"))
	return 
	
End if 

var $start : Integer:=Split string:C1554(Substring:C12($codeNorm; 1; $pos-1); "\n").length
var $end : Integer:=$start+Split string:C1554($selNorm; "\n").length-1

// File path relative to the workspace
var $rel : Text:=$file.path
If (Position:C15($git.workspace.path; $file.path)=1)
	
	$rel:=Substring:C12($file.path; Length:C16($git.workspace.path)+1)
	
End if 

If (Not:C34($git.execute("blame -L "+String:C10($start)+","+String:C10($end)+" --line-porcelain -- \""+$rel+"\"")))
	
	ALERT:C41(String:C10($git.error))
	return 
	
End if 

// Find the most recent commit among the blamed lines (skipping not-yet-committed lines)
var $sha; $bestSha : Text
var $bestTime : Real:=-1
var $line : Text

For each ($line; Split string:C1554($git.result; "\n"))
	
	Case of 
			
			//______________________________________________________
		: (Length:C16($line)>=41) && ($line[[41]]=" ") && (Position:C15(" "; Substring:C12($line; 1; 40))=0)
			
			$sha:=Substring:C12($line; 1; 40)
			
			//______________________________________________________
		: (Position:C15("author-time "; $line)=1)
			
			var $t : Real:=Num:C11(Substring:C12($line; 13))
			
			If ($sha#"0000000000000000000000000000000000000000") && ($t>$bestTime)
				
				$bestTime:=$t
				$bestSha:=$sha
				
			End if 
			
			//______________________________________________________
	End case 
End for each 

If ($bestSha="")
	
	ALERT:C41(Localized string:C991("selectionNotCommitted"))
	return 
	
End if 

// Fetch a readable description of that commit
$git.execute("show -s --format=%h%x09%an%x09%aI%x09%s "+$bestSha)
var $f : Collection:=Split string:C1554($git.result; Char:C90(9))

var $stamp : Text:=($f.length>=3) ? Replace string:C233(Substring:C12($f[2]; 1; 16); "T"; " ") : ""
var $msg : Text:=Localized string:C991("lastCommitForSelection")+":\r\r"
$msg:=$msg+String:C10($f[0])+"  —  "+String:C10($f[1])+"\r"+$stamp+"\r\r"
$msg:=$msg+(($f.length>=4) ? $f.slice(3).join(Char:C90(9)) : "")

ALERT:C41($msg)
