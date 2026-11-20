# Samsung Chromebook 4 — BLUEBIRD Port Record

## Target identification

User-supplied firmware photographs identify the machine as a Samsung Chromebook 4 with an Intel Celeron N4020 and 4096 MB RAM. The user identifies the board as **BLUEBIRD**. The firmware screen reports MrChromebox firmware dated 2026-10-28. The EFI shell photograph shows an `FS2:` mapping containing a Linux-style root filesystem layout; this does not by itself prove that the installed OS boots successfully or establish the underlying Linux block-device name.

## Relationship to Peppy

BLUEBIRD is a separate target profile. It must not be represented as Peppy merely because both targets use x86_64. The existing `configs/peppy_x86_64.example` is retained unchanged as historical v0.1 content. BLUEBIRD is added as a distinct profile.

## Proposed profile

- Board: BLUEBIRD
- Device: Samsung Chromebook 4
- Platform family: Octopus (verify against the exact hardware/firmware release before board-specific build configuration)
- CPU: Intel Celeron N4020, x86_64
- Memory: 4 GiB
- Graphics: Intel UHD Graphics 600 class integrated graphics (runtime discovery required)
- Dedicated NPU: none established by supplied evidence
- Boot: UEFI via the installed MrChromebox firmware, subject to validation on the actual device
- Storage capacity/controller: not established by supplied photographs

## Port status

This is a proposed hardware-profile adaptation, not a completed board port. No claim is made that a bootable image, kernel configuration, Wi-Fi, audio, touchpad, suspend, or storage support has been tested on BLUEBIRD.

## Validation requirements

1. Confirm board identity from firmware/DMI/device-tree identifiers on the machine.
2. Probe CPU, memory, graphics, storage controller/device, Wi-Fi, audio, USB, input devices, thermals, and power management from a trusted live environment.
3. Confirm the intended boot path and recovery path without modifying existing partitions.
4. Build and test from removable media before any installation work.
5. Record kernel, firmware, and driver versions with test results.

## Resource boundary

4 GiB RAM constrains this device to lightweight orchestration, hardware inventory, cataloging, and small inference experiments. It is not a practical primary training host for contemporary large models.
