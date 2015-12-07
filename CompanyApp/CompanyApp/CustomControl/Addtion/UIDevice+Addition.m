//
//  UIDevice+Addition.m
//  Youku
//
//  Created by Lee Peter on 2/1/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "UIDevice+Addition.h"
#import "NSString+Addition.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <AdSupport/AdSupport.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

NSString * const GUID_Key = @"TudouClient_GUIDKEY";
NSString * const GUID_NEW_KEY = @"TudouClient_GUIDNEWKEY";


@implementation UIDevice (Addition)
//iPhone2,1 => iphone 3gs
//iPhone3,1 => iphone 4
//3rd Gen iPod == iPod3,1
- (NSString *)machine {
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithUTF8String:name];
    
    // Done with this
    free(name);
    
    return machine;
}

- (NSString *)carrier {
    if(NSClassFromString(@"CTTelephonyNetworkInfo")){
        CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        CTCarrier *carrier = [networkInfo subscriberCellularProvider];     
        if ([[carrier carrierName] length] > 0) {
            return [NSString stringWithFormat:@"%@_%@%@", [carrier carrierName], [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"", [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@""];
        }else{
            return nil;
        }
    }
    return nil;
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//文件夹下的大小
- (long long) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

- (long long)fileDirSize:(const char*)folderPath
{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || 
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) 
                                        )) continue;
        
        NSInteger folderPathLength = strlen(folderPath);
        char childPath[1024];
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR) {
            folderSize += [self fileDirSize:childPath];
            struct stat st;
            if (lstat(childPath, &st) == 0) folderSize += st.st_size;
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK) {
            struct stat st;
            if (lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)supportCamera
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:type];
	if (![sourceTypes containsObject: (NSString *)kUTTypeMovie] || ![UIImagePickerController isSourceTypeAvailable:type])
        return NO;
    else
        return YES;
    
}

- (BOOL)supportPhotoLibrary
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:type];
	if (![sourceTypes containsObject: (NSString *)kUTTypeMovie] || ![UIImagePickerController isSourceTypeAvailable:type])
        return NO;
    else
        return YES;
}
- (BOOL)isDeviceSupportedM3U8 {
    return [@"iPhone1,1|iPhone1,2|iPod1,1|iPod2,1|iPod2,2"/*|iPod3,1"*/ rangeOfString:[self machine]].location == NSNotFound;
}

- (BOOL)isDeviceVersionGE3Dot2 {
    return [[self systemVersion] floatValue] >= 3.2;
}

- (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}


- (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *freespace = [fattributes objectForKey:NSFileSystemFreeSize];
    
    long long freeval = [freespace longLongValue] - 200*1024*1024; //200M特殊空间需要减掉
    freespace =  [NSNumber numberWithLongLong:freeval];
    
    return freespace;
}

- (NSString *)UUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}

- (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *) GUID
{
    //由后台生成GUID
    NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:GUID_NEW_KEY];
    if(!result)
    {
        NSString * mac = @"";//[self macAddress];
        NSString * imei = @"";
        NSString * deviceid = [[UIDevice currentDevice] customIdentifier];
        NSString * uuid = @"";//[self UUID];
        result = [NSString stringWithFormat:@"%@&%@&%@&%@",mac,imei,deviceid,uuid];
        result = [result md5Digest];
        [[NSUserDefaults standardUserDefaults] setValue:result forKey:GUID_NEW_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return result;
}

- (NSString *)customIdentifier {
    NSString *macaddress = [self macAddress];
    return [macaddress md5Digest];
}

- (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
- (NSString*)netAgent{
    NSString * rtn = nil;
    NSDictionary *proxySettings = NSMakeCollectable([(NSDictionary *)CFNetworkCopySystemProxySettings() autorelease]);
    NSArray *proxies = NSMakeCollectable([(NSArray *)CFNetworkCopyProxiesForURL((CFURLRef)[NSURL URLWithString:@"http://www.youku.com"], (CFDictionaryRef)proxySettings) autorelease]);
    NSDictionary *settings = [proxies objectAtIndex:0];
    if (settings) {
        NSString * host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSString * port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        NSString * type = [settings objectForKey:(NSString *)kCFProxyTypeKey];
        if (host) {
            rtn = host;
        }
        DLog(@"host,port,type=%@,%@,%@",host,port,type);
    }
    return rtn;
}

- (NSString *)defaultUserAgent
{
    static NSString *userAgent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //"useragent": "Youku HD;{{device.appVersion}};{{device.systemName}};{{device.systemVersion}};{{device.machine}}",
        //"useragent": "Youku;{{device.appVersion}};{{device.systemName}};{{device.systemVersion}};{{device.machine}}",
        //应用程序名称
        NSString *appName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Tudou" : @"Tudou HD";
        //软件版本
        NSString *appVersion = [[UIDevice currentDevice] appVersion];
        //系统名称
        NSString *systemName = [[UIDevice currentDevice] systemName];
        //系统版本
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        //硬件标识
        NSString *machine = [[UIDevice currentDevice] machine];
        userAgent = [@[appName, appVersion, systemName, systemVersion, machine] componentsJoinedByString:@";"];
    });
    return [userAgent retain];
    DLog(@"%@",userAgent);
}

@end



//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <SystemConfiguration/SystemConfiguration.h>

#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <unistd.h>
#import <dlfcn.h>

#import "wwanconnect.h"

