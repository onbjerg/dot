function pbcopy --wraps='xsel --clipboard --input' --description 'alias pbcopy=xsel --clipboard --input'
  xsel --clipboard --input $argv; 
end
