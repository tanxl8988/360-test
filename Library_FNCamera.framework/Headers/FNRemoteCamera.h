//
//  FNRemoteCamera.h
//  Library_FNCamera
//
//  Created by 楊凱丞 on 2015/11/27.
//  Copyright © 2015年 Choco Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNListenerDelegate.h"

static const NSUInteger REMOTECAMERA_DEFAULT_TIMEOUT = NSIntegerMax;

@interface FNRemoteCamera : NSObject

@property (nonatomic, weak) id<FNListenerDelegate> delegate;

+ (void)setIdentifier:(NSString *)identifier;

+ (NSDictionary *)getWifiGatewayInfo;

- (void)setCustomTimeout:(NSUInteger)millis;

- (BOOL)isCommandReady;

- (NSDictionary *)connect:(NSString *)ip isLiveMode:(BOOL)isLiveMode;
- (NSDictionary *)connect:(NSString *)ip isLiveMode:(BOOL)isLiveMode timeout:(NSUInteger)millis;
- (NSDictionary *)connect:(NSString *)ip secret:(NSData *)secret isLiveMode:(BOOL)isLiveMode;
- (NSDictionary *)connect:(NSString *)ip secret:(NSData *)secret isLiveMode:(BOOL)isLiveMode timeout:(NSUInteger)millis;
- (NSDictionary *)disconnect;
- (NSDictionary *)disconnect:(NSUInteger)millis;

- (NSDictionary *)sendCommand:(NSString *)command;
- (NSDictionary *)sendCommand:(NSString *)command timeout:(NSUInteger)millis;
- (NSDictionary *)sendCommandWithData:(NSData *)command;
- (NSDictionary *)sendCommandWithData:(NSData *)command timeout:(NSUInteger)millis;

- (NSDictionary *)getLivePath;
- (NSDictionary *)getLivePath:(NSUInteger)millis;
- (NSDictionary *)getLivePaths;
- (NSDictionary *)getLivePaths:(NSUInteger)millis;

- (NSDictionary *)startRecord;
- (NSDictionary *)startRecord:(NSUInteger)millis;
- (NSDictionary *)stopRecord;
- (NSDictionary *)stopRecord:(NSUInteger)millis;
- (NSDictionary *)getRecordTime;
- (NSDictionary *)getRecordTime:(NSUInteger)millis;

- (NSDictionary *)takePhoto;
- (NSDictionary *)takePhoto:(NSUInteger)millis;
- (NSDictionary *)stopTakePhoto;
- (NSDictionary *)stopTakePhoto:(NSUInteger)millis;

- (NSDictionary *)getFileList:(NSString *)srcPath;
- (NSDictionary *)getFileList:(NSString *)srcPath timeout:(NSUInteger)millis;

- (NSDictionary *)sessionHolder;
- (NSDictionary *)sessionHolder:(NSUInteger)millis;

- (NSDictionary *)getSettingsList;
- (NSDictionary *)getSettingsList:(NSUInteger)millis;
- (NSDictionary *)getSetting:(NSString *)type;
- (NSDictionary *)getSetting:(NSString *)type timeout:(NSUInteger)millis;
- (NSDictionary *)getSettingOptions:(NSString *)type;
- (NSDictionary *)getSettingOptions:(NSString *)type timeout:(NSUInteger)millis;
- (NSDictionary *)setSetting:(NSString *)type param:(NSString *)param;
- (NSDictionary *)setSetting:(NSString *)type param:(NSString *)param timeout:(NSUInteger)millis;
- (NSDictionary *)setSetting:(NSString *)type param:(NSString *)param resetLive:(BOOL)resetLive;
- (NSDictionary *)setSetting:(NSString *)type param:(NSString *)param resetLive:(BOOL)resetLive timeout:(NSUInteger)millis;

- (NSDictionary *)deleteFile:(NSString *)srcPath;
- (NSDictionary *)deleteFile:(NSString *)srcPath timeout:(NSUInteger)millis;
- (NSDictionary *)getStreamingPath:(NSString *)srcPath protocol:(NSString *)protocol;
- (NSDictionary *)getStreamingPath:(NSString *)srcPath protocol:(NSString *)protocol timeout:(NSUInteger)millis;

- (void)downloadFile:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath top:(BOOL)top priority:(int)priority append:(BOOL)append;
- (void)downloadFile:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath top:(BOOL)top priority:(int)priority append:(BOOL)append timeout:(NSUInteger)millis;
- (void)stopDownloadFile:(NSString *)srcPath deleteCache:(BOOL)deleteCache;
- (void)stopDownloadFile:(NSString *)srcPath deleteCache:(BOOL)deleteCache timeout:(NSUInteger)millis;

- (void)downloadThumb:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath top:(BOOL)top priority:(int)priority;
- (void)downloadThumb:(id)userInfo destPath:(NSString *)destPath srcPath:(NSString *)srcPath top:(BOOL)top priority:(int)priority timeout:(NSUInteger)millis;
- (void)stopDownloadThumb:(NSString *)srcPath;
- (void)stopDownloadThumb:(NSString *)srcPath timeout:(NSUInteger)millis;

- (void)uploadFile:(id)userInfo srcPath:(NSString *)srcPath destPath:(NSString *)destPath top:(BOOL)top priority:(int)priority;
- (void)uploadFile:(id)userInfo srcPath:(NSString *)srcPath destPath:(NSString *)destPath top:(BOOL)top priority:(int)priority timeout:(NSUInteger)millis;
- (void)stopUploadFile:(NSString *)destPath;
- (void)stopUploadFile:(NSString *)destPath timeout:(NSUInteger)millis;

- (void)actionComplete:(FNNotification)notificationId;

- (NSString *)typeOut:(NSString *)type;
- (NSString *)paramOut:(NSString *)type param:(NSString *)param;

+ (void)logListener:(void(^)(NSString *msg))listener;

@end
