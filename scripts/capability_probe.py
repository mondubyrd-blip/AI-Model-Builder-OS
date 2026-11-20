#!/usr/bin/env python3
"""Offline, read-only hardware capability inventory. No network or disk writes."""
from __future__ import annotations
import argparse
import json
import os
import platform
import re
from pathlib import Path
from typing import Any


def read_text(path: Path) -> str | None:
    try:
        return path.read_text(errors="replace").strip().replace("\x00", "") or None
    except (OSError, PermissionError):
        return None


def cpu_info() -> dict[str, Any]:
    result: dict[str, Any] = {"architecture": platform.machine(), "logical_processors": os.cpu_count()}
    cpuinfo = read_text(Path("/proc/cpuinfo")) or ""
    for key in ("model name", "Hardware", "vendor_id"):
        match = re.search(rf"^{re.escape(key)}\s*:\s*(.+)$", cpuinfo, re.MULTILINE)
        if match:
            result["model" if key in ("model name", "Hardware") else "vendor"] = match.group(1).strip()
    return result


def memory_info() -> dict[str, int]:
    values: dict[str, int] = {}
    text = read_text(Path("/proc/meminfo")) or ""
    for key in ("MemTotal", "MemAvailable", "SwapTotal", "SwapFree"):
        match = re.search(rf"^{key}:\s+(\d+)\s+kB", text, re.MULTILINE)
        if match:
            values[key.lower() + "_kb"] = int(match.group(1))
    return values


def board_info() -> dict[str, str]:
    result: dict[str, str] = {}
    mapping = {
        "manufacturer": "/sys/class/dmi/id/sys_vendor",
        "product": "/sys/class/dmi/id/product_name",
        "board": "/sys/class/dmi/id/board_name",
        "firmware_vendor": "/sys/class/dmi/id/bios_vendor",
        "firmware_version": "/sys/class/dmi/id/bios_version",
    }
    for key, path in mapping.items():
        value = read_text(Path(path))
        if value:
            result[key] = value
    dt_model = read_text(Path("/proc/device-tree/model"))
    if dt_model:
        result["device_tree_model"] = dt_model
    return result


def pci_devices() -> list[dict[str, str]]:
    devices: list[dict[str, str]] = []
    root = Path("/sys/bus/pci/devices")
    if not root.is_dir():
        return devices
    for dev in sorted(root.iterdir()):
        item: dict[str, str] = {"address": dev.name}
        for key in ("vendor", "device", "class", "subsystem_vendor", "subsystem_device"):
            value = read_text(dev / key)
            if value:
                item[key] = value
        try:
            item["driver"] = (dev / "driver").resolve().name
        except OSError:
            pass
        devices.append(item)
    return devices


def block_devices() -> list[dict[str, str]]:
    devices: list[dict[str, str]] = []
    root = Path("/sys/block")
    if not root.is_dir():
        return devices
    for dev in sorted(root.iterdir()):
        item: dict[str, str] = {"name": dev.name}
        sectors = read_text(dev / "size")
        if sectors and sectors.isdigit():
            item["size_bytes"] = str(int(sectors) * 512)
        for key in ("queue/rotational", "removable"):
            value = read_text(dev / key)
            if value is not None:
                item[key.replace("/", "_")] = value
        # Deliberately omit serial numbers, WWNs, UUIDs, and partition contents.
        devices.append(item)
    return devices


def drm_devices() -> list[dict[str, str]]:
    devices: list[dict[str, str]] = []
    root = Path("/sys/class/drm")
    if not root.is_dir():
        return devices
    for card in sorted(root.glob("card[0-9]*")):
        if "-" in card.name:
            continue
        item = {"name": card.name}
        for key in ("vendor", "device"):
            value = read_text(card / "device" / key)
            if value:
                item[key] = value
        try:
            item["driver"] = (card / "device" / "driver").resolve().name
        except OSError:
            pass
        devices.append(item)
    return devices


def network_devices() -> list[dict[str, str]]:
    devices: list[dict[str, str]] = []
    root = Path("/sys/class/net")
    if not root.is_dir():
        return devices
    for iface in sorted(root.iterdir()):
        if iface.name == "lo":
            continue
        item = {"interface": iface.name}
        for key in ("type", "operstate"):
            value = read_text(iface / key)
            if value:
                item[key] = value
        try:
            item["driver"] = (iface / "device" / "driver").resolve().name
        except OSError:
            pass
        devices.append(item)
    return devices


def device_nodes() -> dict[str, bool]:
    return {
        "accelerator_device_directory": Path("/dev/accel").exists(),
        "accelerator_sysfs_class": Path("/sys/class/accel").exists(),
        "drm_class": Path("/sys/class/drm").exists(),
        "sound_class": Path("/sys/class/sound").exists(),
        "thermal_class": Path("/sys/class/thermal").exists(),
        "power_supply_class": Path("/sys/class/power_supply").exists(),
    }


def build_report() -> dict[str, Any]:
    return {
        "schema_version": "1.0.0",
        "collection": {"method": "local_sysfs_procfs", "network_used": False, "storage_modified": False, "serial_numbers_collected": False},
        "system": {"kernel": platform.release(), "platform": platform.platform()},
        "board": board_info(),
        "cpu": cpu_info(),
        "memory": memory_info(),
        "pci_devices": pci_devices(),
        "block_devices": block_devices(),
        "graphics": drm_devices(),
        "network_devices": network_devices(),
        "interfaces": device_nodes(),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", "-o", help="Write JSON to this file; default is stdout")
    args = parser.parse_args()
    encoded = json.dumps(build_report(), indent=2, sort_keys=True) + "\n"
    if args.output:
        Path(args.output).write_text(encoded, encoding="utf-8")
    else:
        print(encoded, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
