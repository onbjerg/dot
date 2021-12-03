# fnm
set PATH /home/oliver/.fnm $PATH
fnm env --shell fish | source

# cargo
set PATH /home/oliver/.cargo/bin $PATH

# nix
bass source $HOME/.nix-profile/etc/profile.d/nix.sh
