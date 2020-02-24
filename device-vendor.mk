# This file lists all qcom products and defines the QC_PROP flag which
# is used to enable projects inside $(QC_PROP_ROOT) directory.

# Also, This file intended for use by device/product makefiles
# to pick and choose the optional proprietary modules

# Root of Qualcomm Proprietary component tree
QC_PROP_ROOT := vendor/qcom/proprietary
SDCLANG_LTO_DEFS := device/essential/mata/sdllvm-lto-defs.mk

PRODUCT_LIST := mata
PRODUCT_LIST += msm8998

ifneq ($(strip $(TARGET_VENDOR)),)
  PRODUCT_LIST += $(TARGET_PRODUCT)
endif

XML_CONF_PATH := vendor/qcom/proprietary/telephony-apps/etc
ifneq ($(wildcard $(XML_CONF_PATH)),)
  PRODUCT_COPY_FILES := $(XML_CONF_PATH)/cdma_call_conf.xml:system/etc/cdma_call_conf.xml $(PRODUCT_COPY_FILES)
endif

TARGET_BOARD_PLATFORM := msm8998

$(call inherit-product-if-exists, $(QC_PROP_ROOT)/android-perf/profiles.mk)

#Include other rules if any
$(call inherit-product-if-exists, $(QC_PROP_ROOT)/common-noship/build/generate_extra_images_prop.mk)


#prebuilt javalib
ifneq ($(wildcard $(QC_PROP_ROOT)/common/build/prebuilt_javalib.mk),)
BUILD_PREBUILT_JAVALIB := $(QC_PROP_ROOT)/common/build/prebuilt_javalib.mk
else
BUILD_PREBUILT_JAVALIB := $(BUILD_PREBUILT)
endif

# Each line here corresponds to an optional LOCAL_MODULE built by
# Android.mk(s) in the proprietary projects. Where project
# corresponds to the vars here in CAPs.

# These modules are tagged with optional as their LOCAL_MODULE_TAGS
# wouldn't be present in your on target images, unless listed here
# explicitly.

#ADSPRPC
ADSPRPC := libadsprpc
ADSPRPC += libadsp_default_listener
ADSPRPC += libssc_default_listener
ADSPRPC += adsprpcd

#BT
BT := btnvtool
BT += dun-server
BT += hci_qcomm_init
BT += liboi_sbc_decoder
BT += sapd
BT += wcnss_filter
BT += android.hardware.bluetooth@1.0-service
BT += android.hardware.bluetooth@1.0-impl
BT += android.hardware.bluetooth@1.0-service.rc

#CNE
CNE := andsfCne.xml
CNE += cnd
CNE += cneapiclient
CNE += cneapiclient.xml
CNE += CNEService
CNE += com.quicinc.cne
CNE += com.quicinc.cne.xml
CNE += com.quicinc.cneapiclient
CNE += libcne
CNE += libcneapiclient
CNE += libcneqmiutils
CNE += libcneoplookup
CNE += libmasc
CNE += libvendorconn
CNE += libwms
CNE += libwqe
CNE += libxml
CNE += ROW_profile1.xml
CNE += ROW_profile2.xml
CNE += ROW_profile3.xml
CNE += ROW_profile4.xml
CNE += ROW_profile5.xml
CNE += ROW_profile6.xml
CNE += ROW_profile7.xml
CNE += ATT_profile1.xml
CNE += ATT_profile2.xml
CNE += ATT_profile3.xml
CNE += ATT_profile4.xml
CNE += ATT_profile5.xml
CNE += ATT_profile6.xml
CNE += VZW_profile1.xml
CNE += VZW_profile2.xml
CNE += VZW_profile3.xml
CNE += VZW_profile4.xml
CNE += VZW_profile5.xml
CNE += VZW_profile6.xml
CNE += SwimConfig.xml
CNE += com.quicinc.cne.api@1.0
CNE += com.quicinc.cne.server@1.0
CNE += com.quicinc.cne.server@2.0
CNE += com.quicinc.cne.constants@1.0
CNE += com.quicinc.cne.constants@2.0
CNE += com.quicinc.cne.api-V1.0-java

# CNE rely on Latency HIDL
LATENCY := vendor.qti.hardware.data.latency@1.0
LATENCY += vendor.qti.hardware.data.latency@1.0_vendor
LATENCY += vendor.qti.hardware.data.latency-V1.0-java
LATENCY += vendor.qti.hardware.data.latency.xml

#DATA
DATA := ATFWD-daemon
DATA += dsdnsutil
DATA += dsi_config.xml
DATA += libconfigdb
DATA += libdsnet
DATA += libdsnetutil
DATA += libdsprofile
DATA += libdss
DATA += libdssock
DATA += libdsutils
DATA += libnetmgr
DATA += libqcmaputils
DATA += netmgrd
DATA += netmgr_config.xml
DATA += port-bridge
DATA += qti

#DISPLAY
DISPLAY := libsdmextension
DISPLAY += libqseed3
DISPLAY += libsdm-disp-apis
DISPLAY += libsdm-color
DISPLAY += libsdm-diag
DISPLAY += vendor.display.config@1.0_vendor

#DIAG
DIAG := diag_klog
DIAG += diag_mdlog
DIAG += diag_socket_log
DIAG += diag_qshrink4_daemon
DIAG += diag_uart_log
DIAG += libdiag_system
DIAG += libdiagjni

#hvdcp 3.0 daemon
HVDCP_OPTI := hvdcp_opti

# To create XTRA daemon (linked to libizat_core)
AOSP_GPS := xtra-daemon
AOSP_GPS += libizat_core
# Support library from vendor/qcom/opensource/location/
# Those are the implementation of the API, definied on the HAL
AOSP_GPS += libloc_api_v02
AOSP_GPS += libloc_ds_api
AOSP_GPS += liblbs_core
AOSP_GPS += libgeofence
AOSP_GPS += libflp
AOSP_GPS += libloc_pla
# loc_launcher will start the right daemons, per izat.conf
AOSP_GPS += loc_launcher
AOSP_GPS += izat.conf
# LOWI is needed for Free-WiFi Scan information
AOSP_GPS += lowi-server
AOSP_GPS += liblowi_client
AOSP_GPS += liblowi_wifihal
AOSP_GPS += liblowi_wifihal_nl
# sap.conf provide the sensor information for the GPS
AOSP_GPS += sap.conf
AOSP_GPS += flp.conf

#GsmaNfcService
GSMA_NFC := GsmaNfcService
GSMA_NFC += com.gsma.services.nfc
GSMA_NFC += com.gsma.services.nfc.xml
GSMA_NFC += com.gsma.services.utils
GSMA_NFC += com.gsma.services.utils.xml

#HBTP
HBTP := hbtp_daemon
HBTP += hbtpcfg_qtc800s.dat
HBTP += hbtpcfg_rohm.dat
HBTP += qtc800s_dsp.bin
HBTP += libhbtpdsp
HBTP += libhbtpclient
HBTP += libhbtpfrmwk
HBTP += libfastrpc_utf_stub
HBTP += libFastRPC_UTF_Forward_skel
HBTP += libFastRPC_UTF_Forward_Qtc2_skel
HBTP += libhbtpjni
HBTP += vendor.qti.hardware.improvetouch.touchcompanion@1.0
HBTP += vendor.qti.hardware.improvetouch.touchcompanion@1.0_vendor
HBTP += vendor.qti.hardware.improvetouch.touchcompanion@1.0-service
HBTP += vendor.qti.hardware.improvetouch.gesturemanager@1.0
HBTP += vendor.qti.hardware.improvetouch.gesturemanager@1.0_vendor
HBTP += vendor.qti.hardware.improvetouch.gesturemanager@1.0-service
HBTP += vendor.qti.hardware.improvetouch.blobmanager@1.0
HBTP += vendor.qti.hardware.improvetouch.blobmanager@1.0_vendor
HBTP += vendor.qti.hardware.improvetouch.blobmanager@1.0-service
HBTP += loader.cfg

#HY11_HY22 diff
HY11_HY22_diff += libacdb-fts
HY11_HY22_diff += libdatactrl
HY11_HY22_diff += libevent_observer
HY11_HY22_diff += libimsmedia_jni
HY11_HY22_diff += libsettings
HY11_HY22_diff += libwfdavenhancements
HY11_HY22_diff += libacdb-fts
HY11_HY22_diff += libacdbrtac
HY11_HY22_diff += libadiertac
HY11_HY22_diff += libdatactrl
HY11_HY22_diff += libdiag
HY11_HY22_diff += libevent_observer
HY11_HY22_diff += libimsmedia_jni
HY11_HY22_diff += libwbc_jni
HY11_HY22_diff += libmmcamera2_c2d_module
HY11_HY22_diff += libmmcamera2_cpp_module
HY11_HY22_diff += libmmcamera2_iface_modules
HY11_HY22_diff += libmmcamera2_imglib_modules
HY11_HY22_diff += libmmcamera2_isp_modules
HY11_HY22_diff += libmmcamera2_pp_buf_mgr
HY11_HY22_diff += libmmcamera2_pproc_modules
HY11_HY22_diff += libmmcamera2_sensor_modules
HY11_HY22_diff += libmmcamera2_stats_lib
HY11_HY22_diff += libmmcamera_eztune_module
HY11_HY22_diff += libmmcamera_ppbase_module
HY11_HY22_diff += libmmcamera_sw2d_lib
HY11_HY22_diff += libmmcamera_thread_services
HY11_HY22_diff += libmmcamera_tuning_lookup
HY11_HY22_diff += libomx-dts
HY11_HY22_diff += libqdi
HY11_HY22_diff += libqdp
HY11_HY22_diff += libqmi_client_qmux
HY11_HY22_diff += libremosaic_daemon
HY11_HY22_diff += libsensor_reg
HY11_HY22_diff += libsettings
HY11_HY22_diff += libtime_genoff
HY11_HY22_diff += libwfdavenhancements
HY11_HY22_diff += libwfdmmsink
HY11_HY22_diff += libwfduibcsinkinterface
HY11_HY22_diff += libwfduibcsink
HY11_HY22_diff += libpdnotifier
HY11_HY22_diff += libperfgluelayer
HY11_HY22_diff += libqti-gt-prop
HY11_HY22_diff += vendor.qti.hardware.radio.atcmdfwd@1.0_vendor
HY11_HY22_diff += radioconfig
HY11_HY22_diff += LteDirectDiscovery.xml
HY11_HY22_diff += radioconfig.xml
HY11_HY22_diff += radioconfiginterface.xml
HY11_HY22_diff += cdma_call_conf.xml
HY11_HY22_diff += spn-conf.xml
HY11_HY22_diff += libsns_low_lat_stream_skel_system
HY11_HY22_diff += libqti-util_system

