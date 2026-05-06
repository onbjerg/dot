---
name: rust
description: Rust development conventions for formatting, linting, safety comments, and completion checks. Use when writing, editing, reviewing, or testing Rust code.
---

# Rust

Use this skill whenever working with Rust source files (`*.rs`) or Rust projects.

These conventions are based on `https://github.com/onbjerg/dot/blob/master/amp/docs/rust-conventions.md`.

## Required completion checks

Before considering any Rust work complete, always run:

```bash
cargo +nightly fmt --all
cargo clippy --workspace --all-targets
```

Fix any formatting issues, clippy warnings, clippy errors, and compiler errors before finishing.

If a repository has documented project-specific test or lint commands, run those as well; these Rust checks are the baseline.

## Safety comments for `unwrap`

Whenever adding or keeping a call to `unwrap`, include a nearby note explaining why it is safe.

Example:

```rust
let a: Option<usize> = Some(1usize);
// SAFETY: Guaranteed to always be `Some`.
let b: usize = a.unwrap();
```

Prefer avoiding `unwrap` when a clear error propagation or handling path is appropriate. When `unwrap` is intentional, the safety note should describe the invariant that guarantees it cannot panic.
