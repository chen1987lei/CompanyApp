//
//  TDView.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-30.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDView.h"

@implementation TDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if([self.drawDelegate respondsToSelector:self.drawMethod])
    {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.drawDelegate methodSignatureForSelector:self.drawMethod]];
        [inv setSelector:self.drawMethod];
        [inv setTarget:self.drawDelegate];
        [inv setArgument:&rect atIndex:2];
        [inv invoke];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if([self.drawDelegate respondsToSelector:self.layoutMethod])
    {
        SuppressPerformSelectorLeakWarning([self.drawDelegate performSelector:self.layoutMethod]);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if([self.moveToWindowDelegate respondsToSelector:self.willMoveToWindowMethod])
    {
        SuppressPerformSelectorLeakWarning([self.moveToWindowDelegate performSelector:self.willMoveToWindowMethod withObject:nil]);
    }
    
}

- (void)didMoveToWindow
{
    if([self.moveToWindowDelegate respondsToSelector:self.didMoveToWindowMethod])
    {
        SuppressPerformSelectorLeakWarning([self.moveToWindowDelegate performSelector:self.didMoveToWindowMethod]);
    }
}
@end