# IMS Telephony Libs
# Defined as the ims provider in the overlay
IMS_TEL := ims.xml
IMS_TEL += imslibrary
IMS_TEL += ims

#IMS_VT
IMS_VT := lib-imsvt
IMS_VT += lib-imscamera
IMS_VT += lib-imsvtextutils
IMS_VT += lib-imsvtutils
IMS_VT += lib-imsvideocodec
IMS_VT += librcc

# Vzw Specific RCS APIs (Android Telephony)
IMS_TEL_RCS := qti-vzw-ims-internal
IMS_TEL_RCS += qti-vzw-ims-internal.xml
IMS_TEL_RCS += qti-vzw-ims-common
IMS_TEL_RCS += qti-vzw-ims-common.xml

#IMS_RCS
IMS_RCS := imsrcsd
IMS_RCS += lib-uceservice
IMS_RCS += lib-imsrcs-v2
IMS_RCS += lib-imsxml
IMS_RCS += lib-imscmservice
IMS_RCS += uceShimService
IMS_RCS += whitelist_com.qualcomm.qti.uceShimService
IMS_RCS += com.qualcomm.qti.imscmservice@1.0
IMS_RCS += com.qualcomm.qti.imscmservice@1.0_vendor

#IMS_NEWARCH
IMS_NEWARCH := imsdatadaemon
IMS_NEWARCH += imsqmidaemon
IMS_NEWARCH += ims_rtp_daemon
IMS_NEWARCH += lib-dplmedia
IMS_NEWARCH += lib-imsdpl
IMS_NEWARCH += lib-imsqimf
IMS_NEWARCH += lib-imsSDP
IMS_NEWARCH += lib-rtpcommon
IMS_NEWARCH += lib-rtpcore
IMS_NEWARCH += lib-rtpdaemoninterface
IMS_NEWARCH += lib-rtpsl
IMS_NEWARCH += vendor.qti.imsrtpservice@1.0-service-Impl
IMS_NEWARCH += vendor.qti.imsrtpservice@1.0
IMS_NEWARCH += vendor.qti.imsrtpservice@1.0_vendor

#IMS_REGMGR
IMS_REGMGR := RegmanagerApi

#MDM_HELPER
MDM_HELPER := mdm_helper

#MDM_HELPER_PROXY
MDM_HELPER_PROXY := mdm_helper_proxy

#MM_AUDIO
MM_AUDIO := audiod
MM_AUDIO += AudioFilter
MM_AUDIO += libacdbloader
MM_AUDIO += libacdbmapper
MM_AUDIO += libalsautils
MM_AUDIO += libatu
MM_AUDIO += libaudcal
MM_AUDIO += libaudioalsa
MM_AUDIO += libaudioeq
MM_AUDIO += libaudioparsers
MM_AUDIO += libcsd-client
MM_AUDIO += lib_iec_60958_61937
MM_AUDIO += libmm-audio-resampler
MM_AUDIO += libstagefright_soft_qtiflacdec
MM_AUDIO += libOmxAacDec
MM_AUDIO += libOmxAacEnc
MM_AUDIO += libOmxAdpcmDec
MM_AUDIO += libOmxAmrDec
MM_AUDIO += libOmxAmrEnc
MM_AUDIO += libOmxAmrRtpDec
MM_AUDIO += libOmxAmrwbDec
MM_AUDIO += libOmxAmrwbplusDec
MM_AUDIO += libOmxEvrcDec
MM_AUDIO += libOmxEvrcEnc
MM_AUDIO += libOmxEvrcHwDec
MM_AUDIO += libOmxMp3Dec
MM_AUDIO += libOmxQcelp13Dec
MM_AUDIO += libOmxQcelp13Enc
MM_AUDIO += libOmxQcelpHwDec
MM_AUDIO += libOmxVp8Dec
MM_AUDIO += libOmxWmaDec
MM_AUDIO += libOmxAlacDec
MM_AUDIO += libOmxApeDec
MM_AUDIO += libOmxAlacDecSw
MM_AUDIO += libOmxApeDecSw
MM_AUDIO += libOmxDsdDec
MM_AUDIO += libvoem-jni
MM_AUDIO += mm-omx-devmgr
MM_AUDIO += QCAudioManager
MM_AUDIO += liblistensoundmodel
MM_AUDIO += liblistensoundmodel2
MM_AUDIO += liblistenjni
MM_AUDIO += liblisten
MM_AUDIO += liblistenhardware
MM_AUDIO += STApp
MM_AUDIO += libqtigef
MM_AUDIO += libqcbassboost
MM_AUDIO += libqcvirt
MM_AUDIO += libqcreverb
MM_AUDIO += libasphere
MM_AUDIO += audiosphere
MM_AUDIO += audiosphere.xml
MM_AUDIO += audio_effects.conf
MM_AUDIO += libFlacSwDec
MM_AUDIO += libAlacSwDec
MM_AUDIO += libApeSwDec
MM_AUDIO += libdsd2pcm
MM_AUDIO += audioflacapp
MM_AUDIO += libqct_resampler
MM_AUDIO += libaudiodevarb
MM_AUDIO += audiod
MM_AUDIO += libsmwrapper
MM_AUDIO += libadpcmdec
MM_AUDIO += libmulawdec
MM_AUDIO += sound_trigger.primary.msm8998
MM_AUDIO += libnative_audio_latency_jni
MM_AUDIO += libhwdaphal
MM_AUDIO += libqcomvisualizer
MM_AUDIO += libqcomvoiceprocessing
MM_AUDIO += libqcompostprocbundle
MM_AUDIO += libadm
MM_AUDIO += libsurround_3mic_proc
MM_AUDIO += surround_sound_rec_AZ.cfg
MM_AUDIO += surround_sound_rec_5.1.cfg
MM_AUDIO += libdrc
MM_AUDIO += drc_cfg_AZ.txt
MM_AUDIO += drc_cfg_5.1.txt
MM_AUDIO += libgcs-osal
MM_AUDIO += libgcs-calwrapper
MM_AUDIO += libgcs-ipc
MM_AUDIO += libgcs
MM_AUDIO += cmudict.bin
MM_AUDIO += poc_64_hmm.gmm
MM_AUDIO += noisesample.bin
MM_AUDIO += antispoofing.bin
MM_AUDIO += libshoebox
MM_AUDIO += libvr_amb_engine
MM_AUDIO += libvr_object_engine
MM_AUDIO += libvr_sam_wrapper
MM_AUDIO += libvraudio
MM_AUDIO += libvraudio_client

