var $e:=FORM Event:C1606

Case of 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.me.onLoad()
		
		Form:C1466._buttons:=cs:C1710.ui.group.new()
		Form:C1466._ok:=cs:C1710.ui.button.new("ok").addToGroup(Form:C1466._buttons)
		cs:C1710.ui.button.new("cancel").addToGroup(Form:C1466._buttons)
		Form:C1466._buttons.distributeRigthToLeft()
		
		Form:C1466._options:=cs:C1710.ui.group.new("checkOutOptions,noChange,stashReaply,discard")
		
		var $o:=cs:C1710.ui.input.new("sha")
		$o.helpTip:=Form:C1466.at
		
		$o:=cs:C1710.ui.input.new("label")
		$o.helpTip:=Form:C1466.label
		$o.truncateWithEllipsis(Align right:K42:4)
		
		cs:C1710.ui.input.new("branchName").focus()
		
		// ______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466.me.onResize()
		
		return 
		
		// ______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: ($e.objectName="checkout")
				
				// <NOTHING MORE TO DO>
				
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
			Else 
				
				return 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		// ______________________________________________________
End case 

var $height : Integer:=cs:C1710.ui.static.new("checkOutOptions").rect.height

If (Form:C1466.checkout)
	
	Form:C1466._options.show()
	Form:C1466._ok.title:=Localized string:C991("createAndCheckout")
	Form:C1466._buttons.distributeRigthToLeft()
	
	If ($e.code=On Clicked:K2:4)
		
		Form:C1466._buttons.moveVertically($height)
		cs:C1710.ui.static.new("main").resizeVertically($height)
		
	End if 
	
Else 
	
	Form:C1466._options.hide()
	Form:C1466._ok.title:="Create"
	Form:C1466._buttons.distributeRigthToLeft().moveVertically(-$height)
	cs:C1710.ui.static.new("main").resizeVertically(-$height)
	
End if 