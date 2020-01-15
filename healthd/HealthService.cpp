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
#define LOG_TAG "android.hardware.health@2.0-service.mata"
#include <android-base/logging.h>

#include <healthd/healthd.h>
#include <health2/Health.h>
#include <health2/service.h>
#include <hidl/HidlTransportSupport.h>

#include <android-base/file.h>
#include <android-base/strings.h>

#include <vector>
#include <string>

using android::hardware::health::V2_0::StorageInfo;
using android::hardware::health::V2_0::DiskStats;

void healthd_board_init(struct healthd_config*) {
}

int healthd_board_battery_update(struct android::BatteryProperties*) {
    return 1;
}

const char kUFSHealthFile[] = "/sys/kernel/debug/ufshcd0/dump_health_desc";
const char kUFSHealthVersionFile[] = "/sys/kernel/debug/ufshcd0/show_hba";
const char kDiskStatsFile[] = "/sys/block/sda/stat";
const char kUFSName[] = "UFS0";

/*
 * Implementation based on system/core/storaged/storaged_info.cc
 */
void get_storage_info(std::vector<StorageInfo>& vec_storage_info) {
    StorageInfo storage_info = {};
    std::string buffer, version;

    storage_info.attr.isInternal = true;
    storage_info.attr.isBootDevice = true;
    storage_info.attr.name = std::string(kUFSName);

    if (!android::base::ReadFileToString(std::string(kUFSHealthVersionFile), &version)) {
        return;
    }

    std::vector<std::string> lines = android::base::Split(version, "\n");
    if (lines.empty()) {
        return;
    }

    char rev[8];
    if (sscanf(lines[6].c_str(), "hba->ufs_version = 0x%7s\n", rev) < 1) {
        return;
    }

    storage_info.version = "ufs " + std::string(rev);

    if (!android::base::ReadFileToString(std::string(kUFSHealthFile), &buffer)) {
        return;
    }

    lines = android::base::Split(buffer, "\n");
    if (lines.empty()) {
        return;
    }

    for (size_t i = 1; i < lines.size(); i++) {
        char token[32];
        uint16_t val;
        int ret;
        if ((ret = sscanf(lines[i].c_str(),
                   "Health Descriptor[Byte offset 0x%*d]: %31s = 0x%hx",
                   token, &val)) < 2) {
            continue;
        }

        if (std::string(token) == "bPreEOLInfo") {
            storage_info.eol = val;
        } else if (std::string(token) == "bDeviceLifeTimeEstA") {
            storage_info.lifetimeA = val;
        } else if (std::string(token) == "bDeviceLifeTimeEstB") {
            storage_info.lifetimeB = val;
        }
    }

    vec_storage_info.resize(1);
    vec_storage_info[0] = storage_info;
    return;
}

/*
 * Implementation based on parse_disk_stats() in system/core/storaged_diskstats.cpp
 */
void get_disk_stats(std::vector<DiskStats>& vec_stats) {
    const size_t kDiskStatsSize = 11;
    struct DiskStats stats = {};

    stats.attr.isInternal = true;
    stats.attr.isBootDevice = true;
    stats.attr.name = std::string(kUFSName);


    std::string buffer;
    if (!android::base::ReadFileToString(std::string(kDiskStatsFile), &buffer)) {
        LOG(ERROR) << kDiskStatsFile << ": ReadFileToString failed.";
        return;
    }

    // Regular diskstats entries
    std::stringstream ss(buffer);
    for (uint i = 0; i < kDiskStatsSize; ++i) {
        ss >> *(reinterpret_cast<uint64_t*>(&stats) + i);
    }
    vec_stats.resize(1);
    vec_stats[0] = stats;

    return;
}

int main(void) {
    return health_service_main();
}
