Class extends widget

property data : Object
property dataSource : Object

Class constructor($name : Text; $data; $page : Integer; $parent : Object)
	
	Super:C1705($name; $parent)
	
	This:C1470.dataSource:=$data
/*
💡 The widget "Variable or Expression" property mut be:
"formGetInstance.<name>.dataSource"
*/
	
	This:C1470.data:={}
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.isChoiceList)  // Using a choice list
			
			This:C1470.data.values:=[]
			
			var $i : Integer
			For ($i; 1; Count list items:C380($data); 1)
				
				GET LIST ITEM:C378($data; $i; $ref; $label)
				This:C1470.data.values.push($label)
				
			End for 
			
			//______________________________________________________
		: (This:C1470.isObject)  // Using an object
			
			Case of 
					
					//______________________________________________________
				: ($data.values=Null:C1517)
					
					This:C1470.data.values:=[]
					
					//______________________________________________________
				: (Value type:C1509($data.values)=Is collection:K8:32)
					
					This:C1470.data.values:=$data.values
					
					//______________________________________________________
				: (Value type:C1509($data.values)=Is text:K8:3)
					
					This:C1470.data.values:=[$data.values]
					
					//______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215; "Type not allowed for data.values!")
					
					//______________________________________________________
			End case 
			
			This:C1470.data.index:=Num:C11($data.index)
			
			//______________________________________________________
		Else 
			
			// We don't want manage legacy text array
			ASSERT:C1129(False:C215; "⛔️ The data parameter must be an Object or a Choice list")
			
			//______________________________________________________
	End case 
	
	This:C1470.pageNumber:=$page
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get pageRef() : Integer
	
	If (This:C1470.isChoiceList)
		
		var $itemeRef : Integer
		var $itemeText : Text
		GET LIST ITEM:C378(*; This:C1470.name; *; $itemeRef; $itemeText)
		return $itemeRef
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get pageNumber() : Integer
	
	return This:C1470.data.values.indexOf(This:C1470.data.currentValue)+1
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set pageNumber($page : Integer)
	
	// Map to 0 - collection.length-1
	$page-=1
	This:C1470.data.index:=$page>=0 ? $page : 0
	
	This:C1470.data.currentValue:=This:C1470.data.index<=This:C1470.data.values.length\
		 ? This:C1470.data.values[This:C1470.data.index]\
		 : ""
	
	If (This:C1470.isChoiceList)
		
		SELECT LIST ITEMS BY REFERENCE:C630(This:C1470.dataSource; $page+1)
		
	End if 
	
	If (Value type:C1509(OBJECT Get subform container value:C1785)#Is undefined:K8:13)  // Subform
		
		FORM GOTO PAGE:C247($page+1; *)
		
	Else 
		
		FORM GOTO PAGE:C247($page+1)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function goToPage()
	
	var $t : Text
	var $page : Integer
	
	If (This:C1470.isChoiceList)
		
		GET LIST ITEM:C378(*; This:C1470.name; *; $page; $t)
		
	Else 
		
		$page:=This:C1470.pageNumber
		
	End if 
	
	If (Value type:C1509(OBJECT Get subform container value:C1785)#Is undefined:K8:13)
		
		FORM GOTO PAGE:C247($page; *)
		
	Else 
		
		FORM GOTO PAGE:C247($page)
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get isChoiceList() : Boolean
	
	return ((Value type:C1509(This:C1470.dataSource)=Is longint:K8:6) || (Value type:C1509(This:C1470.dataSource)=Is real:K8:4))\
		 && (Is a list:C621(This:C1470.dataSource))
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get isObject() : Boolean
	
	return (Value type:C1509(This:C1470.dataSource)=Is object:K8:27)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function clearList()
	
	If (This:C1470.isChoiceList)
		
		CLEAR LIST:C377(This:C1470.dataSource; *)
		
	End if 