//%attributes = {"invisible":true,"preemptive":"incapable"}
var $i : Integer

ARRAY LONGINT:C221($windows; 0)

WINDOW LIST:C442($windows; *)

For ($i; 1; Size of array:C274($windows); 1)
	
	If (Get window title:C450($windows{$i})="git") && (Window kind:C445($windows{$i})=Floating window:K27:4)
		
		CALL FORM:C1391($windows{$i}; Formula:C1597(EXECUTE METHOD IN SUBFORM:C1085("git"; Formula:C1597(SET TIMER:C645(-1)))))
		
		break
		
	End if 
End for 