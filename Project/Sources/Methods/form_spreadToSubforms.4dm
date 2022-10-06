//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : form_spreadToSubforms
// ID[2EA9710049454153B1F0AF42D2215894]
// Created 15-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// 
// ----------------------------------------------------
// Declarations
#DECLARE($message : Object)

If (False:C215)
	C_OBJECT:C1216(form_spreadToSubforms; $1)
End if 

var $i : Integer
ARRAY TEXT:C222($widgets; 0)

// ----------------------------------------------------
EXECUTE METHOD:C1007($message.method)

FORM GET OBJECTS:C898($widgets)

For ($i; 1; Size of array:C274($widgets); 1)
	
	If (OBJECT Get type:C1300(*; $widgets{$i})=Object type subform:K79:40)
		
		If (Position:C15($message.target; $widgets{$i})=1)
			
			EXECUTE METHOD IN SUBFORM:C1085($widgets{$i}; $message.method)
			
		End if 
		
		EXECUTE METHOD IN SUBFORM:C1085($widgets{$i}; "form_spreadToSubforms"; *; $message)
		
	End if 
End for 