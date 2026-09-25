# Keep Git Close to Your 4D Code with 4DPop Git

When a 4D project is managed with Git, a simple change can involve several tools: 4D to edit the code, a terminal to inspect the repository, a diff application to review changes, and a browser to work with GitHub. Moving between them interrupts the most important part of the workflow: understanding and improving the code.

**4DPop Git** brings Git and GitHub operations into the 4D IDE. It gives 4D developers a visual way to review changes, create focused commits, navigate history, and synchronize a project without leaving the environment where they write their code.

![The 4DPop Git widget](widget.png)

## SEE YOUR PROJECT STATUS AT A GLANCE

The Git widget stays available in the 4DPop toolbar. It shows the current branch, local changes, commits available to pull, and commits waiting to be pushed. From the same widget, you can refresh the repository, open the main window, switch branches, and access the repository settings.

If the project is not yet a Git repository, 4DPop Git offers to initialize it. This creates the local `.git` folder; it does not create a remote repository automatically.

## REVIEW AND COMMIT CHANGES WITHOUT LEAVING 4D

The first step after changing a method is usually to understand exactly what changed. The **Changes** page separates local modifications from the Git index. Select a file to inspect its diff, stage the files that belong to the next commit, and write the commit message in the same window.

![Reviewing changes in 4DPop Git](main.png)

This separation is useful when a project contains several unrelated edits: you can create a focused commit without staging everything at once. The file menu also provides practical actions such as opening a file in the code editor or an external diff tool, copying its path, adding an ignore pattern, or discarding a local change after confirmation. A preview is available before adding a pattern to `.gitignore`.

## UNDERSTAND THE HISTORY BEHIND YOUR CODE

The **History** page displays commits together with a color-coded graph for branches and merges. Local branches, remote branches, tags, and stashes are shown directly in the graph, making it easier to understand how the project reached its current state.

![The 4DPop Git commit history](commitHistory.png)

Select a commit to inspect its author, date, identifiers, changed files, and diff against its parent. History loading happens in the background, so the interface remains available while a large repository is being read.

4DPop Git also adds two macros to the 4D method editor:

- **Git history** opens the commits that changed the file currently being edited, including rename tracking and uncommitted changes.
- **Last commit for selection** identifies the last commit that modified the selected lines.

![Git history for a file](history.png)

These two actions make it possible to answer questions such as “when did this method change?” or “why was this line introduced?” without leaving the editor. This context is particularly useful when reviewing an old piece of business logic or preparing a fix in a shared project.

## SYNCHRONIZE WITH YOUR TEAM

Once the changes are ready, fetch, pull, and push are available from the widget and the main window. Pull supports merge, rebase, and optional automatic stashing. Push can publish a branch and supports `--force-with-lease` when rewriting a remote branch is intentional.

When no remote is configured, **Publish to GitHub** uses the GitHub CLI device-flow authentication. The component can create the repository and push the local commits without requiring a token to be copied manually into 4D.

## INSTALL IT AND EXTEND IT

With 4D v21 or later, install 4DPop Git through the Dependencies Manager by adding the GitHub dependency `vdelachaux/4DPop-Git`. Git must be installed on the computer because the component uses the local Git executable. The GitHub CLI is optional, but recommended for the **Publish to GitHub** workflow.

4DPop Git also exposes a scriptable API through the `git` class store namespace. For example, a host project can create and push a commit from 4D code:

```4d
var $git : cs.git.Git:=cs.git.Git.me

$git.add("all")
$git.commit("Update customer dashboard")
$git.push()
```

The API provides access to repository status, branches, remotes, tags, stashes, history, diffs, Git LFS, and command results. Host projects can therefore add repository-aware actions to their own tools and workflows.

4DPop Git is intended for 4D projects. Binary databases (`.4db` and `.4dc`) are not managed as a set of project files, so they do not provide the same Git workflow.

## WRAP UP

4DPop Git keeps repository status, code history, and everyday Git operations close to the 4D code. It helps developers make smaller commits, investigate changes with more context, and spend less time switching tools.

Ready to try it? Visit the [4DPop Git repository on GitHub](https://github.com/vdelachaux/4DPop-Git) for installation instructions, user guides, screenshots, and API documentation.

Share your feedback and workflow ideas on the [4D Forum](https://discuss.4d.com/).