// Shared singleton cache of the raw `git log` output used to build the commit
// list. Persists across dialog re-opens and is refreshed in the background by
// the _gitLogRefresh worker, so the UI shows the cached list instantly and the
// slow `git log` never freezes the interface.

property raw : Text:=""
property version : Integer:=0
property loading : Boolean:=False

shared singleton Class constructor
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Store a freshly fetched git log output and bump the version counter
shared Function store($raw : Text)
	
	// Bump the version only when the log actually changed, so consumers rebuild
	// the list only when needed (the periodic refresh polls without any change).
	If ($raw#This:C1470.raw)
		
		This:C1470.raw:=$raw
		This:C1470.version:=This:C1470.version+1
		
	End if 
	
	This:C1470.loading:=False
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Flag a background refresh as started (prevents concurrent workers)
shared Function setLoading()
	
	This:C1470.loading:=True
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Clear the loading flag without bumping the version (refresh failed/aborted)
shared Function abortLoading()
	
	This:C1470.loading:=False
