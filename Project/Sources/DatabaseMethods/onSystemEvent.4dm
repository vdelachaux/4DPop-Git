#DECLARE($event : Integer)

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($event=On application background move:K74:1)
		
		// Do something
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($event=On application foreground move:K74:2)
		
		update
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 