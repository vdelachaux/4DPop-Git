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
		$tPrivate:="-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAz8HtqQZM/wDqlzcvtrPfQDSAnwLERIvOLYES+ram+4sm1kqr\nvHl2W8+hYL/C+dOair6o3mxEOKWh6mnkClkwYLftW5NLO9YyS6Savi/tVDnuRA2R\nxUf2veIEYspf1oMA4WcIqqrif9XlmtUkWSHw/L7G5pkoCSH7a4WvBpbzMyjlpHv0\nyHEY5b3B"+\
			"\t\t\t\t\t\thT6BtwpAmsi1/K9n"+\
			"FVj8bCNMGEU0AvU0Hxxfj+8aXwC9+mhL1VKeDzVy\nWa5wYvnrzGuvAXxOoQrWYOtOQajYpLi1T+UyHbrHdVlN5GIt2hbs0RSNPNEFUQVY\neoGQJFOBpLEDR7HJ+Ndyc2D1eE8Ro3Ghe8j3swIDAQABAoIBAGpG5QFi9L45xMeH\n9oN6rgiVEvrEmowKDHVgosnX58GjpEFYv1NRuwcqRn5Mejv8UAELmSz2q0tjB1n3\nwyy8"+\
			"BTB"+\
			"\t\t\tkxi"+\
			"\t\t\t\t\t\tnjRkg"+\
			"cwWvKj1IdCEXewJDVdC08K+9kkCPNLIt6RlgHsfpEIkuMqsCy\nqb5iy3kvSmYqEL3jQU72ettfGpefNv8PgcVaWJWhMrK2465XTZTv2Elx19ub5as2\nWDBYGUHhX+io1mjZmNY5ljlp6yFG4ViVmpEvBkegioXEqSiAry7scHSHnCDo2FHJ\ni8CXzX7zZTeBzFu5Qw3FWTr46tfk4qkzlPCVq3gbSUnnZ3T/0TFvdmf3ebLqu"+\
			"mfn"+\
			"\t\t\t\nA"+\
			"\t\t\t\t\t\tbXey1"+\
			"ECgYEA8AVTGuhyf+WSwu8o9Ky9v0OqxWbflwbk/j9TI5gv5fwwhBot0UL/\nlU1Iai1Hnf5W0zxP3H1yic83yetHWJc5z7UcpYhW8MkMTiXC1nPu3H1ZXIT5EwLV\nRWoZxirc0dOPM3Q1GDcvpcL93l68io11lxj6b0Gj/lJ+9HAILsSsbvsCgYEA3Za9\nokzyBYCIRkRV2ARrT1B+Qn7PlNHguoyKAJqnlbbYGaJAqJoDqJf7"+\
			"cfa"+\
			"\t\t\t+Rr"+\
			"\t\t\t\t\t\tZ97f"+\
			"BL\n0PUnVz4k0e9SHdKfmPDV74jlfGamz069Ujd0I2+zhwCaPBtCX66zdnGqPJemAEYo\nvp+udu6M90TRzQy9tJRGuk30VGOX4xXZdQ983KkCgYBfVc4XnwJzuI0drn73CHHp\nuYfoFp9yzoNAVYjBV56W3B+tKPTP7Ku18tdzjP6oS7DTAF68Nnu7Lzp6kmBpWM/W\np5p0SX4277Raifck1TGoFIXdENgZ7AMoKieIpdfF5C"+\
			"E6D"+\
			"\t\t\t8tT"+\
			"\t\t\t\t\t\tDgB39"+\
			"8Z8f+alpeBy\nHrLCZDEuQDg7ARDO+sF+5wKBgQCCVsmCrwnpDJqb4lQwNSE9zRYHXPoTCoTKliIS\niuWqXZutMFAiHD2srIEdnsp7Y5qdG6ws5BbY7VfRGJlPq3VvC7J7LCX4T5Us+Z7I\nvo+UzH5oGYWfd1VKXMN5FxDQhU8CeEI9JkYD9Pt78sIJf8YSculLatEd1lsgGtkH\nTy3dyQKBgQDOkg7Lz4Qq1B1m+MHnatZlc"+\
			"Q4b"+\
			"\t\t\tHRm"+\
			"\t\t\t\t\t\tpRQ8u"+\
			"DCdwyWmn5Qg69k2KeX+w\nlMtmH52VqdqHW2Hj7wItqQcG5idAcQ6yH/d9GPMJvO0ji9+jdH/PYFF/P6Xk2aFp\nATP0hxCLVfWsBsE60e+OZoGrzeTaOwzn7kb+96Fi9m2FBp3n2UukbA==\n-----END RSA PRIVATE KEY-----"
		
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