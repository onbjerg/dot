---
name: cargo-asm
description: Inspects generated assembly for Rust functions using cargo-asm. Use when analyzing low-level codegen, verifying SIMD/vectorization, or debugging performance at the instruction level.
---

# cargo-asm

Displays the generated assembly for specific Rust functions.

## Usage

```bash
cargo asm [OPTIONS] <PATH>
```

Where `<PATH>` is a function path like `crate::module::function` or a partial match.

## Common Workflows

### View assembly for a function

```bash
cargo asm my_crate::hot_loop
```

### List all available symbols

```bash
cargo asm --lib
```

### Show with source interleaved

```bash
cargo asm --rust my_crate::function
```

### Check specific target features

```bash
RUSTFLAGS="-C target-cpu=native" cargo asm my_crate::simd_fn
```

## Key Options

- `--rust` - Interleave Rust source with assembly
- `--lib` - Analyze library target (vs binary)
- `--bin <NAME>` - Analyze specific binary
- `--release` - Use release profile (default)
- `--dev` - Use dev profile
- `--target <TRIPLE>` - Cross-compile target

## Tips

- Always use `--release` (or it's on by default) to see optimized output
- Use `--rust` to understand which source lines map to which instructions
- Look for `vmov`, `vpadd`, etc. to verify SIMD vectorization
- Missing function? Try `--lib` or check if it was inlined
