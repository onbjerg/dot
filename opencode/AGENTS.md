# AGENTS.md

## Version Control

ALWAYS use `jj` (Jujutsu) for all version control operations. Only fall back to `git` when there is no `jj` equivalent.

Commit message headers (the first line) MUST ALWAYS be within 50 characters. The commit message body MUST ALWAYS be wrapped to 72 characters or less.

### Common jj commands

```bash
# Show status
jj st

# Show diff
jj diff

# Create a new change
jj new

# Describe a change
jj describe -m "message"

# Create a named bookmark (use prefix onbjerg/)
jj bookmark create onbjerg/<name>

# Move bookmark to current change
jj bookmark set onbjerg/<name>

# Squash into parent
jj squash

# Edit a previous change
jj edit <change-id>

# Rebase
jj rebase -d <destination>
```

### Bookmark Naming

Always use the `onbjerg/` prefix when creating bookmarks:

```bash
jj bookmark create onbjerg/feature-name
```

### Pushing Changes

When told to "push the changes", ALWAYS use:

```bash
jj gpc
```

Only use a different command if explicitly instructed OR if the current change is part of a bookmark.

## tmux

Use `tmux` to run interactive applications and development servers. Never run long-lived or interactive processes directly — always use a tmux session.

```bash
# Start a dev server in a named session
tmux new-session -d -s dev 'npm run dev'

# Run an interactive application
tmux new-session -d -s app './my-app'

# Check output
tmux capture-pane -t dev -p

# Send keys to a session
tmux send-keys -t dev 'C-c' Enter

# Kill a session
tmux kill-session -t dev
```

## Communication Style

When describing changes, use code blocks with backticks:

- Inline code: `example`
- Code blocks for commands, snippets, and diffs

## Cryptography

NEVER implement cryptographic functions (hashing, encryption, signatures, etc.) yourself. Always use existing implementations from dependencies already in the project. Only roll your own crypto if explicitly asked to do so.

## Specific Guidance

See @docs/*.md for more information.
