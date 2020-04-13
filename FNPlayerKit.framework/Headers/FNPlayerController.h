//
//  FNPlayerController.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/8/20.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNPlayerOption.h"
#import "FNPlayerProtocol.h"

@interface FNPlayerController : UIViewController <FNPlayerProtocol, FN360PlayerProtocol>

/* only support VR Image */
+ (id) launchAsImage:(UIImage*) image;

/* option set to nil for normal player */
+ (id) launchAsVideoPath:(NSString*) path options:(FNPlayerOption*) option;

/* option set to nil for normal player */
+ (id) launchAsVideoURL:(NSURL*) path options:(FNPlayerOption*) option;

/* will return nil if last player create by this still alive */
+ (id) launchAsVideoPath:(NSString *)path options:(FNPlayerOption *)option liveStreamingOptions:(FNLiveStreamingOption *)liveOption;

@end
