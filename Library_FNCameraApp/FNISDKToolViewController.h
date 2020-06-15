//
//  FNISDKToolViewController.h
//  Library_FNCameraApp
//
//  Created by DevinLai on 2016/10/13.
//  Copyright © 2016年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ACTION_CONNECT          @"connect"
#define ACTION_SETTING_LIST     @"getSettingList"
#define ACTION_DISCONNECT       @"disconnect"
#define ACTION_START_RECORD     @"startRecord"
#define ACTION_GET_RECORD_TIME  @"getRecordTime"
#define ACTION_STOP_RECORD      @"stopRecord"
#define ACTION_TAKE_PHOTO       @"takePhoto"
#define ACTION_STOP_TAKE_PHOTO  @"stopTakePhoto"
#define ACTION_GET_FILE_LIST    @"getFileList"

typedef enum : NSUInteger {
    APKDefaultMode,
    APK180RoundMode,
    APKUltraWideMode,
    APKWholeSceneMode,
    APKBollMode,
    APK360VRMode,
    APK2in1Mode,
    APK3in1Mode,
    APK4in1Mode
} APKPreviewMode;

@import Library_FNCamera;
@import FNPlayerKit;
@interface FNISDKToolViewController : UIViewController
@property (nonatomic, strong) FNRemoteCamera *remoteCamera;
@property (nonatomic, strong) FNPlayerController *player;

@property (nonatomic,assign) BOOL isConnected;
@property (nonatomic,retain) NSString *cameraVersion;
@property (nonatomic,retain) NSString *rootPath;
@property (nonatomic,retain) NSString *playPath;
@property (nonatomic,retain) NSString *IP;
@property (nonatomic,assign) BOOL isRecord;
@property (nonatomic,assign) APKPreviewMode previewMode;
@property (nonatomic,retain) NSString *SSID;
@property (nonatomic,retain) NSString *password;
+ (instancetype)sharedInstance;
@end
