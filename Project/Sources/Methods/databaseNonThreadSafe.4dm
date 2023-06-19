//%attributes = {"invisible":true,"preemptive":"incapable"}
/*
Non-thread-safe commands to be called in a cooperative process
*/
#DECLARE($signal : 4D:C1709.Signal)

If (False:C215)
	C_OBJECT:C1216(databaseNonThreadSafe; $1)
End if 

var $t : Text
var $c : Collection

Case of 
		
		//mark:-init
	: ($signal.action=Null:C1517)
		
		Use ($signal)
			
			$c:=New collection:C1472
			ARRAY TEXT:C222($textArray; 0x0000)
			COMPONENT LIST:C1001($textArray)
			ARRAY TO COLLECTION:C1563($c; $textArray)
			$signal.components:=$c.copy(ck shared:K85:29; $signal)
			
			$c:=New collection:C1472
			ARRAY LONGINT:C221($IntegerArray; 0x0000)
			PLUGIN LIST:C847($IntegerArray; $textArray)
			ARRAY TO COLLECTION:C1563($c; $textArray)
			$signal.plugins:=$c.copy(ck shared:K85:29; $signal)
			
			$IntegerArray{0}:=Get database parameter:C643(User param value:K37:94; $t)
			
			If (Length:C16($t)>0)
				
				// Decode special entities
				$t:=Replace string:C233($t; "&amp;"; "&")
				$t:=Replace string:C233($t; "&lt;"; "<")
				$t:=Replace string:C233($t; "&gt;"; ">")
				$t:=Replace string:C233($t; "&apos;"; "'")
				$t:=Replace string:C233($t; "&quot;"; "\"")
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\{.*\\}$"; $t; 1))  // Json object
						
						$signal.parameters:=OB Copy:C1225(JSON Parse:C1218($t); ck shared:K85:29; $signal)
						
						//______________________________________________________
					: (Match regex:C1019("(?m-si)^\\[.*\\]$"; $t; 1))  // Json array
						
						$signal.parameters:=JSON Parse:C1218($t).copy(ck shared:K85:29; $signal)
						
						//______________________________________________________
					Else 
						
						$signal.parameters:=$t
						
						//______________________________________________________
				End case 
			End if 
		End use 
		
		//mark:-methods
	: ($signal.action="methods")
		
		ARRAY TEXT:C222($methods; 0x0000)
		METHOD GET NAMES:C1166($methods; $signal.filter="" ? "@" : $signal.filter; *)
		
		$c:=New shared collection:C1527
		
		Use ($c)
			
			ARRAY TO COLLECTION:C1563($c; $methods)
			
		End use 
		
		Use ($signal)
			
			$signal.methods:=$c.orderBy()
			
		End use 
		
		//mark:-methodAvailable
	: ($signal.action="methodAvailable")
		
		ARRAY TEXT:C222($methods; 0x0000)
		METHOD GET NAMES:C1166($methods; *)
		
		Use ($signal)
			
			$signal.available:=Find in array:C230($methods; $signal.name)>0
			
		End use 
		
		//mark:-setUserParam
	: ($signal.action="setUserParam")
		
		SET DATABASE PARAMETER:C642(User param value:K37:94; $signal.userParam)
		
		//mark:-restart
	: ($signal.action="restart")
		
		If ($signal.this.type="Server")
			
			If ($signal.options#Null:C1517)
				
				If ($signal.message#Null:C1517)
					
					RESTART 4D:C1292(Num:C11($signal.options); $signal.message)
					
				Else 
					
					RESTART 4D:C1292(Num:C11($signal.options))
					
				End if 
				
			Else 
				
				RESTART 4D:C1292
				
			End if 
			
		Else 
			
			If ($signal.options#Null:C1517)
				
				SET DATABASE PARAMETER:C642(User param value:K37:94; $signal.options)
				
			End if 
			
			OPEN DATABASE:C1321($signal.this.structureFile.platformPath)
			
		End if 
		
		//mark:-_restart
	: ($signal.action="_restart")
		
		var $root; $xml : Text
		var $result : Object
		var $file : 4D:C1709.File
		
		$result:=New object:C1471(\
			"success"; False:C215)
		
		$root:=DOM Create XML Ref:C861("database_shortcut")
		
		If (Bool:C1537(OK))
			
			XML SET OPTIONS:C1090($root; XML indentation:K45:34; XML with indentation:K45:35)
			
			DOM SET XML ATTRIBUTE:C866($root; \
				"structure_opening_mode"; 1+Num:C11(Bool:C1537($signal.compiled)); \
				"structure_file"; "file:///"+$signal.this.structureFile.path; \
				"data_file"; "file:///"+$signal.this.dataFile.path)
			
			If ($signal.userParam#Null:C1517)
				
				If (Value type:C1509($signal.userParam)=Is object:K8:27)\
					 | (Value type:C1509($signal.userParam)=Is collection:K8:32)
					
					DOM SET XML ATTRIBUTE:C866($root; \
						"user_param"; JSON Stringify:C1217($signal.userParam))
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($root; \
						"user_param"; String:C10($signal.userParam))
					
				End if 
			End if 
			
			DOM EXPORT TO VAR:C863($root; $xml)
			DOM CLOSE XML:C722($root)
			
			$file:=$signal.this.databaseFolder.file("restart.4DLink")
			$file.setText($xml)
			
			If ($file.exists)
				
				$result.success:=True:C214
				OPEN DATABASE:C1321(String:C10($file.platformPath))
				
			Else 
				
				$result.error:="Failed to create file: "+$file.path
				
			End if 
			
		Else 
			
			$result.error:="Failed to create XML Ref"
			
		End if 
		
		Use ($signal)
			
			$signal.result:=$result
			
		End use 
End case 

$signal.trigger()