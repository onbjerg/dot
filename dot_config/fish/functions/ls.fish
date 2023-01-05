function ls --wraps=exa --description 'alias ls=exa'
  if not set -q argv[1]
    set -a argv --binary --header --long --grid --git
  end 
  exa $argv; 
end