#MM_CAMERA
MM_CAMERA := cpp_firmware_v1_1_1.fw
MM_CAMERA += cpp_firmware_v1_1_6.fw
MM_CAMERA += cpp_firmware_v1_2_0.fw
MM_CAMERA += cpp_firmware_v1_2_A.fw
MM_CAMERA += cpp_firmware_v1_6_0.fw
MM_CAMERA += cpp_firmware_v1_4_0.fw
MM_CAMERA += cpp_firmware_v1_5_0.fw
MM_CAMERA += cpp_firmware_v1_5_1.fw
MM_CAMERA += cpp_firmware_v1_5_2.fw
MM_CAMERA += cpp_firmware_v1_8_0.fw
MM_CAMERA += cpp_firmware_v1_10_0.fw
MM_CAMERA += cpp_firmware_v1_12_0.fw
MM_CAMERA += libflash_pmic
MM_CAMERA += libactuator_ak7371
MM_CAMERA += libactuator_ak7371_mono
MM_CAMERA += libois_lc898122
MM_CAMERA += libadsp_denoise_skel
MM_CAMERA += libadsp_hvx_add_constant
MM_CAMERA += libadsp_hvx_add_constant.so
MM_CAMERA += libadsp_hvx_stats
MM_CAMERA += libadsp_hvx_stats.so
MM_CAMERA += libadsp_hvx_callback_skel
MM_CAMERA += libadsp_hvx_stub
MM_CAMERA += libadsp_hvx_skel
MM_CAMERA += libadsp_hvx_skel.so
MM_CAMERA += libadsp_fd_skel
MM_CAMERA += libadsp_hvx_zzhdr_BGGR
MM_CAMERA += libadsp_hvx_zzhdr_BGGR.so
MM_CAMERA += libadsp_hvx_zzhdr_RGGB
MM_CAMERA += libadsp_hvx_zzhdr_RGGB.so
MM_CAMERA += libchromatix_imx258_common
MM_CAMERA += libchromatix_imx258_cpp_hfr_60
MM_CAMERA += libchromatix_imx258_cpp_hfr_90
MM_CAMERA += libchromatix_imx258_cpp_hfr_120
MM_CAMERA += libchromatix_imx258_cpp_liveshot
MM_CAMERA += libchromatix_imx258_cpp_preview
MM_CAMERA += libchromatix_imx258_cpp_snapshot
MM_CAMERA += libchromatix_imx258_cpp_video
MM_CAMERA += libchromatix_imx258_cpp_video_4k
MM_CAMERA += libchromatix_imx258_default_video
MM_CAMERA += libchromatix_imx258_hfr_60
MM_CAMERA += libchromatix_imx258_hfr_90
MM_CAMERA += libchromatix_imx258_hfr_120
MM_CAMERA += libchromatix_imx258_liveshot
MM_CAMERA += libchromatix_imx258_postproc
MM_CAMERA += libchromatix_imx258_preview
MM_CAMERA += libchromatix_imx258_snapshot
MM_CAMERA += libchromatix_imx258_video_4k
MM_CAMERA += libchromatix_imx258_4k_preview_3a
MM_CAMERA += libchromatix_imx258_4k_video_3a
MM_CAMERA += libchromatix_imx258_default_preview_3a
MM_CAMERA += libchromatix_imx258_default_video_3a
MM_CAMERA += libchromatix_imx258_hfr_60_3a
MM_CAMERA += libchromatix_imx258_hfr_90_3a
MM_CAMERA += libchromatix_imx258_hfr_120_3a
MM_CAMERA += libchromatix_imx258_zsl_preview_3a
MM_CAMERA += libchromatix_imx258_zsl_video_3a
MM_CAMERA += libchromatix_imx258_mono_common
MM_CAMERA += libchromatix_imx258_mono_cpp_hfr_60
MM_CAMERA += libchromatix_imx258_mono_cpp_hfr_90
MM_CAMERA += libchromatix_imx258_mono_cpp_hfr_120
MM_CAMERA += libchromatix_imx258_mono_cpp_liveshot
MM_CAMERA += libchromatix_imx258_mono_cpp_preview
MM_CAMERA += libchromatix_imx258_mono_cpp_snapshot
MM_CAMERA += libchromatix_imx258_mono_cpp_video
MM_CAMERA += libchromatix_imx258_mono_cpp_video_4k
MM_CAMERA += libchromatix_imx258_mono_default_video
MM_CAMERA += libchromatix_imx258_mono_hfr_60
MM_CAMERA += libchromatix_imx258_mono_hfr_90
MM_CAMERA += libchromatix_imx258_mono_hfr_120
MM_CAMERA += libchromatix_imx258_mono_liveshot
MM_CAMERA += libchromatix_imx258_mono_postproc
MM_CAMERA += libchromatix_imx258_mono_preview
MM_CAMERA += libchromatix_imx258_mono_snapshot
MM_CAMERA += libchromatix_imx258_mono_video_4k
MM_CAMERA += libchromatix_imx258_mono_4k_preview_3a
MM_CAMERA += libchromatix_imx258_mono_4k_video_3a
MM_CAMERA += libchromatix_imx258_mono_default_preview_3a
MM_CAMERA += libchromatix_imx258_mono_default_video_3a
MM_CAMERA += libchromatix_imx258_mono_hfr_60_3a
MM_CAMERA += libchromatix_imx258_mono_hfr_90_3a
MM_CAMERA += libchromatix_imx258_mono_hfr_120_3a
MM_CAMERA += libchromatix_imx258_mono_zsl_preview_3a
MM_CAMERA += libchromatix_imx258_mono_zsl_video_3a
MM_CAMERA += libedgesmooth
MM_CAMERA += libedge_smooth_hvx_stub
MM_CAMERA += libedge_smooth_skel
MM_CAMERA += libmmcamera_hvx_add_constant
MM_CAMERA += libmmcamera_hvx_grid_sum
MM_CAMERA += libmmcamera_hvx_zzHDR
MM_CAMERA += libmmcamera
MM_CAMERA += libmmcamera_dbg
MM_CAMERA += libmmcamera_cac_lib
MM_CAMERA += libmmcamera_cac2_lib
MM_CAMERA += libmmcamera_chromaflash_lib
MM_CAMERA += libmmcamera_edgesmooth_lib
MM_CAMERA += libmmcamera_quadracfa
MM_CAMERA += libremosaiclib
MM_CAMERA += libmmcamera_eeprom_util
MM_CAMERA += libmmcamera_facedetection_lib
MM_CAMERA += libmmcamera_faceproc
MM_CAMERA += libmmcamera_faceproc2
MM_CAMERA += libswregistrationalgo
MM_CAMERA += libmmcamera_faceproc_system
MM_CAMERA += libmmcamera_faceproc2_system
MM_CAMERA += libswregistrationalgo_system
MM_CAMERA += libmmcamera_frameproc
MM_CAMERA += libmmcamera_hdr_gb_lib
MM_CAMERA += libmmcamera_hdr_lib
MM_CAMERA += libmmcamera_hi256
MM_CAMERA += libmmcamera_imglib
MM_CAMERA += libmmcamera_paaf_lib
MM_CAMERA += libmmcamera_depth_map
MM_CAMERA += libdepthmapwrapper
MM_CAMERA += libdualcameraddm_system
MM_CAMERA += libmmcamera_imx258
MM_CAMERA += libmmcamera_imx258_gt24c32_eeprom
MM_CAMERA += libmmcamera_imx258_mono
MM_CAMERA += libmmcamera_imx258_mono_gt24c32_eeprom
MM_CAMERA += libmmcamera_imx268
MM_CAMERA += libmmcamera_dcrf_lib
MM_CAMERA += libmmcamera_llvd
#MM_CAMERA += libmmcamera_bokeh
MM_CAMERA += libmmcamera_sw_tnr
MM_CAMERA += libmmcamera_s5k3m2xm
MM_CAMERA += libmmcamera_isp_abf44
MM_CAMERA += libmmcamera_isp_abf46
MM_CAMERA += libmmcamera_isp_abf47
MM_CAMERA += libmmcamera_isp_abf48
MM_CAMERA += libmmcamera_isp_aec_bg_stats47
MM_CAMERA += libmmcamera_isp_abcc44
MM_CAMERA += libmmcamera_isp_bcc44
MM_CAMERA += libmmcamera_isp_black_level47
MM_CAMERA += libmmcamera_isp_bpc40
MM_CAMERA += libmmcamera_isp_bcc40
MM_CAMERA += libmmcamera_isp_bpc44
MM_CAMERA += libmmcamera_isp_bpc47
MM_CAMERA += libmmcamera_isp_bpc48
MM_CAMERA += libmmcamera_isp_be_stats44
MM_CAMERA += libmmcamera_isp_bf_scale_stats44
MM_CAMERA += libmmcamera_isp_bf_scale_stats46
MM_CAMERA += libmmcamera_isp_bf_stats44
MM_CAMERA += libmmcamera_isp_bf_stats47
MM_CAMERA += libmmcamera_isp_bhist_stats44
MM_CAMERA += libmmcamera_isp_bg_stats44
MM_CAMERA += libmmcamera_isp_bg_stats46
MM_CAMERA += libmmcamera_isp_black_level48
MM_CAMERA += libmmcamera_isp_cac47
MM_CAMERA += libmmcamera_isp_cs_stats44
MM_CAMERA += libmmcamera_isp_cs_stats46
MM_CAMERA += libmmcamera_isp_chroma_enhan40
MM_CAMERA += libmmcamera_isp_chroma_suppress40
MM_CAMERA += libmmcamera_isp_clamp_encoder40
MM_CAMERA += libmmcamera_isp_clamp_viewfinder40
MM_CAMERA += libmmcamera_isp_clamp_video40
MM_CAMERA += libmmcamera_isp_clf44
MM_CAMERA += libmmcamera_isp_clf46
MM_CAMERA += libmmcamera_isp_color_correct40
MM_CAMERA += libmmcamera_isp_color_correct46
MM_CAMERA += libmmcamera_isp_color_xform_encoder40
MM_CAMERA += libmmcamera_isp_color_xform_viewfinder40
MM_CAMERA += libmmcamera_isp_color_xform_encoder46
MM_CAMERA += libmmcamera_isp_color_xform_viewfinder46
MM_CAMERA += libmmcamera_isp_color_xform_video46
MM_CAMERA += libmmcamera_isp_demosaic40
MM_CAMERA += libmmcamera_isp_demosaic44
MM_CAMERA += libmmcamera_isp_demosaic47
MM_CAMERA += libmmcamera_isp_demosaic48
MM_CAMERA += libmmcamera_isp_demux40
MM_CAMERA += libmmcamera_isp_demux48
MM_CAMERA += libmmcamera_isp_fovcrop_encoder40
MM_CAMERA += libmmcamera_isp_fovcrop_viewfinder40
MM_CAMERA += libmmcamera_isp_fovcrop_encoder46
MM_CAMERA += libmmcamera_isp_fovcrop_viewfinder46
MM_CAMERA += libmmcamera_isp_fovcrop_video46
MM_CAMERA += libmmcamera_isp_gamma40
MM_CAMERA += libmmcamera_isp_gamma44
MM_CAMERA += libmmcamera_isp_gamma46
MM_CAMERA += libmmcamera_isp_gic46
MM_CAMERA += libmmcamera_isp_gic48
MM_CAMERA += libmmcamera_isp_gtm46
MM_CAMERA += libmmcamera_isp_hdr_be_stats46
MM_CAMERA += libmmcamera_isp_hdr46
MM_CAMERA += libmmcamera_isp_hdr48
MM_CAMERA += libmmcamera_isp_hdr_bhist_stats44
MM_CAMERA += libmmcamera_isp_ihist_stats44
MM_CAMERA += libmmcamera_isp_ihist_stats46
MM_CAMERA += libmmcamera_isp_linearization40
MM_CAMERA += libmmcamera_isp_luma_adaptation40
MM_CAMERA += libmmcamera_isp_ltm44
MM_CAMERA += libmmcamera_isp_ltm47
MM_CAMERA += libmmcamera_isp_mce40
MM_CAMERA += libmmcamera_isp_mesh_rolloff40
MM_CAMERA += libmmcamera_isp_mesh_rolloff44
MM_CAMERA += libmmcamera_isp_pedestal_correct46
MM_CAMERA += libmmcamera_isp_pdaf48
MM_CAMERA += libmmcamera_isp_rs_stats44
MM_CAMERA += libmmcamera_isp_scaler_encoder40
MM_CAMERA += libmmcamera_isp_scaler_viewfinder40
MM_CAMERA += libmmcamera_isp_snr47
MM_CAMERA += libmmcamera_isp_rs_stats46
MM_CAMERA += libmmcamera_isp_scaler_encoder44
MM_CAMERA += libmmcamera_isp_scaler_viewfinder44
MM_CAMERA += libmmcamera_isp_scaler_encoder46
MM_CAMERA += libmmcamera_isp_scaler_viewfinder46
MM_CAMERA += libmmcamera_isp_scaler_video46
MM_CAMERA += libmmcamera_isp_sce40
MM_CAMERA += libmmcamera_isp_sub_module
MM_CAMERA += libmmcamera_isp_wb40
MM_CAMERA += libmmcamera_isp_wb46
MM_CAMERA += libmmcamera_mt9m114
MM_CAMERA += libmmcamera_optizoom_lib
MM_CAMERA += libmmcamera_pdaf
MM_CAMERA += libmmcamera_pdafcamif
MM_CAMERA += libmmcamera_plugin
MM_CAMERA += libmmcamera_sp1628
MM_CAMERA += libmmcamera_statsproc31
MM_CAMERA += libmmcamera_stillmore_lib
MM_CAMERA += libmmcamera_target
MM_CAMERA += libmmcamera_trueportrait_lib
MM_CAMERA += libmmcamera_ubifocus_lib
MM_CAMERA += libmmcamera_wavelet_lib
MM_CAMERA += libmmcamera2_dcrf
MM_CAMERA += libmmcamera2_frame_algorithm
MM_CAMERA += libmmcamera2_q3a_core
MM_CAMERA += libmmcamera2_q3a_release
MM_CAMERA += libmmcamera2_is
MM_CAMERA += libmmcamera2_stats_algorithm
MM_CAMERA += libmmcamera2_stats_release
MM_CAMERA += libmmcamera-core
MM_CAMERA += libmm-qcamera
MM_CAMERA += liboemcamera
MM_CAMERA += libmmcamera2_mct
MM_CAMERA += libqcamera
MM_CAMERA += libseemore_hexagon_skel
MM_CAMERA += libtm_interface
MM_CAMERA += v4l2-qcamera-app
MM_CAMERA += libmmcamera_tintless_algo
MM_CAMERA += libmmcamera_tintless_bg_pca_algo
MM_CAMERA += libmmcamera2_mct_shimlayer

