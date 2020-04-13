//
//  FNPMediaInfoManager.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/12/19.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FNP_DOWNLOADING = 0,
    FNP_DOWNLOADED = 1,
    FNP_DOWNLOAD_STOP = 2,
    FNP_DOWNLOAD_CANNOT_STOP = 3,
    FNP_DOWNLOAD_FILE_CREATE_FAIL = 4,
    FNP_DOWNLOAD_SOURCE_NOT_FOUND = 5,
    FNP_DOWNLOAD_NOT_SUPPORT = 6,
    FNP_DOWNLOAD_FAIL = 7
} FNPDataTransferStatus;

@protocol FNPMediaInfoManagerDelegate <NSObject>

- (void) onThumbGet:(id)userInfo
           destPath:(NSString *)destPath
            srcPath:(NSString *)srcPath
            sizeNow:(long long)sizeNow
            sizeAll:(long long)sizeAll
           fileInfo:(NSDictionary *)fileInfo
              isIdr:(BOOL)isIdr
             status:(FNPDataTransferStatus)status;

@end

@interface FNPMediaInfoManager : NSObject

@property (nonatomic, weak) id<FNPMediaInfoManagerDelegate> delegate;

+ (instancetype)shareInstance;

// settop to download first.
- (void)downloadTumbInfo:(id) userInfo FromPath:(NSString*) filePath toPath:(NSString*) destPath atTop:(BOOL) top;

// nil to clean all;
- (void)stopDownloadThumbFromPath:(NSString*) filePath;

@end
