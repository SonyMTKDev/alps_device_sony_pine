DEVICE_PATH := device/sony/pine

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    device/mediatek/common/overlay/sd_in_ex_otg \
    device/mediatek/common/overlay/navbar \
    $(DEVICE_PATH)/overlay

# OPTR Overlays
ifdef OPTR_SPEC_SEG_DEF
  ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    DEVICE_PACKAGE_OVERLAYS += device/mediatek/common/overlay/operator/$(OPTR)/$(SPEC)/$(SEG)
  endif
endif

# Custom Overlays
ifneq (yes,$(strip $(MTK_TABLET_PLATFORM)))
  ifeq (480,$(strip $(LCM_WIDTH)))
    ifeq (854,$(strip $(LCM_HEIGHT)))
      DEVICE_PACKAGE_OVERLAYS += device/mediatek/common/overlay/FWVGA
    endif
  endif
  ifeq (540,$(strip $(LCM_WIDTH)))
    ifeq (960,$(strip $(LCM_HEIGHT)))
      DEVICE_PACKAGE_OVERLAYS += device/mediatek/common/overlay/qHD
    endif
  endif
endif

# Optimize Overlays
ifeq (yes,$(strip $(MTK_GMO_ROM_OPTIMIZE)))
  DEVICE_PACKAGE_OVERLAYS += device/mediatek/common/overlay/slim_rom
endif
ifeq (yes,$(strip $(MTK_GMO_RAM_OPTIMIZE)))
  DEVICE_PACKAGE_OVERLAYS += device/mediatek/common/overlay/slim_ram
endif

# Do not copy rc files before this line !!
# RC files should goto /vendor since O-MR1
MTK_RC_TO_VENDOR = yes
ifeq ($(strip $(MTK_RC_TO_VENDOR)), yes)
MTK_TARGET_VENDOR_RC = $(TARGET_COPY_OUT_VENDOR)/etc/init/hw

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.mtkrc.path=/vendor/etc/init/hw/
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/ueventd.mt6735.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc
else
MTK_TARGET_VENDOR_RC = root
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.mtkrc.path=/
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/ueventd.mt6735.rc:root/ueventd.mt6735.rc
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    $(DEVICE_PATH)/permissions/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    $(DEVICE_PATH)/permissions/android.hardware.microphone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.microphone.xml \
    $(DEVICE_PATH)/permissions/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml

ifeq ($(strip $(CUSTOM_KERNEL_TOUCHPANEL)),generic)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml
else
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml
endif

ifeq ($(MTK_GPS_SUPPORT),yes)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml
endif

# IR
ifeq ($(strip $(MTK_IRTX_SUPPORT)),yes)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

PRODUCT_PACKAGES += \
    consumerir.mt6735 \
    consumerir.mt6737t \
    consumerir.mt6735m \
    consumerir.mt6737m \
    consumerir.mt6753
else
ifeq ($(strip $(MTK_IRTX_PWM_SUPPORT)),yes)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

PRODUCT_PACKAGES += \
    consumerir.mt6735 \
    consumerir.mt6737t \
    consumerir.mt6735m \
    consumerir.mt6737m \
    consumerir.mt6753
else
ifeq ($(strip $(MTK_IR_LEARNING_SUPPORT)),yes)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

PRODUCT_PACKAGES += \
    consumerir.mt6735 \
    consumerir.mt6737t \
    consumerir.mt6735m \
    consumerir.mt6737m \
    consumerir.mt6753
endif
endif
endif

