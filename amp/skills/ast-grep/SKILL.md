---
name: ast-grep
description: Structural code search using ast-grep. Use for syntax-aware searches, finding patterns, refactoring, or when you need to understand code structure beyond plain text matching.
---

# ast-grep

A CLI tool for structural code search using AST patterns.

## When to Use

Use ast-grep instead of text-based search (grep, ripgrep) when:
- You need syntax-aware matching (not just text)
- Searching for code patterns regardless of formatting
- Finding function definitions, calls, or specific constructs
- Refactoring or analyzing code structure

## Basic Usage

```bash
ast-grep --lang <language> -p '<pattern>'
```

### Supported Languages

Common languages: `rust`, `typescript`, `javascript`, `python`, `go`, `c`, `cpp`, `java`, `kotlin`, `swift`, `ruby`, `lua`, `html`, `css`

## Pattern Syntax

### Metavariables

- `$NAME` - matches a single AST node (identifier, expression, etc.)
- `$$$ARGS` - matches zero or more nodes (for argument lists, etc.)
- `$_` - matches any single node (wildcard)

### Examples

Find all function calls to a specific function:
```bash
ast-grep --lang rust -p 'println!($$$ARGS)'
```

Find all struct definitions:
```bash
ast-grep --lang rust -p 'struct $NAME { $$$FIELDS }'
```

Find all async functions:
```bash
ast-grep --lang rust -p 'async fn $NAME($$$ARGS) $BODY'
```

Find method calls on a type:
```bash
ast-grep --lang rust -p '$EXPR.unwrap()'
```

Find if-let patterns:
```bash
ast-grep --lang rust -p 'if let $PATTERN = $EXPR { $$$BODY }'
```

Find React component definitions (TypeScript):
```bash
ast-grep --lang typescript -p 'function $NAME($PROPS): JSX.Element { $$$BODY }'
```

Find Python class definitions:
```bash
ast-grep --lang python -p 'class $NAME: $$$BODY'
```

## Useful Options

- `--json` - Output results as JSON for parsing
- `--color=never` - Disable color (useful for piping)
- `-i, --interactive` - Interactive mode for reviewing matches
- `--rewrite <pattern>` - Replace matches with a new pattern

## Tips

1. Start with a simple pattern and refine
2. Use `$_` when you don't care about a specific part
3. Use `$$$` for variadic matches (arguments, statements)
4. Test patterns interactively with `ast-grep --interactive`
