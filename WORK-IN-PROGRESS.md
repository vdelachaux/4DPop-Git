# Work in progress

## Commit history context menu

Date: 2026-09-23

The Git history page has a contextual menu on the `commits` list, implemented in `Project/Sources/Classes/_GIT_Controller.4dm`.

Available actions:

- `New Branch...`: opens the existing `NEW BRANCH` dialog and uses the selected commit full SHA (`fingerprint.long`) as the start point.
- `New Tag...`: opens `Project/Sources/Forms/NEW TAG/` and creates a tag on the selected commit.
- `Create patch...`: saves `git format-patch -1 --stdout` output for the selected commit.
- `Copy SHA`: copies the full SHA.

After a successful branch or tag creation, the commit graph is refreshed.

## Branch dialog

`Project/Sources/Forms/NEW BRANCH/` validates the branch name while typing and keeps the OK button disabled until the name is valid according to Git branch naming rules.

The visible labels and button titles for `NEW BRANCH` and `NEW TAG` are localized through the `NEW_REF` entries in:

- `Resources/en.lproj/gitlab.xlf`
- `Resources/fr.lproj/gitlab.xlf`

The French label for creating and checking out a branch is `Créer et checkout`.

## Next check

Retest the complete flow in the 4D application:

1. Open the Git history page.
2. Right-click a commit.
3. Choose `New Branch...`.
4. Enter a valid branch name and create it, with and without checkout.
5. Confirm that no `Git encountered an error` dialog appears and that the commit graph updates.

The repository worktree currently contains uncommitted changes related to this work. Do not overwrite user adjustments before reviewing the diff.

Known unrelated diagnostics previously reported in `_GIT_Controller.4dm`:

- `_darkExtension` is undeclared.
- `_commitsCache.isLoadingStale` is unavailable.
