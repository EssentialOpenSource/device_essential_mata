/*
 * Copyright (C) 2019 The Android Open Source Project
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

#ifndef POWER_LIBPERFMGR_AUDIOSTREAMING_H_
#define POWER_LIBPERFMGR_AUDIOSTREAMING_H_

enum AUDIO_STREAMING_HINT {
    AUDIO_STREAMING_OFF = 0,
    AUDIO_STREAMING_ON = 1,
    TPU_BOOST_OFF = 1000,
    TPU_BOOST_SHORT = 1001,
    TPU_BOOST_LONG = 1002
};

enum TPU_HINT_DURATION_MS { SHORT = 200, LONG = 2000 };

#endif  // POWER_LIBPERFMGR_AUDIOSTREAMING_H_
