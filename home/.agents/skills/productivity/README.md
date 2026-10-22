# Productivity

General workflow tools, not code-specific.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[grill-me](./grill-me/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[bro](./bro/SKILL.md)**: Re-pitch a message with missing context, simplified English, and project glossary vocabulary. Renamed from `wait-what`; behavior preserved.
- **[handoff](./handoff/SKILL.md)**: Compact the current conversation into a handoff document so another agent can continue the work.
- **[teach](./teach/SKILL.md)**: Teach the user a new skill or concept over multiple sessions, using the current directory as a stateful teaching workspace.
- **[to-questionnaire](./to-questionnaire/SKILL.md)**: Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can (filled in async, or together over a meeting).
- **[show-me](./show-me/SKILL.md)**: Explain the current topic visually with diagrams, code sketches, or focused HTML.
- **[writing-for-agents](./writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md/CLAUDE.md, and any doc an agent reaches by a pointer. Manual-only in the synchronized upstream definition.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[grilling](./grilling/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea until every branch of the design tree is resolved.
- **[herdr](./herdr/SKILL.md)**: Control Herdr panes, processes, and agents when running inside Herdr.

## Sources

The original collection is from [mattpocock/skills](https://github.com/mattpocock/skills). `handoff` and `writing-for-agents` are synchronized with the dmmulroy snapshot; `herdr` is copied from it, and `show-me` is adapted. See [source, licensing, and deployment notes](../SOURCES.md), including the existing standalone Herdr installation conflict.
