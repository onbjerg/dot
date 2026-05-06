---
name: commit
description: "Read this skill before making jj commits"
---

Create a jj commit for the current changes using a concise Conventional Commits-style subject.

## Format

`<type>(<scope>): <summary>`

- `type` REQUIRED. Use `feat` for new features, `fix` for bug fixes. Other common types: `docs`, `refactor`, `chore`, `test`, `perf`.
- `scope` OPTIONAL. Short noun in parentheses for the affected area (e.g., `api`, `parser`, `ui`).
- `summary` REQUIRED. Short, imperative, <= 72 chars, no trailing period.

## Notes

- Body is OPTIONAL. If needed, add a blank line after the subject and write short paragraphs.
- Do NOT include breaking-change markers or footers.
- Do NOT add sign-offs (no `Signed-off-by`).
- Only commit; do NOT push.
- If it is unclear whether a file should be included, ask the user which files to commit.
- Treat any caller-provided arguments as additional commit guidance. Common patterns:
  - Freeform instructions should influence scope, summary, and body.
  - File paths or globs should limit which files to commit. If files are specified, only include those paths in the jj commit unless the user explicitly asks otherwise.
  - If arguments combine files and instructions, honor both.

## jj notes

- jj has no separate staging area. The working-copy commit `@` already contains the current working tree snapshot.
- `jj commit -m "<subject>"` describes the current working-copy commit and creates a new empty working-copy commit on top.
- `jj commit -m "<subject>" <files...>` includes only those paths in the committed change and moves remaining changes to the new working-copy commit.
- Use `jj commit -i -m "<subject>"` when you need to interactively choose hunks.
- For a body, pass one message containing the subject, blank line, and body, for example `jj commit -m $'<subject>\n\n<body>'`.

## Steps

1. Infer from the prompt if the user provided specific file paths/globs and/or additional instructions.
2. Review `jj status` and `jj diff` to understand the current changes (limit to argument-specified files if provided).
3. (Optional) Run `jj log -n 50 --no-graph -T 'description.first_line() ++ "\n"'` to see commonly used scopes.
4. If there are ambiguous extra files, ask the user for clarification before committing.
5. Include only the intended files:
   - If no files are specified, commit all current changes in `@`.
   - If files are specified, pass those files to `jj commit` so unrelated changes remain in the new working-copy commit.
   - If only some hunks should be included, use `jj commit -i`.
6. Run `jj commit -m "<subject>"` (or `jj commit -m $'<subject>\n\n<body>'` if needed), adding file arguments when the user limited the commit to specific paths.
