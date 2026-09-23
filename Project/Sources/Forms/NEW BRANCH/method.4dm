var $adjustGeometry:=False:C215
var $e:=FORM Event:C1606

Case of 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.me.onLoad()
		
		
		Form:C1466._buttons:=cs:C1710.ui.group.new()
		Form:C1466._ok:=cs:C1710.ui.button.new("ok").addToGroup(Form:C1466._buttons)
		cs:C1710.ui.button.new("cancel").addToGroup(Form:C1466._buttons)
		
		Form:C1466._buttons.distributeRigthToLeft()
		Form:C1466._ok.disable()
		
		Form:C1466.branchName:=cs:C1710.ui.input.new("Input").focus()
		cs:C1710.ui.input.new("Input2").truncateWithEllipsis(Align right:K42:4)
		$adjustGeometry:=True:C214
		
		// ______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		Form:C1466.me.onResize()
		
		return 
		
		// ______________________________________________________
	: ($e.code=On After Edit:K2:43)
		
		var $branch : Text:=Form:C1466.branchName.value
		var $valid:=(Length:C16($branch)>0)\
			 && (Position:C15(".."; $branch)=0) && (Position:C15("@{"; $branch)=0)\
			 && (Position:C15(" "; $branch)=0) && (Position:C15("~"; $branch)=0) && (Position:C15("^"; $branch)=0)\
			 && (Position:C15(":"; $branch)=0) && (Position:C15("?"; $branch)=0) && (Position:C15("*"; $branch)=0)\
			 && (Position:C15("["; $branch)=0) && (Position:C15("\\"; $branch)=0)\
			 && (Position:C15("//"; $branch)=0) && (Position:C15("/."; $branch)=0) && (Position:C15(".lock/"; $branch)=0)\
			 && ($branch[[1]]#"-") && ($branch[[1]]#"/") && ($branch[[Length:C16($branch)]]#".") && ($branch[[Length:C16($branch)]]#"/")\
			 && ((Length:C16($branch)<5) || (Substring:C12($branch; Length:C16($branch)-4)#".lock"))
		
		Form:C1466._ok.enable($valid)
		
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
				
				If (Form:C1466._ok.enabled)
					
					Form:C1466.newBranch:=True:C214
					Form:C1466.me.accept()
					
				End if 
				
				return 
				
				// ┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
		
		// ______________________________________________________
End case 

If ($adjustGeometry)
	
	var $height : Integer:=cs:C1710.ui.static.new("Group Box1").rect.height
	var $group:=cs:C1710.ui.group.new("Group Box1,Radio Button,Radio Button1,Radio Button2")
	
	If (Form:C1466.checkout)
		
		$group.show()
		Form:C1466._ok.title:="Create and checkout"
		Form:C1466._buttons.distributeRigthToLeft()
		
		If ($e.code=On Clicked:K2:4)
			
			Form:C1466._buttons.moveVertically($height)
			cs:C1710.ui.static.new("main").resizeVertically($height)
			
		End if 
		
	Else 
		
		$group.hide()
		Form:C1466._ok.title:="Create"
		Form:C1466._buttons.distributeRigthToLeft().moveVertically(-$height)
		cs:C1710.ui.static.new("main").resizeVertically(-$height)
		
	End if 
End if 