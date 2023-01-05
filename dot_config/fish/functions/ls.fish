function ls --wraps=exa --description 'alias ls=exa'
  if not set -q argv[1]
    set -a argv --long --tree --level 2 --git --header
  end 
  exa $argv; 
end
