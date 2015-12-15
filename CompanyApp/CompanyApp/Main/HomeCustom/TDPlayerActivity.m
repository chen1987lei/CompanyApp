//
//  TDPlayerActivity.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-14.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDPlayerActivity.h"

@implementation TDPlayerActivity

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 41, 41)];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _bgLayer = [CALayer layer];
        [_bgLayer autoSetContentsScale];
        _bgLayer.contents = (id)Image(@"player_loading_bg").CGImage;
        _bgLayer.frame = self.bounds;
        
        _rotateLayer = [CALayer layer];
        _rotateLayer.contents = (id)Image(@"player_loading").CGImage;
        [_rotateLayer autoSetContentsScale];
        _rotateLayer.frame = self.bounds;

        [self.layer addSublayer:_bgLayer];
        [self.layer addSublayer:_rotateLayer];
    }
    return self;
}

- (void)startAnimating
{
    self.hidden = NO;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0f;
    animation.fromValue = (id)[NSNumber numberWithDouble:0];
    animation.byValue = (id)[NSNumber numberWithDouble:2*M_PI];
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_rotateLayer addAnimation:animation forKey:@"rotate"];
    
}

- (void)stopAnimating
{
   [_rotateLayer removeAllAnimations];
    if(_hidesWhenStopped)
        self.hidden = YES;
}

- (BOOL)isAnimating
{
    if([[_rotateLayer animationKeys] count] == 0)
        return NO;
    else
        return YES;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    if(![self isAnimating])
    {
        self.hidden = YES;
    }
}

@end
