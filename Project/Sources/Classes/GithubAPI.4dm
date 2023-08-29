
Class extends http

property validToken : Boolean
property repo : Object

Class constructor($method : Text; $headers : Object; $body)
	
	Super:C1705("https://api.github.com"; $method; $headers; $body)
	
	This:C1470.validToken:=False:C215
	
	This:C1470.URL:="https://api.github.com"
	
	This:C1470.headers["User-Agent"]:="4DPop-git"
	This:C1470.headers["X-GitHub-Api-Version"]:="2022-11-28"
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function CreateRepos($name : Text; $public : Boolean; $description : Text)
	
	var $method : Text
	var $response : Object
	
	If (Not:C34(This:C1470.validToken))
		
		This:C1470._getToken()
		
	End if 
	
	$method:=This:C1470.method  // Save default method
	This:C1470.method:="POST"
	
	This:C1470.body:={\
		accept: "application/vnd.github+json"; \
		name: This:C1470._compliantRepositoryName($name); \
		description: $description; \
		private: Not:C34($public)\
		}
	
	$response:=This:C1470.Request(This:C1470.URL+"/user/repos"; True:C214; 201)
	
	This:C1470.method:=$method  // Restore default method
	
	If (This:C1470.success)
		
		If (This:C1470.dev)
			
			SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($response.body; *))
			
		End if 
		
		// Create readme
		var $file : 4D:C1709.File
		$file:=Folder:C1567(fk database folder:K87:14; *).file("README.md")
		
		If (Not:C34($file.exists))
			
			$file.setText("# "+$name)
			
			//$ git add README.md
			//$ git commit -m "first commit"
			
		End if 
		
		// Add the origin to to teh repository
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
Function Request($url : Text; $wait : Boolean; $status : Integer) : Object
	
	var $error : Text
	var $response : Object
	var $request : 4D:C1709.HTTPRequest
	
	$request:=This:C1470.HTTPRequest.new($url; This:C1470)
	
	If ($wait)
		
		$request.wait()
		
		$response:=$request.response
		
		This:C1470.success:=$response.status=($status=0 ? 200 : $status)
		
		If (Not:C34(This:C1470.success))
			
			If ($response.body.errors#Null:C1517)\
				 && ($response.body.errors.length>0)
				
				$error:=$response.body.errors.extract("message").join("\r")
				
			Else 
				
				$error:=String:C10($response.body.message#Null:C1517 ? $response.body.message : $response.statusText)
				
			End if 
			
			This:C1470._pushError($error)
			
			If (This:C1470.dev)
				
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
	
	If ($o.token#Null:C1517) && (Length:C16(String:C10($o.token))>0)
		
		This:C1470.headers.Authorization:="Bearer "+String:C10($o.token)
		
	End if 
	
	This:C1470.body:={\
		accept: $o.accept#Null:C1517 ? String:C10($o.accept) : "application/vnd.github+json"\
		}
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _compliantRepositoryName($name : Text) : Text
	
	var $len; $pos : Integer
	var $c : Collection
	
	$name:=Lowercase:C14($name)
	$c:=[]
	
	While (Match regex:C1019("(?mi-s)([^[:alnum:]]+)"; $name; 1; $pos; $len))
		
		$c.push(Substring:C12($name; 1; $pos-1))
		$name:=Delete string:C232($name; 1; $pos+$len-1)
		
	End while 
	
	$c.push($name)
	
	return $c.join("-")
	
	