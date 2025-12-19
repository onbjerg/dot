# Rust
set PATH $HOME/.local/share/cargo/bin $PATH

# Foundry
set PATH $HOME/.foundry/bin $PATH

# Prompt
function fish_prompt
  set -l last_status  $status
  set -l glyph        "\$"
  set -l glyph_color  (set_color normal)
  set -l pwd          (prompt_pwd)
  set -l pwd_color    (set_color blue)


  if test (id -u "$USER") -eq 0
    set glyph "#"
  end

  printf "$pwd_color$pwd $glyph_color$glyph "
end

function fish_right_prompt
  fish_vcs_prompt
end

function fish_vcs_prompt
  fish_jj_prompt $argv
  or fish_git_prompt $argv
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/onbjerg/.lmstudio/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# amp
fish_add_path "$HOME/.amp/bin"
