var $url : Text

$url:=WA Get current URL:C1025(*; "wa")

If ($url="https://github.com/login/device/success")
	
	// Autoclose
	SET TIMER:C645(60)
	
End if 