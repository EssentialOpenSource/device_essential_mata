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

#define LOG_TAG "android.hardware.power@1.3-service.mata-libperfmgr"

#include <android/log.h>
#include <hidl/HidlTransportSupport.h>

#include "Power.h"

using android::OK;
using android::sp;
using android::status_t;

// libhwbinder:
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;

// Generated HIDL files
using android::hardware::power::V1_3::IPower;
using android::hardware::power::V1_3::implementation::Power;

int main(int /* argc */, char ** /* argv */) {
    ALOGI("Power HAL Service 1.3 for Mata is starting.");

    android::sp<IPower> service = new Power();
    if (service == nullptr) {
        ALOGE("Can not create an instance of Power HAL Iface, exiting.");
        return 1;
    }

    configureRpcThreadpool(1, true /*callerWillJoin*/);

    status_t status = service->registerAsService();
    if (status != OK) {
        ALOGE("Could not register service for Power HAL Iface (%d), exiting.", status);
        return 1;
    }

    ALOGI("Power Service is ready");
    joinRpcThreadpool();

    // In normal operation, we don't expect the thread pool to exit
    ALOGE("Power Service is shutting down");
    return 1;
}
