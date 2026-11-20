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
  python3 - "$ROOT" <<'PY'
import json, pathlib, subprocess, sys
root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / 'manifest.json').read_text(encoding='utf-8'))
assert manifest.get('architecture') == 'x86_64'
assert manifest.get('destructive_install') is False
print('PASS manifest JSON and safety invariants')
schema = json.loads((root / 'schemas/node-capabilities.schema.json').read_text(encoding='utf-8'))
report = json.loads(subprocess.check_output([sys.executable, str(root / 'scripts/capability_probe.py')], text=True))
assert report['collection']['network_used'] is False
assert report['collection']['storage_modified'] is False
assert report['collection']['serial_numbers_collected'] is False
assert report['cpu']['architecture']
try:
    import jsonschema
except ImportError:
    assert all(key in report for key in schema['required'])
    print('PASS capability report structural validation (jsonschema unavailable)')
else:
    jsonschema.validate(report, schema)
    print('PASS capability report JSON Schema validation')
PY
else echo 'SKIP JSON and capability validation (python3 not installed)'; fi
exit "$fail"
