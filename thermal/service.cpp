/*
 * Copyright (C) 2017 The Android Open Source Project
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

#include <android-base/logging.h>
#include <hidl/HidlTransportSupport.h>
#include "Thermal.h"

using android::sp;
using android::status_t;
using android::OK;

// libhwbinder:
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;

// Generated HIDL files
using android::hardware::thermal::V1_0::IThermal;
using android::hardware::thermal::V1_0::implementation::Thermal;

int main() {

    status_t status;
    android::sp<IThermal> service = nullptr;

    LOG(INFO) << "Thermal HAL Service 1.0 is starting";

    service = new Thermal();
    if (service == nullptr) {
        LOG(ERROR) << "Can not create an instance of Thermal HAL Iface, exiting";

        goto shutdown;
    }

    configureRpcThreadpool(1, true /*callerWillJoin*/);

    status = service->registerAsService();
    if (status != OK) {
        LOG(ERROR) << "Could not register service for Thermal HAL Iface (" << status << ")";
        goto shutdown;
    }

    LOG(INFO) << "Thermal Service is ready";
    joinRpcThreadpool();
    // Should not pass this line

shutdown:
    // In normal operation, we don't expect the thread pool to exit
    LOG(ERROR) << "Thermal Service is shutting down";
    return 1;
}
