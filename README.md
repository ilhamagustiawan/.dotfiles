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

## Local-only files

These are excluded from Git and Stow by `.gitignore` and `home/.stow-local-ignore`, so set them up on each machine:

- `~/.config/opencode/service.json`: OpenCode service credentials.
- `~/.pi/agent/settings.json` and `~/.gemini/antigravity-cli/settings.json`: Pi and Antigravity CLI settings.
- Pi credentials, sessions, installed packages, and generated model catalogs. Install `npm:pi-antigravity` and authenticate if needed. For Codemode, add `"defaultTools": ["+codemode"]` to the Pi settings and run `/reload`.
- `*.gpui-lock`: lock files Herdr UI creates beside linked configs.

## Herdr UI

Settings changed in the app are saved to `home/.config/herdr/config-gpui.local.toml`. The app rewrites `~/.config/herdr/config-gpui.toml` with its defaults on startup, so that file is not tracked.

## OpenCode

Plannotator reviews open in Safari via `PLANNOTATOR_BROWSER` in the Fish configuration, without changing the default browser. Restart the agent from a new Fish shell after changing it.

## Tinycast

Settings live in `home/.config/tinycast/settings.json`, based on [dmmulroy's configuration](https://github.com/dmmulroy/.dotfiles/tree/main/home/.config/tinycast). After linking, enable **Settings → Backup → Settings File** and choose **Import**, not Replace. From then on, GUI changes update the JSON file and file edits apply live.

Command-Space opens the launcher and Right Command is Hyper. Hyper-1 through Hyper-5 open Zen, Ghostty, Spotify, TickTick, and Obsidian; Hyper-V opens clipboard history; Control-Option-H/J/K/L manage windows. Emoji search uses the `em` alias. Keep these shortcuts free in Spotlight and other launchers.

Grant Accessibility permission for paste and window actions, and set launch at login yourself. Review settings diffs for personal paths or prompts before committing.

## Agent skills

Stow links `home/.agents/skills/` into `~/.agents/skills/`, where Pi and other Agent Skills tools find them. Run `/reload` in Pi after changes.

- `productivity/`: `bro` (renamed from `wait-what`), `grill-me`, `grilling`, `handoff`, `herdr`, `show-me`, `teach`, `to-questionnaire`, `writing-for-agents`.
- `engineering/`: `code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `implement`, `implement-spec`, `pr`, `prototype`, `research`, `retro`, `setup-engineering-skills`, `to-spec`, `to-tickets`, `wayfinder`, `wizard`, `write-discoverable-code`.

Most come from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT, license retained). `diagnosing-bugs`, `handoff`, `writing-for-agents`, and `herdr` follow a pinned dmmulroy snapshot; `show-me` and `write-discoverable-code` are adapted. [SOURCES.md](home/.agents/skills/SOURCES.md) has the commits, local changes, and license details.

## Fonts

Ghostty and Herdr UI use Berkeley Mono. Install your licensed `.otf` files with Font Book; they are not stored here.