@implementation UIDevice (Reachability)
SCNetworkConnectionFlags connectionFlags;
SCNetworkReachabilityRef reachability;

#pragma mark Class IP and Host Utilities 
// This IP Utilities are mostly inspired by or derived from Apple code. Thank you Apple.

+ (NSString *) stringFromAddress: (const struct sockaddr *) address
{
	if(address && address->sa_family == AF_INET) {
		const struct sockaddr_in* sin = (struct sockaddr_in*) address;
		return [NSString stringWithFormat:@"%@:%d", [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)], ntohs(sin->sin_port)];
	}
    
	return nil;
}

+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
    
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
    
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
    
	return YES;
}

- (NSString *) hostname
{
	char baseHostName[256]; // Thanks, Gunnar Larisch
	int success = gethostname(baseHostName, 255);
	if (success != 0) return nil;
	baseHostName[255] = '\0';
	
#if TARGET_IPHONE_SIMULATOR
 	return [NSString stringWithFormat:@"%s", baseHostName];
#else
	return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

- (NSString *) localIPAddress
{
	struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}
- (NSString *)getLocalIPAddress
{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}
-(NSString *)getIDFA{
    NSString *adId=@"";
    //ios6以后开始存在
    if (MY_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(6)) {
        adId= [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }    
    return adId;
}
- (NSString *)bundleIdentifier{
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return identifier;
}
// Matt Brown's get WiFi IP addy solution
// Author gave permission to use in Cookbook under cookbook license
// http://mattbsoftware.blogspot.com/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
- (NSString *) localWiFiIPAddress
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
    
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

- (NSString *) whatismyipdotcom
{
	NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
	return ip ? ip : nil;
}

- (BOOL) hostAvailable: (NSString *) theHost
{
    
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
    
    struct sockaddr_in address;
    BOOL gotAddress = [UIDevice addressFromString:addressString address:&address];
    
    if (!gotAddress)
    {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
    
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
    
	BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;
}

#pragma mark Checking Connections

- (void) pingReachabilityInternal
{
	if (!reachability)
	{
		BOOL ignoresAdHocWiFi = NO;
		struct sockaddr_in ipAddress;
		bzero(&ipAddress, sizeof(ipAddress));
		ipAddress.sin_len = sizeof(ipAddress);
		ipAddress.sin_family = AF_INET;
		ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
        
		/* Can also create zero addy
		 struct sockaddr_in zeroAddress;
		 bzero(&zeroAddress, sizeof(zeroAddress));
		 zeroAddress.sin_len = sizeof(zeroAddress);
		 zeroAddress.sin_family = AF_INET; */
        
		reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);
		CFRetain(reachability);
	}
    
	// Recover reachability flags
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(reachability, &connectionFlags);
	if (!didRetrieveFlags) printf("Error. Could not recover network reachability flags\n");
}

- (BOOL) networkAvailable
{
	[self pingReachabilityInternal];
	BOOL isReachable = ((connectionFlags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((connectionFlags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (BOOL) activeWWAN
{
	if (![self networkAvailable]) return NO;
	return ((connectionFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
}

- (BOOL) activeWLAN
{
	return ([[UIDevice currentDevice] localWiFiIPAddress] != nil);
}




- (BOOL) performWiFiCheck
{
	if (![self networkAvailable] || ![self activeWLAN])
	{
		[self performSelector:@selector(privateShowAlert:) withObject:@"This application requires WiFi. Please enable WiFi in Settings and run this application again." afterDelay:0.5f];
		return NO;
	}
	return YES;
}

#pragma mark Forcing WWAN connection. Courtesy of Apple. Thank you Apple.
MyStreamInfoPtr	myInfoPtr;
static void myClientCallback(void *refCon)
{
	int  *val = (int*)refCon;
	printf("myClientCallback entered - value from refCon is %d\n", *val);
}

- (BOOL) forceWWAN
{
	int value = 0;
	myInfoPtr = (MyStreamInfoPtr) StartWWAN(myClientCallback, &value);
	DLog(@"%@", myInfoPtr ? @"Started WWAN" : @"Failed to start WWAN");
	return (!(myInfoPtr == NULL));
}

- (void) shutdownWWAN
{
	if (myInfoPtr) StopWWAN((MyInfoRef) myInfoPtr);
}

#pragma mark Monitoring reachability
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void* info)
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[(id)info performSelector:@selector(reachabilityChanged)];
	[pool release];
}

- (BOOL) scheduleReachabilityWatcher: (id) watcher
{
	if (![watcher conformsToProtocol:@protocol(ReachabilityWatcher)]) 
	{
		DLog(@"Watcher must conform to ReachabilityWatcher protocol. Cannot continue.");
		return NO;
	}
    
	[self pingReachabilityInternal];
    
	SCNetworkReachabilityContext context = {0, watcher, NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(reachability, ReachabilityCallback, &context)) 
	{
		if(!SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) 
		{
			DLog(@"Error: Could not schedule reachability");
			SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
			return NO;
		}
	} 
	else 
	{
		DLog(@"Error: Could not set reachability callback");
		return NO;
	}
    
	return YES;
}

- (void) unscheduleReachabilityWatcher
{
	SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
	if (SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes))
    {
		DLog(@"Unscheduled reachability");
    }
	else
    {
		DLog(@"Error: Could not unschedule reachability");
    }
    
	CFRelease(reachability);
	reachability = nil;
}
//官方推荐判断系统设备的方法
NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}
@end



