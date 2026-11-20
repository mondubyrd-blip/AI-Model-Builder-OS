# AI Model Builder Buildroot External Tree

This is the initial Buildroot external-tree integration. It packages the read-only hardware inventory utilities and the capability schema. It does not provide a bootable board image, training engine, dashboard, or init daemon.

Use with the pinned Buildroot 2025.02.20 LTS source tree after verifying the official source archive and signature. The external tree is not yet validated against an extracted Buildroot source tree; package syntax/build validation remains pending.
