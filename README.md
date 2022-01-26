# .

Various dotfiles.

### Usage

The bootstrap script assumes you have `stow` available on your system and that the script lives in a directory with the dotfiles one folder above the home directory (e.g. in `$HOME/dot`).

### Configs

- [Xresources](./xresources)
- [git](./git)
- [neovim](./nvim/.config/nvim)
- [bspwm](./i3/.config/i3)
- [sxhkd](./sxhkd/.config/sxhkd)
- [polybar](./polybar/.config/polybar)
- [rofi](./rofi/.config/rofi)
- [fish](./fish/.config/fish)
- [alacritty](./alacritty/.config/alacritty)
- [fontconfig](./fontconfig/.config/fontconfig)
- [dunst](./dunst/.config/dunst)

### Notes

#### Overall

- Requires [`exa`](https://github.com/ogham/exa) since `ls` is aliased to `exa`
- Requires [`bat`](https://github.com/sharkdp/bat) since `cat` is aliased to `bat`

#### git

- Requires [`delta`](https://github.com/dandavison/delta)

#### neovim

- Syntax highlighting in the `fzf` preview window requires [`bat`](https://github.com/sharkdp/bat)
- Requires [`ag`](https://github.com/ggreer/the_silver_searcher)

#### bspwm 

- Requires [`polybar`](https://github.com/polybar/polybar) and [`feh`](https://github.com/derf/feh)
- Requires [`dunst`](https://github.com/dunst-project/dunst) for notifications

#### sxhkd

- Requires [`rofi`](https://github.com/davatorium/rofi)
- Requires [`shotgun`](https://github.com/neXromancers/shotgun) and [`hacksaw`](https://github.com/neXromancers/hacksaw) for screenshots

