# Automatic Fork Synchronization

This repository includes an automated workflow to keep the fork synchronized with the upstream repository at [noctalia-dev/noctalia-shell](https://github.com/noctalia-dev/noctalia-shell).

## How It Works

The workflow is defined in `.github/workflows/sync-upstream.yml` and automatically:

1. **Runs Daily**: The workflow executes every day at 2 AM UTC
2. **Manual Trigger**: You can also manually trigger it from the Actions tab
3. **Syncs Main Branch**: Automatically merges changes from the upstream repository's default branch
4. **Handles Conflicts**: If merge conflicts occur, the workflow will fail and notify you to resolve them manually

## Manual Trigger

To manually sync your fork:

1. Go to the **Actions** tab in your GitHub repository
2. Select the **"Sync Fork with Upstream"** workflow
3. Click **"Run workflow"** button
4. Select the branch and click **"Run workflow"**

## Syncing Additional Branches

By default, the workflow only syncs the main/default branch. If you want to automatically sync additional feature branches:

1. Edit `.github/workflows/sync-upstream.yml`
2. Find the `BRANCHES_TO_SYNC` array
3. Add your branch names, for example:
   ```bash
   BRANCHES_TO_SYNC=("develop" "feature-branch" "another-branch")
   ```

## Handling Merge Conflicts

If the automatic sync encounters merge conflicts:

1. You'll receive a notification that the workflow failed
2. Manually resolve conflicts by:
   ```bash
   git remote add upstream https://github.com/noctalia-dev/noctalia-shell.git
   git fetch upstream
   git checkout main  # or your branch name
   git merge upstream/main
   # Resolve conflicts in your editor
   git commit
   git push origin main
   ```

## Disabling Auto-Sync

To disable automatic synchronization:

1. Go to the **Actions** tab
2. Select **"Sync Fork with Upstream"**
3. Click the **"•••"** menu
4. Select **"Disable workflow"**

Alternatively, delete the `.github/workflows/sync-upstream.yml` file.

## Requirements

- The workflow requires `contents: write` permission (already configured)
- Uses the default `GITHUB_TOKEN` (no additional secrets needed)
