# Capability Discovery Contract

The AI Builder separates hardware facts from hardware policy.

## Producer

scripts/capability_probe.py reads local Linux interfaces only:

- /proc/cpuinfo and /proc/meminfo
- /sys/class/dmi/id and /proc/device-tree/model when exposed
- /sys/bus/pci/devices
- /sys/block
- /sys/class/drm
- /sys/class/net
- selected /dev and /sys/class presence checks

It does not open network connections, mount filesystems, write to storage, or collect storage serial numbers, WWNs, UUIDs, or network MAC addresses.

## Output

The probe emits JSON conforming to schemas/node-capabilities.schema.json. The report includes the collection method and explicit false values for network use, storage modification, and serial-number collection.

A missing interface is represented by an empty collection or false presence flag. It must not be interpreted as proof that hardware does not exist; it may mean that the current kernel or live environment does not expose it.

## Policy boundary

The capability report is descriptive. It does not choose drivers, install packages, train models, or make claims that an accelerator is supported by a particular runtime.

The next layer will map detected devices and kernel drivers to tested runtime backends. Unknown or untested devices must remain marked unknown rather than being assigned speculative compatibility.
