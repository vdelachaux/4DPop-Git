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
		
		  // Private key contents
		$tPrivate:="-----BEGIN RSA PRIVATE KEY-----\n-----END RSA PRIVATE KEY-----"
		
		  // Get current date and time avoiding timezone issues
		$time:=Current time:C178
		$timeGMT:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$time);1;11);"Z";""))
		$dateGMT:=Date:C102(Delete string:C232(String:C10(Current date:C33;ISO date GMT:K1:10;$time);12;20)+"00:00:00")
		
		  // Convert date and time in number of seconds
		$lIAT:=(($dateGMT-Add to date:C393(!00-00-00!;1970;1;1))*86400)+($timeGMT+0)
		
		$o:=New object:C1471(\
			"type";"PEM";\
			"size";256;\
			"pem";$tPrivate)
		
		$oJWT:=cs:C1710.jwt.new($o)
		
		$oPayload:=New object:C1471(\
			"iat";$lIAT;\
			"exp";$lIAT+(10*60);\
			"iss";"61936")
		
		$o:=New object:C1471(\
			"algorithm";"ES256")
		
		$tToken:=$oJWT.sign($oPayload;$o)
		
		$o:=$oJWT.verify($tToken)
		
		If ($o.success)
			
			ARRAY TEXT:C222($aTheaderNames;0x0000)
			ARRAY TEXT:C222($aTheaderValues;0x0000)
			
			APPEND TO ARRAY:C911($aTheaderNames;"Authorization")
			APPEND TO ARRAY:C911($aTheaderValues;$tToken)
			
			APPEND TO ARRAY:C911($aTheaderNames;"User-Agent")
			APPEND TO ARRAY:C911($aTheaderValues;"4dpop-git")
			
			APPEND TO ARRAY:C911($aTheaderNames;"Accept")
			APPEND TO ARRAY:C911($aTheaderValues;"application/vnd.github.machine-man-preview+json")
			
			$tURL:="https://api.github.com/users/vdelachaux/repos"
			
			$lError:=HTTP Request:C1158(HTTP GET method:K71:1;$tURL;$tContents;$tResponse;$aTheaderNames;$aTheaderValues)
			
			ARRAY OBJECT:C1221($aOresponses;0x0000)
			JSON PARSE ARRAY:C1219($tResponse;$aOresponses)
			
			$t:=JSON Stringify array:C1228($aOresponses;*)
			File:C1566("/RESOURCES/response.json").setText($t)
			
			If ($lError=200)
				
				  //$aTheaderValues{3}:="application/vnd.github.nebula-preview+json"
				
				$tURL:="https://api.github.com/users/vdelachaux/repos"
				
				  //$o:=New object(\
					"name";"Hello-World";\
					"description";"This is your first repository"\
					)
				
				  //$tContents:=JSON Stringify($o)
				  //$tURL:=$tURL+JSON Stringify($o)
				$tContents:="{\"name\":\"Hello-World\",\"description\":\"This is your first repository\"}"
				$lError:=HTTP Request:C1158(HTTP POST method:K71:2;$tURL;$tContents;$tResponse;$aTheaderNames;$aTheaderValues)
				
			Else 
				
				  // A "If" statement should never omit "Else" 
				
			End if 
		Else 
			
			  // A "If" statement should never omit "Else"
			
		End if 
		
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