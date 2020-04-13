//
//  FNRemoteFwManager.h
//  Library_FNCamera
//
//  Created by Choco Yang on 2018/2/6.
//  Copyright © 2018年 Choco Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNRemoteFwManager : NSObject

+ (instancetype)shareInstance;

/*  Get the latest firmware information.
    return nil when server request fail.
    return empty dictionary when no firmware information paired.
    ex: {
        "href": "/fw_updates/2",
        "id": 2,
        "fw_profile_id": 1,
        "version": "1.1",
        "description": null,
        "filename": "test_fw.bin",
        "download_url": "https://api.fusionnextinc.com/v3/fw_updates/test_fw.bin",
        "created_at": "2016-08-29 00:00:00",
        "updated_at": "2016-08-29 00:00:00"
    }
 */
- (NSDictionary *)getFwUpdateInfo:(NSString *)manufacturer model:(NSString *)model platform:(NSString *)platform platform_ver:(NSString *)platform_ver;

@end
