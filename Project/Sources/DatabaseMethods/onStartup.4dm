//%attributes = {}
If (Non:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($componentsArray; 0)
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
	End if 
End if 
