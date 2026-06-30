var $e:=FORM Event:C1606

Case of 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.me.onLoad()
		
		cs:C1710.group.new("ok,cancel").distributeRigthToLeft()
		
		// ______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466.me.onResize()
		
		// ______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="cancel")
				
				Form:C1466.me.cancel()
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="ok")
				
				Form:C1466.checkout:=True:C214
				Form:C1466.me.accept()
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		// ______________________________________________________
End case 