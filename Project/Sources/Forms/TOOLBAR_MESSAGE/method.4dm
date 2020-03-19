  // ----------------------------------------------------
  // Form method : TOOLBAR_MESSAGE
  // ID[261FF4AD9CF548A59C0B7F3863C5E3F9]
  // Created 17-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_OBJECT:C1216($event)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------

Case of 
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Bound Variable Change:K2:52)
		
		Form:C1466.message:=OBJECT Get pointer:C1124(Object subform container:K67:4)->
		SET TIMER:C645(20)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		SET TIMER:C645(0)
		
		Form:C1466.message:=""
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 