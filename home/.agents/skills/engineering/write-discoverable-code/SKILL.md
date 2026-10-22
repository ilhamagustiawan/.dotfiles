---
name: write-discoverable-code
description: Make code easy to find through text search. Use when writing or renaming functions, types, constants, files, events, error messages, or documentation at their definitions.
license: MIT
---

# Write discoverable code

Make each concept resolvable through a name search or the plain words someone would use to ask about it. Follow the repository's conventions and existing domain vocabulary; improve the code in scope rather than renaming unrelated code.

## Names are search queries

- Use the shortest name that distinguishes the concept in this codebase. Give generic verbs their object: `sanitizeEmailHtml`, not `sanitize`, when the latter is ambiguous.
- Reuse the domain's spelling consistently. Consult `GLOSSARY.md` (or `GLOSSARY-MAP.md`) when present; avoid introducing a synonym for an existing concept.
- Prefer concept-named files where the repository permits it. Keep framework-required filenames and established module conventions.
- Keep one authoritative implementation per concept. When moving code, update references and remove the superseded implementation within the same change.
- When behavior changes, check that the name still describes it. Rename when the old name would mislead callers, accounting for public compatibility requirements.

## Put constraints where readers land

- At a definition, document the constraints the signature cannot express: units, timezone, ownership, ordering, or an important invariant. Skip comments that only repeat the name or code.
- Include natural-language search terms where they add a useful route to the definition: a session-expiry check can mention "session expired" in its documentation.
- Prefer whole literal event names, error codes, and diagnostic prefixes so a runtime message can lead back to its source. Keep variable context separate from the identifying literal.
- Name types for the concepts they represent. Use discriminated unions, branded IDs, or capability types when supported by the language and justified by real invalid-state or argument-order risks; follow existing conventions.
- Mark deprecated entry points with the supported replacement when a compatibility path must remain.

## Keep answers local

- Give each concept one clear home. Separate unrelated responsibilities, while keeping helpers that only make sense inside a module with that module.
- Preserve deep modules: a small interface may hide a substantial implementation. Searchability is not a reason to expose internals or introduce a file for every function.
- Keep tests easy to locate through the repository's established test layout and naming conventions.
- Use `codebase-design` for interface and seam decisions and `domain-modeling` for terminology decisions; these rules concern findability, not a competing architecture.

## Completion check

For the changed code, verify that:

1. A search for each new exported name reaches its definition without ambiguous generic matches.
2. Important constraints are visible in the signature or at the definition.
3. Stable event/error identifiers can be searched verbatim in source.
4. Names still describe the changed behavior, and moved code has no abandoned duplicate.

Adapted from dmmulroy/.dotfiles; see [source and licensing notes](../../SOURCES.md).
