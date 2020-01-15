LOCAL_KERNEL := device/essential/mata/Image.gz-dtb

# Include Essential audio assets
$(call inherit-product-if-exists, vendor/essential/apps/assets/sounds/audio.mk)

# Sounds properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Sikkim.ogg \
    ro.config.notification_sound=Sherwood.ogg \
    ro.config.alarm_alert=Gallatin.ogg

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \
    $(LOCAL_PATH)/init.recovery.mata.rc:root/init.recovery.mata.rc

BOARD_VENDOR_KERNEL_MODULES := device/essential/mata/qca_cld3_wlan.ko

TARGET_USES_QCOM_BSP := false
DEVICE_PACKAGE_OVERLAYS += device/essential/mata/overlay

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.vndk.version=27.1.0 \

# Include vndk/vndk-sp/ll-ndk modules
PRODUCT_PACKAGES += vndk_package

TARGET_USES_AOSP_FOR_AUDIO := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := false
TARGET_DISABLE_DASH := true

ENABLE_VENDOR_IMAGE := true

ENABLE_AB := true

TARGET_KERNEL_VERSION := 4.4
# Use AOSP configuration
TARGET_USES_AOSP := true

BOARD_FRP_PARTITION_NAME :=frp

# Video codec configuration files
PRODUCT_COPY_FILES += \
    device/essential/mata/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/essential/mata/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/essential/mata/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/essential/mata/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.mata

# Exclude TOF sensor from InputManager
PRODUCT_COPY_FILES += \
    device/essential/mata/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

# Android_net
PRODUCT_PACKAGES += \
    libandroid_net \
    libandroid_net_32

# Add support for whitelisted apps
PRODUCT_COPY_FILES += device/essential/mata/whitelistedapps.xml:system/etc/whitelistedapps.xml

TARGET_USES_QTIC := false

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# Add soft home, back and multitask keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m

# Disable Data roaming by default
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.android.dataroaming=false

# whitelisted Sprint app
PRODUCT_COPY_FILES += \
    device/essential/mata/sprint_whitelist.xml:system/etc/sysconfig/sprint_whitelist.xml

# APN file
PRODUCT_COPY_FILES += \
    device/essential/mata/etc/apns-conf.xml:system/etc/apns-conf.xml

