#! /vendor/bin/sh

# Copyright (c) 2012-2013,2016 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export PATH=/vendor/bin

log -t BOOT -p i "Essential Mata target '$1', SoC '$soc_hwplatform', HwID '$soc_hwid', SoC ver '$soc_hwver'"

#For drm based display driver
vbfile=/sys/module/drm/parameters/vblankoffdelay
if [ -w $vbfile ]; then
    echo -1 >  $vbfile
else
    log -t DRM_BOOT -p w "file: '$vbfile' or perms doesn't exist"
fi

hw_revision=`getprop ro.boot.revision`
setprop ro.hardware.nfc_nci msm8998

# If grip manual is set to 0 (user forced to disable grip), disable it
# Otherwise set it on
grip_manual=`getprop persist.grip.status_manual`
if [ "$grip_manual" == "" ] || [ "$grip_manual" == "1" ]; then
    setprop sys.grip.status on
else
    setprop sys.grip.status off
fi

# Set default smoothness value
smoothness=`getprop persist.touch.smoothness`
if [ "$smoothness" == "" ]; then
    setprop persist.touch.smoothness 5
fi

# Set carrier specific properties as per sku
sku=`getprop ro.boot.carrier.sku`
tags=`getprop ro.build.tags`
if [ "$sku" == "OPENJP" ]; then
    setprop ro.boot.wificountrycode JP
    setprop ro.product.locale ja-JP
elif [ "$sku" == "OPENEU" ]; then
    setprop ro.boot.wificountrycode UK
    setprop ro.product.locale en-UK
fi

if [ "$sku" != "SPRINT" ] && [ "$tags" == "release-keys" ]; then
    setprop ro.boot.diagclean true
fi
# Since an ro.* cannot be set twice, we can just call this directly
setprop ro.product.locale en-US
setprop ro.boot.wificountrycode US

# End of carrier specific properties
# Setup display nodes & permissions
# HDMI can be fb1 or fb2
# Loop through the sysfs nodes and determine
# the HDMI(dtv panel)

function set_perms() {
    #Usage set_perms <filename> <ownership> <permission>
    chown -h $2 $1
    chmod $3 $1
}

function setHDMIPermission() {
   file=/sys/class/graphics/fb$1
   dev_file=/dev/graphics/fb$1
   dev_gfx_hdmi=/devices/virtual/switch/hdmi

   set_perms $file/hpd system.graphics 0664
   set_perms $file/res_info system.graphics 0664
   set_perms $file/vendor_name system.graphics 0664
   set_perms $file/product_description system.graphics 0664
   set_perms $file/video_mode system.graphics 0664
   set_perms $file/format_3d system.graphics 0664
   set_perms $file/s3d_mode system.graphics 0664
   set_perms $file/dynamic_fps system.graphics 0664
   set_perms $file/msm_fb_dfps_mode system.graphics 0664
   set_perms $file/hdr_stream system.graphics 0664
   set_perms $file/cec/enable system.graphics 0664
   set_perms $file/cec/logical_addr system.graphics 0664
   set_perms $file/cec/rd_msg system.graphics 0664
   set_perms $file/pa system.graphics 0664
   set_perms $file/cec/wr_msg system.graphics 0600
   set_perms $file/hdcp/tp system.graphics 0664
   set_perms $file/hdmi_audio_cb audioserver.audio 0600
   ln -s $dev_file $dev_gfx_hdmi
}

# check for the type of driver FB or DRM
fb_driver=/sys/class/graphics/fb0
if [ -e "$fb_driver" ]
then
    # check for HDMI connection
    for fb_cnt in 0 1 2 3
    do
        file=/sys/class/graphics/fb$fb_cnt/msm_fb_panel_info
        if [ -f "$file" ]
        then
          cat $file | while read line; do
            case "$line" in
                *"is_pluggable"*)
                 case "$line" in
                      *"1"*)
                      setHDMIPermission $fb_cnt
                 esac
            esac
          done
        fi
    done

    file=/sys/class/graphics/fb0
    if [ -d "$file" ]
    then
            set_perms $file/idle_time system.graphics 0664
            set_perms $file/dynamic_fps system.graphics 0664
            set_perms $file/dyn_pu system.graphics 0664
            set_perms $file/modes system.graphics 0664
            set_perms $file/mode system.graphics 0664
            set_perms $file/msm_cmd_autorefresh_en system.graphics 0664
    fi

    # set lineptr permissions for all displays
    for fb_cnt in 0 1 2 3
    do
        file=/sys/class/graphics/fb$fb_cnt
        if [ -f "$file/lineptr_value" ]; then
            set_perms $file/lineptr_value system.graphics 0664
        fi
        if [ -f "$file/msm_fb_persist_mode" ]; then
            set_perms $file/msm_fb_persist_mode system.graphics 0664
        fi
    done
fi


