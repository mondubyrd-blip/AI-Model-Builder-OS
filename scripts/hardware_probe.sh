#!/bin/sh
set -eu
echo "=== AI BUILDER HARDWARE PROBE ==="
echo
printf '%s\n' '[CPU]'
grep -m1 'model name' /proc/cpuinfo 2>/dev/null || true
echo
printf '%s\n' '[MEMORY]'
awk '/MemTotal/ {print $0}' /proc/meminfo 2>/dev/null || true
echo
printf '%s\n' '[PCI]'
if command -v lspci >/dev/null 2>&1; then
  lspci 2>/dev/null | grep -Ei 'VGA|3D|Display|Processing accelerators|NPU|AI|Network|Wireless|Audio|SATA|eMMC|Non-Volatile' || true
else
  echo "lspci unavailable in this prototype environment"
fi
echo
printf '%s\n' '[DMI]'
if command -v dmidecode >/dev/null 2>&1; then
  dmidecode -s system-product-name 2>/dev/null || true
  dmidecode -s system-manufacturer 2>/dev/null || true
fi
echo
printf '%s\n' '[DEVICE TREE]'
if [ -r /proc/device-tree/model ]; then tr -d '\000' </proc/device-tree/model; echo; else echo "No device-tree model exposed"; fi
echo
printf '%s\n' '[DRM]'
ls -1 /sys/class/drm 2>/dev/null || true
echo
printf '%s\n' '[ACCELERATORS]'
ls -la /dev/accel 2>/dev/null || echo "No /dev/accel interface exposed"
