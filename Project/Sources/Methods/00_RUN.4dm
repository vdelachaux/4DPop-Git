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

C_LONGINT:C283($Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($t;$Txt_entryPoint;$Txt_methodName)
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
		
		$o:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
		
		OK:=Num:C11($o.folder(".git").exists)
		
		If (OK=0)
			
			While ($o#Null:C1517)\
				 & (OK=0)
				
				$o:=$o.parent
				
				If ($o#Null:C1517)
					
					OK:=Num:C11($o.folder(".git").exists)
					
				End if 
			End while 
			
			If (OK=0)
				
				CONFIRM:C162(Get localized string:C991("thisDatabaseIsNotUnderGitControl");Get localized string:C991("initializeTheGitRepository"))
				
			Else 
				
				CONFIRM:C162(Get localized string:C991("thisDatabaseIsUnderGitSourceControlButNotAtThisLevel"))
				
			End if 
		End if 
		
		If (Bool:C1537(OK))
			
			$oForm:=New object:C1471(\
				"window";Open form window:C675("GIT";Plain form window:K39:10;Horizontally centered:K39:1;Vertically centered:K39:4;*);\
				"project";File:C1566(Structure file:C489(*);fk platform path:K87:2);\
				"git";cs:C1710.Git.new();\
				"unstaged";New collection:C1472;\
				"staged";New collection:C1472;\
				"commitSubject";"";\
				"commitDescription";"";\
				"commits";New collection:C1472;\
				"commitDetail";New collection:C1472\
				)
			
			  // Template to use, only one for now
			$oForm.template:="default/"
			
			  // Page menu definition
			$c:=New collection:C1472(\
				New object:C1471("label";Get localized string:C991("changes"));\
				New object:C1471(\
				"label";Get localized string:C991("allCommits")))
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/"+$oForm.template+"changes.png").platformPath;$p)
			TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
			$c[0].icon:=$p
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/"+$oForm.template+"commits.png").platformPath;$p)
			TRANSFORM PICTURE:C988($p;Scale:K61:2;0.4;0.4)
			$c[1].icon:=$p
			
			$oForm.menu:=$c
			
			  // Preload icons
			$oForm.icons:=New object:C1471
			
			For each ($t;New collection:C1472("checked";"github";"gitLab";"branch";"branching";"master";"tag";"fix";"remote";"stash"))
				
				READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/"+$oForm.template+$t+".png").platformPath;$p)
				CREATE THUMBNAIL:C679($p;$p;20;20)
				$oForm.icons[Lowercase:C14($t)]:=$p
				
			End for each 
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/logo.png").platformPath;$p)
			$oForm.log:=$p
			
			  // Selector definition
			$oForm.selector:=New list:C375
			
			APPEND TO LIST:C376($oForm.selector;"Branches";-21;New list:C375;True:C214)
			$p:=$oForm.icons.branch
			SET LIST ITEM ICON:C950($oForm.selector;0;$p)
			
			APPEND TO LIST:C376($oForm.selector;"Remotes";-22;New list:C375;True:C214)
			$p:=$oForm.icons.remote
			SET LIST ITEM ICON:C950($oForm.selector;0;$p)
			
			APPEND TO LIST:C376($oForm.selector;"Tags";-23;New list:C375;True:C214)
			$p:=$oForm.icons.tag
			SET LIST ITEM ICON:C950($oForm.selector;0;$p)
			
			APPEND TO LIST:C376($oForm.selector;"Staches";-24;New list:C375;True:C214)
			$p:=$oForm.icons.stash
			SET LIST ITEM ICON:C950($oForm.selector;0;$p)
			
			SET LIST PROPERTIES:C387($oForm.selector;0;0;25)
			
			  // Methods definitions
			$o:=New object:C1471(\
				"refresh";Formula:C1597(SET TIMER:C645(-1));\
				"updateUI";Formula:C1597(GIT UI );\
				"stage";Formula:C1597(GIT ("stage"));\
				"stageAll";Formula:C1597(GIT ("stageAll"));\
				"unstage";Formula:C1597(GIT ("unstage"));\
				"discard";Formula:C1597(GIT ("discard"));\
				"path";Formula:C1597(GIT Path );\
				"commit";Formula:C1597(GIT (New object:C1471("action";"commit";"message";Form:C1466.commitSubject;"amend";Bool:C1537(Form:C1466.amend))))\
				)
			
			$oForm.ƒ:=$o
			
			  // Color definitions
			$oForm.colors:=JSON Parse:C1218(File:C1566("/RESOURCES/Images/"+$oForm.template+"manifest.json").getText()).colors
			
			DIALOG:C40("GIT";$oForm)
			CLOSE WINDOW:C154
			
			CLEAR LIST:C377($oForm.selector;*)
			
		Else 
			
			  // USER CANCELLATION 
			
		End if 
		
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