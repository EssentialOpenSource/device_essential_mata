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

#ifndef POWER_LIBPERFMGR_CAMERAMODE_H_
#define POWER_LIBPERFMGR_CAMERAMODE_H_

enum CameraStreamingMode {
    CAMERA_STREAMING_OFF = 0,
    CAMERA_STREAMING,
    CAMERA_STREAMING_1080P,
    CAMERA_STREAMING_4K,
    CAMERA_STREAMING_MAX
};

#endif  // POWER_LIBPERFMGR_CAMERAMODE_H_
