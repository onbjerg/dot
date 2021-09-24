# This file signs in to 1Password (if available)
# and pulls a bunch of secrets for ease of use.
function secrets
  # Check if 1Password was installed
  if not type -q op
    echo "1Password CLI is not set up.
  Please install 1Password CLI for your system secrets can be pulled." 1>&2
    exit 1
  end

  # Sign in
  bass (op signin my.1password.com)
  if not set -q OP_SESSION_my
    echo Sign in failed.
    exit 1
  end

  # Load all dotfiles
  op list items | jq -c -r '.[] | select(.overview.tags[]? | contains("dotfiles")) | .uuid' | while read -l item
    set contents (op get item $item)
    echo "Loading" (echo $contents | jq -c -r '.overview.title')
    bass (echo $contents | jq -c -r '.details.notesPlain')
  end
end
