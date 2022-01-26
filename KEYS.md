## Note on signing key

This is a note for myself.

To import the Keybase key for signing commits:

- `keybase pgp export | gpg --import`
- `keybase pgp export --secret | keybase --allow-secret-key --import`
- `gpg --list-secret-keys`
- `gpg --edit-key $KEY_ID`
- Trust it
