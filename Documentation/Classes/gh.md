# gh

The `gh` class is a wrapper around the **GitHub CLI** ([`gh`](https://cli.github.com/manual/)). It uses a locally installed `gh` binary when available and falls back to an embedded one otherwise. It handles device-flow authentication and repository creation/deletion.

<hr>

ℹ️ <b>Important</b>

1. `gh` is a **singleton**: always use the same instance through the `me` accessor.
2. The instance detects the CLI on creation and checks the authentication token. Inspect `.available` and `.authorized` before running commands.
3. Command outcomes are exposed by the `.success` property; the last error message is available through `.lastError`.

<hr>

The class is available from the `cs` class store. When the component is installed with the **`git`** namespace, host projects reach it through the `cs.git` class store:

#### Example

```4d
// From a host project (component installed as `git`)
var $gh : cs.git.gh:=cs.git.gh.me

If ($gh.available && $gh.login())
	$url:=$gh.createRepo("my-new-repo"; True)  // private repository
End if
```

## <a name="Constructor">cs.gh.new()</a>

**cs.gh.new** ( ) : `cs.gh`

|Parameter|Type||Description|
|---|---|---|---|
| result | **cs**.gh | ← | The `gh` singleton |

### Description

`cs.gh.new()` returns the shared singleton. Prefer the `me` accessor to obtain the instance:

```4d
var $gh : cs.gh:=cs.gh.me
```

On creation, the constructor detects the `gh` executable (`.available`) and, if found, checks the current authentication token (`.authorized`).

## <a name="Properties">Properties</a>

|Properties|Description|Type|Writable|
|:----------|:-----------|:-----------|:-----------:|
|.**available** | **True** when the GitHub CLI is available | `Boolean` | <font color="red">x</font>
|.**authorized** | **True** when a valid authentication token is configured | `Boolean` | <font color="red">x</font>
|.**success** | **True** when the last command succeeded | `Boolean` | <font color="red">x</font>
|.**exe** | Path to the `gh` executable | `Text` | <font color="red">x</font>
|.**remote** | Remote URL of the last created repository | `Text` | <font color="red">x</font>
|.**status** | Authentication status `{host; user; scope}` | `Object` | <font color="red">x</font>
|.**errors** | Collection of error messages | `Collection` | <font color="red">x</font>
|.**timeout** | System worker timeout, in seconds (default 60) | `Integer` | <font color="green">✓</font>

## <a name="Functions">Functions</a>

### Authentication

| Functions | |
|:-------- |:------ |
|.**getStatus** ( ) →`Object` | Verifies and returns the authentication state `{host; user; scope}`
|.**login** ( ) →`Boolean` | Ensures the user is authenticated (device-flow login when needed)
|.**logout** ( ) | Removes the stored authentication for the host
|.**checkToken** ( ) →`Boolean` | **True** when a valid `gh` authentication token is configured
|.**get lastError** ( ) →`Text` | The most recent error message (`""` when there is none)

### Repositories

| Functions | |
|:-------- |:------ |
|.**createRepo** ( *name* : `Text` { ; *private* : `Boolean` { ; *options* : `Object` } } ) →`Text` | Creates a GitHub repository and returns its remote URL (`.remote`)
|.**deleteRepo** ( *name* : `Text` ) →`Boolean` | Deletes a GitHub repository (requests the `delete_repo` scope if missing)
