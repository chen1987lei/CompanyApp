//
//  UIButton+Addtion.m
//  Tudou
//
//  Created by zhang jiangshan on 13-2-5.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "UIButton+Addtion.h"

@implementation UIButton(ExclusiveTouch)

- (void)didMoveToWindow
{
    self.exclusiveTouch = YES;
}

@end
