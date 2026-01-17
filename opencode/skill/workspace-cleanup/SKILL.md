---
name: workspace-cleanup
description: Cleans up stale jj workspaces based on age or pushed bookmarks. Use when asked to clean, prune, or remove old jj workspaces.
---

# Workspace Cleanup

Removes stale jj workspaces (older than 7 days OR all bookmarks pushed).

## Step 1: List Stale Workspaces

```bash
python3 scripts/list_stale.py <cwd>
# Returns JSON: [{"name": "...", "path": "...", "age_days": N, "reason": "age|pushed"}]
```

Exit codes: 0 = success, 2 = cannot determine workspace root

## Step 2: Present & Confirm

Show table (Workspace | Age | Reason), then ask user which to delete:
- "all"/"yes" -> delete all
- Specific names -> delete those
- "none"/"no" -> cancel

## Step 3: Delete

```bash
python3 scripts/delete.py <main-repo-cwd> <workspace-name> <workspace-path>
```

Forgets workspace from jj, removes directory, cleans empty parents.
