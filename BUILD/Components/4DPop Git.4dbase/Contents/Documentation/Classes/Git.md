# Git

The `Git` class is a thin wrapper around the local **`git`** command line. It runs git commands, parses their output and exposes the repository state (branches, changes, stashes, remotes, tags…) as 4D collections and objects.

<hr>

ℹ️ <b>Important</b>

1. `Git` is a **shared singleton**: always use the same instance through the `me` accessor.
2. Every command is run through the [`execute()`](#execute) function. The outcome is exposed by the `.success`, `.result`, `.error` and `.warning` properties.
3. Functions that return `This` (the instance) can be chained.

<hr>

The class is available from the `cs` class store. When the component is installed with the **`git`** namespace, host projects reach it through the `cs.git` class store:

#### Example

```4d
// From a host project (component installed as `git`)
var $git : cs.git.Git
$git:=cs.git.Git.me

// From inside the component itself
var $git : cs.Git
$git:=cs.Git.me
```

## <a name="Constructor">cs.Git.new()</a>

**cs.Git.new** ( ) : `cs.Git`<br>
**cs.Git.new** ( *folder* : 4D.Folder ) : `cs.Git`

|Parameter|Type||Description|
|---|---|---|---|
| folder | 4D.Folder | → | Working folder to attach the instance to (the current project folder if omitted) |
| result | **cs**.Git | ← | The `Git` singleton |

### Description

`cs.Git.new()` returns the shared singleton and attaches it to a working folder. Prefer the `me` accessor to obtain the instance:

```4d
var $git : cs.Git:=cs.Git.me
```

If the optional `folder` parameter points to a git working copy, the instance is initialized (HEAD, user and version are read from the repository).

## <a name="Properties">Properties</a>

|Properties|Description|Type|Writable|
|:----------|:-----------|:-----------|:-----------:|
|.**workspace** | Working copy folder | `4D.Folder` | <font color="red">x</font>
|.**root** | The `.git` folder | `4D.Folder` | <font color="red">x</font>
|.**gitignore** | The `.gitignore` file | `4D.File` | <font color="red">x</font>
|.**gitattributes** | The `.gitattributes` file | `4D.File` | <font color="red">x</font>
|.**success** | **True** when the last command succeeded | `Boolean` | <font color="red">x</font>
|.**local** | **True** when a local `git` binary is available | `Boolean` | <font color="red">x</font>
|.**result** | Raw output of the last command | `Text` | <font color="red">x</font>
|.**error** | Last error message (`""` when none) | `Text` | <font color="red">x</font>
|.**errors** | Collection of error messages | `Collection` | <font color="red">x</font>
|.**warning** | Last warning message (`""` when none) | `Text` | <font color="red">x</font>
|.**warnings** | Collection of warning messages | `Collection` | <font color="red">x</font>
|.**user** | `{name; email}` of the git user | `Object` | <font color="red">x</font>
|.**workingBranch** | The current branch `{name; ref; current}` | `Object` | <font color="red">x</font>
|.**branches** | Collection of branches `{name; ref; current}` | `Collection` | <font color="red">x</font>
|.**changes** | Collection of pending changes (refreshed by `status()`) | `Collection` | <font color="red">x</font>
|.**history** | Commit history | `Collection` | <font color="red">x</font>
|.**remotes** | Collection of remotes `{name; url}` | `Collection` | <font color="red">x</font>
|.**stashes** | Collection of stashes `{name; branch; message}` | `Collection` | <font color="red">x</font>
|.**tags** | Collection of tags | `Collection` | <font color="red">x</font>
|.**HEAD** | Current HEAD reference | `Text` | <font color="red">x</font>

## <a name="Functions">Functions</a>

### Authentication

| Functions | |
|:-------- |:------ |
|.**get token** ( ) →`Text` | The GitHub token (shared with the dependency manager, stored in `github.json`)
|.**set token** ( *token* : `Text` ) | Stores the GitHub token (shared with the dependency manager)

### Command

| Functions | |
|:-------- |:------ |
|<a name="execute"></a>.**execute** ( *command* : `Text` { ; *inputStream* : `Text` } ) →`Boolean` | Runs a git command line and returns the success flag. Output goes to `.result`
|.**getConfig** ( *what* : `Text` ) →`Text` | Reads a git config value (`git config --get <what>`)
|.**getVersion** ( { *type* : `Text` } ) →`Text` | The installed git version (`"short"` → the version number only)
|.**version** ( ) →`Text` | Runs `git version` and returns the version string

### Repository

| Functions | |
|:-------- |:------ |
|.**init** ( ) | Initializes a git repository (with default `.gitignore` / `.gitattributes`)
|.**update** ( ) | Refreshes HEAD, user and version from the repository
|.**userName** ( ) →`Text` | The configured git user name
|.**userMail** ( ) →`Text` | The configured git user email
|.**installLFS** ( ) →`Boolean` | Installs Git LFS in the repository
|.**get lfs** ( ) →`Boolean` | **True** when Git LFS is enabled in the repository
|.**open** ( *what* : `Text` ) | Opens the working directory in the terminal (`"terminal"`) or file browser (`"show"`)

### Changes

| Functions | |
|:-------- |:------ |
|.**status** ( { *short* : `Boolean` } ) →`Integer` | Refreshes the `.changes` collection and returns its length
|.**add** ( *what* : `Text` \| `Collection` ) | Stages file(s): a path, a collection of paths, `"all"` or `"update"`
|.**untrack** ( *what* : `Text` \| `Collection` ) | Removes file(s) from the index (`git rm --cached`), keeping them on disk
|.**unstage** ( *what* : `Text` \| `Collection` ) | Unstages file(s), a moved `"old -> new"` pair, or `"all"`
|.**commit** ( *message* : `Text` { ; *amend* : `Boolean` } ) | Commits the staged changes (message via stdin; *amend* to amend the last one)
|.**diff** ( *pathname* : `Text` { ; *option* : `Text` } ) | Computes the diff of a file (result in `.result`)
|.**diffList** ( *parent* : `Text` ; *current* : `Text` ) →`Boolean` | Lists changed files between two commits (`git diff --name-status`)
|.**diffTool** ( *pathname* : `Text` ) | Opens the configured external diff tool for a file

### Branches

| Functions | |
|:-------- |:------ |
|.**branch** ( { *whatToDo* : `Text` { ; *name* : `Text` { ; *newName* : `Text` } } } ) →`This` | Branch operations: `list` / `create` / `createAndUse` / `use` / `merge` / `rename` / `delete` / `deleteForce` / `main`. Refreshes `.branches`
|.**checkout** ( *what* : `Text` \| `Collection` ) →`This` | Checks out a branch/ref (`Text`) or discards local path(s) (`Collection`)
|.**get currentBranch** ( ) →`Text` | The current branch name (`""` when HEAD is detached)
|.**branchFetchNumber** ( *branch* : `Text` ) →`Integer` | Number of commits available to fetch/pull on the given branch
|.**branchPushNumber** ( *branch* : `Text` ) →`Integer` | Number of local commits waiting to be pushed on the given branch

### Synchronization

| Functions | |
|:-------- |:------ |
|.**fetch** ( { *origin* : `Boolean` } ) →`Boolean` | Fetches origin only (*origin*=**True**) or every remote
|.**fetchAll** ( ) →`Boolean` | Fetches all remotes (prune + tags)
|.**fetchCurrent** ( ) →`Boolean` | Fetches the origin remote (prune + tags)
|.**pull** ( { *rebase* : `Boolean` { ; *stash* : `Boolean` } } ) →`Boolean` | Pulls from origin (optional rebase / autostash)
|.**push** ( { *origin* : `Text` { ; *branch* : `Text` { ; *force* : `Boolean` } } } ) →`Boolean` | Pushes to origin (or *origin*/*branch*); *force* uses `--force-with-lease`
|.**forcePush** ( { *origin* : `Text` { ; *branch* : `Text` } } ) →`Boolean` | Force-pushes (with lease) to origin (or *origin*/*branch*)

### Remotes & tags

| Functions | |
|:-------- |:------ |
|.**updateRemotes** ( ) →`This` | Refreshes the `.remotes` collection (`git remote -v`)
|.**addRemote** ( *name* : `Text` ; *url* : `Text` ) | Adds a remote to the `.remotes` collection (in memory)
|.**updateTags** ( ) →`This` | Refreshes the `.tags` collection (`git tag`)
|.**FETCH_HEAD** ( *type* : `Text` ) →`Collection` | Parses `.git/FETCH_HEAD` for the given ref type (e.g. `"branch"`)
|.**REMOTE_ORIGIN** ( ) →`Collection` | Reads the `refs/remotes/origin` refs from disk

### Stash

| Functions | |
|:-------- |:------ |
|.**stash** ( { *action* : `Text` { ; *name* : `Text` } } ) →`This` | Stash operations: `list` / `save` / `snapshot` / `pop`. Refreshes `.stashes`

### Miscellaneous

| Functions | |
|:-------- |:------ |
|.**getTarget** ( *path* : `Text` { ; *root* : `4D.Folder` } ) →`Variant` | Resolves a repository-relative path to a 4D `File`/`Folder` or an object identifier
