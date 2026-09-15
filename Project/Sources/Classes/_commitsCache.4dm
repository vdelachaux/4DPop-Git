// Shared singleton cache of the built commit list (raw `git log` output +
// ready-to-display collection with graph/label pictures already computed).
// Both are built OFF the form process (in the _gitLogRefresh worker), so the
// UI shows the cached list instantly and neither `git log` nor the CPU-heavy
// graph/SVG rendering ever freezes the interface.

property raw : Text:=""
property builtCommits : Collection
property version : Integer:=0
property loading : Boolean:=False

shared singleton Class constructor
	
	This:C1470.builtCommits:=New shared collection:C1527
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// True when $raw differs from the cached log (cheap check, run BEFORE the
	// costly graph/SVG build so an unchanged periodic poll can skip it entirely)
Function hasChanged($raw : Text) : Boolean
	
	return ($raw#This:C1470.raw)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Store a freshly built commit list (raw log + ready collection) and bump the version
shared Function store($raw : Text; $commits : Collection)
	
	This:C1470.raw:=$raw
	
	// A plain (non-shared) collection can't be assigned/pushed as-is into a shared
	// object — each item must be OB Copy'd into THIS singleton's shared group first
	This:C1470.builtCommits:=New shared collection:C1527
	
	var $item : Object
	For each ($item; $commits)
		
		This:C1470.builtCommits.push(OB Copy:C1225($item; ck shared:K85:29; This:C1470))
		
	End for each 
	
	This:C1470.version:=This:C1470.version+1
	This:C1470.loading:=False
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Flag a background refresh as started (prevents concurrent workers)
shared Function setLoading()
	
	This:C1470.loading:=True
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Clear the loading flag without bumping the version (refresh failed/aborted/unchanged)
shared Function abortLoading()
	
	This:C1470.loading:=False
