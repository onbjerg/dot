---
name: workspace-init
description: Initializes jj workspaces for agent threads. Use when starting work on a task that needs an isolated workspace.
---

# Workspace Initialization

Creates isolated jj workspaces for agent threads.

## Usage

```bash
python3 scripts/init.py <cwd> <workspace-name> [base-revision]
```

**Workspace name**: Slugify the task title (lowercase, hyphens, alphanumeric only, max 50 chars).
Example: "Add JWT authentication!" → `add-jwt-authentication`

## Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success | Prints workspace path |
| 1 | Already in non-default workspace | Skip creation |
| 2 | Cannot determine workspace root | Error |
| 3 | Workspace collision | Ask for different name |

On success: inform user "Created workspace `<name>` at `<path>`"
