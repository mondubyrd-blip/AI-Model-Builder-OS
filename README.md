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
