# mt6735 platform boardconfig
DEVICE_PATH := device/sony/pine

# Use the non-open-source part, if present
-include vendor/mediatek/mt6735/BoardConfigVendor.mk

# Use the common part
include device/mediatek/common/BoardConfig.mk

# Use the project config
include $(DEVICE_PATH)/ProjectConfig.mk

# Platform
TARGET_BOARD_PLATFORM := mt6735

# Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_CPU_SMP := true
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

# Audio
BOARD_USES_MTK_AUDIO := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# CDEFS
MTK_INTERNAL_CDEFS := $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)))
MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),$(foreach v,$(shell echo $($(t)) | tr '[a-z]' '[A-Z]'),-D$(v))))
MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)=\"$($(t))\"))

# Config.fs
TARGET_FS_CONFIG_GEN += $(DEVICE_PATH)/config.fs

# Connectivity
BOARD_CONNECTIVITY_VENDOR := MediaTek
ifeq ($(strip $(BOARD_CONNECTIVITY_VENDOR)), MediaTek)
BOARD_MEDIATEK_USES_GPS := true
endif

# Display
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := false
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false
ifneq ($(MTK_BASIC_PACKAGE), yes)
VSYNC_EVENT_PHASE_OFFSET_NS := -8000000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := -8000000
endif
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
ifneq ($(FPGA_EARLY_PORTING), yes)
MTK_HWC_SUPPORT := yes
else
MTK_HWC_SUPPORT := no
endif
TARGET_USES_HWC2 := true
MTK_HWC_VERSION := 2.0.0
MTK_GPU_VERSION := mali midgard r18p0
OVERRIDE_RS_DRIVER := libRSDriver_mtk.so

# Flags
MTK_GLOBAL_CFLAGS += $(MTK_INTERNAL_CDEFS)

# Kernel
BOARD_KERNEL_BASE = 0x40078000
BOARD_KERNEL_OFFSET = 0x00008000
BOARD_RAMDISK_OFFSET = 0x03f88000
BOARD_TAGS_OFFSET = 0x0df88000
TARGET_USES_64_BIT_BINDER := true
TARGET_IS_64_BIT := true
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
TARGET_TOOLCHAIN_ROOT := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9
TARGET_TOOLS_PREFIX := $(TARGET_TOOLCHAIN_ROOT)/bin/aarch64-linux-android-
TARGET_KERNEL_TOOLCHAIN_PREFIX := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-gnu-6.3.1/bin/aarch64-linux-gnu-
KERNEL_CROSS_COMPILE:= $(abspath $(TOP))/$(TARGET_KERNEL_TOOLCHAIN_PREFIX)
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

# PTGEN
MTK_PTGEN_CHIP ?= $(shell echo $(TARGET_BOARD_PLATFORM) | tr '[a-z]' '[A-Z]')
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
include device/mediatek/build/build/tools/ptgen/$(MTK_PTGEN_CHIP)/ptgen.mk
endif

# Partitions
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_NO_FACTORYIMAGE := true
-include $(MTK_PTGEN_OUT)/partition_size.mk
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 4096
TARGET_COPY_OUT_VENDOR := system/vendor
TARGET_RECOVERY_FSTAB := $(MTK_PTGEN_PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(MTK_PLATFORM_DIR)

#SELinux Policy File Configuration
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy/basic
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy/basic \
        $(DEVICE_PATH)/sepolicy/bsp
endif
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy/basic \
        $(DEVICE_PATH)/sepolicy/bsp \
        $(DEVICE_PATH)/sepolicy/full
endif
endif

# TLS
ARCH_ARM_HAVE_TLS_REGISTER := true
