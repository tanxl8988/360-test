//
//  FNPFlipFile.h
//  FNPlayerKit
//
//  Created by 林尚恩 on 2017/11/20.
//  Copyright © 2017年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNPEditorObject.h"

typedef NS_ENUM(NSUInteger, FNPFlipType) {
    FNPFlipTypeH
};

@interface FNPFlipFile : FNPEditorObject

@property(nonatomic) FNPFlipType flipType;

- (instancetype)initWithType:(FNPFlipType)type;

- (instancetype) init __attribute__((unavailable("use initWithType instead")));

@end
