//
//  APKDVRFile.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/19.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface APKDVRFile : NSObject
@property (nonatomic,retain) NSDate *date;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSString *size;
@property (nonatomic,assign) BOOL isDownloaded;
@property (nonatomic,retain) UIImage *previewImage;
@end

NS_ASSUME_NONNULL_END
