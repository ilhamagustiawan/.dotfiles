# Issue tracker: Beads

Use **Beads (`bd`)** as the project issue tracker. Specs, implementation tickets, and wayfinder maps live in Beads; reference them by title and Beads ID.

## Mental model

**Think → Create → Act.** Investigate with prompts or design docs, capture actionable work as issues, then execute from the ready queue. Issues are handoff points: another session should be able to resume from the issue's requirements, state, and context pointers.

Use Beads for active and near-term work. Keep the ready queue actionable; distant ideas and long-form documentation belong in their own artifacts. Specs explain why and what success means; Beads tracks execution. Link an existing spec rather than copying it into competing sources of truth.

## Before tracker operations

Run `bd --version` and `bd where` from the target repository to confirm the CLI and active workspace. If the CLI is missing, ask the user to install Beads. If the repository has no workspace, ask the user to initialize it with `bd init` before publishing or claiming work. Read the repo's Beads instructions when present. Consult `bd <command> --help` for installed-version flags and use `--json` when consuming results programmatically.

## Operations

- **Read:** `bd show <id>` and `bd comments <id>` for the full description, relationships, and discussion.
- **Publish a spec or map:** `bd create "<title>" --type epic --body-file <file> --labels <labels>`. Use `ready-for-agent` for specs and `wayfinder:map` for maps. Capture the returned ID.
- **Publish a ticket:** `bd create "<title>" --type task --body-file <file> --parent <parent-id> --labels <labels>`. Omit `--parent` when there is no existing parent. Implementation tickets use `ready-for-agent`; decision tickets use `wayfinder:<type>`.
- **Wire blocking:** `bd dep add <dependent-id> <blocker-id>`. The first issue waits for the second. Parent-child relationships group work; add blocking dependencies separately. Create all tickets before wiring edges so every endpoint has an ID.
- **List children:** `bd list --parent <parent-id> --all --limit 0`.
- **Find the frontier:** `bd ready --parent <parent-id> --unassigned --limit 0`. Omit the parent filter for standalone work. Readiness comes from native dependencies and status, not the `ready-for-agent` label.
- **Claim:** `bd update <id> --claim` before starting work. Proceed only if the claim succeeds; if another session owns it, choose another frontier ticket. Concurrent sessions should use distinct actor identities (via `BEADS_ACTOR` or `--actor`).
- **Capture discoveries:** `bd create "<title>" --type bug --priority 2 --description "<finding and completion criteria>" --deps discovered-from:<current-id> --json`. Choose the appropriate type and priority. `discovered-from` preserves provenance without blocking; use `blocks` only for a genuine prerequisite. Use `related` for a non-blocking connection without discovery provenance.
- **Record progress or resolution:** `bd comments add <id> "<answer, verification, and context pointers>"`. Include relevant commit, branch, file, or external URL pointers rather than duplicating artifacts.
- **Update a body:** read the latest body, edit it, then use `bd update <id> --body-file <file>`. Preserve concurrent changes to shared maps.
- **Apply / remove labels:** `bd update <id> --add-label <label>` / `--remove-label <label>`. Use `docs/agents/triage-labels.md` for overrides when present.
- **Close:** `bd close <id> --reason "<resolution summary>"` once its completion criteria are met. For implementation tickets, close after merging and verifying on the integration branch so dependents start from integrated work. Beads closure is explicit; opening or merging a PR does not replace it.

## Session bookends

**Start or resume:** read the repo's tracker instructions, run `bd ready --json` (scope to the current effort where appropriate), review the selected issue and comments, then claim it. If installed-version hooks or `bd prime` provide workflow context, use them after startup or context compaction; hooks supplement explicit queue checks.

**Land the plane:**

1. Run relevant quality gates and record their results.
2. File remaining discoveries and unfinished work with enough context for a fresh session.
3. Close verified work; update unfinished issues with progress, blockers, and the next action. Leave ownership in an intentional state using the repo's handoff convention.
4. Persist and synchronize tracker changes using the installed version and repo configuration. Follow the repo's commit/push policy; when remote sharing is authorized and required, verify it succeeded. Otherwise explicitly report what remains local or unsynchronized.
5. Give a concise handoff: issue titles and IDs, code branch/commit pointers, verification results, outstanding blockers, and the next ready action.

Prefer short sessions around bounded issues when context starts drifting. Persistent state enables cheap session replacement; it does not make agents consult the tracker automatically.

## Persistence and version compatibility

Check `bd --help` and repo configuration before selecting sync, hooks, or maintenance commands. Storage and synchronization are version-specific; do not assume that committing code also shares tracker state. In worktrees, verify `bd where` resolves the intended workspace before mutations.

This workflow draws on [Ian Bull's Beads guide](https://ianbull.com/posts/beads/). The post describes SQLite plus git-tracked JSONL, a daemon, and `bd sync`, and reports parent-child readiness semantics for that version. Treat those as historical implementation details: verify current behavior through installed help and `bd ready`, and express actual prerequisites as explicit blocking edges.

## Pull requests as a triage surface

**PRs as a request surface: no.** Work is tracked in Beads. PRs may carry code review and commit pointers but do not automatically close Beads issues.

## When a skill says "publish to the issue tracker"

Create a Beads issue using the operations above. Specs are epics; implementation slices are child tasks. A `ready-for-agent` label is classification, not a status or a substitute for dependency checks.

## When a skill says "fetch the relevant ticket"

Use `bd show <id>` and `bd comments <id>`. Issue references in commits use Beads IDs; follow parent relationships to find the full spec when necessary.

## Wayfinding operations

Used by `/wayfinder`:

- **Map:** an epic labelled `wayfinder:map` with the Destination / Notes / Decisions-so-far / Not-yet-specified body.
- **Child:** a task created with `--parent <map-id>` and a `wayfinder:<type>` label (`research`, `prototype`, `grilling`, or `task`).
- **Blocking:** `bd dep add <dependent-id> <blocker-id>`; create children first, then wire edges.
- **Frontier:** `bd ready --parent <map-id> --unassigned --limit 0`.
- **Claim:** `bd update <ticket-id> --claim` before work; a successful claim sets assignee and `in_progress` status. Use distinct session actors.
- **Resolve:** comment with the answer and artifact pointers, close the ticket, then append its title, Beads ID, and one-line gist to the map's Decisions-so-far. Use title-and-ID references instead of inventing issue URLs. Re-read the map before updating its body to preserve concurrent edits.

Markdown files passed to `--body-file` are authoring inputs, not a parallel tracker. Report created or resolved Beads IDs with their titles. Use explicit IDs for every mutation.
