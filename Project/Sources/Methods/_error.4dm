//%attributes = {"invisible":true}
#DECLARE($message : Text; $user : Object) : Object

var $error:={\
code: "UIwC"; \
deferred: True:C214; \
message: $message}

//TODO:Allow additional parameters in object

return $error