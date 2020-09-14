# Build AOSP code

The provided vendor images was tested with 11.0.0_r3

## Getting the sources

### To build latest Android 11 AOSP tag

* Clone the latest AOSP code (For example android-11.0.0_r3 tag)

```
repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r3
```

* Add Essential mata repo (master branch)

```
mkdir -p device/essential
cd device/essential
git clone https://github.com/EssentialOpenSource/device_essential_mata.git mata
```
* Revert

https://android.googlesource.com/platform/system/sepolicy/+/61178550157fce18861ddd59fa9a6a29cf06c583%5E%21/#F2

BOARD_SEPOLICY_VERS := 29.0 doesn't build and without it the wrong mapping (1000) is created and 29.0 one
is empty. For now, reverting this patch for the AOSP build (OK with GSI)


## Building

* Download prebuilt [vendor-QQ1A.200105.088.img](https://storage.googleapis.com/essential-static/vendor-QQ1A.200105.088.zip)
* Extract in device/essential/mata
* Start a build

```
source build/envsetup.sh
lunch mata-userdebug
make -j16
```

* Flash boot, system and vendor (unlock device only)

# To flash GSI

* Get the latest [GSI for Android 11/Android 10](https://developer.android.com/topic/generic-system-image/releases)
* Tested with QJR1.191112.001 and RPP1.200123.016.A1
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
