/*
 * Copyright (C) 2018 The Android Open Source Project
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

#define LOG_NIDEBUG 0
#define LOG_TAG "android.hardware.power@1.3-service.mata-libperfmgr"

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <cutils/sockets.h>
#include <log/log.h>

#include "display-helper.h"

#define DAEMON_SOCKET "pps"

static int daemon_socket = -1;

static int connectPPDaemon() {
    // Setup socket connection, if not already done.
    if (daemon_socket < 0)
        daemon_socket =
                socket_local_client(DAEMON_SOCKET, ANDROID_SOCKET_NAMESPACE_RESERVED, SOCK_STREAM);

    if (daemon_socket < 0) {
        ALOGE("Connecting to socket failed: %s", strerror(errno));
        return -1;
    }
    return 0;
}

static int ppdComm(const char *cmd) {
    int ret = -1;

    ret = connectPPDaemon();
    if (ret < 0)
        return ret;

    ret = write(daemon_socket, cmd, strlen(cmd));
    if (ret < 0) {
        ALOGE("Failed to send data over socket, %s", strerror(errno));
        return ret;
    }
    return 0;
}

void set_display_lpm(int enable) {
    ALOGI("set_display_lpm state: %d", enable);
    if (enable) {
        ppdComm("foss:on");
    } else {
        ppdComm("foss:off");
    }
}
