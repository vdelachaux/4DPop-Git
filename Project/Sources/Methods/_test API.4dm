//%attributes = {}
var $zen : Text

/*

echo "# test-repo" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/vdelachaux/test-repo.git
git push -u origin main

*/

var $gh:=cs:C1710.GithubAPI.new()
//var $token : Object:=$gh.getAppToken()

//$gh.getUser($gh.token)

////$gh.AuthorizeApp()

//$gh._getToken()

$zen:=$gh.zen()

//// Try creating a repository
//$gh.CreateRepos("TEST REPO")

//// Try delete a repository
//$gh.DeleteRepos("test-repo")

/*

// Create readme
File("~repo/README.md").setText("# "+$name)
git add README.md
git commit -m "first commit"

// Add the origin to to the repository
git remote add origin + $remoteURL

// Create the main branch
git branch -M main

// Push
git push -u origin main

*/