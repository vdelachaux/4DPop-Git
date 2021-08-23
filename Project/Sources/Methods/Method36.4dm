//%attributes = {}

var $url : Text
var $run : Boolean
var $cache; $lib; $o : Object
var $c : Collection
var $file; $fileCache; $filePreferences : 4D:C1709.File
var $package : 4D:C1709.Folder
var $http : cs:C1710.http

$filePreferences:=File:C1566("/PACKAGE/Preferences/4DPop Brew.settings")

If ($filePreferences.exists)
	
	$package:=Folder:C1567(fk database folder:K87:14)
	
	$http:=cs:C1710.http.new()
	
	$fileCache:=File:C1566("/PACKAGE/Preferences/4DPop Brew.cache")
	
	If ($fileCache.exists)
		
		$cache:=JSON Parse:C1218($fileCache.getText())
		
	Else 
		
		// First time
		$cache:=New object:C1471
		
	End if 
	
	For each ($lib; JSON Parse:C1218($filePreferences.getText()).sources)
		
		$http.success:=True:C214
		
		$c:=New collection:C1472
		
		Case of 
				
				//______________________________________________________
			: ($lib.server=Null:C1517)\
				 | (String:C10($lib.server)="github")
				
				$c.push("https://raw.githubusercontent.com")
				
				//______________________________________________________
			Else 
				
				// #ERROR : Unmanaged server
				$http.success:=False:C215
				
				//______________________________________________________
		End case 
		
		$c.push($lib.user)
		$c.push($lib.repository)
		
		Case of 
				
				//______________________________________________________
			: ($lib.branch=Null:C1517)\
				 | (String:C10($lib.branch)="master")
				
				$c.push("master")
				
				//______________________________________________________
			Else 
				
				$c.push($lib.branch)
				
				//______________________________________________________
		End case 
		
		Case of 
				
				//______________________________________________________
			: ($lib.type=Null:C1517)\
				 | (String:C10($lib.type)="class")
				
				$c.push("Project/Sources/Classes")
				
				//______________________________________________________
			Else 
				
				// #ERROR : Unmanaged type
				$http.success:=False:C215
				
				//______________________________________________________
		End case 
		
		$c.push($lib.name+".4dm")
		
		If ($http.success)
			
			$url:=$c.join("/")
			$http.reset($url)
			
			$file:=$package.file($c.remove(0; 4).join("/"))
			
			If ($cache[$url]#Null:C1517)\
				 & ($file.exists)
				
				// Is there any update?
				$run:=$http.newerRelease($cache[$url])
				
			Else 
				
				// Never downloaded or removed
				$run:=True:C214
				
			End if 
			
			If ($run)
				
				$http.setResponseType(Is a document:K24:1; $file)
				$http.get()
				
				If ($http.success)
					
					$o:=$http.headers.query("name = ETag").pop()
					
					If ($o#Null:C1517)
						
						$cache[$url]:=$o.value
						
					End if 
					
					$c:=$c.remove(0; $c.length)
					
					Case of 
							
							//______________________________________________________
						: ($lib.server=Null:C1517)\
							 | (String:C10($lib.server)="github")
							
							$c.push("https://raw.githubusercontent.com")
							
							//______________________________________________________
					End case 
					
					$c.push($lib.user)
					$c.push($lib.repository)
					
					Case of 
							
							//______________________________________________________
						: ($lib.branch=Null:C1517)\
							 | (String:C10($lib.branch)="master")
							
							$c.push("master")
							
							//______________________________________________________
						Else 
							
							$c.push($lib.branch)
							
							//______________________________________________________
					End case 
					
					Case of 
							
							//______________________________________________________
						: ($lib.type=Null:C1517)\
							 | (String:C10($lib.type)="class")
							
							$c.push("Documentation/Classes")
							
							//______________________________________________________
					End case 
					
					$c.push($lib.name+".md")
					
					$http.reset($c.join("/"))
					
					Case of 
							
							//______________________________________________________
						: ($lib.type="class")
							
							$file:=$package.file("Documentation/Classes/"+$lib.name+".md")
							
							//______________________________________________________
					End case 
					
					$http.setResponseType(Is a document:K24:1; $file)
					$http.get()
					
				Else 
					
					// #ERROR
					
				End if 
			End if 
			
		Else 
			
			// A "If" statement should never omit "Else"
			
		End if 
	End for each 
	
	$fileCache.setText(JSON Stringify:C1217($cache; *))
	
	RELOAD PROJECT:C1739
	BEEP:C151
	
End if 