---
globs:
  - '**/*.rs'
---

Before considering any work complete, **always** run:

```bash
# Format with nightly
cargo +nightly fmt --all

# Lint with clippy
cargo clippy --workspace --all-targets
```

Fix any warnings or errors before finishing.

## Safety

Whenever you use unwrap, you must include a note why it is safe, e.g.

```
let a: Option<usize> = Some(1usize);
// SAFETY: Guaranteed to always be `Some`
let b: usize = a.unwrap();
```
