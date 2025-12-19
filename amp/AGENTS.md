# Global Agent Guidelines

## Version Control

Prefer using `jj` (Jujutsu) over `git` for version control operations.

## Code Search

You are operating in an environment where ast-grep is installed. For any code search that requires understanding of syntax or code structure, you should default to using `ast-grep --lang [language] -p '<pattern>'`. Adjust the `--lang` flag as needed for the specific programming language. Avoid using text-only search tools unless a plain-text search is explicitly requested.

## Rust

Prefer using nightly toolchain for formatting and linting:
- `cargo +nightly fmt`
- `cargo +nightly clippy`
