# AGENTS.md

## Version Control

Use `jj` (Jujutsu) for all version control operations. Only fall back to `git` when there is no `jj` equivalent.

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

## Communication Style

When describing changes, use code blocks with backticks:

- Inline code: `example`
- Code blocks for commands, snippets, and diffs

## Code Search

 You are operating in an environment where ast-grep is installed. For any code search that requires understanding of syntax or code structure, you should default to using `ast-grep --lang [language] -p '<pattern>'`. Adjust the `--lang` flag as needed for the specific programming language. Avoid using text-only search tools unless a plain-text search is explicitly requested.

## Specific Guidance

See @docs/*.md for more information.
