# BLUEBIRD Hardware Validation Matrix

Target: Samsung Chromebook 4, board BLUEBIRD, Intel Celeron N4020, 4 GiB RAM.

Status key: `UNKNOWN` means not yet measured on this exact machine. Photographs of firmware and an EFI filesystem do not substitute for Linux runtime tests.

| Area | Current evidence | Required validation | Status |
|---|---|---|---|
| Board identity | User identifies board as BLUEBIRD | Confirm DMI/device-tree/firmware board identifier | PARTIAL |
| CPU | Firmware screen reports Celeron N4020 | Confirm CPU flags and microcode from Linux | PARTIAL |
| RAM | Firmware screen reports 4096 MB | Confirm usable RAM and memory map | PARTIAL |
| UEFI | MrChromebox firmware setup photographed | Confirm UEFI boot of removable test media | PARTIAL |
| eMMC | EFI shell maps an FS filesystem | Identify controller, device, capacity, and read-only health data | UNKNOWN |
| Graphics | Processor platform suggests integrated Intel graphics | Confirm PCI ID, i915 driver, DRM nodes, modesetting | UNKNOWN |
| Wi-Fi | Not shown in supplied photographs | Identify PCI/USB adapter, driver, firmware, scan | UNKNOWN |
| Bluetooth | Not shown | Identify adapter and test enumeration | UNKNOWN |
| Audio | Not shown | Identify codec/controller and test playback/capture | UNKNOWN |
| Keyboard/touchpad | Not shown | Confirm input devices and suspend/resume | UNKNOWN |
| USB | Firmware alias indicates a USB controller path | Enumerate ports and test removable boot media | PARTIAL |
| Battery/thermal | Firmware shows 95% battery | Read battery, thermal zones, throttling under load | PARTIAL |
| Suspend/resume | Not shown | Test repeated suspend/resume | UNKNOWN |
| Recovery path | Firmware menu photographed | Document verified recovery path before any bootloader changes | UNKNOWN |

## Safe test sequence

1. Preserve the current internal storage state.
2. Boot a trusted, known Linux live environment from removable media.
3. Run `scripts/bluebird_inventory.sh` without mounting internal partitions read-write.
4. Save the output with date, kernel version, and live-image identifier; redact serial numbers if separately collected by other tools.
5. Validate Wi-Fi, audio, input, graphics, storage, suspend, and thermal behavior.
6. Only after those results are reviewed should a BLUEBIRD-specific kernel configuration be created.

No step in this matrix authorizes repartitioning, flashing firmware, or installing to internal eMMC.
