//%attributes = {}
var $description; $fullName; $gitURL; $name; $ownerURL; $remoteURL : Text
var $url : Text
var $private : Boolean
var $body; $o; $owner : Object
var $file : 4D:C1709.File
var $request : 4D:C1709.HTTPRequest
var $GithubAPI : cs:C1710.GithubAPI

// TODO:search first into project preferences folder

$file:=Folder:C1567(fk user preferences folder:K87:10).file("github.credentials")

If (Not:C34($file.exists))
	
	TRACE:C157
	return 
	
End if 

$o:=JSON Parse:C1218($file.getText())

If ($o.token=Null:C1517)
	
	TRACE:C157
	return 
	
End if 

$GithubAPI:=cs:C1710.GithubAPI.new().authToken($o.token)

// Check token validity
$request:=4D:C1709.HTTPRequest.new($GithubAPI.URL+"/octocat"; $GithubAPI)
$request.wait()

If ($request.response.status#200)
	
	ALERT:C41($request.response.body.message)
	return 
	
End if 

$name:=$GithubAPI.CommpliantRepositoryName("REPO de TEST")
$description:="Nouveau repo!"
$private:=True:C214

// Try creating the repository
$GithubAPI.method:="POST"
$GithubAPI.body:={\
accept: "application/vnd.github+json"; \
name: $name; \
description: $description; \
private: $private\
}

$request:=4D:C1709.HTTPRequest.new($GithubAPI.URL+"/user/repos"; $GithubAPI)
$request.wait()

If ($request.response.status#201)
	
	ALERT:C41($request.response.body.errors.extract("message").join("\n"))
	return 
	
End if 

$body:=$request.response.body

$name:=$body.name  // "test-repo"

$fullName:=$body.full_name  // "vdelachaux/test-repo"

$url:=$body.html_url  // "https://github.com/vdelachaux/test-repo"

$gitURL:=$body.git_url  // "git://github.com/vdelachaux/test-repo.git"

$remoteURL:=$request.response.body.clone_url  // "https://github.com/vdelachaux/test-repo.git"

$owner:=$body.owner
$ownerURL:=$owner.html_url  // "https://github.com/vdelachaux"

/*

// Create readme
File("~repo/README.md").setText("# "+$name)
git add README.md
git commit -m "first commit"

// Add the origin to to teh repository
git remote add origin + $remoteURL

// Create the main branch
git branch -M main

// Push
git push -u origin main

*/