//
//  FNRemoteDiscovery.h
//  Library_FNCamera
//
//  Created by 楊凱丞 on 2016/10/19.
//  Copyright © 2016年 Choco Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNOtusP2pInfo.h"

#define DISCOVERY_KEY_IP            @"IP"
#define DISCOVERY_KEY_MAC           @"MAC"
#define DISCOVERY_KEY_SSID          @"SSID"
#define DISCOVERY_KEY_TYPE          @"TYPE"
#define DISCOVERY_KEY_MSG           @"MSG"
#define DISCOVERY_KEY_NAME          @"NAME"
#define DISCOVERY_KEY_UID           @"UID"
#define DISCOVERY_KEY_PROTOCOL      @"PROTOCOL"

#define DISCOVERY_TYPE_UNKNOWN      @"UNKNOWN"
#define DISCOVERY_TYPE_AMBA         @"AMBA"
#define DISCOVERY_TYPE_NOVATEK      @"NOVATEK"
#define DISCOVERY_TYPE_OTUS         @"OTUS"
#define DISCOVERY_TYPE_AIT          @"AIT"
#define DISCOVERY_TYPE_ICATCH       @"ICATCH"
#define DISCOVERY_TYPE_HISILICON    @"HISILICON"
#define DISCOVERY_TYPE_MULTITEK     @"MULTITEK"

#define DISCOVERY_PROTOCOL_WIFI     @"WIFI"
#define DISCOVERY_PROTOCOL_P2P      @"P2P"
#define DISCOVERY_PROTOCOL_BLE      @"BLE"

#define DEFAULT_MIN_SCAN_PERIOD     1000  // 1 sec

@class FNRemoteDiscovery;
@class FNOtusP2pInfo;

typedef NS_OPTIONS(NSUInteger, FNDiscoveryProtocol) {
    FNDiscoveryProtocolNone = 0,
    FNDiscoveryProtocolWifi = 1 << 0,
    FNDiscoveryProtocolP2p = 1 << 1,
    FNDiscoveryProtocolBle = 1 << 2
};

@protocol FNRemoteDiscoveryListener <NSObject>

/*  Callback after deviceList changed.
    deviceList is a Device object array; Device object is a NSDictionary.
    ex: {
        DISCOVERY_KEY_IP: @"ip",
        DISCOVERY_KEY_MAC: @"mac",
        DISCOVERY_KEY_SSID: @"ssid",
        DISCOVERY_KEY_TYPE: DISCOVERY_TYPE_UNKNOWN,
        DISCOVERY_KEY_MSG: @"msg"
    }
 */
- (void)didUpdateDeviceList:(NSArray *)deviceList;

@end

@protocol FNOtusP2pListener <NSObject>

- (void)didOtusP2pInfoError:(FNOtusP2pInfo *)info error:(unsigned int)error;

@end

@interface FNRemoteDiscovery : NSObject

+ (instancetype)shareInstance;

/*  Set up the scanning connection protocol, which takes effect before FNRemoteDiscoveryListener
    has been added or after all FNRemoteDiscoveryListener has been removed.
 
    discoveryProtocol Default value is FNDiscoveryProtocolWifi | FNDiscoveryProtocolP2p;
 */
- (void)setDiscoveryProtocol:(FNDiscoveryProtocol)discoveryProtocol;

/*  Scanning all devices may not be a camera.
    scanTimeout unit is millisecond.
    return Device object array; Device object is a NSDictionary.
    ex: {
        DISCOVERY_KEY_IP: @"ip",
        DISCOVERY_KEY_MAC: @"mac",
        DISCOVERY_KEY_SSID: @"ssid",
        DISCOVERY_KEY_TYPE: DISCOVERY_TYPE_UNKNOWN,
        DISCOVERY_KEY_MSG: @"msg"
    }
 */
- (NSArray *)scanAllDevice:(NSUInteger)scanTimeout;

- (void)registerListener:(id<FNRemoteDiscoveryListener>)listener;

- (void)unregisterListener:(id<FNRemoteDiscoveryListener>)listener;

/*  scanPeriod unit is millisecond.
 */
- (void)setScanPeriod:(NSUInteger)scanPeriod;

/*  If app wants to use the p2p connection, app must call startOtusP2pServer at app launch.
 */
- (void)startOtusP2pServer:(NSString *)domainName listener:(id<FNOtusP2pListener>)listener;

/*  If app wants to use the p2p connection, app must call startOtusP2pServer at app launch.
 */
- (void)startOtusP2pServers:(NSArray<NSString *> *)domainNames listener:(id<FNOtusP2pListener>)listener;

/*  If app wants to use the p2p connection, app must call stopOtusP2pServer at app terminate.
    This stopOtusP2pServer api will not clear otusP2pUids list.
 */
- (void)stopOtusP2pServer;

/*  If app wants to use the p2p connection, app can call setOtusP2pUids when needed.
 */
- (void)setOtusP2pUids:(NSArray<FNOtusP2pInfo *> *)infos;

- (id)getDeviceInfoForKey:(NSString *)key;

@end

@interface FNRemoteDiscoveryBlock : NSObject <FNRemoteDiscoveryListener>

- (instancetype)initWithBlock:(void(^)(NSArray *deviceList))block;

@end