MM_CAMERA += libmmcamera_csidtg
MM_CAMERA += libmmcamera_eebinparse
MM_CAMERA += libmmcamera_imglib_faceproc_adspstub
MM_CAMERA += libmmcamera_isp_abf40
MM_CAMERA += libmmcamera_isp_template
MM_CAMERA += libmmcamera_dummyalgo
MM_CAMERA += libactuator_bu64297
MM_CAMERA += libactuator_dw9761b
MM_CAMERA += libactuator_dw9763
MM_CAMERA += libchromatix_csidtg_common
MM_CAMERA += libchromatix_csidtg_cpp_preview
MM_CAMERA += libchromatix_csidtg_postproc
MM_CAMERA += libchromatix_csidtg_preview
MM_CAMERA += libchromatix_csidtg_zsl_preview

MM_CAMERA += camera_config.xml
MM_CAMERA += imx258_chromatix.xml
MM_CAMERA += imx258_mono_chromatix.xml
MM_CAMERA += sensors.hal.tof

MM_CAMERA += libchromaflash
MM_CAMERA += liboptizoom
MM_CAMERA += libseemore
MM_CAMERA += libblurbuster
MM_CAMERA += libclearsight
MM_CAMERA += libts_face_beautify_hal_system
MM_CAMERA += libubifocus_system
MM_CAMERA += libdualcameraddm_system
MM_CAMERA += libchromaflash_system
MM_CAMERA += liboptizoom_system
MM_CAMERA += libseemore_system

ifneq ($(TARGET_SCVE_DISABLED),true)
MM_CAMERA += libjni_trackingfocus
MM_CAMERA += libjni_panorama
endif
MM_CAMERA += libjni_makeupV2
MM_CAMERA += libjni_sharpshooter
MM_CAMERA += libjni_stillmore
MM_CAMERA += libjni_optizoom
MM_CAMERA += libjni_chromaflash
MM_CAMERA += libjni_ubifocus
MM_CAMERA += libjni_blurbuster
MM_CAMERA += libllvd_smore
MM_CAMERA += libllvd_sw_tnr
MM_CAMERA += libdualcameraddm
MM_CAMERA += libvideobokeh
MM_CAMERA += libubifocus
MM_CAMERA += libjni_dualcamera
MM_CAMERA += libts_detected_face_hal
MM_CAMERA += libts_detected_face_jni
MM_CAMERA += libts_face_beautify_hal
MM_CAMERA += libts_face_beautify_jni
MM_CAMERA += libjni_clearsight

MM_CAMERA += imx268_chromatix.xml
MM_CAMERA += libchromatix_imx268_common
MM_CAMERA += libchromatix_imx268_cpp_hfr_60
MM_CAMERA += libchromatix_imx268_cpp_hfr_90
MM_CAMERA += libchromatix_imx268_cpp_hfr_120
MM_CAMERA += libchromatix_imx268_cpp_liveshot
MM_CAMERA += libchromatix_imx268_cpp_preview
MM_CAMERA += libchromatix_imx268_cpp_snapshot
MM_CAMERA += libchromatix_imx268_cpp_video
MM_CAMERA += libchromatix_imx268_cpp_video_4k
MM_CAMERA += libchromatix_imx268_default_video
MM_CAMERA += libchromatix_imx268_hfr_60
MM_CAMERA += libchromatix_imx268_hfr_90
MM_CAMERA += libchromatix_imx268_hfr_120
MM_CAMERA += libchromatix_imx268_liveshot
MM_CAMERA += libchromatix_imx268_postproc
MM_CAMERA += libchromatix_imx268_preview
MM_CAMERA += libchromatix_imx268_snapshot
MM_CAMERA += libchromatix_imx268_video_4k
MM_CAMERA += libchromatix_imx268_4k_preview_3a
MM_CAMERA += libchromatix_imx268_4k_video_3a
MM_CAMERA += libchromatix_imx268_default_preview_3a
MM_CAMERA += libchromatix_imx268_default_video_3a
MM_CAMERA += libchromatix_imx268_hfr_60_3a
MM_CAMERA += libchromatix_imx268_hfr_90_3a
MM_CAMERA += libchromatix_imx268_hfr_120_3a
MM_CAMERA += libchromatix_imx268_zsl_preview_3a
MM_CAMERA += libchromatix_imx268_zsl_video_3a

#Gallery
MM_CAMERA += libfiltergenerator
MM_CAMERA += libhazebuster
MM_CAMERA += libtrueportrait
MM_CAMERA += libseestraight
MM_CAMERA += libtruescanner

MM_CAMERA += libjni_filtergenerator
MM_CAMERA += libjni_hazebuster
MM_CAMERA += libjni_trueportrait
MM_CAMERA += libjni_seestraight
MM_CAMERA += libjni_truescanner_v2

#CamX
MM_CAMERA += CAMERA_ICP.elf

MM_CAMERA += camera.qcom
MM_CAMERA += com.qti.chi.override
MM_CAMERA += com.qti.node.memcpy
MM_CAMERA += com.qti.node.swregistration
MM_CAMERA += com.qti.sensormodule.liteon_imx318.bin
MM_CAMERA += com.qti.sensormodule.semco_imx258.bin
MM_CAMERA += imx318tuned.bin
MM_CAMERA += libcamxosutils

#to be removed after source code merges
MM_CAMERA += libcamxstaticaecalgo
MM_CAMERA += libcamxstaticafalgo
MM_CAMERA += libcamxstaticafdalgo
MM_CAMERA += libcamxstaticasdalgo
MM_CAMERA += libcamxstaticawbalgo
MM_CAMERA += libcom.qti.stats.aec
MM_CAMERA += libcom.qti.stats.af
MM_CAMERA += libcom.qti.stats.awb
#end of can be removed after source code merges

MM_CAMERA += libcom.qti.stats.asd
MM_CAMERA += libcom.qti.stats.pdlib
MM_CAMERA += libcom.qtistatic.stats.asd
MM_CAMERA += com.qtistatic.stats.aec
MM_CAMERA += com.qtistatic.stats.af
MM_CAMERA += com.qtistatic.stats.awb
MM_CAMERA += com.qti.stats.aec
MM_CAMERA += com.qti.stats.af
MM_CAMERA += com.qti.stats.awb
MM_CAMERA += libcamxstatscore
MM_CAMERA += libcamxstatsparser
MM_CAMERA += libcamxutils
MM_CAMERA += libsync
MM_CAMERA += stripinglib
MM_CAMERA += systemdefault.bin
MM_CAMERA += titan17x_usecases.bin
#MM_CORE
MM_CORE := libdisp-aba
MM_CORE += libmm-abl
MM_CORE += libmm-abl-oem
MM_CORE += libscale
MM_CORE += mm-pp-daemon
MM_CORE += libmm-hdcpmgr
MM_CORE += libvpu
MM_CORE += libvfmclientutils
MM_CORE += libmm-qdcm
MM_CORE += libmm-disp-apis
MM_CORE += libmm-als

