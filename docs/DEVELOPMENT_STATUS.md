# Development Status

Updated: 2026-11-19

## Repository and source integrity

- [x] Original v0.1 ZIP archived in the repository without changing its bytes.
- [x] SHA-256 recorded.
- [x] Original Peppy profile retained as a legacy reference.
- [x] BLUEBIRD identified as the active Chromebook target profile.
- [x] Runtime-tree script corrected to use POSIX shell syntax.
- [x] Read-only hardware inventory utility added.
- [x] Local validation script added.

## Build system

- [x] Buildroot 2025.02 LTS family selected.
- [ ] Verify official release signature and checksum.
- [ ] Create a Buildroot external tree with release-compatible package definitions.
- [ ] Generate and review a generic x86_64 baseline defconfig.
- [ ] Pin a kernel version and kernel configuration after hardware inventory.
- [ ] Build reproducibly in a disposable Linux build environment.
- [ ] Boot test image in a VM.
- [ ] Boot test image from removable media on BLUEBIRD.

## BLUEBIRD device support

- [ ] Confirm board identity from runtime identifiers.
- [ ] Identify eMMC controller and storage device.
- [ ] Identify Wi-Fi/Bluetooth chipset and required firmware.
- [ ] Confirm Intel graphics driver and display modesetting.
- [ ] Confirm audio codec and audio devices.
- [ ] Confirm keyboard, touchpad, USB, and suspend/resume.
- [ ] Confirm battery/thermal reporting and throttling behavior.
- [ ] Document a verified recovery path.

## AI Builder services

- [ ] Replace init placeholder with a supervised service.
- [ ] Implement hardware capability schema and JSON output.
- [ ] Implement local job queue and lifecycle state machine.
- [ ] Implement provenance manifest generation and artifact hashing.
- [ ] Implement dashboard with authentication and loopback-only default binding.
- [ ] Select model runtimes based on hardware and license compatibility.
- [ ] Add dataset/model validation and evaluation workflows.

## Current release statement

The repository is an architecture and development scaffold. It is not a bootable OS image, not a completed BLUEBIRD port, and not a functioning model-training appliance. No internal Chromebook storage has been modified.
