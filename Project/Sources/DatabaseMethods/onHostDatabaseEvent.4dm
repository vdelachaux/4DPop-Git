#DECLARE($event : Integer)

// ----------------------------------------------------
Case of 
		
		//________________________________________
	: ($event=On after host database startup:K74:4)
		
		// Launch the process of the palette
		$event:=New process:C317("GIT_PALLET"; 0; "$git"; *)
		
		//________________________________________
	: ($event=On before host database exit:K74:5)
		
		//
		
		//________________________________________
	: ($event=On after host database exit:K74:6)
		
		//
		
		//________________________________________
End case 