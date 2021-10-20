# Inherit for devices that support 64-bit primary and 32-bit secondary zygote startup script
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Set target and base project for flavor build
MTK_TARGET_PROJECT := $(subst full_,,$(TARGET_PRODUCT))
MTK_BASE_PROJECT := $(MTK_TARGET_PROJECT)
MTK_PROJECT_FOLDER := $(LOCAL_PATH)
MTK_TARGET_PROJECT_FOLDER := $(LOCAL_PATH)

# This is where we'd set a backup provider if we had one
#$(call inherit-product, device/sample/products/backup_overlay.mk)
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# set locales & aapt config.
include $(LOCAL_PATH)/ProjectConfig.mk

# Set locales
PRODUCT_LOCALES := en_US zh_CN zh_TW es_ES pt_BR ru_RU fr_FR de_DE tr_TR vi_VN ms_MY in_ID th_TH it_IT ar_EG hi_IN bn_IN ur_PK fa_IR pt_PT nl_NL el_GR hu_HU tl_PH ro_RO cs_CZ ko_KR km_KH iw_IL my_MM pl_PL es_US bg_BG hr_HR lv_LV lt_LT sk_SK uk_UA de_AT da_DK fi_FI nb_NO sv_SE en_GB hy_AM zh_HK et_EE ja_JP kk_KZ sr_RS sl_SI ca_ES

# Vanzo:songlixin on: Sat, 31 Jan 2015 16:41:22 +0800
# for locales and aapt customization
ifneq ($(strip $(VANZO_PRODUCT_LOCALES)),)
  PRODUCT_LOCALES := $(VANZO_PRODUCT_LOCALES)
endif
# End of Vanzo:songlixin

# Set those variables here to overwrite the inherited values.
PRODUCT_MANUFACTURER := SONY
PRODUCT_NAME := full_pine
PRODUCT_DEVICE := pine
PRODUCT_MODEL := pine
PRODUCT_POLICY := android.policy_phone
PRODUCT_BRAND := SONY

KERNEL_DEFCONFIG ?= k37tv1_64_bsp_defconfig
PRELOADER_TARGET_PRODUCT ?= pine
LK_PROJECT ?= pine
TRUSTY_PROJECT ?= pine
