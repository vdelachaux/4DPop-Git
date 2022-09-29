//%attributes = {"invisible":true}
#DECLARE() : Object

If (False:C215)
	C_OBJECT:C1216(GIT Metas; $0)
End if 

Case of 
		
		//______________________________________________________
	: (This:C1470.status="??")\
		 | (This:C1470.status="A@")  // New (staged or not)
		
		return New object:C1471(\
			"fill"; Form:C1466.colors.new)
		
		//______________________________________________________
	: (This:C1470.status="@D@")  // Deleted (staged or not)
		
		return New object:C1471(\
			"fill"; Form:C1466.colors.deleted)
		
		//______________________________________________________
	: (This:C1470.status="RM")  // Moved
		
		//
		
		//______________________________________________________
	: (This:C1470.status="@M@")  // Modified
		
		return New object:C1471(\
			"fill"; Form:C1466.colors.modified)
		
		//  //______________________________________________________
		//: (This.status="D")  // Deleted (into commit)
		
		//$0.fill:=Form.colors.deleted
		
		//  //______________________________________________________
		//: (This.status="A")  // New (into commit)
		
		//$0.fill:=Form.colors.new
		
		//  //______________________________________________________
		//: (This.status="M")  // Modified (into commit)
		
		//$0.fill:=Form.colors.modified
		
		//______________________________________________________
	Else 
		
		return New object:C1471
		
		//______________________________________________________
End case 