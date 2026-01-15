---
name: cargo-llvm-lines
description: Analyzes LLVM IR to find monomorphization bloat and compile time hotspots. Use when debugging slow builds, reducing binary size, or optimizing generic code.
---

# cargo-llvm-lines

Shows which functions generate the most LLVM IR lines, indicating compile time and binary size contributors.

## Usage

```bash
cargo llvm-lines [OPTIONS]
```

## Common Workflows

### Analyze library crate

```bash
cargo llvm-lines --lib
```

### Analyze specific binary

```bash
cargo llvm-lines --bin my_bin
```

### Sort by copy count (monomorphization)

```bash
cargo llvm-lines --lib --sort copies
```

### Filter to specific functions

```bash
cargo llvm-lines --lib | grep "my_module"
```

## Key Options

- `--lib` - Analyze library target
- `--bin <NAME>` - Analyze specific binary
- `--release` - Use release profile
- `--sort lines|copies` - Sort by IR lines (default) or instantiation count

## Reading Output

Output format: `Lines | Copies | Function`

```
  Lines  Copies  Function name
  -----  ------  -------------
  30000     100  core::fmt::write
   5000      50  alloc::vec::Vec<T>::push
```

- **Lines** - Total LLVM IR lines from all instantiations
- **Copies** - Number of monomorphized copies
- High copies with moderate lines = monomorphization bloat

## Common Fixes

- Extract non-generic inner functions to reduce copies
- Use `dyn Trait` instead of generics for cold paths
- Consider `#[inline(never)]` on large generic functions
