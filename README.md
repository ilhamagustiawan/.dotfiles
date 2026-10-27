# Dotfiles

[Homebrew](https://brew.sh/) installs tools and [GNU Stow](https://www.gnu.org/software/stow/) links configuration into `$HOME`.

- `packages/bundle` lists Homebrew packages and apps.
- `home/` is one Stow package that mirrors `$HOME`. For example, `home/.config/herdr/config.toml` links to `~/.config/herdr/config.toml`.
- `bootstrap.sh` installs the bundle and links `home/`.

Keep passwords, tokens, machine-specific state, and generated files out of this repository.

## Install

Install Homebrew, then run:

```sh
./bootstrap.sh
```

Stow never overwrites existing files. If a regular file sits at a target path, the script stops; move that file into the matching `home/` path and rerun. Apps that save settings can replace a link with a regular file, so this also catches config drift.

Preview or remove the links:

```sh
stow --simulate --restow --verbose --no-folding --dir "$PWD" --target "$HOME" home
stow --delete --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

