Class extends http

property validToken:=False:C215
property hasToken:=False:C215
property URL:="https://api.github.com"
property clientId:="0b65d7deae9a2a88bcf4"

property repo : Object

property _token : Text
property latest : 4D:C1709.HTTPRequest

property clientSecret : Text

Class constructor($method : Text; $headers : Object; $body)
	
	// Super(This.URL; $method; $headers; $body)
	Super:C1705("https://api.github.com"; $method; $headers; $body)
	
	This:C1470.headers["User-Agent"]:="4DPop-git"
	This:C1470.headers["Accept"]:="application/vnd.github+json"
	This:C1470.headers["X-GitHub-Api-Version"]:="2022-11-28"
	
	This:C1470.hasToken:=Length:C16(This:C1470.token)>0
	
	This:C1470.clientSecret:=This:C1470._secret()
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get token() : Text
	
	If (This:C1470[""].token#Null:C1517)\
		 && (Length:C16(This:C1470[""].token)>0)
		
		return This:C1470[""].token
		
	End if 
	
	var $file:=Folder:C1567(fk user preferences folder:K87:10).file("github.json")
	
	If ($file.exists)
		
		This:C1470[""].token:=String:C10(JSON Parse:C1218($file.getText()).token)
		
	End if 
	
	return This:C1470[""].token
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set token($token : Text)
	
	var $file:=Folder:C1567(fk user preferences folder:K87:10).file("github.json")
	var $o : Object:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	$o.token:=$token
	$file.setText(JSON Stringify:C1217($o; *))
	
	This:C1470._token:=$token
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CreateRepos($name : Text; $public : Boolean; $description : Text)
	
	//var $headers:=OB Copy(This.headers)
	//If (This.hasToken)
	//$headers["Authorization"]:="Bearer "+String(This.token)
	//End if 
	
	//If (Not(This.validToken))
	
	//This._getToken()
	
	//End if 
	
	This:C1470.getAppToken()
	
	var $method:=This:C1470.method  // Save default method
	This:C1470.method:="POST"
	
	This:C1470.body:={\
		name: This:C1470._compliantRepositoryName($name); \
		description: $description; \
		private: Not:C34($public)\
		}
	
	var $response : Object:=This:C1470.Request(This:C1470.URL+"/user/repos"; True:C214; 201)
	
	This:C1470.method:=$method  // Restore default method
	
	If (This:C1470.success)
		
		If (This:C1470.DEV)
			
			SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($response.body; *))
			
		End if 
		
		// Create readme
		var $file:=Folder:C1567(fk database folder:K87:14; *).file("README.md")
		
		If (Not:C34($file.exists))
			
			$file.setText("# "+$name)
			
			//$ git add README.md
			//$ git commit -m "first commit"
			
		End if 
		
		// Add the origin to to the repository
		//$ git remote add origin+$response.body.git_url
		
		// Create the main branch
		//$ git branch -M main
		
		// Push
		//$ git push -u origin main
		
		This:C1470.repo:=$response.body
		
