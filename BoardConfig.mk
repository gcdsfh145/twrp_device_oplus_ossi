#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oplus/ossi

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# A/B
AB_OTA_UPDATER := true
# 取自本机 ro.product.ab_ota_partitions（stock 值，未做增删）
AB_OTA_PARTITIONS += \
    abl \
    aop \
    aop_config \
    bluetooth \
    boot \
    cpucp \
    cpucp_dtb \
    devcfg \
    dsp \
    dtbo \
    engineering_cdt \
    featenabler \
    hyp \
    imagefv \
    init_boot \
    keymaster \
    modem \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock \
    odm \
    oplus_sec \
    oplusstanvbk \
    pdp \
    pdp_cdb \
    product \
    pvmfw \
    qupfw \
    recovery \
    shrm \
    soccp_dcd \
    soccp_debug \
    splash \
    spuservice \
    system \
    system_dlkm \
    system_ext \
    tz \
    uefi \
    uefisecapp \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm \
    xbl \
    xbl_config \
    xbl_ramdump

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := oryon

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a75

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sun
TARGET_NO_BOOTLOADER := true

# Display
TARGET_USES_VULKAN := true

# Kernel
# 本机 stock recovery_a.img 是 boot header v4 且 kernel_size = 0，
# 即 recovery 镜像里不带内核，所以不需要 prebuilt kernel。
BOARD_BOOTIMG_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_RAMDISK_USE_LZ4 := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# super —— 先用模板占位值，拿到本机 GPT 后请替换成真实大小（不影响 recoveryimage 构建）
BOARD_SUPER_PARTITION_SIZE := 9126805504 # TODO: 真机 super 实际大小
BOARD_SUPER_PARTITION_GROUPS := oplus_dynamic_partitions
BOARD_OPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    odm \
    my_product \
    my_company \
    my_carrier \
    my_region \
    my_bigball \
    my_heytap \
    my_stock \
    my_preload \
    my_manifest \
    my_engineering
BOARD_OPLUS_DYNAMIC_PARTITIONS_SIZE := 9122611200 # TODO: 同上

# Platform
TARGET_BOARD_PLATFORM := sun

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16.1.0

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true

# 亮度节点（sun 平台 panel0），不设则默认最暗
TW_BRIGHTNESS_PATH := /sys/class/backlight/panel0-backlight/brightness
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 1000
TW_FRAMERATE := 120

# OrangeFox 配置（builder README 要求，必须在 BoardConfig 末尾）
-include $(DEVICE_PATH)/OrangeFoxConfig.mk
