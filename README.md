<!-- MARKDOWN LINKS & IMAGES -->
[release-shield]: https://img.shields.io/github/v/release/vdelachaux/4DPop-Git.svg?include_prereleases
[release-url]: https://github.com/vdelachaux/4DPop-Git.svg/releases/latest

[license-shield]: https://img.shields.io/github/license/vdelachaux/4DPop-Git.svg

<!--BADGES-->
![Static Badge](https://img.shields.io/badge/Dev%20Component-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com)
![Static Badge](https://img.shields.io/badge/Project%20Dependencies-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com%2Fdocs%2FProject%2Fcomponents%2F%23loading-components)
<br>
[![release][release-shield]][release-url]
[![license][license-shield]](LICENSE)
<br>
<img src="https://img.shields.io/github/downloads/vdelachaux/4DPop-Git/total"/>

# 4DPop Git

**4DPop Git** brings a friendly, developer-oriented Git interface right inside the 4D IDE.

No need to read the <a href="https://git-scm.com/docs/git">**git**</a> command-line documentation or to be a Terminal expert: everyday operations — stage, commit, branch, fetch, pull, push, stash, diff — are handled for you, so you can stay focused on your work.

For a step-by-step introduction, see the [English user guide](Documentation/User-guide.md), or the [French user guide](Documentation/Guide-utilisateur.md).

It also exposes a scriptable API (the [`Git`](Documentation/Classes/Git.md) and [`gh`](Documentation/Classes/gh.md) classes) so you can automate Git and GitHub tasks from your own code.

## Highlights

- Visual overview of your working copy: pending changes, staged files and history.
- Everyday Git actions in a couple of clicks:
	- Stage / unstage / untrack files
	- Commit (with amend)
	- Fetch, pull and push (with force-with-lease)
	- Branch: create, switch, merge, rename, delete
	- Stash: save, snapshot, pop
	- Diff files with your external diff tool
- Commit history with author avatars (Gravatar) and asynchronous, non-blocking loading.
- **Per-method history from the code editor**: while editing a method or class, open the full Git history of *that* file — every commit that touched it (subject, author, date, short hash, ± line counts and rename tracking), the diff against the previous commit, plus a top entry for uncommitted changes (or a brand-new, not-yet-committed file).
- **Blame a selection**: select one or more lines of a method in the code editor and instantly see the last commit that modified them.
- **Fork-style commit graph**: colour-coded lanes for branches and merges, with reference labels — local branches, remotes (with their GitHub icon), tags and stashes — tinted to match their lane, in both light and dark mode.
- **Publish to GitHub** in one step, using the GitHub CLI (`gh`) with device-flow authentication — no manual token handling.
- Git LFS support.
- A scriptable API available to host projects through the `git` namespace.

## Prerequisites: Git must be installed

### macOS

Git ships with [Xcode](https://developer.apple.com/xcode/), so nothing more is needed if it is installed. Otherwise, install the latest version of Git from [this page](https://git-scm.com/download/mac).

### Windows

If you have not already done so, install Git from [this page](https://git-scm.com/download/win).

### Optional: GitHub CLI (for the *Publish to GitHub* feature)

The one-step *Publish to GitHub* flow relies on the [GitHub CLI](https://cli.github.com/). The component embeds a fallback binary, but installing `gh` on your machine is recommended.

## Installation

### Recommended (4D v21+): [Project dependencies](https://developer.4d.com/docs/Project/components/#adding-a-github-or-gitlab-dependency)

Use the 4D Dependencies Manager UI to install the component:

1. Open your project in 4D (v21+).
2. Open the Dependencies Manager.
3. Add a GitHub dependency.
4. Enter the GitHub repository address: `vdelachaux/4DPop-Git`.
5. Choose the version you want (for example `latest`).
6. Apply changes and let 4D update project dependencies.

No manual JSON editing is required.

4DPop Git is intended for **4D projects**. Git is not useful for binary databases (`.4db` or `.4dc`), whose structure is not managed as a set of project files.

## Usage

The component has three main entry points. For step-by-step instructions, see the [English user guide](Documentation/User-guide.md) or the [French user guide](Documentation/Guide-utilisateur.md).

### Widget

The Git widget in the 4DPop toolbar provides a quick overview of the current project: current branch, local changes, commits to pull, and commits to push. It also gives quick access to branch switching, changes, refresh, the repository, and settings.

<img src="./Documentation/widget.png" alt="4DPop Git widget">

### Main window

Open the 4DPop **Git** entry to display the main window. 

* The **Changes** page lets you review diffs, stage files, and create commits.

<img src="./Documentation/main.png" alt="4DPop Git main window">

* The **History** page provides commit details and a colored branch graph for branches, merges, remotes, tags, and stashes.

<img src="./Documentation/commitHistory.png" alt="4DPop Git commit history">

### Method editor macros

Installing the component automatically adds macros to the 4D method editor context menu while editing a method or class:

- **Insert macro > Git history…** opens the history of the file being edited.
- **Insert macro > Last commit for selection…** reports the last commit that modified the selected lines.

<img src="./Documentation/history.png" alt="Git history for a file">

## Scripting API

The component exposes two classes to host projects through the `git` class store namespace:

| Class | Access | Purpose |
|---|---|---|
| [`Git`](Documentation/Classes/Git.md) | `cs.git.Git.me` | Wrapper around the local `git` command line |
| [`gh`](Documentation/Classes/gh.md) | `cs.git.gh.me` | Wrapper around the GitHub CLI (auth, create/delete repositories) |

```4d
var $git : cs.git.Git:=cs.git.Git.me

$git.add("all")
$git.commit("My commit message")
$git.push()
```

See the [class documentation](Documentation/Classes) for the full API.

## Source code

The component is distributed in compiled form, with source code available in the `Sources` folder inside the component.
