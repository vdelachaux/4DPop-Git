property enabled : Boolean
property delay; duration : Integer

Class constructor
	
	This:C1470[""]:={\
		default: {enabled: True:C214; delay: 45; duration: 720}; \
		backup: This:C1470.status}
	
	This:C1470.default()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Retain the current settings
Function backup()
	
	This:C1470[""].backup:=This:C1470.status
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Restore retained settings
Function restore()
	
	This:C1470._set(This:C1470[""].backup)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function default()
	
	This:C1470.enabled:=This:C1470[""].default.enabled
	This:C1470.delay:=This:C1470[""].default.delay
	This:C1470.duration:=This:C1470[""].default.duration
	
	This:C1470._set()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== 
Function get status() : Object
	
	return {\
		enabled: Get database parameter:C643(Tips enabled:K37:79)=1; \
		delay: Get database parameter:C643(Tips delay:K37:80); \
		duration: Get database parameter:C643(Tips duration:K37:81)}
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> 
Function set status($param : Object)
	
	This:C1470._set($param)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get enabled() : Boolean
	
	return Get database parameter:C643(Tips enabled:K37:79)=1
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> 
Function set enabled($enabled)
	
	This:C1470._set({enabled: $enabled})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// The default value is True, otherwise it can be an integer or a Boolean.
Function enable($enabled)
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			This:C1470._set({enabled: True:C214})
			
			//______________________________________________________
		: (Value type:C1509($enabled)=Is boolean:K8:9)
			
			This:C1470._set({enabled: $enabled})
			
			//______________________________________________________
		Else 
			
			This:C1470._set({enabled: Num:C11($enabled)#0})
			
			//______________________________________________________
	End case 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get disabled() : Boolean
	
	return Get database parameter:C643(Tips enabled:K37:79)=0
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function disable()
	
	This:C1470._set({enabled: False:C215})
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get delay() : Integer
	
	return Get database parameter:C643(Tips delay:K37:80)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> 
Function set delay($delay : Integer)
	
	This:C1470._set({delay: $delay})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function defaultDelay()
	
	This:C1470._set({delay: This:C1470[""].default.delay})
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get duration() : Integer
	
	return Get database parameter:C643(Tips duration:K37:81)
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> 
Function set duration($duration : Integer)
	
	This:C1470._set({duration: $duration})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function defaultDuration()
	
	This:C1470._set({duration: This:C1470[""].default.duration})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function instantly($duration : Integer)
	
	This:C1470._set({enabled: True:C214; delay: 1; duration: $duration})
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _set($param : Object)
	
	$param:=$param || {}
	$param.enabled:=$param.enabled || This:C1470.enabled
	$param.delay:=$param.delay || This:C1470.delay
	$param.duration:=$param.duration || This:C1470.duration
	
	SET DATABASE PARAMETER:C642(Tips enabled:K37:79; Num:C11($param.enabled))
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; Num:C11($param.delay))
	SET DATABASE PARAMETER:C642(Tips duration:K37:81; Num:C11($param.duration))
	