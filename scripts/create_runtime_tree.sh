#!/bin/sh
set -eu

ROOT=${1:-/var/lib/aibuilder}

# Refuse dangerous or ambiguous destinations. The caller must explicitly
# supply a path if the default is not appropriate.
case "$ROOT" in
  /|/boot|/etc|/home|/root|/usr|/var|/var/lib)
    echo "Refusing unsafe runtime-tree destination: $ROOT" >&2
    exit 2
    ;;
esac

for name in \
  base-models datasets tokenizers training checkpoints adapters \
  quantization evaluation exports logs hardware workspace manifests; do
  mkdir -p "$ROOT/$name"
done
printf 'Created AI Builder runtime tree at %s\n' "$ROOT"
