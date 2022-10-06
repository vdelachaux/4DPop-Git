Class constructor($title : Text)
	
	This:C1470.title:=""
	This:C1470.message:=""
	This:C1470.stopTitle:=""
	This:C1470.isForeground:=True:C214
	This:C1470.icon:=Null:C1517
	This:C1470.progress:=0
	This:C1470.stopEnabled:=False:C215
	This:C1470.stopped:=False:C215
	This:C1470.delay:=0
	This:C1470.start:=Tickcount:C458
	This:C1470.isVisible:=True:C214
	
	// Unfortunately there is no way to create an invisible progress
	
	//This.id:=Progress New
	var $id : Integer
	$id:=Progress New
	This:C1470.id:=$id
	
	If (Count parameters:C259>=1)
		
		This:C1470.setTitle($title)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function setDelay($tiks : Integer)->$this : cs:C1710.progress
	
	This:C1470.hide()
	
	This:C1470.delay:=$tiks
	This:C1470.start:=Tickcount:C458
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function update()
	
	If (Not:C34(This:C1470.isVisible))
		
		If ((Tickcount:C458-This:C1470.start)>This:C1470.delay)
			
			This:C1470.show()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function show($visible : Boolean; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.isVisible:=$visible
		
		If (Count parameters:C259>=2)
			
			This:C1470.isForeground:=$foreground
			
		End if 
		
	Else 
		
		This:C1470.isVisible:=True:C214
		
	End if 
	
	Progress SET WINDOW VISIBLE(This:C1470.isVisible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function bringToFront()->$this : cs:C1710.progress
	
	This:C1470.isForeground:=True:C214
	This:C1470.visible:=True:C214
	
	Progress SET WINDOW VISIBLE(This:C1470.visible; -1; -1; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hide()->$this : cs:C1710.progress
	
	This:C1470.show(False:C215)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function close()
	
	Progress QUIT(This:C1470.id)
	
	// === === === === === === === === === === === === === === === === === === ===
Function setTitle($title : Text)->$this : cs:C1710.progress
	
	var $t : Text
	
	If (Count parameters:C259>=1)
		
		$t:=$title
		
		If (Length:C16($title)>0)\
			 & (Length:C16($title)<=255)
			
			//%W-533.1
			If ($title[[1]]#Char:C90(1))
				
				$t:=Get localized string:C991($title)
				$t:=Choose:C955(Length:C16($t)>0; $t; $title)  // Revert if no localization
				
			End if 
			//%W+533.1
			
		End if 
		
	End if 
	
	This:C1470.title:=$t
	Progress SET TITLE(This:C1470.id; This:C1470.title)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setMessage($message : Text; $foreground : Boolean)->$this : cs:C1710.progress
	
	var $t : Text
	
	If (Count parameters:C259>=1)
		
		$t:=$message
		
		If (Length:C16($message)>0)\
			 & (Length:C16($message)<=255)
			
			//%W-533.1
			If ($message[[1]]#Char:C90(1))
				
				$t:=Get localized string:C991($message)
				$t:=Choose:C955(Length:C16($t)>0; $t; $message)  // Revert if no localization
				
			End if 
			//%W+533.1
			
		End if 
		
		If (Count parameters:C259>=2)
			
			This:C1470.isForeground:=$foreground
			
		End if 
	End if 
	
	This:C1470.message:=$t
	Progress SET MESSAGE(This:C1470.id; This:C1470.message; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setProgress($progress; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Value type:C1509($progress)=Is text:K8:3)
		
		Case of 
				
				//______________________________________________________
			: ($progress="barber@")\
				 | ($progress="undefined")
				
				This:C1470.progress:=-1
				
				//______________________________________________________
			Else 
				
				This:C1470.progress:=Num:C11($progress)
				
				//______________________________________________________
		End case 
		
	Else 
		
		This:C1470.progress:=Num:C11($progress)
		
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.isForeground:=$foreground
		
	End if 
	
	Progress SET PROGRESS(This:C1470.id; This:C1470.progress; This:C1470.message; This:C1470.isForeground)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setIcon($icon : Picture; $foreground : Boolean)->$this : cs:C1710.progress
	
	var $p : Picture
	
	If (Count parameters:C259>=1)
		
		$p:=$icon
		
	End if 
	
	This:C1470.icon:=$p
	
	If (Count parameters:C259>=2)
		
		Progress SET ICON(This:C1470.id; This:C1470.icon; $foreground)
		
	Else 
		
		Progress SET ICON(This:C1470.id; This:C1470.icon)
		
	End if 
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setPosition($x : Integer; $y : Integer; $foreground : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=2)
		
		This:C1470.x:=$x
		This:C1470.y:=$y
		
		If (Count parameters:C259>=3)
			
			This:C1470.isForeground:=$foreground
			
		End if 
		
		Progress SET WINDOW VISIBLE(This:C1470.visible; This:C1470.x; This:C1470.y; This:C1470.isForeground)
		
	Else 
		
		This:C1470.x:=$x
		Progress SET WINDOW VISIBLE(This:C1470.visible; This:C1470.x; -1; This:C1470.isForeground)
		
	End if 
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function showStop($show : Boolean)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.stopEnabled:=$show
		
	Else 
		
		// Default is True
		This:C1470.stopEnabled:=True:C214
		
	End if 
	
	Progress SET BUTTON ENABLED(This:C1470.id; This:C1470.stopEnabled)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function hideStop()->$this : cs:C1710.progress
	
	This:C1470.showStop(False:C215)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function setStopTitle($title : Text)->$this : cs:C1710.progress
	
	If (Count parameters:C259>=1)
		
		This:C1470.stopTitle:=$title
		
	Else 
		
		// Default is True
		This:C1470.stopTitle:="Stop"
		
	End if 
	
	Progress SET BUTTON TITLE(This:C1470.id; This:C1470.stopTitle)
	
	This:C1470.isStopped()
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function isStopped()->$stopped : Boolean
	
	This:C1470.stopped:=Progress Stopped(This:C1470.id)
	
	$stopped:=This:C1470.stopped
	
	// === === === === === === === === === === === === === === === === === === ===
Function forEach($target; $formula : Object; $keepOpen : Boolean)->$this : cs:C1710.progress
	
	var $i; $size : Integer
	var $v : Variant
	var $t : Text
	var $keep : Boolean
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($target)=Is collection:K8:32)
			
			This:C1470.setProgress(0)
			$size:=$target.length
			
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27)
			
			This:C1470.setProgress(0)
			
			$size:=OB Entries:C1720($target).length
			
			//______________________________________________________
		Else 
			
			This:C1470.setProgress(-1)  // Barber shop
			
			//______________________________________________________
	End case 
	
	If (This:C1470.stopEnabled)  // The progress has a Stop button
		
		This:C1470.stopped:=False:C215
		
		// As long as progress is not stopped...
		For each ($v; $target) While (Not:C34(This:C1470.stopped))
			
			This:C1470.update()
			
			If (Not:C34(This:C1470.isStopped()))
				
				$i:=$i+1
				$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
				
				If ($size#0)
					
					This:C1470.setProgress($i/$size)
					
				End if 
				
				If (Length:C16($t)>0)
					
					This:C1470.setMessage($t)
					
				End if 
				
			Else 
				
				// The user clicks on Stop
				This:C1470.hideStop()
				
			End if 
		End for each 
		
		
	Else 
		
		This:C1470.stopped:=False:C215
		
		For each ($v; $target)
			
			This:C1470.update()
			
			$i:=$i+1
			$t:=String:C10($formula.call(Null:C1517; $v; $target; $i))
			
			If ($size#0)
				
				This:C1470.setProgress($i/$size)
				
			End if 
			
			If (Length:C16($t)>0)
				
				This:C1470.setMessage($t)
				
			End if 
		End for each 
		
	End if 
	
	If (Count parameters:C259>=3)
		
		$keep:=$keepOpen
		
	End if 
	
	If ($keep)
		
		This:C1470.setProgress(-1).setMessage("")
		
	Else 
		
		This:C1470.close()
		
	End if 
	
	$this:=This:C1470