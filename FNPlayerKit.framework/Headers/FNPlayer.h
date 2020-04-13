//
//  FNPlayer.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/7/13.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNPlayerOption.h"
#import "FNPlayerProtocol.h"
#import "FNPlayerOption.h"

@import UIKit;


@interface FNPlayer : UIViewController <FNPlayerProtocol, FN360PlayerProtocol>
- (instancetype) initWithContentURL:(NSURL*)fnUrl
                        withOptions:(FNPlayerOption*)options;

- (instancetype) initWithContentURLString:(NSString*)fnUrlString
                              withOptions:(FNPlayerOption*)options;

- (instancetype) initWithContentURLString:(NSString*)fnUrlString
                              withOptions:(FNPlayerOption*)options
                  withLiveStreamingOption:(FNLiveStreamingOption *)liveOption;


//- (void) setPlayerProcessing:(BOOL) processing;

/* Not Support
 * - (CVPixelBufferRef) currentCVPixelBuffer;
 */
@end
