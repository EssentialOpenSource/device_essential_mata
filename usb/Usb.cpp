/*
 * Copyright (C) 2016 The Android Open Source Project
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
#include <assert.h>
#include <dirent.h>
#include <iostream>
#include <fstream>
#include <pthread.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

#include <cutils/uevent.h>
#include <sys/epoll.h>
#include <utils/Errors.h>
#include <utils/StrongPointer.h>

#include "Usb.h"

namespace android {
namespace hardware {
namespace usb {
namespace V1_0 {
namespace implementation {

// Set by the signal handler to destroy the thread
volatile bool destroyThread;

int32_t readFile(std::string filename, std::string& contents) {
    std::ifstream file(filename);

    if (file.is_open()) {
        getline(file, contents);
        file.close();
        return 0;
    }
    return -1;
}

std::string appendRoleNodeHelper(const std::string portName, PortRoleType type) {
    std::string node("/sys/class/dual_role_usb/" + portName);

    switch(type) {
        case PortRoleType::DATA_ROLE:
            return node + "/data_role";
        case PortRoleType::POWER_ROLE:
            return node + "/power_role";
        default:
            return node + "/mode";
    }
}

std::string convertRoletoString(PortRole role) {
    if (role.type == PortRoleType::POWER_ROLE) {
        if (role.role == static_cast<uint32_t> (PortPowerRole::SOURCE))
            return "source";
        else if (role.role ==  static_cast<uint32_t> (PortPowerRole::SINK))
            return "sink";
    } else if (role.type == PortRoleType::DATA_ROLE) {
        if (role.role == static_cast<uint32_t> (PortDataRole::HOST))
            return "host";
        if (role.role == static_cast<uint32_t> (PortDataRole::DEVICE))
            return "device";
    } else if (role.type == PortRoleType::MODE) {
        if (role.role == static_cast<uint32_t> (PortMode::UFP))
            return "ufp";
        if (role.role == static_cast<uint32_t> (PortMode::DFP))
            return "dfp";
    }
    return "none";
}

Return<void> Usb::switchRole(const hidl_string& portName,
        const PortRole& newRole) {
    std::string filename = appendRoleNodeHelper(std::string(portName.c_str()),
        newRole.type);
    std::ofstream file(filename);
    std::string written;

    ALOGI("filename write: %s role:%d", filename.c_str(), newRole.role);

    if (file.is_open()) {
        file << convertRoletoString(newRole).c_str();
        file.close();
        if (!readFile(filename, written)) {
            ALOGI("written: %s", written.c_str());
            if (written == convertRoletoString(newRole)) {
                ALOGI("Role switch successfull");
                Return<void> ret =
                    mCallback->notifyRoleSwitchStatus(portName, newRole,
                    Status::SUCCESS);
                if (!ret.isOk())
                    ALOGE("RoleSwitchStatus error %s",
                        ret.description().c_str());
            }
        }
    }

    Return<void> ret = mCallback->notifyRoleSwitchStatus(portName, newRole, Status::ERROR);
    if (!ret.isOk())
        ALOGE("RoleSwitchStatus error %s", ret.description().c_str());

    return Void();
}

Status getCurrentRoleHelper(std::string portName,
        PortRoleType type, uint32_t &currentRole)  {
    std::string filename;
    std::string roleName;

    if (type == PortRoleType::POWER_ROLE) {
        filename = "/sys/class/dual_role_usb/" +
            portName + "/power_role";
        currentRole = static_cast<uint32_t>(PortPowerRole::NONE);
    } else if (type == PortRoleType::DATA_ROLE) {
        filename = "/sys/class/dual_role_usb/" +
            portName + "/data_role";
        currentRole = static_cast<uint32_t> (PortDataRole::NONE);
    } else if (type == PortRoleType::MODE) {
        filename = "/sys/class/dual_role_usb/" +
            portName + "/mode";
        currentRole = static_cast<uint32_t> (PortMode::NONE);
    }

    if (readFile(filename, roleName)) {
        ALOGE("getCurrentRole: Failed to open filesystem node");
        return Status::ERROR;
    }

    if (roleName == "dfp")
        currentRole = static_cast<uint32_t> (PortMode::DFP);
    else if (roleName == "ufp")
        currentRole = static_cast<uint32_t> (PortMode::UFP);
    else if (roleName == "source")
        currentRole = static_cast<uint32_t> (PortPowerRole::SOURCE);
    else if (roleName == "sink")
        currentRole = static_cast<uint32_t> (PortPowerRole::SINK);
    else if (roleName == "host")
        currentRole = static_cast<uint32_t> (PortDataRole::HOST);
    else if (roleName == "device")
        currentRole = static_cast<uint32_t> (PortDataRole::DEVICE);
    else if (roleName != "none") {
         /* case for none has already been addressed.
          * so we check if the role isnt none.
          */
        return Status::UNRECOGNIZED_ROLE;
    }
    return Status::SUCCESS;
}

