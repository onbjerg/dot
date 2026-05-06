---
name: jj
description: "Jujutsu (jj) version control reference. Use when working with jj repositories, translating git workflows to jj, or when you need more information about jj commands, revsets, templates, conflicts, bookmarks, or commits."
---

# jj Skill

Use this skill when you need more information about Jujutsu (`jj`) or need to perform version-control work in a jj repository.

## First principles

- Prefer `jj` commands over `git` commands in repositories that use Jujutsu.
- jj snapshots the working copy at the start of most commands; `@` is the working-copy commit.
- There is no staging area. The working tree is already represented by `@`.
- Creating a commit normally means describing `@` and moving the working copy to a new empty change on top.
- Use `jj help <command>` whenever command details are unclear; the installed jj version is authoritative.

## Common commands

Inspect state:

```bash
jj status
jj log
jj log -n 20
jj diff
jj diff <files...>
jj show @
```

Commit current work:

```bash
jj commit -m "feat(scope): summarize the change"
```

Commit only specific paths, leaving other changes in the new working-copy commit:

```bash
jj commit -m "fix(scope): summarize the change" path/to/file another/path
```

Interactively choose hunks:

```bash
jj commit -i -m "fix(scope): summarize the change"
```

Set or edit the description without creating a new change:

```bash
jj describe -m "docs(scope): summarize the change"
jj describe --editor
```

Create a new change:

```bash
jj new
jj new <revision>
```

Abandon an unwanted change:

```bash
jj abandon <revision>
```

Restore files from another revision:

```bash
jj restore --from <revision> path/to/file
```

Resolve conflicts:

```bash
jj status
jj resolve --list
jj resolve path/to/file
```

Bookmarks, when needed for remote collaboration:

```bash
jj bookmark list
jj bookmark set <name> -r <revision>
jj bookmark move <name> --to <revision>
```

Remote operations, only when explicitly requested:

```bash
jj git fetch
jj git push
```

## Useful help topics

Use these when you need more detail:

```bash
jj help
jj help status
jj help log
jj help diff
jj help commit
jj help describe
jj help new
jj help restore
jj help bookmarks
jj help git
jj help revsets
jj help templates
jj help filesets
```

## Revsets quick reference

- `@`: working-copy commit
- `@-`: first parent of the working-copy commit
- `@--`: grandparent of the working-copy commit
- `::@`: ancestors of `@`
- `@::`: descendants of `@`
- `mutable()`: mutable commits
- `immutable()`: immutable commits

Examples:

```bash
jj log -r '::@'
jj diff -r @-
jj show -r @
```

## Safety guidelines

- Do not push unless the user explicitly asks.
- Ask before abandoning, rebasing, splitting, or otherwise rewriting changes if intent is unclear.
- Prefer path-limited or interactive commands when unrelated changes are present.
- When uncertain, inspect with `jj status`, `jj diff`, and `jj help <command>` before acting.
