  // ----------------------------------------------------
  // Form method : ADD_PATTERN
  // ID[F480A3B6285F424087B017C3B2CADCA1]
  // Created 11-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284($tPattern)
C_OBJECT:C1216($event;$o)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($event.code=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Data Change:K2:15)\
		 | ($event.code=On After Edit:K2:43)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($event.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$tPattern:=Choose:C955(String:C10($event.objectName)="pattern";Get edited text:C655;String:C10(Form:C1466.pattern))
		$tPattern:=Replace string:C233($tPattern;".";"\\.")
		$tPattern:=Replace string:C233($tPattern;"*";".*")
		
		Form:C1466.preview:=New collection:C1472
		
		For each ($o;Form:C1466.files)
			
			If (Match regex:C1019($tPattern;$o.path;1))
				
				Form:C1466.preview.push($o)
				
			End if 
		End for each 
		
		Form:C1466.preview:=Form:C1466.preview
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$event.description+")")
		
		  //______________________________________________________
End case 