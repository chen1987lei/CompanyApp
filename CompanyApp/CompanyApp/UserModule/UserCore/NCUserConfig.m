//
//  NCUserConfig.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCUserConfig.h"

@implementation NCUserConfig

@synthesize accountName,sexValue,certCard,mobilenumber,validatecode,tmppasswd,invitecode;

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
