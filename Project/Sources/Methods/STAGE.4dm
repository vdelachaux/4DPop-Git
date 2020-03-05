//%attributes = {}
C_OBJECT:C1216($o)

For each ($o;Form:C1466.selectedUnstaged)
	
	Form:C1466.git.add($o.path)
	
End for each 

Form:C1466.git.status()

Form:C1466.redraw()
Form:C1466.refresh()