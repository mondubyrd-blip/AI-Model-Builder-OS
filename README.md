# AI Model Builder OS — v0.1 Prototype

Purpose: a bootable-appliance prototype for turning commodity x86_64 hardware into a dedicated AI model-builder node.

This is **not yet the final Buildroot ISO**. v0.1 is the reproducible project skeleton used to validate the architecture safely before touching the Ryzen 9.

Hardware profile status: original v0.1 profiles are preserved. The Samsung Chromebook 4 BLUEBIRD target is documented separately in `configs/bluebird_x86_64.example` and `docs/BLUEBIRD_PORT.md`.

Design: UEFI -> minimal Linux/Buildroot -> hardware discovery -> AI Builder services -> local dashboard.

The prototype deliberately keeps the normal OS intact. It is intended to be developed/tested first in a VM or disposable USB environment.

## Directory layout

- `configs/` target profiles
- `board/` board-specific files (future)
- `package/` AI Builder packages/services
- `rootfs-overlay/` immutable root filesystem additions
- `scripts/` build/test utilities
- `docs/` architecture and provenance notes
- `data/` runtime mount layout
- `licenses/` third-party license inventory placeholder

## v0.1 scope

- x86_64 appliance architecture
- hardware capability discovery
- CPU/GPU/NPU inventory where discoverable through Linux interfaces
- model/dataset/artifact directory convention
- local-only dashboard service (planned)
- provenance manifest format
- reversible boot design
- no cloud dependency
- no automatic model training
- no destructive disk operations

This repository contains an architecture/development scaffold, not a bootable ISO or completed model-training appliance.

## Important

This prototype does not claim that every NPU is usable for every AI workload. Accelerator support is hardware/backend dependent.

It also does not make an ownership claim about AI-generated synthetic data. Every dataset/model should carry provenance and applicable license/terms information.

## Original v0.1 source preservation

The original uploaded archive is preserved byte-for-byte at:
- `archive/AI_Model_Builder_OS_v0.1_prototype.zip`

Its SHA-256 is recorded in `docs/ORIGINAL_ARCHIVE_SHA256.txt`. The archive is the historical source baseline; subsequent engineering work is kept as separate repository changes.

## Current hardware target

The primary port target is now **Samsung Chromebook 4 — BLUEBIRD**. The previous Peppy profile remains as a legacy reference and is not being used as the Bluebird identity.

- Target profile: `configs/bluebird_x86_64.example`
- Port record: `docs/BLUEBIRD_PORT.md`
- Validation matrix: `docs/BLUEBIRD_VALIDATION_MATRIX.md`
- Read-only inventory: `scripts/bluebird_inventory.sh`
- Machine-readable capability report: `scripts/capability_probe.py`
- Capability schema: `schemas/node-capabilities.schema.json`
- Discovery contract: `docs/CAPABILITY_DISCOVERY.md`

The profile is proposed pending actual device validation. No bootable Bluebird image is claimed.

## Build baseline

The selected build-system baseline is Buildroot 2025.02.20 from the 2025.02 LTS series. See `docs/BUILDROOT_BASELINE.md`. Signature/checksum verification and a reproducible build are still pending.

## Local validation

Run:

```sh
./scripts/validate_project.sh
```

For the Bluebird inventory, boot a trusted Linux live environment and run:

```sh
sudo ./scripts/bluebird_inventory.sh
```

The inventory script is read-only. It does not mount or write internal storage. Review its output before treating any device capability as established.