/*
{
  "id": 683051026,
  "node_id": "R_kgDOKLaIEg",
  "name": "test-repo",
  "full_name": "<login>/test-repo",
  "private": true,
  "owner": {
    "login": "<login>",
    "id": 623020,
    "node_id": "MDQ6VXNlcjYyMzAyMA==",
    "avatar_url": "https://avatars.githubusercontent.com/u/623020?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/<login>",
    "html_url": "https://github.com/<login>",
    "followers_url": "https://api.github.com/users/<login>/followers",
    "following_url": "https://api.github.com/users/<login>/following{/other_user}",
    "gists_url": "https://api.github.com/users/<login>/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/<login>/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/<login>/subscriptions",
    "organizations_url": "https://api.github.com/users/<login>/orgs",
    "repos_url": "https://api.github.com/users/<login>/repos",
    "events_url": "https://api.github.com/users/<login>/events{/privacy}",
    "received_events_url": "https://api.github.com/users/<login>/received_events",
    "type": "User",
    "site_admin": false
  },
  "html_url": "https://github.com/<login>/test-repo",
  "description": null,
  "fork": false,
  "url": "https://api.github.com/repos/<login>/test-repo",
  "forks_url": "https://api.github.com/repos/<login>/test-repo/forks",
  "keys_url": "https://api.github.com/repos/<login>/test-repo/keys{/key_id}",
  "collaborators_url": "https://api.github.com/repos/<login>/test-repo/collaborators{/collaborator}",
  "teams_url": "https://api.github.com/repos/<login>/test-repo/teams",
  "hooks_url": "https://api.github.com/repos/<login>/test-repo/hooks",
  "issue_events_url": "https://api.github.com/repos/<login>/test-repo/issues/events{/number}",
  "events_url": "https://api.github.com/repos/<login>/test-repo/events",
  "assignees_url": "https://api.github.com/repos/<login>/test-repo/assignees{/user}",
  "branches_url": "https://api.github.com/repos/<login>/test-repo/branches{/branch}",
  "tags_url": "https://api.github.com/repos/<login>/test-repo/tags",
  "blobs_url": "https://api.github.com/repos/<login>/test-repo/git/blobs{/sha}",
  "git_tags_url": "https://api.github.com/repos/<login>/test-repo/git/tags{/sha}",
  "git_refs_url": "https://api.github.com/repos/<login>/test-repo/git/refs{/sha}",
  "trees_url": "https://api.github.com/repos/<login>/test-repo/git/trees{/sha}",
  "statuses_url": "https://api.github.com/repos/<login>/test-repo/statuses/{sha}",
  "languages_url": "https://api.github.com/repos/<login>/test-repo/languages",
  "stargazers_url": "https://api.github.com/repos/<login>/test-repo/stargazers",
  "contributors_url": "https://api.github.com/repos/<login>/test-repo/contributors",
  "subscribers_url": "https://api.github.com/repos/<login>/test-repo/subscribers",
  "subscription_url": "https://api.github.com/repos/<login>/test-repo/subscription",
  "commits_url": "https://api.github.com/repos/<login>/test-repo/commits{/sha}",
  "git_commits_url": "https://api.github.com/repos/<login>/test-repo/git/commits{/sha}",
  "comments_url": "https://api.github.com/repos/<login>/test-repo/comments{/number}",
  "issue_comment_url": "https://api.github.com/repos/<login>/test-repo/issues/comments{/number}",
  "contents_url": "https://api.github.com/repos/<login>/test-repo/contents/{+path}",
  "compare_url": "https://api.github.com/repos/<login>/test-repo/compare/{base}...{head}",
  "merges_url": "https://api.github.com/repos/<login>/test-repo/merges",
  "archive_url": "https://api.github.com/repos/<login>/test-repo/{archive_format}{/ref}",
  "downloads_url": "https://api.github.com/repos/<login>/test-repo/downloads",
  "issues_url": "https://api.github.com/repos/<login>/test-repo/issues{/number}",
  "pulls_url": "https://api.github.com/repos/<login>/test-repo/pulls{/number}",
  "milestones_url": "https://api.github.com/repos/<login>/test-repo/milestones{/number}",
  "notifications_url": "https://api.github.com/repos/<login>/test-repo/notifications{?since,all,participating}",
  "labels_url": "https://api.github.com/repos/<login>/test-repo/labels{/name}",
  "releases_url": "https://api.github.com/repos/<login>/test-repo/releases{/id}",
  "deployments_url": "https://api.github.com/repos/<login>/test-repo/deployments",
  "created_at": "2023-08-25T13:31:53Z",
  "updated_at": "2023-08-25T13:31:53Z",
  "pushed_at": "2023-08-25T13:31:53Z",
  "git_url": "git://github.com/<login>/test-repo.git",
  "ssh_url": "git@github.com:<login>/test-repo.git",
  "clone_url": "https://github.com/<login>/test-repo.git",
  "svn_url": "https://github.com/<login>/test-repo",
  "homepage": null,
  "size": 0,
  "stargazers_count": 0,
  "watchers_count": 0,
  "language": null,
  "has_issues": true,
  "has_projects": true,
  "has_downloads": true,
  "has_wiki": false,
  "has_pages": false,
  "has_discussions": false,
  "forks_count": 0,
  "mirror_url": null,
  "archived": false,
  "disabled": false,
  "open_issues_count": 0,
  "license": null,
  "allow_forking": true,
  "is_template": false,
  "web_commit_signoff_required": false,
  "topics": [],
  "visibility": "private",
  "forks": 0,
  "open_issues": 0,
  "watchers": 0,
  "default_branch": "main",
  "permissions": {
    "admin": true,
    "maintain": true,
    "push": true,
    "triage": true,
    "pull": true
  },
  "allow_squash_merge": true,
  "allow_merge_commit": true,
  "allow_rebase_merge": true,
  "allow_auto_merge": false,
  "delete_branch_on_merge": false,
  "allow_update_branch": false,
  "use_squash_pr_title_as_default": false,
  "squash_merge_commit_message": "COMMIT_MESSAGES",
  "squash_merge_commit_title": "COMMIT_OR_PR_TITLE",
  "merge_commit_message": "PR_TITLE",
  "merge_commit_title": "MERGE_MESSAGE",
  "network_count": 0,
  "subscribers_count": 0
}
*/
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function DeleteRepos($name : Text; $owner : Text)
	
	var $method : Text
	var $response : Object
	
	If (Not:C34(This:C1470.validToken))
		
		This:C1470._getToken()
		
	End if 
	
	$method:=This:C1470.method  // Save default method
	This:C1470.method:="DELETE"
	
	This:C1470._prepareRequest()
	
	$response:=This:C1470.Request(This:C1470.URL+"/repos/"+$owner+"/"+This:C1470._compliantRepositoryName($name); True:C214; 204)
	
	This:C1470.method:=$method  // Restore default method
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CheckTokenValidity($token : Text) : Boolean
	
	This:C1470._prepareRequest({token: $token})
	return This:C1470.Request(This:C1470.URL+"/octocat"; True:C214).status=200
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function zen($token : Text) : Text
	
	This:C1470._prepareRequest({token: $token})
	return String:C10(This:C1470.Request(This:C1470.URL+"/zen"; True:C214).body)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getUser($token : Text) : Object
	
	If (Not:C34(This:C1470.validToken))
		
		This:C1470._getToken()
		
	End if 
	
	This:C1470._prepareRequest({token: $token})
	This:C1470.user:=This:C1470.Request(This:C1470.URL+"/user"; True:C214).body
	
	return This:C1470.user
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function AuthorizeApp() : Boolean
	
	// Lien vers les informations d’autorisation d’une OAuth app
	// Pour que les utilisateurs puissent vérifier et révoquer leurs autorisations d’application.
	// "https://Github.com/settings/connections/applications/<AppClientID>"
	
	
	// Requests device and user verification codes from GitHub
	//POST https://github.com/login/device/code
	
	This:C1470.method:="POST"
	This:C1470._prepareRequest()
	
	This:C1470.body.clientId:=This:C1470.clientId
	This:C1470.body.scope:="repo user"
	
	This:C1470.Request("https://github.com/login/device/code"; True:C214)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getAppToken() : Object
	
	var $token : Object:=Storage:C1525.OAuth2
	This:C1470.success:=This:C1470._IsValidAppToken($token)
	
	If (This:C1470.success)
		
		return $token
		
	End if 
	
	// Start the web server if necessary
	var $webServer:=WEB Server:C1674(Web server database:K73:30)
	
	If (Not:C34($webServer.isRunning))
		
		$webServer.start()
		
	End if 
	
	var $credential:={\
		token: $token; \
		permission: "signedIn"; \
		clientId: This:C1470.clientId; \
		clientSecret: This:C1470.clientSecret; \
		redirectURI: "http://127.0.0.1:50993/authorize/"; \
		scope: "repo, user"; \
		authenticateURI: "https://github.com/login/oauth/authorize"; \
		tokenURI: "https://github.com/login/oauth/access_token"; \
		timeout: 60; \
		authenticationPage: Folder:C1567($webServer.rootFolder).file("authenticate/authentication.htm"); \
		authenticationErrorPage: Folder:C1567($webServer.rootFolder).file("error.htm")\
		}
	
	//var $oAuth2:=cs.NetKit.OAuth2Provider.new($credential)
	//$token:=$oAuth2.getToken()
	$token:=cs:C1710.NetKit.OAuth2Provider.new($credential).getToken()
	
	This:C1470.success:=$token#Null:C1517
	
	If (This:C1470.success)
		
		Use (Storage:C1525)
			
			Storage:C1525.OAuth2:=OB Copy:C1225($token; ck shared:K85:29)
			
		End use 
		
		return $token
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _IsValidAppToken($token : Object) : Boolean
	
	return (Date:C102($token.tokenExpiration)>=Current date:C33)\
		 && ((Time:C179($token.tokenExpiration)+60)>=(Current time:C178+0))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function Request($url : Text; $wait : Boolean; $status : Integer) : Object
	
	var $error : Text
	var $response : Object
	var $request : 4D:C1709.HTTPRequest
	
	$request:=4D:C1709.HTTPRequest.new($url; This:C1470)
	
	If ($wait)
		
		$request.wait()
		
		$response:=$request.response
		
		This:C1470.success:=$response.status=($status=0 ? 200 : $status)
		
		If (Not:C34(This:C1470.success))
			
			Case of 
					
					//______________________________________________________
				: ($response=Null:C1517)
					
					$error:="Unknown error"
					
					//______________________________________________________
				: (Value type:C1509($response.body)=Is object:K8:27)
					
					If ($response.body.errors#Null:C1517)\
						 && ($response.body.errors.length>0)
						
						$error:=$response.body.errors.extract("message").join("\r")
						
					Else 
						
						$error:=String:C10($response.body.message#Null:C1517 ? $response.body.message : $response.statusText)
						
					End if 
					
					//______________________________________________________
				Else 
					
					$error:=String:C10($response.status)+" - "+String:C10($response.statusText)
					
					//______________________________________________________
			End case 
			
			This:C1470._pushError($error)
			
			If (This:C1470.DEV)
				
				ALERT:C41($error)
				
			End if 
		End if 
	End if 
	
	This:C1470.latest:=$request
	
	return $response
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onResponse method, if you want to handle the request asynchronously
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	// My onError method, if you want to handle the request asynchronously
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _getToken()
	
	var $token : Text
	var $file : 4D:C1709.File
	
	// First, search the project folder
	$file:=Folder:C1567(fk database folder:K87:14; *).file("Preferences/github.credentials")
	
	If (Not:C34($file.exists))
		
		// Search for a global file
		$file:=Folder:C1567(fk user preferences folder:K87:10).file("github.credentials")
		
	End if 
	
	If ($file.exists)
		
		$token:=String:C10(JSON Parse:C1218($file.getText()).token)
		
	End if 
	
	If (Length:C16($token)=0)
		
		$token:=Request:C163("Please enter the token to use to access your account:")
		
	End if 
	
	This:C1470.success:=Length:C16($token)>0
	
	If (This:C1470.success)
		
		This:C1470.CheckTokenValidity($token)
		
		If (This:C1470.success)
			
			This:C1470.validToken:=True:C214
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _prepareRequest($o : Object)
	
	If ($o.token#Null:C1517)\
		 && (Length:C16(String:C10($o.token))>0)
		
		This:C1470.headers.Authorization:="Bearer "+String:C10($o.token)
		
	End if 
	
	This:C1470.body:={\
		accept: $o.accept#Null:C1517 ? String:C10($o.accept) : "application/vnd.github+json"\
		}
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _secret() : Text
	
	var $x; $y : Blob
	
	$x:=Folder:C1567(fk resources folder:K87:11).file("vdl").getContent()
	
	var $c:=[]
	$c.push("-----BEGIN *-----")
	$c.push("MEgCQQC6OwTFqEKzVHgZOWViy1cFZWzeP1AnMtyNmujoc99tEolO3cM4/lDLIgQq")
	$c.push("deYt6UuWAbc+OCsCb9/VyzUO4zV/AgMBAAE=")
	$c.push("-----END *-----")
	
	TEXT TO BLOB:C554(Replace string:C233($c.join("\n"); "*"; "RSA PUBLIC KEY"); $y; UTF8 text without length:K22:17)
	DECRYPT BLOB:C690($x; $y)
	
	return Convert to text:C1012($x; "US-ASCII")
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _compliantRepositoryName($name : Text) : Text
	
	var $len; $pos : Integer
	
	$name:=Lowercase:C14($name)
	var $c:=[]
	
	While (Match regex:C1019("(?mi-s)([^[:alnum:]]+)"; $name; 1; $pos; $len))
		
		$c.push(Substring:C12($name; 1; $pos-1))
		$name:=Delete string:C232($name; 1; $pos+$len-1)
		
	End while 
	
	$c.push($name)
	
	return $c.join("-")
	