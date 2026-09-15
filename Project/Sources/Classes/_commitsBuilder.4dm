// Builds the ready-to-display commit collection (parsing + branch graph +
// label pictures) from a raw `git log` output. Designed to be used from the
// _gitLogRefresh BACKGROUND WORKER (not the dialog's form process): the
// per-commit graph/SVG rendering can take a while on a large history, and a
// process can't handle its own window's clicks while a method is running on
// it, so this heavy work must happen on a DIFFERENT process.

property darkScheme : Boolean
property icons : Object
property _tagCache : Object

// MARK: FEATURES
property _FEATURES:={\
displayStashInCommitList: True:C214\
}

Class constructor($darkScheme : Boolean)
	
	This:C1470.darkScheme:=$darkScheme
	This:C1470.icons:={}
	This:C1470._tagCache:={}
	
	This:C1470._loadIcons()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _loadIcons()
	
	var $key : Text
	var $icon : Picture
	var $dark : Text:=This:C1470.darkScheme ? "_dark" : ""
	
	For each ($key; ["tag"; "stash"])
		
		var $file:=File:C1566("/RESOURCES/Images/Main/"+$key+$dark+".svg")
		READ PICTURE FILE:C678($file.platformPath; $icon)
		This:C1470.icons[$key]:=$icon
		
	End for each 
	
	// GitHub octocat: load both variants explicitly (see _GIT_Controller._loadScheme
	// for why: media queries are ignored when rasterised via READ PICTURE FILE)
	$file:=File:C1566("/RESOURCES/Images/Main/github.svg")
	READ PICTURE FILE:C678($file.platformPath; $icon)
	This:C1470.icons.github:=$icon
	$file:=File:C1566("/RESOURCES/Images/Main/github_dark.svg")
	READ PICTURE FILE:C678($file.platformPath; $icon)
	This:C1470.icons.githubDark:=$icon
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Build the ready-to-display commit collection from a raw `git log` output
Function build($raw : Text; $git : cs:C1710.Git) : Collection
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	var $empty; $separator : Picture
	CREATE THUMBNAIL:C679($separator; $separator; 5)
	CREATE THUMBNAIL:C679($empty; $empty; 5)
	
	var $o:={\
		colors: ["orange"; "green"; "blue"; "red"]; \
		stashes: []\
		}
	
	var $notPushed : Integer:=$git.branchPushNumber($git.currentBranch)
	
	var $today:=Current date:C33
	var $yesterday : Date:=$today-1
	
