# Buildroot Baseline Decision

## Selected release family

- Buildroot series: **2025.02 LTS**
- Bugfix release visible on the official release page at project start: **2025.02.20**
- Archive: https://buildroot.org/downloads/buildroot-2025.02.20.tar.xz
- Status: release family selected; checksum/signature verification and a successful build are still pending.

## Rationale

Buildroot's official manual states that releases in the 2025.02 LTS series receive three years of support. The newer 2026.08 series is a stable non-LTS series. The LTS family is selected as the maintenance baseline for a reproducible appliance. This does not imply that the selected release has been built or tested on BLUEBIRD.

Official references:
- https://buildroot.org/download.html
- https://buildroot.org/news.html
- https://buildroot.org/downloads/manual/manual.html

## Build policy

1. Pin the exact release archive.
2. Verify the official signature and checksum before extraction.
3. Keep kernel version/configuration pinned separately after hardware support is assessed.
4. Build in a disposable Linux environment or isolated build host.
5. Test from removable media; do not write to the Chromebook's internal storage.
6. Record Buildroot configuration, kernel configuration, toolchain, package versions, source hashes, and output-image hashes.

## BLUEBIRD status

No Buildroot defconfig is declared production-ready yet. The board identity and device components need confirmation from a read-only inventory of the actual machine. A generic x86_64 image is not proof of BLUEBIRD board support.
