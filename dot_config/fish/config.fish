if status is-interactive
    # fnm
    set PATH /home/oliver/.fnm $PATH
    fnm env --shell fish | source

    # Rust
    set RUSTUP_HOME $HOME/.local/share/rustup
    set CARGO_HOME $HOME/.local/share/cargo
    set PATH $HOME/.local/share/cargo/bin $PATH

    # Foundry
    set PATH $HOME/.foundry/bin $PATH

    # Prompt
    starship init fish | source
end
