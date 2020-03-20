Class constructor

C_TEXT:C284($1)

This:C1470.name:=$1
This:C1470.type:=OBJECT Get type:C1300(*;This:C1470.name)

This:C1470.getCoordinates()

/*————————————————————————————————————————————————————————*/
Function getCoordinates  // Update widget coordinates

C_LONGINT:C283($bottom;$left;$right;$top)

OBJECT GET COORDINATES:C663(*;This:C1470.nam;$left;$top;$right;$bottom)

This:C1470._coordinates($left;$top;$right;$bottom)

/*————————————————————————————————————————————————————————*/
Function bestSize  // Resize the widget to its best size

C_OBJECT:C1216($1)
C_LONGINT:C283($bottom;$left;$right;$top)
C_LONGINT:C283($width;$height)

OBJECT GET COORDINATES:C663(*;This:C1470.name;$left;$top;$right;$bottom)

If ($1.maxWidth#Null:C1517)
	
	OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height;Num:C11($1.maxWidth))
	
Else 
	
	OBJECT GET BEST SIZE:C717(*;This:C1470.name;$width;$height)
	
End if 

If (Num:C11($1.minWidth)#0)
	
	$width:=Choose:C955($width<$1.minWidth;$1.minWidth;$width)
	
End if 

If (Num:C11($1.alignment)=Align right:K42:4)
	
	$left:=$right-$width
	
Else 
	
	  // Default is Align left
	$right:=$left+$width
	
End if 

OBJECT SET COORDINATES:C1248(*;This:C1470.name;$left;$top;$right;$bottom)

This:C1470._coordinates($left;$top;$right;$bottom)

/*————————————————————————————————————————————————————————*/
Function hide

OBJECT SET VISIBLE:C603(*;This:C1470.name;False:C215)

/*————————————————————————————————————————————————————————*/
Function show

OBJECT SET VISIBLE:C603(*;This:C1470.name;True:C214)

/*————————————————————————————————————————————————————————*/
Function setVisible

C_BOOLEAN:C305($1)

OBJECT SET VISIBLE:C603(*;This:C1470.name;$1)

/*————————————————————————————————————————————————————————*/
Function _coordinates

C_LONGINT:C283($1;$2;$3;$4)

This:C1470.coordinates:=New object:C1471(\
"left";$1;\
"top";$2;\
"right";$3;\
"bottom";$4;\
"width";$3-$1;\
"height";$4-$2)

CONVERT COORDINATES:C1365($1;$2;XY Current form:K27:5;XY Current window:K27:6)
CONVERT COORDINATES:C1365($3;$4;XY Current form:K27:5;XY Current window:K27:6)

This:C1470.windowCoordinates:=New object:C1471(\
"left";$1;\
"top";$2;\
"right";$3;\
"bottom";$4)