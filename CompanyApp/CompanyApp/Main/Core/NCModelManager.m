//
//  NCModelManager.m
//  CompanyApp
//
//  Created by chenlei on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCModelManager.h"

@implementation NCModelManager
@synthesize regcertobj;

+(NCModelManager *)sharedInstance{
    static NCModelManager *analytics = nil;
    if (analytics == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            analytics = [[NCModelManager alloc] init];
        });
    }
    
    return analytics;
}

@end
