property main : Integer
property rgb; hsl : Object
property css : Text

Class constructor($color)
	
	This:C1470.main:=0x0000
	This:C1470.hsl:=Null:C1517
	This:C1470.rgb:=Null:C1517
	This:C1470.css:=""
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		: (Value type:C1509($color)=Is object:K8:27)
			
			Case of 
					
					//______________________________________________________
				: ($color.red#Null:C1517)  // RGB Color
					
					This:C1470.setRGB($color)
					
					//______________________________________________________
				: ($color.hue#Null:C1517)  // HSL color
					
					This:C1470.setHSL($color)
					
					//______________________________________________________
				: ($color.color#Null:C1517)  // 4D Color
					
					This:C1470.setColor(Num:C11($color.color))
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215; "#ERROR")
					
					//______________________________________________________
			End case 
			
			//______________________________________________________
		: (Value type:C1509($color)=Is text:K8:3)  // CSS Color
			
			This:C1470.setCSS($color)
			
			//______________________________________________________
		: (Value type:C1509($color)=Is real:K8:4)\
			 | (Value type:C1509($color)=Is longint:K8:6)  // 4D Color
			
			This:C1470.setColor(Num:C11($color))
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Invalid type for the color parameter!")
			
			//______________________________________________________
	End case 
	
	//MARK:-[SETTERS]
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
	// 4D color expression
Function setColor($color : Integer) : cs:C1710.color
	
	This:C1470.main:=$color
	This:C1470.rgb:=This:C1470.colorToRGB($color)
	This:C1470.hsl:=This:C1470.colorToHSL($color)
	This:C1470.css:=This:C1470.colorToCSS($color)
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
	// 4RGB color from 4DPalette index (1-256)
Function setColorIndexed($color : Integer) : cs:C1710.color
	
	If (Asserted:C1132(($color>=1) & ($color<=256); "The index value must be between 1 & 256 !"))
		
		This:C1470.setCSS(JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).indexed[$color-1])
		
	End if 
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function colorPicker() : Integer
	
	This:C1470.main:=Select RGB color:C956(This:C1470.main)
	This:C1470.setColor(This:C1470.main)
	
	return This:C1470.main
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
	// RGB Color
Function setRGB($rgb : Object) : cs:C1710.color
	
	This:C1470.rgb:=$rgb
	This:C1470.main:=(This:C1470.rgb.red << 16)+(This:C1470.rgb.green << 8)+This:C1470.rgb.blue
	This:C1470.hsl:=This:C1470.colorToHSL(This:C1470.main)
	This:C1470.css:=This:C1470.colorToCSS(This:C1470.main)
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
	// HSL Color
Function setHSL($hsl : Object) : cs:C1710.color
	
	This:C1470.hsl:=$hsl
	This:C1470.rgb:=This:C1470.hslToRGB($hsl)
	This:C1470.main:=(This:C1470.rgb.red << 16)+(This:C1470.rgb.green << 8)+This:C1470.rgb.blue
	This:C1470.css:=This:C1470.colorToCSS(This:C1470.main)
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
	// HTML Color
Function setCSS($css : Text) : cs:C1710.color
	
	var $lightness; $r1; $r2; $saturation : Real
	var $t : Text
	var $blue; $green; $hue; $red : Integer
	var $o : Object
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	$o:=JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).named.query("name = :1"; $css).pop()
	
	Case of 
			
			//______________________________________________________
		: ($o#Null:C1517)  // Named color
			
			This:C1470.setRGB($o)
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)#[0-9abcdef]{6}"; $css; 1))  // #RRGGBB
			
			PROCESS 4D TAGS:C816("<!--#4dtext "+Replace string:C233($css; "#"; "0x")+"-->"; $t)
			This:C1470.setColor(Num:C11($t))
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)rgb\\s*\\(\\s*(\\d*)\\s*,\\s*(\\d*)\\s*,\\s*(\\d*)\\s*\\)"; $css; 1; $pos; $len))  // rgb(R,G,B)
			
			$red:=Num:C11(Substring:C12($css; $pos{1}; $len{1}))
			$green:=Num:C11(Substring:C12($css; $pos{2}; $len{2}))
			$blue:=Num:C11(Substring:C12($css; $pos{3}; $len{3}))
			This:C1470.setColor(($red << 16)+($green << 8)+$blue)
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)hsl\\s*\\(\\s*(\\d+)\\s*,\\s*(\\d+)%\\s*,\\s*(\\d+)%\\s*\\)"; $css; 1; $pos; $len))  // hsl(hue, saturation, lightness)
			
			$hue:=Num:C11(Substring:C12($css; $pos{1}; $len{1}))%360  //from 0 to 360°
			$lightness:=Num:C11(Substring:C12($css; $pos{2}; $len{2}))/100  //from 0 to 100%
			$saturation:=Num:C11(Substring:C12($css; $pos{3}; $len{3}))/100  //from 0 to 100%
			
			If ($saturation=0)  //HSL from 0 to 1
				
				$red:=$lightness*255  //RGB results from 0 to 255
				$green:=$lightness*255
				$blue:=$lightness*255
				
			Else 
				
				If ($lightness<0.5)
					
					$r2:=$lightness*(1+$saturation)
					
				Else 
					
					$r2:=($lightness+$saturation)-($saturation*$lightness)
					
				End if 
				
				$r1:=Abs:C99(2*($lightness-$r2))
				
				$red:=255*This:C1470._hueToRGB($r1; $r2; $hue+(1/3))
				$green:=255*This:C1470._hueToRGB($r1; $r2; $hue)
				$blue:=255*This:C1470._hueToRGB($r1; $r2; $hue-(1/3))
				
			End if 
			
			This:C1470.setColor(($red << 16)+($green << 8)+$blue)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(Structure file:C489=Structure file:C489(*); "Unknown color format or value: "+String:C10($css))
			// we have a not valid color (could return null but constructor could not failed and return null)
			
			//______________________________________________________
	End case 
	
	return (This:C1470)
	
	//MARK:-[CONVERTERS]
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function colorToRGB($color) : Object
	
	return (This:C1470._convertColor($color))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function colorToCSS($color : Integer; $type : Text)->$css
	
	var $blue; $green; $red : Integer
	
	$red:=(($color & 0x00FF0000) >> 16)
	$green:=(($color & 0xFF00) >> 8)
	$blue:=($color & 0x00FF)
	
	If (Count parameters:C259>=2)
		
		Case of 
				
				//______________________________________________________
			: ($type="components")
				
				$css:="rgb("\
					+String:C10($red)+","\
					+String:C10($green)+","\
					+String:C10($blue)+")"
				
				//______________________________________________________
			: ($type="percentages")
				
				$css:="rgb("+String:C10(Round:C94(($red*100)/255; 0); "&xml")+"%,"\
					+String:C10(Round:C94(($green*100)/255; 0); "&xml")+"%,"\
					+String:C10(Round:C94(($blue*100)/255; 0); "&xml")+"%)"
				
				//______________________________________________________
			: ($type="hex")
				
				var $hex : Text
				$hex:=Substring:C12(String:C10($color+0x01000000; "&x"); 5)
				$css:="#"+$hex[[1]]+$hex[[3]]+$hex[[5]]
				
				//______________________________________________________
			: ($type="hexLong")
				
				$css:="#"+Substring:C12(String:C10($color+0x01000000; "&x"); 5)
				
				//______________________________________________________
			: ($type="hsl")
				
				var $o : Object
				$o:=This:C1470.colorToHSL($color)
				$css:="hsl("+String:C10($o.hue)+","+String:C10($o.saturation)+"%,"+String:C10($o.lightness)+"%)"
				
				//______________________________________________________
			: ($type="named")
				
				$o:=JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).named.query("red = :1 AND green = :2 AND blue = :3"; $red; $green; $blue).pop()
				$css:=String:C10($o.name)
				
				//______________________________________________________
		End case 
		
	Else 
		
		$o:=JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).named.query("red = :1 AND green = :2 AND blue = :3"; $red; $green; $blue).pop()
		
		$css:=New object:C1471(\
			"components"; This:C1470.colorToCSS($color; "components"); \
			"percentages"; This:C1470.colorToCSS($color; "percentages"); \
			"hex"; This:C1470.colorToCSS($color; "hex"); \
			"hexLong"; This:C1470.colorToCSS($color; "hexLong"); \
			"hsl"; This:C1470.colorToCSS($color; "hsl"); \
			"name"; Choose:C955($o=Null:C1517; Null:C1517; $o.name)\
			)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function colorToHSL($color : Integer) : Object
	
	return (This:C1470._convertColor($color; "hsl"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hslToRGB($hsl : Object) : Object
	
	return (This:C1470._convertHSL($hsl; "rgb"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hslToColor($hsl : Object) : Integer
	
	return (This:C1470._convertHSL($hsl))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hslToCss($hsl : Object) : Text
	
	return (This:C1470._convertHSL($hsl; "css"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function rgbToColor($rgb : Object) : Integer
	
	return (This:C1470._convertRgb($rgb; "color"))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function rgbToHSL($rgb : Object) : Object
	
	return (This:C1470._convertRgb($rgb; "hsl"))
	
	//MARK:-[UTILITIES]
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getMatchingColors($kind : Integer)->$palette : Collection
	
	$palette:=New collection:C1472
	
	Case of 
			
			//________________________________________
		: ($kind=0)  // Complementary color (1)
			
			Case of 
					
					//………………………………………………………………………
				: (This:C1470.main=0x0000)  // Black
					
					$palette.push(0x00FFFFFF)
					
					//………………………………………………………………………
				: (This:C1470.main=0x00FFFFFF)  // White
					
					$palette.push(0x0000)
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue<=180)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+180; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				Else 
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-180; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
			End case 
			
			//________________________________________
		: ($kind=1)  // Complementary colors separated (2)
			
			Case of 
					
					//………………………………………………………………………
				: (This:C1470.main=0x0000)  // Black
					
					$palette.push(0x00FFFFFF)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue; \
						"saturation"; 50; \
						"lightness"; 100)))
					
					//………………………………………………………………………
				: (This:C1470.main=0x00FFFFFF)  // White
					
					$palette.push(0x0000)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue; \
						"saturation"; 50; \
						"lightness"; 100)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue<=150)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+150; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+210; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>150)\
					 & (This:C1470.hsl.hue<=210)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+150; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-150; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>210)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-150; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-210; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
			End case 
			
			//________________________________________
		: ($kind=2)  // Triadic complementary colors (2)
			
			Case of 
					
					//………………………………………………………………………
				: (This:C1470.main=0x0000)  // Black
					
					$palette.push(0x00FFFFFF)
					$palette.push(0x00D6D6D6)
					
					//………………………………………………………………………
				: (This:C1470.main=0x00FFFFFF)  // White
					
					$palette.push(0x0000)
					$palette.push(0x00929292)
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue<=120)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+120; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+240; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>120)\
					 & (This:C1470.hsl.hue<=240)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+120; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-120; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>240)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-120; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-240; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
			End case 
			
			//________________________________________
		: ($kind=3)  // Analogous colors (2)
			
			Case of 
					
					//………………………………………………………………………
				: (This:C1470.main=0x0000)  // Black
					
					$palette.push(0x00D6D6D6)
					$palette.push(0x00929292)
					
					//………………………………………………………………………
				: (This:C1470.main=0x00FFFFFF)  // White
					
					$palette.push(0x0000)
					$palette.push(0x00929292)
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue<=30)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+30; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; 360-(30-This:C1470.hsl.hue); \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>30)\
					 & (This:C1470.hsl.hue<=330)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+30; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-30; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>330)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-30; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-330; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
			End case 
			
			//________________________________________
		: ($kind=4)  // Monochromatic colors (3)
			
			$palette.push(This:C1470.hslToColor(New object:C1471(\
				"hue"; This:C1470.hsl.hue; \
				"saturation"; 100; \
				"lightness"; 50)))
			
			$palette.push(This:C1470.hslToColor(New object:C1471(\
				"hue"; This:C1470.hsl.hue; \
				"saturation"; 50; \
				"lightness"; 100)))
			
			$palette.push(This:C1470.hslToColor(New object:C1471(\
				"hue"; This:C1470.hsl.hue; \
				"saturation"; 90; \
				"lightness"; 40)))
			
			//________________________________________
		: ($kind=5)  // Tetradic complementary colors (4)
			
			Case of 
					
					//………………………………………………………………………
				: (This:C1470.main=0x0000)  // Black
					
					$palette.push(0x00FFFFFF)
					$palette.push(0x00D6D6D6)
					$palette.push(0x00929292)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue; \
						"saturation"; 50; \
						"lightness"; 100)))
					
					//………………………………………………………………………
				: (This:C1470.main=0x00FFFFFF)  // White
					
					$palette.push(0x0000)
					$palette.push(0x00929292)
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue<=45)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+225; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+315; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>45)\
					 & (This:C1470.hsl.hue<=135)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+225; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>135)\
					 & (This:C1470.hsl.hue<=90)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+225; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>135)\
					 & (This:C1470.hsl.hue<=225)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
				: (This:C1470.hsl.hue>225)
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue+45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-225; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-135; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					$palette.push(This:C1470.hslToColor(New object:C1471(\
						"hue"; This:C1470.hsl.hue-45; \
						"saturation"; This:C1470.hsl.saturation; \
						"lightness"; This:C1470.hsl.lightness)))
					
					//………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fontColor($backgroundColor; $green : Integer; $blue : Integer) : Text
	
	var $lightness : Real
	var $rgb : Object
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259=0)
			
			$rgb:=This:C1470.rgb
			
			//______________________________________________________
		: (Value type:C1509($backgroundColor)=Is real:K8:4)\
			 | (Value type:C1509($backgroundColor)=Is longint:K8:6)
			
			$rgb:=New object:C1471(\
				"red"; $backgroundColor; \
				"green"; 0; \
				"blue"; 0)
			
			If (Count parameters:C259>=2)
				
				$rgb.green:=$green
				
			End if 
			
			If (Count parameters:C259>=3)
				
				$rgb.blue:=$blue
				
			End if 
			
			//______________________________________________________
		Else 
			
			$rgb:=cs:C1710.color.new($backgroundColor).rgb
			
			//______________________________________________________
	End case 
	
	If ($rgb#Null:C1517)
		
		$lightness:=1-(((0.299*$rgb.red)+(0.587*$rgb.green)+(0.114*$rgb.blue))/255)
		return ($lightness<0.5 ? "black" : "white")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isValid() : Boolean
	
	return ((This:C1470.rgb#Null:C1517) & (This:C1470.hsl#Null:C1517) & (This:C1470.css#Null:C1517))
	
	//MARK:-[PRIVATES]
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _convertColor($color : Integer; $format : Text) : Variant
	
	var $alpha; $blue; $green; $red : Integer
	
	$format:=Length:C16($format)=0 ? "rgb" : $format  // Default is RGB
	
	$alpha:=255  // No alpha with 4D color
	$red:=($color & 0x00FF0000) >> 16
	$green:=($color & 0xFF00) >> 8
	$blue:=$color & 0x00FF
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($format="rgb")
			
			return (New object:C1471(\
				"alpha"; $alpha; \
				"red"; $red; \
				"green"; $green; \
				"blue"; $blue\
				))
			
			//………………………………………………………………………………………………………
		: ($format="hsl")
			
			return (This:C1470._rgb2Hsl($red; $green; $blue))
			
			//………………………………………………………………………………………………………
		: ($format="css")
			
			return ("rgb("+String:C10($red)+","\
				+String:C10($green)+","\
				+String:C10($blue)+")")
			
			//………………………………………………………………………………………………………
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _convertRgb($color : Object; $format : Text) : Variant
	
	var $rgb : Object
	
	$rgb:=Count parameters:C259>=1 ? $color : This:C1470.rgb
	$format:=Length:C16($format)=0 ? "color" : $format  // Default is 4D color
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($format="color")
			
			return ((Num:C11($rgb.alpha) << 24)+(Num:C11($rgb.red) << 16)+(Num:C11($rgb.green) << 8)+Num:C11($rgb.blue))
			
			//………………………………………………………………………………………………………
		: ($format="hsl")
			
			return (This:C1470._rgb2Hsl(Num:C11($rgb.red); Num:C11($rgb.green); Num:C11($rgb.blue)))
			
			//………………………………………………………………………………………………………
		: ($format="css")
			
			return ("rgb("+String:C10(Num:C11($rgb.red))+","+String:C10(Num:C11($rgb.green))+","+String:C10(Num:C11($rgb.blue))+")")
			
			//………………………………………………………………………………………………………
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _rgb2Hsl($r : Integer; $g : Integer; $b : Integer)->$value : Object
	
	var $blue; $green; $red : Real
	
	//in the interval [0, 1]
	$red:=Num:C11($r)*100/255
	$green:=Num:C11($g)*100/255
	$blue:=Num:C11($b)*100/255
	
	$value:=New object:C1471(\
		"hue"; 0; \
		"saturation"; 0; \
		"lightness"; 0\
		)
	
	Case of 
			
			//________________________________________
		: ($red=$blue)\
			 & ($blue=$green)  // Grey
			
			$value.lightness:=$blue
			
			//________________________________________
		: ($red>$green)\
			 & ($green=$blue)
			
			$value.lightness:=$red
			$value.saturation:=100*($value.lightness-$blue)/$value.lightness
			
			//________________________________________
		: ($red>$green)\
			 & ($green>$blue)
			
			$value.lightness:=$red
			$value.saturation:=100*($value.lightness-$blue)/$value.lightness
			
			// More the green increases, more the hue increases (1 to 59)
			$value.hue:=60*(($green-$blue)/($red-$blue))
			
			//________________________________________
		: ($green=$red)\
			 & ($red>$blue)
			
			$value.lightness:=$red
			$value.saturation:=100*($value.lightness-$blue)/$value.lightness
			$value.hue:=60
			
			//________________________________________
		: ($green>$red)\
			 & ($red>$blue)
			
			$value.lightness:=$green
			$value.saturation:=100*($value.lightness-$blue)/$value.lightness
			
			// More the red decreases, more the hue increases (61 to 119)
			$value.hue:=60+(60*(($green-$red)/($green-$blue)))
			
			//________________________________________
		: ($green>$blue)\
			 & ($blue=$red)
			
			$value.lightness:=$green
			$value.saturation:=100*($value.lightness-$red)/$value.lightness
			$value.hue:=120
			
			//________________________________________
		: ($green>$blue)\
			 & ($blue>$red)
			
			$value.lightness:=$green
			$value.saturation:=100*($value.lightness-$red)/$value.lightness
			
			// More the blue increases, more the hue increases (121 to 179)
			$value.hue:=120+(60*(($blue-$red)/($green-$red)))
			
			//________________________________________
		: ($blue=$green)\
			 & ($green>$red)
			
			$value.lightness:=$green
			$value.saturation:=100*($value.lightness-$red)/$value.lightness
			$value.hue:=180
			
			//________________________________________
		: ($blue>$green)\
			 & ($green>$red)
			
			$value.lightness:=$blue
			$value.saturation:=100*($value.lightness-$red)/$value.lightness
			
			// More the green decreases, more the hue increases (181 to 239)
			$value.hue:=180+(60*(($blue-$green)/($blue-$red)))
			
			//________________________________________
		: ($blue>$red)\
			 & ($red=$green)
			
			$value.lightness:=$blue
			$value.saturation:=100*($value.lightness-$green)/$value.lightness
			$value.hue:=240
			
			//________________________________________
		: ($blue>$red)\
			 & ($red>$green)
			
			$value.lightness:=$blue
			$value.saturation:=100*($value.lightness-$green)/$value.lightness
			
			// More the red increases, more the hue increases (241 to 299)
			$value.hue:=240+(60*(($red-$green)/($blue-$green)))
			
			//________________________________________
		: ($red=$blue)\
			 & ($blue>$green)
			
			$value.lightness:=$blue
			$value.saturation:=100*($value.lightness-$green)/$value.lightness
			
			//________________________________________
		: ($red>=$blue)\
			 & ($blue>=$green)
			
			$value.lightness:=$red
			$value.saturation:=100*($value.lightness-$green)/$value.lightness
			
			// More the blue decreases, more the hue increases (300 to 360)
			$value.hue:=300+(60*(($red-$blue)/($red-$green)))
			
			//________________________________________
	End case 
	
	$value.lightness:=Round:C94($value.lightness; 0)
	$value.saturation:=Round:C94($value.saturation; 0)
	$value.hue:=Round:C94($value.hue; 0)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _convertHSL($color : Object; $format : Text) : Variant
	
	var $blue; $green; $hue; $lightness; $max; $min; $offset; $red; $saturation : Integer
	var $hsl : Object
	
	$hsl:=Count parameters:C259>=1 ? $color : This:C1470.hsl
	$format:=Length:C16($format)=0 ? "color" : $format  // Default is 4D color
	
	If ($format#"css")
		
		$hue:=Num:C11($hsl.hue)%360  //0 to 360°
		$saturation:=Num:C11($hsl.saturation)  //0 to 100%
		$lightness:=Num:C11($hsl.lightness)  //0 to 100%
		
		$max:=$lightness*255/100  // RGB from  0 to 255
		$min:=$max*((100-$saturation)/100)
		$offset:=$max-$min
		
		Case of 
				
				//________________________________________
			: ($hue>=300)
				
				$red:=$max
				$green:=$min
				
				// Blue descending
				$blue:=Round:C94($max-($offset*(($hue-300)/60)); 0)
				
				//________________________________________
			: ($hue>=240)
				
				$blue:=$max
				$green:=$min
				
				// Red Crescent
				$red:=Round:C94($min+($offset*(($hue-240)/60)); 0)
				
				//________________________________________
			: ($hue>=180)
				
				$blue:=$max
				$red:=$min
				
				// Green descending
				$green:=Round:C94($max-($offset*(($hue-180)/60)); 0)
				
				//________________________________________
			: ($hue>=120)
				
				$green:=$max
				$red:=$min
				
				// Blue Crescent
				$blue:=Round:C94($min+($offset*(($hue-120)/60)); 0)
				
				//________________________________________
			: ($hue>=60)
				
				$green:=$max
				$blue:=$min
				
				// Red descending
				$red:=Round:C94($max-($offset*(($hue-60)/60)); 0)
				
				//________________________________________
			: ($hue>=0)
				
				$red:=$max
				$blue:=$min
				
				// Green Crescent
				$green:=Round:C94($min+($offset*($hue/60)); 0)
				
				//________________________________________
		End case 
		
	End if 
	
	Case of 
			
			//………………………………………………………………………………………………………
		: ($format="color")
			
			return (0+($red << 16)+($green << 8)+$blue)
			
			//………………………………………………………………………………………………………
		: ($format="rgb")
			
			return (New object:C1471(\
				"red"; $red; \
				"green"; $green; \
				"blue"; $blue))
			
			//………………………………………………………………………………………………………
		: ($format="css")
			
			return ("hsl("+String:C10($hsl.hue)+","\
				+String:C10($hsl.saturation)+"%,"\
				+String:C10($hsl.lightness)+"%)")
			
			//………………………………………………………………………………………………………
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _hueToRGB($v1 : Real; $v2 : Real; $vH : Real) : Integer
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($vH<0)
			
			$vH:=$vH+1
			
			//…………………………………………………………………………………………………
		: ($vH>1)
			
			$vH:=$vH-1
			
			//…………………………………………………………………………………………………
	End case 
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ((6*$vH)<1)
			
			return ($v1+(($v2-$v1)*6*$vH))
			
			//…………………………………………………………………………………………………
		: ((2*$vH)<1)
			
			return ($v2)
			
			//…………………………………………………………………………………………………
		: ((3*$vH)<2)
			
			return ($v1+(($v2-$v1)*((2/3)-$vH)*6))
			
			//…………………………………………………………………………………………………
		Else 
			
			return ($v1)
			
			//…………………………………………………………………………………………………
	End case 
	