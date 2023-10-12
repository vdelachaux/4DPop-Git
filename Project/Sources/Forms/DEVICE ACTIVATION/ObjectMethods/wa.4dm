var $url : Text

$url:=WA Get current URL:C1025(*; "wa")

Case of 
		
		//______________________________________________________
	: ($url="https://github.com/login/device/success")
		
		// Autoclose
		SET TIMER:C645(60)
		
		//______________________________________________________
	: ($url="https://github.com/login/device/")
		
		INVOKE ACTION:C1439(ak paste:K76:55)
		
		//______________________________________________________
	: ($url="https://github.com/dashboard")
		
		CANCEL:C270
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 