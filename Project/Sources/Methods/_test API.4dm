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

//var $gh:=cs.GithubAPI.new()
//var $token : Object:=$gh.getAppToken()

var $gh:=cs:C1710.gh.me

//If (Not($gh.authorized))
//$gh.logIn()
//End if 
//If ($gh.authorized)
//$gh.logout()
//End if 
//ASSERT($gh.authorized)


//$gh.getUser($gh.token)
////$gh.AuthorizeApp()
//$gh._getToken()
//$zen:=$gh.zen()


// Try creating a repository
var $repo:="TEST REPO"
var $remote:=$gh.createRepo($repo)

If ($gh.success)
	
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
	
End if 

//If (Length($remote)>0)


//// Try delete a repository
//$gh.deleteRepo("test-repo")


//End if 


