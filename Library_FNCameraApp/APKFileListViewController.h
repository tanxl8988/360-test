//
//  APKFileListViewController.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/17.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNISDKToolViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    APKTypeVideo,
    APKTypeImage,
    APKTypeEvent,
    APKTypeParking,
    APKTypeLocalVideo,
    APKTypeLocalEvent,
    APKTypeLocalParking,
    APKTypeLocalImage
} APKSourceType;

@interface APKFileListViewController : UITableViewController
@property (nonatomic, strong) FNRemoteCamera *remoteCamera;
@property (nonatomic, strong) FNPlayerController *player;
@property (nonatomic,retain) FNISDKToolViewController *previewVC;
@property (nonatomic,retain) NSString *rootPath;
@property (nonatomic,assign) APKSourceType type;
@property (nonatomic,retain) NSString *IP;
@end

NS_ASSUME_NONNULL_END
