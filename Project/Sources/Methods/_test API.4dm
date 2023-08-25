//%attributes = {}
var $description; $fullName; $gitURL; $name; $ownerURL; $remoteURL : Text
var $url : Text
var $private : Boolean
var $body; $o; $owner : Object
var $file : 4D:C1709.File
var $request : 4D:C1709.HTTPRequest
var $GithubAPI : cs:C1710.GithubAPI

/*

echo "# test-repo" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/vdelachaux/test-repo.git
git push -u origin main

*/

$GithubAPI:=cs:C1710.GithubAPI.new()

// Try creating a repository
$GithubAPI.CreateRepository("TEST REPO")

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