#MM_COLOR_CONVERSION
MM_COLOR_CONVERSION := libtile2linear

#MM_COLOR_CONVERTOR
MM_COLOR_CONVERTOR := libmm-color-convertor
MM_COLOR_CONVERTOR += libI420colorconvert

#MM_GESTURES
MM_GESTURES := gesture_mouse.idc
MM_GESTURES += GestureOverlayService
MM_GESTURES += GestureTouchInjectionConfig
MM_GESTURES += GestureTouchInjectionService
MM_GESTURES += libgesture-core
MM_GESTURES += libmmgesture-activity-trigger
MM_GESTURES += libmmgesture-bus
MM_GESTURES += libmmgesture-camera
MM_GESTURES += libmmgesture-camera-factory
MM_GESTURES += libmmgesture-client
MM_GESTURES += libmmgesture-jni
MM_GESTURES += libmmgesture-linux
MM_GESTURES += libmmgesture-service
MM_GESTURES += mm-gesture-daemon

#MM_GRAPHICS
MM_GRAPHICS := a225_pfp.fw
MM_GRAPHICS += a225_pm4.fw
MM_GRAPHICS += a225p5_pm4.fw
MM_GRAPHICS += a300_pfp.fw
MM_GRAPHICS += a300_pm4.fw
MM_GRAPHICS += a330_pfp.fw
MM_GRAPHICS += a330_pm4.fw
MM_GRAPHICS += a420_pfp.fw
MM_GRAPHICS += a420_pm4.fw
MM_GRAPHICS += a530_pfp.fw
MM_GRAPHICS += a530_pm4.fw
MM_GRAPHICS += a530v1_pfp.fw
MM_GRAPHICS += a530v1_pm4.fw
MM_GRAPHICS += a530_gpmu.fw2
MM_GRAPHICS += a530v2_seq.fw2
MM_GRAPHICS += a530v3_gpmu.fw2
MM_GRAPHICS += a530v3_seq.fw2
MM_GRAPHICS += a530_zap.b00
MM_GRAPHICS += a530_zap.b01
MM_GRAPHICS += a530_zap.b02
MM_GRAPHICS += a530_zap.mdt
MM_GRAPHICS += a530_zap.elf
MM_GRAPHICS += a512_zap.b00
MM_GRAPHICS += a512_zap.b01
MM_GRAPHICS += a512_zap.b02
MM_GRAPHICS += a512_zap.mdt
MM_GRAPHICS += a512_zap.elf
MM_GRAPHICS += a508_zap.b00
MM_GRAPHICS += a508_zap.b01
MM_GRAPHICS += a508_zap.b02
MM_GRAPHICS += a508_zap.mdt
MM_GRAPHICS += a508_zap.elf
MM_GRAPHICS += a506_zap.b00
MM_GRAPHICS += a506_zap.b01
MM_GRAPHICS += a506_zap.b02
MM_GRAPHICS += a506_zap.mdt
MM_GRAPHICS += a506_zap.elf
MM_GRAPHICS += a540_gpmu.fw2
MM_GRAPHICS += a630_sqe.fw
MM_GRAPHICS += a630_gmu.bin
MM_GRAPHICS += a630_zap.b00
MM_GRAPHICS += a630_zap.b01
MM_GRAPHICS += a630_zap.b02
MM_GRAPHICS += a630_zap.elf
MM_GRAPHICS += a630_zap.mdt
MM_GRAPHICS += a615_zap.b00
MM_GRAPHICS += a615_zap.b01
MM_GRAPHICS += a615_zap.b02
MM_GRAPHICS += a615_zap.elf
MM_GRAPHICS += a615_zap.mdt
MM_GRAPHICS += eglsubAndroid
MM_GRAPHICS += eglSubDriverAndroid
MM_GRAPHICS += gpu_dcvsd
MM_GRAPHICS += leia_pfp_470.fw
MM_GRAPHICS += leia_pm4_470.fw
MM_GRAPHICS += libadreno_utils
MM_GRAPHICS += libC2D2
MM_GRAPHICS += libCB
MM_GRAPHICS += libc2d2_z180
MM_GRAPHICS += libc2d2_a3xx
MM_GRAPHICS += libEGL_adreno
MM_GRAPHICS += libc2d30-a3xx
MM_GRAPHICS += libc2d30-a4xx
MM_GRAPHICS += libc2d30-a5xx
MM_GRAPHICS += libc2d30_bltlib
MM_GRAPHICS += libc2d30
MM_GRAPHICS += libgsl
MM_GRAPHICS += libGLESv2_adreno
MM_GRAPHICS += libGLESv2S3D_adreno
MM_GRAPHICS += libGLESv1_CM_adreno
MM_GRAPHICS += libllvm-a3xx
MM_GRAPHICS += libllvm-arm
MM_GRAPHICS += libllvm-glnext
MM_GRAPHICS += libllvm-qcom
MM_GRAPHICS += libOpenVG
MM_GRAPHICS += libOpenCL
MM_GRAPHICS += libplayback_adreno
MM_GRAPHICS += libq3dtools_adreno
MM_GRAPHICS += libq3dtools_esx
MM_GRAPHICS += libQTapGLES
MM_GRAPHICS += libsc-a2xx
MM_GRAPHICS += libsc-a3xx
MM_GRAPHICS += libsc-adreno.a
MM_GRAPHICS += ProfilerPlaybackTools
MM_GRAPHICS += yamato_pfp.fw
MM_GRAPHICS += yamato_pm4.fw
MM_GRAPHICS += librs_adreno
MM_GRAPHICS += libRSDriver_adreno
MM_GRAPHICS += libbccQTI
MM_GRAPHICS += android.hardware.renderscript@1.0-impl
MM_GRAPHICS += libintrinsics_skel
MM_GRAPHICS += librs_adreno_sha1
MM_GRAPHICS += libESXEGL_adreno
MM_GRAPHICS += libESXGLESv1_CM_adreno
MM_GRAPHICS += libESXGLESv2_adreno
MM_GRAPHICS += libRBEGL_adreno
MM_GRAPHICS += libRBGLESv1_CM_adreno
MM_GRAPHICS += libRBGLESv2_adreno
MM_GRAPHICS += vulkan.msm8998
MM_GRAPHICS += libllvm-qgl

#MM_HTTP
MM_HTTP := libmmipstreamaal
MM_HTTP += libmmipstreamnetwork
MM_HTTP += libmmipstreamutils
MM_HTTP += libmmiipstreammmihttp
MM_HTTP += libmmhttpstack
MM_HTTP += libmmipstreamsourcehttp
MM_HTTP += libmmqcmediaplayer
MM_HTTP += libmmipstreamdeal

#MM_DRMPLAY
MM_DRMPLAY := drmclientlib
MM_DRMPLAY += libDrmPlay

#MM_MUX
MM_MUX := libFileMux

#MM_OSAL
MM_OSAL := libmmosal
MM_OSAL += libmmosal_proprietary

#MM_PARSER
MM_PARSER := libmmparser_lite

#MM_QSM
MM_QSM := libmmQSM

#MM_RTP
MM_RTP := libmmrtpdecoder
MM_RTP += libmmrtpencoder

#MM_STEREOLIB
MM_STEREOLIB := libmmstereo

#MM_STILL
MM_STILL := libadsp_jpege_skel
MM_STILL += libgemini
MM_STILL += libimage-jpeg-dec-omx-comp
MM_STILL += libimage-jpeg-enc-omx-comp
MM_STILL += libimage-omx-common
MM_STILL += libjpegdhw
MM_STILL += libjpegehw
MM_STILL += libmmipl
MM_STILL += libmmjpeg
MM_STILL += libmmjps
MM_STILL += libmmmpo
MM_STILL += libmmmpod
MM_STILL += libmmqjpeg_codec
MM_STILL += libmmstillomx
MM_STILL += libqomx_jpegenc
MM_STILL += libqomx_jpegdec
MM_STILL += test_gemini
MM_STILL += libjpegdmahw
MM_STILL += libmmqjpegdma
MM_STILL += libqomx_jpegenc_pipe

#MM_VIDEO
ifneq ($(call is-board-platform,sdm845),true)
MM_VIDEO := ast-mm-vdec-omx-test7k
MM_VIDEO += iv_h264_dec_lib
MM_VIDEO += iv_mpeg4_dec_lib
MM_VIDEO += libh264decoder
MM_VIDEO += libHevcSwDecoder
MM_VIDEO += liblasic
MM_VIDEO += libmm-adspsvc
MM_VIDEO += libmp4decoder
MM_VIDEO += libmp4decodervlddsp
MM_VIDEO += libOmxH264Dec
MM_VIDEO += libOmxIttiamVdec
MM_VIDEO += libOmxIttiamVenc
MM_VIDEO += libOmxMpeg4Dec
MM_VIDEO += libOmxOn2Dec
MM_VIDEO += libOmxrv9Dec
MM_VIDEO += libon2decoder
MM_VIDEO += librv9decoder
MM_VIDEO += libVenusMbiConv
MM_VIDEO += venc-device-android
MM_VIDEO += venus-v1.b00
MM_VIDEO += venus-v1.b01
MM_VIDEO += venus-v1.b02
MM_VIDEO += venus-v1.b03
MM_VIDEO += venus-v1.b04
MM_VIDEO += venus-v1.mdt
MM_VIDEO += venus-v1.mbn
MM_VIDEO += venus.b00
MM_VIDEO += venus.b01
MM_VIDEO += venus.b02
MM_VIDEO += venus.b03
MM_VIDEO += venus.b04
MM_VIDEO += venus.mbn
MM_VIDEO += venus.mdt
MM_VIDEO += vidc_1080p.fw
MM_VIDEO += vidc.b00
MM_VIDEO += vidc.b01
MM_VIDEO += vidc.b02
MM_VIDEO += vidc.b03
MM_VIDEO += vidcfw.elf
MM_VIDEO += vidc.mdt
MM_VIDEO += vidc_720p_command_control.fw
MM_VIDEO += vidc_720p_h263_dec_mc.fw
MM_VIDEO += vidc_720p_h264_dec_mc.fw
MM_VIDEO += vidc_720p_h264_enc_mc.fw
MM_VIDEO += vidc_720p_mp4_dec_mc.fw
MM_VIDEO += vidc_720p_mp4_enc_mc.fw
MM_VIDEO += vidc_720p_vc1_dec_mc.fw
MM_VIDEO += vt-sim-test
MM_VIDEO += libgpustats
MM_VIDEO += libvqzip
endif

