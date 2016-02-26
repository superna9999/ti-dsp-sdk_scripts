# DSP Top Makefile

TOPDIR = $(PWD)

DEVICE = TI816X
SDK = NONE
EXEC_DIR = $(TOPDIR)/install
DEPOT = $(TOPDIR)
LINUXKERNEL = $(DEPOT)/linux/KERNEL
CGT_ARM_INSTALL_DIR = $(DEPOT)/toolchain
IPC_INSTALL_DIR = $(DEPOT)/ipc
BIOS_INSTALL_DIR = $(DEPOT)/sysbios
XDC_INSTALL_DIR = $(DEPOT)/xdctools
CGT_C674_ELF_INSTALL_DIR = $(DEPOT)/xdctools
CGT_M3_ELF_INSTALL_DIR = $(DEPOT)/toolchain

all: $(LINUXKERNEL)/include/config/kernel.release
	$(MAKE) -C syslink DEVICE=$(DEVICE) \
			   SDK=$(SDK) \
			   EXEC_DIR=$(EXEC_DIR) \
			   DEPOT=$(DEPOT) \
			   LINUXKERNEL=$(LINUXKERNEL) \
			   CGT_ARM_INSTALL_DIR=$(CGT_ARM_INSTALL_DIR) \
			   IPC_INSTALL_DIR=$(IPC_INSTALL_DIR) \
			   BIOS_INSTALL_DIR=$(BIOS_INSTALL_DIR) \
			   XDC_INSTALL_DIR=$(XDC_INSTALL_DIR) \
			   CGT_C674_ELF_INSTALL_DIR=$(CGT_C674_ELF_INSTALL_DIR) \
			   CGT_M3_ELF_INSTALL_DIR=$(CGT_M3_ELF_INSTALL_DIR)

$(LINUXKERNEL)/include/config/kernel.release:
	cd $(DEPOT)/linux/ && ./build_kernel.sh

clean:
	$(MAKE) -C syslink clean
