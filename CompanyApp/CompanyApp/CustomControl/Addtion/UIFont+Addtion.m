//
//  UIFont+Addtion.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-4.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "UIFont+Addtion.h"
#import <UIKit/UIKit.h>
#import <CoreText/CTFont.h>

@implementation UIFont (Addition)

+(id) numberFontWithSize:(float)size
{
    return [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
}
@end
