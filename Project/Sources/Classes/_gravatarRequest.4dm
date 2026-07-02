property method:="GET"
property body:=""
property headers:={}

property target : 4D:C1709.Function
property hash : Text
property mail : Text

Class constructor($info : Object; $target : 4D:C1709.Function)
	
	This:C1470.hash:=String:C10($info.hash)
	This:C1470.mail:=String:C10($info.mail)
	This:C1470.target:=$target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Gravatar answered. A 200 means the e-mail has an avatar; anything else
	// (a 404 thanks to "?d=404") triggers the GitHub then local-default fallback.
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	var $p : Picture
	
	If ($request.response.status=200)
		
		BLOB TO PICTURE:C682($request.response.body; $p)
		
	Else 
		
		$p:=This:C1470._fallback()
		
	End if 
	
	This:C1470._deliver($p)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Network/connection error: try GitHub, then the local default picture.
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	This:C1470._deliver(This:C1470._fallback())
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deliver the picture to the explicit callback or to the shared cache.
Function _deliver($p : Picture)
	
	If (This:C1470.target#Null:C1517)
		
		This:C1470.target.call(Null:C1517; $p)
		
	Else 
		
		cs:C1710._gravatars.me.store(This:C1470.hash; $p)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// GitHub avatar (GitHub "noreply" e-mails only); otherwise a Gravatar-generated
	// identicon (always available) so an avatar is never blank.
Function _fallback() : Picture
	
	var $p : Picture
	var $url : Text:=This:C1470._githubAvatarURL(This:C1470.mail)
	
	If (Length:C16($url)>0)
		
		$p:=This:C1470._fetch($url)
		
	End if 
	
	If (Picture size:C356($p)=0)
		
		$p:=This:C1470._fetch("https://www.gravatar.com/avatar/"+This:C1470.hash+"?d=identicon")
		
	End if 
	
	return $p
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Build the GitHub avatar URL from a "…@users.noreply.github.com" e-mail.
	// "ID+login@…" → avatars.githubusercontent.com/u/ID ; "login@…" → github.com/login.png
	// Returns "" when the e-mail is not a GitHub noreply address.
Function _githubAvatarURL($mail : Text) : Text
	
	If (Position:C15("@users.noreply.github.com"; $mail)=0)
		
		return ""
		
	End if 
	
	var $local : Text:=Substring:C12($mail; 1; Position:C15("@"; $mail)-1)
	var $c : Collection:=Split string:C1554($local; "+")
	
	If (($c.length>1) && (Match regex:C1019("^[0-9]+$"; $c[0])))
		
		return "https://avatars.githubusercontent.com/u/"+$c[0]
		
	End if 
	
	return "https://github.com/"+$c[$c.length-1]+".png"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Synchronous GET that follows a single redirect (github.com/<login>.png → CDN).
Function _fetch($url : Text) : Picture
	
	var $p : Picture
	var $request : 4D:C1709.HTTPRequest:=4D:C1709.HTTPRequest.new($url).wait()
	var $status : Integer:=Num:C11($request.response.status)
	
	If (($status=301) || ($status=302) || ($status=307) || ($status=308))
		
		var $location : Text:=String:C10($request.response.headers.Location || $request.response.headers.location)
		
		If (Length:C16($location)>0)
			
			$request:=4D:C1709.HTTPRequest.new($location).wait()
			$status:=Num:C11($request.response.status)
			
		End if 
	End if 
	
	If ($status=200)
		
		BLOB TO PICTURE:C682($request.response.body; $p)
		
	End if 
	
	return $p