# Main packages
PRODUCT_PACKAGES += \
    libI420colorconvert \
    libvcodec_utility \
    libvcodec_oal \
    libh264enc_sa.ca7 \
    libh264enc_sb.ca7 \
    libHEVCdec_sa.ca7.android \
    libmp4enc_sa.ca7 \
    libmp4enc_xa.ca7 \
    libvc1dec_sa.ca7 \
    libvp8dec_sa.ca7 \
    libvp8enc_sa.ca7 \
    libvp9dec_sa.ca7 \
    libuvtswenc_sa.ca7.android \
    libvideoeditorplayer \
    libvideoeditor_osal \
    libvideoeditor_3gpwriter \
    libvideoeditor_mcs \
    libvideoeditor_core \
    libvideoeditor_stagefrightshells \
    libvideoeditor_videofilters \
    libvideoeditor_jni \
    audio.primary.default \
    audio.primary.mt6735 \
    audio.primary.mt6737t \
    audio.primary.mt6735m \
    audio.primary.mt6737m \
    audio.primary.mt6753 \
    audio_policy.stub \
    local_time.default \
    libaudiocustparam \
    libaudiocomponentengine \
    libaudiocomponentengine_vendor \
    libh264dec_xa.ca9 \
    libh264dec_xb.ca9 \
    libh264dec_customize \
    libmp4dec_sa.ca9 \
    libmp4dec_sb.ca9 \
    libmp4dec_customize \
    libvp8dec_xa.ca9 \
    libmp4enc_xa.ca9 \
    libmp4enc_xb.ca9 \
    libh264enc_sa.ca9 \
    libh264enc_sb.ca9 \
    libvcodec_oal \
    libvc1dec_sa.ca9 \
    liblic_divx \
    liblic_s263 \
    init.factory.rc \
    libaudio.primary.default \
    audio.a2dp.default \
    audio_policy.default \
    audio_policy.mt6735 \
    libaudio.a2dp.default \
    libMtkVideoTranscoder \
    libMtkOmxCore \
    libMtkOmxOsalUtils \
    libMtkOmxVdecEx \
    libMtkOmxVenc \
    libaudiodcrflt \
    libaudiosetting \
    librtp_jni \
    mfv_ut \
    libstagefrighthw \
    libstagefright_memutil \
    factory.ini \
    libmtdutil \
    libminiui \
    factory \
    drvbd \
    libaudio.usb.default \
    audio.usb.default \
    audio.usb.mt6735 \
    audio.usb.mt6737t \
    audio.usb.mt6735m \
    audio.usb.mt6737m \
    audio.usb.mt6753 \
    AccountAndSyncSettings \
    DeskClock \
    AlarmProvider \
    Bluetooth \
    Calculator \
    Calendar \
    CertInstaller \
    DrmProvider \
    Email \
    FusedLocation \
    TelephonyProvider \
    Exchange2 \
    LatinIME \
    Music \
    MusicFX \
    Protips \
    QuickSearchBox \
    Settings \
    Sync \
    SystemUI \
    Updater \
    CalendarProvider \
    ccci_mdinit \
    ccci_fsd \
    ccci_rpcd \
    batterywarning \
    SyncProvider \
    disableapplist.txt \
    resmonwhitelist.txt \
    MTKThermalManager \
    libmtcloader \
    thermal_manager \
    thermald \
    thermal \
    thermal.mt6735 \
    thermal.mt6737t \
    thermal.mt6735m \
    thermal.mt6737m \
    thermal.mt6753 \
    CellConnService \
    calib.dat \
    param.dat \
    sensors.dat \
    sensors.mt6735 \
    sensors.mt6737t \
    sensors.mt6735m \
    sensors.mt6737m \
    sensors.mt6753 \
    libhwm \
    lights.mt6735 \
    lights.mt6737t \
    lights.mt6735m \
    lights.mt6737m \
    lights.mt6753 \
    meta_tst \
    dhcp6c \
    dhcp6ctl \
    dhcp6c.conf \
    dhcp6cDNS.conf \
    dhcp6s \
    dhcp6s.conf \
    dhcp6c.script \
    dhcp6cctlkey \
    libblisrc \
    libifaddrs \
    libmobilelog_jni \
    libaudio.r_submix.default \
    audio.r_submix.default \
    audio.r_submix.mt6735 \
    audio.r_submix.mt6737t \
    audio.r_submix.mt6735m \
    audio.r_submix.mt6737m \
    audio.r_submix.mt6753 \
    libaudio.usb.default \
    libnbaio \
    libaudioflinger \
    libmeta_audio \
    liba3m \
    libja3m \
    libmmprofile \
    libmmprofile_jni \
    libtvoutjni \
    libtvoutpattern \
    libmtkhdmi_jni \
    libmtkcam_modulefactory_custom \
    libmtkcam_modulefactory_drv \
    libmtkcam_modulefactory_aaa \
    libmtkcam_modulefactory_feature \
    libcam_platform \
    vendor.mediatek.hardware.camera.advcam@1.0-impl \
    vendor.mediatek.hardware.camera.callbackclient@1.0-impl \
    camerahalserver \
    android.hardware.camera.provider@2.4-service-mediatek \
    android.hardware.camera.provider@2.4-impl-mediatek \
    libmtkcam_device1 \
    libmtkcam_device3 \
    camera.mt6735 \
    camera.mt6737t \
    camera.mt6753 \
    camera.mt6735m \
    camera.mt6737m \
    liblog \
    shutdown \
    muxreport \
    mtkrild \
    mtk-ril \
    librilmtk \
    libutilrilmtk \
    gsm0710muxd \
    md_minilog_util \
    wbxml \
    wappush \
    thememap.xml \
    libBLPP.so \
    rc.fac \
    mtkGD \
    pvrsrvctl \
    libEGL_mtk.so \
    libGLESv1_CM_mtk.so \
    libGLESv2_mtk.so \
    ged_srv \
    thermalindicator \
    libged.so \
    gralloc.mt6735.so \
    libusc.so \
    libglslcompiler.so \
    libIMGegl.so \
    libpvr2d.so \
    libsrv_um.so \
    libsrv_init.so \
    libPVRScopeServices.so \
    libpvrANDROID_WSEGL.so \
    libFraunhoferAAC \
    audiocmdservice_atci \
    libMtkOmxAudioEncBase \
    libMtkOmxAmrEnc \
    libMtkOmxAwbEnc \
    libMtkOmxAacEnc \
    libMtkOmxVorbisEnc \
    libMtkOmxAdpcmEnc \
    libMtkOmxMp3Dec \
    libMtkOmxGsmDec \
    libMtkOmxAacDec \
    libMtkOmxG711Dec \
    libMtkOmxVorbisDec \
    libMtkOmxAudioDecBase \
    libMtkOmxAdpcmDec \
    libMtkOmxRawDec \
    libMtkOmxAMRNBDec \
    libMtkOmxAMRWBDec \
    libvoicerecognition_jni \
    libvoicerecognition \
    libphonemotiondetector_jni \
    libphonemotiondetector \
    libmotionrecognition \
    libasf \
    libasfextractor \
    audio.primary.default \
    audio_policy.stub \
    audio_policy.default \
    libaudio.primary.default \
    libaudio.a2dp.default \
    audio.a2dp.default \
    libaudio-resampler \
    local_time.default \
    libaudiocustparam \
    libaudiodcrflt \
    libaudiosetting \
    librtp_jni \
    libmatv_cust \
    libmtkplayer \
    libatvctrlservice \
    matv \
    libMtkOmxApeDec \
    libMtkOmxFlacDec \
    ppp_dt \
    power.mt6735 \
    power.mt6737t \
    power.mt6735m \
    power.mt6737m \
    power.mt6753 \
    vendor.mediatek.hardware.power@1.1-impl \
    libdiagnose \
    libsonivox \
    iAmCdRom.iso \
    libmemorydumper \
    memorydumper \
    libvt_custom \
    libamrvt \
    libvtmal \
    libipsec_ims \
    racoon \
    libipsec \
    libpcap \
    mtpd \
    netcfg \
    pppd \
    pppd_via \
    pppd_dt \
    dhcpcd \
    dhcpcd.conf \
    dhcpcd-run-hooks \
    20-dns.conf \
    95-configured \
    radvd \
    radvd.conf \
    dnsmasq \
    netd \
    ndc \
    libiprouteutil \
    libnetlink \
    tc \
    e2fsck \
    libext2_blkid \
    libext2_e2p \
    libext2_com_err \
    libext2fs \
    libext2_uuid \
    mke2fs \
    tune2fs \
    badblocks \
    resize2fs \
    resize.f2fs \
    libnvram \
    libnvram_daemon_callback \
    libfile_op \
    nvram_daemon \
    vendor.mediatek.hardware.nvram@1.0 \
    vendor.mediatek.hardware.nvram@1.0-impl \
    make_ext4fs \
    sdcard \
    libext \
    libext4 \
    libext6 \
    libxtables \
    libip4tc \
    libip6tc \
    ipod \
    libipod \
    fuelgauged \
    libfgauge \
    gatord \
    boot_logo_updater \
    boot_logo \
    bootanimation \
    libtvoutjni \
    libtvoutpattern \
    libmtkhdmi_jni \
    libhissage.so \
    libhpe.so \
    sdiotool \
    superumount \
    libsched \
    fsck_msdos_mtk \
    cmmbsp \
    libcmmb_jni \
    robotium \
    libc_malloc_debug_mtk \
    dpfd \
    libaal \
    libaalservice \
    aal \
    libaal_cust \
    SchedulePowerOnOff \
    BatteryWarning \
    libpq_cust \
    libpq_cust_mtk \
    libPQjni \
    libPQDCjni \
    MiraVision \
    libMiraVision_jni \
    hald \
    dmlog \
    mtk_msr.ko \
    met.ko \
    gator.ko \
    send_bug \
    met-cmd \
    libmet-tag \
    met_log_d \
    trace-cmd \
    libMtkOmxRawDec \
    libperfservice \
    libperfservicenative \
    libpowerhalwrap \
    libperfctl \
    libperfctl_vendor \
    power_native_test \
    power_whitelist_cfg.xml \
    powerscntbl.cfg \
    powerboosttbl.cfg \
    powercontable.cfg \
    Videos \
    sn \
    lcdc_screen_cap \
    libJniAtvService \
    GoogleKoreanIME \
    memtrack.mt6735 \
    memtrack.mt6737t \
    memtrack.mt6735m \
    memtrack.mt6737m \
    memtrack.mt6753 \
    android.hardware.memtrack@1.0-impl \
    libjni_koreanime.so \
    atcid \
    wpa_supplicant \
    wpa_cli \
    wpa_supplicant.conf \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf \
    hostapd \
    hostapd_cli \
    lib_driver_cmd_mt66xx.a \
    Dialer \
    CallLogBackup \
    libacdk \
    hwcomposer.mt6735 \
    hwcomposer.mt6737t \
    hwcomposer.mt6735m \
    hwcomposer.mt6737m \
    hwcomposer.mt6753 \
    md_ctrl \
    storagemanagerd \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    libGLES_android \
    fstab.mt6735 \
    Gallery2 \
    Gallery2Root \
    Gallery2Drm \
    Gallery2Gif \
    Gallery2Pq \
    Gallery2PqTool \
    Gallery2Raw \
    Gallery2SlowMotion \
    Gallery2StereoEntry \
    Gallery2StereoCopyPaste \
    Gallery2StereoBackground \
    Gallery2StereoFancyColor \
    Gallery2StereoRefocus \
    Gallery2PhotoPicker \
    Camera \
    Panorama \
    NativePip \
    SlowMotion \
    CameraRoot \
    wifi2agps \
    libsec \
    sbchk \
    com.android.future.usb.accessory \
    libsysenv \
    sysenv_daemon \
    android.hardware.bluetooth@1.0-impl-mediatek \
    android.hardware.bluetooth@1.0-service-mediatek \
    vintf \
    android.hardware.audio@2.0-impl-mediatek \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@2.0-service-mediatek \
    fs_config_files \
    android.hardware.vibrator@1.0-impl \
    android.hardware.light@2.0-impl-mediatek \
    android.hardware.sensors@1.0-impl-mediatek \
    android.hardware.sensors@1.0-service-mediatek \
    vendor.mediatek.hardware.pq@2.0-service \
    vendor.mediatek.hardware.pq@2.0-impl \
    android.hardware.thermal@1.0-impl \
    vendor.mediatek.hardware.mtkcodecservice@1.1-impl \
    android.hardware.oemlock@1.0-service \
    android.hardware.oemlock@1.0-impl \
    libmtkavenhancements

