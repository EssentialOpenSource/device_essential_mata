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

#define LOG_TAG "VibratorService"

#include <log/log.h>

#include <hardware/hardware.h>
#include <hardware/vibrator.h>
#include <cutils/properties.h>

#include "Vibrator.h"

#include <cinttypes>
#include <cmath>
#include <iostream>
#include <fstream>


namespace android {
namespace hardware {
namespace vibrator {
namespace V1_2 {
namespace implementation {

static constexpr int32_t WAVEFORM_CLICK_EFFECT_MS = 6;

using Status = ::android::hardware::vibrator::V1_0::Status;
using EffectStrength = ::android::hardware::vibrator::V1_0::EffectStrength;

Vibrator::Vibrator(std::ofstream&& activate, std::ofstream&& scale) :
    mActivate(std::move(activate)),
    mScale(std::move(scale)) {}

// Methods from ::android::hardware::vibrator::V1_2::IVibrator follow.
Return<Status> Vibrator::on(uint32_t timeoutMs) {
    mActivate << timeoutMs << std::endl;
    if (!mActivate) {
        ALOGE("Failed to activate (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }

   return Status::OK;
}

Return<Status> Vibrator::off()  {
    mActivate << 0 << std::endl;
    if (!mActivate) {
        ALOGE("Failed to turn vibrator off (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }
    return Status::OK;
}

Return<bool> Vibrator::supportsAmplitudeControl()  {
    return false;
}

Return<Status> Vibrator::setAmplitude(uint8_t /*amplitude*/) {
    return Status::UNSUPPORTED_OPERATION;
}

Return<void> Vibrator::perform(V1_0::Effect effect, EffectStrength strength, perform_cb _hidl_cb) {
    return performEffect(static_cast<Effect>(effect), strength, _hidl_cb);
}

Return<void> Vibrator::perform_1_1(V1_1::Effect_1_1 /*effect*/, EffectStrength /*strength*/,
        perform_cb _hidl_cb) {
     _hidl_cb(Status::UNSUPPORTED_OPERATION, 0);
     return Void();
}

Return<void> Vibrator::perform_1_2(Effect /*effect*/, EffectStrength /*strength*/, perform_cb _hidl_cb) {
     _hidl_cb(Status::UNSUPPORTED_OPERATION, 0);
     return Void();
}

static uint16_t convertEffectStrength(EffectStrength strength) {
    uint16_t scale;

    switch (strength) {
    case EffectStrength::LIGHT:
        scale = 1375; // 50%
        break;
    case EffectStrength::MEDIUM:
        scale = 2062; // 75%
        break;
    case EffectStrength::STRONG:
        scale = 2750;
        break;
    }

    return scale;
}

Return<void> Vibrator::performEffect(Effect effect, EffectStrength strength, perform_cb _hidl_cb) {
    Status status = Status::OK;
    uint32_t timeMS;

    switch (effect) {
    case Effect::CLICK:
        timeMS = WAVEFORM_CLICK_EFFECT_MS;
        break;
    default:
        _hidl_cb(Status::UNSUPPORTED_OPERATION, 0);
        return Void();
    }

    mScale << convertEffectStrength(strength) << std::endl;
    on(timeMS);
    _hidl_cb(status, timeMS);
    return Void();
}


} // namespace implementation
}  // namespace V1_2
}  // namespace vibrator
}  // namespace hardware
}  // namespace android
