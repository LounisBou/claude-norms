# claude-norms

Evidence-based code norms tooling for [Claude Code](https://claude.com/claude-code), packaged as the `norms` plugin.

## What it does

Eight review agents check a diff against a project's own established conventions —
never against generic style opinions. Every finding must cite evidence: either an
explicit rule in the project's `CONTRIBUTING.md`, or a pattern demonstrably repeated
in the existing codebase. No evidence, no finding.

- `norms-pattern-conformity` — structural patterns, function shapes, DI style, error handling
- `norms-variable-naming` — naming conventions
- `norms-test-structure` — test file structure conventions
- `norms-diff-scope` — flags unrelated changes, reformatting, out-of-scope hunks
- `norms-import-organization` — unused/duplicate imports, grouping/ordering
- `norms-magic-values` — hardcoded values that should be extracted
- `norms-documentation` — missing documentation where the project's own conventions require it
- `norms-test-coverage` — coverage gaps relative to the project's existing baseline

## Commands and skills

- `/norms:check` — runs the eight agents above in parallel against the current diff
- `/norms:learn` — after a PR is merged or reviewed, reads its resolved review
  threads and turns the generalizable ones into rules in the project's own
  `CONTRIBUTING.md`
- `find-pattern` skill — pre-implementation pattern discovery for a given file type
- `validate` skill — validates `CONTRIBUTING.md` structure before `/norms:check` relies on it

## CONTRIBUTING.md stays with the project

`CONTRIBUTING.md` lives at the root of whatever project you run these commands
in, not inside this plugin — the plugin never bundles or ships one. A copy
committed here would ship one project's conventions to every other project
that installs it.

Rules are grouped under `## [section]` headings. Four sections have a fixed
reader: `[type-strictness]`, `[test-conventions]`, `[naming]` and
`[code-hygiene]`. Any other section is read by the pattern-conformity agent,
and its first prose line is its scope: a sentence naming a path (for example
"Rules specific to migrations under `migrations/`") restricts the section to
files under that path, and a section with no such sentence applies to every
source file.

## GitHub dependency

The plugin's manifest (`.claude-plugin/plugin.json`) declares `"dependencies":
["github@lounisbou"]`. Only `/norms:learn` uses it, to fetch a PR's resolved
review threads; `/norms:check`, `find-pattern`, and `validate` work offline
and never touch it.

## Installation

```
/plugin marketplace add LounisBou/claude-norms
/plugin install norms@claude-norms
```

Once the aggregate `lounisbou` marketplace lists this plugin, `norms@lounisbou`
becomes the canonical install key instead.

## Tests

```
CLAUDE_GITHUB_ROOT=<path to a github plugin checkout> bash tests/run-tests.sh
```

The suite runs offline and needs no GitHub account or installed plugin; it
resolves the `github` plugin from `CLAUDE_GITHUB_ROOT` (or the platform's own
install record) purely to check that `/norms:learn` calls only subcommands and
formats that tool actually exposes. If the `github` plugin can't be resolved,
the suite fails loudly with an `error:`/`fix:` pair rather than skipping the
check. Sample run:

```
20 passed, 0 failed
```

## Licence

MIT.
