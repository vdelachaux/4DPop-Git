//%attributes = {"invisible":true}
var $name : Text:=OBJECT Get name:C1087
var $manager : Text:="_"+$name+"Manager"
var $instance : 4D:C1709.Class:=formGetInstance

If (Not:C34(OB Instance of:C1731($instance[$manager]; 4D:C1709.Function)))\
 && Match regex:C1019("(?m-si)_\\d*$"; $name; 1)  // A cs.onBoard subform ?
	
	var $c : Collection:=Split string:C1554($name; "_")
	$c.pop()  // Removes the last item
	$manager:="_"+$c.join("_")+"Manager"
	
	If (Not:C34(OB Instance of:C1731($instance[$manager]; 4D:C1709.Function)))
		
		// Restore
		$manager:="_"+$name+"Manager"
		
	End if 
End if 

If (OB Instance of:C1731($instance[$manager]; 4D:C1709.Function))
	
	$instance[$manager](FORM Event:C1606)
	
End if 