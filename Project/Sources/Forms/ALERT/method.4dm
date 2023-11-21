var $e : Object
$e:=FORM Event:C1606

Case of 
		
		//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	: ($e.code=On Load:K2:1)
		
		Form:C1466.me.onLoad()
		
		//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	: ($e.code=On Resize:K2:27)
		
		Form:C1466.me.onResize()
		
		//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
End case 