Status getTypeCPortNamesHelper(std::vector<std::string>& names) {
    DIR *dp;

    dp = opendir("/sys/class/dual_role_usb");
    if (dp != NULL)
    {
rescan:
        int32_t ports = 0;
        int32_t current = 0;
        struct dirent *ep;

        while ((ep = readdir (dp))) {
            if (ep->d_type == DT_LNK) {
                ports++;
            }
        }

        if (ports == 0) {
            closedir(dp);
            return Status::SUCCESS;
        }

        names.resize(ports);
        rewinddir(dp);

        while ((ep = readdir (dp))) {
            if (ep->d_type == DT_LNK) {
                /* Check to see if new ports were added since the first pass. */
                if (current >= ports) {
                    rewinddir(dp);
                    goto rescan;
                }
                names[current++] = ep->d_name;
            }
        }

        closedir (dp);
        return Status::SUCCESS;
    }

    ALOGE("Failed to open /sys/class/dual_role_usb");
    return Status::ERROR;
}

bool canSwitchRoleHelper(const std::string portName, PortRoleType type)  {
    std::string filename = appendRoleNodeHelper(portName, type);
    std::ofstream file(filename);

    if (file.is_open()) {
        file.close();
        return true;
    }
    return false;
}

Status getPortModeHelper(const std::string portName, PortMode& portMode)  {
    std::string filename = "/sys/class/dual_role_usb/" +
    std::string(portName.c_str()) + "/supported_modes";
    std::string modes;

    if (readFile(filename, modes)) {
        ALOGE("getSupportedRoles: Failed to open filesystem node");
        return Status::ERROR;
    }

    if (modes == "ufp dfp")
        portMode = PortMode::DRP;
    else  if (modes == "ufp")
        portMode = PortMode::UFP;
    else if  (modes == "dfp")
        portMode = PortMode::DFP;
    else
        return Status::UNRECOGNIZED_ROLE;

        return Status::SUCCESS;
}

#define MAX_LOOP 300

Status getPortStatusHelper (hidl_vec<PortStatus>& currentPortStatus) {
    std::vector<std::string> names;
    Status result = getTypeCPortNamesHelper(names);
    int j = 0;

    if (result == Status::SUCCESS) {
        currentPortStatus.resize(names.size());
        for(std::vector<std::string>::size_type i = 0; i < names.size(); i++) {
            while (j < MAX_LOOP) {
                currentPortStatus[i].portName = names[i];

                uint32_t currentRole;
                if (getCurrentRoleHelper(names[i], PortRoleType::POWER_ROLE,
                        currentRole) == Status::SUCCESS) {
                    currentPortStatus[i].currentPowerRole =
                    static_cast<PortPowerRole> (currentRole);
                } else {
                    ALOGE("Error while retreiving portNames");
                    goto done;
                }

                if (getCurrentRoleHelper(names[i],
                        PortRoleType::DATA_ROLE, currentRole) == Status::SUCCESS) {
                    currentPortStatus[i].currentDataRole =
                            static_cast<PortDataRole> (currentRole);
                } else {
                    ALOGE("Error while retreiving current port role");
                    goto done;
                }

                if (getCurrentRoleHelper(names[i], PortRoleType::MODE,
                        currentRole) == Status::SUCCESS) {
                    currentPortStatus[i].currentMode =
                        static_cast<PortMode> (currentRole);
                } else {
                    ALOGE("Error while retreiving current data role");
                    goto done;
                }

                currentPortStatus[i].canChangeMode =
                    canSwitchRoleHelper(names[i], PortRoleType::MODE);
                currentPortStatus[i].canChangeDataRole =
                    canSwitchRoleHelper(names[i], PortRoleType::DATA_ROLE);
                currentPortStatus[i].canChangePowerRole =
                    canSwitchRoleHelper(names[i], PortRoleType::POWER_ROLE);

                if (getPortModeHelper(names[i], currentPortStatus[i].supportedModes)
                      != Status::SUCCESS) {
                    ALOGE("Error while retrieving port modes");
                    goto done;
                }
                /* Exit when a status is properly detected */
                if (currentPortStatus[i].canChangeMode || currentPortStatus[i].canChangeDataRole || currentPortStatus[i].canChangePowerRole) {
                    ALOGI("canChangeMode: %d canChagedata: %d canChangePower:%d",
                       currentPortStatus[i].canChangeMode,
                       currentPortStatus[i].canChangeDataRole,
                       currentPortStatus[i].canChangePowerRole);
                    break;
                }
                j++;
            }
            if (j == MAX_LOOP) {
                ALOGI("Fail: canChangeMode: %d canChagedata: %d canChangePower:%d",
                       currentPortStatus[i].canChangeMode,
                       currentPortStatus[i].canChangeDataRole,
                       currentPortStatus[i].canChangePowerRole);
            }
        }
        return Status::SUCCESS;
    }
done:
    return Status::ERROR;
}

