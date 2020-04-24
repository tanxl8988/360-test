//
//  FNListenerDelegate.h
//  Library_FNCamera
//
//  Created by 楊凱丞 on 2015/12/17.
//  Copyright © 2015年 Choco Yang. All rights reserved.
//

#ifndef FNListenerDelegate_h
#define FNListenerDelegate_h
#import "FNConstants.h"

@protocol FNListenerDelegate <NSObject>

- (void)onDisconnected;

- (void)onCameraUnstableAndReconnectSuccess;

- (void)onNotification:(FNNotification)notificationId otherInfo:(NSDictionary *)otherInfo;

- (void)onFileTransfer:(id)userInfo
              destPath:(NSString *)destPath
               srcPath:(NSString *)srcPath
               sizeNow:(long long)sizeNow
               sizeAll:(long long)sizeAll
              fileInfo:(NSDictionary *)fileInfo
                status:(FNDataTransferStatus)status;

- (void)onThumbTransfer:(id)userInfo
               destPath:(NSString *)destPath
                srcPath:(NSString *)srcPath
                sizeNow:(long long)sizeNow
                sizeAll:(long long)sizeAll
               fileInfo:(NSDictionary *)fileInfo
                  isIdr:(BOOL)isIdr
                 status:(FNDataTransferStatus)status;

@end

#endif /* FNListenerDelegate_h */
