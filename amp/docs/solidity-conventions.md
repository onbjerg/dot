---
globs:
  - '**/*.sol'
  - '**/*.t.sol'
  - '**/*.s.sol'
---

Before considering any work complete, if the project is a Foundry project, **always** run:

```bash
# Format with Foundry
forge fmt

# Run lint
forge lint

# Run tests
forge test
```

Fix any warnings or errors before finishing.

## Safety

Whenever you do something deemed "unsafe" by a lint or the compiler, you must include a note why it is safe.
