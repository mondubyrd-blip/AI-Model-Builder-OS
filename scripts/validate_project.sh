#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail=0
for script in "$ROOT"/scripts/*.sh; do
  [ -f "$script" ] || continue
  if sh -n "$script"; then printf 'PASS shell syntax: %s\n' "${script#$ROOT/}"; else printf 'FAIL shell syntax: %s\n' "${script#$ROOT/}" >&2; fail=1; fi
done
if command -v shellcheck >/dev/null 2>&1; then
  if shellcheck "$ROOT"/scripts/*.sh; then echo 'PASS ShellCheck'; else echo 'FAIL ShellCheck' >&2; fail=1; fi
else echo 'SKIP ShellCheck (not installed)'; fi
if command -v python3 >/dev/null 2>&1; then
  python3 - "$ROOT/manifest.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding='utf-8') as f:
    data = json.load(f)
assert data.get('architecture') == 'x86_64'
assert data.get('destructive_install') is False
print('PASS manifest JSON and safety invariants')
PY
else echo 'SKIP manifest validation (python3 not installed)'; fi
exit "$fail"
