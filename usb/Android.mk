LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE := android.hardware.usb@1.0-service.mata
LOCAL_INIT_RC := android.hardware.usb@1.0-service.mata.rc
LOCAL_SRC_FILES := \
    service.cpp \
    Usb.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libhidlbase \
    libhidltransport \
    liblog \
    libutils \
    libhardware \
    android.hardware.usb@1.0 \

include $(BUILD_EXECUTABLE)
