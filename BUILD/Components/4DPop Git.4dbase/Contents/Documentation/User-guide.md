# 4DPop Git - User Guide

4DPop Git lets you use Git from 4D without opening a Terminal for everyday operations: reviewing changes, preparing a commit, synchronizing the repository, and browsing its history.

The component is intended for **4D projects**. It works with project files and their history; Git is not useful for binary `.4db` or `.4dc` databases, whose structure is not managed as a set of project files.

This guide is for developers who understand the basic principles of Git, but do not necessarily know all of its command-line commands.

## 1. Prerequisites

### Git

Git must be installed on the computer:

- macOS: Git is included with Xcode. It can also be installed from [git-scm.com](https://git-scm.com/download/mac).
- Windows: install Git from [git-scm.com](https://git-scm.com/download/win).

The component uses the local Git installation to read and modify the project's repository.

### GitHub CLI

The **Publish to GitHub** feature uses the `gh` command. The component provides a fallback executable, but installing [GitHub CLI](https://cli.github.com/) is recommended.

## 2. Installing the component

### Project with dependency management

With 4D v21 or later:

1. Open the project in 4D.
2. Open the Dependencies Manager.
3. Add a GitHub dependency.
4. Enter `vdelachaux/4DPop-Git`.
5. Select the version you want, for example `latest`.
6. Apply the changes.
7. Restart the project if 4D asks you to do so.

## 3. Opening 4DPop Git

Open the **Git** entry in 4DPop. The component displays the repository for the current project.

If the project is not yet a Git repository, the widget offers to initialize it. This creates a `.git` folder in the project folder. It does not automatically create a remote repository.

### The widget in the 4DPop toolbar

The Git widget remains visible in the 4DPop toolbar and provides a quick overview of the repository status for the current project.

![4DPop Git widget](widget.png)

From top to bottom:

- **Git icon**: opens the main 4DPop Git window.
- **Current branch**: displays the current branch, `main` in the screenshot. Click it to display the available branches and switch branches. The name may appear in red when the branch does not match the 4D version expected by the project.
- **Local changes**: the number next to the changes icon indicates the number of modified files in the working directory. Click it to display the files and access actions for them.
- **To pull**: the number to the left of the arrows indicates the number of commits available on the remote repository that are not yet present locally.
- **To push**: the number to the right of the arrows indicates the number of local commits that have not yet been sent to the remote repository.
- **TODO and FIXME tags**: when present, these icons provide access to methods containing the corresponding markers.
- **`...` menu**: provides access to the repository manager, snapshot creation, opening the project in Terminal or on disk, the repository's GitHub page, refresh, and settings.

When the current project is not yet a Git repository, the widget replaces this information with **Click to initialize as a git repository**.

### The main window

The main window contains two pages:

- **Changes**: working directory files, Git index, the diff for the selected file, and commit creation.
- **History**: commits, branch graph, and details for the selected commit.

![Changes page](main.png)

![History page](commitHistory.png)

The current branch and synchronization indicators are also visible in the 4DPop widget. Quick actions let you view changes, switch branches, fetch remote updates, and send commits.

## 4. Preparing and creating a commit

### Understanding the two lists

On the **Changes** page:

- **Working Directory** contains files that have changed but are not yet prepared for the next commit.
- **Index** contains the files that will be included in the next commit.
- The right-hand panel displays the diff for the selected file.

This separation follows Git's workflow: a file can be modified locally without being selected for the next commit.

### Adding files to the index

1. Select one or more files in **Working Directory**.
2. Click the button to add them to the index.
3. Check that the files appear in **Index**.
4. To remove a file from the index, select it in **Index** and click the remove button.

When nothing is selected, the button applies to all files in the relevant list.

A file's menu also lets you edit it, show it in Finder, or, for a local change, discard the change or delete the local file. It can also launch an external diff, copy the path, stage the file, or ignore it.

![File context menu](fielMenu.png)

> Discarding a change removes the file's local changes. Review the diff before confirming this operation.

When a file should be ignored, the **Ignore** submenu lets you add a pattern to `.gitignore`. The pattern can be checked in a preview before it is validated.

![Adding a pattern to gitignore](customizedPattern.png)

### Creating the commit

1. Add the files to be recorded to the index.
2. Enter a short subject in the commit field.
3. Optionally add a more detailed description.
4. Click **Commit**.

A commit contains only the files in the index. Other changes remain in the working directory and can be included in a later commit.

### Amending the last commit

Enable **Amend the last commit** when you want to replace the last commit with a new commit, for example after forgetting a file or correcting its message.

This option rewrites the last commit. Avoid using it on a commit that has already been shared with others unless your team accepts history rewrites.

## 5. Browsing the history

Open the **History** page to browse the repository commits.

Select a commit to display:

- its author and date;
- its short and full identifiers;
- its parent commit;
- the list of modified files;
- the diff against its parent.

Loading the history may take a moment in a large repository. Refreshing runs in the background.

### Understanding the graph

The graph represents branches and merges with colored lines. Labels identify local branches, remote branches, tags, and stashes.

![Commit graph](commitGraph.png)

The color helps you follow a line in the graph; it does not represent a particular commit state.

## 6. Synchronizing with a remote repository

The **Fetch**, **Pull**, and **Push** buttons operate on the remote repository configured for the current branch.

### Fetch

**Fetch** downloads new references from the remote repository without changing local files or merging a commit into the current branch. Use it to inspect the remote state before deciding whether to pull or switch branches.

### Pull

**Pull** retrieves remote updates and integrates them into the current branch. The dialog provides two mutually exclusive integration modes:

- **Merge**: used when the **Rebase** checkbox is not selected; it creates a merge when the histories have diverged.
- **Rebase**: used when the **Rebase** checkbox is selected; it replays your local commits on top of the remote commits.

The **Automatic stash** option is independent of these modes. When selected, it temporarily saves local changes when needed, then attempts to restore them.

Choose the mode used by your team. If you are unsure, check the project's convention before starting the operation.

![Pull dialog](pull.png)

### Push

**Push** sends local commits to the remote repository.

If the branch has no remote repository yet, 4DPop Git offers to publish it on GitHub (see the next section).

**Force-with-lease** can rewrite a remote branch while checking that nobody else has changed it since your last fetch. Use it only when rewriting the remote history is intentional.

![Push dialog](push.png)

## 7. Branches, tags, and stashes

### Switching branches

Use the branch menu in the 4DPop widget or the context menu of a commit in the history.

Before switching branches, make sure your local changes are committed, stored in a stash, or explicitly preserved by the automatic stash option in the dialog.

The **Checkout** dialog lets you choose how local changes are handled: leave them unchanged, stash and reapply them, or discard them.

![Checkout dialog](checkout.png)

### Creating a branch

From the branch menu or a commit's context menu:

1. Choose **New Branch**.
2. Enter a valid Git name.
3. Choose whether the new branch should become the current branch immediately.
4. Confirm.

![New branch dialog](newBranch.png)

### Tags

A tag can be created from a commit in the history. It gives a name to a specific project state, such as a published version. The dialog asks for the tag name and the commit to which it should be attached.

![New tag dialog](newTag.png)

### Stashes

A stash sets aside local changes without creating a commit. It is useful before switching branches or retrieving remote changes.

- **Save** stores the changes in a stash.
- **Snapshot** creates a stash while preserving the working state according to the available option.
- **Pop** reapplies a stash and removes it from the list when it succeeds.

Stashes also appear in the history graph.

## 8. Publishing the project on GitHub

The **Publish to GitHub** command is offered when no remote is configured for the repository.

1. Open the **Push** menu or the publication action offered by the widget.
2. Sign in to GitHub when GitHub CLI asks you to.
3. Follow the authentication flow in your browser.
4. Choose the proposed settings for the new repository.
5. 4DPop Git creates the GitHub repository and pushes the local commits.

No GitHub token needs to be copied manually into 4D.

A dedicated screenshot of this workflow could be added, provided that it does not show personal information or a token.

## 9. Method editor macros

Installing the component adds two macros to the 4D method editor context menu. They are available while editing a method or class.

### Git history for a file

1. While editing a method or class, open the context menu.
2. In the context menu, choose **Insert macro > Git history...**.
3. Select a commit in the list to display its diff.

The window shows the commits that modified the file, including tracked renames. A top entry represents uncommitted changes when there are any.

![File history](history.png)

There is one window per file. Running the macro again brings the existing window to the front. It closes with the associated method editor.

### Last commit for a selection

1. Select one or more lines in the method editor.
2. In the context menu, choose **Insert macro > Last commit for selection...**.

4DPop Git reports the last commit that modified those lines, including its author, date, short identifier, and subject.

## 10. Opening external tools

The **Open in...** menu opens the project or selected file in tools available on the computer, such as Finder or Terminal.

![Open in menu](openMenu.png)

The **Diff tool** menu can open the diff in the external tool configured in the component settings.

## 11. Quick troubleshooting

### Git cannot be found

Check that Git is installed and available in 4D's `PATH`. Restart 4D after installing Git if the component does not detect the executable immediately.

### The repository does not appear

Check that the current project contains a `.git` folder. If necessary, use the initialization action offered by the widget.

### Push is rejected

First inspect the history and use **Fetch** to update remote references. You may need to **Pull** before trying **Push** again.

Choose **Force-with-lease** only when you really need to rewrite the remote history.

### GitHub publication fails

Check that GitHub CLI is installed or that the component's fallback executable is available. Repeat the browser authentication, then check that your account can create a repository.

## Further documentation

- [French user guide](Guide-utilisateur.md).

## Git and GitHub resources

- [Git documentation](https://git-scm.com/doc): reference documentation and installation resources.
- [Pro Git book](https://git-scm.com/book/en/v2): a free introduction to Git concepts and workflows.
- [GitHub documentation](https://docs.github.com/en/get-started): guides for repositories, branches, pull requests, and collaboration.
- [GitHub CLI manual](https://cli.github.com/manual/): command reference for the `gh` command used by the GitHub publishing workflow.
- [Component README](../README.md): installation, technical overview, and API.
- [Git class](Classes/Git.md): automating Git commands from 4D.
- [gh class](Classes/gh.md): automating GitHub operations from 4D.
