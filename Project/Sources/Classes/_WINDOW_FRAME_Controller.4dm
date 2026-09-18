// MARK: Default values ⚙️
property isSubform:=True:C214
property toBeInitialized:=False:C215

property options:=0
property actionOnDoubleClick:="Maximize"

// MARK: Delegates 📦
property form : cs:C1710.ui.form

// MARK: Widgets 🧱
property drag; reduce; zoom; close : cs:C1710.ui.button

property closeMedia; reduceMedia; zoomMedia : cs:C1710.ui.static

// MARK: Other 💾
property isModal : Boolean
property proxyMacOS : Text:="path:/FORM/Images/macOS/"

Class constructor
	
	// MARK:-Delegates 📦
	This:C1470.form:=cs:C1710.ui.form.new(This:C1470; Try(JSON Parse:C1218(File:C1566("/SOURCES/Forms/"+Current form name:C1298+"/form.4DForm").getText())))
	
	This:C1470.isModal:=This:C1470.form.window.type=Modal dialog:K27:2
	
	If (Is Windows:C1573)
		
		// A double-click should toggle between maximizing the window and restoring the window
		// https://learn.microsoft.com/en/windows/apps/design/basics/titlebar-design
		
	Else 
		
		// The double-click action can be configured in the system preferences
		var $in; $out : Text
		LAUNCH EXTERNAL PROCESS:C811("defaults read NSGlobalDomain"; $in; $out)
		
		If (Bool:C1537(OK))
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			
			If (Match regex:C1019("(?mi-s)actionOnDoubleClick\\s*=\\s*([^;]*);"; $out; 1; $pos; $len))
				
				This:C1470.actionOnDoubleClick:=Substring:C12($out; $pos{1}; $len{1})
				
			End if 
		End if 
	End if 
	
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.drag:=This:C1470.form.Button("dragWindow")
	
	If (Is macOS:C1572)
		
		This:C1470.close:=This:C1470.form.Button("closeMac")
		This:C1470.reduce:=This:C1470.form.Button("minusMac")
		This:C1470.zoom:=This:C1470.form.Button("plusMac")
		
		This:C1470.closeMedia:=This:C1470.form.Static("closeMacIcon")
		This:C1470.reduceMedia:=This:C1470.form.Static("minusMacIcon")
		This:C1470.zoomMedia:=This:C1470.form.Static("plusMacIcon")
		
	Else 
		
		This:C1470.close:=This:C1470.form.Button("closeWin")
		This:C1470.reduce:=This:C1470.form.Button("minusWin")
		This:C1470.zoom:=This:C1470.form.Button("plusWin")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	// MARK:Form Method
	If ($e.objectName=Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.boundVariableChange)
				
				// ⚠️ The container must be of numeric type
				This:C1470.options:=OBJECT Get subform container value:C1785
				This:C1470.form.update()
				
				//______________________________________________________
			: ($e.timer)
				
				This:C1470.form.update()
				
				//______________________________________________________
			: ($e.activate) || ($e.deactivate)
				
				This:C1470.update()
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	// MARK: Widget Methods
	Case of 
			
			// The rollover animation is managed by the button icon, which has 4 states
			//______________________________________________________
		: (Is macOS:C1572 && $e.mouseEnter)
			
			If (Not:C34(This:C1470.closeDisabled))
				
				This:C1470.closeMedia.setPicture(This:C1470.proxyMacOS+"closeOver.png")
				
			End if 
			
			If (Not:C34(This:C1470.reduceDisabled))
				
				This:C1470.reduceMedia.setPicture(This:C1470.proxyMacOS+"minimizeOver.png")
				
			End if 
			
			If (Not:C34(This:C1470.zoomDisabled))
				
				This:C1470.zoomMedia.setPicture(This:C1470.proxyMacOS+(Is window maximized:C1830(This:C1470.form.window.ref) ? "zoomRestoreOver.png" : "zoomEnlargeOver.png"))
				
			End if 
			
			//______________________________________________________
		: (Is macOS:C1572 && $e.mouseLeave)
			
			If (Not:C34(This:C1470.closeDisabled))
				
				This:C1470.closeMedia.setPicture(This:C1470.proxyMacOS+(This:C1470.documentModified ? "closeModified.png" : "close.png"))
				
			End if 
			
			If (Not:C34(This:C1470.reduceDisabled))
				
				This:C1470.reduceMedia.setPicture(This:C1470.proxyMacOS+"minimize.png")
				
			End if 
			
			If (Not:C34(This:C1470.zoomDisabled))
				
				This:C1470.zoomMedia.setPicture(This:C1470.proxyMacOS+"zoom.png")
				
			End if 
			
			//______________________________________________________
		: (This:C1470.drag.catch($e))
			
			If ($e.doubleClick)
				
				Case of 
						
						//………………………………………………………………………………………………………………
					: (This:C1470.actionOnDoubleClick=Null:C1517)\
						 || (This:C1470.actionOnDoubleClick="none")
						
						// <NOTHING MORE TO DO>
						
						//………………………………………………………………………………………………………………
					: (This:C1470.actionOnDoubleClick="Minimize")
						
						If (Not:C34(This:C1470.reduceDisabled))
							
							This:C1470.form.window.reduce()
							
						End if 
						
						//………………………………………………………………………………………………………………
					: (This:C1470.actionOnDoubleClick="Maximize")
						
						This:C1470.miniaturiseOrNot()
						
						//………………………………………………………………………………………………………………
				End case 
				
			Else 
				
				This:C1470.form.window.drag()
				
			End if 
			
			//______________________________________________________
		: (This:C1470.close.catch($e))
			
			If (Not:C34(This:C1470.closeDisabled))
				
				CANCEL:C270
				
			End if 
			
			//______________________________________________________
		: (This:C1470.reduce.catch($e))
			
			If (Not:C34(This:C1470.reduceDisabled))
				
				This:C1470.form.window.reduce()
				
			End if 
			
			//______________________________________________________
		: (This:C1470.zoom.catch($e))
			
			This:C1470.miniaturiseOrNot()
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	If (Is macOS:C1572)
		
		If (This:C1470.form.window.isFrontmost())
			
			If (Not:C34(This:C1470.closeDisabled))
				
				This:C1470.closeMedia.setPicture(This:C1470.proxyMacOS+(This:C1470.documentModified ? "closeModified.png" : "close.png"))
				
			End if 
			
			If (Not:C34(This:C1470.reduceDisabled))
				
				This:C1470.reduceMedia.setPicture(This:C1470.proxyMacOS+"minimize.png")
				
			End if 
			
			If (Not:C34(This:C1470.zoomDisabled))
				
				This:C1470.zoomMedia.setPicture(This:C1470.proxyMacOS+"zoom.png")
				
			End if 
			
		Else 
			
			If (This:C1470.closeDisabled)
				
				This:C1470.closeMedia.setPicture(This:C1470.proxyMacOS+"disabled.png")
				
			Else 
				
				This:C1470.closeMedia.setPicture(This:C1470.proxyMacOS+(This:C1470.documentModified ? "disabledModified.png" : "disabled.png"))
				
			End if 
			
			This:C1470.zoomMedia.setPicture(This:C1470.proxyMacOS+"disabled.png")
			This:C1470.reduceMedia.setPicture(This:C1470.proxyMacOS+"disabled.png")
			
		End if 
		
	Else 
		
		If (This:C1470.form.window.isFrontmost())
			
			This:C1470.close.enable()
			This:C1470.reduce.enable(Not:C34(This:C1470.isModal))
			This:C1470.zoom.enable()
			
		Else 
			
			This:C1470.close.disable()
			This:C1470.reduce.disable()
			This:C1470.zoom.disable()
			
		End if 
	End if 
	
	This:C1470.form.callParent(On Load:K2:1)  // Resize
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get documentModified() : Boolean
	
	return This:C1470.options ?? 0
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get reduceDisabled() : Boolean
	
	return This:C1470.isModal | (This:C1470.options ?? 1)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get zoomDisabled() : Boolean
	
	return This:C1470.options ?? 2
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get closeDisabled() : Boolean
	
	return This:C1470.options ?? 3
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function miniaturiseOrNot()
	
	If (This:C1470.zoomDisabled)
		
		return 
		
	End if 
	
	If (Is window maximized:C1830(This:C1470.form.window.ref))
		
		This:C1470.form.window.minimize()
		
		If (Is Windows:C1573)
			
			This:C1470.zoom.setPicture("Images/Windows/maximize.png")
			
		End if 
		
	Else 
		
		This:C1470.form.window.maximize()
		
		If (Is Windows:C1573)
			
			This:C1470.zoom.setPicture("Images/Windows/restore.png")
			
		End if 
	End if 
	
	This:C1470.form.callParent(On Load:K2:1)  // Resize