# Build AOSP code

The provided vendor images was tested with 10.0 r39 and r_preview_4

## Getting the sources

### To build latest Android 10 AOSP tag

* Clone the latest AOSP code (For example 10.0.0_r39 tag)

```
repo init -u https://android.googlesource.com/platform/manifest -b android-10.0.0_r39
```

* Add Essential mata repo (master branch)

```
mkdir -p device/essential
cd device/essential
git clone https://github.com/EssentialOpenSource/device_essential_mata.git mata
```


### To build R preview code:

* Clone the latest R AOSP code

```
repo init -u https://android.googlesource.com/platform/manifest -b android-r-preview-4
```

* Apply

https://android.googlesource.com/platform/external/linux-kselftest/+/db3a9fa235b35199b31b6e056c5e853e017554fc
https://android.googlesource.com/platform/external/seccomp-tests/+/f109fb9e5705801c4ab8400df9cc9d68d8132022
https://android.googlesource.com/platform/libcore/+/7afc6fac7c7e8ef9db73ebb63872b9ec93915866
https://android.googlesource.com/platform/libcore/+/0b557ea
https://android.googlesource.com/platform/libcore/+/f42557067242b9a6ea22e63f9caa2b6f90822a4c

* Revert

https://android.googlesource.com/platform/system/sepolicy/+/61178550157fce18861ddd59fa9a6a29cf06c583%5E%21/#F2
https://android.googlesource.com/platform/art/+/198955af0d596dd87d5398d610dd503cf818db86
https://android.googlesource.com/platform/build/soong/+/5b88fe36b5ce34055b28cd904a845bb87709a860

BOARD_SEPOLICY_VERS := 29.0 doesn't build and without it the wrong mapping (1000) is created and 29.0 one
is empty. For now, reverting this patch for the AOSP build (OK with GSI)

The VDEX change is broken on legacy devices (the symlink is boot.vdex rather than ../boot.vdex, so it's a close loop).

* Add Essential mata repo (r-preview branch)

```
mkdir -p device/essential
cd device/essential
git clone https://github.com/EssentialOpenSource/device_essential_mata.git mata -b r-preview
```

## Building

* Download prebuilt [vendor-QQ1A.200105.088.img](https://www.essential.com/developer/current-builds)
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
