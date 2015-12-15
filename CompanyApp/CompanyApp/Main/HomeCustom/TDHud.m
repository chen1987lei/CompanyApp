//
//  TDHud.m
//  Tudou
//
//  Created by zhang jiangshan on 13-1-29.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDHud.h"

@implementation TDHud

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _activity = [[TDCommActivity alloc] init];
        [self addSubview:_activity];
    }
    return self;
}


- (void)layoutSubviews
{
    _activity.center = CGPointMake(self.width/2, self.height/2);
}

- (void)startAnimating
{
    [_activity startAnimating];
}

- (void)stopAnimating
{
    [_activity stopAnimating];
}

- (BOOL)isAnimating
{
    return [_activity isAnimating];
}
@end
