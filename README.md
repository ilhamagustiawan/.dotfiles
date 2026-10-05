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
stow --simulate --restow --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

To remove the links:

```sh
stow --delete --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

Keep passwords, tokens, machine-specific state, and generated files out of this repository.

## Pi

Pi settings (`~/.pi/agent/settings.json`) and Antigravity CLI settings (`~/.gemini/antigravity-cli/settings.json`) stay local and are not managed by Stow. Their corresponding paths under `home/` are excluded from Git and from Stow by `home/.stow-local-ignore`. Configure providers, models, and packages separately on each machine.

Pi credentials, sessions, installed packages, and generated model catalogs also stay local and are ignored by Git and Stow. Install `npm:pi-antigravity` and authenticate separately on each machine if needed.

Codemode is optional. To enable it, add `"defaultTools": ["+codemode"]` to the Pi settings and run `/reload`.

## Agent skills

`home/.agents/skills/productivity/` contains the productivity skills copied from [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/productivity), including their supporting files and MIT license:

- `grill-me`
- `grilling`
- `handoff`
- `teach`
- `to-questionnaire`
- `wait-what`
- `writing-for-agents`

`home/.agents/skills/engineering/` contains these [engineering skills](https://github.com/mattpocock/skills/tree/main/skills/engineering), including their supporting files and the upstream MIT license:

- `code-review`
- `codebase-design`
- `diagnosing-bugs`
- `domain-modeling`
- `implement`
- `implement-spec`
- `pr`
- `prototype`
- `research`
- `retro`
- `to-spec`
- `to-tickets`
- `wayfinder`
- `wizard`

Upstream names the ticket-planning skill `to-tickets` (plural); no `to-implement` skill was present in the upstream snapshot.

Stow links these into `~/.agents/skills/`, where Pi and other Agent Skills-compatible tools can discover them. After adding the files, rerun Stow and reload Pi:

```sh
stow --restow --verbose --no-folding --dir "$PWD" --target "$HOME" home
```

Run `/reload` in Pi to load the skills.

## Fonts

Ghostty uses Berkeley Mono. Install your licensed Berkeley Mono `.otf` files with Font Book before launching Ghostty. The font files are not stored in this repository.
