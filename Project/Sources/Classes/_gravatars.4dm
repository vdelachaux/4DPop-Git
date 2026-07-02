// Shared singleton cache of gravatar pictures (md5(mail) -> Picture).
// Persists for the whole process, so avatars survive dialog re-opens: they are
// fetched once on the first update, then only new authors are added over time.

shared singleton Class constructor
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return the avatar for a mail, fetching it synchronously if not cached yet
Function avatar($mail : Text) : Picture
	
	var $t : Text:=Generate digest:C1147($mail; MD5 digest:K66:1)
	
	If (This:C1470[$t]=Null:C1517)
		
		This:C1470._request($t; $mail).wait()
		
	End if 
	
	return This:C1470[$t]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Preload a set of mails in parallel: fire all missing requests, then wait
	// once. Requests run concurrently, so total time is the slowest round-trip.
Function preload($mails : Collection)
	
	var $requests:=[]
	var $seen:={}
	var $mail : Text
	
	For each ($mail; $mails || [])
		
		var $t : Text:=Generate digest:C1147($mail; MD5 digest:K66:1)
		
		If (($seen[$t]#Null:C1517) | (This:C1470[$t]#Null:C1517))
			
			continue
			
		End if 
		
		$seen[$t]:=True:C214
		
		$requests.push(This:C1470._request($t; $mail))
		
	End for each 
	
	var $request : 4D:C1709.HTTPRequest
	For each ($request; $requests)
		
		$request.wait()
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Store a fetched picture (called from the async _gravatarRequest callbacks)
shared Function store($hash : Text; $picture : Picture)
	
	This:C1470[$hash]:=$picture
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Build and start an async request that will cache its result by hash
Function _request($hash : Text; $mail : Text) : 4D:C1709.HTTPRequest
	
	var $callback:=cs:C1710._gravatarRequest.new({hash: $hash; mail: $mail})
	
	return 4D:C1709.HTTPRequest.new("https://www.gravatar.com/avatar/"+$hash+"?d=404"; $callback)
	