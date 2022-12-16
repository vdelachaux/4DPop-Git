//%attributes = {"invisible":true,"preemptive":"incapable"}
var $i : Integer

ARRAY LONGINT:C221($windows; 0)

WINDOW LIST:C442($windows; *)

For ($i; 1; Size of array:C274($windows); 1)
	
	If (Get window title:C450($windows{$i})="git") && (Window kind:C445($windows{$i})=Floating window:K27:4)
		
		//CALL FORM($windows{$i}; Formula(EXECUTE METHOD IN SUBFORM("git"; Formula(SET TIMER(-1)))))
		CALL FORM:C1391($windows{$i}; Formula:C1597(EXECUTE METHOD IN SUBFORM:C1085("git"; "refresh")))
		
		break
		
	End if 
End for 