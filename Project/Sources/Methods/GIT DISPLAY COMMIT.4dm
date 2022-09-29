//%attributes = {"invisible":true}
var $t : Text
var $p : Picture
var $x : Blob
var $o; $commit : Object
var $c : Collection

// Clear list
Form:C1466.$.detailCommit.deselect()

Form:C1466.commitDetail.clear()

$commit:=Form:C1466.commitsCurrent

If ($commit#Null:C1517)
	
	OBJECT SET VISIBLE:C603(*; "detail_@"; True:C214)
	
	If (Form:C1466.git.diffList($commit.parent.short; $commit.fingerprint.short))
		
		For each ($t; Split string:C1554(Form:C1466.git.result; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2))
			
			$c:=Split string:C1554($t; "\t"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			$o:=New object:C1471(\
				"status"; $c[0]; \
				"path"; $c[1]; \
				"label"; $c[1])
			
			If ($c.length>=3)  // Renamed
				
				$o.label:=$o.label+" -> "+$c[2]
				$o.path:=$c[2]
				
			End if 
			
			Form:C1466.commitDetail.push($o)
			
		End for each 
	End if 
	
	If ($commit.author.avatar=Null:C1517)
		
		$t:=Generate digest:C1147($commit.author.mail; MD5 digest:K66:1)
		
		If (Form:C1466[$t]=Null:C1517)
			
			If (HTTP Get:C1157("https://www.gravatar.com/avatar/"+$t; $x)=200)
				
				BLOB TO PICTURE:C682($x; $p)
				Form:C1466[$t]:=$p
				
			End if 
		End if 
		
		$commit.author.avatar:=Form:C1466[$t]
		
	End if 
	
Else 
	
	OBJECT SET VISIBLE:C603(*; "detail_@"; False:C215)
	
End if 

Form:C1466.$.selector.deselect()

OBJECT SET VISIBLE:C603(*; "diff1"; False:C215)
Form:C1466.diff:=""