MM_VIDEO += libOmxVidEnc
MM_VIDEO += libOmxWmvDec
MM_VIDEO += libMpeg4SwEncoder
MM_VIDEO += libswvdec
MM_VIDEO += libVC1DecDsp_skel
MM_VIDEO += libVC1DecDsp_skel.so
MM_VIDEO += libVC1Dec
MM_VIDEO += libVC1Dec.so
MM_VIDEO += libavenhancements
MM_VIDEO += libfastcrc
MM_VIDEO += libstreamparser
MM_VIDEO += libvideoutils
MM_VIDEO += libUBWC

#MM_VPU
MM_VPU := vpu.b00
MM_VPU += vpu.b01
MM_VPU += vpu.b02
MM_VPU += vpu.b03
MM_VPU += vpu.b04
MM_VPU += vpu.b05
MM_VPU += vpu.b06
MM_VPU += vpu.b07
MM_VPU += vpu.b08
MM_VPU += vpu.b09
MM_VPU += vpu.b10
MM_VPU += vpu.b11
MM_VPU += vpu.b12
MM_VPU += vpu.mbn
MM_VPU += vpu.mdt


#MODEM_APIS
MODEM_APIS := libadc
MODEM_APIS += libauth
MODEM_APIS += libcm
MODEM_APIS += libdsucsd
MODEM_APIS += libfm_wan_api
MODEM_APIS += libgsdi_exp
MODEM_APIS += libgstk_exp
MODEM_APIS += libisense
MODEM_APIS += libloc_api
MODEM_APIS += libmmgsdilib
MODEM_APIS += libmmgsdisessionlib
MODEM_APIS += libmvs
MODEM_APIS += libnv
MODEM_APIS += liboem_rapi
MODEM_APIS += libpbmlib
MODEM_APIS += libpdapi
MODEM_APIS += libpdsm_atl
MODEM_APIS += libping_mdm
MODEM_APIS += libplayready
MODEM_APIS += librfm_sar
MODEM_APIS += libsnd
MODEM_APIS += libtime_remote_atom
MODEM_APIS += libvoem_if
MODEM_APIS += libwidevine
MODEM_APIS += libwms
MODEM_APIS += libcommondefs
MODEM_APIS += libcm_fusion
MODEM_APIS += libcm_mm_fusion
MODEM_APIS += libdsucsdappif_apis_fusion
MODEM_APIS += liboem_rapi_fusion
MODEM_APIS += libpbmlib_fusion
MODEM_APIS += libping_lte_rpc
MODEM_APIS += libwms_fusion

#MSM_IRQBALANCE
MSM_IRQBALANCE := msm_irqbalance

#PD_LOCATER - Service locater binary/libs
PD_LOCATER := pd-mapper
PD_LOCATER += libpdmapper
PD_LOCATER += libjson  # 3rd party support library

#PERIPHERAL MANAGER:
PERMGR := pm-service
PERMGR += libperipheral_client
PERMGR += pm-proxy

#PROFILER
PROFILER := profiler_tester
PROFILER += profiler_daemon
PROFILER += libprofiler_msmadc

#QCRIL
QCRIL := libril-qc-1
QCRIL += libril-qc-qmi-1
QCRIL += libril-qc-hal-qmi
QCRIL += libril-qcril-hook-oem
QCRIL += qcrilhook
QCRIL += qcrilmsgtunnel
QCRIL += qcrilhook.xml
QCRIL += libwmsts
QCRIL += libril-qc-radioconfig
QCRIL += libril-qc-ltedirectdisc
QCRIL += librilqmiservices
QCRIL += libsettings
QCRIL += liblqe
QCRIL += lib_remote_simlock
QCRIL += vendor.qti.hardware.radio.am@1.0_vendor
QCRIL += vendor.qti.hardware.radio.ims@1.0_vendor
QCRIL += vendor.qti.hardware.radio.lpa@1.0_vendor
QCRIL += vendor.qti.hardware.radio.qcrilhook@1.0_vendor
QCRIL += vendor.qti.hardware.radio.qtiradio@1.0_vendor

#QMI
QMI := check_system_health
QMI := irsc_util
QMI += libidl
QMI += libqcci_legacy
QMI += libqmi
QMI += libqmi_cci
QMI += libqmi_client_helper
QMI += libqmi_common_so
QMI += libqmi_csi
QMI += libqmi_encdec
QMI += libsmemlog
QMI += libmdmdetect
QMI += libqmiservices
QMI += qmiproxy
QMI += qmi_config.xml
QMI += libqmi_cci_system

#QOSMGR
QOSMGR := qosmgr
QOSMGR += qosmgr_rules.xml

#QVR
QVR := qvrservice_6dof_config.xml
QVR += qvrservice_6dof_config_stereo.xml
QVR += qvrservice_config.txt
QVR += ov7251_640x480_cam_config.xml
QVR += ov9282_stereo_1280x400_cam_config.xml
QVR += ov9282_stereo_2560x800_cam_config.xml
QVR += libqvrservice_ov7251_hvx_tuning
QVR += libqvrservice_ov9282_hvx_tuning
QVR += qvrservice
QVR += qvrcameratseq
QVR += qvrcameratseq64
QVR += libqvr_adsp_driver_stub
QVR += libqvr_adsp_driver_skel
QVR += libqvrservice
QVR += libqvrservice_client
QVR += libqvrcamera_client
QVR += libqvrservice_hvxcameraclient

#REMOTEFS
REMOTEFS := rmt_storage

RFS_ACCESS := rfs_access

#RNGD
RNGD := rngd

#SCVE
SCVE := _conf_eng_num_sym_font40_4transd_zscore_morph_.trn2876.trn
SCVE += _conf_eng_num_sym_font40_conc2_meshrn__de__1_1__zscore_morph.trn10158.trn
SCVE += _conf_eng_num_sym_font40_rbp_data5100_patch500_5x5_24x24_dim727.trn31585.trn
SCVE += _eng_font40_4transmeshrnorm6x6_leaflda85_ligature_ext14_c70_sp1lI_newxml3.trn31299.trn
SCVE += _numpunc_font40_4transmeshrnorm_leafnum1.trn9614.trn
SCVE += _numpunc_font40_conc2_DEFn__BGTouchy6x6n__1_1__morph.trn32025.trn
SCVE += _numpunc_parteng_font40_4transmeshr_morph.trn400.trn
SCVE += character.cost
SCVE += CharType.dat
SCVE += chinese.lm
SCVE += chinese_address_20150304.bin
SCVE += ChinesePunctuation.rst
SCVE += cnn_small5_synthrev_sw_sampled2_bin
SCVE += dcnConfigForEngCNN.txt
SCVE += dcnConfigForMultiCNN.txt
SCVE += english_address_20150213.bin
SCVE += english_dictionary_20150213.bin
SCVE += forestData.bin
SCVE += glvq_kor_2197classes_576_100dim_i42_centroidNorm.dat
SCVE += glvq_kor_consonant_19classes_64_16dim_i0_linearNorm.dat
SCVE += GLVQDecoder_fixed.ohie
SCVE += gModel.dat
SCVE += gModel_system.dat
SCVE += gModel.dat_system
SCVE += hGLVQ_kor_RLF80_float.hie
SCVE += korean.lm
SCVE += korean_address_20150129.bin
SCVE += korean_dictionary_20150414.bin
SCVE += LDA_kor_2197classes_576dim_centroidNorm.dat
SCVE += LDA_kor_consonant_19classes_64dim_linearNorm.dat
SCVE += libhvxMathVIO
SCVE += libhvxMathVIO.so
SCVE += libobjectMattingApp_skel
SCVE += libobjectMattingApp_skel.so
SCVE += libscveBlobDescriptor
SCVE += libscveBlobDescriptor_skel
SCVE += libscveBlobDescriptor_skel.so
SCVE += libscveBlobDescriptor_stub
SCVE += libscveCleverCapture
SCVE += libscveCleverCapture_skel
SCVE += libscveCleverCapture_skel.so
SCVE += libscveCleverCapture_stub
SCVE += libscveCommon
SCVE += libscveCommon_stub
SCVE += libscveFaceLandmark_skel
SCVE += libscveFaceLandmark_skel.so
SCVE += libscveFaceLandmarks
SCVE += libscveFaceLandmarks_stub
SCVE += libscveFaceRecognition
SCVE += libscveFaceRecognition_skel
SCVE += libscveFaceRecognition_skel.so
SCVE += libscveFaceRecognition_stub
SCVE += libscveImageCloning
SCVE += libscveImageCorrection
SCVE += libscveImageRemoval
SCVE += libscveMotionVector
SCVE += libscveObjectMatting
SCVE += libscveObjectMatting_stub
SCVE += libscveObjectSegmentation
SCVE += libscveObjectSegmentation_skel
SCVE += libscveObjectSegmentation_skel.so
SCVE += libscveObjectSegmentation_stub
SCVE += libscveObjectTracker
SCVE += libscveObjectTracker_stub
SCVE += libscvePanorama
SCVE += libscvePanorama_lite
SCVE += libscveScan3D
SCVE += libscveT2T_skel
SCVE += libscveT2T_skel.so
SCVE += libscveTextReco
SCVE += libscveTextReco_skel
SCVE += libscveTextReco_skel.so
SCVE += libscveTextReco_stub
SCVE += libscveTextRecoPostProcessing
SCVE += libscveVideoSummary
SCVE += libscveVideoSummary_skel
SCVE += libscveVideoSummary_skel.so
SCVE += libscveVideoSummary_stub
SCVE += libobjectMattingApp_skel_system
SCVE += libobjectMattingApp_skel_system.so
SCVE += libscveBlobDescriptor_system
SCVE += libscveBlobDescriptor_skel_system
SCVE += libscveBlobDescriptor_skel_system.so
SCVE += libscveBlobDescriptor_stub_system
SCVE += libscveCleverCapture_system
SCVE += libscveCleverCapture_skel_system
SCVE += libscveCleverCapture_skel_system.so
SCVE += libscveCleverCapture_stub_system
SCVE += libscveCommon_system
SCVE += libscveCommon_stub_system
SCVE += libscveFaceLandmark_skel_system
SCVE += libscveFaceLandmark_skel_system.so
SCVE += libscveFaceLandmarks_system
SCVE += libscveFaceLandmarks_stub_system
SCVE += libscveFaceRecognition_system
SCVE += libscveFaceRecognition_skel_system
SCVE += libscveFaceRecognition_skel_system.so
SCVE += libscveFaceRecognition_stub_system
SCVE += libscveImageCloning_system
SCVE += libscveImageCorrection_system
SCVE += libscveImageRemoval_system
SCVE += libscveMotionVector_system
SCVE += libscveObjectMatting_system
SCVE += libscveObjectMatting_stub_system
SCVE += libscveObjectSegmentation_system
SCVE += libscveObjectSegmentation_skel_system
SCVE += libscveObjectSegmentation_skel_system.so
SCVE += libscveObjectSegmentation_stub_system
SCVE += libscveObjectTracker_system
SCVE += libscveObjectTracker_stub_system
SCVE += libscvePanorama_system
SCVE += libscvePanorama_lite_system
SCVE += libscveScan3D_system
SCVE += libhvxMathVIO_system
SCVE += libhvxMathVIO_system.so
SCVE += libscveT2T_skel_system
SCVE += libscveT2T_skel_system.so
SCVE += libscveTextReco_system
SCVE += libscveTextReco_skel_system
SCVE += libscveTextReco_skel_system.so
SCVE += libscveTextReco_stub_system
SCVE += libscveTextRecoPostProcessing_system
SCVE += libscveVideoSummary_system
SCVE += libscveVideoSummary_skel_system
SCVE += libscveVideoSummary_skel_system.so
SCVE += libscveVideoSummary_stub_system
SCVE += nontextremoval_eng.model
SCVE += nontextremoval_multilang.model
SCVE += punRangeData.rst

