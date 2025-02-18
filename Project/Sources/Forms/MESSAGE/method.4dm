// ----------------------------------------------------
// Form method : MESSAGE - (runtime)
// ID[4BD050041E3E42FCA067E2707D3CC9EC]
// Created #4-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $t : Text
var $bottom; $i; $left; $offset : Integer
var $right; $top; $type : Integer

var $e:=FORM Event:C1606
var $isWindows:=Is Windows:C1573 || ((Structure file:C489=Structure file:C489(*)) && Shift down:C543)
var $context:=String:C10(Form:C1466.type)

Case of 
		
		// ______________________________________________________
	: ($e.code=On Load:K2:1)
		
		If ((Structure file:C489=Structure file:C489(*)) && Macintosh option down:C545)
			
			OBJECT SET BORDER STYLE:C1262(*; "@"; Border Dotted:K42:29)
			
		End if 
		
		// MARK: Window title
		If (Form:C1466.title#Null:C1517)
			
			SET WINDOW TITLE:C213(String:C10(Form:C1466.title))
			
		End if 
		
		// MARK: Icons management
		Case of 
				
				// ______________________________________________________
			: (Form:C1466.icon#Null:C1517)  // Use the passed icon
				
				OBJECT SET VISIBLE:C603(*; "icon"; False:C215)
				OBJECT SET VISIBLE:C603(*; "userIcon"; True:C214)
				
				If ($isWindows)
					
					OBJECT MOVE:C664(*; "userIcon"; 15; 0; -15; -30)
					
				Else 
					
					If (Form:C1466.badge#Null:C1517)
						
						Case of 
								
								// …………………………………………………………………………………
							: ($isWindows)
								
								// …………………………………………………………………………………
							: (Form:C1466.badge="alert")
								
								OBJECT SET FORMAT:C236(*; "badge"; "|Images/alert.png")
								OBJECT SET VISIBLE:C603(*; "badge"; True:C214)
								
								// …………………………………………………………………………………
							Else 
								
								ASSERT:C1129(False:C215; "Unknown message badge type: \""+Form:C1466.badge+"\"")
								
								// …………………………………………………………………………………
						End case 
					End if 
				End if 
				
				// ______________________________________________________
			: ((Length:C16($context)=0)\
				 | ($context="info"))\
				 && (Not:C34($isWindows))
				
				// Set main icon according to the running 4D environment
				// 4D_SET_APPLICATION_ICON("icon")
				
				// ______________________________________________________
			: ($context="alert")\
				 | ($context="confirm")
				
				If ($isWindows)
					
					OBJECT SET FORMAT:C236(*; "icon"; "|Images/alert.png")
					
					// Reduce icon…
					OBJECT GET COORDINATES:C663(*; "icon"; $left; $top; $right; $bottom)
					OBJECT SET COORDINATES:C1248(*; "icon"; $left; $top; $right-30; $bottom-30)
					
					// … & move texts
					OBJECT MOVE:C664(*; "main"; -35; 0; 35)
					OBJECT MOVE:C664(*; "additional"; -35; 0; 35)
					OBJECT MOVE:C664(*; "comment"; -35; 0; 35)
					
				Else 
					
					// Set small application icon according to the running 4D environment
					// 4D_SET_APPLICATION_ICON("badge")
					OBJECT SET VISIBLE:C603(*; "badge"; True:C214)
					
				End if 
				
				// ______________________________________________________
			: ($context="noIcon")\
				 | ($isWindows)
				
				// Hide icon…
				OBJECT SET VISIBLE:C603(*; "icon"; False:C215)
				
				// … & move texts
				OBJECT MOVE:C664(*; "main"; -80; 0; 80)
				OBJECT MOVE:C664(*; "additional"; -80; 0; 80)
				OBJECT MOVE:C664(*; "comment"; -80; 0; 80)
				
				// ______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown message type: \""+$context+"\"")
				
				// ______________________________________________________
		End case 
		
		// Get current geometry
		Form:C1466._geometry:=New object:C1471
		
		For each ($t; New collection:C1472("main"; "additional"; "comment"))
			
			OBJECT GET COORDINATES:C663(*; $t; $left; $top; $right; $bottom)
			Form:C1466._geometry[$t]:=New object:C1471(\
				"left"; $left; \
				"top"; $top; \
				"right"; $right; \
				"bottom"; $bottom)
			
		End for each 
		
		// MARK: Texts sizes
		var $width : Integer:=Num:C11(Form:C1466._geometry.main.right)-Num:C11(Form:C1466._geometry.main.left)
		OBJECT GET BEST SIZE:C717(*; "main"; $width; $height; $width)
		
		If ($height>500)
			
			// Display vertical scrollbar
			var $height : Integer:=400
			OBJECT SET SCROLLBAR:C843(*; "main"; 0; 2)
			
		End if 
		
		$top:=Num:C11(Form:C1466._geometry.main.top)
		$bottom:=Num:C11(Form:C1466._geometry.main.bottom)
		
		If ($height>($bottom-$top))  // Resize if higher
			
			$offset:=($top+$height)-$bottom
			Form:C1466._geometry.main.bottom:=$bottom+$offset
			
			// Move the following widgets
			Form:C1466._geometry.additional.top:=Num:C11(Form:C1466._geometry.additional.top)+$offset
			Form:C1466._geometry.additional.bottom:=Num:C11(Form:C1466._geometry.additional.bottom)+$offset
			Form:C1466._geometry.comment.top:=Num:C11(Form:C1466._geometry.comment.top)+$offset
			Form:C1466._geometry.comment.bottom:=Num:C11(Form:C1466._geometry.comment.bottom)+$offset
			
		End if 
		
		If (Form:C1466.additional#Null:C1517)
			
			$width:=Num:C11(Form:C1466._geometry.additional.right)-Num:C11(Form:C1466._geometry.additional.left)
			OBJECT GET BEST SIZE:C717(*; "additional"; $width; $height; $width)
			
			$top:=Num:C11(Form:C1466._geometry.additional.top)
			$bottom:=Num:C11(Form:C1466._geometry.additional.bottom)
			
			If ($height>($bottom-$top))  // Resize if higher
				
				$offset+=(($top+$height)-$bottom)
				
				Form:C1466._geometry.additional.bottom:=$bottom+(($top+$height)-$bottom)+10
				
				// Move the following widgets
				$offset+=10
				Form:C1466._geometry.comment.top:=Num:C11(Form:C1466._geometry.comment.top)+$offset
				Form:C1466._geometry.comment.bottom:=Num:C11(Form:C1466._geometry.comment.bottom)+$offset
				
			End if 
		End if 
		
		If (Form:C1466.comment#Null:C1517)
			
			$offset+=$isWindows ? 10 : 30
			
			$width:=Num:C11(Form:C1466._geometry.comment.right)-Num:C11(Form:C1466._geometry.comment.left)
			OBJECT GET BEST SIZE:C717(*; "comment"; $width; $height; $width)
			
			$top:=Num:C11(Form:C1466._geometry.comment.top)
			$bottom:=Num:C11(Form:C1466._geometry.comment.bottom)
			
			If ($height>($bottom-$top))  // Resize if higher
				
				$top:=Form:C1466.additional#Null:C1517 ? Num:C11(Form:C1466._geometry.additional.bottom) : Num:C11(Form:C1466._geometry.comment.top)+10
				Form:C1466._geometry.comment.top:=$top
				
				$offset:=($top+$height)-$bottom+$offset
				
				Form:C1466._geometry.comment.bottom:=$bottom+(($top+$height)-$bottom)
				
			End if 
		End if 
		
		// MARK: Option button
		If (Bool:C1537(Form:C1466.buttons.option))
			
			OBJECT SET TITLE:C194(*; "option"; String:C10(Form:C1466.buttons.optionTitle))
			cs:C1710.button.new("option").bestSize(Align left:K42:2)
			
			If ($isWindows)
				
				// Disable automatic move
				OBJECT SET RESIZING OPTIONS:C1175(*; "option"; Resize horizontal none:K42:7; Resize vertical none:K42:10)
				
				// Define the position of the option button under the texts
				OBJECT GET COORDINATES:C663(*; "option"; $left; $top; $right; $bottom)
				$width:=$right-$left
				$height:=$bottom-$top
				
				$left:=Num:C11(Form:C1466._geometry.main.left)
				$top:=Form:C1466.comment#Null:C1517 ? \
					Num:C11(Form:C1466._geometry.comment.bottom) : \
					Form:C1466.additional#Null:C1517 ? \
					Num:C11(Form:C1466._geometry.additional.bottom) : \
					Num:C11(Form:C1466._geometry.main.bottom)
				$right:=$left+$width
				$bottom:=$top+$height
				
				Form:C1466._geometry.option:=New object:C1471(\
					"left"; $left; \
					"top"; $top; \
					"right"; $right; \
					"bottom"; $bottom)
				
				$offset+=20
				
			Else 
				
				OBJECT SET VISIBLE:C603(*; "option"; True:C214)
				
			End if 
		End if 
		
		// MARK: Buttons management
		var $c:=[]
		
		// MARK: Cancel button
		If (Bool:C1537(Form:C1466.buttons.cancel))\
			 | ($context="confirm")
			
			$c.push("cancel")
			
			If (Form:C1466.buttons.cancelTitle#Null:C1517)
				
				OBJECT SET TITLE:C194(*; "cancel"; String:C10(Form:C1466.buttons.cancelTitle))
				
			End if 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "cancel"; False:C215)
			
		End if 
		
		// MARK: Alternate button
		If (Bool:C1537(Form:C1466.buttons.alternate))
			
			$c.push("alternate")
			
			OBJECT SET TITLE:C194(*; "alternate"; String:C10(Form:C1466.buttons.alternateTitle))
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "alternate"; False:C215)
			
		End if 
		
		// MARK: OK button is always visible
		$c.push("ok")
		
		If (Form:C1466.buttons.okTitle#Null:C1517)
			
			OBJECT SET TITLE:C194(*; "ok"; String:C10(Form:C1466.buttons.okTitle))
			
		End if 
		
		// MARK: Resize the window if any
		If ($offset>0)
			
			var $winRef:=Current form window:C827
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
			SET WINDOW RECT:C444($left; $top; $right; $bottom+$offset; $winRef)
			
		End if 
		
		// MARK: Adjustments to suit the platform
		ARRAY TEXT:C222($entryOrders; 0x0000)
		ARRAY TEXT:C222($widgets; 0x0000)
		
		FORM GET OBJECTS:C898($widgets; Form current page:K67:6)
		
		// Get the entry order of the current page
		FORM GET ENTRY ORDER:C1469($entryOrders; *)
		
		If ($isWindows)
			
			OBJECT MOVE:C664(*; "ok"; 10; 8; 0; 1)
			OBJECT MOVE:C664(*; "cancel"; 10; 8; 0; 1)
			OBJECT MOVE:C664(*; "alternate"; 10; 8; 0; 1)
			
			If ($c.length>1)
				
				// Reverse the "ok" and "cancel" buttons
				OBJECT GET COORDINATES:C663(*; "ok"; $left; $top; $right; $bottom)
				OBJECT SET COORDINATES:C1248(*; "cancel"; $left; $top; $right; $bottom)
				
				var $indx:=Find in array:C230($entryOrders; "cancel")
				
				If ($indx>0)
					
					DELETE FROM ARRAY:C228($entryOrders; $indx)
					APPEND TO ARRAY:C911($entryOrders; "cancel")
					
				End if 
				
				$indx:=Find in array:C230($entryOrders; "ok")
				
				If ($indx#-1)
					
					DELETE FROM ARRAY:C228($entryOrders; $indx)
					
				End if 
				
				INSERT IN ARRAY:C227($entryOrders; 1)
				$entryOrders{1}:="ok"
				
				$c.push($c[0])
				$c.remove(0)
				
			End if 
			
		Else 
			
			If (Form:C1466.fullKeyboardAccess=Null:C1517)\
				 || (Form:C1466.fullKeyboardAccess)
				
				// <DEFAULT>
				
			Else 
				
				For ($i; 1; Size of array:C274($widgets); 1)
					
					$type:=OBJECT Get type:C1300(*; $widgets{$i})
					
					If ($type=Object type 3D button:K79:17)\
						 | ($type=Object type push button:K79:16)\
						 | ($type=Object type checkbox:K79:26)\
						 | ($type=Object type radio button:K79:23)\
						 | ($type=Object type popup dropdown list:K79:13)\
						 | ($type=Object type radio button field:K79:6)
						
						// Not focusable
						$indx:=Find in array:C230($entryOrders; $widgets{$i})
						
						If ($indx>0)
							
							DELETE FROM ARRAY:C228($entryOrders; $indx)
							
						End if 
					End if 
				End for 
			End if 
		End if 
		
		FORM SET ENTRY ORDER:C1468($entryOrders)
		
		cs:C1710.group.new($c.reverse().join(",")).distributeRigthToLeft({spacing: 13; minWidth: $isWindows ? 69 : 80})
		
		SET TIMER:C645(-1)
		
		// ______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		For each ($t; Form:C1466._geometry)
			
			OBJECT SET COORDINATES:C1248(*; $t; \
				Form:C1466._geometry[$t].left; \
				Form:C1466._geometry[$t].top; \
				Form:C1466._geometry[$t].right; \
				Form:C1466._geometry[$t].bottom)
			
			OBJECT SET VISIBLE:C603(*; $t; True:C214)
			
		End for each 
		
		OB REMOVE:C1226(Form:C1466; "_geometry")
		
		// ________________________________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		// ______________________________________________________
End case 