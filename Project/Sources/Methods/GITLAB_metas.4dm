//%attributes = {"invisible":true}
$0:=New object:C1471

Case of 
		
		  //______________________________________________________
	: (This:C1470.status="??")\
		 | (This:C1470.status="A@")
		
		$0.fill:=Form:C1466.colors.new
		
		  //______________________________________________________
	: (This:C1470.status="@D@")
		
		$0.fill:=Form:C1466.colors.deleted
		
		  //______________________________________________________
	: (This:C1470.status="@M@")
		
		$0.fill:=Form:C1466.colors.modified
		
		  //______________________________________________________
	Else 
		
		  //$0.fill:="cornsilk"
		
		  //______________________________________________________
End case 