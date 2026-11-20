#!/bin/sh
set -eu
echo "AI Model Builder OS v0.1"
echo
echo "This release is the architecture/test skeleton."
echo "A real bootable image requires a pinned Buildroot tree/toolchain."
echo "No disks are modified by this script."
echo
echo "Next implementation stage:"
echo "  1. pin Buildroot release"
echo "  2. add x86_64 defconfig"
echo "  3. add kernel config"
echo "  4. package hardware probe"
echo "  5. package dashboard"
echo "  6. produce reproducible ISO/IMG"