#SECUREMSM
SECUREMSM :=
SECUREMSM += aostlmd
SECUREMSM += chamomile_provision
SECUREMSM += dbAccess
SECUREMSM += default_qti_regular_37.bin
SECUREMSM += default_qti_regular_43.bin
SECUREMSM += default_qti_regular_90.bin
SECUREMSM += e2image_blocks
SECUREMSM += filefrag_blocks
SECUREMSM += gatekeeper.msm8998
SECUREMSM += keystore.msm8998
SECUREMSM += libChamomilePA
SECUREMSM += libcppf
SECUREMSM += libdrmprplugin
SECUREMSM += libdrmprplugin_customer
SECUREMSM += libFidoCrypto_system
SECUREMSM += libFidoCrypto_vendor
SECUREMSM += libFidoCryptoJNI
SECUREMSM += libFIDOKeyProvisioning
SECUREMSM += libFidoSuiJNI
SECUREMSM += libprdrmdecrypt
SECUREMSM += libprdrmdecrypt_customer
SECUREMSM += libprmediadrmdecrypt
SECUREMSM += libprmediadrmdecrypt_customer
SECUREMSM += libprmediadrmplugin
SECUREMSM += libprmediadrmplugin_customer
SECUREMSM += libdrmfs
SECUREMSM += libdrmMinimalfs
SECUREMSM += libdrmMinimalfsHelper
SECUREMSM += libdrmtime
SECUREMSM += libgoogletest
SECUREMSM += libGPreqcancel
SECUREMSM += libGPreqcancel_svc
SECUREMSM += libGPTEE_system
SECUREMSM += libGPTEE_vendor
SECUREMSM += libtzplayready
SECUREMSM += libbase64
SECUREMSM += libtzplayready_customer
SECUREMSM += libprpk3
SECUREMSM += libprdrmengine
SECUREMSM += libtzdrmgenprov
SECUREMSM += liboemcrypto
SECUREMSM += liboemcrypto.a
SECUREMSM += libQSEEComAPI
SECUREMSM += libQSEEComAPIStatic
SECUREMSM += libMcClient
SECUREMSM += libMcCommon
SECUREMSM += libMcDriverDevice
SECUREMSM += libMcRegistry
SECUREMSM += libmdtp
SECUREMSM += libmdtp_crypto
SECUREMSM += libmdtpdemojni
SECUREMSM += libPaApi
SECUREMSM += libqmp_sphinx_jni
SECUREMSM += libqmp_sphinxlog
SECUREMSM += libqmpart
SECUREMSM += librmp
SECUREMSM += libpvr
SECUREMSM += librpmb
SECUREMSM += librpmbStatic
SECUREMSM += librpmbStaticHelper
SECUREMSM += libSampleAuthJNI
SECUREMSM += libSampleExtAuthJNI
SECUREMSM += libsecotacommon
SECUREMSM += libsecotanservice
SECUREMSM += libSecureSampleAuthJNI
SECUREMSM += libSecureExtAuthJNI
SECUREMSM += lib-sec-disp
SECUREMSM += libsi
SECUREMSM += libsmcinvokecred
SECUREMSM += libspcom
SECUREMSM += libspiris
SECUREMSM += libspl
SECUREMSM += spdaemon
SECUREMSM += sec_nvm
SECUREMSM += libssd
SECUREMSM += libssdStatic
SECUREMSM += libssdStaticHelper
SECUREMSM += libqsappsver
SECUREMSM += libTLV
SECUREMSM += libtzcom
SECUREMSM += libqisl
#SECUREMSM += seccamd
SECUREMSM += mcDriverDaemon
SECUREMSM += qfipsverify
SECUREMSM += qfipsverify.hmac
SECUREMSM += bootimg.hmac
SECUREMSM += libDevHealth
SECUREMSM += libHealthAuthClient
SECUREMSM += libHealthAuthJNI
SECUREMSM += liblmclient
SECUREMSM += HealthAuthService
SECUREMSM += qseecomd
SECUREMSM += SampleAuthenticatorService
SECUREMSM += SampleExtAuthService
SECUREMSM += SecotaAPI
SECUREMSM += secotad
SECUREMSM += SecotaService
SECUREMSM += SecureExtAuthService
SECUREMSM += smcinvoked
SECUREMSM += smcinvokepkgmgr
SECUREMSM += soter_client
SECUREMSM += StoreKeybox
SECUREMSM += sphinxproxy
SECUREMSM += TelemetryService
SECUREMSM += tbaseLoader
SECUREMSM += hdcp1prov
SECUREMSM += libhdcp1prov
SECUREMSM += hdcp2p2prov
SECUREMSM += libhdcp2p2prov
SECUREMSM += tloc_daemon
SECUREMSM += kb_parser
SECUREMSM += libhdcpsrm
SECUREMSM += libcpion

#SENSORS
SENSORS := activity_recognition.msm8998
SENSORS += sensor_def_qcomdev.conf
SENSORS += sensors_settings
SENSORS += libsnsdiaglog
SENSORS += sensors.mata
SENSORS += sensors.qcom
SENSORS += libssc
SENSORS += libsensorslog
SENSORS += libsensor1
SENSORS += libcalmodule_common
SENSORS += calmodule.cfg
SENSORS += sensor_calibrate
SENSORS += android.hardware.sensors@1.0-service
SENSORS += android.hardware.sensors@1.0-impl
SENSORS += libsns_low_lat_stream_stub
SENSORS += libsns_low_lat_stream_skel
SENSORS += libssc_system
SENSORS += libsensorslog_system
SENSORS += libsnsdiaglog_system
SENSORS += sensors_config_module

#SS_RESTART
SS_RESTART := ssr_diag

#SVGT
SVGT := libsvgecmascriptBindings
SVGT += libsvgutils
SVGT += libsvgabstraction
SVGT += libsvgscriptEngBindings
SVGT += libsvgnativeandroid
SVGT += libsvgt
SVGT += libsvgcore

#SWDEC2DTO3D
SW2DTO3D := libswdec_2dto3d

#SYSTEM HEALTH MONITOR
SYSTEM_HEALTH_MONITOR := libsystem_health_mon

#TELEPHONY_APPS
TELEPHONY_APPS := datastatusnotification
TELEPHONY_APPS += QtiTelephonyService
TELEPHONY_APPS += QtiAudioService
TELEPHONY_APPS += telephonyservice.xml
TELEPHONY_APPS += embms
TELEPHONY_APPS += embms.xml
TELEPHONY_APPS += libimscamera_jni
TELEPHONY_APPS += libimsmedia_jni

#TFTP
TFTP := tftp_server

#THERMAL-ENGINE
THERMAL-ENGINE := thermal-engine
THERMAL-ENGINE += libthermalclient
THERMAL-ENGINE += thermal-engine.conf

