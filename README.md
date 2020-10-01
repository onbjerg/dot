# .

Various dotfiles

### Usage

The bootstrap script assumes you have `stow` available on your system and that the script lives in a directory with the dotfiles one folder above the home directory (e.g. in `$HOME/dot`).

### Configs

- [neovim](./nvim/.config/nvim)
- [i3](./i3/.config/i3)
- [polybar](./polybar/.config/polybar)
- [rofi](./rofi/.config/rofi)
- [fish](./fish/.config/fish)
- [alacritty](./alacritty/.config/alacritty)
- [fontconfig](./fontconfig/.config/fontconfig)
- [dunst](./dunst/.config/dunst)

### Notes

#### neovim

- Syntax highlighting in the `fzf` preview window requires [`bat`](https://github.com/sharkdp/bat)
- Requires [`ag`](https://github.com/ggreer/the_silver_searcher)

#### fish

- Optionally requires [`neofetch`](https://github.com/dylanaraps/neofetch)

#### i3

- Requires [`polybar`](https://github.com/polybar/polybar) and [`feh`](https://github.com/derf/feh)
- Requires [`rofi`](https://github.com/davatorium/rofi)
- Requires [`dunst`](https://github.com/dunst-project/dunst) for notifications

#### polybar

- Optionally requires [`playerctl`](https://github.com/altdesktop/playerctl) for Now Playing module
- Optionally requires [`gh`](https://github.com/cli/cli) and `jq` for Github module
