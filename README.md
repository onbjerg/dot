# .

Various dotfiles.

### Usage

Use [`chezmoi`](https://www.chezmoi.io)

### Configs

- [git](./dot_gitconfig)
- [neovim](./dot_config/nvim)
- [fish](./dot_config/fish)
- [alacritty](./dot_config/alacritty)
- [fontconfig](./dot_config/fontconfig)
- [cargo](./dot_cargo)
- [tealdeer](./dot_config/tealdeer)

### Notes

#### Overall

- Requires [`exa`](https://github.com/ogham/exa) since `ls` is aliased to `exa`
- Requires [`bat`](https://github.com/sharkdp/bat) since `cat` is aliased to `bat`

#### git

- Requires [`delta`](https://github.com/dandavison/delta)

#### neovim

- Syntax highlighting in the `fzf` preview window requires [`bat`](https://github.com/sharkdp/bat)
- Requires [`ag`](https://github.com/ggreer/the_silver_searcher)

#### rust

The home (`RUSTUP_HOME`) is set to `$HOME/.local/share/rustup`.

#### cargo

The home (`CARGO_HOME`) is set to `$HOME/.local/share/cargo`.

- Uses [`sccache`](https://github.com/mozilla/sccache) (note: incremental compilation is [disabled][sccache_incremental])
- On Linux, [`mold`](https://github.com/rui314/mold) is used as a linker

[sccache_incremental]: https://github.com/mozilla/sccache#rust
