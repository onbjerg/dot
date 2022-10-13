if status is-interactive
    # fnm
    set PATH /home/oliver/.fnm $PATH
    fnm env --shell fish | source

    # Rust
    set PATH $HOME/.cargo/bin $PATH

    # Foundry
    set PATH $HOME/.foundry/bin $PATH

    # Prompt
    starship init fish | source
end
