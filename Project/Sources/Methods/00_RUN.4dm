//%attributes = {}
  // ----------------------------------------------------
  // Project method: 00_RUN
  // ID[52DD5F426D1647FF837AF213147FFC6B]
  // Created 4-3-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_PICTURE:C286($p)
C_TEXT:C284($Txt_entryPoint;$Txt_methodName)
C_OBJECT:C1216($o;$oForm)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(00_RUN ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //___________________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		$Txt_methodName:=Current method name:C684
		
		Case of 
				
				  //……………………………………………………………………
			: (Method called on error:C704=$Txt_methodName)
				
				  // Error handling manager
				
				  //……………………………………………………………………
			Else 
				
				BRING TO FRONT:C326(New process:C317($Txt_methodName;0;"$"+$Txt_methodName;"_run";*))
				
				  //……………………………………………………………………
		End case 
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		  // First launch of this method executed in a new process
		00_RUN ("_declarations")
		00_RUN ("_init")
		
		$oForm:=New object:C1471(\
			"project";File:C1566(Structure file:C489(*);fk platform path:K87:2);\
			"git";git ();\
			"unstaged";New collection:C1472;\
			"staged";New collection:C1472;\
			"commitSubject";"";\
			"commitDescription";""\
			)
		
		  // Selector definition
		$c:=New collection:C1472(\
			New object:C1471("label";Get localized string:C991("changes"));\
			New object:C1471(\
			"label";Get localized string:C991("allCommits")))
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/changes.png").platformPath;$p)
		TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
		$c[0].icon:=$p
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/commits.png").platformPath;$p)
		TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
		$c[1].icon:=$p
		
		$oForm.menu:=$c
		
		  // Methods definitions
		$o:=New object:C1471(\
			"update";Formula:C1597(SET TIMER:C645(-1));\
			"refresh";Formula:C1597(GITLAB_REFRESH );\
			"stage";Formula:C1597(GITLAB_EXECUTE ("stage"));\
			"stageAll";Formula:C1597(GITLAB_EXECUTE ("stageAll"));\
			"unstage";Formula:C1597(GITLAB_EXECUTE ("unstage"));\
			"discard";Formula:C1597(GITLAB_EXECUTE ("discard"));\
			"path";Formula:C1597(GITLAB_resolvePath );\
			"commit";Formula:C1597(GITLAB_EXECUTE (New object:C1471("action";"commit";"message";Form:C1466.commitSubject;"amend";Bool:C1537(Form:C1466.amend))))\
			)
		
		$oForm.ƒ:=$o
		
		  // Color definitions
		$oForm.colors:=New object:C1471(\
			"modified";"cornsilk";\
			"deleted";"mistyrose";\
			"new";"honeydew"\
			)
		
		$Win_hdl:=Open form window:C675("GITLAB";Plain form window:K39:10;Horizontally centered:K39:1;Vertically centered:K39:4;*)
		DIALOG:C40("GITLAB";$oForm)
		CLOSE WINDOW:C154
		
		00_RUN ("_deinit")
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_declarations")
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_init")
		
		$o:=menu \
			.append(":xliff:CommonMenuFile";menu .file())\
			.append(":xliff:CommonMenuEdit";menu .edit())
		
		  // If (Storage.database.isMatrix)
		  //file_Menu($o.ref)
		  //dev_Menu($o.ref)
		
		  // End if
		
		$o.setBar()
		
		  //___________________________________________________________
	: ($Txt_entryPoint="_deinit")
		
		RELEASE MENU:C978(Get menu bar reference:C979)
		
		  //___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point ("+$Txt_entryPoint+")")
		
		  //___________________________________________________________
End case 