# fnm
set PATH /home/oliver/.fnm $PATH
fnm env --shell fish | source

# Rust
set PATH $HOME/.local/share/cargo/bin $PATH

# Foundry
set PATH $HOME/.foundry/bin $PATH

if status is-interactive
    # Prompt
    starship init fish | source
end