/*
0 = message
1 = author name
2 = short sha
3 = time stamp
4 = sha
5 = parent short sha
6 = parent sha
7 = author mail
8 = shortened reflog
9 = ref names
*/
	
	// One commit per line
	var $commits:=[]
	var $line; $style : Text
	var $i : Integer
	
	For each ($line; Split string:C1554($raw; "\n"; sk ignore empty strings:K86:1))
		
		var $c:=Split string:C1554($line; "|")
		
		If (Match regex:C1019("index\\son\\s"; $line; 1; *))
			
			continue
			
		End if 
		
		If (Match regex:C1019("^untracked files"; $line; 1; *))
			
			continue
			
		End if 
		
		CLEAR VARIABLE:C89($style)
		
		var $tags:=[Null:C1517; Null:C1517; Null:C1517]
		
		$i+=1
		
		If ($i<=$notPushed)
			
			$tags[0]:={what: "toPush"}
			
		End if 
		
		var $metas:=$c.length>=10 ? Split string:C1554($c[9]; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2) : []
		
		If ($metas.length>0)
			
			var $meta : Text
			For each ($meta; $metas)
				
				Case of 
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="HEAD -> @")  // HEAD current branch
						
						$style:="bold"
						
						If ($metas.includes("origin/HEAD"))
							
							$tags[0]:={what: "origin"}
							
						End if 
						
						$tags[1]:={what: "current branch"; text: Replace string:C233($meta; "HEAD ->"; "")}
						
						var $branch : Text:=$git.workingBranch.name
						var $main:=$branch
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="tag: @")  // Tag
						
						$tags[2]:={what: "tag"; text: Replace string:C233($meta; "tag: "; "")}
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="origin/HEAD")  // Checked out branch
						
						If ($tags[0]#Null:C1517)\
							 | ($metas.includes("HEAD -> @"))
							
							continue
							
						End if 
						
						$tags[0]:={what: "origin"}
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="refs/stash")\
						 && (Match regex:C1019("(?mi-s)On\\s([^:]*):\\s(.*)"; $c[0]; 1; $pos; $len; *))
						
						If (Not:C34(Bool:C1537(This:C1470._FEATURES.displayStashInCommitList)))
							
							continue
							
						End if 
						
						var $stash:={\
							on: Substring:C12($c[0]; $pos{1}; $len{1}); \
							index: Split string:C1554($c[5]; " ")[1]; \
							ref: "stash@{"+String:C10($o.stashes.length)+"}"\
							}
						
						$tags[0]:={what: "stash"; text: $stash.ref}
						
						$o.stashes.push($stash)
						
						$c[0]:=Substring:C12($c[0]; $pos{2}; $len{2})
						
						$branch:=$stash.ref
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					: ($meta="origin/@")  // Origin branch
						
						If ($tags[0]#Null:C1517)
							
							continue
							
						End if 
						
						If ($metas.includes(Replace string:C233($meta; "origin/"; "")))
							
							$tags[0]:={what: "origin"}
							
						Else 
							
							$tags[0]:={what: "origin"; text: Replace string:C233($meta; "origin/"; "")}
							
						End if 
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
					Else   // Branch
						
						$branch:=$meta
						$tags[1]:={what: "branch"; text: $branch}
						
						//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
				End case 
			End for each 
			
		Else 
			
			$branch:=$main
			
		End if 
		
		var $date:=Try(Date:C102($c[3]))
		var $desc:=Split string:C1554($c[0]; "\r"; sk ignore empty strings:K86:1)
		
		If ($desc.length>1)
			
			$desc.shift()
			var $description:=$desc.join("\r")
			
		Else 
			
			$description:=""
			
		End if 
		
		// The label shows only the subject (first line); rendered after the graph is known
		var $title : Text:=$desc[0]
		
		Try($commits.push({\
			title: $title; \
			description: $description; \
			author: {name: $c[1]; mail: $c[7]; avatar: cs:C1710._gravatars.me.avatar($c[7])}; \
			stamp: ($date=$today ? Localized string:C991("today") : $date=$yesterday ? Localized string:C991("yesterday") : String:C10($date; 2))+", "+String:C10(Time:C179($c[3])+?00:00:00?); \
			fingerprint: {short: $c[2]; long: $c[4]}; \
			parent: {short: $c[5]; long: $c[6]}; \
			notPushed: $i<=$notPushed; \
			origin: $i=($notPushed+1); \
			branch: $branch; \
			date: $date; \
			time: $c[3]; \
			__tags: $tags; \
			__title: $title; \
			__bold: ($style="bold"); \
			__main: ($branch=$main)\
			}))
		
	End for each 
	
	$commits:=$commits.orderBy([\
		{propertyPath: "date"; descending: True:C214}; \
		{propertyPath: "time"; descending: True:C214}])
	
	// Mark:Branch graph
	// Assign lanes, then render each label (branch tags coloured to their lane) + graph
	This:C1470._computeGraph($commits)
	var $gc; $spec : Object
	var $graphPic; $lbl : Picture
	For each ($gc; $commits)
		
		$lbl:=$empty
		For each ($spec; $gc.__tags)
			If ($spec#Null:C1517)
				$lbl:=$lbl+This:C1470.getLabelTag($spec.what; String:C10($spec.text); {color: $gc.graph.color})+$separator
			End if 
		End for each 
		
		$graphPic:=This:C1470._graphPicture($gc.graph)
		$gc._:={normal: ($graphPic+$lbl+This:C1470.getLabelTag("title"; $gc.__title; {bold: $gc.__bold; main: $gc.__main})); selected: ($graphPic+$lbl+This:C1470.getLabelTag("title"; $gc.__title; {bold: $gc.__bold; selected: True:C214}))}
		$gc.label:=$gc._.normal
		
	End for each 
	
	return $commits
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Assign a lane (column) + colour to every commit so the list can draw a branch
	// graph. Commits must be in display order (a parent always comes after its
	// children). Fills each commit's `.graph` and returns the max number of lanes.
Function _computeGraph($commits : Collection) : Integer
	
	var $palette:=["#E8710A"; "#1E8E3E"; "#1A73E8"; "#D93025"; "#9334E6"; "#12A4AF"; "#7CB342"; "#F439A0"]
	var $lanes:=[]  // active lanes: {hash; color} (commit each lane routes to) or Null
	var $colorIndex; $cols; $node; $k; $j; $free; $used; $m; $idx : Integer
	var $color; $hash; $newColor : Text
	var $commit; $pc : Object
	var $parents; $above; $parentCols : Collection
	$cols:=1
	
	For each ($commit; $commits)
		
		$hash:=String:C10($commit.fingerprint.long)
		$parents:=Split string:C1554(String:C10($commit.parent.long); " "; sk ignore empty strings:K86:1)
		$above:=$lanes.copy()
		
		// The node sits in the first lane already routing to it (else a new lane)
		$node:=This:C1470._laneIndexOf($lanes; $hash)
		
		If ($node=-1)  // branch tip
			
			$node:=This:C1470._firstFreeLane($lanes)
			$color:=$palette[$colorIndex%$palette.length]
			$colorIndex+=1
			
		Else 
			
			$color:=$lanes[$node].color
			
		End if 
		
		// Close the other lanes that were routing to this commit (children merging in)
		For ($k; 0; $lanes.length-1)
			
			If (($k#$node) && ($lanes[$k]#Null:C1517) && ($lanes[$k].hash=$hash))
				
				$lanes[$k]:=Null:C1517
				
			End if 
		End for 
		
		// Route the parents downward and record the column each one lands in
		$parentCols:=[]
		If ($parents.length=0)  // root
			
			$lanes[$node]:=Null:C1517
			
		Else 
			
			$lanes[$node]:={hash: $parents[0]; color: $color}  // first parent continues the lane
			$parentCols.push({col: $node; color: $color})
			
			For ($j; 1; $parents.length-1)  // extra parents (merge)
				
				$idx:=This:C1470._laneIndexOf($lanes; $parents[$j])
				
				If ($idx=-1)
					
					$free:=This:C1470._firstFreeLane($lanes)
					$newColor:=$palette[$colorIndex%$palette.length]
					$colorIndex+=1
					$lanes[$free]:={hash: $parents[$j]; color: $newColor}
					$parentCols.push({col: $free; color: $newColor})
					
				Else 
					
					$parentCols.push({col: $idx; color: $lanes[$idx].color})
					
				End if 
			End for 
			
		End if 
		
		// Width actually used on this row (highest lane), for a tight layout
		$used:=$node+1
		For ($m; 0; $above.length-1)
			If (($above[$m]#Null:C1517) && (($m+1)>$used))
				$used:=$m+1
			End if 
		End for 
		For each ($pc; $parentCols)
			If (($pc.col+1)>$used)
				$used:=$pc.col+1
			End if 
		End for each 
		
		If ($used>$cols)
			$cols:=$used
		End if 
		
		$commit.graph:={hash: $hash; col: $node; color: $color; width: $used; above: $above; parentCols: $parentCols}
		
	End for each 
	
	return $cols
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// First lane routing to $hash, or -1
Function _laneIndexOf($lanes : Collection; $hash : Text) : Integer
	
	var $k : Integer
	For ($k; 0; $lanes.length-1)
		
		If (($lanes[$k]#Null:C1517) && ($lanes[$k].hash=$hash))
			
			return $k
			
		End if 
	End for 
	
	return -1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// First free lane index (extends the collection if none)
Function _firstFreeLane($lanes : Collection) : Integer
	
	var $k : Integer
	For ($k; 0; $lanes.length-1)
		
		If ($lanes[$k]=Null:C1517)
			
			return $k
			
		End if 
	End for 
	
	$lanes.push(Null:C1517)
	
	return $lanes.length-1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Horizontal centre of a lane column
Function _laneX($col : Integer; $w : Integer) : Real
	
	return ($col*$w)+($w/2)+1
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Render the branch-graph picture for one commit row
Function _graphPicture($graph : Object) : Picture
	
	var $dark : Boolean:=This:C1470.darkScheme
	var $w; $h; $node; $k : Integer
	var $mid; $r : Real
	var $pc : Object
	var $above : Collection
	var $svg : cs:C1710.svgx.svg
	$w:=12
	$h:=23
	$mid:=11.5
	$r:=3
	$svg:=cs:C1710.svgx.svg.new()
	$svg.width(($graph.width*$w)+2).height($h)
	$above:=$graph.above
	$node:=$graph.col
	
	// Lines coming from the row above
	For ($k; 0; $above.length-1)
		
		If ($above[$k]=Null:C1517)
			continue
		End if 
		
		If ($above[$k].hash=$graph.hash)  // a child converges into this node
			
			$svg.line(This:C1470._laneX($k; $w); 0; This:C1470._laneX($node; $w); $mid).stroke({color: $above[$k].color; width: 2})
			
		Else   // the lane passes straight through
			
			$svg.line(This:C1470._laneX($k; $w); 0; This:C1470._laneX($k; $w); $h).stroke({color: $above[$k].color; width: 2})
			
		End if 
	End for 
	
	// Lines going down to the parents
	For each ($pc; $graph.parentCols)
		
		$svg.line(This:C1470._laneX($node; $w); $mid; This:C1470._laneX($pc.col; $w); $h).stroke({color: $pc.color; width: 2})
		
	End for each 
	
	// Commit node
	$svg.circle($r; This:C1470._laneX($node; $w); $mid).fill($graph.color).stroke({color: ($dark ? "black" : "white"); width: 1})
	
	return $svg.picture()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getLabelTag($what : Text; $text : Text; $style : Object) : Picture
	
	This:C1470._tagCache:=This:C1470._tagCache || {}
	
	// "title" is unique per commit → not cached (avoids unbounded cache growth)
	If ($what="title")
		
		return This:C1470._renderLabelTag($what; $text; $style)
		
	End if 
	
	var $key : Text:=$what+Char:C90(1)+String:C10($text)+Char:C90(1)+String:C10($style.color)+Char:C90(1)+String:C10(Num:C11(This:C1470.darkScheme))
	This:C1470._tagCache[$key]:=This:C1470._tagCache[$key] || This:C1470._renderLabelTag($what; $text; $style)
	
	return This:C1470._tagCache[$key]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _renderLabelTag($what : Text; $text : Text; $style : Object) : Picture
	
	var $dark : Boolean:=This:C1470.darkScheme
	var $svg:=cs:C1710.svgx.svg.new()
	var $col : Text:=String:C10($style.color)
	var $w : Real
	
	// Every badge sets an explicit width & height (like _graphPicture) so the export
	// viewport is fixed and the rounded rectangle's bottom border is never clipped.
	
	Case of 
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="graph")
			
			$svg.width(10).height(30).color($text).stroke(2)
			$svg.line(5; 0; 5; 24)
			$svg.circle(3; 5; 10)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="title")
			
			$svg.text($text).position(2; 15)\
				.fontStyle($style.bold ? Bold:K14:2 : Plain:K14:1)
			
			If (Bool:C1537($style.selected))
				
				$svg.color("white")
				
			Else 
				
				$svg.color($style.main ? ($dark ? "white" : "black") : ($dark ? "silver" : "darkgray"))
				
			End if 
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="branch")
			
			$w:=$svg.getTextWidth($text)*1.2
			$svg.width($w+1).height(21)
			
			$svg.rect($w; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke($col).fill($col).opacity($dark ? 0.8 : 0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="current branch")
			
			$text:="🚧 "+$text  //✔️
			$w:=$svg.getTextWidth($text)+10
			$svg.width($w+1).height(21)
			
			$svg.rect($w; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke($col).fill($col).opacity($dark ? 0.8 : 0.3)
			
			$svg.text($text).position(4; 15).fontStyle(Bold:K14:2).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="origin")
			
			If (Length:C16($text)>0)
				
				$text:="origin/"+$text
				$w:=$svg.getTextWidth($text)+8
				$svg.width($w+24).height(22)
				
				// Leading solid chip for the GitHub icon (kept legible on any lane colour)
				$svg.rect(21; 20)\
					.radius(4).position(0.5; 0.5)\
					.fill($dark ? "#2b2b30" : "white")
				
				// Trailing coloured pill with the remote branch name (kept separate to avoid overlap)
				$svg.group().translate(3)
				$svg.rect($w; 20)\
					.radius(4).position(23; 0.5)\
					.stroke($col).fill($col).opacity($dark ? 0.8 : 0.3)
				
				$svg.text($text).position(27; 15).color($dark ? "white" : "black")
				$svg.goUp()
				
			Else 
				
				$svg.width(22).height(22)
				
				$svg.rect(21; 20)\
					.radius(4).position(0.5; 0.5)\
					.stroke($col).fill($dark ? "#2b2b30" : "white")
				
			End if 
			
			$svg.image($dark ? This:C1470.icons.githubDark : This:C1470.icons.github).attachTo("root")\
				.position(2.5; 2).width(16).height(16)
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="tag")
			
			$w:=$svg.getTextWidth($text)+28
			$svg.width($w+1).height(21)
			
			$svg.rect($w; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("blue").fill($dark ? "fuchsia" : "lavender").opacity($dark ? 0.8 : 0.3)
			
			$svg.image(This:C1470.icons.tag)
			
			$svg.line(21; 0.5; 21; 20.5).stroke("blue").opacity(0.5)
			
			$svg.text($text).position(25; 15).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="stash")
			
			$w:=$svg.getTextWidth($text)+28
			$svg.width($w+1).height(22)
			
			$svg.rect($w; 20)\
				.radius(4).position(0.5; 0.5)\
				.stroke("grey").fill($dark ? "darkgray" : "lightgray").opacity($dark ? 0.8 : 0.3)
			
			$svg.image(This:C1470.icons.stash)
			
			$svg.line(21; 0.5; 21; 20.5).stroke("grey").opacity(0.5)
			
			$svg.text($text).position(25; 15).color($dark ? "white" : "black")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		: ($what="toPush")
			
			$svg.circle(3).position(10; 10)\
				.color("orangered")
			
			return $svg.picture()
			
			//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
	End case 
	
	$svg.close()
