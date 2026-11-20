#!/bin/sh
# Read-only inventory for a Linux live environment on Samsung Chromebook 4.
# Does not mount, modify, repartition, or write to disks.
set -u
section() { printf '\n=== %s ===\n' "$1"; }
section 'SYSTEM'
printf 'Kernel: '; uname -srmo 2>/dev/null || true
printf 'Hostname: '; hostname 2>/dev/null || true
section 'CPU'
if [ -r /proc/cpuinfo ]; then awk -F: '/^(model name|Hardware|vendor_id|cpu family|model)[[:space:]]*:/ {gsub(/^[ \t]+/, "", $2); print $1 ": " $2; if (++n == 8) exit}' /proc/cpuinfo; fi
section 'MEMORY'
awk '/^(MemTotal|MemAvailable|SwapTotal|SwapFree):/ {print}' /proc/meminfo 2>/dev/null || true
section 'FIRMWARE AND BOARD IDENTIFIERS'
for f in /sys/class/dmi/id/sys_vendor /sys/class/dmi/id/product_name /sys/class/dmi/id/board_name /sys/class/dmi/id/bios_vendor /sys/class/dmi/id/bios_version; do
  if [ -r "$f" ]; then printf '%s: ' "${f##*/}"; cat "$f"; fi
done
if [ -r /proc/device-tree/model ]; then printf 'device-tree model: '; tr -d '\000' </proc/device-tree/model; printf '\n'; fi
section 'PCI DEVICES AND DRIVERS'
if command -v lspci >/dev/null 2>&1; then lspci -nnk 2>/dev/null || true; else echo 'lspci not installed'; fi
section 'USB DEVICES'
if command -v lsusb >/dev/null 2>&1; then lsusb 2>/dev/null || true; else echo 'lsusb not installed'; fi
section 'STORAGE (NO SERIAL NUMBERS)'
if command -v lsblk >/dev/null 2>&1; then lsblk -o NAME,TYPE,SIZE,RO,TRAN,MODEL,MOUNTPOINTS 2>/dev/null || lsblk 2>/dev/null || true; else echo 'lsblk not installed'; fi
section 'GRAPHICS'
for f in /sys/class/drm/card*/device/vendor /sys/class/drm/card*/device/device; do [ -r "$f" ] || continue; printf '%s: ' "$f"; cat "$f"; done
ls -1 /sys/class/drm 2>/dev/null || true
section 'NETWORK'
if command -v ip >/dev/null 2>&1; then ip -brief link 2>/dev/null || true; fi
if command -v iw >/dev/null 2>&1; then iw dev 2>/dev/null || true; fi
if command -v rfkill >/dev/null 2>&1; then rfkill list 2>/dev/null || true; fi
section 'AUDIO'
if command -v aplay >/dev/null 2>&1; then aplay -l 2>/dev/null || true; fi
if [ -d /sys/class/sound ]; then ls -1 /sys/class/sound 2>/dev/null || true; fi
section 'ACCELERATOR INTERFACES'
for d in /dev/accel /sys/class/accel; do if [ -e "$d" ]; then ls -la "$d" 2>/dev/null || true; else printf 'Not exposed: %s\n' "$d"; fi; done
section 'POWER AND THERMALS'
for d in /sys/class/power_supply /sys/class/thermal; do if [ -d "$d" ]; then find "$d" -maxdepth 2 -type f \( -name type -o -name status -o -name capacity -o -name temp \) -print 2>/dev/null; fi; done
section 'END'
echo 'Read-only inventory complete. Review output before using it as a board-support claim.'
