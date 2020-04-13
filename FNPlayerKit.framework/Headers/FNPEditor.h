//
//  FNEditorPlayer.h
//  FNEditorTool
//
//  Created by 施崇邑 on 2016/4/12.
//  Copyright © 2016年 funsionnext. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNPEditorObject.h"
//#import "FNEditObjectProtocol.h"

//@protocol FNEditorDelegate;
typedef struct FilterContext FilterContext;

@interface FNPEditor : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly) NSArray<FNPEditorObject *> *overlayObjectArray;

- (nullable instancetype)initWithFilterContext:(FilterContext *)filter_ctx;

- (void)addObject:(FNPEditorObject *)editorObject;
- (void)addObjects:(NSArray<FNPEditorObject *> *)editorObjects;
- (void)modifyObject:(FNPEditorObject *)editorObject;
- (void)removeObject:(FNPEditorObject *)editorObject;
- (void)removeAll;
- (void)testing:(NSString *)desrc;
NS_ASSUME_NONNULL_END
@end

