//
//  FNImageTransform.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/3/2.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FNImageDecoder : NSObject

+ (UIImage*) imageDecoderFromIDRSource:(NSString*) srcPath saveTo:(NSString*) dstPath deleteSource:(BOOL) needDelete;

@end
