//
//  APKRemotePlayerViewController.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNISDKToolViewController.h"
#import "APKFileListViewController.h"
#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface APKRemotePlayerViewController : UIViewController
@property (nonatomic, strong) FNPlayerController *player;
@property (nonatomic, strong) FNRemoteCamera *remoteCamera;
@property (nonatomic,retain) FNISDKToolViewController *previewVC;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,assign) APKSourceType type;
@end

NS_ASSUME_NONNULL_END