$(foreach custom_hal_msensorlib,$(CUSTOM_HAL_MSENSORLIB),$(eval PRODUCT_PACKAGES += lib$(custom_hal_msensorlib)))

# Specific packages and props
ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
PRODUCT_PACKAGES += \
    MTKAndroidSuiteDaemon
endif

ifeq ($(MTK_SYSTEM_UPDATE_SUPPORT), yes)
PRODUCT_PACKAGES += \
    GoogleOtaBinder \
    SystemUpdate \
    SystemUpdateAssistant
endif

ifneq ($(MTK_BASIC_PACKAGE), yes)
PRODUCT_PACKAGES += \
    libgas.so \
    guiext-server
endif

ifneq ($(strip $(MTK_HIDL_PROCESS_CONSOLIDATION_ENABLED)), yes)
PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.power@1.1-service \
    nvram_agent_binder \
    android.hardware.memtrack@1.0-service \
    android.hardware.graphics.allocator@2.0-service \
    merged_hal_service \
    android.hardware.vibrator@1.0-service \
    android.hardware.light@2.0-service-mediatek \
    android.hardware.thermal@1.0-service \
    vendor.mediatek.hardware.mtkcodecservice@1.1-service
endif

ifneq (,$(filter yes, $(MTK_KERNEL_POWER_OFF_CHARGING)))
PRODUCT_PACKAGES += \
    kpoc_charger
endif

ifndef MTK_TB_WIFI_3G_MODE
  PRODUCT_PACKAGES += Mms
else
  ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
    PRODUCT_PACKAGES += Mms
  endif
endif
ifneq ($(TARGET_BUILD_VARIANT),user)
    PRODUCT_PACKAGES += atci_service
    PRODUCT_PACKAGES += libatciserv_jni
    PRODUCT_PACKAGES += AtciService
else
    ifneq ($(wildcard vendor/mediatek/internal/em_enable),)
        PRODUCT_PACKAGES += atci_service
        PRODUCT_PACKAGES += libatciserv_jni
        PRODUCT_PACKAGES += AtciService
    else
        ifeq ($(strip $(MTK_CUSTOM_USERLOAD_ENGINEERMODE)), yes)
            PRODUCT_PACKAGES += atci_service
            PRODUCT_PACKAGES += libatciserv_jni
            PRODUCT_PACKAGES += AtciService
        endif
    endif
