# DSP Top Makefile

TOPDIR = $(PWD)

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

all: $(LINUXKERNEL)/include/config/kernel.release \
     syslink/packages/ti/syslink/bin/TI816X/syslink.ko \
     buildroot/output/images/rootfs.tar

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
			   syslink-driver syslink-hlos

buildroot/output/images/rootfs.tar:
	cp buildroot_rootfs_defconfig buildroot/configs
	(cd buildroot && $(MAKE) buildroot_rootfs_defconfig)
	(cd buildroot && $(MAKE) olddefconfig)
	(cd buildroot && $(MAKE) -s)

$(LINUXKERNEL)/include/config/kernel.release:
	cd $(DEPOT)/linux/ && ./build_kernel.sh

clean:
	(cd buildroot && $(MAKE) distclean)
	-rm -fr linux/deploy
	-$(MAKE) -C syslink clean
