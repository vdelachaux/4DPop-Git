//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : progress
  // ID[2D47EE62E7C147DF9F00B5A80975A1E6]
  // Created 21-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i;$l)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_VARIANT:C1683($v)

If (False:C215)
	C_OBJECT:C1216(progress ;$0)
	C_TEXT:C284(progress ;$1)
	C_OBJECT:C1216(progress ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";"progress";\
		"name";$t;\
		"id";Progress New ;\
		"isStopped";False:C215;\
		"buttonTitle";"";\
		"icon";Null:C1517;\
		"message";"";\
		"progress";0;\
		"stop";False:C215;\
		"stopped";False:C215;\
		"title";"";\
		"visible";True:C214;\
		"bringToFront";Formula:C1597(progress ("foreground"));\
		"setStopTitle";Formula:C1597(progress ("setStopTitle";New object:C1471("value";String:C10($1))));\
		"close";Formula:C1597(progress ("close"));\
		"hide";Formula:C1597(progress ("hide"));\
		"hideStop";Formula:C1597(progress ("hideStop"));\
		"isStopped";Formula:C1597(progress ("isStopped").stopped);\
		"setIcon";Formula:C1597(progress ("setIcon";New object:C1471("icon";$1)));\
		"setMessage";Formula:C1597(progress ("setMessage";New object:C1471("value";String:C10($1);"foreground";Bool:C1537($2))));\
		"position";Formula:C1597(progress ("setPosition";New object:C1471("x";$1;"y";$2;"foreground";Bool:C1537($2))));\
		"setProgress";Formula:C1597(progress ("setProgress";New object:C1471("progress";$1)));\
		"setTitle";Formula:C1597(progress ("setTitle";New object:C1471("value";String:C10($1))));\
		"show";Formula:C1597(progress ("show";New object:C1471("foreground";Bool:C1537($1))));\
		"showStop";Formula:C1597(progress ("showStop"));\
		"forEach";Formula:C1597(progress ("forEach";New object:C1471("container";$1;"formula";$2;"keep";$3)))\
		)
	
	$o.progress:=Progress Get Progress ($o.id)
	
	If (Count parameters:C259>=1)
		
		$o.setTitle($1)
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="close")
			
			$o.stopped:=$o.isStopped()
			Progress QUIT ($o.id)
			
			  //______________________________________________________
		: ($1="isStopped")
			
			$o.stopped:=Progress Stopped ($o.id)
			
			  //______________________________________________________
		: ($1="setTitle")\
			 | ($1="setStopTitle")\
			 | ($1="setMessage")
			
			$t:=Get localized string:C991($2.value)
			
			If (Length:C16($t)>0)
				
				$2.value:=$t
				
			End if 
			
			Case of 
					
					  //--------------------------------
				: ($1="setTitle")
					
					$o.title:=$2.value
					Progress SET TITLE ($o.id;$2.value)
					
					  //--------------------------------
				: ($1="setStopTitle")
					
					$o.buttonTitle:=$2.value
					Progress SET BUTTON TITLE ($o.id;$2.value)
					
					  //--------------------------------
				: ($1="setMessage")
					
					$o.message:=$2.value
					Progress SET MESSAGE ($o.id;$2.value;$2.foreground)
					
					  //--------------------------------
			End case 
			
			  //______________________________________________________
		: ($1="setIcon")
			
			$o.icon:=$2.icon
			Progress SET ICON ($o.id;$2.icon)
			
			  //______________________________________________________
		: ($1="setProgress")
			
			If (Value type:C1509($2.progress)=Is text:K8:3)
				
				Case of 
						
						  //______________________________________________________
					: ($2.progress="barber@")
						
						$o.progress:=-1
						
						  //______________________________________________________
					Else 
						
						$o.progress:=Num:C11($2.progress)
						
						  //______________________________________________________
				End case 
				
			Else 
				
				$o.progress:=Num:C11($2.progress)
				
			End if 
			
			Progress SET PROGRESS ($o.id;$o.progress)
			
			  //______________________________________________________
		: ($1="setPosition")
			
			Progress SET WINDOW VISIBLE ($o.visible;Choose:C955($2.x=Null:C1517;-1;Num:C11($2.x));Choose:C955($2.y=Null:C1517;-1;Num:C11($2.y));$2.foreground)
			
			  //______________________________________________________
		: ($1="hide")
			
			$o.visible:=False:C215
			Progress SET WINDOW VISIBLE (False:C215)
			
			  //______________________________________________________
		: ($1="show")
			
			$o.visible:=True:C214
			Progress SET WINDOW VISIBLE (True:C214;-1;-1;$2.foreground)
			
			  //______________________________________________________
		: ($1="hideStop")
			
			$o.stop:=False:C215
			Progress SET BUTTON ENABLED ($o.id;False:C215)
			
			  //______________________________________________________
		: ($1="showStop")
			
			$o.stop:=True:C214
			Progress SET BUTTON ENABLED ($o.id;True:C214)
			
			  //______________________________________________________
		: ($1="foreground")
			
			$o.visible:=True:C214
			Progress SET WINDOW VISIBLE (True:C214;-1;-1;True:C214)
			
			  //______________________________________________________
		: ($1="forEach")
			
			Case of 
					
					  //______________________________________________________
				: (Value type:C1509($2.container)=Is collection:K8:32)
					
					$o.setProgress(0)
					$l:=$2.container.length
					
					  //______________________________________________________
				: (Value type:C1509($2.container)=Is object:K8:27)
					
					$o.setProgress(0)
					
					ARRAY TEXT:C222($tTxt_properties;0x0000)
					OB GET PROPERTY NAMES:C1232($2.container;$tTxt_properties)
					$l:=Size of array:C274($tTxt_properties)
					
					  //______________________________________________________
				Else 
					
					$o.setProgress(-1)  // Barber shop
					
					  //______________________________________________________
			End case 
			
			If (Progress Get Button Enabled ($o.id))
				
				  // The progress bar has a Stop button
				
				$o.stopped:=False:C215
				
				  // As long as progress is not stopped...
				For each ($v;$2.container) While (Not:C34($o.stopped))
					
					$o.isStopped()
					
					If (Not:C34($o.stopped))
						
						$i:=$i+1
						$t:=String:C10($2.formula.call(Null:C1517;$v;$2.container;$i))
						
						If ($l#0)
							
							$o.setProgress($i/$l)
							
						End if 
						
						If (Length:C16($t)>0)
							
							$o.setMessage($t)
							
						End if 
						
					Else 
						
						  // The user clicks on Stop
						$o.hideStop()
						
					End if 
				End for each 
				
			Else 
				
				$o.stopped:=False:C215
				
				For each ($v;$2.container)
					
					$i:=$i+1
					$t:=String:C10($2.formula.call(Null:C1517;$v;$2.container;$i))
					
					If ($l#0)
						
						$o.setProgress($i/$l)
						
					End if 
					
					If (Length:C16($t)>0)
						
						$o.setMessage($t)
						
					End if 
				End for each 
			End if 
			
			If (Bool:C1537($2.keep))
				
				$o.setProgress(-1).setMessage("")
				
			Else 
				
				$o.close()
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End