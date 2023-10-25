Class constructor
	
	This:C1470.dataType:="text"
	This:C1470.data:=""
	This:C1470.dataError:=""
	
	This:C1470.currentDirectory:=Folder:C1567(fk database folder:K87:14)
	This:C1470.hideWindow:=True:C214
	
Function onResponse($worker : 4D:C1709.SystemWorker)
	
	//…
	
Function onData($worker : 4D:C1709.SystemWorker; $info : Object)
	
	This:C1470.data+=$info.data
	
	//…
	
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	
	This:C1470.dataError+=$info.data
	
Function onTerminate($worker : 4D:C1709.SystemWorker)
	
	var $textBody : Text
	
	If (Length:C16($worker.response)=0)
		
		$textBody:=$worker.responseError
		
	Else 
		
		$textBody:=$worker.response
		
	End if 
	
	
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _onEvent($worker : 4D.SystemWorker; $params : Object)
	
	//Case of 
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//: ($params.type="data")\
		 && ($worker.dataType="text")
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//: ($params.type="data")\
		 && ($worker.dataType="blob")
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//: ($params.type="error")
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//: ($params.type="termination")
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//: ($params.type="response")
	
	////┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	//End case 
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _onExecute($worker : 4D.SystemWorker; $params : Object)
	
	//If (This._commands.length=0)
	
	//This._abort()
	
	//Else 
	
	//This._execute()
	
	//End if 
	
	//If (OB Instance of(This._onResponse; 4D.Function))
	
	//This._onResponse.call(This; $worker; $params)
	
	//End if 
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _execute()
	
	//This._complete:=False
	//This._worker:=4D.SystemWorker.new(This._commands.shift(); This)
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _onComplete($worker : 4D.SystemWorker; $params : Object)
	
	//If (OB Instance of(This._onTerminate; 4D.Function))
	
	//This._onTerminate.call(This; $worker; $params)
	
	//End if 
	
	//If (This.complete)
	
	//This._terminate()
	
	//End if 
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _abort()
	
	//This._complete:=True
	//This._commands.clear()
	
	//// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Function _terminate()
	
	//This.onResponse:=This._onResponse
	//This.onTerminate:=This._onTerminate
	//This._worker:=Null