Return<void> Usb::queryPortStatus() {
    hidl_vec<PortStatus> currentPortStatus;
    Status status;

    status = getPortStatusHelper(currentPortStatus);
    Return<void> ret = mCallback->notifyPortStatusChange(currentPortStatus,
       status);
    if (!ret.isOk())
        ALOGE("queryPortStatus error %s", ret.description().c_str());

    return Void();
}
struct data {
    int uevent_fd;
    android::hardware::usb::V1_0::implementation::Usb *usb;
};

static void uevent_event(uint32_t /*epevents*/, struct data *payload) {
    char msg[UEVENT_MSG_LEN + 2];
    char *cp;
    int n;

    n = uevent_kernel_multicast_recv(payload->uevent_fd, msg, UEVENT_MSG_LEN);
    if (n <= 0)
        return;
    if (n >= UEVENT_MSG_LEN)   /* overflow -- discard */
        return;

    msg[n] = '\0';
    msg[n + 1] = '\0';
    cp = msg;

    while (*cp) {
        if (!strcmp(cp, "SUBSYSTEM=dual_role_usb")) {
            ALOGE("uevent received %s", cp);
            if (payload->usb->mCallback != NULL) {
                hidl_vec<PortStatus> currentPortStatus;
                Status status = getPortStatusHelper(currentPortStatus);
                Return<void> ret =
                    payload->usb->mCallback->notifyPortStatusChange(currentPortStatus, status);
                if (!ret.isOk())
                    ALOGE("error %s", ret.description().c_str());
            }
            break;
        }
        /* advance to after the next \0 */
        while (*cp++);
    }
}

void* work(void* param) {
    int epoll_fd, uevent_fd;
    struct epoll_event ev;
    int nevents = 0;
    struct data payload;

    ALOGE("creating thread");

    uevent_fd = uevent_open_socket(64*1024, true);

    if (uevent_fd < 0) {
        ALOGE("uevent_init: uevent_open_socket failed\n");
        return NULL;
    }

    payload.uevent_fd = uevent_fd;
    payload.usb = (android::hardware::usb::V1_0::implementation::Usb *)param;

    fcntl(uevent_fd, F_SETFL, O_NONBLOCK);

    ev.events = EPOLLIN;
    ev.data.ptr = (void *)uevent_event;

    epoll_fd = epoll_create(64);
    if (epoll_fd == -1) {
        ALOGE("epoll_create failed; errno=%d", errno);
        goto error;
    }

    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, uevent_fd, &ev) == -1) {
        ALOGE("epoll_ctl failed; errno=%d", errno);
        goto error;
    }

    while (!destroyThread) {
        struct epoll_event events[64];

        nevents = epoll_wait(epoll_fd, events, 64, -1);
        if (nevents == -1) {
            if (errno == EINTR)
                continue;
            ALOGE("usb epoll_wait failed; errno=%d", errno);
            break;
        }

        for (int n = 0; n < nevents; ++n) {
            if (events[n].data.ptr)
                (*(void (*)(int, struct data *payload))events[n].data.ptr)
                    (events[n].events, &payload);
        }
    }

    ALOGI("exiting worker thread");
error:
    close(uevent_fd);

    if (epoll_fd >= 0)
        close(epoll_fd);

    return NULL;
}

void sighandler(int sig)
{
    if (sig == SIGUSR1) {
        destroyThread = true;
        ALOGI("destroy set");
        return;
    }
    signal(SIGUSR1, sighandler);
}

Return<void> Usb::setCallback(const sp<IUsbCallback>& callback) {

    pthread_mutex_lock(&mLock);
    if ((mCallback == NULL && callback == NULL) ||
            (mCallback != NULL && callback != NULL)) {
        mCallback = callback;
        pthread_mutex_unlock(&mLock);
        return Void();
    }

    mCallback = callback;
    ALOGI("registering callback");

    if (mCallback == NULL) {
        if  (!pthread_kill(mPoll, SIGUSR1)) {
            pthread_join(mPoll, NULL);
            ALOGI("pthread destroyed");
        }
        pthread_mutex_unlock(&mLock);
        return Void();
    }

    destroyThread = false;
    signal(SIGUSR1, sighandler);

    if (pthread_create(&mPoll, NULL, work, this)) {
        ALOGE("pthread creation failed %d", errno);
        mCallback = NULL;
    }
    pthread_mutex_unlock(&mLock);
    return Void();
}

// Protects *usb assignment
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
Usb *usb;

Usb::Usb() {
    pthread_mutex_lock(&lock);
    // Make this a singleton class
    assert(usb == NULL);
    usb = this;
    pthread_mutex_unlock(&lock);
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace usb
}  // namespace hardware
}  // namespace android
