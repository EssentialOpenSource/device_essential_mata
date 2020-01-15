/*
 * Copyright 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "dumpstate"

#include "DumpstateDevice.h"

#include <android-base/properties.h>
#include <android-base/unique_fd.h>
#include <cutils/properties.h>
#include <libgen.h>
#include <log/log.h>
#include <stdlib.h>
#include <string>
#include <termios.h>

#include "DumpstateUtil.h"
#include "DumpstateInternal.h"

using android::os::dumpstate::CommandOptions;
using android::os::dumpstate::DumpFileToFd;
using android::os::dumpstate::PropertiesHelper;
using android::os::dumpstate::RunCommandToFd;

namespace android {
namespace hardware {
namespace dumpstate {
namespace V1_0 {
namespace implementation {


#define COMMAND_DEV "/dev/ttyACM0"
#define ATTACHED_FILE "/sys/class/sidecar/attached"
#define POWER_CONTROL_FILE "/sys/class/sidecar/power_control"

void DumpstateDevice::dumpAccessory(int fdFile) {
    char buffer[5];
    ssize_t amt;
    std::string cmd = "bugreport";
    bool isPowerSet = false;
    /* If attached, power the accessory */
    int fd = open(ATTACHED_FILE, O_RDONLY);
    if (fd >= 0) {
        memset(buffer,0,5);
        amt = read(fd, buffer, sizeof(buffer));
        close(fd);
        if (atoi(buffer) == 1) {
            fd = open(POWER_CONTROL_FILE, O_RDWR);
            if (fd >= 0) {
                memset(buffer,0,5);
                amt = read(fd, buffer, sizeof(buffer));
                if (atoi(buffer) == 0) {
                    memset(buffer,0,5);
                    int bytes = sprintf(buffer, "1\n");
                    amt = write(fd, buffer, (size_t)bytes);
                    close(fd);
                    isPowerSet = true;
                    /* Sleep to allow the accessory to boot properly */
                     RunCommandToFd(fdFile, "", {"sleep", "10"});
                }
            } else {
                ALOGI("Cannot open POWER CONTROL - %d", fd);
            }
        } else
            return;
    }
    /* Open command channel */
    struct termios cnf;
    fd = open(COMMAND_DEV, O_RDWR | O_NOCTTY);

    if (fd < 0) {
        ALOGE(" No accessory currently connected\n");
        return;
    }

    tcgetattr(fd, &cnf);
    cfmakeraw(&cnf);
    cnf.c_lflag |= ICANON;
    cnf.c_cc[VEOF] = 0xff;
    tcsetattr(fd, TCSANOW, &cnf);

    int len;
    ssize_t len_written;
    char byte;
    int ret = 0;

    len = strlen(cmd.c_str()) + 1;

    len_written = write(fd, cmd.c_str(), len);

    if (len_written != len) {
        ALOGE("!!!! Sending the request failed\n");
        close(fd);
        return;
    }

    DumpFileFromFdToFd("Accessory", COMMAND_DEV, fd, fdFile, PropertiesHelper::IsDryRun());
    close(fd);
    if (isPowerSet) {
        /* Turn off the power after use */
        fd = open(POWER_CONTROL_FILE, O_RDWR);
        if (fd >= 0) {
            memset(buffer,0,5);
            int bytes = sprintf(buffer, "0\n");
            amt = write(fd, buffer, (size_t)bytes);
            close(fd);
        } else {
            ALOGI("Cannot open POWER CONTROL - %d", fd);
        }
    }
}


// Methods from ::android::hardware::dumpstate::V1_0::IDumpstateDevice follow.
Return<void> DumpstateDevice::dumpstateBoard(const hidl_handle& handle) {
    if (handle == nullptr || handle->numFds < 1) {
        ALOGE("no FDs\n");
        return Void();
    }

    int fd = handle->data[0];
    if (fd < 0) {
        ALOGE("invalid FD: %d\n", handle->data[0]);
        return Void();
    }

    DumpFileToFd(fd, "CPU present", "/sys/devices/system/cpu/present");
    DumpFileToFd(fd, "CPU online", "/sys/devices/system/cpu/online");
    DumpFileToFd(fd, "INTERRUPTS", "/proc/interrupts");

    DumpFileToFd(fd, "RPM Stats", "/d/rpm_stats");
    DumpFileToFd(fd, "Power Management Stats", "/d/rpm_master_stats");
    DumpFileToFd(fd, "CNSS Pre-Alloc", "/d/cnss-prealloc/status");

    DumpFileToFd(fd, "SMD Log", "/d/ipc_logging/smd/log");
    DumpFileToFd(fd, "BT Logs", "/d/ipc_logging/c171000.uart_pwr/log");
    RunCommandToFd(fd, "ION HEAPS", {"/vendor/bin/sh", "-c", "for d in $(ls -d /d/ion/*); do for f in $(ls $d); do echo --- $d/$f; cat $d/$f; done; done"});
    RunCommandToFd(fd, "Temperatures", {"/vendor/bin/sh", "-c", "for f in `ls /sys/class/thermal` ; do type=`cat /sys/class/thermal/$f/type` ; temp=`cat /sys/class/thermal/$f/temp` ; echo \"$type: $temp\" ; done"});
    DumpFileToFd(fd, "cpu0-3 time-in-state", "/sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state");
    RunCommandToFd(fd, "cpu0-3 cpuidle", {"/vendor/bin/sh", "-c", "for d in $(ls -d /sys/devices/system/cpu/cpu0/cpuidle/state*); do echo \"$d: `cat $d/name` `cat $d/desc` `cat $d/time` `cat $d/usage`\"; done"});
    DumpFileToFd(fd, "cpu4-8 time-in-state", "/sys/devices/system/cpu/cpu4/cpufreq/stats/time_in_state");
    RunCommandToFd(fd, "cpu4-8 cpuidle", {"/vendor/bin/sh", "-c", "for d in $(ls -d /sys/devices/system/cpu/cpu4/cpuidle/state*); do echo \"$d: `cat $d/name` `cat $d/desc` `cat $d/time` `cat $d/usage`\"; done"});

    dumpAccessory(fd);

    return Void();
};

}  // namespace implementation
}  // namespace V1_0
}  // namespace dumpstate
}  // namespace hardware
}  // namespace android
