function pbpaste --wraps='xsel --clipboard --output' --description 'alias pbpaste=xsel --clipboard --output'
  xsel --clipboard --output $argv; 
end
