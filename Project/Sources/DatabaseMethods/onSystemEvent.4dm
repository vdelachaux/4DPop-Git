//FIXME:Turn around compilator error
//#DECLARE($event : Integer)
C_LONGINT:C283($1)

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		//: ($event=On application background move)
	: ($1=On application background move:K74:1)
		
		// Do something
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		//: ($event=On application foreground move)
	: ($1=On application foreground move:K74:2)
		
		GIT UPDATE
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 