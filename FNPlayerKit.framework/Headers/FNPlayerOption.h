//
//  FNPlayerOption.h
//  FNPlayerKit
//
//  Created by DevinLai on 2016/7/13.
//  Copyright © 2016年 DevinLai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNPlayerOption : NSObject

@property (nonatomic, getter=isVRSupport) BOOL vrSupport;
@property (nonatomic) BOOL autoPlay;    //  default YES
@property (nonatomic) BOOL liveRTSPStreaming;    //  default NO
@property (nonatomic) BOOL liveViewAutuShutDown;    //  default YES;
@property (nonatomic) BOOL tcpTransport; // default NO
@property (nonatomic) BOOL showLog; // default NO
@property (nonatomic) NSUInteger bufferBytes; // default 0
/// Default 0. If vfps less than or equal to minimumVFPS, will trigger lowVFPSMaxCount.
@property(nonatomic) float minimumVFPS;// 0
/// Default 0, value <=0 means don't check.
@property(nonatomic) NSTimeInterval checkStatusInterval;//0
/// Default 0, value <=0 means don't check. If reached lowVFPSMaxCount, will trigger drop frames.
@property(nonatomic) int lowVFPSMaxCount;//0

+ (instancetype) defaultOption;

+ (instancetype) defaultVROption;

@end

@interface FNLiveStreamingOption : NSObject

- (instancetype)initWithLiveStreamingOutput:(NSString *)output;

@property (nonatomic) BOOL micEnable; // default NO
@property (nonatomic, strong) NSString *liveStreamingOutput;

@end
