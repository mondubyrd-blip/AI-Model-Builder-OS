AIBUILDER_VERSION = 0.1
AIBUILDER_SITE = $(BR2_EXTERNAL_AIBUILDER_PATH)/..
AIBUILDER_SITE_METHOD = local
AIBUILDER_DEPENDENCIES = python3

# Package the inventory utilities only. The orchestration engine and
# dashboard are not implemented in this prototype.
define AIBUILDER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/scripts/capability_probe.py $(TARGET_DIR)/usr/bin/aibuilder-capability-probe
	$(INSTALL) -D -m 0755 $(@D)/scripts/bluebird_inventory.sh $(TARGET_DIR)/usr/bin/aibuilder-bluebird-inventory
	$(INSTALL) -D -m 0755 $(@D)/scripts/create_runtime_tree.sh $(TARGET_DIR)/usr/bin/aibuilder-create-runtime-tree
	$(INSTALL) -D -m 0644 $(@D)/schemas/node-capabilities.schema.json $(TARGET_DIR)/usr/share/aibuilder/node-capabilities.schema.json
	$(INSTALL) -D -m 0644 $(@D)/rootfs-overlay/etc/aibuilder/node.conf $(TARGET_DIR)/etc/aibuilder/node.conf
endef

$(eval $(generic-package))