$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/essential/mata/base.mk)
$(call inherit-product, device/essential/mata/device-vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 480dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.rat_on=other \
    sys.vendor.shutdown.waittime=500

# whitelisted app
PRODUCT_COPY_FILES += \
    device/essential/mata/qti_whitelist.xml:system/etc/sysconfig/qti_whitelist.xml

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
    ro.opengles.version=196610

PRODUCT_NAME := mata
# End-user-visible name for the overall product. Appears in the Settings > About screen.
PRODUCT_DEVICE := mata
#  End-user-visible name for the end product
PRODUCT_MODEL := PH-1
# The brand (e.g., carrier) the software is customized for, if any
# This is the first part of the fingerprint
# [BRAND/TARGET_PRODUCT/DEVICE:7.1.1/NMF26V/7:user/test-keys]
PRODUCT_BRAND := essential
# Name of the manufacturer
PRODUCT_MANUFACTURER := Essential Products

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += telephony-ext
PRODUCT_PACKAGES += libqmiextservices

# system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=cherokee

# FW for BT
PRODUCT_PACKAGES += \
    crbtfw11.tlv \
    crnv11.bin \
    crbtfw20.tlv \
    crnv20.bin \
    crbtfw21.tlv \
    crnv21.bin

DEVICE_MANIFEST_FILE := device/essential/mata/manifest.xml
DEVICE_MATRIX_FILE   := device/essential/mata/compatibility_matrix.xml

# Audio, SmartAmp
PRODUCT_PACKAGES += libtfa98xx climax
PRODUCT_COPY_FILES += \
    device/essential/mata/audio/mixer_paths_tasha_mata.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_tasha.xml \
    device/essential/mata/audio/audio_platform_info_mata.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    device/essential/mata/audio/smartamp/TFA9891.ini:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/TFA9891.ini \
    device/essential/mata/audio/smartamp/TFA9891.cnt_preformat.ini:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/TFA9891.cnt_preformat.ini \
    device/essential/mata/audio/smartamp/TFA9891.cnt:$(TARGET_COPY_OUT_VENDOR)/firmware/TFA9891.cnt \
    device/essential/mata/audio/smartamp/TFA9891_N1A_11_1_31_NL3_HQ.patch:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/TFA9891_N1A_11_1_31_NL3_HQ.patch \
    device/essential/mata/audio/smartamp/TFA9891N1A_Dec2015.config:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/TFA9891N1A_Dec2015.config \
    device/essential/mata/audio/smartamp/TFA9891.speaker:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/TFA9891.speaker \
    device/essential/mata/audio/smartamp/T9891_mu.drc:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_mu.drc \
    device/essential/mata/audio/smartamp/T9891_mu.vstep:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_mu.vstep \
    device/essential/mata/audio/smartamp/T9891_rt.drc:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_rt.drc \
    device/essential/mata/audio/smartamp/T9891_rt.vstep:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_rt.vstep \
    device/essential/mata/audio/smartamp/T9891_vo.drc:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_vo.drc \
    device/essential/mata/audio/smartamp/T9891_vo.vstep:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/T9891_vo.vstep \
    device/essential/mata/audio/acdbdata/Bluetooth_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Bluetooth_cal.acdb \
    device/essential/mata/audio/acdbdata/General_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_General_cal.acdb \
    device/essential/mata/audio/acdbdata/Global_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Global_cal.acdb \
    device/essential/mata/audio/acdbdata/Handset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Handset_cal.acdb \
    device/essential/mata/audio/acdbdata/Hdmi_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Hdmi_cal.acdb \
    device/essential/mata/audio/acdbdata/Headset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Headset_cal.acdb \
    device/essential/mata/audio/acdbdata/Speaker_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_Speaker_cal.acdb \
    device/essential/mata/audio/acdbdata/workspaceFile.qwsp:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Mata/Mata_workspaceFile.qwsp \
    device/essential/mata/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml

# Audio volume control
PRODUCT_COPY_FILES += \
    device/essential/mata/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    device/essential/mata/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml

# Essential audio policy
PRODUCT_COPY_FILES += \
     device/essential/mata/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
     device/essential/mata/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml

# Audio configuration file
-include device/essential/mata/audio/msm8998.mk

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/essential/mata/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# WLAN host driver
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/essential/mata/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/essential/mata/wifi_concurrency_cfg.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wifi_concurrency_cfg.txt

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.2-service.mata \

# NFC packages
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    com.android.nfc_extras \
    android.hardware.nfc@1.1-service \

PRODUCT_PROPERTY_OVERRIDES += \
   persist.vendor.nfc.uicc_enabled=true \
   persist.vendor.radio.uicc_se_enabled=true

PRODUCT_PACKAGES += \
    SecureElement

# NXP chip (NQ2xxx)
PRODUCT_COPY_FILES += \
    device/essential/mata/nfc/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    device/essential/mata/nfc/libnfc-brcm-mata.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += libpn548ad_fw.so

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

PRODUCT_PACKAGES += libdiag_system

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/essential/mata/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += device/essential/mata/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

# dm-verity configuration
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/bootdevice/by-name/vendor
$(call inherit-product, build/target/product/verity.mk)

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

#for wlan
PRODUCT_PACKAGES += \
	wificond \
	wifilogd

#A/B related packages
PRODUCT_PACKAGES += update_engine \
		    update_engine_client \
		    update_verifier \
		    bootctrl.msm8998 \
		    android.hardware.boot@1.0-impl \
		    android.hardware.boot@1.0-service

# Enable update engine sideloading by including the static version of the
# boot_control HAL and its dependencies.
PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.msm8998 \
    libgptutils \
    libz \
    libcutils

PRODUCT_PACKAGES += \
    update_engine_sideload

# A/B OTA dexopt package
PRODUCT_PACKAGES += otapreopt_script

# A/B OTA dexopt update_engine hookup
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#inherit product from qcom
$(call inherit-product-if-exists, vendor/qcom/proprietary/prebuilt_HY11/target/product/msm8998/prebuilt.mk)

# Tell the system to enable copying odexes from other partition.
PRODUCT_PACKAGES += \
	cppreopts.sh

PRODUCT_PROPERTY_OVERRIDES += \
    ro.cp_system_other_odex=1

#Health packages
PRODUCT_PACKAGES += android.hardware.health@2.0-service.mata

PRODUCT_COPY_FILES += \
    device/essential/mata/healthd/images/animation.txt:root/res/values/charger/animation.txt

#Disable QTI KEYMASTER and GATEKEEPER HIDLs
#We cannot use those during an OTA from N => O
KMGK_USE_QTI_SERVICE := false

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service

# Kernel modules install path
# Change to dlkm when dlkm feature is fully enabled
KERNEL_MODULES_INSTALL := system

# Audio post-processing

PRODUCT_PACKAGES += libvolumelistener

#Thermal
PRODUCT_PACKAGES +=  android.hardware.thermal@1.0-service.mata

PRODUCT_COPY_FILES += \
	device/essential/mata/rootdir/etc/init.qcom.post_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.post_boot.sh \
	device/essential/mata/rootdir/etc/init.qcom.early_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.early_boot.sh \
	device/essential/mata/rootdir/etc/ueventd.vendor.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# NFC features
PRODUCT_COPY_FILES += \
    device/essential/mata/android.sofware.nfc.beam.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.sofware.nfc.beam.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml

# Touch command handling script
PRODUCT_COPY_FILES += \
   device/essential/mata/rootdir/etc/hbtp_cmd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hbtp_cmd.sh

# Essential legal page
PRODUCT_PACKAGES += \
    EssentialLegal

# Essential FactoryProvisioning app
PRODUCT_PACKAGES += \
    FactoryProvisioning

# Essential EssentialSUWOverlay
PRODUCT_PACKAGES += \
    EssentialSUWOverlay

# Essential EssentialSuwWelcome
PRODUCT_PACKAGES += \
    EssentialSuwWelcome

# Add spn-conf file
PRODUCT_COPY_FILES += \
   device/essential/mata/etc/spn-conf.xml:system/etc/spn-conf.xml

# USB-C => Jack keylayout
PRODUCT_COPY_FILES += \
    device/essential/mata/Vendor_2e17_Product_a001.kl:system/usr/keylayout/Vendor_2e17_Product_a001.kl \
    device/essential/mata/uinput-fpc.kl:system/usr/keylayout/uinput-fpc.kl

# Hidden API Whitelist
PRODUCT_COPY_FILES += \
   device/essential/mata/essential-hiddenapi-package-whitelist.xml:system/etc/sysconfig/essential-hiddenapi-package-whitelist.xml

# Carrier Apps list that are disabled until used
PRODUCT_COPY_FILES += \
   device/essential/mata/mata-disabled-until-used-preinstalled-carrier-app.xml:system/etc/sysconfig/mata-disabled-until-used-preinstalled-carrier-app.xml

# Essential Camera & Gallery
PRODUCT_PACKAGES += \
    Klik

# Essential Sidecar Service
PRODUCT_PACKAGES += \
    vendor.essential.hardware.sidecar@1.0_vendor \
    vendor.essential.hardware.sidecar-V1.0-java \
    vendor.essential.hardware.sidecar@1.0-service \
    vendor.essential.hardware.sidecar@1.0-impl \
    vendor-essential-hardware-sidecar.xml \
    Score \
    fastboot_target

# Essential whitelist resource app
PRODUCT_PACKAGES += \
    EssentialResources

# Essential Core Services
PRODUCT_PACKAGES += \
    Ecore

# Prebuilt text classifier
PRODUCT_PACKAGES += \
    textclassifier.smartselection.bundle1

# APTx codecs
$(call inherit-product-if-exists, vendor/essential/apps/aptX_codecs/aptx_codecs.mk)

# Essential priv-app permission
PRODUCT_COPY_FILES += \
   device/essential/mata/privapp-permissions-mata.xml:system/etc/permissions/privapp-permissions-mata.xml \

# This needs to be set before including GMS packages
# Cannot be set in the system.prop, the inclusion
# is happening too late
PRODUCT_SHIPPING_API_LEVEL := 25

# Custom bootanimation
PRODUCT_COPY_FILES += \
   device/essential/mata/bootanimation.zip:system/media/bootanimation.zip

$(call inherit-product-if-exists, vendor/essential/mata/fpc_fingerprints/device/device.mk)

# Silenced verbose logs
PRODUCT_PROPERTY_OVERRIDES += \
    persist.log.tag.improveTouch=INFO \
    persist.log.tag.QCNEJ=WARNING \
    persist.log.tag.ThermalEngine=WARNING

PRODUCT_PROPERTY_OVERRIDES += \
     persist.sys.logging=0 \
     persist.sys.crash_dumps=0 \
     persist.sys.pstore_dumps=0 \
     dalvik.vm.thread-trace-file=/data/anr/threads.txt


# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.mata

# Build DRM HAL
PRODUCT_PACKAGES += \
    move_widevine_data.sh \
    android.hardware.drm@1.2-service.widevine \
    android.hardware.drm@1.2-service.clearkey

# Add host packages

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload \
    delta_generator \
    shflags \
    simg2img

# Add override for vendor build.prop

# RIL info
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1 \
    persist.radio.VT_ENABLE=1 \
    persist.radio.VT_HYBRID_ENABLE=1 \
    persist.radio.data_con_rprt=true \
    persist.rcs.supported=1 \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    persist.data.mode=concurrent \
    persist.data.iwlan.enable=true \
    ro.telephony.default_network=22 \
    telephony.lteOnCdmaDevice=1

# Enable CameraHAL perfd usage
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.perfd.enable=true

# Get kernel-headers
$(call inherit-product, hardware/qcom/msm8998/msm8998.mk)

# Set the path for HAL headers
SRC_CAMERA_HAL_DIR := hardware/qcom/camera/msm8998
SRC_DISPLAY_HAL_DIR := hardware/qcom/display/msm8998
SRC_MEDIA_HAL_DIR := hardware/qcom/media/msm8998

PRODUCT_COPY_FILES += \
    device/essential/mata/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
  PRODUCT_COPY_FILES += \
      device/essential/mata/init.hardware.diag.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.mata.diag.rc
else
  PRODUCT_COPY_FILES += \
      device/essential/mata/init.hardware.diag.rc.user:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.mata.diag.rc
endif

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=enforce

# Subsystem silent restart
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.ssr.restart_level=modem,slpi,adsp

# Disable BT HAL v2 for now
PRODUCT_PROPERTY_OVERRIDES += \
    persist.bluetooth.bluetooth_audio_hal.disabled=true

# Reset default locale
PRODUCT_LOCALES :=

# MQA
PRODUCT_PACKAGES += \
    libhdaudio

# Set lmkd options
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.lmk.low=1001 \
    ro.lmk.medium=800 \
    ro.lmk.critical=0 \
    ro.lmk.critical_upgrade=false \
    ro.lmk.upgrade_pressure=100 \
    ro.lmk.downgrade_pressure=100 \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.kill_timeout_ms=100 \
    ro.lmk.use_minfree_levels=true \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.shutdown_timeout=1

# Set density
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=480
# GPIO mapping
PRODUCT_COPY_FILES += \
      device/essential/mata/gpio-keys-mata.kl:system/usr/keylayout/gpio-keys.kl

# PowerHint values
PRODUCT_COPY_FILES += \
    device/essential/mata/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
