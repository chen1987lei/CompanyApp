//
//  NCUserConfig.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCUserConfig.h"

@implementation NCUserConfig

@synthesize userName,sexValue,certCard,mobilenumber,validatecode,tmppasswd, secondpwd,invitecode;
@synthesize photourl,addv;
@synthesize uid, uuid;

+(BOOL)haslogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasuuid = [userDefaults stringForKey:@"useruuid"]?YES:NO;
    return hasuuid;
}

+(NCUserConfig *)sharedInstance;
{
    static NCUserConfig *config = nil;
    if (config == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            config = [[NCUserConfig alloc] init];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          
            NSString *uid = [userDefaults stringForKey:@"useruid"];
            NSString *uuid = [userDefaults stringForKey:@"useruuid"];
            config.uuid = uuid;
            config.uid = uid;
            
            
        });
    }
    
    return config;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


@end
