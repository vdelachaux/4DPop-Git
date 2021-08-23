Class constructor($item)
	
	This:C1470.package:=Folder:C1567(fk database folder:K87:14; *)
	
	This:C1470.settings:=This:C1470.package.file("Preferences/4DPop Brew.settings")
	This:C1470.success:=This:C1470.settings.exists
	
	This:C1470.cache:=This:C1470.package.file("Preferences/4DPop Brew.cache")
	
	If (This:C1470.cache.exists)
		
		This:C1470.cacheContent:=JSON Parse:C1218(This:C1470.cache.getText())
		
	Else 
		
		// First time
		This:C1470.cacheContent:=New object:C1471
		
	End if 
	
	This:C1470.http:=cs:C1710.http.new()
	
	If (Count parameters:C259>=1)
		
		This:C1470.install($item)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function install($item)
	
	var $file : 4D:C1709.File
	var $run : Boolean
	var $o : Object
	
	Case of 
			//______________________________________________________
		: (Count parameters:C259>=1)  // Use the given url
			
			
			RELOAD PROJECT:C1739
			
			//______________________________________________________
		: (This:C1470.settings.exists)  // Use preferences
			
			For each ($item; JSON Parse:C1218(This:C1470.settings.getText()).sources)
				
				$file:=This:C1470._getFile($item)
				
				If (This:C1470.success)
					
					If (This:C1470.cacheContent[This:C1470.http.url]#Null:C1517)\
						 & ($file.exists)
						
						// Is there any update?
						$run:=This:C1470.http.newerRelease(This:C1470.cacheContent[This:C1470.http.url])
						
					Else 
						
						// Never downloaded or removed
						$run:=True:C214
						
					End if 
					
					If ($run)
						
						This:C1470.http.setResponseType(Is a document:K24:1; $file)
						This:C1470.http.get()
						
						If (This:C1470.http.success)
							
							$o:=This:C1470.http.headers.query("name = ETag").pop()
							
							If ($o#Null:C1517)
								
								This:C1470.cacheContent[This:C1470.http.url]:=$o.value
								
							End if 
							
							This:C1470.http.setResponseType(Is a document:K24:1; This:C1470._getDoc($item))
							This:C1470.http.get()
							
						End if 
					End if 
				End if 
			End for each 
			
			This:C1470.cache.setText(JSON Stringify:C1217(This:C1470.cacheContent; *))
			
			RELOAD PROJECT:C1739
			
			//______________________________________________________
		Else 
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function uninstall($item)
	
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function update($item)
	
	
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function cask($item)
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function outdated()->$items : Collection
	
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function create
	
	
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _getDoc($item : Object)->$file : 4D:C1709.File
	
	var $c : Collection
	
	$c:=New collection:C1472
	
	Case of 
			
			//______________________________________________________
		: ($item.server=Null:C1517)\
			 | (String:C10($item.server)="github")
			
			$c.push("https://raw.githubusercontent.com")
			
			//______________________________________________________
	End case 
	
	$c.push($item.user)
	$c.push($item.repository)
	
	Case of 
			
			//______________________________________________________
		: ($item.branch=Null:C1517)\
			 | (String:C10($item.branch)="master")
			
			$c.push("master")
			
			//______________________________________________________
		Else 
			
			$c.push($item.branch)
			
			//______________________________________________________
	End case 
	
	Case of 
			
			//______________________________________________________
		: ($item.type=Null:C1517)\
			 | (String:C10($item.type)="class")
			
			$c.push("Documentation/Classes")
			$file:=This:C1470.package.file("Documentation/Classes/"+$item.name+".md")
			
			//______________________________________________________
		: ($item.type="method")
			
			$c.push("Documentation/Methods")
			$file:=This:C1470.package.file("Documentation/Methods/"+$item.name+".md")
			
			//______________________________________________________
	End case 
	
	$c.push($item.name+".md")
	
	This:C1470.http.reset($c.join("/"))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _getFile($item : Object)->$file : 4D:C1709.File
	
	var $c : Collection
	
	$c:=New collection:C1472
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//______________________________________________________
		: ($item.server=Null:C1517)\
			 | (String:C10($item.server)="github")
			
			$c.push("https://raw.githubusercontent.com")
			
			//______________________________________________________
		Else 
			
			// #ERROR : Unmanaged server
			This:C1470.success:=False:C215
			
			//______________________________________________________
	End case 
	
	$c.push($item.user)
	$c.push($item.repository)
	
	Case of 
			
			//______________________________________________________
		: ($item.branch=Null:C1517)\
			 | (String:C10($item.branch)="master")
			
			$c.push("master")
			
			//______________________________________________________
		Else 
			
			$c.push($item.branch)
			
			//______________________________________________________
	End case 
	
	Case of 
			
			//______________________________________________________
		: ($item.type=Null:C1517)\
			 | (String:C10($item.type)="class")
			
			$c.push("Project/Sources/Classes")
			
			//______________________________________________________
		: ($item.type="method")
			
			$c.push("Project/Sources/Methods")
			
			//______________________________________________________
		Else 
			
			// #ERROR : Unmanaged type
			This:C1470.success:=False:C215
			
			//______________________________________________________
	End case 
	
	$c.push($item.name+".4dm")
	
	If (This:C1470.success)
		
		This:C1470.http.reset($c.join("/"))
		
		$file:=This:C1470.package.file($c.remove(0; 4).join("/"))
		
	End if 