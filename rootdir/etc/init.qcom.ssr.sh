#! /vendor/bin/sh

# Copyright (c) 2013, The Linux Foundation. All rights reserved.
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

ssr_str="$1"
IFS=,
ssr_array=($ssr_str)
declare -i subsys_mask=0

# check user input subsystem with system device
ssr_check_subsystem_name()
{
    declare -i i=0
    subsys=`cat /sys/bus/msm_subsys/devices/subsys$i/name`
    while [ "$subsys" != "" ]
    do
        if [ "$subsys" == "$ssr_name" ]; then
            return 1
        fi
        i=$i+1
        subsys=`cat /sys/bus/msm_subsys/devices/subsys$i/name`
    done
    return 0
}

# set subsystem mask to indicate which subsystem needs to be enabled
for num in "${!ssr_array[@]}"
do
    case "${ssr_array[$num]}" in
        "1")
            subsys_mask=0
        ;;
        "riva")
            subsys_mask=$subsys_mask+1
        ;;
        "3")
            subsys_mask=63
        ;;
        "adsp")
            ssr_name=adsp
            if ( ssr_check_subsystem_name ); then
                subsys_mask=$subsys_mask+2
            fi
        ;;
        "modem")
            ssr_name=modem
            if ( ssr_check_subsystem_name ); then
                subsys_mask=$subsys_mask+4
            fi
        ;;
        "wcnss")
            ssr_name=wcnss
            if ( ssr_check_subsystem_name ); then
                subsys_mask=$subsys_mask+8
            fi
        ;;
        "venus")
            ssr_name=venus
            if ( ssr_check_subsystem_name ); then
                subsys_mask=$subsys_mask+16
            fi
        ;;
        "external_modem")
            ssr_name=external_modem
            if ( ssr_check_subsystem_name ); then
                subsys_mask=$subsys_mask+32
            fi
        ;;
    esac
done

# enable selected subsystem restart
if [ $((subsys_mask & 1)) == 1 ]; then
    echo 1 > /sys/module/wcnss_ssr_8960/parameters/enable_riva_ssr
else
    echo 0 > /sys/module/wcnss_ssr_8960/parameters/enable_riva_ssr
fi

if [ $((subsys_mask & 2)) == 2 ]; then
    echo "related" > /sys/bus/msm_subsys/devices/subsys0/restart_level
else
    echo "system" > /sys/bus/msm_subsys/devices/subsys0/restart_level
fi

if [ $((subsys_mask & 4)) == 4 ]; then
    echo "related" > /sys/bus/msm_subsys/devices/subsys1/restart_level
else
    echo "system" > /sys/bus/msm_subsys/devices/subsys1/restart_level
fi

if [ $((subsys_mask & 8)) == 8 ]; then
    echo "related" > /sys/bus/msm_subsys/devices/subsys2/restart_level
else
    echo "system" > /sys/bus/msm_subsys/devices/subsys2/restart_level
fi

if [ $((subsys_mask & 16)) == 16 ]; then
    echo "related" > /sys/bus/msm_subsys/devices/subsys3/restart_level
else
    echo "system" > /sys/bus/msm_subsys/devices/subsys3/restart_level
fi

if [ $((subsys_mask & 32)) == 32 ]; then
    echo "related" > /sys/bus/msm_subsys/devices/subsys4/restart_level
else
    echo "system" > /sys/bus/msm_subsys/devices/subsys4/restart_level
fi

if [ $((subsys_mask & 63)) == 63 ]; then
    echo 3 > /sys/module/subsystem_restart/parameters/restart_level
else
    echo 1 > /sys/module/subsystem_restart/parameters/restart_level
fi
