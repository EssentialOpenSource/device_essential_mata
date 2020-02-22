#! /vendor/bin/sh

#
# Copy qcril.db if needed for RIL
#
if [ -f /vendor/radio/qcril_database/qcril.db -a ! -f /data/vendor/radio/qcril.db ]; then
     cp /vendor/radio/qcril_database/qcril.db /data/vendor/radio/qcril.db
     chown -h radio.radio /data/vendor/radio/qcril.db
fi
echo 1 > /data/vendor/radio/db_check_done

#
# Make modem config folder and copy firmware config to that folder for RIL
#
if [ -f /data/vendor/radio/ver_info.txt ]; then
    prev_version_info=`cat /data/vendor/radio/ver_info.txt`
else
    prev_version_info=""
fi

cur_version_info=`cat /vendor/firmware_mnt/verinfo/ver_info.txt`
if [ ! -f /vendor/firmware_mnt/verinfo/ver_info.txt -o "$prev_version_info" != "$cur_version_info" ]; then
    rm -rf /data/vendor/radio/modem_config
    mkdir /data/vendor/radio/modem_config
    chmod 770 /data/vendor/radio/modem_config
    cp -r /vendor/firmware_mnt/image/modem_pr/mcfg/configs/* /data/vendor/radio/modem_config
    chown -hR radio.radio /data/vendor/radio/modem_config
    cp /vendor/firmware_mnt/verinfo/ver_info.txt /data/vendor/radio/ver_info.txt
    chown radio.radio /data/vendor/radio/ver_info.txt
fi
cp /vendor/firmware_mnt/image/modem_pr/mbn_ota.txt /data/vendor/radio/modem_config
chown radio.radio /data/vendor/radio/modem_config/mbn_ota.txt
echo 1 > /data/vendor/radio/copy_complete
