  // ----------------------------------------------------
  // Form method : GIT PATTERN
  // ID[F480A3B6285F424087B017C3B2CADCA1]
  // Created 11-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284($tPattern)
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		  // Adapt UI to localization
		button ("cancel").setCoordinates(Null:C1517;Null:C1517;button ("done").bestSize(Align right:K42:4).coordinates.left-20;Null:C1517).bestSize(Align right:K42:4)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Data Change:K2:15)\
		 | ($event.code=On After Edit:K2:43)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$tPattern:=Choose:C955(String:C10($event.objectName)="pattern";Get edited text:C655;String:C10(Form:C1466.pattern))
		
		  //#TO_DO: see if we can use git check-ignore
		
		  // Escape dot
		$tPattern:=Replace string:C233($tPattern;".";"\\.")
		
		  //The character "?" matches any one character except "/"
		$tPattern:=Replace string:C233($tPattern;"?";"[^/]")
		
		  // If there is a separator at the beginning or middle (or both) of the pattern,
		  // then the pattern is relative to the directory level of the particular .gitignore
		  // file itself. Otherwise the pattern may also match at any level below the
		  // .gitignore level.
		If (Choose:C955(Position:C15("/";$tPattern)=1;True:C214;Split string:C1554($tPattern;"/";sk ignore empty strings:K86:1).length>1))
			
			$tPattern:="^"+$tPattern
			
		End if 
		
		  // A leading "**" followed by a slash means match in all directories. For example,
		  // "**/foo" matches file or directory "foo" anywhere, the same as pattern "foo".
		  // "**/foo/bar" matches file or directory "bar" anywhere that is directly under
		  // directory "foo".
		If (Match regex:C1019("(?m-si)^\\^?\\*\\*/";$tPattern;1))
			
			$tPattern:=Delete string:C232(Replace string:C233($tPattern;"^";"";1);1;3)
			
		End if 
		
		  // A trailing "/**" matches everything inside. For example, "abc/**" matches all
		  // files inside directory "abc", relative to the location of the .gitignore file,
		  // with infinite depth.
		If (Match regex:C1019("(?m-si)/\\*\\*$";$tPattern;1))
			
			$tPattern:=Delete string:C232($tPattern;Length:C16($tPattern)-2;3)
			
		End if 
		
		  // A slash followed by two consecutive asterisks then a slash matches zero or more
		  // directories. For example, "a/**/b" matches "a/b", "a/x/b", "a/x/y/b" and so on.
		If (Position:C15("/**/";$tPattern)>0)
			
			$tPattern:=Replace string:C233($tPattern;"/**/";"/(?:.{0,}/){0,}")
			
		End if 
		
		  // An asterisk "*" matches anything except "/"
		$tPattern:=Replace string:C233($tPattern;"*";"[^/]*")
		
		Form:C1466.preview:=New collection:C1472
		
		For each ($o;Form:C1466.files)
			
			If ($tPattern[[1]]="!")
				
				If (Not:C34(Match regex:C1019($tPattern;$o.path;1)))
					
					Form:C1466.preview.push($o)
					
				End if 
				
			Else 
				
				If (Match regex:C1019($tPattern;$o.path;1))
					
					Form:C1466.preview.push($o)
					
				End if 
			End if 
		End for each 
		
		Form:C1466.preview:=Form:C1466.preview
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 