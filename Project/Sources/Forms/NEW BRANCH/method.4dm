var $e:=FORM Event:C1606

Case of 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.me.onLoad()
		Form:C1466._buttons:=cs:C1710.group.new()
		Form:C1466._ok:=cs:C1710.button.new("ok").addToGroup(Form:C1466._buttons)
		cs:C1710.button.new("cancel").addToGroup(Form:C1466._buttons)
		
		Form:C1466._buttons.distributeRigthToLeft()
		
		var $adjustGeometry:=True:C214
		
		cs:C1710.input.new("Input").focus()
		
		// ______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466.me.onResize()
		
		return 
		
		// ______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="checkout")
				
				$adjustGeometry:=True:C214
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="cancel")
				
				Form:C1466.me.cancel()
				
				return 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="ok")
				
				Form:C1466.newBranch:=True:C214
				Form:C1466.me.accept()
				
				return 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		// ______________________________________________________
End case 

If ($adjustGeometry)
	
	$adjustGeometry:=False:C215
	
	var $height : Integer:=cs:C1710.static.new("Group Box1").rect.height
	var $group:=cs:C1710.group.new("Group Box1,Radio Button,Radio Button1,Radio Button2")
	
	If (Form:C1466.checkout)
		
		$group.show()
		Form:C1466._ok.title:="Create and checkout"
		Form:C1466._buttons.distributeRigthToLeft()
		
		If ($e.code=On Clicked:K2:4)
			Form:C1466._buttons.moveVertically($height)
			cs:C1710.static.new("main").resizeVertically($height)
		End if 
		
	Else 
		
		$group.hide()
		Form:C1466._ok.title:="Create"
		Form:C1466._buttons.distributeRigthToLeft().moveVertically(-$height)
		cs:C1710.static.new("main").resizeVertically(-$height)
		
	End if 
End if 