//
//  UIDevice+Addition.h
//  Youku
//
//  Created by Lee Peter on 2/1/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const GUID_Key;
extern NSString * const GUID_NEW_KEY;

@interface UIDevice (Addition)
- (NSString *)machine;
- (BOOL)isCameraAvailable;
- (BOOL)supportCamera;//作用等同isCameraAvailable
- (BOOL)supportPhotoLibrary;
- (BOOL)isDeviceSupportedM3U8;
- (BOOL)isDeviceVersionGE3Dot2;
- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;
- (NSString *)appVersion;
- (long long) folderSizeAtPath:(NSString*) folderPath;//计算文件夹大小 wangpengfei add

- (NSString *) UUID;
- (NSString *) GUID;

//运营商+国家代码
- (NSString *)carrier;
//获取device的网卡物理地址
- (NSString *)macAddress;
//获取自定义唯一标识 算法：md5(mac address)
- (NSString *)customIdentifier;
//获取代理地址,没有返回nil
- (NSString*)netAgent;
- (NSString *)defaultUserAgent;
@end


//---------------------------------------------------------------------------------------------
//--------------------------------UIDevice (Reachability)--------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//来源:https://github.com/erica/uidevice-extension/blob/master/UIDevice-Reachability.m
/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <UIKit/UIKit.h>
#include <netinet/in.h>

@protocol ReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end


@interface UIDevice (Reachability)
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;

- (NSString *) hostname;
- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (NSString *) localIPAddress;
- (NSString *) getLocalIPAddress;
- (NSString *) localWiFiIPAddress;
- (NSString *) whatismyipdotcom;
/**
 *  获取广告唯一标示
 *
 *  @return id
 */
- (NSString *)getIDFA;
///获取app的bundleid
- (NSString *)bundleIdentifier;
- (BOOL) hostAvailable: (NSString *) theHost;
- (BOOL) networkAvailable;
- (BOOL) activeWLAN;
- (BOOL) activeWWAN;
- (BOOL) performWiFiCheck;

- (BOOL) forceWWAN; // via Apple
- (void) shutdownWWAN; // via Apple

- (BOOL) scheduleReachabilityWatcher: (id) watcher;
- (void) unscheduleReachabilityWatcher;
//官方推荐判断系统设备的方法
NSUInteger DeviceSystemMajorVersion();
#define MY_IOS_VERSION_EQUAL_TO(v) (DeviceSystemMajorVersion() == v)
#define MY_IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v) (DeviceSystemMajorVersion() <= v)
#define MY_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v) (DeviceSystemMajorVersion() >= v)
#define MY_IOS_VERSION_7 (DeviceSystemMajorVersion() >= 7)
#define MY_IOS_VERSION_8 (DeviceSystemMajorVersion() >= 8)
@end