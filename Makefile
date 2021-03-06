# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

# make package/I350/clean
# make package/I350/compile
# make package/I350/install

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=I350
PKG_VERSION:=5.3.5.42
PKG_RELEASE:=0

F_NAME:=igb-$(PKG_VERSION)
PKG_SOURCE:=$(F_NAME).tar.gz
PKG_SOURCE_URL:=https://downloadmirror.intel.com/13663/eng/
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_HASH:=8feccf37b10cde1d68caa883a153d7584ae03312ad93101fe873c51e43e8b517

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
	SUBMENU:=Network Devices
	TITLE:=I350 Driver
endef

define KernelPackage/$(PKG_NAME)/description
	I350 Kernel Driver.
	download form Intel
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	tar -C $(PKG_BUILD_DIR) -xvzf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		SUBDIRS="$(PKG_BUILD_DIR)/$(F_NAME)/src" \
		CONFIG_IGB=$(CONFIG_PACKAGE_kmod-$(PKG_NAME)) \
		modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
