#!/bin/sh
set -eu
ROOT="${1:-/var/lib/aibuilder}"
for dir in base-models datasets tokenizers training checkpoints adapters quantization evaluation exports logs hardware workspace manifests; do
  mkdir -p "$ROOT/$dir"
done
echo "Created AI Builder runtime tree at $ROOT"
