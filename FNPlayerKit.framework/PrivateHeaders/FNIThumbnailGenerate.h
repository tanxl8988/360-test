//
//  FNIThumbnailGenerate.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/11/8.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FNIThumbnailGenerate : NSObject

- (BOOL) setDataSource:(NSString*) path;

- (UIImage*) thumbnail;

- (CGSize) resolution;

- (NSInteger) duratoin;

- (NSInteger) fps;

- (void) done;
@end
