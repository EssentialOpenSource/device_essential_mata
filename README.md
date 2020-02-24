# To build R preview code:

* Clone the latest R AOSP code

```
repo init -u https://android.googlesource.com/platform/manifest -b android-r-preview-1
```

* Apply

https://android-review.googlesource.com/c/platform/external/e2fsprogs/+/1216916
https://android.googlesource.com/platform/libcore/+/0a5160d04a3f
https://android.googlesource.com/platform/libcore/+/d8a6e4823995e64a9e21c0ad9289d9d530f18034
https://android.googlesource.com/platform/libcore/+/c6298a8b77942aa1108548bd70e97059dc9d7b6e

* Revert

https://android.googlesource.com/platform/system/sepolicy/+/61178550157fce18861ddd59fa9a6a29cf06c583%5E%21/#F2

Otherwise lead to init issue due to empty mapping files (To be checked)

* Add Essential mata repo

```
mkdir -p device/essential
cd device/essential
git clone https://github.com/EssentialOpenSource/device_essential_mata.git mata -b r-preview
```

* Download prebuilt vendor-QQ1A.200105.086.img (To be provided)

```
source build/envsetup.sh
lunch mata-userdebug
make -j16
```

* Flash boot, system and vendor (unlock device only)

# To flash GSI

* Get the latest [GSI for Android 11](https://developer.android.com/topic/generic-system-image/releases)
* Flash the userdebug open source build (see above)
* Disable verity (GSI image don't have any verity metadata)

```
adb root
adb disable-verity
```

* Flash GSI system image

```
fastboot flash system_a system.img
```

* Erase userdata

```
fastboot format userdata
```

* Reboot

## Known issues with GSI

1. Cellular data doesn't work

datastatusnotification needs to share the APN status with the modem.
This requires privileged/signature (WRITE_APN_SETTINGS) permission that cannot be
granted for GSI.