#TIME_SERVICES
TIME_SERVICES := time_daemon TimeService libTimeService

#TINY xml
TINYXML := libtinyxml

#TINYXML2
TINYXML2 := libtinyxml2

#VERIZON
VERIZON_PREINSTALL := DMService
VERIZON_PREINSTALL += ConnMO
VERIZON_PREINSTALL += VzwOmaTrigger

#VPP
VPP := DE.o.msm8937
VPP += DE.o.msm8953
VPP += DE.o.sdm660
VPP += libhcp_rpc_skel
VPP += libhcp_rpc_skel.so
VPP += libmmsw_detail_enhancement
VPP += libmmsw_math
VPP += libmmsw_opencl
VPP += libmmsw_platform
VPP += libOmxVpp
VPP += libvpplibrary
VPP += libvpphcp
VPP += libvpphvx
VPP += libvpp_frc
VPP += libvpp_frc.so
VPP += libvpp_svc_skel
VPP += libvpp_svc_skel.so
VPP += libvppclient
VPP += vendor.qti.hardware.vpp@1.1

#WFD
WFD := capability.xml
WFD += libwfdmminterface
WFD += libmmwfdsinkinterface
WFD += libmmwfdsrcinterface
WFD += libwfdmmservice
WFD += libwfduibcinterface
WFD += libwfduibcsrcinterface
WFD += libwfduibcsrc
WFD += libOmxMux
WFD += libwfdcommonutils
WFD += libwfdhdcpcp
WFD += libwfdlinkstub
WFD += libwfdmmsrc
WFD += libwfdmmutils
WFD += libwfdnative
WFD += libwfdsm
WFD += libwfdservice
WFD += libwfdrtsp
WFD += libextendedremotedisplay
WFD += libOmxVideoDSMode
WFD += WfdCommon
WFD += WfdService
WFD += wfdconfig.xml
WFD += wfdconfigsink.xml
WFD += WfdP2pCommon
WFD += WfdP2pService
WFD += com.qualcomm.wfd.permissions.xml
WFD += wfdservice
WFD += libqti-wl
WFD += com.qualcomm.qti.wifidisplayhal@1.0-halimpl
WFD += com.qualcomm.qti.wifidisplayhal@1.0
WFD += com.qualcomm.qti.wifidisplayhal@1.0_system
WFD += wifidisplayhalservice
WFD += libwfdhaldsmanager
WFD += libwfdmodulehdcpsession
WFD += libwfdavenhancements
WFD += libwfdcodecv4l2
WFD += libwfdcommonutils_proprietary
WFD += wfdservice.rc
WFD += com.qualcomm.qti.wifidisplayhal@1.0-service.rc
WFD += libwfdconfigutils
WFD += libtinyalsa
WFD += libstagefright_soft_aacenc
WFD += libaacwrapper
WFD += libion
WFD += libdisplayconfig

#WLAN
WLAN := libAniAsf
WLAN += cfg.dat

ifneq ($(BOARD_HAS_ATH_WLAN_AR6320), true)
WLAN += ptt_socket_app
BUILD_PTT_SOCKET_APP:=1
endif
WLAN += qcom_cfg_default.ini
WLAN += qcom_cfg.ini
WLAN += qcom_fw.bin
WLAN += qcom_wapi_fw.bin
WLAN += qcom_wlan_nv.bin
WLAN += WCNSS_cfg.dat
WLAN += WCNSS_qcom_cfg.ini
WLAN += WCNSS_qcom_wlan_nv.bin
WLAN += pktlogconf
WLAN += athdiag
WLAN += cld-fwlog-record
WLAN += cld-fwlog-netlink
WLAN += cld-fwlog-parser
WLAN += cnss-daemon
WLAN += libwifi-hal-qcom
WLAN += libwpa_client
WLAN += libqsap_sdk
WLAN += hal_proxy_daemon
WLAN += e_loop
WLAN += myftm
WLAN += vendor_cmd_tool
WLAN += icm
WLAN += libwpa_drv_oem
WLAN += android.hardware.wifi@1.0-service

#SPRINT
SPRINT_PREINSTALL := MobileInstaller
SPRINT_PREINSTALL += SMF
SPRINT_PREINSTALL += libsmf
REDBEND_PREINSTALL += OMADMDIL
REDBEND_PREINSTALL += libsmm
SPRINT_PREINSTALL += Dialer
SPRINT_OEM := sprint-telephony-common
SPRINT_OEM += sprint-services
SPRINT_OEM += SprintHiddenMenu
SPRINT_OEM += ChameleonProvider
SPRINT_OEM += DataDispatcher
SPRINT_OEM += PhoneDataHandler
SPRINT_OEM += SystemDataHandler
SPRINT_OEM += ChameleonProvider
SPRINT_OEM += com.ts.android.chameleon.chameleonshare
SPRINT_OEM += com.ts.android.chameleon.chameleonshare.xml
SPRINT_OEM += com.ts.android.chameleon.dataservice
SPRINT_OEM += com.ts.android.chameleon.dataservice.xml
SPRINT_OEM += OemTelephonyApp

PRODUCT_PACKAGES += $(ADSPRPC)
PRODUCT_PACKAGES += $(BT)
PRODUCT_PACKAGES += $(CNE)
PRODUCT_PACKAGES += $(DATA)
PRODUCT_PACKAGES += $(DIAG)
PRODUCT_PACKAGES += $(DISPLAY)
PRODUCT_PACKAGES += $(AOSP_GPS)
PRODUCT_PACKAGES += $(GSMA_NFC)
PRODUCT_PACKAGES += $(HBTP)
PRODUCT_PACKAGES += $(HVDCP_OPTI)
PRODUCT_PACKAGES += $(HY11_HY22_diff)

#PRODUCT_PACKAGES += $(IMS_VT)
PRODUCT_PACKAGES += $(IMS_TEL)
PRODUCT_PACKAGES += $(IMS_TEL_RCS)
PRODUCT_PACKAGES += $(IMS_RCS)
PRODUCT_PACKAGES += $(IMS_NEWARCH)
PRODUCT_PACKAGES += $(IMS_REGMGR)
PRODUCT_PACKAGES += $(LATENCY)
PRODUCT_PACKAGES += $(MDM_HELPER)
PRODUCT_PACKAGES += $(MDM_HELPER_PROXY)
PRODUCT_PACKAGES += $(MM_AUDIO)
PRODUCT_PACKAGES += $(MM_CAMERA)
PRODUCT_PACKAGES += $(MM_CORE)
PRODUCT_PACKAGES += $(MM_COLOR_CONVERSION)
PRODUCT_PACKAGES += $(MM_COLOR_CONVERTOR)
PRODUCT_PACKAGES += $(MM_DRMPLAY)
PRODUCT_PACKAGES += $(MM_GESTURES)
PRODUCT_PACKAGES += $(MM_GRAPHICS)
PRODUCT_PACKAGES += $(MM_HTTP)
PRODUCT_PACKAGES += $(MM_STA)
PRODUCT_PACKAGES += $(MM_MUX)
PRODUCT_PACKAGES += $(MM_OSAL)
PRODUCT_PACKAGES += $(MM_PARSER)
PRODUCT_PACKAGES += $(MM_QSM)
PRODUCT_PACKAGES += $(MM_RTP)
PRODUCT_PACKAGES += $(MM_STEREOLIB)
PRODUCT_PACKAGES += $(MM_STILL)
PRODUCT_PACKAGES += $(MM_VIDEO)
PRODUCT_PACKAGES += $(MM_VPU)
PRODUCT_PACKAGES += $(MODEM_APIS)
PRODUCT_PACKAGES += $(MSM_IRQBALANCE)
PRODUCT_PACKAGES += $(PD_LOCATER)
PRODUCT_PACKAGES += $(PERMGR)
PRODUCT_PACKAGES += $(PERF)
PRODUCT_PACKAGES += $(PROFILER)
PRODUCT_PACKAGES += $(QCRIL)
PRODUCT_PACKAGES += $(QMI)
PRODUCT_PACKAGES += $(QOSMGR)
PRODUCT_PACKAGES += $(QVR)
PRODUCT_PACKAGES += $(REMOTEFS)
PRODUCT_PACKAGES += $(RFS_ACCESS)
PRODUCT_PACKAGES += $(RIDL_BINS)
PRODUCT_PACKAGES += $(RNGD)
PRODUCT_PACKAGES += $(SCVE)
PRODUCT_PACKAGES += $(SECUREMSM)
PRODUCT_PACKAGES += $(SENSORS)
PRODUCT_PACKAGES += $(SCS_PROP)
PRODUCT_PACKAGES += $(SS_RESTART)
PRODUCT_PACKAGES += $(SVGT)
PRODUCT_PACKAGES += $(SW2DTO3D)
PRODUCT_PACKAGES += $(SYSTEM_HEALTH_MONITOR)
PRODUCT_PACKAGES += $(TELEPHONY_APPS)
PRODUCT_PACKAGES += $(TFTP)
PRODUCT_PACKAGES += $(THERMAL)
PRODUCT_PACKAGES += $(THERMAL-ENGINE)
PRODUCT_PACKAGES += $(TIME_SERVICES)
PRODUCT_PACKAGES += $(TINYXML)
PRODUCT_PACKAGES += $(TINYXML2)
PRODUCT_PACKAGES += $(VPP)
PRODUCT_PACKAGES += $(WFD)
PRODUCT_PACKAGES += $(WLAN)
PRODUCT_PACKAGES += $(VERIZON_PREINSTALL)
PRODUCT_PACKAGES += $(SPRINT_PREINSTALL)
PRODUCT_PACKAGES += $(SPRINT_OEM)
PRODUCT_PACKAGES += $(REDBEND_PREINSTALL)
