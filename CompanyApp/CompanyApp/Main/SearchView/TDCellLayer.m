//
//  TDCellLayer.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-30.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDCellLayer.h"

@implementation TDCellLayer

- (id)init
{
    self = [super init];
    if(self)
    {
        self.rasterizationScale = [[UIScreen mainScreen] scale];
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.opaque = YES;
    }
    return self;
}

@end
