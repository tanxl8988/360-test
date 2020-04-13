//
//  FNPhotoFile.h
//  FNEditorTool
//
//  Created by 施崇邑 on 2016/4/12.
//  Copyright © 2016年 funsionnext. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNPEditorObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface FNPImageFile : FNPEditorObject

@property(nonatomic, strong) NSURL *fileURL;
@property(nonatomic) CGFloat rotateDegree;
@property(nonatomic) CGPoint position;
@property(nonatomic) CGSize size;
@property(nonatomic) BOOL hidden;

- (nullable instancetype)initWithImageURL:(NSURL *)url;

- (nullable instancetype)initWithImage:(UIImage *)image;

- (instancetype) init __attribute__((unavailable("use initWithImageURL or initWithImage instead")));

@end
NS_ASSUME_NONNULL_END
