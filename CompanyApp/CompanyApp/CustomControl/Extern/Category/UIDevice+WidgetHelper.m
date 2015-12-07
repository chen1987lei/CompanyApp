//
//  UIDevice+WidgetHelper.m
//  Tudou
//
//  Created by Tudou-Wangjun on 7/24/14.
//  Copyright (c) 2014 Youku.com inc. All rights reserved.
//

#import "UIDevice+WidgetHelper.h"

#import "NSString+MD5.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

NSString * const GUID_NEW_KEY = @"TudouClient_GUIDNEWKEY";

@implementation UIDevice (WidgetHelper)

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

@end
