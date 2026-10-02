# Dotfiles

This repository uses [Homebrew](https://brew.sh/) to install tools and [GNU Stow](https://www.gnu.org/software/stow/) to link configuration files into your home directory.

## Layout

- `packages/bundle` lists Homebrew packages and apps.
- `home/` is a single Stow package. Its contents mirror paths under `$HOME`.
- `bootstrap.sh` installs `packages/bundle` and links `home/` into `$HOME`.

For example, `home/.config/herdr/config.toml` links to `~/.config/herdr/config.toml`.

## Install

Install Homebrew first if it is missing, then run:

```sh
./bootstrap.sh
```

The script checks all links before creating them. If an existing file occupies a target path, it stops and reports the conflict. Move that file into the matching `home/` path, or back it up yourself, then rerun the script. Existing files are never adopted or overwritten automatically.

To preview links without installing software:

```sh
stow --simulate --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

To remove the links:

```sh
stow --delete --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

Keep passwords, tokens, machine-specific state, and generated files out of this repository.

## Pi

`home/.pi/agent/settings.json` stores the default provider/model and Pi package declarations. Device IDs and changelog state are omitted; credentials, sessions, installed packages, and generated model catalogs stay local and are ignored by Git.

If `~/.pi/agent/settings.json` already exists, back it up before linking:

```sh
mv ~/.pi/agent/settings.json ~/.pi/agent/settings.json.backup
stow --simulate --verbose --no-folding --dir "$PWD" --target "$HOME" home
stow --restow --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

Pi loads the declared `npm:pi-antigravity` package on startup. Authenticate separately on each machine; authentication files are not managed by Stow.

Codemode is optional. To enable it, add `"defaultTools": ["+codemode"]` to the Pi settings and run `/reload`.

## Fonts

Ghostty uses Berkeley Mono. Install your licensed Berkeley Mono `.otf` files with Font Book before launching Ghostty. The font files are not stored in this repository.
