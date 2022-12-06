//%attributes = {"invisible":true,"preemptive":"incapable"}
//var $i : Integer

//ARRAY LONGINT($windows; 0)

//WINDOW LIST($windows; *)

//For ($i; 1; Size of array($windows); 1)

//If (Get window title($windows{$i})="git") && (Window kind($windows{$i})=Floating window)

//CALL FORM($windows{$i}; Formula(EXECUTE METHOD IN SUBFORM("git"; Formula(SET TIMER(-1)))))

//break

//End if 
//End for 