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
@synthesize uid, uuid;


+(NCUserConfig *)sharedInstance;
{
    static NCUserConfig *config = nil;
    if (config == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            config = [[NCUserConfig alloc] init];
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
