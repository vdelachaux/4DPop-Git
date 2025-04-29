//FIXME:Turn around compilator error
#DECLARE($event : Integer)
//C_LONGINT($1)

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($event=On application background move:K74:1)
		//: ($1=On application background move)
		
		// Do something
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($event=On application foreground move:K74:2)
		//: ($1=On application foreground move)
		
		GIT UPDATE
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 