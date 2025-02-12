property isSubform:=False:C215
property toBeInitialized:=False:C215

// MARK:Delegates 📦
property form : cs:C1710.form
property pattern : cs:C1710.input
property preview : cs:C1710.listbox
property _footer : cs:C1710.group
property done; cancel; help : cs:C1710.button

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	This:C1470.form.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.pattern:=This:C1470.form.Input("pattern")
	This:C1470.preview:=This:C1470.form.Listbox("preview")
	
	This:C1470.help:=This:C1470.form.Button("help")
	
	This:C1470._footer:=This:C1470.form.group.new()
	This:C1470.done:=This:C1470.form.Button("done").addToGroup(This:C1470._footer)
	This:C1470.cancel:=This:C1470.form.Button("cancel").addToGroup(This:C1470._footer)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	If ($e.form)  // <== FORM METHOD
		
		Case of 
				
				// ______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				// ______________________________________________________
			: ($e.timer)
				
				This:C1470.form.update()
				
				// ______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				// ==============================================
			: (This:C1470.pattern.catch($e))
				
				This:C1470.form.update()
				
				// ==============================================
			: (This:C1470.help.catch($e))
				
				OPEN URL:C673("https: // Git-scm.com/docs/gitignore")
				
				// ==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470._footer.distributeRigthToLeft()
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $pattern : Text:=This:C1470.pattern.getValue()
	
	//#TO_DO: see if we can use git check-ignore
	
	// Escape dot
	$pattern:=Replace string:C233($pattern; "."; "\\.")
	
	//The character "?" matches any one character except "/"
	$pattern:=Replace string:C233($pattern; "?"; "[^/]")
	
	// If there is a separator at the beginning or middle (or both) of the pattern,
	// then the pattern is relative to the directory level of the particular .gitignore
	// file itself. Otherwise the pattern may also match at any level below the
	// .gitignore level.
	If (Position:C15("/"; $pattern)=1 ? True:C214 : Split string:C1554($pattern; "/"; sk ignore empty strings:K86:1).length>1)
		
		$pattern:="^"+$pattern
		
	End if 
	
	// A leading "**" followed by a slash means match in all directories. For example,
	// "**/foo" matches file or directory "foo" anywhere, the same as pattern "foo".
	// "**/foo/bar" matches file or directory "bar" anywhere that is directly under
	// directory "foo".
	If (Match regex:C1019("(?m-si)^\\^?\\*\\*/"; $pattern; 1))
		
		$pattern:=Delete string:C232(Replace string:C233($pattern; "^"; ""; 1); 1; 3)
		
	End if 
	
	// A trailing "/**" matches everything inside. For example, "abc/**" matches all
	// files inside directory "abc", relative to the location of the .gitignore file,
	// with infinite depth.
	If (Match regex:C1019("(?m-si)/\\*\\*$"; $pattern; 1))
		
		$pattern:=Delete string:C232($pattern; Length:C16($pattern)-2; 3)
		
	End if 
	
	// A slash followed by two consecutive asterisks then a slash matches zero or more
	// directories. For example, "a/**/b" matches "a/b", "a/x/b", "a/x/y/b" and so on.
	If (Position:C15("/**/"; $pattern)>0)
		
		$pattern:=Replace string:C233($pattern; "/**/"; "/(?:.{0,}/){0,}")
		
	End if 
	
	// An asterisk "*" matches anything except "/"
	$pattern:=Replace string:C233($pattern; "*"; "[^/]*")
	
	Form:C1466._preview:=[]
	
	var $file : 4D:C1709.File
	For each ($file; Form:C1466.files)
		
		If ($pattern[[1]]="!")
			
			If (Not:C34(Match regex:C1019($pattern; $file.path; 1)))
				
				Form:C1466._preview.push($file)
				
			End if 
			
		Else 
			
			If (Match regex:C1019($pattern; $file.path; 1))
				
				Form:C1466._preview.push($file)
				
			End if 
		End if 
	End for each 
	
	Form:C1466._preview:=Form:C1466._preview
	
	This:C1470.preview.touch()
	