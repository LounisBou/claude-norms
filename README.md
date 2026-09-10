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

## Commands

- `/norms:check` — runs the eight agents in parallel against the current diff
- `/norms:learn` — after a PR is merged or reviewed, captures reviewer feedback as
  reusable rules in the project's `CONTRIBUTING.md`

## Skills

- `find-pattern` — pre-implementation pattern discovery for a given file type
- `validate` — validates `CONTRIBUTING.md` structure before `/norms:check` relies on it

## Installation

Add this repository as a Claude Code plugin marketplace and install the `norms` plugin.

## License

MIT
