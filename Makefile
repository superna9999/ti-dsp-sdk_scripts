# DSP Top Makefile

TOPDIR = $(PWD)

LINUX_VER=4.4.2-dm81xx

DEVICE = TI816X
SDK = EZSDK
EXEC_DIR = $(TOPDIR)/install
DEPOT = $(TOPDIR)
LINUXKERNEL = $(DEPOT)/linux/KERNEL
CGT_ARM_INSTALL_DIR = $(DEPOT)/linux/dl/gcc-linaro-5.2-2015.11-2-x86_64_arm-linux-gnueabihf
CGT_ARM_PREFIX = $(CGT_ARM_INSTALL_DIR)/bin/arm-linux-gnueabihf-
IPC_INSTALL_DIR = $(DEPOT)/ipc
BIOS_INSTALL_DIR = $(DEPOT)/sysbios
XDC_INSTALL_DIR = $(DEPOT)/xdctools
CGT_C674_ELF_INSTALL_DIR = $(DEPOT)/codegen
CGT_M3_ELF_INSTALL_DIR = $(DEPOT)/toolchain

all: linux/deploy/$(LINUX_VER).zImage \
     syslink/packages/ti/syslink/bin/TI816X/syslink.ko \
     syslink/packages/ti/syslink/bin/TI816X/samples/slaveloader_release \
     buildroot/output/images/rootfs.tar
	cp buildroot/output/images/rootfs.tar rootfs.tar
	(cd install && tar xfz ../linux/deploy/$(LINUX_VER)-modules.tar.gz)
	depmod -b install/ $(LINUX_VER)
	(cd install && mkdir -p lib/firmware )
	(cd install/lib/firmware && tar xfz ../../../linux/deploy/$(LINUX_VER)-firmware.tar.gz)
	(cd install && tar --append --file=../rootfs.tar ./*)

syslink/packages/ti/syslink/bin/TI816X/syslink.ko:
	$(MAKE) -C syslink DEVICE=$(DEVICE) \
			   SDK=$(SDK) \
			   EXEC_DIR=$(EXEC_DIR) \
			   DEPOT=$(DEPOT) \
			   LINUXKERNEL=$(LINUXKERNEL) \
			   CGT_ARM_INSTALL_DIR=$(CGT_ARM_INSTALL_DIR) \
			   CGT_ARM_PREFIX=$(CGT_ARM_PREFIX) \
			   IPC_INSTALL_DIR=$(IPC_INSTALL_DIR) \
			   BIOS_INSTALL_DIR=$(BIOS_INSTALL_DIR) \
			   XDC_INSTALL_DIR=$(XDC_INSTALL_DIR) \
			   CGT_C674_ELF_INSTALL_DIR=$(CGT_C674_ELF_INSTALL_DIR) \
			   CGT_M3_ELF_INSTALL_DIR=$(CGT_M3_ELF_INSTALL_DIR) \
			   USE_SYSLINK_NOTIFY=0 \
			   syslink-driver \
			   install-driver

syslink/packages/ti/syslink/bin/TI816X/samples/slaveloader_release:
	$(MAKE) -C syslink DEVICE=$(DEVICE) \
			   SDK=$(SDK) \
			   EXEC_DIR=$(EXEC_DIR) \
			   DEPOT=$(DEPOT) \
			   LINUXKERNEL=$(LINUXKERNEL) \
			   CGT_ARM_INSTALL_DIR=$(CGT_ARM_INSTALL_DIR) \
			   CGT_ARM_PREFIX=$(CGT_ARM_PREFIX) \
			   IPC_INSTALL_DIR=$(IPC_INSTALL_DIR) \
			   BIOS_INSTALL_DIR=$(BIOS_INSTALL_DIR) \
			   XDC_INSTALL_DIR=$(XDC_INSTALL_DIR) \
			   CGT_C674_ELF_INSTALL_DIR=$(CGT_C674_ELF_INSTALL_DIR) \
			   CGT_M3_ELF_INSTALL_DIR=$(CGT_M3_ELF_INSTALL_DIR) \
			   USE_SYSLINK_NOTIFY=0 \
			   syslink-hlos \
			   samples-hlos
	mkdir -p install/bin/
	cp syslink/packages/ti/syslink/bin/TI816X/samples/slaveloader_release install/bin/slaveloader

buildroot/output/images/rootfs.tar:
	cp buildroot_rootfs_defconfig buildroot/configs
	(cd buildroot && $(MAKE) buildroot_rootfs_defconfig)
	(cd buildroot && $(MAKE) olddefconfig)
	(cd buildroot && $(MAKE) -s)

linux/deploy/$(LINUX_VER).zImage:
	cd $(DEPOT)/linux/ && ./build_kernel.sh

clean:
	(cd buildroot && $(MAKE) distclean)
	-rm -fr linux/deploy
	-rm -fr install
	-$(MAKE) -C syslink clean
