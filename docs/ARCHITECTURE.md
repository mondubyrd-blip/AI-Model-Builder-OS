# AI Model Builder OS v0.1 Architecture

## Core principle

The machine is treated as a model-building appliance rather than a conventional desktop.

## Layers

1. Boot/firmware
2. Minimal Linux kernel
3. Hardware capability layer
4. AI Builder orchestration layer
5. Model/data/artifact storage
6. Local dashboard
7. Optional normal-OS boot target

## Hardware abstraction

The node discovers available:
- CPU architecture/features
- memory
- PCI/PCIe devices
- graphics adapters
- accelerator/NPU interfaces exposed by the kernel/runtime
- storage
- network interfaces
- thermal/power telemetry when available

The capability map is data, not hard-coded assumptions.

## Reversibility

The final appliance should coexist with a normal OS through UEFI boot entries or a bootloader menu. The AI Builder must never silently repartition or erase disks.

## Model lifecycle

DATASET -> VALIDATE -> PREPARE -> TRAIN/FINE-TUNE -> CHECKPOINT -> EVALUATE -> QUANTIZE/CONVERT -> EXPORT

Each run should create a provenance manifest and hashes for important inputs/outputs.

## Safety boundary

No cloud service is required by the core appliance. Network access is optional and should be explicit.

## Board profiles

Hardware-specific tuning belongs in separate profiles. Board identity must not be inferred from CPU model alone; identify the board using firmware/device-tree/DMI evidence where available and validate peripherals on the actual device.
