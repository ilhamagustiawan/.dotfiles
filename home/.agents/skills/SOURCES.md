# Skill sources and local changes

## Existing imports

The engineering and productivity collections were imported from [mattpocock/skills](https://github.com/mattpocock/skills). Their existing MIT notices remain in [engineering/LICENSE](engineering/LICENSE) and [productivity/LICENSE](productivity/LICENSE). Those notices apply to the imported material, not automatically to separately sourced additions.

`productivity/bro` is the former `wait-what` skill, renamed locally with its behavior preserved. `engineering/pr` retains its existing Humanlayer / Dex Horthy attribution; its visual guidance now lives in `productivity/show-me/VISUAL-GUIDANCE.md` for reuse.

## dmmulroy snapshot

Source: [dmmulroy/.dotfiles at `9dccb2d0dc067b666e4d97faa506fabc877529bf`](https://github.com/dmmulroy/.dotfiles/tree/9dccb2d0dc067b666e4d97faa506fabc877529bf/home/.agents/skills).

| Local skill | Source folder | Treatment |
| --- | --- | --- |
| `engineering/diagnosing-bugs` | `diagnosing-bugs` | Definition and supporting files match the snapshot. |
| `productivity/handoff` | `handoff` | Definition and supporting files match the snapshot. |
| `productivity/writing-for-agents` | `writing-for-agents` | Definition and supporting files match the snapshot, including manual-only frontmatter. |
| `productivity/herdr` | `herdr` | Definition copied verbatim. |
| `productivity/show-me` | `show-me` | Adapted: shared visual guidance extracted from the existing `pr` skill; HTML handling respects active mode, permissions, and host tools. |
| `engineering/write-discoverable-code` | `write-discoverable-code` | Adapted: repository conventions take precedence over rigid naming, file, comment, and type prescriptions; unsupported measurements omitted. Source frontmatter declares MIT. |

The pinned repository contains no general license file or separate license notices for these new source folders. Preserve the source declarations and attribution here; do not interpret the neighboring mattpocock MIT files as a blanket license for separately sourced material. Confirm reuse terms with the relevant authors before redistributing material whose license is unspecified.

## Deployment

Before deploying these additions, resolve the existing standalone `~/.agents/skills/herdr` directory: it has the same skill name as `productivity/herdr`. Do not delete or overwrite it automatically. Inspect Stow's dry-run output and the installed skills before deciding which copy to keep active.

After resolving conflicts, use the Stow command in the root README and reload the client (Pi: `/reload`). Also verify that the old `wait-what` installation is gone and only `bro` is discoverable after the rename. Client invocation support varies; the copied frontmatter and existing supporting metadata are retained as sourced.
