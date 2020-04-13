//
//  FNOtusP2pInfo.h
//  Library_FNCamera
//
//  Created by Choco Yang on 2017/12/29.
//  Copyright © 2017年 Choco Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNOtusP2pInfo : NSObject

@property (nonatomic, readonly, strong) NSString *uid;
@property (nonatomic, readonly, strong) NSString *mac;
@property (nonatomic, readonly, strong) NSString *password;

- (instancetype)initWithUid:(NSString *)uid mac:(NSString *)mac;

- (instancetype)initWithUid:(NSString *)uid mac:(NSString *)mac password:(NSString *)password;

@end
