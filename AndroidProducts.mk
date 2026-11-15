#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_ossi.mk

# OrangeFox 14.1 基于 AOSP 14，lunch 必须是三段式
# <product>-<release>-<variant>
COMMON_LUNCH_CHOICES := \
    twrp_ossi-ap2a-eng \
    twrp_ossi-ap2a-userdebug \
    twrp_ossi-ap2a-user