endif

ifeq ($(strip $(MTK_CCCI_PERMISSION_CHECK_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    permission_check

PRODUCT_PROPERTY_OVERRIDES += \
    persist.md.perm.checked=to_upgrade
endif

ifeq ($(strip $(BUILD_MTK_LDVT)),yes)
PRODUCT_PACKAGES += \
    ts_uvvf \
    ts_md32
endif

ifeq ($(strip $(MTK_TC1_FEATURE)),yes)
PRODUCT_PACKAGES += \
    libtc1part \
    libtc1rft
endif

ifeq ($(strip $(MTK_APP_GUIDE)),yes)
PRODUCT_PACKAGES += \
    ApplicationGuide
endif

ifeq ($(strip $(MTK_FLV_PLAYBACK_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    libflv \
    libflvextractor
endif

ifneq ($(strip $(foreach value,$(DFO_NVRAM_SET),$(filter yes,$($(value))))),)
PRODUCT_PACKAGES += \
    featured \
    libdfo \
    libdfo_jni
endif

ifdef OPTR_SPEC_SEG_DEF
    ifeq ($(OPTR_SPEC_SEG_DEF),NONE)
        ifeq ($(strip $(MTK_CMAS_SUPPORT)), yes)
            PRODUCT_PACKAGES += CMASReceiver
            PRODUCT_PACKAGES += CmasEM
        endif
    endif
else
    ifeq ($(strip $(MTK_CMAS_SUPPORT)), yes)
        PRODUCT_PACKAGES += CMASReceiver
        PRODUCT_PACKAGES += CmasEM
    endif
endif

ifeq ($(strip $(MTK_CDS_EM_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    CDS_INFO
endif

ifeq ($(strip $(MTK_NFC_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    nfcservice \
    nfcstackp \
    DeviceTestApp \
    libdta_mt6605_jni \
    libmtknfc_dynamic_load_jni \
    libnfc_mt6605_jni

$(call inherit-product-if-exists, vendor/mediatek/proprietary/packages/apps/DeviceTestApp/DeviceTestApp.mk)
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/mtknfc/mtknfc.mk)
endif

ifeq ($(strip $(MTK_SPECIFIC_SM_CAUSE)), yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.specific.sm_cause=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ril.specific.sm_cause=0
endif

ifeq ($(strip $(MTK_GLOBAL_PQ_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.globalpq.support=1
endif

ifeq ($(strip $(MTK_EMULATOR_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    SDKGallery \
    Provision
endif

ifeq ($(strip $(HAVE_CMMB_FEATURE)), yes)
PRODUCT_PACKAGES += \
    CMMBPlayer
endif

ifeq ($(strip $(MTK_DATA_TRANSFER_APP)), yes)
PRODUCT_PACKAGES += \
    DataTransfer
endif

ifeq ($(strip $(MTK_MDM_APP)),yes)
PRODUCT_PACKAGES += \
    MediatekDM
endif

ifeq ($(strip $(MTK_VT3G324M_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    libmtk_vt_client \
    libmtk_vt_em \
    libmtk_vt_utils \
    libmtk_vt_service \
    libmtk_vt_swip \
    vtservice
endif

ifeq ($(strip $(MTK_OOBE_APP)),yes)
PRODUCT_PACKAGES += \
    OOBE
endif

ifdef MTK_WEATHER_PROVIDER_APP
  ifneq ($(strip $(MTK_WEATHER_PROVIDER_APP)), no)
    PRODUCT_PACKAGES += MtkWeatherProvider
  endif
endif

ifeq ($(strip $(MTK_ENABLE_VIDEO_EDITOR)),yes)
PRODUCT_PACKAGES += \
    VideoEditor
endif

ifeq ($(strip $(MTK_CALENDAR_IMPORTER_APP)), yes)
PRODUCT_PACKAGES += \
    CalendarImporter
endif

ifeq ($(strip $(MTK_LOG2SERVER_APP)), yes)
PRODUCT_PACKAGES += \
    Log2Server \
    Excftpcommonlib \
    Excactivationlib \
    Excadditionnallib \
    Excmaillib
endif

ifeq ($(strip $(MTK_CAMERA_APP)), yes)
PRODUCT_PACKAGES += \
    CameraOpen
endif

ifeq ($(strip $(MTK_VIDEO_FAVORITES_WIDGET_APP)), yes)
  ifneq ($(strip $(MTK_TABLET_PLATFORM)), yes)
    PRODUCT_PACKAGES += VideoFavorites
    PRODUCT_PACKAGES += libjtranscode
  endif
endif

ifeq ($(strip $(MTK_VIDEOWIDGET_APP)),yes)
PRODUCT_PACKAGES += \
    MtkVideoWidget
endif

ifeq ($(strip $(MTK_A1_FEATURE)),yes)
  PRODUCT_PACKAGES += Stk
else
  ifeq ($(strip $(MTK_BSP_PACKAGE)),yes)
    PRODUCT_PACKAGES += Stk1
  else
    ifeq ($(strip $(MTK_BASIC_PACKAGE)),yes)
      PRODUCT_PACKAGES += Stk
    else
      PRODUCT_PACKAGES += Stk1
    endif
  endif
endif

ifeq ($(strip $(MTK_ENGINEERMODE_APP)), yes)
PRODUCT_PACKAGES += \
    EngineerMode \
    EngineerModeSim \
    libem_bt_jni \
    libem_platform32_dummy \
    libem_support_jni \
    libem_gpio_jni \
    libem_modem_jni \
    libem_usb_jni \
    libem_wifi_jni \
    libem_sensor_jni \
    libem_lte_jni \
    libem_audio_jni
  ifeq ($(strip $(MTK_NFC_SUPPORT)), yes)
    PRODUCT_PACKAGES += libem_nfc_jni
  endif
  ifneq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
        ifneq ($(wildcard vendor/mediatek/internal/em_enable),)
            PRODUCT_PACKAGES += em_svr
        else
            ifeq  ($(strip $(MTK_CUSTOM_USERLOAD_ENGINEERMODE)), yes)
              PRODUCT_PACKAGES += em_svr
            endif
        endif
  endif
endif

ifeq ($(strip $(MTK_RCSE_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    Rcse \
    Provisioning
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    YGPS \
    BGW

PRODUCT_PROPERTY_OVERRIDES += \
    bgw.current3gband=0
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT6620)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=1
  endif
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT6628)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=1
  endif
  ifeq ($(strip $(MTK_GPS_CHIP)), MTK_GPS_MT3332)
    PRODUCT_PROPERTY_OVERRIDES += gps.solution.combo.chip=0
  endif
endif

ifeq ($(strip $(MTK_NAND_UBIFS_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    mkfs_ubifs \
    ubinize \
    mtdinfo \
    ubiupdatevol \
    ubirmvol \
    ubimkvol \
    ubidetach \
    ubiattach \
    ubinfo \
    ubiformat
endif

ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)),2)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.external.md=2
else
  ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)),1)
    PRODUCT_PROPERTY_OVERRIDES += ril.external.md=1
  else
    PRODUCT_PROPERTY_OVERRIDES += ril.external.md=0
  endif
endif

ifeq ($(strip $(MTK_LIVEWALLPAPER_APP)), yes)
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    VisualizationWallpapers \
    Galaxy4 \
    HoloSpiralWallpaper \
    NoiseField \
    PhaseBeam
endif

ifeq ($(strip $(MTK_SNS_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    SNSCommon \
    SnsContentProvider \
    SnsWidget \
    SnsWidget24 \
    SocialStream
  ifeq ($(strip $(MTK_SNS_KAIXIN_APP)), yes)
    PRODUCT_PACKAGES += KaiXinAccountService
  endif
  ifeq ($(strip $(MTK_SNS_RENREN_APP)), yes)
    PRODUCT_PACKAGES += RenRenAccountService
  endif
  ifeq ($(strip $(MTK_SNS_FACEBOOK_APP)), yes)
    PRODUCT_PACKAGES += FacebookAccountService
  endif
  ifeq ($(strip $(MTK_SNS_FLICKR_APP)), yes)
    PRODUCT_PACKAGES += FlickrAccountService
  endif
  ifeq ($(strip $(MTK_SNS_TWITTER_APP)), yes)
    PRODUCT_PACKAGES += TwitterAccountService
  endif
  ifeq ($(strip $(MTK_SNS_SINAWEIBO_APP)), yes)
    PRODUCT_PACKAGES += WeiboAccountService
  endif
endif

ifeq ($(strip $(MTK_DATADIALOG_APP)), yes)
PRODUCT_PACKAGES += \
    DataDialog
endif

ifeq ($(strip $(MTK_DATA_TRANSFER_APP)), yes)
PRODUCT_PACKAGES += \
    DataTransfer
endif

ifneq ($(strip $(MTK_A1_FEATURE)),yes)
PRODUCT_PACKAGES += \
    FMRadio
endif

ifeq (MT6620_FM,$(strip $(MTK_FM_CHIP)))
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.driver.chip=1
endif

ifeq (MT6626_FM,$(strip $(MTK_FM_CHIP)))
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.driver.chip=2
endif

ifeq (MT6628_FM,$(strip $(MTK_FM_CHIP)))
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.driver.chip=3
endif

RAT_CONFIG = $(strip $(MTK_PROTOCOL1_RAT_CONFIG))
ifneq (, $(RAT_CONFIG))
  ifneq (,$(findstring C,$(RAT_CONFIG)))
    #C2K is supported
    RAT_CONFIG_C2K_SUPPORT=yes
  endif
endif

ifeq ($(strip $(MTK_CAM_LOMO_SUPPORT)), yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.mtk_cam_lomo_support=1

PRODUCT_PACKAGES += \
    libjni_lomoeffect
endif

ifeq ($(strip $(MTK_DT_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    ip-up \
    ip-down \
    ppp_options \
    chap-secrets \
    init.gprs-pppd
  ifneq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
    ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
      PRODUCT_PACKAGES += ExtModemLog
      PRODUCT_PACKAGES += libextmdlogger_ctrl_jni
      PRODUCT_PACKAGES += libextmdlogger_ctrl
      PRODUCT_PACKAGES += extmdlogger
    endif
  endif
endif

ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    cmddumper \
    Bypass \
    bypass
endif

ifeq ($(strip $(MTK_ENGINEERMODE_APP)), yes)
PRODUCT_PACKAGES += \
    EngineerMode \
    MobileLog
endif

ifeq ($(strip $(HAVE_MATV_FEATURE)),yes)
PRODUCT_PACKAGES += \
    MtvPlayer \
    MATVEM \
    com.mediatek.atv.adapter
endif

ifneq ($(strip $(MTK_LCM_PHYSICAL_ROTATION)),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.hwrotation=$(MTK_LCM_PHYSICAL_ROTATION)
endif

ifeq ($(strip $(MTK_FM_TX_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    FMTransmitter
endif

ifeq ($(strip $(MTK_SOUNDRECORDER_APP)),yes)
PRODUCT_PACKAGES += \
    SoundRecorder
endif

ifeq ($(strip $(MTK_LOCKSCREEN_TYPE)),2)
PRODUCT_PACKAGES += \
    MtkWallPaper
endif

ifneq ($(strip $(MTK_LOCKSCREEN_TYPE)),)
PRODUCT_PROPERTY_OVERRIDES +=\
    curlockscreen=$(MTK_LOCKSCREEN_TYPE)
endif

ifeq ($(strip $(MTK_OMA_DOWNLOAD_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    Browser \
    DownloadProvider
endif

ifeq ($(strip $(MTK_OMACP_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    Omacp
endif

ifeq ($(strip $(MTK_WIFI_P2P_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    WifiContactSync \
    WifiP2PWizardy \
    FileSharingServer \
    FileSharingClient \
    UPnPAV \
    WifiWsdsrv \
    bonjourExplorer
endif

ifeq ($(strip $(CUSTOM_KERNEL_TOUCHPANEL)),generic)
PRODUCT_PACKAGES += \
    Calibrator
endif

ifeq ($(strip $(MTK_FILEMANAGER_APP)), yes)
PRODUCT_PACKAGES += \
    FileManager
endif

ifeq ($(strip $(MTK_ENGINEERMODE_APP)), yes)
PRODUCT_PACKAGES += \
    ActivityNetwork
endif

ifneq ($(findstring OP03, $(strip $(OPTR_SPEC_SEG_DEF))),)
PRODUCT_PACKAGES += \
    SimCardAuthenticationService
endif

ifeq ($(strip $(MTK_NFC_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    NxpSecureElement
endif

ifeq ($(strip $(MTK_NFC_OMAAC_SUPPORT)),yes)
PRODUCT_PACKAGES += \
    SmartcardService \
    org.simalliance.openmobileapi \
    org.simalliance.openmobileapi.xml \
    libassd
endif

ifeq ($(strip $(MTK_APKINSTALLER_APP)), yes)
PRODUCT_PACKAGES += \
    APKInstaller
endif

ifeq ($(strip $(MTK_SMSREG_APP)), yes)
PRODUCT_PACKAGES += \
    SmsReg
endif

ifeq ($(MTK_BACKUPANDRESTORE_APP),yes)
PRODUCT_PACKAGES += \
    BackupAndRestore
endif

ifeq ($(strip $(MTK_BWC_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    libbwc
endif

ifeq ($(strip $(MTK_GPU_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    gralloc.mt6735 \
    gralloc.mt6737t \
    gralloc.mt6735m \
    gralloc.mt6737m \
    gralloc.mt6753 \
    libGLES_mali \
    libgpu_aux \
    libRSDriver_mtk \
    rs2spir \
    spir2cl \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.renderscript@1.0-impl

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609
endif

ifdef OPTR_SPEC_SEG_DEF
  ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    $(call inherit-product-if-exists, mediatek/operator/$(OPTR)/$(SPEC)/$(SEG)/optr_apk_config.mk)

    # Todo:
    # obsolete this section's configuration for operator project resource overlay
    # once all operator related overlay resource moved to custom folder
    PRODUCT_PACKAGE_OVERLAYS += mediatek/operator/$(OPTR)/$(SPEC)/$(SEG)/OverLayResource
    # End

    PRODUCT_PROPERTY_OVERRIDES += ro.operator.optr=$(OPTR)
    PRODUCT_PROPERTY_OVERRIDES += ro.operator.spec=$(SPEC)
    PRODUCT_PROPERTY_OVERRIDES += ro.operator.seg=$(SEG)
    PRODUCT_PROPERTY_OVERRIDES += persist.operator.optr=$(OPTR)
    PRODUCT_PROPERTY_OVERRIDES += persist.operator.spec=$(SPEC)
    PRODUCT_PROPERTY_OVERRIDES += persist.operator.seg=$(SEG)
  endif
endif

ifeq ($(strip $(GEMINI)), yes)
  ifeq ($(OPTR_SPEC_SEG_DEF),NONE)
    PRODUCT_PACKAGES += StkSelection
  endif
  ifeq (OP01,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
    PRODUCT_PACKAGES += StkSelection
  endif
  ifndef OPTR_SPEC_SEG_DEF
    PRODUCT_PACKAGES += StkSelection
  endif
endif

ifeq (yes,$(strip $(MTK_FD_SUPPORT)))
# Only support the format: n.m (n:1 or 1+ digits, m:Only 1 digit) or n (n:integer)
# Time Unit:0.1 sec
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.fd.counter=150 \
    persist.radio.fd.off.counter=50 \
    persist.radio.fd.r8.counter=150 \
    persist.radio.fd.off.r8.counter=50
endif

ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
#both L1 and L3 library
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

PRODUCT_PACKAGES += \
    com.google.widevine.software.drm.xml \
    com.google.widevine.software.drm \
    libdrmmtkutil \
    libdrmwvmplugin \
    libwvm \
    libdrmdecrypt
  ifeq ($(strip $(MTK_WVDRM_L1_SUPPORT)),yes)
    PRODUCT_PACKAGES += libWVStreamControlAPI_L1
    PRODUCT_PACKAGES += libwvdrm_L1
    PRODUCT_PACKAGES += lib_uree_mtk_crypto
  else
    PRODUCT_PACKAGES += libWVStreamControlAPI_L3
    PRODUCT_PACKAGES += libwvdrm_L3
  endif
endif

ifeq ($(strip $(MTK_WVDRM_SUPPORT)),yes)
  #Mock modular drm plugin for cts
  PRODUCT_PACKAGES += libmockdrmcryptoplugin
  #both L1 and L3 library
  PRODUCT_PACKAGES += libwvdrmengine
  ifeq ($(strip $(MTK_WVDRM_L1_SUPPORT)),yes)
    PRODUCT_PACKAGES += lib_uree_mtk_modular_drm
    PRODUCT_PACKAGES += liboemcrypto
  endif
else
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=false
endif

ifeq ($(strip $(MTK_DRM_APP)),yes)
PRODUCT_PACKAGES += \
    libdrmmtkutil
#Media framework reads this property
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true
  ifeq ($(strip $(MTK_OMADRM_SUPPORT)), yes)
    PRODUCT_PACKAGES += libdrmmtkplugin
    PRODUCT_PACKAGES += drm_chmod
    PRODUCT_PACKAGES += libdcfdecoderjni
  endif
  ifeq ($(strip $(MTK_CTA_SET)), yes)
    PRODUCT_PACKAGES += libdrmctaplugin
    PRODUCT_PACKAGES += DataProtection
  endif
endif

ifeq (yes,$(strip $(MTK_FM_SUPPORT)))
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.driver.enable=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.driver.enable=0
endif

ifeq ($(strip $(MTK_WEATHER_WIDGET_APP)), yes)
PRODUCT_PACKAGES +=  \
    MtkWeatherWidget
endif

ifeq ($(strip $(MTK_ECCCI_C2K)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    mtk.eccci.c2k=enabled
endif

ifeq ($(strip $(MTK_FIRST_MD)),1)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.first.md=1
endif

ifeq ($(strip $(MTK_FIRST_MD)),2)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.first.md=2
endif

ifeq ($(strip $(MTK_FLIGHT_MODE_POWER_OFF_MD)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.flightmode.poweroffMD=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ril.flightmode.poweroffMD=0
endif

ifeq ($(strip $(MTK_FIRST_MD)),1)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.first.md=1
endif

ifeq ($(strip $(MTK_FIRST_MD)),2)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.first.md=2
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),0)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=0
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),1)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=1
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),2)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=2
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),3)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=3
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),4)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=4
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),5)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=5
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),6)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=6
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),7)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=7
endif

ifeq ($(strip $(MTK_TELEPHONY_MODE)),8)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.telephony.mode=8
endif

ifeq ($(strip $(MTK_WFD_SINK_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    MtkFloatMenu
endif

ifeq ($(strip $(MTK_WLAN_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    mediatek.wlan.chip=$(MTK_WLAN_CHIP) \
    mediatek.wlan.module.postfix="_"$(shell echo $(strip $(MTK_WLAN_CHIP)) | tr A-Z a-z)
endif

ifeq ($(strip $(MTK_RILD_READ_IMSI)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.read.imsi=1
endif

ifeq ($(strip $(MTK_RADIOOFF_POWER_OFF_MD)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ril.radiooff.poweroffMD=1
else
PRODUCT_PROPERTY_OVERRIDES += \
    ril.radiooff.poweroffMD=0
endif

ifeq ($(strip $(MTK_FACTORY_RESET_PROTECTION_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/frp
endif

ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    keystore.mt6735 \
    keystore.mt6737t \
    keystore.mt6735m \
    keystore.mt6737m \
    keystore.mt6753
endif

ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
ifeq ($(strip $(MTK_TEE_TRUSTED_UI_SUPPORT)), yes)
PRODUCT_PACKAGES += \
    libTui \
    TuiService \
    SamplePinpad \
    libTlcPinpad
endif
endif

ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  ifneq ($(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)),V1)
    MTK_AUDIO_PARAM_DIR_LIST += $(DEVICE_PATH)/audio_param
    # Speech Parameter Tuning
    # SPH_PARAM_VERSION: 0 support single network(MD ability related)
    # SPH_PARAM_VERSION: 1.0 support multiple networks(MD ability related)
    ifeq ($(strip $(MTK_TC10_FEATURE)),yes)
      AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_VERSION=1
    else
      AUDIO_PARAM_OPTIONS_LIST += SPH_PARAM_VERSION=0
    endif
    AUDIO_PARAM_OPTIONS_LIST += FIX_WB_ENH=no
    AUDIO_PARAM_OPTIONS_LIST += MTK_IIR_ENH_SUPPORT=no
    AUDIO_PARAM_OPTIONS_LIST += MTK_IIR_MIC_SUPPORT=no
    AUDIO_PARAM_OPTIONS_LIST += MTK_FIR_IIR_ENH_SUPPORT=no
  endif
endif

ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
PRODUCT_COPY_FILES += \
    vendor/mediatek/proprietary/trustzone/microtrust/source/platform/mt6735/teei/soter.raw:$(TARGET_COPY_OUT_VENDOR)/thh/soter.raw:mtk

PRODUCT_PACKAGES += \
    keystore.mt6735 \
    keystore.mt6737t \
    keystore.mt6735m \
    keystore.mt6737m \
    keystore.mt6753 \
    gatekeeper.mt6735 \
    gatekeeper.mt6737t \
    gatekeeper.mt6735m \
    gatekeeper.mt6737m \
    gatekeeper.mt6753 \
    kmsetkey.mt6735 \
    kmsetkey.mt6737t \
    kmsetkey.mt6735m \
    kmsetkey.mt6737m \
    kmsetkey.mt6753
endif

ifeq ($(MTK_VOW_SUPPORT),yes)
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.0-impl
endif

ifneq ($(strip $(MTK_MD1_SUPPORT)),)
ifneq ($(strip $(MTK_MD1_SUPPORT)), 0)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_md1_support=$(strip $(MTK_MD1_SUPPORT))
endif
endif

ifneq ($(strip $(MTK_MD3_SUPPORT)),)
ifneq ($(strip $(MTK_MD3_SUPPORT)), 0)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_md3_support=$(strip $(MTK_MD3_SUPPORT))
endif
endif

ifeq ($(strip $(MTK_C2K_LTE_MODE)), 2)
  PRODUCT_PROPERTY_OVERRIDES +=ro.boot.opt_c2k_lte_mode=2
else
  ifeq ($(strip $(MTK_C2K_LTE_MODE)), 1)
    PRODUCT_PROPERTY_OVERRIDES +=ro.boot.opt_c2k_lte_mode=1
  else
    ifeq ($(strip $(MTK_C2K_LTE_MODE)), 0)
      PRODUCT_PROPERTY_OVERRIDES +=ro.boot.opt_c2k_lte_mode=0
    endif
  endif
endif

ifeq ($(strip $(MTK_ECCCI_C2K)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_eccci_c2k=1
endif

ifneq ($(strip $(MTK_PROTOCOL1_RAT_CONFIG)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_ps1_rat=$(strip $(MTK_PROTOCOL1_RAT_CONFIG))
ifneq ($(findstring L,$(strip $(MTK_PROTOCOL1_RAT_CONFIG))),)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_lte_support=1
endif
ifneq ($(findstring C,$(strip $(MTK_PROTOCOL1_RAT_CONFIG))),)
  PRODUCT_PROPERTY_OVERRIDES += ro.boot.opt_c2k_support=1
endif
endif

# PROPS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.mediatek.chip_ver=S01 \
    ro.mediatek.platform=MT6737T \
    ro.telephony.sim.count=2 \
    persist.radio.default.sim=0
    dalvik.vm.mtk-stack-trace-file=/data/anr/mtk_traces.txt \
    ro.audio.usb.period_us=16000 \
    ro.boot.opt_using_default=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.service.acm.enable=0 \
    ro.mount.fs=EXT4 \
    ro.oem_unlock_supported=1

# Audio
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/audio/audio_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_device.xml:mtk \
    $(DEVICE_PATH)/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf:mtk \
    frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf \
    vendor/mediatek/proprietary/custom/pine/factory/res/sound/testpattern1.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/testpattern1.wav:mtk \
    vendor/mediatek/proprietary/custom/pine/factory/res/sound/ringtone.wav:$(TARGET_COPY_OUT_VENDOR)/res/sound/ringtone.wav:mtk

# Graphics
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/egl/egl.cfg:mtk

# Keylayout
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/ACCDET.kl:system/usr/keylayout/ACCDET.kl:mtk \
    $(DEVICE_PATH)/keylayout/mtk-kpd.kl:system/usr/keylayout/mtk-kpd.kl:mtk

# LCD
PRODUCT_COPY_FILES += \
    vendor/mediatek/proprietary/custom/pine/factory/res/images/lcd_test_00.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_00.png:mtk \
    vendor/mediatek/proprietary/custom/pine/factory/res/images/lcd_test_01.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_01.png:mtk \
    vendor/mediatek/proprietary/custom/pine/factory/res/images/lcd_test_02.png:$(TARGET_COPY_OUT_VENDOR)/res/images/lcd_test_02.png:mtk

# Media
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml:mtk \
    $(DEVICE_PATH)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml:mtk \
    $(DEVICE_PATH)/media/media_codecs_mediatek_audio_basic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml:mtk \
    $(DEVICE_PATH)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml:mtk \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    vendor/mediatek/proprietary/hardware/omx/mediacodec/android.hardware.media.omx@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.media.omx@1.0-service.rc

ifneq ($(MTK_BASIC_PACKAGE), yes)
    ifeq ($(strip $(MTK_AUDIO_CODEC_SUPPORT_TABLET)), yes)
        PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/media_codecs_mediatek_audio_tablet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml:mtk
    else
        PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/media_codecs_mediatek_audio_phone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml:mtk
    endif
endif

ifeq (yes 0x20000000,$(strip $(MTK_GMO_RAM_OPTIMIZE)) $(strip $(CUSTOM_CONFIG_MAX_DRAM_SIZE)))
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/media_codecs_google_video_gmo.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/media_codecs_mediatek_video_gmo.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_video.xml
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/mtk_omx_core_gmo.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_omx_core.cfg:mtk
else
  PRODUCT_COPY_FILES += frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/media_codecs_mediatek_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_video.xml:mtk
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/media/mtk_omx_core.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_omx_core.cfg:mtk
endif

# Rootdir
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/init.mt6735.rc:$(MTK_TARGET_VENDOR_RC)/init.mt6735.rc \
    $(DEVICE_PATH)/rootdir/factory_init.rc:$(MTK_TARGET_VENDOR_RC)/factory_init.rc \
    $(DEVICE_PATH)/rootdir/init.modem.rc:$(MTK_TARGET_VENDOR_RC)/init.modem.rc \
    $(DEVICE_PATH)/rootdir/meta_init.modem.rc:$(MTK_TARGET_VENDOR_RC)/meta_init.modem.rc \
    $(DEVICE_PATH)/rootdir/meta_init.rc:$(MTK_TARGET_VENDOR_RC)/meta_init.rc \
    $(DEVICE_PATH)/rootdir/init.mt6735.usb.rc:$(MTK_TARGET_VENDOR_RC)/init.mt6735.usb.rc \
    $(DEVICE_PATH)/rootdir/factory_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.project.rc \
    $(DEVICE_PATH)/rootdir/init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.project.rc \
    $(DEVICE_PATH)/rootdir/meta_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.project.rc \
    $(DEVICE_PATH)/rootdir/init.recovery.mt6735.rc:recovery/root/init.recovery.mt6735.rc \
    $(DEVICE_PATH)/rootdir/partition_permission.sh:$(TARGET_COPY_OUT_VENDOR)/etc/partition_permission.sh:mtk \
    device/mediatek/common/fstab.enableswap:root/fstab.enableswap

ifeq ($(strip $(MTK_C2K_SUPPORT)),yes)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/init.c2k.rc:root/init.c2k.rc \
    $(DEVICE_PATH)/rootdir/meta_init.c2k.rc:root/meta_init.c2k.rc
endif

ifeq ($(strip $(RAT_CONFIG_C2K_SUPPORT)),yes)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/factory_init.c2k.usb.rc:$(MTK_TARGET_VENDOR_RC)/factory_init.usb.rc \
    $(DEVICE_PATH)/rootdir/init.c2k.rc:$(MTK_TARGET_VENDOR_RC)/init.c2k.rc \
    $(DEVICE_PATH)/rootdir/meta_init.c2k.rc:$(MTK_TARGET_VENDOR_RC)/meta_init.c2k.rc
else
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/factory_init.usb.rc:$(MTK_TARGET_VENDOR_RC)/factory_init.usb.rc
endif

ifneq ($(strip $(MTK_EMMC_SUPPORT)), yes)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.mt6735.nand:root/fstab.mt6735
endif

# Sensors
ifeq ($(strip $(MTK_SENSORS_1_0)),yes)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/init.sensor_1_0.rc:$(MTK_TARGET_VENDOR_RC)/init.sensor_1_0.rc
endif

# SmartBook
ifeq ($(MTK_SMARTBOOK_SUPPORT),yes)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/smartbook/sbk-kpd.kl:system/usr/keylayout/sbk-kpd.kl:mtk \
    $(DEVICE_PATH)/smartbook/sbk-kpd.kcm:system/usr/keychars/sbk-kpd.kcm:mtk
endif

# Thermal
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/thermal/thermal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/.tp/thermal.conf:mtk \
    $(DEVICE_PATH)/thermal/thermal.off.conf:$(TARGET_COPY_OUT_VENDOR)/etc/.tp/thermal.off.conf:mtk \
    $(DEVICE_PATH)/thermal/ht120.mtc:$(TARGET_COPY_OUT_VENDOR)/etc/.tp/.ht120.mtc:mtk \
    $(DEVICE_PATH)/thermal/throttle.sh:$(TARGET_COPY_OUT_VENDOR)/etc/throttle.sh:mtk

ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/thermal_eng.conf:$(TARGET_COPY_OUT_VENDOR)/etc/.tp/thermal.conf:mtk
endif

# Inherit common platform
$(call inherit-product, device/mediatek/common/device.mk)

# Inherit prebuilt
$(call inherit-product-if-exists, vendor/sony/pine/device-vendor.mk)

# Replace label
prevent_replace_label=k37tv1_64
$(call inherit-product-if-exists, vendor/mediatek/libs/$(prevent_replace_label)_bsp/device-vendor.mk)
