#!/bin/bash
# Test suite. No network, no plugin installation.
set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

pass=0
fail=0

check() {
  if [ "$2" = "$3" ]; then
    printf '  ok   %s\n' "$1"
    pass=$((pass + 1))
  else
    printf '  FAIL %s\n' "$1"
    printf '       expected: %s\n' "$(printf '%s' "$2" | tr '\n' '⏎')"
    printf '       actual:   %s\n' "$(printf '%s' "$3" | tr '\n' '⏎')"
    fail=$((fail + 1))
  fi
}

check_status() {
  local name="$1" expected="$2"
  shift 2
  "$@" >/dev/null 2>&1
  local code=$?
  check "$name" "exit $expected" "exit $code"
}

echo "== manifests =="

check "plugin name" "norms" \
  "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$ROOT/.claude-plugin/plugin.json")"

check "declares the github dependency" "github@lounisbou" \
  "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["dependencies"][0])' "$ROOT/.claude-plugin/plugin.json")"

check "marketplace lists the plugin" "norms" \
  "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["plugins"][0]["name"])' "$ROOT/.claude-plugin/marketplace.json")"

echo "== components =="

check "eight agents" "8" "$(ls "$ROOT"/agents/norms-*.md | wc -l | tr -d ' ')"

for s in find-pattern validate; do
  check "skill $s exists" "yes" \
    "$([ -f "$ROOT/skills/$s/SKILL.md" ] && echo yes || echo no)"
  check "skill $s names its directory" "$s" \
    "$(sed -n 's/^name: *//p' "$ROOT/skills/$s/SKILL.md" | head -1)"
done

echo "== the project norms file is never bundled =="

# CONTRIBUTING.md is per-repository and local. A copy inside the plugin would
# ship one project's conventions to every other project.
check "no CONTRIBUTING.md at the plugin root" "absent" \
  "$([ -e "$ROOT/CONTRIBUTING.md" ] && echo present || echo absent)"

echo "== no project-specific paths leaked from the divergent variant =="

# The PHP/Symfony variant of this tooling references src/Protocol/*,
# migrations/Version*.php and PHPUnit's codeCoverageIgnore. None of that is
# portable; its presence here would mean project-specific content leaked into
# what must be a generic plugin.
leak=0
for needle in 'src/Protocol/' 'migrations/Version' 'codeCoverageIgnore'; do
  hits=$(grep -rl -- "$needle" "$ROOT/agents" "$ROOT/commands" "$ROOT/skills" 2>/dev/null | wc -l | tr -d ' ')
  check "no match for '$needle'" "0" "$hits"
done

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
